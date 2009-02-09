From: Eric Leblond <eric@inl.fr>
Subject: [PATCH 7/7] netfilter: fix nflog timeout handling.
Date: Mon,  9 Feb 2009 22:11:16 +0100
Message-ID: <1234213876-8176-7-git-send-email-eric@inl.fr>
References: <49909B3E.0@inl.fr>
Cc: netfilter-devel@vger.kernel.org, Eric Leblond <eric@inl.fr>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:36907 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753765AbZBIVLX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 Feb 2009 16:11:23 -0500
In-Reply-To: <49909B3E.0@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

NFLOG timeout was computed in timer by doing:
 flushtimeout*HZ/100
Default value of flushtimeout was HZ (for 1 second delay). This was
wrong for non 100HZ computer. This patch modify the default delay by
using 100 instead of HZ.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 net/netfilter/nfnetlink_log.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index 88b455e..42e7de9 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -39,7 +39,7 @@
 #endif
 
 #define NFULNL_NLBUFSIZ_DEFAULT	NLMSG_GOODSIZE
-#define NFULNL_TIMEOUT_DEFAULT 	HZ	/* every second */
+#define NFULNL_TIMEOUT_DEFAULT 	100	/* every second */
 #define NFULNL_QTHRESH_DEFAULT 	100	/* 100 packets */
 #define NFULNL_COPY_RANGE_MAX	0xFFFF	/* max packet size is limited by 16-bit struct nfattr nfa_len field */
 
-- 
1.5.6.3

