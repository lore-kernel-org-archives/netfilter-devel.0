From: Jesper Dangaard Brouer <brouer@redhat.com>
Subject: [PATCH V4 3/7] ipvs: Use config macro IS_ENABLED()
Date: Wed, 26 Sep 2012 14:06:20 +0200
Message-ID: <20120926120616.24804.45927.stgit@dragon>
References: <20120926120534.24804.78415.stgit@dragon>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Jesper Dangaard Brouer <brouer@redhat.com>,
	"Patrick McHardy" <kaber@trash.net>, Thomas Graf <tgraf@suug.ch>,
	Wensong Zhang <wensong@linux-vs.org>,
	netfilter-devel@vger.kernel.org, Simon Horman <horms@verge.net.au>
To: Hans Schillstrom <hans@schillstrom.com>,
	Hans Schillstrom <hans.schillstrom@ericsson.com>,
	netdev@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
	lvs-devel@vger.kernel.org, Julian Anastasov <ja@ssi.bg>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53379 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754942Ab2IZL6k (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 Sep 2012 07:58:40 -0400
In-Reply-To: <20120926120534.24804.78415.stgit@dragon>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Cleanup patch.

Use the IS_ENABLED macro, instead of having to check
both the build and the module CONFIG_ option.

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---

 include/net/ip_vs.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/net/ip_vs.h b/include/net/ip_vs.h
index aba0bb2..c8b2bdb 100644
--- a/include/net/ip_vs.h
+++ b/include/net/ip_vs.h
@@ -22,7 +22,7 @@
 #include <linux/ip.h>
 #include <linux/ipv6.h>			/* for struct ipv6hdr */
 #include <net/ipv6.h>
-#if defined(CONFIG_NF_CONNTRACK) || defined(CONFIG_NF_CONNTRACK_MODULE)
+#if IS_ENABLED(CONFIG_NF_CONNTRACK)
 #include <net/netfilter/nf_conntrack.h>
 #endif
 #include <net/net_namespace.h>		/* Netw namespace */

