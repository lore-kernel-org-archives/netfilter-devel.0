From: "Evan Langlois" <evan@ddos.com>
Subject: Re: TProxy w/2.6
Date: Tue, 22 Jun 2004 14:11:58 -0500 (CDT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <56384.68.92.26.41.1087931518.squirrel@mercury.ddos.com>
References: <54933.68.92.26.41.1087835494.squirrel@mercury.ddos.com>
    <20040621170452.GA6797@sch.bme.hu>
Reply-To: evan@ddos.com
Mime-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
In-Reply-To: <20040621170452.GA6797@sch.bme.hu>
To: "KOVACS Krisztian" <hidden@balabit.hu>
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

>   The patches on our homepage were created for 2.6.6 with Jozsef
> Kadlecsik's TCP window tracking patch applied. The one in POM-ng should
> apply on 2.6.6 (and probably fail on others). BTW, applying window
> tracking onto 2.6.7 has failed for me, so applying TProxy will fail as
> well.

tcp-window-tracking from pom applied to vanilla 2.6.6 - cttproxy patches
from web site fails.  cttproxy applied to vanilla 2.6.6 fails.  I tried
using other versions of the window tracking patch, they failed.

>   You can somewhat lower these requirements by skipping 04-nat_delete,
> since that is a rarely-used optional part, and it is the only part of t=
he
> patches which requires the TCP window tracking code. I've just re-check=
ed
> that the patches contained in our tarball apply without rejects on vani=
lla
> 2.6.6.

tcp-window-tracking applies fine.

the tproxt in pom never works.  The cttproxy package does not apply to
2.6.6 even with tcp-window-tracking applied to a vanilla 2.6.6 kernel.=20
Are you using a vanilla kernel from kernel.org, or a kernel from some
distribution that may have modified the original sources?

Note the very large number of failures!  This is against a vanilla 2.6.6
kernel with the latest tcp-window-tracking patch from POMng applied (whic=
h
applied cleanly).

Now what?

linux # cat ../cttproxy-2.6.6-1.9.6/patch_tree/0* | patch -p1 --dry-run
patching file include/linux/netfilter_ipv4/ip_conntrack.h
Hunk #2 succeeded at 256 with fuzz 1 (offset -5 lines).
patching file include/linux/netfilter_ipv4/ip_nat.h
patching file net/ipv4/netfilter/ip_conntrack_core.c
Hunk #3 succeeded at 952 (offset -1 lines).
patching file net/ipv4/netfilter/ip_conntrack_standalone.c
Hunk #1 succeeded at 651 (offset -45 lines).
patching file net/ipv4/netfilter/ip_nat_core.c
patching file net/ipv4/netfilter/ip_nat_proto_icmp.c
patching file net/ipv4/netfilter/ip_nat_proto_tcp.c
patching file net/ipv4/netfilter/ip_nat_proto_udp.c
patching file net/ipv4/netfilter/ip_nat_standalone.c
patching file net/ipv4/netfilter/Kconfig
patching file net/ipv4/netfilter/ip_nat_standalone.c
Hunk #1 FAILED at 392.
1 out of 1 hunk FAILED -- saving rejects to file
net/ipv4/netfilter/ip_nat_standalone.c.rej
patching file include/linux/in.h
patching file include/linux/net.h
patching file include/linux/netfilter_ipv4/ip_conntrack.h
Hunk #2 succeeded at 212 (offset -5 lines).
Hunk #3 FAILED at 268.
1 out of 3 hunks FAILED -- saving rejects to file
include/linux/netfilter_ipv4/ip_conntrack.h.rej

<<stuff deleted for space>>

patching file net/ipv4/netfilter/ip_nat_standalone.c
Hunk #1 FAILED at 398.
1 out of 1 hunk FAILED -- saving rejects to file
net/ipv4/netfilter/ip_nat_standalone.c.rej

<<stuff deleted for space>>

patching file net/ipv4/netfilter/ip_nat_core.c
Hunk #1 succeeded at 96 (offset -19 lines).
Hunk #2 FAILED at 272.
Hunk #3 FAILED at 308.
Hunk #4 FAILED at 368.
Hunk #5 FAILED at 545.
Hunk #6 succeeded at 189 with fuzz 2 (offset -389 lines).
4 out of 6 hunks FAILED -- saving rejects to file
net/ipv4/netfilter/ip_nat_core.c.rej
patching file net/ipv4/netfilter/ip_conntrack_proto_tcp.c
Hunk #1 FAILED at 856.
1 out of 1 hunk FAILED -- saving rejects to file
net/ipv4/netfilter/ip_conntrack_proto_tcp.c.rej
patching file net/ipv4/netfilter/ip_conntrack_standalone.c
Hunk #1 succeeded at 656 (offset -49 lines).
patching file include/linux/netfilter_ipv4/ip_conntrack.h
Hunk #1 FAILED at 54.
Hunk #2 succeeded at 224 (offset -17 lines).
Hunk #3 succeeded at 251 with fuzz 1 (offset -17 lines).
1 out of 3 hunks FAILED -- saving rejects to file
include/linux/netfilter_ipv4/ip_conntrack.h.rej
