From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER -stable 02/02]: bridge-netfilter: fix net_device refcnt
 leaks
Date: Tue, 29 Jan 2008 19:08:28 +0100
Message-ID: <479F6B9C.6000101@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000603080504000504010701"
Cc: "David S. Miller" <davem@davemloft.net>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: stable@kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:60994 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760624AbYA2SId (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Jan 2008 13:08:33 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------000603080504000504010701
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit


--------------000603080504000504010701
Content-Type: text/x-patch;
 name="02.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="02.diff"

commit 6738b41be08760572a3fd013c57b4554de0080f5
Author: Patrick McHardy <kaber@trash.net>
Date:   Tue Jan 29 19:02:59 2008 +0100

    [NETFILTER]: bridge-netfilter: fix net_device refcnt leaks
    
    Upstream commit 2dc2f207fb251666d2396fe1a69272b307ecc333
    
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
    Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/net/bridge/br_netfilter.c b/net/bridge/br_netfilter.c
index ce48d8c..22545bd 100644
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
@@ -644,6 +661,11 @@ static unsigned int br_nf_forward_ip(unsigned int hook, struct sk_buff **pskb,
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
@@ -727,6 +749,11 @@ static unsigned int br_nf_local_out(unsigned int hook, struct sk_buff **pskb,
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

--------------000603080504000504010701--
