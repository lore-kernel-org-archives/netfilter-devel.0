From: federikkom <federikkom@yahoo.com.ar>
Subject: new match extension to implement port knocking in one rule
Date: Tue, 10 Oct 2006 20:40:21 -0700 (PDT)
Message-ID: <20061011034021.26783.qmail@web39501.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Hi everybody, we have been working in a netfilter extension to implement po=
rt knocking in a easy way. The idea is to set everything in just one iptabl=
es rule:=0A=0A=0A=0Afor instance, if you want port knocking to allow SSH co=
nnections:=0A=0A=0A=0A(1) the quick and easy way:=0A=0A=0A=0A$ iptables -A =
INPUT -m state --state NEW -m pknock --name SSH --knockports 2002,2001,2004=
 -p tcp --dport 22 -j ACCEPT=0A=0A=0A=0Aafter "knocking" ports 2002, 2001 a=
nd 2004 in sequence, you are allowed to connect to port 22.=0A=0A=0A=0AWe a=
re also working in a more secure way to "knock" using hmacs:=0A=0A=0A=0A(2)=
 the more secure way: you knock with a UDP packet, payload containing an hm=
ac (see the README.txt for more details)=0A=0A=0A=0A$ iptables -A INPUT -m =
state --state NEW -m pknock --name SSH --knockports 2000 --opensecret <your=
_opensecret> --closesecret <your_closesecret> -p udp -j DROP=0A=0A$ iptable=
s -A INPUT -m state --state NEW -m pknock --name SSH --checkip -p tcp --dpo=
rt 22 -j ACCEPT=0A=0A=0A=0A=0A=0AThe project is hosted at berlios:=0A=0A=0A=
=0Ahttp://developer.berlios.de/projects/portknocko/=0A=0A=0A=0Aand you can =
check the source code out here:=0A=0A=0A=0Asvn checkout svn://svn.berlios.d=
e/portknocko/trunk=0A=0A=0A=0Ahope you like the idea!=0A=0A=0A=0Aany feedba=
ck is welcome!=0A=0A=0A=0Aregards,=0A=0A=0A=0ALuis Aquiles Floreani and J. =
Federico Hernandez=0A=0A=0A=0A=0A=09=0A=09=0A=09=09=0A_____________________=
_____________________________=0APregunt=E1. Respond=E9. Descubr=ED.=0ATodo =
lo que quer=EDas saber, y lo que ni imaginabas,=0Aest=E1 en Yahoo! Respuest=
as (Beta).=0A=A1Probalo ya! =0Ahttp://www.yahoo.com.ar/respuestas=0A
