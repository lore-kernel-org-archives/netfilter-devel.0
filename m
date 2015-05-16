From: Felix Janda <felix.janda@posteo.de>
Subject: [conntrack-tools PATCH 6/6] src/netlink: Use <fcntl.h> instead of
 legacy synonym <sys/fcntl.h>
Date: Sat, 16 May 2015 12:20:25 +0200
Message-ID: <20150516100621.GH14201@euler>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx02.posteo.de ([89.146.194.165]:59446 "EHLO mx02.posteo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752500AbbEPKVo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 16 May 2015 06:21:44 -0400
Received: from dovecot03.posteo.de (unknown [185.67.36.28])
	by mx02.posteo.de (Postfix) with ESMTPS id 087F625A3DC1
	for <netfilter-devel@vger.kernel.org>; Sat, 16 May 2015 12:21:43 +0200 (CEST)
Received: from mail.posteo.de (localhost [127.0.0.1])
	by dovecot03.posteo.de (Postfix) with ESMTPSA id 3lpjMB6BKnz5vN7
	for <netfilter-devel@vger.kernel.org>; Sat, 16 May 2015 12:21:42 +0200 (CEST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Felix Janda <felix.janda@posteo.de>
---
 src/netlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/netlink.c b/src/netlink.c
index 5be102e..189f55a 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -26,7 +26,7 @@
 #include <errno.h>
 #include <sys/types.h>
 #include <sys/socket.h>
-#include <sys/fcntl.h>
+#include <fcntl.h>
 #include <libnetfilter_conntrack/libnetfilter_conntrack_tcp.h>
 
 struct nfct_handle *nl_init_event_handler(void)
-- 
2.3.6
