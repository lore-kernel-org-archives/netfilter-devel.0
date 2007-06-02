From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: [PATCH] xt_gateway match
Date: Sat, 2 Jun 2007 18:56:15 +0200 (MEST)
Message-ID: <Pine.LNX.4.61.0706021337370.21057@yvahk01.tjqt.qr>
References: <46604D8B.7030507@ufomechanic.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
To: Amin Azez <azez@ufomechanic.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <46604D8B.7030507@ufomechanic.net>
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


On Jun 1 2007 17:47, Amin Azez wrote:
>
>This adds a gateway match to iptables that lets you match against the
>routed ipv4 gateway, it's very useful for SNAT if you want to avoid
>replicating your routing in your SNAT table.
>
>e.g.
>
>iptables -t nat -A POSTROUTING -m gateway --nexthop 172.16.1.1 -j SNAT
>--to-address 172.16.1.5
>iptables -t nat -A POSTROUTING -m gateway --nexthop 192.168.1.1 -j SNAT
>--to-address 192.168.1.25
>
>The .gateway-test doesn't work for me because I don't build into my
>kernel source dir, but I tried to do it right for a public release.

(Neither do I, just run `KERNEL_DIR=/ws/linux-2.6.22-rc3 make` in the
iptables directory.)

+               info->flags ^= info->flags & IPT_GATEWAY_ROUTE;                 

Stunning line.

So, I refreshed this to be xtables-style, xt_gateway. It builds cleanly,
but only done limited testing on it yet. Especially, I decoupled that
bigass return statement to make it easier to read. I hope I got all the
conditions right.

How things look:
 inet 192.168.222.36/24
 default gw 192.168.222.1

What I did:
 iptables -A OUTPUT -m gateway --gateway 192.168.222.1
 iptables -A OUTPUT -m gateway --nexthop 192.168.222.1
 ping -c1 192.168.222.1
 iptables -nvL
    +1 for the --gateway rule
    +1 for the --nexthop rule
 ping -c1 134.76.13.21
    +1 for the --gateway rule
    +0 for the --nexthop rule

Route to 134.76.13.21 is:
   (192.168.222.36)
    192.168.222.1
    10.10.96.1
    134.76.63.254
    134.76.13.21

Does xt_gateway still do the right thing? Please check, thanks!

(patches as a response to this mail,
or svnized for now @ 
https://dev.computergmbh.de/svn/misc_kernel/xt_gateway/trunk/ )


	Jan
-- 
