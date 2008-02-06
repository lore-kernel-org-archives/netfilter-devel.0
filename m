From: Greg KH <gregkh@suse.de>
Subject: [patch 67/73] Netfilter: bridge: fix double POST_ROUTING invocation
Date: Wed, 6 Feb 2008 15:54:26 -0800
Message-ID: <20080206235426.GP13121@suse.de>
References: <20080206234302.769849277@mini.kroah.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Justin Forbes <jmforbes@linuxtx.org>,
	Zwane Mwaikambo <zwane@arm.linux.org.uk>,
	Theodore Ts'o <tytso@mit.edu>,
	Randy Dunlap <rdunlap@xenotime.net>,
	Dave Jones <davej@redhat.com>,
	Chuck Wolber <chuckw@quantumlinux.com>,
	Chris Wedgwood <reviews@ml.cw.f00f.org>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Chuck Ebbert <cebbert@redhat.com>,
	Domenico Andreoli <cavokz@gmail.com>,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	alan@lxorguk.ukuu.org.uk,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Patrick McHardy <kaber@trash.net>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:46665 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932689AbYBGAAH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 6 Feb 2008 19:00:07 -0500
Content-Disposition: inline; filename="netfilter-bridge-fix-double-post_routing-invocation.patch"
In-Reply-To: <20080206235015.GA13121@suse.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

2.6.23-stable review patch.  If anyone has any objections, please let us know.
------------------
From: Patrick McHardy <kaber@trash.net>

[NETFILTER]: bridge: fix double POST_ROUTING invocation

Upstream commit 2948d2ebbb98747b912ac6d0c864b4d02be8a6f5

The bridge code incorrectly causes two POST_ROUTING hook invocations
for DNATed packets that end up on the same bridge device. This
happens because packets with a changed destination address are passed
to dst_output() to make them go through the neighbour output function
again to build a new destination MAC address, before they will continue
through the IP hooks simulated by bridge netfilter.

The resulting hook order is:
 PREROUTING (bridge netfilter)
 POSTROUTING        (dst_output -> ip_output)
 FORWARD    (bridge netfilter)
 POSTROUTING        (bridge netfilter)

The deferred hooks used to abort the first POST_ROUTING invocation,
but since the only thing bridge netfilter actually really wants is
a new MAC address, we can avoid going through the IP stack completely
by simply calling the neighbour output function directly.

Tested, reported and lots of data provided by: Damien Thebault <damien.thebault@gmail.com>

Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/bridge/br_netfilter.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

--- a/net/bridge/br_netfilter.c
+++ b/net/bridge/br_netfilter.c
@@ -247,8 +247,9 @@ static void __br_dnat_complain(void)
  * Let us first consider the case that ip_route_input() succeeds:
  *
  * If skb->dst->dev equals the logical bridge device the packet
- * came in on, we can consider this bridging. We then call
- * skb->dst->output() which will make the packet enter br_nf_local_out()
+ * came in on, we can consider this bridging. The packet is passed
+ * through the neighbour output function to build a new destination
+ * MAC address, which will make the packet enter br_nf_local_out()
  * not much later. In that function it is assured that the iptables
  * FORWARD chain is traversed for the packet.
  *
@@ -285,12 +286,17 @@ static int br_nf_pre_routing_finish_brid
 	skb->nf_bridge->mask ^= BRNF_NF_BRIDGE_PREROUTING;
 
 	skb->dev = bridge_parent(skb->dev);
-	if (!skb->dev)
-		kfree_skb(skb);
-	else {
+	if (skb->dev) {
+		struct dst_entry *dst = skb->dst;
+
 		nf_bridge_pull_encap_header(skb);
-		skb->dst->output(skb);
+
+		if (dst->hh)
+			return neigh_hh_output(dst->hh, skb);
+		else if (dst->neighbour)
+			return dst->neighbour->output(skb);
 	}
+	kfree_skb(skb);
 	return 0;
 }
 

-- 
