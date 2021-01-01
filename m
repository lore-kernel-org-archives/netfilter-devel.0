Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19CA5C433DB
	for <netfilter-devel@archiver.kernel.org>; Fri,  1 Jan 2021 09:03:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C668020780
	for <netfilter-devel@archiver.kernel.org>; Fri,  1 Jan 2021 09:03:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726707AbhAAJDW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 1 Jan 2021 04:03:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726641AbhAAJDV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 1 Jan 2021 04:03:21 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C4EAC061575
        for <netfilter-devel@vger.kernel.org>; Fri,  1 Jan 2021 01:02:41 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id c124so8682391wma.5
        for <netfilter-devel@vger.kernel.org>; Fri, 01 Jan 2021 01:02:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3rTFGzMpliTK8eU+crhwZi2oWKxeWCChv9Szw1tH6ls=;
        b=uw/mgDP0gTqKkAYbkK77txB38aXInt1rUIUOaHfUH9K2OGoO8acPgOhwtiR9o2f7Q3
         M39rqiVjUy03PUJI60PwpPw7ghkYGUHolziH5JTO/W5fCxZyYn9pZFrMGFcJ+SiLg45O
         yQiecJbRIjvzrqq06/LI3KgfLQ6SHCSOHcE2K69LLpag8amGHSslnIRIz7X3VAPQALo1
         X7uC8F5nyrpFByXV5R0AgJOIjsxTSblIB3sPZQCDa/Tvi/O/8mJNsiyvyweMczwadima
         F/BdyAsFF+J5UuvSUfqadTwLPqGUYcB397yQ6GB81n4ehUSDDp1wsRLwIBvAX7PxaCy9
         0zwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3rTFGzMpliTK8eU+crhwZi2oWKxeWCChv9Szw1tH6ls=;
        b=Kp1HdwLw4pYIuy6GM4rB3r3Ay6XRr7vc8BNWrm0HiF1/DBAwW/tIztFohqUDCNUAmx
         OL7EJie4Qt+c0EDIELi1GfCCuv/Hjgd2t66H/koCMoFTZg998Fw5iIXSZYpYHJyZFTr6
         KhwRsssESRAvsL31QsuwVVNBZNIAbFp4VO7g2MMcXUXrzdRlHVdBHNtC93vfd7lYLCA5
         5vINIjXq7qlDZqZDzId0GYJHBn4IHFM+N3rdogYlJaJT9vSPNeFJvLB0nhXW3L8oFE3S
         RNi3BYN1OqJr8OF9yGAznYe0H24oVLK0yotwxBnUuEwZLtXMhMU2A/yNs8lVyOBUSnWf
         p6dQ==
X-Gm-Message-State: AOAM531a2zsGpukTFqvDCTlND9BfDf8umrNoxFDqz5M/0q5SdLrKKl7k
        ZTrG/4TWaWo9LPmARq/b4CquSc5glWZ1B5Fn
X-Google-Smtp-Source: ABdhPJxvlVGFinZgIHkZLg4v6YnZo85HE9HDJgpgGkMbsEja6l9MwTYM9MRxAM5WnjqPtRUvhO2wgg==
X-Received: by 2002:a7b:c751:: with SMTP id w17mr14644096wmk.121.1609491759671;
        Fri, 01 Jan 2021 01:02:39 -0800 (PST)
Received: from localhost.localdomain ([213.57.166.51])
        by smtp.gmail.com with ESMTPSA id c81sm15627587wmd.6.2021.01.01.01.02.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Jan 2021 01:02:39 -0800 (PST)
From:   Eyal Birger <eyal.birger@gmail.com>
To:     netfilter-devel@vger.kernel.org
Cc:     Eyal Birger <eyal.birger@gmail.com>
Subject: [PATCH libnetfilter_conntrack] examples: check return value of nfct_nlmsg_build()
Date:   Fri,  1 Jan 2021 11:02:26 +0200
Message-Id: <20210101090226.3237589-1-eyal.birger@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

nfct_nlmsg_build() may fail for different reasons, for example if
insufficient parameters exist in the ct object. The resulting nlh would
not contain any of the ct attributes.

Some conntrack operations would still operate in such case, for example
an IPCTNL_MSG_CT_DELETE message would just delete all existing conntrack
entries.

