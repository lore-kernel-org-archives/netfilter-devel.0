From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD2 PATCH 08/11] Suppress twice defined key.
Date: Sun, 27 Jul 2008 15:51:23 +0200
Message-ID: <1217166686-28508-9-git-send-email-eric@inl.fr>
References: <20080723162746.GB31572@bayen.regit.org>
Cc: Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:43803 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751935AbYG0Nv3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 27 Jul 2008 09:51:29 -0400
In-Reply-To: <20080723162746.GB31572@bayen.regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch fixes a multiple definition of the key TCP_URG.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 util/printpkt.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/util/printpkt.c b/util/printpkt.c
index 5359b8b..29c2ea4 100644
--- a/util/printpkt.c
+++ b/util/printpkt.c
@@ -76,7 +76,6 @@ struct ulogd_key printpkt_keys[] = {
 	[KEY_TCP_WINDOW]	= { .name = "tcp.window", },
 	[KEY_TCP_SYN]		= { .name = "tcp.syn", },
 	[KEY_TCP_ACK]		= { .name = "tcp.ack", },
-	[KEY_TCP_URG]		= { .name = "tcp.urg", },
 	[KEY_TCP_PSH]		= { .name = "tcp.psh", },
 	[KEY_TCP_RST]		= { .name = "tcp.rst", },
 	[KEY_TCP_FIN]		= { .name = "tcp.fin", },
-- 
1.5.4.3

