Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E48EC433F5
	for <netfilter-devel@archiver.kernel.org>; Thu,  6 Oct 2022 00:28:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229665AbiJFA2i (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 5 Oct 2022 20:28:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229800AbiJFA23 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 5 Oct 2022 20:28:29 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64C958285A
        for <netfilter-devel@vger.kernel.org>; Wed,  5 Oct 2022 17:28:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=yuBX3A0b4KYo/PcsjSO+moN/c1bXf6e6qkCTMcB2wMo=; b=c2rWSua8lXV00C0JS7Wiea/J7E
        4TtKxgKkcXgYeG1VS8UQQ0ryOc2jAW05qdTMq1KjhnZltsmJCisHYgekwRoPseo5stXpd92Kgzqsm
        G/PcRk1+VwgBWtkR6AHQTItAXyjHqXGHrmUn9qj+Brs6uahAdoZ42mEwOuI1w8SeUQ0M4wkbr80kQ
        L5tKS1s8/YoCGZyyWSBLFrgDf0YISS0SDjAAytFLV+9AgFuKAYcYbcuhJhjo7tDC+cmVKXrmnfoiK
        VdQW+yDkPwL1ZFq+smDobbMMqjaQdz4xRyfIWKgn96hrMU/1RONd9q03ilRT1J1m9DGslDd1IDe+A
        atUAj+Uw==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1ogEkF-0001wP-9v; Thu, 06 Oct 2022 02:28:11 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jan Engelhardt <jengelh@inai.de>
Subject: [iptables PATCH 11/12] extensions: Do not print all-one's netmasks
Date:   Thu,  6 Oct 2022 02:28:01 +0200
Message-Id: <20221006002802.4917-12-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221006002802.4917-1-phil@nwl.cc>
References: <20221006002802.4917-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

All one's netmasks are a trivial default, no point in printing them.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libip6t_NETMAP.c  |  2 +-
 extensions/libipt_NETMAP.c   |  2 +-
 extensions/libxt_CONNMARK.c  | 32 +++++++++++++++++--------
 extensions/libxt_CONNMARK.t  |  4 ++--
 extensions/libxt_MARK.c      |  4 +++-
 extensions/libxt_connlimit.c |  8 +++++--
 extensions/libxt_connlimit.t |  8 +++----
 extensions/libxt_recent.c    | 45 ++++++++++++++++++++----------------
 extensions/libxt_recent.t    | 12 +++++-----
 9 files changed, 70 insertions(+), 47 deletions(-)

diff --git a/extensions/libip6t_NETMAP.c b/extensions/libip6t_NETMAP.c
index 579ed04ef0058..996c4059d3f11 100644
--- a/extensions/libip6t_NETMAP.c
+++ b/extensions/libip6t_NETMAP.c
@@ -64,7 +64,7 @@ static void __NETMAP_print(const void *ip, const struct xt_entry_target *target,
 	bits = xtables_ip6mask_to_cidr(&a);
 	if (bits < 0)
 		printf("/%s", xtables_ip6addr_to_numeric(&a));
-	else
+	else if (bits < sizeof(a) * 8)
 		printf("/%d", bits);
 }
 
diff --git a/extensions/libipt_NETMAP.c b/extensions/libipt_NETMAP.c
index f30615a357821..208d831009667 100644
--- a/extensions/libipt_NETMAP.c
+++ b/extensions/libipt_NETMAP.c
@@ -76,7 +76,7 @@ static void __NETMAP_print(const void *ip, const struct xt_entry_target *target,
 	bits = netmask2bits(a.s_addr);
 	if (bits < 0)
 		printf("/%s", xtables_ipaddr_to_numeric(&a));
-	else
+	else if (bits < sizeof(a) * 8)
 		printf("/%d", bits);
 }
 
diff --git a/extensions/libxt_CONNMARK.c b/extensions/libxt_CONNMARK.c
index 21e1091386294..4fa88854f7fd6 100644
--- a/extensions/libxt_CONNMARK.c
+++ b/extensions/libxt_CONNMARK.c
@@ -496,6 +496,12 @@ static void CONNMARK_init(struct xt_entry_target *t)
 	markinfo->mask = 0xffffffffUL;
 }
 
