Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C019DC4332F
	for <netfilter-devel@archiver.kernel.org>; Fri, 23 Dec 2022 21:56:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230383AbiLWV4d (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 23 Dec 2022 16:56:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229650AbiLWV4d (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 23 Dec 2022 16:56:33 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3888659C
        for <netfilter-devel@vger.kernel.org>; Fri, 23 Dec 2022 13:56:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=X8P/Kz4o8ZokJJSCDcjjbkr9A4FxH20O4C/XPkSC9VI=; b=LYZc/vBGuzQMyfymwiQYf0RWC5
        tQzlirDvop0v5endfNjyAmRQlcKiNEOGcXmYyaFmRQMNeslmOtOuHLw+Cae+j3MlG6SoaeUb+tF6L
        RCz6CSfRBdKNQEOifP3c/T6fuw3A735H9XBv0fscvZ9U+ag5BfwZZrTJs3FbC1nAiLu1y3ojvTzAM
        j8gfJxC8v3s71mLY0jlQ7dp6VAfEEXVKTqBkw1aqbyvtp4YJAdYmuU1eb97ccWKzeXrgMdW/L7BQt
        9ZZ7ANTZuvteXwKWZBxlb6RSE//NqHtx2SVXgXTv4P0hLC3QDNBbyKFVnd99ZV7mLgA5KcLsv1r2h
        A7sec0QQ==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1p8q1k-005nnj-Ra
        for netfilter-devel@vger.kernel.org; Fri, 23 Dec 2022 21:56:28 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH libmnl] doc: fix some non-native English usages
Date:   Fri, 23 Dec 2022 21:56:21 +0000
Message-Id: <20221223215621.2940577-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

"allows to" -> "allows ${pronoun} to".  We use "you" if that appears in context,
"one" otherwise.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 src/attr.c   | 14 +++++++-------
 src/nlmsg.c  |  6 +++---
 src/socket.c |  2 +-
 3 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/src/attr.c b/src/attr.c
index 838eab063981..2b1261d63a86 100644
--- a/src/attr.c
+++ b/src/attr.c
@@ -115,7 +115,7 @@ EXPORT_SYMBOL struct nlattr *mnl_attr_next(const struct nlattr *attr)
  * \param attr pointer to attribute to be checked
  * \param max maximum attribute type
  *
- * This function allows to check if the attribute type is higher than the
+ * This function allows one to check if the attribute type is higher than the
  * maximum supported type. If the attribute type is invalid, this function
  * returns -1 and errno is explicitly set. On success, this function returns 1.
  *
@@ -222,8 +222,8 @@ EXPORT_SYMBOL int mnl_attr_validate(const struct nlattr *attr, enum mnl_attr_dat
  * \param type attribute type (see enum mnl_attr_data_type)
  * \param exp_len expected attribute data size
  *
- * This function allows to perform a more accurate validation for attributes
- * whose size is variable. If the size of the attribute is not what we expect,
+ * This function allows one to perform a more accurate validation for attributes
+ * whose size is variable. If the size of the attribute is not what is expected,
  * this functions returns -1 and errno is explicitly set.
  */
 EXPORT_SYMBOL int mnl_attr_validate2(const struct nlattr *attr,
@@ -244,8 +244,8 @@ EXPORT_SYMBOL int mnl_attr_validate2(const struct nlattr *attr,
  * \param cb callback function that is called for each attribute
  * \param data pointer to data that is passed to the callback function
  *
- * This function allows to iterate over the sequence of attributes that compose
- * the Netlink message. You can then put the attribute in an array as it
+ * This function allows you to iterate over the sequence of attributes that
+ * compose the Netlink message. You can then put the attribute in an array as it
  * usually happens at this stage or you can use any other data structure (such
  * as lists or trees).
  *
@@ -271,8 +271,8 @@ EXPORT_SYMBOL int mnl_attr_parse(const struct nlmsghdr *nlh,
  * \param cb callback function that is called for each attribute in the nest
  * \param data pointer to data passed to the callback function
  *
- * This function allows to iterate over the sequence of attributes that compose
- * the Netlink message. You can then put the attribute in an array as it
+ * This function allows you to iterate over the sequence of attributes that
+ * compose the Netlink message. You can then put the attribute in an array as it
  * usually happens at this stage or you can use any other data structure (such
  * as lists or trees).
  *
diff --git a/src/nlmsg.c b/src/nlmsg.c
index ce37cbc63191..a42c2050471f 100644
--- a/src/nlmsg.c
+++ b/src/nlmsg.c
@@ -488,9 +488,9 @@ EXPORT_SYMBOL bool mnl_nlmsg_batch_next(struct mnl_nlmsg_batch *b)
  * mnl_nlmsg_batch_reset - reset the batch
  * \param b pointer to batch
  *
- * This function allows to reset a batch, so you can reuse it to create a
- * new one. This function moves the last message which does not fit the
- * batch to the head of the buffer, if any.
+ * This function allows you to reset a batch, so you can reuse it to create a
+ * new one. This function moves the last message which does not fit the batch to
+ * the head of the buffer, if any.
  */
 EXPORT_SYMBOL void mnl_nlmsg_batch_reset(struct mnl_nlmsg_batch *b)
 {
diff --git a/src/socket.c b/src/socket.c
index dbfb06c4f895..85b6bcc8048c 100644
--- a/src/socket.c
+++ b/src/socket.c
@@ -135,7 +135,7 @@ EXPORT_SYMBOL struct mnl_socket *mnl_socket_open(int bus)
  * \param bus the netlink socket bus ID (see NETLINK_* constants)
  * \param flags the netlink socket flags (see SOCK_* constants in socket(2))
  *
- * This is similar to mnl_socket_open(), but allows to set flags like
+ * This is similar to mnl_socket_open(), but allows one to set flags like
  * SOCK_CLOEXEC at socket creation time (useful for multi-threaded programs
  * performing exec calls).
  *
-- 
2.35.1

