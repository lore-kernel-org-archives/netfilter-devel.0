Return-Path: <SRS0=CgNT=DN=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07DE3C41604
	for <netfilter-devel@archiver.kernel.org>; Tue,  6 Oct 2020 16:51:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A9BEA206DD
	for <netfilter-devel@archiver.kernel.org>; Tue,  6 Oct 2020 16:51:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726064AbgJFQvn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 6 Oct 2020 12:51:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725972AbgJFQvn (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Oct 2020 12:51:43 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 078EBC061755
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Oct 2020 09:51:43 -0700 (PDT)
Received: from localhost ([::1]:33150 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.94)
        (envelope-from <phil@nwl.cc>)
        id 1kPqBg-0004RY-Cy; Tue, 06 Oct 2020 18:51:40 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org,
        Laura Garcia Liebana <nevola@gmail.com>
Subject: [iptables PATCH] extensions: libipt_icmp: Fix translation of type 'any'
Date:   Tue,  6 Oct 2020 19:13:01 +0200
Message-Id: <20201006171301.6192-1-phil@nwl.cc>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

By itself, '-m icmp --icmp-type any' is a noop, it matches any icmp
types. Yet nft_ipv4_xlate() does not emit an 'ip protocol' match if
there's an extension with same name present in the rule. Luckily, legacy
iptables demands icmp match to be prepended by '-p icmp', so we can
assume this is present and just emit the 'ip protocol' match from icmp
xlate callback.

Fixes: aa158ca0fda65 ("extensions: libipt_icmp: Add translation to nft")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libipt_icmp.c      | 5 +++++
 extensions/libipt_icmp.txlate | 3 +++
 2 files changed, 8 insertions(+)

diff --git a/extensions/libipt_icmp.c b/extensions/libipt_icmp.c
index e76257c54708c..e5e236613f39f 100644
--- a/extensions/libipt_icmp.c
+++ b/extensions/libipt_icmp.c
@@ -256,6 +256,11 @@ static int icmp_xlate(struct xt_xlate *xl,
 		if (!type_xlate_print(xl, info->type, info->code[0],
 				      info->code[1]))
 			return 0;
+	} else {
+		/* '-m icmp --icmp-type any' is a noop by itself,
+		 * but it eats a (mandatory) previous '-p icmp' so
+		 * emit it here */
+		xt_xlate_add(xl, "ip protocol icmp");
 	}
 	return 1;
 }
diff --git a/extensions/libipt_icmp.txlate b/extensions/libipt_icmp.txlate
index 434f8cc4eb1ae..a2aec8e26df75 100644
--- a/extensions/libipt_icmp.txlate
+++ b/extensions/libipt_icmp.txlate
@@ -6,3 +6,6 @@ nft add rule ip filter INPUT icmp type destination-unreachable counter accept
 
 iptables-translate -t filter -A INPUT -m icmp ! --icmp-type 3 -j ACCEPT
 nft add rule ip filter INPUT icmp type != destination-unreachable counter accept
+
+iptables-translate -t filter -A INPUT -m icmp --icmp-type any -j ACCEPT
+nft add rule ip filter INPUT ip protocol icmp counter accept
-- 
2.28.0