+static void print_mask_v1(const char *pfx, __u32 mask)
+{
+	if (mask != UINT32_MAX)
+		printf("%s0x%x", pfx, mask);
+}
+
 static void
 connmark_tg_save(const void *ip, const struct xt_entry_target *target)
 {
@@ -503,15 +509,18 @@ connmark_tg_save(const void *ip, const struct xt_entry_target *target)
 
 	switch (info->mode) {
 	case XT_CONNMARK_SET:
-		printf(" --set-xmark 0x%x/0x%x", info->ctmark, info->ctmask);
+		printf(" --set-xmark 0x%x", info->ctmark);
+		print_mask_v1("/", info->ctmask);
 		break;
 	case XT_CONNMARK_SAVE:
-		printf(" --save-mark --nfmask 0x%x --ctmask 0x%x",
-		       info->nfmask, info->ctmask);
+		printf(" --save-mark");
+		print_mask_v1(" --nfmask ", info->nfmask);
+		print_mask_v1(" --ctmask ", info->ctmask);
 		break;
 	case XT_CONNMARK_RESTORE:
-		printf(" --restore-mark --nfmask 0x%x --ctmask 0x%x",
-		       info->nfmask, info->ctmask);
+		printf(" --restore-mark");
+		print_mask_v1(" --nfmask ", info->nfmask);
+		print_mask_v1(" --ctmask ", info->ctmask);
 		break;
 	default:
 		printf(" ERROR: UNKNOWN CONNMARK MODE");
@@ -527,15 +536,18 @@ connmark_tg_save_v2(const void *ip, const struct xt_entry_target *target)
 
 	switch (info->mode) {
 	case XT_CONNMARK_SET:
-		printf(" --set-xmark 0x%x/0x%x", info->ctmark, info->ctmask);
+		printf(" --set-xmark 0x%x", info->ctmark);
+		print_mask_v1("/", info->ctmask);
 		break;
 	case XT_CONNMARK_SAVE:
-		printf(" --save-mark --nfmask 0x%x --ctmask 0x%x",
-		       info->nfmask, info->ctmask);
+		printf(" --save-mark");
+		print_mask_v1(" --nfmask ", info->nfmask);
+		print_mask_v1(" --ctmask ", info->ctmask);
 		break;
 	case XT_CONNMARK_RESTORE:
-		printf(" --restore-mark --nfmask 0x%x --ctmask 0x%x",
-		       info->nfmask, info->ctmask);
+		printf(" --restore-mark");
+		print_mask_v1(" --nfmask ", info->nfmask);
+		print_mask_v1(" --ctmask ", info->ctmask);
 		break;
 	default:
 		printf(" ERROR: UNKNOWN CONNMARK MODE");
diff --git a/extensions/libxt_CONNMARK.t b/extensions/libxt_CONNMARK.t
index 79a838fefaa14..1783f7a447195 100644
--- a/extensions/libxt_CONNMARK.t
+++ b/extensions/libxt_CONNMARK.t
@@ -2,6 +2,6 @@
 *mangle
 -j CONNMARK --restore-mark;=;OK
 -j CONNMARK --save-mark;=;OK
--j CONNMARK --save-mark --nfmask 0xfffffff --ctmask 0xffffffff;-j CONNMARK --save-mark;OK
--j CONNMARK --restore-mark --nfmask 0xfffffff --ctmask 0xffffffff;-j CONNMARK --restore-mark;OK
+-j CONNMARK --save-mark --nfmask 0xffffffff --ctmask 0xffffffff;-j CONNMARK --save-mark;OK
+-j CONNMARK --restore-mark --nfmask 0xffffffff --ctmask 0xffffffff;-j CONNMARK --restore-mark;OK
 -j CONNMARK;;FAIL
diff --git a/extensions/libxt_MARK.c b/extensions/libxt_MARK.c
index 1536563d0f4c7..36355f6645fbe 100644
--- a/extensions/libxt_MARK.c
+++ b/extensions/libxt_MARK.c
@@ -242,7 +242,9 @@ static void mark_tg_save(const void *ip, const struct xt_entry_target *target)
 {
 	const struct xt_mark_tginfo2 *info = (const void *)target->data;
 
-	printf(" --set-xmark 0x%x/0x%x", info->mark, info->mask);
+	printf(" --set-xmark 0x%x", info->mark);
+	if (info->mask != 0xffffffffU)
+		printf("/0x%x", info->mask);
 }
 
 static void mark_tg_arp_save(const void *ip, const struct xt_entry_target *target)
diff --git a/extensions/libxt_connlimit.c b/extensions/libxt_connlimit.c
index 118faea560f73..00cd0ba2f852c 100644
--- a/extensions/libxt_connlimit.c
+++ b/extensions/libxt_connlimit.c
@@ -152,13 +152,15 @@ static void connlimit_print6(const void *ip,
 static void connlimit_save4(const void *ip, const struct xt_entry_match *match)
 {
 	const struct xt_connlimit_info *info = (const void *)match->data;
+	unsigned int bits = count_bits4(info->v4_mask);
 	const int revision = match->u.user.revision;
 
 	if (info->flags & XT_CONNLIMIT_INVERT)
 		printf(" --connlimit-upto %u", info->limit);
 	else
 		printf(" --connlimit-above %u", info->limit);
-	printf(" --connlimit-mask %u", count_bits4(info->v4_mask));
+	if (bits != 32)
+		printf(" --connlimit-mask %u", bits);
 	if (revision >= 1) {
 		if (info->flags & XT_CONNLIMIT_DADDR)
 			printf(" --connlimit-daddr");
@@ -170,13 +172,15 @@ static void connlimit_save4(const void *ip, const struct xt_entry_match *match)
 static void connlimit_save6(const void *ip, const struct xt_entry_match *match)
 {
 	const struct xt_connlimit_info *info = (const void *)match->data;
+	unsigned int bits = count_bits6(info->v6_mask);
 	const int revision = match->u.user.revision;
 
 	if (info->flags & XT_CONNLIMIT_INVERT)
 		printf(" --connlimit-upto %u", info->limit);
 	else
 		printf(" --connlimit-above %u", info->limit);
-	printf(" --connlimit-mask %u", count_bits6(info->v6_mask));
+	if (bits != 128)
+		printf(" --connlimit-mask %u", bits);
 	if (revision >= 1) {
 		if (info->flags & XT_CONNLIMIT_DADDR)
 			printf(" --connlimit-daddr");
diff --git a/extensions/libxt_connlimit.t b/extensions/libxt_connlimit.t
index 23bba69474fed..8495b77fd2d2c 100644
--- a/extensions/libxt_connlimit.t
+++ b/extensions/libxt_connlimit.t
@@ -8,9 +8,9 @@
 -m connlimit --connlimit-above 4294967296 --connlimit-saddr;;FAIL
 -m connlimit --connlimit-above -1;;FAIL
 -m connlimit --connlimit-upto 1 --conlimit-above 1;;FAIL
--m connlimit --connlimit-above 10 --connlimit-saddr;-m connlimit --connlimit-above 10 --connlimit-mask 32 --connlimit-saddr;OK
--m connlimit --connlimit-above 10 --connlimit-daddr;-m connlimit --connlimit-above 10 --connlimit-mask 32 --connlimit-daddr;OK
+-m connlimit --connlimit-above 10 --connlimit-saddr;=;OK
+-m connlimit --connlimit-above 10 --connlimit-daddr;=;OK
 -m connlimit --connlimit-above 10 --connlimit-saddr --connlimit-daddr;;FAIL
--m connlimit --connlimit-above 10 --connlimit-mask 32 --connlimit-saddr;=;OK
--m connlimit --connlimit-above 10 --connlimit-mask 32 --connlimit-daddr;=;OK
+-m connlimit --connlimit-above 10 --connlimit-mask 32 --connlimit-saddr;-m connlimit --connlimit-above 10 --connlimit-saddr;OK
+-m connlimit --connlimit-above 10 --connlimit-mask 32 --connlimit-daddr;-m connlimit --connlimit-above 10 --connlimit-daddr;OK
 -m connlimit;;FAIL
diff --git a/extensions/libxt_recent.c b/extensions/libxt_recent.c
index 055ae35080346..659a91ba7b707 100644
--- a/extensions/libxt_recent.c
+++ b/extensions/libxt_recent.c
@@ -176,6 +176,29 @@ static void recent_check(struct xt_fcheck_call *cb)
 			"`--update' or `--remove'");
 }
 
+static void recent_print_mask(int family, const char *prefix,
+			      const union nf_inet_addr *mask)
+{
+	static const __u32 allones[4] = { -1, -1, -1, -1 };
+
+	switch(family) {
+	case NFPROTO_IPV4:
+		if (!memcmp(&mask->in, allones, sizeof(mask->in)))
+			return;
+
+		printf(" %s %s", prefix,
+		       xtables_ipaddr_to_numeric(&mask->in));
+		break;
+	case NFPROTO_IPV6:
+		if (!memcmp(&mask->in6, allones, sizeof(mask->in6)))
+			return;
+
+		printf(" %s %s", prefix,
+		       xtables_ip6addr_to_numeric(&mask->in6));
+		break;
+	}
+}
+
 static void recent_print(const void *ip, const struct xt_entry_match *match,
                          unsigned int family)
 {
@@ -205,16 +228,7 @@ static void recent_print(const void *ip, const struct xt_entry_match *match,
 	if (info->side == XT_RECENT_DEST)
 		printf(" side: dest");
 
-	switch(family) {
-	case NFPROTO_IPV4:
-		printf(" mask: %s",
-			xtables_ipaddr_to_numeric(&info->mask.in));
-		break;
-	case NFPROTO_IPV6:
-		printf(" mask: %s",
-			xtables_ip6addr_to_numeric(&info->mask.in6));
-		break;
-	}
+	recent_print_mask(family, "mask:", &info->mask);
 }
 
 static void recent_save(const void *ip, const struct xt_entry_match *match,
@@ -241,16 +255,7 @@ static void recent_save(const void *ip, const struct xt_entry_match *match,
 		printf(" --rttl");
 	printf(" --name %s",info->name);
 
-	switch(family) {
-	case NFPROTO_IPV4:
-		printf(" --mask %s",
-			xtables_ipaddr_to_numeric(&info->mask.in));
-		break;
-	case NFPROTO_IPV6:
-		printf(" --mask %s",
-			xtables_ip6addr_to_numeric(&info->mask.in6));
-		break;
-	}
+	recent_print_mask(family, "--mask", &info->mask);
 
 	if (info->side == XT_RECENT_SOURCE)
 		printf(" --rsource");
diff --git a/extensions/libxt_recent.t b/extensions/libxt_recent.t
index ce85b91bf9ac6..bccb8cecfd924 100644
--- a/extensions/libxt_recent.t
+++ b/extensions/libxt_recent.t
@@ -1,11 +1,11 @@
 :INPUT,FORWARD,OUTPUT
 -m recent --set;-m recent --set --name DEFAULT --rsource;OK
--m recent --rcheck --hitcount 8 --name foo --mask 255.255.255.255 --rsource;=;OK
--m recent --rcheck --hitcount 12 --name foo --mask 255.255.255.255 --rsource;=;OK
--m recent --update --rttl;-m recent --update --rttl --name DEFAULT --mask 255.255.255.255 --rsource;OK
+-m recent --rcheck --hitcount 8 --name foo --mask 255.255.255.255 --rsource;-m recent --rcheck --hitcount 8 --name foo --rsource;OK
+-m recent --rcheck --hitcount 12 --name foo --mask 255.255.255.255 --rsource;-m recent --rcheck --hitcount 12 --name foo --rsource;OK
+-m recent --update --rttl;-m recent --update --rttl --name DEFAULT --rsource;OK
 -m recent --set --rttl;;FAIL
 -m recent --rcheck --hitcount 999 --name foo --mask 255.255.255.255 --rsource;;FAIL
 # nonsensical, but all should load successfully:
--m recent --rcheck --hitcount 3 --name foo --mask 255.255.255.255 --rsource -m recent --rcheck --hitcount 4 --name foo --mask 255.255.255.255 --rsource;=;OK
--m recent --rcheck --hitcount 4 --name foo --mask 255.255.255.255 --rsource -m recent --rcheck --hitcount 4 --name foo --mask 255.255.255.255 --rsource;=;OK
--m recent --rcheck --hitcount 8 --name foo --mask 255.255.255.255 --rsource -m recent --rcheck --hitcount 12 --name foo --mask 255.255.255.255 --rsource;=;OK
+-m recent --rcheck --hitcount 3 --name foo --rsource -m recent --rcheck --hitcount 4 --name foo --rsource;=;OK
+-m recent --rcheck --hitcount 4 --name foo --rsource -m recent --rcheck --hitcount 4 --name foo --rsource;=;OK
+-m recent --rcheck --hitcount 8 --name foo --rsource -m recent --rcheck --hitcount 12 --name foo --rsource;=;OK
-- 
2.34.1

