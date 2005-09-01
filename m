From: Udo van den Heuvel <udovdh@xs4all.nl>
Subject: 2.6.13 (-git2) and h323-conntrack-nat -> error
Date: Thu, 01 Sep 2005 16:21:40 +0200
Message-ID: <43170E74.5040908@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
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

Hello,

Sinds 2.6.13 (git2 now) I get this problem wehn trying to build a kerlen
with patch-o-matic h323-conntrack-nat applied:

net/ipv4/netfilter/ip_conntrack_h323_h225.c: In function
=E2h225_parse_connect_uuie=E2:
net/ipv4/netfilter/ip_conntrack_h323_h225.c:111: error: too few
arguments to function =E2ip_conntrack_expect_alloc=E2
net/ipv4/netfilter/ip_conntrack_h323_h225.c:135: warning: implicit
declaration of function =E2ip_conntrack_expect_free=E2
make[3]: *** [net/ipv4/netfilter/ip_conntrack_h323_h225.o] Error 1
make[2]: *** [net/ipv4/netfilter] Error 2
make[1]: *** [net/ipv4] Error 2
make: *** [net] Error 2

Is this known?
How could I fix this?

Kind regards,
Udo
