Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 530E9C61D97
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 Nov 2023 21:45:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344372AbjKVVpH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 22 Nov 2023 16:45:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344385AbjKVVpD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Nov 2023 16:45:03 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1687D40
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Nov 2023 13:44:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=n9gYwQSxN8OgqoSS5xHtkZtFx3BN6M+ZhvorYJSWt3I=; b=H3cr1zUgxQ4MMEYmSNi0KwPGX3
        4oYUYP+lriUlxVwDGUhDvF6Lj6m38UjepQd4djXqXru5FVBZCsCuim+9z12NkZ5sT03Hf27uO/KAy
        f80MblZOhDa3iAX5VDWKGKm0MPIUdlGSVoT6eBDgEJWHeWfgkQeNr22wrG8OKpUCSoD9RAWoRyMXn
        l1RGoFdJoSO6qUhNos7NWYyXh4n4Uzj0wa+evHYPqwkBNqxgoA6OSxktAskJdzSF7xyDq3wJ1Kzfy
        oDACRUbquHOJC+wnk/C5ke2TJu/MbIuCvUMMa8GUQ3SDDAEHB3W4+SkgLfMdpCvmoXQk2uP5cTXvA
        Z0rjrvCw==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1r5v1m-0003i6-4P
        for netfilter-devel@vger.kernel.org; Wed, 22 Nov 2023 22:44:58 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 5/6] extensions: libarpt_mangle: Use guided option parser
Date:   Wed, 22 Nov 2023 22:53:00 +0100
Message-ID: <20231122215301.15725-6-phil@nwl.cc>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231122215301.15725-1-phil@nwl.cc>
References: <20231122215301.15725-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Sadly not the best conversion, struct arpt_mangle is not ideal for use
as storage backend: With MAC addresses, xtopt_parse_ethermac() refuses
to write into *_devaddr fields as they are larger than expected. With
XTTYPE_HOSTMASK OTOH, XTOPT_PUT is not supported in the first place.

As a side-effect, network names (from /etc/networks) are no longer
accepted. But earlier migrations to guided option parser had this
side-effect as well, so probably not a frequently used feature.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libarpt_mangle.c | 128 +++++++++++++-----------------------
 extensions/libarpt_mangle.t |   4 ++
 2 files changed, 48 insertions(+), 84 deletions(-)

diff --git a/extensions/libarpt_mangle.c b/extensions/libarpt_mangle.c
index 364c9ce755b97..283bb1323806c 100644
--- a/extensions/libarpt_mangle.c
+++ b/extensions/libarpt_mangle.c
@@ -25,19 +25,16 @@ static void arpmangle_print_help(void)
 	"--mangle-target target (DROP, CONTINUE or ACCEPT -- default is ACCEPT)\n");
 }
 
-#define MANGLE_IPS    '1'
-#define MANGLE_IPT    '2'
-#define MANGLE_DEVS   '3'
-#define MANGLE_DEVT   '4'
-#define MANGLE_TARGET '5'
-
-static const struct option arpmangle_opts[] = {
-	{ .name = "mangle-ip-s",	.has_arg = true, .val = MANGLE_IPS },
-	{ .name = "mangle-ip-d",	.has_arg = true, .val = MANGLE_IPT },
-	{ .name = "mangle-mac-s",	.has_arg = true, .val = MANGLE_DEVS },
-	{ .name = "mangle-mac-d",	.has_arg = true, .val = MANGLE_DEVT },
-	{ .name = "mangle-target",	.has_arg = true, .val = MANGLE_TARGET },
-	XT_GETOPT_TABLEEND,
+/* internal use only, explicitly not covered by ARPT_MANGLE_MASK */
+#define ARPT_MANGLE_TARGET	0x10
+
+static const struct xt_option_entry arpmangle_opts[] = {
+{ .name = "mangle-ip-s", .id = ARPT_MANGLE_SIP, .type = XTTYPE_HOSTMASK },
+{ .name = "mangle-ip-d", .id = ARPT_MANGLE_TIP, .type = XTTYPE_HOSTMASK },
+{ .name = "mangle-mac-s", .id = ARPT_MANGLE_SDEV, .type = XTTYPE_ETHERMAC },
+{ .name = "mangle-mac-d", .id = ARPT_MANGLE_TDEV, .type = XTTYPE_ETHERMAC },
+{ .name = "mangle-target", .id = ARPT_MANGLE_TARGET, .type = XTTYPE_STRING },
+XTOPT_TABLEEND,
 };
 
 static void arpmangle_init(struct xt_entry_target *target)
@@ -47,86 +44,50 @@ static void arpmangle_init(struct xt_entry_target *target)
 	mangle->target = NF_ACCEPT;
 }
 
