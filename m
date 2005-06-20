From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 7/7]: Check TCP checksum in ipt_REJECT
Date: Tue, 21 Jun 2005 01:04:27 +0200
Message-ID: <42B74B7B.2030301@trash.net>
Mime-Version: 1.0
Content-Type: text/x-patch;
 name="07.diff"
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
Content-Disposition: inline;
 filename="07.diff"
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

[NETFILTER]: Check TCP checksum in ipt_REJECT

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit d7edb3501fc521edf0d856d30fd6bad8019ed369
tree 44f3b9cbb38d0be5f40c676ed87dcdf3346213cc
parent f324916223389c944e50fa8b2c514bacf3f460c5
author Patrick McHardy <kaber@trash.net> Mon, 20 Jun 2005 18:56:16
committer Patrick McHardy <kaber@trash.net> Mon, 20 Jun 2005 18:56:16

 net/ipv4/netfilter/ipt_REJECT.c |   13 ++++++++++++-
 1 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/net/ipv4/netfilter/ipt_REJECT.c b/net/ipv4/netfilter/ipt_REJECT.c
--- a/net/ipv4/netfilter/ipt_REJECT.c
+++ b/net/ipv4/netfilter/ipt_REJECT.c
@@ -104,10 +104,12 @@ static inline struct rtable *route_rever
 static void send_reset(struct sk_buff *oldskb, int hook)
 {
 	struct sk_buff *nskb;
+	struct iphdr *iph = oldskb->nh.iph;
 	struct tcphdr _otcph, *oth, *tcph;
 	struct rtable *rt;
 	u_int16_t tmp_port;
 	u_int32_t tmp_addr;
+	unsigned int tcplen;
 	int needs_ack;
 	int hh_len;
 
@@ -124,7 +126,16 @@ static void send_reset(struct sk_buff *o
 	if (oth->rst)
 		return;
 
-	/* FIXME: Check checksum --RR */
+	/* Check checksum */
+	tcplen = oldskb->len - iph->ihl * 4;
+	if (((hook != NF_IP_LOCAL_IN && oldskb->ip_summed != CHECKSUM_HW) ||
+	     (hook == NF_IP_LOCAL_IN &&
+	      oldskb->ip_summed != CHECKSUM_UNNECESSARY)) &&
+	    csum_tcpudp_magic(iph->saddr, iph->daddr, tcplen, IPPROTO_TCP,
+	                      oldskb->ip_summed == CHECKSUM_HW ? oldskb->csum :
+	                      skb_checksum(oldskb, iph->ihl * 4, tcplen, 0)))
+		return;
+
 	if ((rt = route_reverse(oldskb, oth, hook)) == NULL)
 		return;
 
