From: "David S. Miller" <davem@redhat.com>
Subject: Fw: PROBLEM: PATCH for 2.4.23-pre4 and up hang on one system
Date: Mon, 10 Nov 2003 23:32:25 -0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031110233225.00de7987.davem@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
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

Please have a look, thanks guys.

Begin forwarded message:

Date: Sat, 8 Nov 2003 18:27:28 -1000
From: "Beau E. Cox" <beau@beaucox.com>
To: linux-kernel@vger.kernel.org
Cc: Marcelo Tosatti <marcelo.tosatti@cyclades.com>
Subject: PROBLEM: PATCH for 2.4.23-pre4 and up hang on one system


submitted Sat Nov  8 13:08:55 HST 2003 by Beau E. Cox <beau@beaucox.com>

[1.] One line summary of the problem:

Patch that fixes my problem:
Starting with 2.4.23-pre4 my system hangs during startup and/or is
generally unstable (see patch in [ X. ] below.)

[2.] Full description of the problem/report:

Origionally I had catagorized this problem with the startup sequence;
the system always seemed to hang when squid was started before
mysql, etc. Moving squid near the end of the startup process, I
thought the problem was in hand. However, the system (pre9) proved
unstable (would not stay up for longer than one day.)

The problem exhibits itself with a solid 'hang'; no oops, no dumps,
nada.

[ 3. ] - [ 7. ]

See previous posting; no hardware or configuration changes.

[X.] Other notes, patches, fixes, workarounds:

This patch to net/ipv4/netfilter/ip_nat_core.c fixed my problem
in all 2.4.23 versions pre4 - pre9:

--- linux-2.4.23-pre4/net/ipv4/netfilter/ip_nat_core.c	2003-11-08 
03:01:59.000000000 -1000
+++ linux-2.4.23-pre3/net/ipv4/netfilter/ip_nat_core.c	2003-11-08 
03:00:47.000000000 -1000
@@ -157,8 +157,8 @@
 				continue;
 		}
 
-		if (!(mr->range[i].flags & IP_NAT_RANGE_PROTO_SPECIFIED)
-		    || proto->in_range(&newtuple, IP_NAT_MANIP_SRC,
+		if ((mr->range[i].flags & IP_NAT_RANGE_PROTO_SPECIFIED)
+		    && proto->in_range(&newtuple, IP_NAT_MANIP_SRC,
 				       &mr->range[i].min, &mr->range[i].max))
 			return 1;
 	}

It is simply a rollback of changes to ip_nat_core.c made in
pre4.

Since my patch is to ip_nat_core.c, I should mention that I use
NAT via iptables. Here is an the relevant section if my iptables
startup script:

[...]
# setup nat
echo "  applying nat rules"
echo ""
$iptables -F FORWARD
$iptables -F -t nat
$iptables -P FORWARD DROP
$iptables -A FORWARD -i eth0 -j ACCEPT
$iptables -A INPUT -i eth0 -j ACCEPT
$iptables -A OUTPUT -o eth0 -j ACCEPT
$iptables -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT
$iptables -t nat -A POSTROUTING -s 10.0.0.0/8 -o eth1 -j SNAT --to-source 
x.x.x.x
[...]

All the information I can think of relating to this problem is at:

ftp://beaucox.com/pub/kernel/2.4.23-pre4-bug

Please see the README file.

---------------------------WARNING--------------------------
I am NOT a kernel programmer. The patch above was arrived at
by hit-or-miss. I REALLY don't know what I am doing (but
my system works now!)
---------------------------WARNING--------------------------

Aloha => Beau;

PS: Please let me know if you need more information.



