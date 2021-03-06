$PBExportHeader$w_pre_pag_ext.srw
$PBExportComments$Ventana de Extorno de prepagos
forward
global type w_pre_pag_ext from w_gen
end type
type dw_mov_lis from uo_dw_mant within w_pre_pag_ext
end type
type cb_cerrar from commandbutton within w_pre_pag_ext
end type
type st_fec_ini from statictext within w_pre_pag_ext
end type
type dp_fec_ini from datepicker within w_pre_pag_ext
end type
type st_deudor from statictext within w_pre_pag_ext
end type
type st_deu from statictext within w_pre_pag_ext
end type
type cb_buscar_cli from commandbutton within w_pre_pag_ext
end type
type cb_find from commandbutton within w_pre_pag_ext
end type
type st_usu from statictext within w_pre_pag_ext
end type
type dw_usu from uo_dw_mant within w_pre_pag_ext
end type
type gb_gral from groupbox within w_pre_pag_ext
end type
type cb_ext from commandbutton within w_pre_pag_ext
end type
end forward

global type w_pre_pag_ext from w_gen
integer width = 2779
integer height = 1848
string title = "Extorno de movimientos de prepagos"
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
dw_mov_lis dw_mov_lis
cb_cerrar cb_cerrar
st_fec_ini st_fec_ini
dp_fec_ini dp_fec_ini
st_deudor st_deudor
st_deu st_deu
cb_buscar_cli cb_buscar_cli
cb_find cb_find
st_usu st_usu
dw_usu dw_usu
gb_gral gb_gral
cb_ext cb_ext
end type
global w_pre_pag_ext w_pre_pag_ext

type variables
st_mov ist_mov
STRING is_cod_per = '', is_cod_usu =''

uo_cre_cre iuo_cre
uo_mov_pag iuo_pag
end variables

forward prototypes
public subroutine wf_cargar_datos ()
end prototypes

public subroutine wf_cargar_datos ();Date ld_fec_ini

ld_fec_ini = DATE(dp_fec_ini.value)
	
dw_mov_lis.retrieve(ld_fec_ini, is_cod_usu)


end subroutine

on w_pre_pag_ext.create
int iCurrent
call super::create
this.dw_mov_lis=create dw_mov_lis
this.cb_cerrar=create cb_cerrar
this.st_fec_ini=create st_fec_ini
this.dp_fec_ini=create dp_fec_ini
this.st_deudor=create st_deudor
this.st_deu=create st_deu
this.cb_buscar_cli=create cb_buscar_cli
this.cb_find=create cb_find
this.st_usu=create st_usu
this.dw_usu=create dw_usu
this.gb_gral=create gb_gral
this.cb_ext=create cb_ext
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_mov_lis
this.Control[iCurrent+2]=this.cb_cerrar
this.Control[iCurrent+3]=this.st_fec_ini
this.Control[iCurrent+4]=this.dp_fec_ini
this.Control[iCurrent+5]=this.st_deudor
this.Control[iCurrent+6]=this.st_deu
this.Control[iCurrent+7]=this.cb_buscar_cli
this.Control[iCurrent+8]=this.cb_find
this.Control[iCurrent+9]=this.st_usu
this.Control[iCurrent+10]=this.dw_usu
this.Control[iCurrent+11]=this.gb_gral
this.Control[iCurrent+12]=this.cb_ext
end on

on w_pre_pag_ext.destroy
call super::destroy
destroy(this.dw_mov_lis)
destroy(this.cb_cerrar)
destroy(this.st_fec_ini)
destroy(this.dp_fec_ini)
destroy(this.st_deudor)
destroy(this.st_deu)
destroy(this.cb_buscar_cli)
destroy(this.cb_find)
destroy(this.st_usu)
destroy(this.dw_usu)
destroy(this.gb_gral)
destroy(this.cb_ext)
end on

event open;iuo_cre = CREATE uo_cre_cre 
iuo_pag = CREATE uo_mov_pag

dw_mov_lis.settransobject( SQLCA)

dp_fec_ini.value = DATETIME(guo_gen.gd_fec_act)
is_cod_usu = guo_gen.gs_cod_usu

dw_usu.settransobject(SQLCA)
dw_usu.insertrow(0)
dw_usu.setitem( 1, 'seg_cod_usu', is_cod_usu)

wf_cargar_datos()
end event

event closequery;call super::closequery;DESTROY(iuo_cre)
DESTROY(iuo_pag) 
end event

