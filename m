From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: libmnl [PATCH 3/5] examples: use mnl_nlmsg_get_payload()
Date: Thu, 5 Dec 2013 19:16:48 +0900
Message-ID: <CAGCkEt0U7wEmzWWK+TiqDjaEjcMEA1VyYQyCFoqUfYy20u4rfg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qc0-f178.google.com ([209.85.216.178]:49306 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751887Ab3LEKQt (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 5 Dec 2013 05:16:49 -0500
Received: by mail-qc0-f178.google.com with SMTP id i17so4601797qcy.23
        for <netfilter-devel@vger.kernel.org>; Thu, 05 Dec 2013 02:16:48 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
Date: Mon, 25 Nov 2013 15:36:28 +0900
Subject: [PATCH 3/5] examples: use mnl_nlmsg_get_payload()

not increment (nlmsghdr) pointer
---
 examples/netfilter/nfct-create-batch.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/examples/netfilter/nfct-create-batch.c
b/examples/netfilter/nfct-create-batch.c
index 40cd2f6..a232991 100644
--- a/examples/netfilter/nfct-create-batch.c
+++ b/examples/netfilter/nfct-create-batch.c
@@ -67,7 +67,7 @@ static void put_msg(char *buf, uint16_t i, int seq)

 static int cb_err(const struct nlmsghdr *nlh, void *data)
 {
-       struct nlmsgerr *err = (void *)(nlh + 1);
+       struct nlmsgerr *err = (void *)mnl_nlmsg_get_payload(nlh);
        if (err->error != 0)
                printf("message with seq %u has failed: %s\n",
                        nlh->nlmsg_seq, strerror(-err->error));
--
1.7.10.4
