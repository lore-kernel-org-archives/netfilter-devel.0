From: =?iso-8859-2?q?Micha=B3=20Margula?= <alchemyx@uznam.net.pl>
Subject: ip_conntrack
Date: Tue, 4 Mar 2003 01:07:28 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200303040107.28400.alchemyx@uznam.net.pl>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter-devel <netfilter-devel@lists.netfilter.org>
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

Still not having time to try ctnetlink so currently another problem to so=
lve.
Number of ip_conntrack entries varies from 40 000 to about 120 000. I get=
=20
messages:

ip_conntrack: table full, dropping packet.

I understand source of problems and solution.

Doing

echo 256000 > /proc/net/ip_conntrack

Does not help.

--=20
Micha=B3 Margula, alchemyx@uznam.net.pl, http://alchemyx.uznam.net.pl/ +)
"W =BFyciu pi=EAkne s=B1 tylko chwile" [Ryszard Riedel]
