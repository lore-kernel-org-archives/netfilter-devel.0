From: "Shen Rong" <rshen@udtech.com.cn>
Subject: A patch to delete items in ip_conntrack hash table
Date: Sun, 13 Jul 2003 18:05:52 +0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <096f01c34926$57c4b540$e600a8c0@udtech.net>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi,
   I write a patch to delete specified item in ip_conntrack hash
table through setsockopt. A demo program is also attached.
   Will it be ok for normal use? Is there any hidden issues on it?
Please give me any type of feedback. Thanks a lot.

BTW: Please CC to my mail box since I am not on the list. Thanks.

Shenrong


begin 666 delete_ip_conntrack.patch
M+2TM(&QI;G5X<'!C7S)?-%]D979E;"TQ+C$Q-S0O:6YC;'5D92]L:6YU>"]N
M971F:6QT97)?:7!V-"YH"5=E9"!*=6X@(#0@,38Z-3,Z,34@,C P,PHK*RL@
M;&EN=7@M,BXT+C(P+VEN8VQU9&4O;&EN=7@O;F5T9FEL=&5R7VEP=C0N: E3
M=6X@2G5L(#$S(#$U.C R.C(Q(#(P,#,*0$ @+38U+#8@*S8U+#D@0$ *("\J
M(#(N-"!F:7)E=V%L;&EN9R!W96YT(#8T('1H<F]U9V@@-C<N("HO"B C9&5F
M:6YE(%-/7T]224=)3D%,7T135" X, H@"BLC9&5F:6YE(%-/7T1%3%]#3TY.
M5%)!0TL@.# **PHK"B C:69D968@7U]+15).14Q?7PH@(VEF9&5F($-/3D9)
M1U].151&24Q415)?1$5"54<*('9O:60@;F9?9&5B=6=?:7!?;&]C86Q?9&5L
M:79E<BAS=')U8W0@<VM?8G5F9B J<VMB*3L*+2TM(&QI;G5X<'!C7S)?-%]D
M979E;"TQ+C$Q-S0O;F5T+VEP=C0O;F5T9FEL=&5R+VEP7V-O;FYT<F%C:U]C
M;W)E+F,)5V5D($IU;B @-" Q-CHU,SHS-B R,# S"BLK*R!L:6YU>"TR+C0N
M,C O;F5T+VEP=C0O;F5T9FEL=&5R+VEP7V-O;FYT<F%C:U]C;W)E+F,)4W5N
M($IU;" Q,R Q-CHS.3HP,2 R,# S"D! ("TQ,CDQ+#8@*S$R.3$L,S8@0$ *
M( E]"B!]"B **W-T871I8R!I;G0**V1E;&-O;FYT<F%C:RAS=')U8W0@<V]C
M:R J<VLL(&EN="!O<'1V86PL('9O:60@*G5S97(L('5N<VEG;F5D(&EN="!L
M96XI"BM["BL)<W1R=6-T(&EP7V-O;FYT<F%C:U]T=7!L92!T=7!L93L**PES
M=')U8W0@:7!?8V]N;G1R86-K7W1U<&QE7VAA<V@@*F@["BL)"BL):68@*"%C
M87!A8FQE*$-!4%].151?041-24XI*0HK"0ER971U<FX@+45015)-.PHK"BL)
M:68@*&]P='9A;" A/2!33U]$14Q?0T].3E1204-+*0HK"0ER971U<FX@+45)
M3E9!3#L**PHK"6EF("AL96X@(3T@<VEZ96]F*'-T<G5C="!I<%]C;VYN=')A
M8VM?='5P;&4I*0HK"0ER971U<FX@+45)3E9!3#L**PHK"6EF("AC;W!Y7V9R
M;VU?=7-E<B@F='5P;&4L('5S97(L('-I>F5O9BAS=')U8W0@:7!?8V]N;G1R
M86-K7W1U<&QE*2D@(3T@,"D**PD)<F5T=7)N("U%1D%53%0["BL**PEH(#T@
M:7!?8V]N;G1R86-K7V9I;F1?9V5T*"9T=7!L92P@3E5,3"D["BL):68@*&@I
M('L**PD):68@*&1E;%]T:6UE<B@F:"T^8W1R86-K+3YT:6UE;W5T*2D**PD)
M"61E871H7V)Y7W1I;65O=70H*'5N<VEG;F5D(&QO;F<I:"T^8W1R86-K*3L*
M*PD):7!?8V]N;G1R86-K7W!U="AH+3YC=')A8VLI.PHK"BL)"7)E='5R;B P
M.PHK"7T**PHK"7)E='5R;B M14Y/14Y4.PHK?0HK"B O*B!&87-T(&9U;F-T
M:6]N(&9O<B!T:&]S92!W:&\@9&]N)W0@=V%N="!T;R!P87)S92 O<')O8R H
M86YD($D@9&]N)W0*(" @(&)L86UE('1H96TI+B J+PH@+RH@4F5V97)S:6YG
M('1H92!S;V-K970G<R!D<W0O<W)C('!O:6YT(&]F('9I97<@9VEV97,@=7,@
M=&AE(')E<&QY"D! ("TQ,S0Q+#<@*S$S-S$L-R! 0 H@"B!S=&%T:6,@<W1R
M=6-T(&YF7W-O8VMO<'1?;W!S('-O7V=E=&]R:6=D<W0*(#T@>R![($Y53$PL
M($Y53$P@?2P@4$9?24Y%5"P*+2 @(" P+" P+"!.54Q,+" O*B!3971S;V-K
M;W!T<R J+PHK(" @(%-/7T1%3%]#3TY.5%)!0TLL(%-/7T1%3%]#3TY.5%)!
M0TLK,2P@)F1E;&-O;FYT<F%C:RP*(" @("!33U]/4DE'24Y!3%]$4U0L(%-/
M7T]224=)3D%,7T135"LQ+" F9V5T;W)I9V1S="P*(" @(" P+"!.54Q,('T[
#"B *
`
end

begin 666 del_conntrack.c
M(VEN8VQU9&4@/'-T9&EO+F@^"B-I;F-L=61E(#QE<G)N;RYH/@HC:6YC;'5D
M92 \<WES+W1Y<&5S+F@^"B-I;F-L=61E(#QS>7,O<V]C:V5T+F@^"B-I;F-L
M=61E(#QN971I;F5T+VEN+F@^"B-I;F-L=61E(#QA<G!A+VEN970N:#X*(VEN
M8VQU9&4@/&QI;G5X+W1Y<&5S+F@^"B-I;F-L=61E(#QL:6YU>"]N971F:6QT
M97)?:7!V-"YH/@HC:6YC;'5D92 \;&EN=7@O;F5T9FEL=&5R7VEP=C0O:7!?
M8V]N;G1R86-K7W1U<&QE+F@^"@H*(VEF;F1E9B!33U]$14Q?0T].3E1204-+
M"B-D969I;F4@4T]?1$5,7T-/3DY44D%#2PDX, HC96YD:68*"@II;G0@9&5L
M7V-O;FYT<F%C:RA?7W4Q-B!P<F]T;RP@7U]U,S(@<V%D9'(L(%]?=3$V('-P
M;W)T+"!?7W4S,B!D861D<BP@7U]U,38@9'!O<G0I"GL*"7-T<G5C="!I<%]C
M;VYN=')A8VM?='5P;&4@='5P;&4["@EI;G0@<RP@<CL*"@ES(#T@<V]C:V5T
M*%!&7TE.150L(%-/0TM?4U1214%-+"!)4%!23U1/7TE0*3L*"6EF("AS(#P@
M,"D*"0ER971U<FX@+3$["@D*"71U<&QE+G-R8RYI<" ]('-A9&1R.PH)='5P
M;&4N<W)C+G4N86QL(#T@<W!O<G0["@ET=7!L92YD<W0N:7 @/2!D861D<CL*
M"71U<&QE+F1S="YU+F%L;" ](&1P;W)T.PH)='5P;&4N9'-T+G!R;W1O;G5M
M(#T@<')O=&\["@D*"7(@/2!S971S;V-K;W!T*',L(%-/3%])4"P@4T]?1$5,
M7T-/3DY44D%#2RP@)G1U<&QE+"!S:7IE;V8H<W1R=6-T(&EP7V-O;FYT<F%C
M:U]T=7!L92DI.PH*"6-L;W-E*',I.PH)<F5T=7)N('(["GT*"FEN="!M86EN
M*&EN="!A<F=C+"!C:&%R("HJ87)G=BD*>PH)7U]U,S(@<V%D9'(L(&1A9&1R
M.PH)7U]U,38@<W!O<G0L(&1P;W)T+"!P<F]T;SL*"0H):68@*&%R9V,@(3T@
M-BD*"0EG;W1O('5S86=E.PH*"6EF("@A<W1R8V%S96-M<"AA<F=V6S%=+" B
M=&-P(BDI"@D)<')O=&\@/2!)4%!23U1/7U1#4#L*"65L<V4@:68@*"%S=')C
M87-E8VUP*&%R9W9;,5TL(")U9' B*2D*"0EP<F]T;R ]($E04%)/5$]?5410
M.PH)96QS90H)"6=O=&\@=7-A9V4["@D*"6EF*"%I;F5T7V%T;VXH87)G=ELR
M72P@*'-T<G5C="!I;E]A9&1R("HI)G-A9&1R*2D*"0EG;W1O('5S86=E.PH*
M"7-P;W)T(#T@871O:2AA<F=V6S-=*3L*"6EF*'-P;W)T(#P](# @?'P@<W!O
M<G0@/CT@-C4U,S4I"@D)9V]T;R!U<V%G93L*"@EI9B@A:6YE=%]A=&]N*&%R
M9W9;-%TL("AS=')U8W0@:6Y?861D<B J*29D861D<BDI"@D)9V]T;R!U<V%G
M93L*"@ED<&]R=" ](&%T;VDH87)G=ELU72D["@EI9BAD<&]R=" \/2 P("!\
M?"!D<&]R=" ^/2 V-34S-2D*"0EG;W1O('5S86=E.PH*"7)E='5R;B!D96Q?
M8V]N;G1R86-K*'!R;W1O+"!S861D<BP@<W!O<G0L(&1A9&1R+"!D<&]R="D[
M"@IU<V%G93H*"7!R:6YT9B@B57-A9V4Z("5S(%MT8W!\=61P72!S;W5R8V4M
M:7 @<V]U<F-E+7!O<G0@9&5S="UI<"!D97-T+7!O<G1<;B(L( H)(" @(" @
C(&)A<V5N86UE*&%R9W9;,%TI*3L*"7)E='5R;B M,3L*?0H`
`
end
