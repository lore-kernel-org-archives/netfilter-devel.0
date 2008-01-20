From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 2.6.24]: bridge-netfilter: fix net_device refcnt leaks
Date: Sun, 20 Jan 2008 15:19:27 +0100
Message-ID: <4793586F.10709@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------030101080300090509050608"
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: "David S. Miller" <davem@davemloft.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:58883 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752843AbYATOU2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 20 Jan 2008 09:20:28 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------030101080300090509050608
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

This patch fixes the bridge netfilter device refcounting
problems reported by Jan Christoph Nordholz. I'll also push
it to -stable once it hits upstream.


--------------030101080300090509050608
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

commit 5cd04b03b07dd30c63a3ae888f69b10b0727231b
Author: Patrick McHardy <kaber@trash.net>
Date:   Sun Jan 20 15:17:56 2008 +0100

    [NETFILTER]: bridge-netfilter: fix net_device refcnt leaks
    
    When packets are flood-forwarded to multiple output devices, the
    bridge-netfilter code reuses skb->nf_bridge for each clone to store
    the bridge port. When queueing packets using NFQUEUE netfilter takes
    a reference to skb->nf_bridge->physoutdev, which is overwritten
    when the packet is forwarded to the second port. This causes
    refcount unterflows for the first device and refcount leaks for all
    others. Additionally this provides incorrect data to the iptables
    physdev match.
    
    Unshare skb->nf_bridge by copying it if it is shared before assigning
    the physoutdev device.
    
    Reported, tested and based on initial patch by
    Jan Christoph Nordholz <hesso@pool.math.tu-berlin.de>.
    
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/net/bridge/br_netfilter.c b/net/bridge/br_netfilter.c
index 5d8b939..9f78a69 100644
--- a/net/bridge/br_netfilter.c
+++ b/net/bridge/br_netfilter.c
@@ -142,6 +142,23 @@ static inline struct nf_bridge_info *nf_bridge_alloc(struct sk_buff *skb)
 	return skb->nf_bridge;
 }
 
+static inline struct nf_bridge_info *nf_bridge_unshare(struct sk_buff *skb)
+{
+	struct nf_bridge_info *nf_bridge = skb->nf_bridge;
+
+	if (atomic_read(&nf_bridge->use) > 1) {
+		struct nf_bridge_info *tmp = nf_bridge_alloc(skb);
+
+		if (tmp) {
+			memcpy(tmp, nf_bridge, sizeof(struct nf_bridge_info));
+			atomic_set(&tmp->use, 1);
+			nf_bridge_put(nf_bridge);
+		}
+		nf_bridge = tmp;
+	}
+	return nf_bridge;
+}
+
 static inline void nf_bridge_push_encap_header(struct sk_buff *skb)
 {
 	unsigned int len = nf_bridge_encap_header_len(skb);
@@ -637,6 +654,11 @@ static unsigned int br_nf_forward_ip(unsigned int hook, struct sk_buff *skb,
 	if (!skb->nf_bridge)
 		return NF_ACCEPT;
 
+	/* Need exclusive nf_bridge_info since we might have multiple
+	 * different physoutdevs. */
+	if (!nf_bridge_unshare(skb))
+		return NF_DROP;
+
 	parent = bridge_parent(out);
 	if (!parent)
 		return NF_DROP;
@@ -718,6 +740,11 @@ static unsigned int br_nf_local_out(unsigned int hook, struct sk_buff *skb,
 	if (!skb->nf_bridge)
 		return NF_ACCEPT;
 
+	/* Need exclusive nf_bridge_info since we might have multiple
+	 * different physoutdevs. */
+	if (!nf_bridge_unshare(skb))
+		return NF_DROP;
+
 	nf_bridge = skb->nf_bridge;
 	if (!(nf_bridge->mask & BRNF_BRIDGED_DNAT))
 		return NF_ACCEPT;

--------------030101080300090509050608--
