Return-Path: <SRS0=kxmZ=T6=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C7FAC28CC0
	for <netfilter-devel@archiver.kernel.org>; Thu, 30 May 2019 10:55:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 77109257A0
	for <netfilter-devel@archiver.kernel.org>; Thu, 30 May 2019 10:55:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726668AbfE3Kzl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 30 May 2019 06:55:41 -0400
Received: from mail.us.es ([193.147.175.20]:35318 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726599AbfE3Kzk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 30 May 2019 06:55:40 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 5FF13C1DE8
        for <netfilter-devel@vger.kernel.org>; Thu, 30 May 2019 12:55:37 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4EE44DA703
        for <netfilter-devel@vger.kernel.org>; Thu, 30 May 2019 12:55:37 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 440EDDA715; Thu, 30 May 2019 12:55:37 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 45D1ADA705;
        Thu, 30 May 2019 12:55:35 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 30 May 2019 12:55:35 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 164054265A5B;
        Thu, 30 May 2019 12:55:35 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     phil@nwl.cc
Subject: [PATCH nft,v2 2/7] mnl: mnl_set_rcvbuffer() skips buffer size update if it is too small
Date:   Thu, 30 May 2019 12:55:24 +0200
Message-Id: <20190530105529.12657-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190530105529.12657-1-pablo@netfilter.org>
References: <20190530105529.12657-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Check for existing buffer size, if this is larger than the requested new
buffer size, skip the buffer size update.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/mnl.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/src/mnl.c b/src/mnl.c
index 288a887df097..a84a6a609333 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -235,8 +235,15 @@ static void mnl_set_sndbuffer(const struct mnl_socket *nl,
 
 static int mnl_set_rcvbuffer(const struct mnl_socket *nl, size_t bufsiz)
 {
+	size_t cur_bufsiz;
+	socklen_t len;
 	int ret;
 
+	ret = getsockopt(mnl_socket_get_fd(nl), SOL_SOCKET, SO_RCVBUF,
+			 &cur_bufsiz, &len);
+	if (cur_bufsiz > bufsiz)
+		return 0;
+
 	ret = setsockopt(mnl_socket_get_fd(nl), SOL_SOCKET, SO_RCVBUFFORCE,
 			 &bufsiz, sizeof(socklen_t));
 	if (ret < 0) {
-- 
2.11.0

