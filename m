From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 15/64]: x_tables: enable compat translation for IPv6 matches/targets
Date: Tue, 18 Dec 2007 00:46:33 +0100 (MET)
Message-ID: <20071217234633.23601.42131.sendpatchset@localhost.localdomain>
References: <20071217234612.23601.6979.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:38924 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932438AbXLQXqe (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Dec 2007 18:46:34 -0500
In-Reply-To: <20071217234612.23601.6979.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: x_tables: enable compat translation for IPv6 matches/targets

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit ec56030835b00ac701a64db9b979edcae05c98b0
tree ca41368de9f7505d7f2ac435f88d32168a5ee1af
parent 8a27d7d8dbfa0a27714e8b05d3c51786ebdb42e7
author Patrick McHardy <kaber@trash.net> Mon, 17 Dec 2007 14:57:53 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 18 Dec 2007 00:24:53 +0100

 net/netfilter/xt_CONNMARK.c |    5 +++++
 net/netfilter/xt_connmark.c |    5 +++++
 net/netfilter/xt_limit.c    |    5 +++++
 net/netfilter/xt_mark.c     |    5 +++++
 4 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/net/netfilter/xt_CONNMARK.c b/net/netfilter/xt_CONNMARK.c
index 0250bbe..d96ee3e 100644
--- a/net/netfilter/xt_CONNMARK.c
+++ b/net/netfilter/xt_CONNMARK.c
@@ -160,6 +160,11 @@ static struct xt_target connmark_tg_reg[] __read_mostly = {
 		.destroy	= connmark_tg_destroy,
 		.target		= connmark_tg,
 		.targetsize	= sizeof(struct xt_connmark_target_info),
+#ifdef CONFIG_COMPAT
+		.compatsize	= sizeof(struct compat_xt_connmark_target_info),
+		.compat_from_user = connmark_tg_compat_from_user,
+		.compat_to_user	= connmark_tg_compat_to_user,
+#endif
 		.me		= THIS_MODULE
 	},
 };
diff --git a/net/netfilter/xt_connmark.c b/net/netfilter/xt_connmark.c
index 7e0874a..b5c0f2f 100644
--- a/net/netfilter/xt_connmark.c
+++ b/net/netfilter/xt_connmark.c
@@ -126,6 +126,11 @@ static struct xt_match connmark_mt_reg[] __read_mostly = {
 		.match		= connmark_mt,
 		.destroy	= connmark_mt_destroy,
 		.matchsize	= sizeof(struct xt_connmark_info),
+#ifdef CONFIG_COMPAT
+		.compatsize	= sizeof(struct compat_xt_connmark_info),
+		.compat_from_user = connmark_mt_compat_from_user,
+		.compat_to_user	= connmark_mt_compat_to_user,
+#endif
 		.me		= THIS_MODULE
 	},
 };
diff --git a/net/netfilter/xt_limit.c b/net/netfilter/xt_limit.c
index c9352db..2ef0dbf 100644
--- a/net/netfilter/xt_limit.c
+++ b/net/netfilter/xt_limit.c
@@ -187,6 +187,11 @@ static struct xt_match limit_mt_reg[] __read_mostly = {
 		.checkentry	= limit_mt_check,
 		.match		= limit_mt,
 		.matchsize	= sizeof(struct xt_rateinfo),
+#ifdef CONFIG_COMPAT
+		.compatsize	= sizeof(struct compat_xt_rateinfo),
+		.compat_from_user = limit_mt_compat_from_user,
+		.compat_to_user	= limit_mt_compat_to_user,
+#endif
 		.me		= THIS_MODULE,
 	},
 };
diff --git a/net/netfilter/xt_mark.c b/net/netfilter/xt_mark.c
index 650cdea..ce8735e 100644
--- a/net/netfilter/xt_mark.c
+++ b/net/netfilter/xt_mark.c
@@ -94,6 +94,11 @@ static struct xt_match mark_mt_reg[] __read_mostly = {
 		.checkentry	= mark_mt_check,
 		.match		= mark_mt,
 		.matchsize	= sizeof(struct xt_mark_info),
+#ifdef CONFIG_COMPAT
+		.compatsize	= sizeof(struct compat_xt_mark_info),
+		.compat_from_user = mark_mt_compat_from_user,
+		.compat_to_user	= mark_mt_compat_to_user,
+#endif
 		.me		= THIS_MODULE,
 	},
 };
