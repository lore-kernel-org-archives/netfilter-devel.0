Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72BF6ECAAD4
	for <netfilter-devel@archiver.kernel.org>; Wed, 31 Aug 2022 11:16:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230511AbiHaLQT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 31 Aug 2022 07:16:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231124AbiHaLQS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 31 Aug 2022 07:16:18 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 786BCBFE9A
        for <netfilter-devel@vger.kernel.org>; Wed, 31 Aug 2022 04:16:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=MJdoI9DshPhQVypd0ipMBtbWJcUlQCBU2v6lXYtLykE=; b=H/ZonlTRY7hQBmuTaMkGnkdBPA
        J/Va94SS1IiafG1QAh2R9F3j9nmJHKs6MdsS477gP5djIcopRDL3MGayMHepIEegeu/5qDWmcWq97
        GiQHwFZAiO73jgl16rZKIX4iS++CGBPsTFkEwUaL4tBo57teIAg/urdVKbsSLcWxLmF5VtKaAwqKH
        /dOOctpnbxoVABPC6cWV+704XmJB0BN/naNPxeGiLzEbM5xUecP25DlhgNiXmbKPYugMgMW1aW8E6
        k3djv0YxBAnkwnrzdpgvsyzOap3G4ZAEH4Hum46LNmYmmdMpcFEaBLpsSiPVfNUpFCq9zr5pWQpvG
        t7Dhu8ug==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1oTLhf-0000l2-Ma; Wed, 31 Aug 2022 13:16:15 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     "Jose M . Guisado Gomez" <guigom@riseup.net>,
        netfilter-devel@vger.kernel.org
Subject: [conntrack-tools PATCH] local: Avoid sockaddr_un::sun_path buffer overflow
Date:   Wed, 31 Aug 2022 13:16:10 +0200
Message-Id: <20220831111610.16188-1-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The array's size in struct sockaddr_un is only UNIX_PATH_MAX and
according to unix(7), it should hold a null-terminated string. So adjust
config reader to reject paths of length UNIX_PATH_MAX and above and
adjust the internal arrays to aid the compiler.

Fixes: f196de88cdd97 ("src: fix strncpy -Wstringop-truncation warnings")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/local.h      | 4 ++--
 src/read_config_yy.y | 6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/local.h b/include/local.h
index 9379446732eed..22859d7ab60aa 100644
--- a/include/local.h
+++ b/include/local.h
@@ -7,12 +7,12 @@
 
 struct local_conf {
 	int reuseaddr;
-	char path[UNIX_PATH_MAX + 1];
+	char path[UNIX_PATH_MAX];
 };
 
 struct local_server {
 	int fd;
-	char path[UNIX_PATH_MAX + 1];
+	char path[UNIX_PATH_MAX];
 };
 
 /* callback return values */
diff --git a/src/read_config_yy.y b/src/read_config_yy.y
index 5815d6ab464e8..a2154be3733e1 100644
--- a/src/read_config_yy.y
+++ b/src/read_config_yy.y
@@ -699,12 +699,12 @@ unix_options:
 
 unix_option : T_PATH T_PATH_VAL
 {
-	if (strlen($2) > UNIX_PATH_MAX) {
+	if (strlen($2) >= UNIX_PATH_MAX) {
 		dlog(LOG_ERR, "Path is longer than %u characters",
-		     UNIX_PATH_MAX);
+		     UNIX_PATH_MAX - 1);
 		exit(EXIT_FAILURE);
 	}
-	snprintf(conf.local.path, sizeof(conf.local.path), "%s", $2);
+	strcpy(conf.local.path, $2);
 	free($2);
 };
 
-- 
2.34.1

