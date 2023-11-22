Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 707F0C61DB1
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 Nov 2023 21:45:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344369AbjKVVpG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 22 Nov 2023 16:45:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344372AbjKVVpD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Nov 2023 16:45:03 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 779F31BF
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Nov 2023 13:44:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Ak9Ldh0Cg94LV58WoreEC07xO562loBXRmOP2kyoX34=; b=f8a3gnZbbfIsmeoWs14lagAt67
        /gYsFROlIW0wT62AkcggiJU2KuaJvKvRDCad2XfkEORd7pkDTadzRw65KkZ/8QdkZcjZgTW89Q8+T
        KzjNyMU/aYPCr2Pbg4FOGR+o4vKtNZCxpRt0B4vjKQn8ll5474CGiywF8mjXO2PIIosZOjpnq1EPU
        z1tfahViZGMmsmUCpqY7evmgkRcSRFPcVrjDHzDhWyvrZvcCX6mDBteiSlqkztfdzDzZpXG1HR/FF
        YAxnlIgviVXbtxiEoQ0tT5bnw7LBwK4j4UvdWZHDwIos9w1ZCMk0QeRee6Z9qchu1KsEPEvJCEnlx
        IEDiM87Q==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1r5v1l-0003i2-Qj
        for netfilter-devel@vger.kernel.org; Wed, 22 Nov 2023 22:44:57 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 2/6] libxtables: Fix guided option parser for use with arptables
Date:   Wed, 22 Nov 2023 22:52:57 +0100
Message-ID: <20231122215301.15725-3-phil@nwl.cc>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231122215301.15725-1-phil@nwl.cc>
References: <20231122215301.15725-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

With an unexpected value in afinfo->family, guided option parser was
rather useless when called from arptables extensions. Introduce
afinfo_family() wrapper to sanitize at least NFPROTO_ARP value.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 libxtables/xtoptions.c | 23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/libxtables/xtoptions.c b/libxtables/xtoptions.c
index 0667315ceccf8..25540f8b88c6d 100644
--- a/libxtables/xtoptions.c
+++ b/libxtables/xtoptions.c
@@ -65,6 +65,19 @@ static const size_t xtopt_psize[] = {
 	[XTTYPE_ETHERMAC]    = sizeof(uint8_t[6]),
 };
 
+/**
+ * Return a sanitized afinfo->family value, covering for NFPROTO_ARP
+ */
+static uint8_t afinfo_family(void)
+{
+	switch (afinfo->family) {
+	case NFPROTO_ARP:
+		return NFPROTO_IPV4;
+	default:
+		return afinfo->family;
+	}
+}
+
 /**
  * Creates getopt options from the x6-style option map, and assigns each a
  * getopt id.
@@ -461,7 +474,7 @@ static socklen_t xtables_sa_hostlen(unsigned int afproto)
  */
 static void xtopt_parse_host(struct xt_option_call *cb)
 {
-	struct addrinfo hints = {.ai_family = afinfo->family};
+	struct addrinfo hints = {.ai_family = afinfo_family()};
 	unsigned int adcount = 0;
 	struct addrinfo *res, *p;
 	int ret;
@@ -472,7 +485,7 @@ static void xtopt_parse_host(struct xt_option_call *cb)
 			"getaddrinfo: %s\n", gai_strerror(ret));
 
 	memset(&cb->val.hmask, 0xFF, sizeof(cb->val.hmask));
-	cb->val.hlen = (afinfo->family == NFPROTO_IPV4) ? 32 : 128;
+	cb->val.hlen = (afinfo_family() == NFPROTO_IPV4) ? 32 : 128;
 
 	for (p = res; p != NULL; p = p->ai_next) {
 		if (adcount == 0) {
@@ -615,7 +628,7 @@ static void xtopt_parse_mport(struct xt_option_call *cb)
 
 static int xtopt_parse_mask(struct xt_option_call *cb)
 {
-	struct addrinfo hints = {.ai_family = afinfo->family,
+	struct addrinfo hints = {.ai_family = afinfo_family(),
 				 .ai_flags = AI_NUMERICHOST };
 	struct addrinfo *res;
 	int ret;
@@ -627,7 +640,7 @@ static int xtopt_parse_mask(struct xt_option_call *cb)
 	memcpy(&cb->val.hmask, xtables_sa_host(res->ai_addr, res->ai_family),
 	       xtables_sa_hostlen(res->ai_family));
 
-	switch(afinfo->family) {
+	switch(afinfo_family()) {
 	case AF_INET:
 		cb->val.hlen = xtables_ipmask_to_cidr(&cb->val.hmask.in);
 		break;
@@ -649,7 +662,7 @@ static void xtopt_parse_plen(struct xt_option_call *cb)
 	const struct xt_option_entry *entry = cb->entry;
 	unsigned int prefix_len = 128; /* happiness is a warm gcc */
 
-	cb->val.hlen = (afinfo->family == NFPROTO_IPV4) ? 32 : 128;
+	cb->val.hlen = (afinfo_family() == NFPROTO_IPV4) ? 32 : 128;
 	if (!xtables_strtoui(cb->arg, NULL, &prefix_len, 0, cb->val.hlen)) {
 		/* Is this mask expressed in full format? e.g. 255.255.255.0 */
 		if (xtopt_parse_mask(cb))
-- 
2.41.0

