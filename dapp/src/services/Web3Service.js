import Web3 from "web3"; //Importo o pacote de comunicação de carteira

export async function doLogin() { //Crio a função do Login
  if (!window.ethereum) throw new Error('No MataMask found!'); //Verifica se o usuário possui MetaMask no navegador
//Quando há wallet no navegador, ela joga um objeto ethereum no window, se não encontra retorna um Error
  const web3 = new Web3(window.ethereum); //Cria um objeto web3 a partir da função contrutora Web3 com o objeto da carteira que está no window.
  const accounts = await web3.eth.requestAccounts(); //atribuo a accounts um array contendo as carteiras da metaMask.
  //uso await pq é uma chamada de API e pq quero que ele só vá para a linha de baixo quando terminar de executar requestAccounts().
  //Se eu uso o await na função ela obrigatoriamente tem que ser async
  if(!accounts || !accounts.length) throw new Error("Wallet not found/allowed."); //Verifico se o requestAccounts() retornou alguma carteira, ou seja, se o usuário permitiu linkar a carteira.
  //Se não tiver accounts ou se accounts for um array vazio lança erro.
  return accounts[0]; //retorno a primeira carteira do array.
}