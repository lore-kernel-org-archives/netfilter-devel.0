From: Chris Wright <chrisw@sous-sol.org>
Subject: [patch 68/76] NETFILTER: nfnetlink_log: fix computation of netlink skb size
Date: Fri, 21 Mar 2008 15:43:58 -0700
Message-ID: <20080321224449.868525871@sous-sol.org>
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
	Eric Leblond <eric@inl.fr>, Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:49184 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764446AbYCUW5r (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 21 Mar 2008 18:57:47 -0400
Content-Disposition: inline; filename=netfilter-nfnetlink_log-fix-computation-of-netlink-skb-size.patch
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Eric Leblond <eric@inl.fr>

Upstream commit 7000d38d:

This patch is similar to nfnetlink_queue fixes. It fixes the computation
of skb size by using NLMSG_SPACE instead of NLMSG_ALIGN.

Signed-off-by: Eric Leblond <eric@inl.fr>
Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---

 net/netfilter/nfnetlink_log.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -594,7 +594,7 @@ nfulnl_log_packet(unsigned int pf,
 	/* FIXME: do we want to make the size calculation conditional based on
 	 * what is actually present?  way more branches and checks, but more
 	 * memory efficient... */
-	size =    NLMSG_ALIGN(sizeof(struct nfgenmsg))
+	size =    NLMSG_SPACE(sizeof(struct nfgenmsg))
 		+ nla_total_size(sizeof(struct nfulnl_msg_packet_hdr))
 		+ nla_total_size(sizeof(u_int32_t))	/* ifindex */
 		+ nla_total_size(sizeof(u_int32_t))	/* ifindex */

-- 
