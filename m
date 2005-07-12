From: Patrick McHardy <kaber@trash.net>
Subject: Re: REDIRECT differences in 2.6.12.2
Date: Tue, 12 Jul 2005 16:02:33 +0200
Message-ID: <42D3CD79.8070301@trash.net>
References: <42CADB0F.5010804@metaloft.com>
	<42CDD0DA.20303@trash.net>	<42CECAFB.6070709@metaloft.com>
	<42CFE495.9000904@trash.net> <42D2FA5D.6060708@metaloft.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------080108020403020308050201"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Dirk Morris <dmorris@metaloft.com>
In-Reply-To: <42D2FA5D.6060708@metaloft.com>
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

This is a multi-part message in MIME format.
--------------080108020403020308050201
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Dirk Morris wrote:
> Hey Patrick,
> 
> A bit more info:

Thanks, we already identified the responsible patch, it is
the same problem as in the SO_ORIGINAL_DST thread. This
patch should fix it.

Regards
Patrick


--------------080108020403020308050201
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

[NETFILTER]: Revert nf_reset change

Revert the nf_reset change that caused so much trouble, drop conntrack
references manually before packets are queued to packet sockets.

Signed-off-by: Phil Oester <kernel@linuxace.com>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit c64e9fafffd203886f6c57149803f1824febd9bb
tree 40a90ab1427c25f7a36109eabd1a53b0a8f144be
parent 9fd73bed06eb5cf309e0cb5cdf3249a54fd3ff22
author Phil Oester <kernel@linuxace.com> Mon, 11 Jul 2005 02:04:08
committer Patrick McHardy <kaber@trash.net> Mon, 11 Jul 2005 02:04:08

 net/ipv4/ip_output.c                         |    9 ---------
 net/ipv4/netfilter/ip_conntrack_standalone.c |    7 +++++++
 net/packet/af_packet.c                       |    6 ++++++
 3 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -107,7 +107,6 @@ static int ip_dev_loopback_xmit(struct s
 	newskb->pkt_type = PACKET_LOOPBACK;
 	newskb->ip_summed = CHECKSUM_UNNECESSARY;
 	BUG_TRAP(newskb->dst);
-	nf_reset(newskb);
 	netif_rx(newskb);
 	return 0;
 }
@@ -188,14 +187,6 @@ static inline int ip_finish_output2(stru
 		skb = skb2;
 	}
 
-#ifdef CONFIG_BRIDGE_NETFILTER
-	/* bridge-netfilter defers calling some IP hooks to the bridge layer
-	 * and still needs the conntrack reference.
-	 */
-	if (skb->nf_bridge == NULL)
-#endif
-		nf_reset(skb);
-
 	if (hh) {
 		int hh_alen;
 
diff --git a/net/ipv4/netfilter/ip_conntrack_standalone.c b/net/ipv4/netfilter/ip_conntrack_standalone.c
--- a/net/ipv4/netfilter/ip_conntrack_standalone.c
+++ b/net/ipv4/netfilter/ip_conntrack_standalone.c
@@ -432,6 +432,13 @@ static unsigned int ip_conntrack_defrag(
 				        const struct net_device *out,
 				        int (*okfn)(struct sk_buff *))
 {
+#if !defined(CONFIG_IP_NF_NAT) && !defined(CONFIG_IP_NF_NAT_MODULE)
+	/* Previously seen (loopback)?  Ignore.  Do this before
+           fragment check. */
+	if ((*pskb)->nfct)
+		return NF_ACCEPT;
+#endif
+
 	/* Gather fragments. */
 	if ((*pskb)->nh.iph->frag_off & htons(IP_MF|IP_OFFSET)) {
 		*pskb = ip_ct_gather_frags(*pskb,
diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -274,6 +274,9 @@ static int packet_rcv_spkt(struct sk_buf
 	dst_release(skb->dst);
 	skb->dst = NULL;
 
+	/* drop conntrack reference */
+	nf_reset(skb);
+
 	spkt = (struct sockaddr_pkt*)skb->cb;
 
 	skb_push(skb, skb->data-skb->mac.raw);
@@ -517,6 +520,9 @@ static int packet_rcv(struct sk_buff *sk
 	dst_release(skb->dst);
 	skb->dst = NULL;
 
+	/* drop conntrack reference */
+	nf_reset(skb);
+
 	spin_lock(&sk->sk_receive_queue.lock);
 	po->stats.tp_packets++;
 	__skb_queue_tail(&sk->sk_receive_queue, skb);

--------------080108020403020308050201--
