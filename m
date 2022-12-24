Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D588C4332F
	for <netfilter-devel@archiver.kernel.org>; Sat, 24 Dec 2022 17:35:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230247AbiLXRfu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 24 Dec 2022 12:35:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbiLXRfs (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 24 Dec 2022 12:35:48 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50485100A
        for <netfilter-devel@vger.kernel.org>; Sat, 24 Dec 2022 09:35:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=W5dFjwezf+1e0xwOos1cdb1TgX3Kfwp+s56mboCFY0M=; b=iFf0sB7/Ks+NYoHlOqsMw+Nl32
        VUO6y/oPI1Qdq+TIQklYVDAlDOLPdgekxFo1kOjrkLUUkRLvVHG9VwH8zWf+Q40N6rDjCXJKJyrrx
        YkAT9DCtrm/Eb8rsQWCayL3xHPFs7xfHoEa71fQe2rhHNkOJI63GFMOhUrl4kKcI+V2wtgdNqyjaM
        s+KWiPRiQU85qQOpFoo+7642d72Y3HZXrDhkk5NJdcSAENZiQakrsooS6JbCDn4i/hr4guSp9YlCU
        ElKEB3kmf4vfLKOpq+uYq5wBXICgNjtTT5ojHZYdAsRgewSPF6gj7ZXl+bqtrtJmvCuMItUkaDERf
        JZB4OfKA==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1p98Qz-006tyy-2B
        for netfilter-devel@vger.kernel.org; Sat, 24 Dec 2022 17:35:45 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH libmnl v2] doc: fix some non-native English usages
Date:   Sat, 24 Dec 2022 17:35:40 +0000
Message-Id: <20221224173540.3035470-1-jeremy@azazel.net>
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
Changes since v1:
  * rebased on to b923795047e7 ("Makefile: Create LZMA-compressed dist-files")

src/attr.c   | 12 ++++++------
 src/nlmsg.c  |  6 +++---
 src/socket.c |  2 +-
 3 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/src/attr.c b/src/attr.c
index 20d48a370524..bc39df4199e7 100644
--- a/src/attr.c
+++ b/src/attr.c
@@ -122,7 +122,7 @@ EXPORT_SYMBOL struct nlattr *mnl_attr_next(const struct nlattr *attr)
  * \param attr pointer to attribute to be checked
  * \param max maximum attribute type
  *
- * This function allows to check if the attribute type is higher than the
+ * This function allows one to check if the attribute type is higher than the
  * maximum supported type.
  *
  * Strict attribute checking in user-space is not a good idea since you may
@@ -236,7 +236,7 @@ EXPORT_SYMBOL int mnl_attr_validate(const struct nlattr *attr, enum mnl_attr_dat
  * \param type attribute type (see enum mnl_attr_data_type)
  * \param exp_len expected attribute data size
  *
- * This function allows to perform a more accurate validation for attributes
+ * This function allows one to perform a more accurate validation for attributes
  * whose size is variable.
  *
  * On an error, errno is explicitly set.
@@ -262,8 +262,8 @@ EXPORT_SYMBOL int mnl_attr_validate2(const struct nlattr *attr,
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
@@ -289,8 +289,8 @@ EXPORT_SYMBOL int mnl_attr_parse(const struct nlmsghdr *nlh,
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
index e7014bdc0b85..c63450174c67 100644
--- a/src/nlmsg.c
+++ b/src/nlmsg.c
@@ -518,9 +518,9 @@ EXPORT_SYMBOL bool mnl_nlmsg_batch_next(struct mnl_nlmsg_batch *b)
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

