From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 2/2]: Fix recent match jiffies wrap mismatches
Date: Thu, 01 Dec 2005 12:06:18 +0100
Message-ID: <20051201110618.8700.1299.sendpatchset@localhost.localdomain>
References: <20051201110617.8700.16237.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20051201110617.8700.16237.sendpatchset@localhost.localdomain>
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

[NETFILTER]: Fix recent match jiffies wrap mismatches

Around jiffies wrap time (i.e. within first 5 mins after boot), recent
match rules which contain both --seconds and --hitcount arguments
experience false matches.

This is because the last_pkts array is filled with zeros on creation, and
when comparing 'now' to 0 (+ --seconds argument), time_before_eq thinks it
has found a hit.

Below patch adds a break if the packet value is zero.  This has the
unfortunate side effect of causing mismatches if a packet was received
when jiffies really was equal to zero.  The odds of that happening are
slim compared to the problems caused by not adding the break however.
Plus, the author used this same method just below, so it is "good enough".

This fixes netfilter bugs #383 and #395.

Signed-off-by: Phil Oester <kernel@linuxace.com>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit fb344289abd5a78a1ac7f295353d2dc4aa739bf3
tree eb5bacd9963fc9ed44ef9976bc507cffb180fb0d
parent 28fbc43b64e0982cdb775afb2055f4c02fd6c41a
author Phil Oester <kernel@linuxace.com> Wed, 30 Nov 2005 00:05:21 +0100
committer Patrick McHardy <kaber@trash.net> Wed, 30 Nov 2005 00:05:21 +0100

 net/ipv4/netfilter/ipt_recent.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/ipv4/netfilter/ipt_recent.c b/net/ipv4/netfilter/ipt_recent.c
index 2d44b07..261cbb4 100644
--- a/net/ipv4/netfilter/ipt_recent.c
+++ b/net/ipv4/netfilter/ipt_recent.c
@@ -532,6 +532,7 @@ match(const struct sk_buff *skb,
 			}
 			if(info->seconds && info->hit_count) {
 				for(pkt_count = 0, hits_found = 0; pkt_count < ip_pkt_list_tot; pkt_count++) {
+					if(r_list[location].last_pkts[pkt_count] == 0) break;
 					if(time_before_eq(now,r_list[location].last_pkts[pkt_count]+info->seconds*HZ)) hits_found++;
 				}
 				if(hits_found >= info->hit_count) ans = !info->invert; else ans = info->invert;
