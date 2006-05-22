From: Chris Wright <chrisw@sous-sol.org>
Subject: [PATCH] Netfilter: SNMP NAT helper: fix memleak snmp_object_decode
Date: Mon, 22 May 2006 15:40:39 -0700
Message-ID: <20060522224039.GW23243@moss.sous-sol.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
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

If kmalloc fails, error path leaks data allocated from asn1_oid_decode().

Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---

 net/ipv4/netfilter/ip_nat_snmp_basic.c |    1 +
 1 file changed, 1 insertion(+)

--- linus-2.6.orig/net/ipv4/netfilter/ip_nat_snmp_basic.c
+++ linus-2.6/net/ipv4/netfilter/ip_nat_snmp_basic.c
@@ -768,6 +768,7 @@ static unsigned char snmp_object_decode(
 			len *= sizeof(unsigned long);
 			*obj = kmalloc(sizeof(struct snmp_object) + len, GFP_ATOMIC);
 			if (*obj == NULL) {
+				kfree(lp);
 				kfree(id);
 				if (net_ratelimit())
 					printk("OOM in bsalg (%d)\n", __LINE__);
