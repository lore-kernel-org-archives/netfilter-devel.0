From: Michal Margula <alchemyx@uznam.net.pl>
Subject: runme
Date: Tue, 6 Jan 2004 15:17:22 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.58L.0401061514080.17738@gandalf.uznam.net.pl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=X-UNKNOWN
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hello!

=09Yesterday I was fighting with patch-o-matic. It was complaining=20
about "bad substitution" at some line. After few minutes of googling, i=20
found out that runme is bash-based shell. So it requires bash to run. OK,=
=20
fine. But in header it has #!/bin/sh and it shouldn't. Some distribution=20
(PLD for example) use other shells like pdksh for /bin/sh.=20

Solution is simple - changing #!/bin/sh into #!/bin/bash and everything=20
should be fine. I don't know if I should to report it at=20
bugs.netfilter.org or maybe someone can commit a change to CVS?

Thanks.

--=20
Micha=B3 Margula, alchemyx@uznam.net.pl, http://alchemyx.uznam.net.pl/ +)
"W =BFyciu pi=EAkne s=B1 tylko chwile" [Ryszard Riedel]
