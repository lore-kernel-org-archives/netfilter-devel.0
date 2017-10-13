From: Harsha Sharma <harshasharmaiitr@gmail.com>
Subject: [PATCH] src: Remove unnecessary cast on void pointer
Date: Fri, 13 Oct 2017 05:31:16 +0530
Message-ID: <20171013000116.20107-1-harshasharmaiitr@gmail.com>
Cc: netfilter-devel@vger.kernel.org, outreachy-kernel@googlegroups.com,
        Harsha Sharma <harshasharmaiitr@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:56351 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757374AbdJMAES (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 12 Oct 2017 20:04:18 -0400
Received: by mail-pf0-f196.google.com with SMTP id b85so7228279pfj.13
        for <netfilter-devel@vger.kernel.org>; Thu, 12 Oct 2017 17:04:18 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Done with following coccinelle patch

@r@
expression x;
void* e;
type T;
identifier f;
@@
(
  *((T *)e)
|
  ((T *)x)[...]
|
  ((T*)x)->f
|

- (T*)
  e
)

Signed-off-by: Harsha Sharma <harshasharmaiitr@gmail.com>
---
 src/netlink.c | 2 +-
 src/tcpopt.c  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/netlink.c b/src/netlink.c
index d5d410a..3a7ae62 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -2941,7 +2941,7 @@ static int netlink_events_cb(const struct nlmsghdr *nlh, void *data)
 {
 	int ret = MNL_CB_OK;
 	uint16_t type = NFNL_MSG_TYPE(nlh->nlmsg_type);
-	struct netlink_mon_handler *monh = (struct netlink_mon_handler *)data;
+	struct netlink_mon_handler *monh = data;
 
 	netlink_events_debug(type, monh->debug_mask);
 	netlink_events_cache_update(monh, nlh, type);
diff --git a/src/tcpopt.c b/src/tcpopt.c
index 7c6c255..c37c9d5 100644
--- a/src/tcpopt.c
+++ b/src/tcpopt.c
@@ -86,7 +86,7 @@ static const struct exthdr_desc tcpopt_timestamp = {
 };
 #undef PHT
 
-#define TCPOPT_OBSOLETE ((struct exthdr_desc *)NULL)
+#define TCPOPT_OBSOLETE (NULL)
 #define TCPOPT_ECHO 6
 #define TCPOPT_ECHO_REPLY 7
 static const struct exthdr_desc *tcpopt_protocols[] = {
-- 
2.11.0

