From: Felix Janda <felix.janda@posteo.de>
Subject: [PATCH libnetfilter_queue] libnetfilter_queue.h: Include
 <sys/time.h> for struct timeval
Date: Tue, 16 Jun 2015 21:23:04 +0200
Message-ID: <20150616192304.GA3247@euler>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx02.posteo.de ([89.146.194.165]:44650 "EHLO mx02.posteo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753324AbbFPTX1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Jun 2015 15:23:27 -0400
Received: from dovecot04.posteo.de (unknown [185.67.36.27])
	by mx02.posteo.de (Postfix) with ESMTPS id 61C1C25C00BA
	for <netfilter-devel@vger.kernel.org>; Tue, 16 Jun 2015 21:23:26 +0200 (CEST)
Received: from mail.posteo.de (localhost [127.0.0.1])
	by dovecot04.posteo.de (Postfix) with ESMTPSA id 3m9zvy21PdzFpW0
	for <netfilter-devel@vger.kernel.org>; Tue, 16 Jun 2015 21:23:26 +0200 (CEST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Felix Janda <felix.janda@posteo.de>
---
 include/libnetfilter_queue/libnetfilter_queue.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/libnetfilter_queue/libnetfilter_queue.h b/include/libnetfilter_queue/libnetfilter_queue.h
index 8194a4f..10e15d8 100644
--- a/include/libnetfilter_queue/libnetfilter_queue.h
+++ b/include/libnetfilter_queue/libnetfilter_queue.h
@@ -13,6 +13,7 @@
 #ifndef __LIBCTNETLINK_H
 #define __LIBCTNETLINK_H
 
+#include <sys/time.h>
 #include <libnfnetlink/libnfnetlink.h>
 // #include <libnfnetlink/liunx_nfnetlink.h>
 
-- 
2.3.6
