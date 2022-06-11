Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0BB1C433EF
	for <netfilter-devel@archiver.kernel.org>; Sat, 11 Jun 2022 10:08:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229870AbiFKKIA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 11 Jun 2022 06:08:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229821AbiFKKH7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 11 Jun 2022 06:07:59 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FB3BC16
        for <netfilter-devel@vger.kernel.org>; Sat, 11 Jun 2022 03:07:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Ax64YxzISIvtDVzbvI66PxM8gbyRl8FaCxomypLILfY=; b=jY0TaKkqsL6yXMA5RZLJobNF65
        p9yer+RrRpLlinCk9J7Hy5KxRvAqbUoeAxsoLvT8BuEm60wczypS/8zBQpGRsaVFR8bcXjhMlZ1OZ
        auwKd+3mI7S2LJdUGsNWDItNACsYtwOA8yg+UmoeWj3mwuT4oAd6dA4OTHYDysC0jCNv4VFZLpIKJ
        92FeZrNTOfpk54ALMIVkQlHUEmc+uN9JCY97CXYxDAZod5Fu0C3NsDIDOe48ltjFKlOczXMfBBqaS
        Il3mKB5WjPebbK/jfqD8eBNfkFl6phwseZiFH5D8HiHErk3pil3P6+9FEM6dB+KUvVKUN7Y2ww1/a
        IZ9Yn79Q==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nzy28-00061l-FQ; Sat, 11 Jun 2022 12:07:56 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jan Engelhardt <jengelh@inai.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 2/2] libxtables: Define XT_OPTION_OFFSET_SCALE in xtables.h
Date:   Sat, 11 Jun 2022 12:07:42 +0200
Message-Id: <20220611100742.4888-3-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220611100742.4888-1-phil@nwl.cc>
References: <20220611100742.4888-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This is the last symbol in xshared.h used by libxtables, move it over.
Again, treat this as "implementation detail" and hence put it behind
XTABLES_INTERNAL-curtains.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/xtables.h      | 3 +++
 iptables/xshared.h     | 4 ----
 libxtables/xtables.c   | 1 -
 libxtables/xtoptions.c | 1 -
 4 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/include/xtables.h b/include/xtables.h
index b8d8372d0e498..9eba4f619d351 100644
--- a/include/xtables.h
+++ b/include/xtables.h
@@ -687,6 +687,9 @@ struct xtables_afinfo {
 
 extern const struct xtables_afinfo *afinfo;
 
+/* base offset of merged extensions' consecutive options */
+#define XT_OPTION_OFFSET_SCALE	256
+
 #endif /* XTABLES_INTERNAL */
 
 #ifdef __cplusplus
diff --git a/iptables/xshared.h b/iptables/xshared.h
index 1fdc760a32442..1a019a7c04882 100644
--- a/iptables/xshared.h
+++ b/iptables/xshared.h
@@ -132,10 +132,6 @@ struct subcommand {
 	mainfunc_t main;
 };
 
-enum {
-	XT_OPTION_OFFSET_SCALE = 256,
-};
-
 extern int subcmd_main(int, char **, const struct subcommand *);
 extern void xs_init_target(struct xtables_target *);
 extern void xs_init_match(struct xtables_match *);
diff --git a/libxtables/xtables.c b/libxtables/xtables.c
index 0638f9271c601..dc645162973f0 100644
--- a/libxtables/xtables.c
+++ b/libxtables/xtables.c
@@ -64,7 +64,6 @@
 #endif
 #include <getopt.h>
 #include "iptables/internal.h"
-#include "xshared.h"
 
 #define NPROTO	255
 
diff --git a/libxtables/xtoptions.c b/libxtables/xtoptions.c
index 9d3ac5c8066cb..8174a560ec4df 100644
--- a/libxtables/xtoptions.c
+++ b/libxtables/xtoptions.c
@@ -21,7 +21,6 @@
 #include <arpa/inet.h>
 #include <netinet/ip.h>
 #include "xtables.h"
-#include "xshared.h"
 #ifndef IPTOS_NORMALSVC
 #	define IPTOS_NORMALSVC 0
 #endif
-- 
2.34.1

