Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC04FEE49A4
	for <netfilter-devel@archiver.kernel.org>; Sun, 10 Sep 2023 20:30:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbjIJUae (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 10 Sep 2023 16:30:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbjIJUad (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 10 Sep 2023 16:30:33 -0400
Received: from taras.nevrast.org (unknown [IPv6:2a05:d01c:431:aa03:b7e1:333d:ea2a:b14e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D39A59C
        for <netfilter-devel@vger.kernel.org>; Sun, 10 Sep 2023 13:30:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=QjvhJC7iYWe1rKy8UfxZ3Z2H5znLUS97GXLKohUV0/4=; b=jaPP02o/wc956QoOSCAon40Vbm
        MdWiOSDSPRGqUj1cGZXbwN6TJ0/Pc+llLcZJd+2JQHcbZVkEnN+9NPOfXDIfSFt58yX9MwXNOgg5E
        KWWswo5/k9yBR/a8+f+QVAkAFi9Le7R9BHKLW1lSFSPr8HALSxGrr2sqrBrAoibMXXLP711uP676N
        GwOB6ylmkICPRtqkWwQCYuLlfLIQfHAN1aYi55Lc49wXsR+nmASeGRWuTtiEX88gmeuPKLTT5vKEB
        dn38xq82/PtSgEzmveRHuypLHLqEtz+FTWgESd4Oa+T31r7T9+NIkLOrl8YjgzK42rTySVezeXAF0
        T84el0RQ==;
Received: from [2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608] (helo=ulthar.dreamlands)
        by taras.nevrast.org with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.96)
        (envelope-from <jeremy@azazel.net>)
        id 1qfR4b-0006H3-29
        for netfilter-devel@vger.kernel.org;
        Sun, 10 Sep 2023 21:30:25 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH libmnl] nlmsg, attr: fix false positives when validating buffer sizes
Date:   Sun, 10 Sep 2023 21:30:18 +0100
Message-Id: <20230910203018.2782009-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

`mnl_nlmsg_ok` and `mnl_attr_ok` both expect a signed buffer length
value, `len`, against which to compare the size of the object expected
to fit into the buffer, because they are intended to validate the length
and it may be negative in the case of malformed messages.  Comparing
this signed value against unsigned operands leads to compiler warnings,
so the unsigned operands are cast to `int`.  Comparing `len` to the size
of the structure is fine, because the structures are only a few bytes in
size.  Comparing it to the length fields of `struct nlmsg` and `struct
nlattr`, however, is problematic, since these fields may hold values
greater than `INT_MAX`, in which case the casts will yield negative
values and result in false positives.

Instead, assign `len` to an unsigned local variable, check for negative
values first, then use the unsigned local for the other comparisons, and
remove the casts.

Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1691
Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 src/attr.c  | 9 +++++++--
 src/nlmsg.c | 9 +++++++--
 2 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/src/attr.c b/src/attr.c
index bc39df4199e7..48e95019d5e8 100644
--- a/src/attr.c
+++ b/src/attr.c
@@ -97,9 +97,14 @@ EXPORT_SYMBOL void *mnl_attr_get_payload(const struct nlattr *attr)
  */
 EXPORT_SYMBOL bool mnl_attr_ok(const struct nlattr *attr, int len)
 {
-	return len >= (int)sizeof(struct nlattr) &&
+	size_t ulen = len;
+
+	if (len < 0)
+		return 0;
+
+	return ulen          >= sizeof(struct nlattr) &&
 	       attr->nla_len >= sizeof(struct nlattr) &&
-	       (int)attr->nla_len <= len;
+	       attr->nla_len <= ulen;
 }
 
 /**
diff --git a/src/nlmsg.c b/src/nlmsg.c
index c63450174c67..920cad0e0f46 100644
--- a/src/nlmsg.c
+++ b/src/nlmsg.c
@@ -152,9 +152,14 @@ EXPORT_SYMBOL void *mnl_nlmsg_get_payload_offset(const struct nlmsghdr *nlh,
  */
 EXPORT_SYMBOL bool mnl_nlmsg_ok(const struct nlmsghdr *nlh, int len)
 {
-	return len >= (int)sizeof(struct nlmsghdr) &&
+	size_t ulen = len;
+
+	if (len < 0)
+		return 0;
+
+	return ulen           >= sizeof(struct nlmsghdr) &&
 	       nlh->nlmsg_len >= sizeof(struct nlmsghdr) &&
-	       (int)nlh->nlmsg_len <= len;
+	       nlh->nlmsg_len <= ulen;
 }
 
 /**
-- 
2.40.1

