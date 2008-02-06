From: <gregkh@suse.de>
Subject: patch netfilter-bridge-netfilter-fix-net_device-refcnt-leaks.patch queued to -stable tree
Date: Wed, 06 Feb 2008 15:28:38 -0800
Message-ID: <20080206233021.4FCEE1454459@imap.suse.de>
References: <479F6B9C.6000101@trash.net>
Cc: <stable@kernel.org>, <stable-commits@vger.kernel.org>
To: kaber@trash.net, davem@davemloft.net, gregkh@suse.de,
	hesso@pool.math.tu-berlin.de, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57714 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759057AbYBFXaX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 6 Feb 2008 18:30:23 -0500
In-Reply-To: <479F6B9C.6000101@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


This is a note to let you know that we have just queued up the patch titled

     Subject: Netfilter: bridge-netfilter: fix net_device refcnt leaks

to the 2.6.23-stable tree.  Its filename is

     netfilter-bridge-netfilter-fix-net_device-refcnt-leaks.patch

A git repo of this tree can be found at 
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary


>From stable-bounces@linux.kernel.org Tue Jan 29 10:09:08 2008
From: Patrick McHardy <kaber@trash.net>
Date: Tue, 29 Jan 2008 19:08:28 +0100
Subject: Netfilter: bridge-netfilter: fix net_device refcnt leaks
To: stable@kernel.org
Cc: Netfilter Development Mailinglist <netfilter-devel@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>
Message-ID: <479F6B9C.6000101@trash.net>


From: Patrick McHardy <kaber@trash.net>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/bridge/br_netfilter.c |   27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

--- a/net/bridge/br_netfilter.c
+++ b/net/bridge/br_netfilter.c
@@ -142,6 +142,23 @@ static inline struct nf_bridge_info *nf_
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
@@ -644,6 +661,11 @@ static unsigned int br_nf_forward_ip(uns
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
@@ -727,6 +749,11 @@ static unsigned int br_nf_local_out(unsi
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


Patches currently in stable-queue which might be from kaber@trash.net are

queue-2.6.23/netfilter-bridge-fix-double-post_routing-invocation.patch
queue-2.6.23/netfilter-bridge-netfilter-fix-net_device-refcnt-leaks.patch
