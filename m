Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F326C0502C
	for <netfilter-devel@archiver.kernel.org>; Sat, 27 Aug 2022 17:18:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231841AbiH0RSM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 27 Aug 2022 13:18:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbiH0RSL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 27 Aug 2022 13:18:11 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9CFA29CB4
        for <netfilter-devel@vger.kernel.org>; Sat, 27 Aug 2022 10:18:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=hIOVxKLA34s0RjMR/+kfOP7Ix3BI7dqNr7vj417szkY=; b=UltrP9q0AgJaqV82mcNWYHcEF0
        sqFzufm+JUVUal2HkB+W1r9vzek3+/DWlKWMtZXvHmQ/76eq9Y0MJgN15UOBMP2J1Wj4rj9W5oDCh
        w0OKl1Twx1nh5YXh3AAq+YAajGhNg56gWVq0bzjutkd2LvuLLVrZI1yOVU/VFsmRUJVrfa44weg32
        e/RAv2btG7AZpdjqjARl2KMSABDmZrDY0qLl6C7yV/HgM+SrnucnY+/wbsbF/A5ApLm+Mb0lPEGBT
        J9/7w86jb6J7EEmTtIK0T+O0U/Iq9Dae5lXJd1pGzNNZeuRmb2lZUYqzlAs0D5bYDtxDy3UqVyoCr
        GpYtirNw==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1oRzRe-008ZqG-Jk
        for netfilter-devel@vger.kernel.org; Sat, 27 Aug 2022 18:18:06 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH libnftnl] rule, set_elem: fix printing of user data
Date:   Sat, 27 Aug 2022 18:17:17 +0100
Message-Id: <20220827171717.945191-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hitherto, alphanumeric characters have been printed as-is, but anything
else was replaced by '\0'.  However, this effectively truncates the
output.  Instead, print any printable character as-is and print anything
else as a hexadecimal escape sequence:

  userdata = { \x01\x04\x01\x00\x00\x00 }

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 src/rule.c     | 5 +++--
 src/set_elem.c | 7 ++++---
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/src/rule.c b/src/rule.c
index 0bb1c2a0583c..a1a64bd2837d 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -622,8 +622,9 @@ static int nftnl_rule_snprintf_default(char *buf, size_t remain,
 		for (i = 0; i < r->user.len; i++) {
 			char *c = r->user.data;
 
-			ret = snprintf(buf + offset, remain, "%c",
-				       isalnum(c[i]) ? c[i] : 0);
+			ret = snprintf(buf + offset, remain,
+				       isprint(c[i]) ? "%c" : "\\x%02hhx",
+				       c[i]);
 			SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 		}
 
diff --git a/src/set_elem.c b/src/set_elem.c
index 95009acb17dc..1c8720dc7c57 100644
--- a/src/set_elem.c
+++ b/src/set_elem.c
@@ -735,14 +735,15 @@ int nftnl_set_elem_snprintf_default(char *buf, size_t remain,
 	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 	if (e->user.len) {
-		ret = snprintf(buf + offset, remain, "  userdata = {");
+		ret = snprintf(buf + offset, remain, "  userdata = { ");
 		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 		for (i = 0; i < e->user.len; i++) {
 			char *c = e->user.data;
 
-			ret = snprintf(buf + offset, remain, "%c",
-				       isalnum(c[i]) ? c[i] : 0);
+			ret = snprintf(buf + offset, remain,
+				       isprint(c[i]) ? "%c" : "\\x%02hhx",
+				       c[i]);
 			SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 		}
 
-- 
2.35.1

