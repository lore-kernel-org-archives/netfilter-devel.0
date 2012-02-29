From: pablo@netfilter.org
Subject: [PATCH 3/7] netfilter: nf_ct_gre: add unsigned int array to define timeouts
Date: Wed, 29 Feb 2012 03:39:28 +0100
Message-ID: <1330483172-19159-4-git-send-email-pablo@netfilter.org>
References: <1330483172-19159-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44496 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966232Ab2B2Cjn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 28 Feb 2012 21:39:43 -0500
In-Reply-To: <1330483172-19159-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira Ayuso <pablo@netfilter.org>

This patch adds an array to define the default GRE timeouts.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_proto_gre.c |   16 ++++++++++++----
 1 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_gre.c b/net/netfilter/nf_conntrack_proto_gre.c
index f033879..8144f22 100644
--- a/net/netfilter/nf_conntrack_proto_gre.c
+++ b/net/netfilter/nf_conntrack_proto_gre.c
@@ -41,8 +41,16 @@
 #include <linux/netfilter/nf_conntrack_proto_gre.h>
 #include <linux/netfilter/nf_conntrack_pptp.h>
 
-#define GRE_TIMEOUT		(30 * HZ)
-#define GRE_STREAM_TIMEOUT	(180 * HZ)
+enum grep_conntrack {
+	GRE_CT_UNREPLIED,
+	GRE_CT_REPLIED,
+	GRE_CT_MAX
+};
+
+static unsigned int gre_timeouts[GRE_CT_MAX] = {
+	[GRE_CT_UNREPLIED]	= 30*HZ,
+	[GRE_CT_REPLIED]	= 180*HZ,
+};
 
 static int proto_gre_net_id __read_mostly;
 struct netns_proto_gre {
@@ -259,8 +267,8 @@ static bool gre_new(struct nf_conn *ct, const struct sk_buff *skb,
 
 	/* initialize to sane value.  Ideally a conntrack helper
 	 * (e.g. in case of pptp) is increasing them */
-	ct->proto.gre.stream_timeout = GRE_STREAM_TIMEOUT;
-	ct->proto.gre.timeout = GRE_TIMEOUT;
+	ct->proto.gre.stream_timeout = gre_timeouts[GRE_CT_REPLIED];
+	ct->proto.gre.timeout = gre_timeouts[GRE_CT_UNREPLIED];
 
 	return true;
 }
-- 
1.7.7.3

