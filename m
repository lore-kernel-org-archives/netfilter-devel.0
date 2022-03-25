Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47DC8C433F5
	for <netfilter-devel@archiver.kernel.org>; Fri, 25 Mar 2022 10:50:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350532AbiCYKwW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 25 Mar 2022 06:52:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350623AbiCYKwV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 25 Mar 2022 06:52:21 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A356CC527
        for <netfilter-devel@vger.kernel.org>; Fri, 25 Mar 2022 03:50:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=a8nqq7Hysg+kbBp1hoJnYHEtbG4N5bBlPRy5AkGClNA=; b=W6Kbpf4Tq3cERBjMWaPCL8WbLN
        WfrcNF9/gVxc+5I7YcwHOmrAeJw0AxtJeCeR3NeYyishUE9xhU73kEkYMvtpXFxMBRlb4vVGOoW8m
        zfE1DgiXDqelvWxeGvRNDz3xuZemPZTEbFIXihOV4ptI1LUssVxbll9/SM+9+peCXHYkaV6O+9aPh
        0gEFNkJc96v6TdA4ovDkYaiOBm4sqmYmXLK37Owi8F3vd+YeNFFOJMhY0ZwxENLZxP6vQjPR4X5R3
        Kg9hQm2uof6RGYFS4wM07bO7GtfLVLpCUvyOaIa9uPW8W9B88mnr3s0Df9R21jO01GZ4ynoRIU8i5
        cJP+tOZQ==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nXhWo-00081D-P2; Fri, 25 Mar 2022 11:50:46 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [conntrack-tools PATCH 3/8] Fix potential buffer overrun in snprintf() calls
Date:   Fri, 25 Mar 2022 11:49:58 +0100
Message-Id: <20220325105003.26621-4-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220325105003.26621-1-phil@nwl.cc>
References: <20220325105003.26621-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

When consecutively printing into the same buffer at increasing offset,
reduce buffer size passed to snprintf() to not defeat its size checking.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/process.c | 2 +-
 src/queue.c   | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/src/process.c b/src/process.c
index 3ddad5ffa7959..08598eeae84de 100644
--- a/src/process.c
+++ b/src/process.c
@@ -84,7 +84,7 @@ void fork_process_dump(int fd)
 	int size = 0;
 
 	list_for_each_entry(this, &process_list, head) {
-		size += snprintf(buf+size, sizeof(buf),
+		size += snprintf(buf + size, sizeof(buf) - size,
 				 "PID=%u type=%s\n",
 				 this->pid,
 				 this->type < CTD_PROC_MAX ?
diff --git a/src/queue.c b/src/queue.c
index 76425b18495b5..e94dc7c45d1fd 100644
--- a/src/queue.c
+++ b/src/queue.c
@@ -69,12 +69,12 @@ void queue_stats_show(int fd)
 	int size = 0;
 	char buf[512];
 
-	size += snprintf(buf+size, sizeof(buf),
+	size += snprintf(buf + size, sizeof(buf) - size,
 			 "allocated queue nodes:\t\t%12u\n\n",
 			 qobjects_num);
 
 	list_for_each_entry(this, &queue_list, list) {
-		size += snprintf(buf+size, sizeof(buf),
+		size += snprintf(buf + size, sizeof(buf) - size,
 				 "queue %s:\n"
 				 "current elements:\t\t%12u\n"
 				 "maximum elements:\t\t%12u\n"
-- 
2.34.1

