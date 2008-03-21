From: Chris Wright <chrisw@sous-sol.org>
Subject: [patch 40/76] NETFILTER: fix ebtable targets return
Date: Fri, 21 Mar 2008 15:43:30 -0700
Message-ID: <20080321224410.380440150@sous-sol.org>
References: <20080321224250.144333319@sous-sol.org>
Cc: Justin Forbes <jmforbes@linuxtx.org>,
	Zwane Mwaikambo <zwane@arm.linux.org.uk>,
	"Theodore Ts'o" <tytso@mit.edu>,
	Randy Dunlap <rdunlap@xenotime.net>,
	Dave Jones <davej@redhat.com>,
	Chuck Wolber <chuckw@quantumlinux.com>,
	Chris Wedgwood <reviews@ml.cw.f00f.org>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Chuck Ebbert <cebbert@redhat.com>,
	Domenico Andreoli <cavokz@gmail.com>,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	alan@lxorguk.ukuu.org.uk, Patrick McHardy <kaber@trash.net>,
	netfilter-devel@vger.kernel.org, davem@davemloft.net,
	Joonwoo Park <joonwpark81@gmail.com>,
	Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:59357 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763782AbYCUWvA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 21 Mar 2008 18:51:00 -0400
Content-Disposition: inline; filename=netfilter-fix-ebtable-targets-return.patch
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Patrick McHardy <kaber@trash.net>

Upstream commit 1b04ab459:

The function ebt_do_table doesn't take NF_DROP as a verdict from the targets.

Signed-off-by: Joonwoo Park <joonwpark81@gmail.com>
Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---

 net/bridge/netfilter/ebt_dnat.c     |    2 +-
 net/bridge/netfilter/ebt_redirect.c |    2 +-
 net/bridge/netfilter/ebt_snat.c     |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

--- a/net/bridge/netfilter/ebt_dnat.c
+++ b/net/bridge/netfilter/ebt_dnat.c
@@ -21,7 +21,7 @@ static int ebt_target_dnat(struct sk_buf
 	struct ebt_nat_info *info = (struct ebt_nat_info *)data;
 
 	if (!skb_make_writable(skb, 0))
-		return NF_DROP;
+		return EBT_DROP;
 
 	memcpy(eth_hdr(skb)->h_dest, info->mac, ETH_ALEN);
 	return info->target;
--- a/net/bridge/netfilter/ebt_redirect.c
+++ b/net/bridge/netfilter/ebt_redirect.c
@@ -22,7 +22,7 @@ static int ebt_target_redirect(struct sk
 	struct ebt_redirect_info *info = (struct ebt_redirect_info *)data;
 
 	if (!skb_make_writable(skb, 0))
-		return NF_DROP;
+		return EBT_DROP;
 
 	if (hooknr != NF_BR_BROUTING)
 		memcpy(eth_hdr(skb)->h_dest,
--- a/net/bridge/netfilter/ebt_snat.c
+++ b/net/bridge/netfilter/ebt_snat.c
@@ -23,7 +23,7 @@ static int ebt_target_snat(struct sk_buf
 	struct ebt_nat_info *info = (struct ebt_nat_info *) data;
 
 	if (!skb_make_writable(skb, 0))
-		return NF_DROP;
+		return EBT_DROP;
 
 	memcpy(eth_hdr(skb)->h_source, info->mac, ETH_ALEN);
 	if (!(info->target & NAT_ARP_BIT) &&

-- 
