package model.bo;

import java.util.ArrayList;

import model.dao.DespesaDAO;
import model.vo.DespesaVO;

public class DespesaBO {

	public void cadastrarDespesaBO(DespesaVO despesaVO) {
		DespesaDAO despesaDAO = new DespesaDAO();
		
		if(despesaDAO.existeRegistroPorIdDespesa(despesaVO.getId())){
			System.out.println("\n Já existe uma despesa para esse usuário. ");
		}else {
			int resultado = despesaDAO.cadastrarDespesaDAO(despesaVO);
			
			if(resultado == 1) {
				System.out.println("\n Despesa cadastrado com sucesso");
			}else {	
				System.out.println("\n Não possível cadastrar a despesa");
			}
		}			
	}

	public void excluirDespesaBO(DespesaVO despesaVO) {
		DespesaDAO despesaDAO = new DespesaDAO();
		

		if(despesaDAO.existeRegistroPorIdDespesa(despesaVO.getId())){
			
			int resultado = despesaDAO.excluirDespesaDAO(despesaVO);
			
			if(resultado == 1) {
				System.out.println("Despesa excluido com suscesso");
			}else {
				System.out.println("Não foi possível excluir a despesa");
			}
		
		}else {
			System.out.println("\n Despesa não existe na base de dados");
		}
	}

	public void atualizarDespesaBO(DespesaVO despesaVO) {
		
		DespesaDAO despesaDAO = new DespesaDAO();
		

		if(despesaDAO.existeRegistroPorIdDespesa(despesaVO.getId())){
			
			int resultado = despesaDAO.atualizarDespesaDAO(despesaVO);
			
			if(resultado == 1) {
				System.out.println("Despesa atualizada com suscesso");
			}else {
				System.out.println("Não foi possível atualizar a despesa");
			}
		
		}else {
			System.out.println("\n Despesa não existe na base de dados");
		}
	}

	public ArrayList<DespesaVO> consultarTodasDespesaSBO() {
		DespesaDAO despesaDAO = new DespesaDAO();
		ArrayList<DespesaVO> listaDespesasVO = despesaDAO.consultarTodasDespesasDAO();
		
		if(listaDespesasVO.isEmpty()) {
			System.out.println("\nLista de Despesas está vazia.");
		}
		
		return listaDespesasVO;
	}
	
	public DespesaVO consultarDespesaBO(DespesaVO despesaVO) {
		DespesaDAO despesaDAO = new DespesaDAO();

		DespesaVO despesa = despesaDAO.consultarDespesaDAO(despesaVO);
		
		if(despesa == null) {
			System.out.println("\nDespesa não localizada");
		}
		
		return despesa;
		
	}
	
	
}
