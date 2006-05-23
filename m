From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 3/3]: SNMP NAT: fix memleak in snmp_object_decode
Date: Tue, 23 May 2006 11:41:53 +0200
Message-ID: <4472D8E1.5010106@trash.net>
Mime-Version: 1.0
Content-Type: text/plain;
 name="03.diff"
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
Content-Disposition: inline;
 filename="03.diff"
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

[NETFILTER]: SNMP NAT: fix memleak in snmp_object_decode

If kmalloc fails, error path leaks data allocated from asn1_oid_decode().

Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 3eb1830bb0cf13f1e9906e96b6b21d512adfbafd
tree afc2fb8b065ed275e4c5d6680858a62126b34f8b
parent e79f105111e9a6088868a879934d0574ce6230ad
author Chris Wright <chrisw@sous-sol.org> Tue, 23 May 2006 11:23:17 +0200
committer Patrick McHardy <kaber@trash.net> Tue, 23 May 2006 11:23:17 +0200

 net/ipv4/netfilter/ip_nat_snmp_basic.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/ipv4/netfilter/ip_nat_snmp_basic.c b/net/ipv4/netfilter/ip_nat_snmp_basic.c
index c622538..1017d12 100644
--- a/net/ipv4/netfilter/ip_nat_snmp_basic.c
+++ b/net/ipv4/netfilter/ip_nat_snmp_basic.c
@@ -768,6 +768,7 @@ static unsigned char snmp_object_decode(
 			len *= sizeof(unsigned long);
 			*obj = kmalloc(sizeof(struct snmp_object) + len, GFP_ATOMIC);
 			if (*obj == NULL) {
+				kfree(lp);
 				kfree(id);
 				if (net_ratelimit())
 					printk("OOM in bsalg (%d)\n", __LINE__);
