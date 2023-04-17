import Web3 from "web3"; //Importo o pacote de comunicação de carteira
import ABI from "./ABI.json";

const CONTRACT_ADDRESS = "0x05fe1860789B01b92448A7fd9d28E91a5b92Da43";

export async function doLogin() { //Crio a função do Login
  if (!window.ethereum) throw new Error('No MataMask found!'); //Verifica se o usuário possui MetaMask no navegador
//Quando há wallet no navegador, ela joga um objeto ethereum no window, se não encontra retorna um Error
  const web3 = new Web3(window.ethereum); //Cria um objeto web3 a partir da função contrutora Web3 com o objeto da carteira que está no window.
  const accounts = await web3.eth.requestAccounts(); //atribuo a accounts um array contendo as carteiras da metaMask.
  //uso await pq é uma chamada de API e pq quero que ele só vá para a linha de baixo quando terminar de executar requestAccounts().
  //Se eu uso o await na função ela obrigatoriamente tem que ser async
  if(!accounts || !accounts.length) throw new Error("Wallet not found/allowed."); //Verifico se o requestAccounts() retornou alguma carteira, ou seja, se o usuário permitiu linkar a carteira.
  localStorage.setItem("wallet", accounts[0]);
  //Se não tiver accounts ou se accounts for um array vazio lança erro.
  return accounts[0]; //retorno a primeira carteira do array.
}

function getContract() {
  const web3 = new Web3(window.ethereum);
  const from = localStorage.getItem("wallet");
  return new web3.eth.Contract(ABI, CONTRACT_ADDRESS, { from });
}

export async function addCampaign(campaign) {
  const contract = getContract();
  return contract.methods.addCampaign(campaign.title, campaign.description, campaign.videoUrl, campaign.imageUrl).send();
}

export function getLastCampaignId() {
  const contract = getContract();
  return contract.methods.nextId().call();
}

export function getCampaign(id) {
  const contract = getContract();
  return contract.methods.campaigns(id).call();
}

export function donate(id, donation) {
  const contract = getContract();
  return contract.methods.donate(id).send({ value: Web3.utils.toWei(donation, 'ether') });
}
