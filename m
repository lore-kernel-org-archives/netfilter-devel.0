From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 03/06]: SNMP NAT: fix byteorder confusion
Date: Tue, 25 Jul 2006 05:26:57 +0200 (MEST)
Message-ID: <20060725032657.25063.16874.sendpatchset@localhost.localdomain>
References: <20060725032653.25063.8139.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20060725032653.25063.8139.sendpatchset@localhost.localdomain>
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

[NETFILTER]: SNMP NAT: fix byteorder confusion

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 91ce3a69f0154c527da6e4a47c8784383981a222
tree c72655288441f9148a03ed2a3a42ed0c6706fa51
parent 4aed24265c0b6270d328362ff66b51fed56a9d1a
author Patrick McHardy <kaber@trash.net> Tue, 25 Jul 2006 00:05:13 +0200
committer Patrick McHardy <kaber@trash.net> Tue, 25 Jul 2006 00:05:13 +0200

 net/ipv4/netfilter/ip_nat_snmp_basic.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/netfilter/ip_nat_snmp_basic.c b/net/ipv4/netfilter/ip_nat_snmp_basic.c
index 0b1b416..18b7fbd 100644
--- a/net/ipv4/netfilter/ip_nat_snmp_basic.c
+++ b/net/ipv4/netfilter/ip_nat_snmp_basic.c
@@ -1255,9 +1255,9 @@ static int help(struct sk_buff **pskb,
 	struct udphdr *udph = (struct udphdr *)((u_int32_t *)iph + iph->ihl);
 
 	/* SNMP replies and originating SNMP traps get mangled */
-	if (udph->source == ntohs(SNMP_PORT) && dir != IP_CT_DIR_REPLY)
+	if (udph->source == htons(SNMP_PORT) && dir != IP_CT_DIR_REPLY)
 		return NF_ACCEPT;
-	if (udph->dest == ntohs(SNMP_TRAP_PORT) && dir != IP_CT_DIR_ORIGINAL)
+	if (udph->dest == htons(SNMP_TRAP_PORT) && dir != IP_CT_DIR_ORIGINAL)
 		return NF_ACCEPT;
 
 	/* No NAT? */
