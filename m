From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 16/64]: xt_MARK: support revision 1 for IPv6
Date: Tue, 18 Dec 2007 00:46:34 +0100 (MET)
Message-ID: <20071217234634.23601.99263.sendpatchset@localhost.localdomain>
References: <20071217234612.23601.6979.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:38927 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932651AbXLQXqf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Dec 2007 18:46:35 -0500
In-Reply-To: <20071217234612.23601.6979.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: xt_MARK: support revision 1 for IPv6

The current netfilter SVN version includes support for this, so enable
it in the kernel as well.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit e0b1699a604d191d46470fa8af7f211cd905bd78
tree 05cd8924da71e9e73ac17e45af7cb2df464bf266
parent ec56030835b00ac701a64db9b979edcae05c98b0
author Patrick McHardy <kaber@trash.net> Mon, 17 Dec 2007 14:57:54 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 18 Dec 2007 00:24:53 +0100

 net/netfilter/xt_MARK.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/net/netfilter/xt_MARK.c b/net/netfilter/xt_MARK.c
index de32aa5..5bf9121 100644
--- a/net/netfilter/xt_MARK.c
+++ b/net/netfilter/xt_MARK.c
@@ -158,6 +158,21 @@ static struct xt_target mark_tg_reg[] __read_mostly = {
 		.table		= "mangle",
 		.me		= THIS_MODULE,
 	},
+	{
+		.name		= "MARK",
+		.family		= AF_INET6,
+		.revision	= 1,
+		.checkentry	= mark_tg_check,
+		.target		= mark_tg,
+		.targetsize	= sizeof(struct xt_mark_target_info_v1),
+#ifdef CONFIG_COMPAT
+		.compatsize	= sizeof(struct compat_xt_mark_target_info_v1),
+		.compat_from_user = mark_tg_compat_from_user,
+		.compat_to_user	= mark_tg_compat_to_user,
+#endif
+		.table		= "mangle",
+		.me		= THIS_MODULE,
+	},
 };
 
 static int __init mark_tg_init(void)
