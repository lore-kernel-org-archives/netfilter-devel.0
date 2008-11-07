From: Greg KH <gregkh@suse.de>
Subject: [patch 14/16] netfilter: xt_iprange: fix range inversion match
Date: Fri, 7 Nov 2008 15:26:26 -0800
Message-ID: <20081107232626.GO4282@kroah.com>
References: <20081107231848.995297975@mini.kroah.org>
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
	Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
	Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
	Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	alan@lxorguk.ukuu.org.uk, netfilter-devel@vger.kernel.org,
	Patrick McHardy <kaber@trash.net>, davem@davemloft.net,
	Alexey Dobriyan <adobriyan@gmail.com>,
	Jan Engelhardt <jengelh@medozas.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:47647 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754857AbYKGX1A (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 7 Nov 2008 18:27:00 -0500
Content-Disposition: inline; filename="netfilter-xt_iprange-fix-range-inversion-match.patch"
In-Reply-To: <20081107232544.GA4282@kroah.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


2.6.25-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alexey Dobriyan <adobriyan@gmail.com>

netfilter: xt_iprange: fix range inversion match

Upstream commit 6def1eb48:

Inverted IPv4 v1 and IPv6 v0 matches don't match anything since 2.6.25-rc1!

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Acked-by: Jan Engelhardt <jengelh@medozas.de>
Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/netfilter/xt_iprange.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/net/netfilter/xt_iprange.c
+++ b/net/netfilter/xt_iprange.c
@@ -67,7 +67,7 @@ iprange_mt4(const struct sk_buff *skb, c
 	if (info->flags & IPRANGE_SRC) {
 		m  = ntohl(iph->saddr) < ntohl(info->src_min.ip);
 		m |= ntohl(iph->saddr) > ntohl(info->src_max.ip);
-		m ^= info->flags & IPRANGE_SRC_INV;
+		m ^= !!(info->flags & IPRANGE_SRC_INV);
 		if (m) {
 			pr_debug("src IP " NIPQUAD_FMT " NOT in range %s"
 			         NIPQUAD_FMT "-" NIPQUAD_FMT "\n",
@@ -81,7 +81,7 @@ iprange_mt4(const struct sk_buff *skb, c
 	if (info->flags & IPRANGE_DST) {
 		m  = ntohl(iph->daddr) < ntohl(info->dst_min.ip);
 		m |= ntohl(iph->daddr) > ntohl(info->dst_max.ip);
-		m ^= info->flags & IPRANGE_DST_INV;
+		m ^= !!(info->flags & IPRANGE_DST_INV);
 		if (m) {
 			pr_debug("dst IP " NIPQUAD_FMT " NOT in range %s"
 			         NIPQUAD_FMT "-" NIPQUAD_FMT "\n",
@@ -123,14 +123,14 @@ iprange_mt6(const struct sk_buff *skb, c
 	if (info->flags & IPRANGE_SRC) {
 		m  = iprange_ipv6_sub(&iph->saddr, &info->src_min.in6) < 0;
 		m |= iprange_ipv6_sub(&iph->saddr, &info->src_max.in6) > 0;
-		m ^= info->flags & IPRANGE_SRC_INV;
+		m ^= !!(info->flags & IPRANGE_SRC_INV);
 		if (m)
 			return false;
 	}
 	if (info->flags & IPRANGE_DST) {
 		m  = iprange_ipv6_sub(&iph->daddr, &info->dst_min.in6) < 0;
 		m |= iprange_ipv6_sub(&iph->daddr, &info->dst_max.in6) > 0;
-		m ^= info->flags & IPRANGE_DST_INV;
+		m ^= !!(info->flags & IPRANGE_DST_INV);
 		if (m)
 			return false;
 	}

-- 