While the example as it is does supply correct parameters, it's safer
as reference to validate the return value.

Signed-off-by: Eyal Birger <eyal.birger@gmail.com>
---
 examples/nfct-mnl-create.c    | 6 +++++-
 examples/nfct-mnl-del.c       | 6 +++++-
 examples/nfct-mnl-get.c       | 6 +++++-
 examples/nfct-mnl-set-label.c | 7 ++++++-
 4 files changed, 21 insertions(+), 4 deletions(-)

diff --git a/examples/nfct-mnl-create.c b/examples/nfct-mnl-create.c
index 64387a7..7fd224d 100644
--- a/examples/nfct-mnl-create.c
+++ b/examples/nfct-mnl-create.c
@@ -60,7 +60,11 @@ int main(void)
 	nfct_set_attr_u8(ct, ATTR_TCP_STATE, TCP_CONNTRACK_SYN_SENT);
 	nfct_set_attr_u32(ct, ATTR_TIMEOUT, 100);
 
-	nfct_nlmsg_build(nlh, ct);
+	ret = nfct_nlmsg_build(nlh, ct);
+	if (ret == -1) {
+		perror("nfct_nlmsg_build");
+		exit(EXIT_FAILURE);
+	}
 
 	ret = mnl_socket_sendto(nl, nlh, nlh->nlmsg_len);
 	if (ret == -1) {
diff --git a/examples/nfct-mnl-del.c b/examples/nfct-mnl-del.c
index 91ad9e4..806d9f8 100644
--- a/examples/nfct-mnl-del.c
+++ b/examples/nfct-mnl-del.c
@@ -55,7 +55,11 @@ int main(void)
 	nfct_set_attr_u16(ct, ATTR_PORT_SRC, htons(20));
 	nfct_set_attr_u16(ct, ATTR_PORT_DST, htons(10));
 
-	nfct_nlmsg_build(nlh, ct);
+	ret = nfct_nlmsg_build(nlh, ct);
+	if (ret == -1) {
+		perror("nfct_nlmsg_build");
+		exit(EXIT_FAILURE);
+	}
 
 	ret = mnl_socket_sendto(nl, nlh, nlh->nlmsg_len);
 	if (ret == -1) {
diff --git a/examples/nfct-mnl-get.c b/examples/nfct-mnl-get.c
index 4858acf..5be3331 100644
--- a/examples/nfct-mnl-get.c
+++ b/examples/nfct-mnl-get.c
@@ -74,7 +74,11 @@ int main(void)
 	nfct_set_attr_u16(ct, ATTR_PORT_SRC, htons(20));
 	nfct_set_attr_u16(ct, ATTR_PORT_DST, htons(10));
 
-	nfct_nlmsg_build(nlh, ct);
+	ret = nfct_nlmsg_build(nlh, ct);
+	if (ret == -1) {
+		perror("nfct_nlmsg_build");
+		exit(EXIT_FAILURE);
+	}
 
 	ret = mnl_socket_sendto(nl, nlh, nlh->nlmsg_len);
 	if (ret == -1) {
diff --git a/examples/nfct-mnl-set-label.c b/examples/nfct-mnl-set-label.c
index c52b267..50bebb0 100644
--- a/examples/nfct-mnl-set-label.c
+++ b/examples/nfct-mnl-set-label.c
@@ -19,6 +19,7 @@ static void set_label(struct nf_conntrack *ct, struct callback_args *cbargs)
 	char buf[MNL_SOCKET_BUFFER_SIZE];
 	struct nlmsghdr *nlh;
 	struct nfgenmsg *nfh;
+	int ret;
 
 	if (b) {
 		if (bit < 0)
@@ -55,7 +56,11 @@ static void set_label(struct nf_conntrack *ct, struct callback_args *cbargs)
 	nfh->version = NFNETLINK_V0;
 	nfh->res_id = 0;
 
-	nfct_nlmsg_build(nlh, ct);
+	ret = nfct_nlmsg_build(nlh, ct);
+	if (ret == -1) {
+		perror("nfct_nlmsg_build");
+		exit(EXIT_FAILURE);
+	}
 
 	if (mnl_socket_sendto(cbargs->nl, nlh, nlh->nlmsg_len) < 0)
 		perror("mnl_socket_sendto");
-- 
2.25.1

