From: "ISLERO77@telefonica.net" <ISLERO77@telefonica.net>
Subject: Re: Easy question, how to use stdio.h
Date: Tue, 22 Apr 2003 19:27:28 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <ead0eeb154.eb154ead0e@teleline.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Markus Schaber <markus.schaber@student.uni-ulm.de>
Content-Language: es
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


Ok=2C I=27m just trying to understand how netfilter works=2C because afte=
r I would =

like to make my own match (it=27s an University task) =

So I=27m making some changes in an existent match=2C ipt=5Fmultiport=2Ec =

concretely=2E And now I was trying to load in a file the source and the d=
est =

ports of the packets=2E =

 =

If you could tell me how can I do that (in the kernel space or in the use=
r =

space=2C it=27s the same) =

 =

Thank you very much=2E =

 =

	Juan=2E =

 =

  =

----- Mensaje Original -----  =

De=3A Markus Schaber =3Cmarkus=2Eschaber=40student=2Euni-ulm=2Ede=3E  =

Fecha=3A Martes=2C Abril 22=2C 2003 7=3A05 pm  =

Asunto=3A Re=3A Easy question=2C how to use stdio=2Eh  =

  =

=3E Hallo=2C  =

=3E   =

=3E =22ISLERO77=40telefonica=2Enet=22 =3CISLERO77=40telefonica=2Enet=3E s=
chrieb=3A  =

=3E   =

=3E =3E Maybe my question is very easy=2C but I=27m new developing in Lin=
ux=2E    =

=3E =3E I=27m trying to use fopen=2C fprintf and fclose in a match=2C so =
I=27m  =

=3E =3E writting   =23include =3Cstdio=2Eh=3E    =

=3E =3E but when I compile the kernel and I do     =

=3E =3E make modules    =

=3E =3E the system doesn=27t recognize any of these functions    =

=3E =3E How can I use them=3F=3F=3F    =

=3E   =

=3E Basically=2C you can=27t=2E  =

=3E   =

=3E As matches are kernel modules=2C they run in kernel space=2E They don=
=27t   =

=3E havethe usual application infrastructure (as it is the kernel=27s   =

=3E task to  =

=3E provide the fundament of this infrastructure=2C and the libc=27s task=
 to  =

=3E provide the rest=2E)  =

=3E   =

=3E Maybe you could tell us what you want to achieve=2C so we can possibl=
y  =

=3E tell you how to do it=2E  =

=3E   =

=3E   =

=3E Gru=DF=2C  =

=3E Markus  =

=3E   =

=3E --   =

=3E Schabi=27s Flohmarkt=3A http=3A//schabi=2Ede/flohmarkt/  =

=3E   =

=3E Der Dienstweg ist die Verbindung der Sackgasse mit dem Holzweg!  =

=3E =5BDoLi in unibwm=2Estudium=5D  =

=3E   
