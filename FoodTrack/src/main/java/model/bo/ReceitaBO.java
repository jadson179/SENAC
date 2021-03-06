package model.bo;

import java.util.ArrayList;

import model.dao.ReceitaDAO;
import model.vo.ReceitaVO;

public class ReceitaBO {

	public void cadastraReceita(ReceitaVO receitaVO) {
		ReceitaDAO receitaDAO = new ReceitaDAO();
		
		if(receitaDAO.existeRegistroPorIdReceita(receitaVO.getId())){
			System.out.println("\n Já existe uma receita para esse usuário. ");
		}else {
			int resultado = receitaDAO.cadastrarReceitaDAO(receitaVO);
			if(resultado == 1) {
				System.out.println("\n Receita cadastrada com sucesso");
			}else {	
				System.out.println("\n Não possível cadastrar a receita");
			}
		}
		
	}

	public void excluirReceita(ReceitaVO receitaVO) {
		ReceitaDAO receitaDAO = new ReceitaDAO();
		
		if(receitaDAO.existeRegistroPorIdReceita(receitaVO.getId())){
			
			int resultado = receitaDAO.excluirDespesaDAO(receitaVO);
			
			if(resultado == 1) {
				System.out.println("Receita excluida com suscesso");
			}else {
				System.out.println("Não foi possível excluir a receita");
			}
		
		}else {
			System.out.println("\n Receita não existe na base de dados");
		}
	}

	public void atualizarReceita(ReceitaVO receitaVO) {
		ReceitaDAO receitaDAO = new ReceitaDAO();
		
		if(receitaDAO.existeRegistroPorIdReceita(receitaVO.getId())){
			
			int resultado = receitaDAO.atualizarDespesaDAO(receitaVO);
			
			if(resultado == 1) {
				System.out.println("Receita atualizada com suscesso");
			}else {
				System.out.println("Não foi possível atualizar a receita");
			}
		
		}else {
			System.out.println("\n Receita não existe na base de dados");
		}
	}

	public ArrayList<ReceitaVO> consultarTodasReceitaBO() {
		ReceitaDAO receitaDAO = new ReceitaDAO();
		ArrayList<ReceitaVO> listaReceitasVO = receitaDAO.consultarTodasDespesasDAO();
		
		if(listaReceitasVO.isEmpty()) {
			System.out.println("\nLista de Receitas está vazia.");
		}
		
		return listaReceitasVO;
	}

	public ReceitaVO consultarReceitaBO(ReceitaVO receitaVO) {
		ReceitaDAO receitaDAO = new ReceitaDAO();

		ReceitaVO receita = receitaDAO.consultarReceitaDAO(receitaVO);
		
		if(receita == null) {
			System.out.println("\nReceita não localizada");
		}
		
		return receita;
	
	}

}
