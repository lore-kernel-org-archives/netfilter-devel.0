From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: [PATCH libmnl] nlmsg: introduce mnl_nlmsg_batch_rest to get the rest
 length
Date: Mon, 3 Apr 2017 15:11:27 +0900
Message-ID: <20170403061127.GA2329@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: The netfilter developer mailinglist
        <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:35405 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751141AbdDCGLb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 3 Apr 2017 02:11:31 -0400
Received: by mail-pg0-f67.google.com with SMTP id g2so27469889pge.2
        for <netfilter-devel@vger.kernel.org>; Sun, 02 Apr 2017 23:11:31 -0700 (PDT)
Received: from gmail.com (softbank218138040024.bbtec.net. [218.138.40.24])
        by smtp.gmail.com with ESMTPSA id w129sm23122319pfb.130.2017.04.02.23.11.29
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 02 Apr 2017 23:11:30 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Recent languages implements array to hold its length. This patch
enables to help to wrap these. As of this C library, we can use
this like below without double sized buffer.

    char buf[MNL_SOCKET_BUFFER_SIZE];

    b = mnl_nlmsg_batch_start(buf, sizeof(buf));
    nlbuf = mnl_nlmsg_batch_current(b);
    rest = mnl_nlmsg_batch_rest(b);
    if (rest < NLMSG_HDRLEN)
            return false;
    nlh = mnl_nlmsg_put_header(nlbuf);
    ...
    if (!mnl_attr_put_u8_check(nlh, rest, 1, 2))
            return false;
    ...

Signed-off-by: Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
---
 include/libmnl/libmnl.h |  1 +
 src/libmnl.map          |  4 ++++
 src/nlmsg.c             | 12 ++++++++++++
 3 files changed, 17 insertions(+)

diff --git a/include/libmnl/libmnl.h b/include/libmnl/libmnl.h
index 0331da7..8cfe137 100644
--- a/include/libmnl/libmnl.h
+++ b/include/libmnl/libmnl.h
@@ -76,6 +76,7 @@ extern void mnl_nlmsg_batch_reset(struct mnl_nlmsg_batch *b);
 extern void *mnl_nlmsg_batch_head(struct mnl_nlmsg_batch *b);
 extern void *mnl_nlmsg_batch_current(struct mnl_nlmsg_batch *b);
 extern bool mnl_nlmsg_batch_is_empty(struct mnl_nlmsg_batch *b);
+extern size_t mnl_nlmsg_batch_rest(const struct mnl_nlmsg_batch *b);
 
 /*
  * Netlink attributes API
diff --git a/src/libmnl.map b/src/libmnl.map
index e5920e5..97b31d7 100644
--- a/src/libmnl.map
+++ b/src/libmnl.map
@@ -77,3 +77,7 @@ LIBMNL_1.2 {
   mnl_socket_open2;
   mnl_socket_fdopen;
 } LIBMNL_1.1;
+
+LIBMNL_1.3 {
+  mnl_nlmsg_batch_rest;
+} LIBMNL_1.2;
diff --git a/src/nlmsg.c b/src/nlmsg.c
index f9448a5..614e434 100644
--- a/src/nlmsg.c
+++ b/src/nlmsg.c
@@ -562,5 +562,17 @@ bool mnl_nlmsg_batch_is_empty(struct mnl_nlmsg_batch *b)
 }
 
 /**
+ * mnl_nlmsg_batch_rest - get the rest of the batch buffer size
+ * \param b pointer to batch
+ *
+ * This function returns the rest of the batch buffer size
+ */
+EXPORT_SYMBOL(mnl_nlmsg_batch_rest);
+size_t mnl_nlmsg_batch_rest(const struct mnl_nlmsg_batch *b)
+{
+        return b->limit - b->buflen;
+}
+
+/**
  * @}
  */
-- 
2.11.0