type st_win from w_gen`st_win within w_pre_pag_ext
integer x = 2313
integer y = 0
integer height = 52
integer taborder = 10
string text = "w_pre_pag_ext"
alignment alignment = right!
end type

type dw_mov_lis from uo_dw_mant within w_pre_pag_ext
integer x = 37
integer y = 476
integer width = 2679
integer height = 1124
integer taborder = 70
boolean bringtotop = true
string dataobject = "d_pag_mov_lis_pre_pag"
borderstyle borderstyle = stylelowered!
end type

event rowfocuschanged;call super::rowfocuschanged;THIS.selectrow (0, FALSE)
THIS.selectrow (THIS.getrow (), TRUE)

end event

event ue_captura_datos;st_mov lst_aux
Time ldt

ist_mov = lst_aux

	
ist_mov.il_mov_nro_mov = dw_mov_lis.getitemnumber(THIS.getrow() , "mov_nro_mov") 	
ist_mov.is_cre_num_cre = THIS.getitemstring(THIS.getrow(), "cre_num_cre") 
ist_mov.idt_mov_fec = THIS.getitemDate(THIS.getrow(), "mov_fec") 
ist_mov.id_mov_fec_apl = guo_gen.gd_fec_act

IF THIS.getitemDate(THIS.getrow(), "mov_fec") < guo_gen.gd_fec_act THEN
	ist_mov.it_mov_hora =  THIS.getitemTime(THIS.getrow(), "mov_hora")
ELSE
	ldt = TIME (STRiNG(guo_gen.fec_act_dt( ),'hh:mm:ss'))
	ist_mov.it_mov_hora	= ldt 
END IF

ist_mov.is_mov_cod_ofi = THIS.getitemstring(THIS.getrow(), "mov_cod_ofi") 
ist_mov.ir_mov_tot_mov = THIS.getitemdecimal(THIS.getrow(), "mov_tot_mov") 
ist_mov.ir_mov_cap_cuo = THIS.getitemdecimal(THIS.getrow(), "mov_cap_cuo") 
ist_mov.ir_mov_int_cuo = THIS.getitemdecimal(THIS.getrow(), "mov_int_cuo") 
ist_mov.ir_mov_car_cuo = THIS.getitemdecimal(THIS.getrow(), "mov_car_cuo") 
ist_mov.is_mov_ext ='1'

//001:amortizacion, 002:Cancelacion
ist_mov.is_mov_ope =  THIS.getitemstring(1, "mov_ope") 
SETNULL(ist_mov.id_fec_can)

IF ist_mov.is_mov_ope = '002' THEN
	ist_mov.is_mov_ope = '001' 
END IF
end event

type cb_cerrar from commandbutton within w_pre_pag_ext
integer x = 2354
integer y = 1632
integer width = 343
integer height = 104
integer taborder = 110
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Cerrar"
boolean cancel = true
end type

event clicked;CLOSE(PARENT)
end event

type st_fec_ini from statictext within w_pre_pag_ext
integer x = 183
integer y = 116
integer width = 229
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Fecha :"
alignment alignment = right!
boolean focusrectangle = false
end type

type dp_fec_ini from datepicker within w_pre_pag_ext
integer x = 434
integer y = 104
integer width = 384
integer height = 88
integer taborder = 20
boolean bringtotop = true
boolean border = true
borderstyle borderstyle = stylelowered!
boolean enabled = false
date maxdate = Date("2999-12-31")
date mindate = Date("1800-01-01")
datetime value = DateTime(Date("2017-05-03"), Time("08:11:50.000000"))
integer textsize = -8
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
integer calendarfontweight = 400
boolean todaysection = true
boolean todaycircle = true
end type

event valuechanged;dw_mov_lis.reset( )
end event

type st_deudor from statictext within w_pre_pag_ext
integer x = 155
integer y = 332
integer width = 256
integer height = 52
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Deudor :"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_deu from statictext within w_pre_pag_ext
event key_press pbm_keydown
integer x = 434
integer y = 316
integer width = 1248
integer height = 84
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

event key_press;THIS.text =''
THIS.tag = ''
is_cod_per =''
dw_mov_lis.reset( )
end event

type cb_buscar_cli from commandbutton within w_pre_pag_ext
integer x = 1710
integer y = 316
integer width = 105
integer height = 80
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "..."
end type

event clicked;st_bus_per lst_bus_per
STRING ls_nom_alf = ''

OPENWITHPARM(w_rec_bus_alf_cli_dni, '%%%')

lst_bus_per = Message.powerobjectparm

IF NOT ISVALID(lst_bus_per) THEN
	is_cod_per = '' 
ELSE
	is_cod_per  = TRIM( lst_bus_per.is_per_cod)
	ls_nom_alf = lst_bus_per.is_per_nom_alf
	
	cb_find.triggerevent(Clicked!)
END IF

st_deu.text = ls_nom_alf 


end event

type cb_find from commandbutton within w_pre_pag_ext
integer x = 1815
integer y = 312
integer width = 343
integer height = 92
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Buscar"
end type

event clicked;wf_cargar_datos()
end event

type st_usu from statictext within w_pre_pag_ext
integer x = 155
integer y = 220
integer width = 256
integer height = 52
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Usuario :"
alignment alignment = right!
boolean focusrectangle = false
end type

type dw_usu from uo_dw_mant within w_pre_pag_ext
event key_press pbm_dwnkey
integer x = 430
integer y = 224
integer width = 942
integer height = 72
integer taborder = 40
boolean bringtotop = true
string dataobject = "d_con_ext_usu"
boolean hscrollbar = false
boolean vscrollbar = false
boolean border = false
boolean livescroll = false
end type

event key_press;STRING ls_null
SetNull(ls_null)

IF Key= KeyDelete! THEN 
	is_cod_usu = ''
	THIS.SetItem(1,"seg_cod_usu",ls_null)
	
	dw_mov_lis.reset( )
END IF 	
end event

event itemchanged;call super::itemchanged;is_cod_usu = data
dw_mov_lis.reset( )
end event

type gb_gral from groupbox within w_pre_pag_ext
integer x = 50
integer y = 20
integer width = 2656
integer height = 416
integer taborder = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
end type

type cb_ext from commandbutton within w_pre_pag_ext
integer x = 1975
integer y = 1632
integer width = 375
integer height = 104
integer taborder = 90
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Extornar"
end type

event clicked;INTEGER li_pos, li_count, li_nro_cron, li_nro_prepag
STRING ls_cod_ofi, ls_num_cre, ls_res
LONG ll_nro_mov
DATE ldt_fec
TIME ldt_hor

li_pos = dw_mov_lis.getrow( )	
IF li_pos  > 0 THEN
	//Validar que no haya movimientos superiores para este convenio-credito	
	ls_num_cre = dw_mov_lis.getitemstring(li_pos, 'cre_num_cre')
	ldt_fec = dw_mov_lis.getitemdate (li_pos, 'pre_pag_fec')
	ll_nro_mov = dw_mov_lis.getitemnumber (li_pos, 'mov_nro_mov')
	ldt_hor  = dw_mov_lis.getitemtime (li_pos, 'pre_pag_hor')
	
	IF ll_nro_mov <>0 THEN
		IF iuo_pag.existe_trans_post(ldt_fec, ll_nro_mov, ldt_hor, ls_num_cre) THEN
			MessageBox (gs_nomapl, "Debe extornar movimientos posteriores para poder extornar este movimiento." + iuo_cre.is_error , Exclamation!)
			RETURN
		END IF
	END IF
	
	//Excepciones	
	ist_sol_exc.is_sol_exc_mod = '2'
	ist_sol_exc.is_sol_exc_cod_opc ='05'	
	ist_sol_exc.is_sol_exc_clave = STRING(dw_mov_lis.getitemnumber(li_pos, 'pre_pag_cod')) + '/' +  dw_mov_lis.getitemstring(li_pos, 'cre_num_cre')  //Validamos por nro de mov y oficina
	ist_sol_exc.is_sol_exc_nombre = dw_mov_lis.getitemstring( li_pos, 'per_nom_alf')
	ist_sol_exc.is_sol_exc_num_cre = dw_mov_lis.getitemstring( li_pos, 'cre_num_cre') 
	ist_sol_exc.is_sol_exc_cod_ofi = guo_gen.gs_cod_ofi

	OPENWITHPARM(w_sol_exc, ist_sol_exc)
	ls_res = Message.stringparm
	IF ls_res = '0' OR ISNULL(ls_res) OR TRIM(ls_res) = ''  THEN RETURN	
		
	//..
	IF MessageBox(gs_nomapl, "¿Desea Extornar el movimiento selecccionado?", Question!, YesNo!, 2) = 2 THEN
		RETURN
	END IF
	
	//Procedemos a generar extorno
	ls_num_cre = dw_mov_lis.getitemstring(li_pos, 'cre_num_cre')
	li_nro_cron= dw_mov_lis.getitemnumber(li_pos, 'cre_nro_cron')
	li_nro_prepag= dw_mov_lis.getitemnumber(li_pos, 'pre_pag_cod')
	
	IF iuo_cre.extornar_pre_pagos(ls_num_cre, ist_sol_exc, li_nro_cron, li_nro_prepag) = 0 THEN
		MessageBox (gs_nomapl, "Los datos se extornaron correctamente")
		
		wf_cargar_datos()
	ELSE
		MessageBox (gs_nomapl, "Error al grabar la información.~r" + iuo_cre.is_error , Exclamation!)
	END IF		
END IF	

end event

