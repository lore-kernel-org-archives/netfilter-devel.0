From: =?iso-8859-2?q?Micha=B3_Margula?= <alchemyx@uznam.net.pl>
Subject: Connlimit
Date: Wed, 25 Feb 2004 15:33:36 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200402251533.36904.alchemyx@uznam.net.pl>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

Hello!

	Using latest patch-o-matic and 2.4.25 i have following problem when 'make=
=20
modules':

ipt_connlimit.c: In function `init':
ipt_connlimit.c:219: `ip_conntrack_module' undeclared (first use in this=20
function)
ipt_connlimit.c:219: (Each undeclared identifier is reported only once
ipt_connlimit.c:219: for each function it appears in.)
ipt_connlimit.c:220: warning: value computed is not used
ipt_connlimit.c: In function `fini':
ipt_connlimit.c:227: `ip_conntrack_module' undeclared (first use in this=20
function)
ipt_connlimit.c:228: warning: value computed is not used
make[2]: *** [ipt_connlimit.o] Error 1
make[2]: Leaving directory `/usr/src/linux-2.4.25/net/ipv4/netfilter'
make[1]: *** [_modsubdir_ipv4/netfilter] Error 2
make[1]: Leaving directory `/usr/src/linux-2.4.25/net'
make: *** [_mod_net] Error 2

It is caused when I choose connlimit as a module. Whats wrong?

=2D-=20
Micha=B3 Margula, alchemyx@uznam.net.pl, http://alchemyx.uznam.net.pl/
"W =BFyciu pi=EAkne s=B1 tylko chwile" [Ryszard Riedel]