-static int
-arpmangle_parse(int c, char **argv, int invert, unsigned int *flags,
-		const void *entry, struct xt_entry_target **target)
+static void assert_hopts(const struct arpt_entry *e, const char *optname)
 {
-	struct arpt_mangle *mangle = (struct arpt_mangle *)(*target)->data;
-	struct in_addr *ipaddr, mask;
-	struct ether_addr *macaddr;
-	const struct arpt_entry *e = (const struct arpt_entry *)entry;
-	unsigned int nr;
-	int ret = 1;
-
-	memset(&mask, 0, sizeof(mask));
-
-	switch (c) {
-	case MANGLE_IPS:
-		xtables_ipparse_any(optarg, &ipaddr, &mask, &nr);
-		mangle->u_s.src_ip.s_addr = ipaddr->s_addr;
-		free(ipaddr);
-		mangle->flags |= ARPT_MANGLE_SIP;
-		break;
-	case MANGLE_IPT:
-		xtables_ipparse_any(optarg, &ipaddr, &mask, &nr);
-		mangle->u_t.tgt_ip.s_addr = ipaddr->s_addr;
-		free(ipaddr);
-		mangle->flags |= ARPT_MANGLE_TIP;
+	if (e->arp.arhln_mask == 0)
+		xtables_error(PARAMETER_PROBLEM, "no --h-length defined");
+	if (e->arp.invflags & IPT_INV_ARPHLN)
+		xtables_error(PARAMETER_PROBLEM,
+			      "! hln not allowed for --%s", optname);
+	if (e->arp.arhln != 6)
+		xtables_error(PARAMETER_PROBLEM, "only --h-length 6 supported");
+}
+
+static void arpmangle_parse(struct xt_option_call *cb)
+{
+	const struct arpt_entry *e = cb->xt_entry;
+	struct arpt_mangle *mangle = cb->data;
+
+	xtables_option_parse(cb);
+	mangle->flags |= (cb->entry->id & ARPT_MANGLE_MASK);
+	switch (cb->entry->id) {
+	case ARPT_MANGLE_SIP:
+		mangle->u_s.src_ip = cb->val.haddr.in;
 		break;
-	case MANGLE_DEVS:
-		if (e->arp.arhln_mask == 0)
-			xtables_error(PARAMETER_PROBLEM,
-				      "no --h-length defined");
-		if (e->arp.invflags & IPT_INV_ARPHLN)
-			xtables_error(PARAMETER_PROBLEM,
-				      "! --h-length not allowed for "
-				      "--mangle-mac-s");
-		if (e->arp.arhln != 6)
-			xtables_error(PARAMETER_PROBLEM,
-				      "only --h-length 6 supported");
-		macaddr = ether_aton(optarg);
-		if (macaddr == NULL)
-			xtables_error(PARAMETER_PROBLEM,
-				      "invalid source MAC");
-		memcpy(mangle->src_devaddr, macaddr, e->arp.arhln);
-		mangle->flags |= ARPT_MANGLE_SDEV;
+	case ARPT_MANGLE_TIP:
+		mangle->u_t.tgt_ip = cb->val.haddr.in;
 		break;
-	case MANGLE_DEVT:
-		if (e->arp.arhln_mask == 0)
-			xtables_error(PARAMETER_PROBLEM,
-				      "no --h-length defined");
-		if (e->arp.invflags & IPT_INV_ARPHLN)
-			xtables_error(PARAMETER_PROBLEM,
-				      "! hln not allowed for --mangle-mac-d");
-		if (e->arp.arhln != 6)
-			xtables_error(PARAMETER_PROBLEM,
-				      "only --h-length 6 supported");
-		macaddr = ether_aton(optarg);
-		if (macaddr == NULL)
-			xtables_error(PARAMETER_PROBLEM, "invalid target MAC");
-		memcpy(mangle->tgt_devaddr, macaddr, e->arp.arhln);
-		mangle->flags |= ARPT_MANGLE_TDEV;
+	case ARPT_MANGLE_SDEV:
+		assert_hopts(e, cb->entry->name);
+		memcpy(mangle->src_devaddr, cb->val.ethermac, ETH_ALEN);
+	case ARPT_MANGLE_TDEV:
+		assert_hopts(e, cb->entry->name);
+		memcpy(mangle->tgt_devaddr, cb->val.ethermac, ETH_ALEN);
 		break;
-	case MANGLE_TARGET:
-		if (!strcmp(optarg, "DROP"))
+	case ARPT_MANGLE_TARGET:
+		if (!strcmp(cb->arg, "DROP"))
 			mangle->target = NF_DROP;
-		else if (!strcmp(optarg, "ACCEPT"))
+		else if (!strcmp(cb->arg, "ACCEPT"))
 			mangle->target = NF_ACCEPT;
-		else if (!strcmp(optarg, "CONTINUE"))
+		else if (!strcmp(cb->arg, "CONTINUE"))
 			mangle->target = XT_CONTINUE;
 		else
 			xtables_error(PARAMETER_PROBLEM,
 				      "bad target for --mangle-target");
 		break;
-	default:
-		ret = 0;
 	}
-
-	return ret;
-}
-
-static void arpmangle_final_check(unsigned int flags)
-{
 }
 
 static const char *ipaddr_to(const struct in_addr *addrp, int numeric)
@@ -225,11 +186,10 @@ static struct xtables_target arpmangle_target = {
 	.userspacesize	= XT_ALIGN(sizeof(struct arpt_mangle)),
 	.help		= arpmangle_print_help,
 	.init		= arpmangle_init,
-	.parse		= arpmangle_parse,
-	.final_check	= arpmangle_final_check,
+	.x6_parse	= arpmangle_parse,
 	.print		= arpmangle_print,
 	.save		= arpmangle_save,
-	.extra_opts	= arpmangle_opts,
+	.x6_options	= arpmangle_opts,
 	.xlate		= arpmangle_xlate,
 };
 
diff --git a/extensions/libarpt_mangle.t b/extensions/libarpt_mangle.t
index da9669489d291..7a639ee10aa0f 100644
--- a/extensions/libarpt_mangle.t
+++ b/extensions/libarpt_mangle.t
@@ -3,3 +3,7 @@
 -j mangle -d 1.2.3.4 --mangle-ip-d 1.2.3.5;=;OK
 -j mangle -d 1.2.3.4 --mangle-mac-d 00:01:02:03:04:05;=;OK
 -d 1.2.3.4 --h-length 5 -j mangle --mangle-mac-s 00:01:02:03:04:05;=;FAIL
+-j mangle --mangle-ip-s 1.2.3.4 --mangle-target DROP;=;OK
+-j mangle --mangle-ip-s 1.2.3.4 --mangle-target ACCEPT;-j mangle --mangle-ip-s 1.2.3.4;OK
+-j mangle --mangle-ip-s 1.2.3.4 --mangle-target CONTINUE;=;OK
+-j mangle --mangle-ip-s 1.2.3.4 --mangle-target FOO;=;FAIL
-- 
2.41.0

