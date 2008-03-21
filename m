From: Chris Wright <chrisw@sous-sol.org>
Subject: [patch 39/76] NETFILTER: Fix incorrect use of skb_make_writable
Date: Fri, 21 Mar 2008 15:43:29 -0700
Message-ID: <20080321224409.665063393@sous-sol.org>
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
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:59233 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763698AbYCUWue (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 21 Mar 2008 18:50:34 -0400
Content-Disposition: inline; filename=netfilter-fix-incorrect-use-of-skb_make_writable.patch
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Patrick McHardy <kaber@trash.net>

Upstream commit eb1197bc0:

http://bugzilla.kernel.org/show_bug.cgi?id=9920
The function skb_make_writable returns true or false.

Signed-off-by: Joonwoo Park <joonwpark81@gmail.com>
Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---

 net/bridge/netfilter/ebt_dnat.c     |    2 +-
 net/bridge/netfilter/ebt_redirect.c |    2 +-
 net/bridge/netfilter/ebt_snat.c     |    2 +-
 net/ipv4/netfilter/arpt_mangle.c    |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

--- a/net/bridge/netfilter/ebt_dnat.c
+++ b/net/bridge/netfilter/ebt_dnat.c
@@ -20,7 +20,7 @@ static int ebt_target_dnat(struct sk_buf
 {
 	struct ebt_nat_info *info = (struct ebt_nat_info *)data;
 
-	if (skb_make_writable(skb, 0))
+	if (!skb_make_writable(skb, 0))
 		return NF_DROP;
 
 	memcpy(eth_hdr(skb)->h_dest, info->mac, ETH_ALEN);
--- a/net/bridge/netfilter/ebt_redirect.c
+++ b/net/bridge/netfilter/ebt_redirect.c
@@ -21,7 +21,7 @@ static int ebt_target_redirect(struct sk
 {
 	struct ebt_redirect_info *info = (struct ebt_redirect_info *)data;
 
-	if (skb_make_writable(skb, 0))
+	if (!skb_make_writable(skb, 0))
 		return NF_DROP;
 
 	if (hooknr != NF_BR_BROUTING)
--- a/net/bridge/netfilter/ebt_snat.c
+++ b/net/bridge/netfilter/ebt_snat.c
@@ -22,7 +22,7 @@ static int ebt_target_snat(struct sk_buf
 {
 	struct ebt_nat_info *info = (struct ebt_nat_info *) data;
 
-	if (skb_make_writable(skb, 0))
+	if (!skb_make_writable(skb, 0))
 		return NF_DROP;
 
 	memcpy(eth_hdr(skb)->h_source, info->mac, ETH_ALEN);
--- a/net/ipv4/netfilter/arpt_mangle.c
+++ b/net/ipv4/netfilter/arpt_mangle.c
@@ -19,7 +19,7 @@ target(struct sk_buff *skb,
 	unsigned char *arpptr;
 	int pln, hln;
 
-	if (skb_make_writable(skb, skb->len))
+	if (!skb_make_writable(skb, skb->len))
 		return NF_DROP;
 
 	arp = arp_hdr(skb);

-- 
