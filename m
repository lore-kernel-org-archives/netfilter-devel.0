From: "=?iso-8859-1?Q?Jeanmich?=" <jm.cornilleau@freesbee.fr>
Subject: =?iso-8859-1?Q?question?=
Date: Wed, 21 Jan 2004 10:40:55 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <HRU2W7$64C9358E9A23239906B5624603A3F140@tiscali.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "=?iso-8859-1?Q?netfilter-devel?=" <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hello.=0D=0AI'm a french guy, so first of all, please, forgive my poor=0D=
=0Aenglish.=0D=0AI'm insteresting by netfilter just as a user.=0D=0AI've =
installed my Linux (RH9) at home as my first machine on=0D=0Ainternet, tr=
ying to secure my little network. I think it is=0D=0Aworking well.=0D=0A=0D=
=0AI would like to protect myself against syn flooding.=0D=0AObviously, i=
've looked on the web and i found 2 solutions :=0D=0A=0D=0A-1- echo 1 in =
the file /proc/sys/net/ipv4/tcp_syncookies=0D=0A-2- iptables -A FORWARD -=
p tcp --syn -m limit --limit=0D=0A1/second -J ACCEPT=0D=0A=0D=0AThis 2 so=
lutions are accepted, and both seems to work.=0D=0A=0D=0AMy problem is : =
which one is the one ?=0D=0A=0D=0AWhen i've have a look in=0D=0A/usr/scr/=
linux/Documentation/networking/ip-sysctl.txt, i=0D=0Aunderstand that it i=
s a "facility" to use -1-, and that -1-=0D=0Ais often hiding "misconfigur=
ed" servers.=0D=0ABut, http://cr.yp.to/syncookies.html seems to disagree.=
=0D=0A=0D=0AWhen i looked on the web iptables scripts, approximately 80%=0D=
=0Aare using -1- and only 20% are using -2-.=0D=0A=0D=0A=0D=0A=0D=0AThank=
s for helping me to understand.=0D=0AJMC=0A=0A********** PROTEGEZ VOS E-M=
AILS !********** =0AAvec Tiscali SuperMail, vos e-mails en toute s=E9curi=
t=E9 ! =0AAnti Spam personnalisable =0AAnti Virus actualis=E9 en permanen=
ce =0Aet de nombreux bonus... =0APour en savoir plus, rendez-vous sur htt=
p://www.tiscali.fr/supermail/=0A
