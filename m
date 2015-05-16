From: Felix Janda <felix.janda@posteo.de>
Subject: [libnetfilter_queue PATCH 4/4] tcp.c udp.c: Define _GNU_SOURCE to
 get members of tcphdr&ucphdr
Date: Sat, 16 May 2015 14:45:46 +0200
Message-ID: <20150516124546.GW14201@euler>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx02.posteo.de ([89.146.194.165]:59380 "EHLO mx02.posteo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753241AbbEPMqc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 16 May 2015 08:46:32 -0400
Received: from dovecot03.posteo.de (unknown [185.67.36.28])
	by mx02.posteo.de (Postfix) with ESMTPS id B9DED25A2115
	for <netfilter-devel@vger.kernel.org>; Sat, 16 May 2015 14:46:31 +0200 (CEST)
Received: from mail.posteo.de (localhost [127.0.0.1])
	by dovecot03.posteo.de (Postfix) with ESMTPSA id 3lpmZH3m0dz5vN8
	for <netfilter-devel@vger.kernel.org>; Sat, 16 May 2015 14:46:31 +0200 (CEST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The source uses linux names for members of tcphdr. For example
"source" instead of "th_sport", ... musl libc's headers need
_GNU_SOURCE defined in order to expose these.

Signed-off-by: Felix Janda <felix.janda@posteo.de>
---
 src/extra/tcp.c | 1 +
 src/extra/udp.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/src/extra/tcp.c b/src/extra/tcp.c
index bf161aa..d1cd79d 100644
--- a/src/extra/tcp.c
+++ b/src/extra/tcp.c
@@ -15,6 +15,7 @@
 #include <arpa/inet.h>
 #include <netinet/ip.h>
 #include <netinet/ip6.h>
+#define _GNU_SOURCE
 #include <netinet/tcp.h>
 
 #include <libnetfilter_queue/libnetfilter_queue.h>
diff --git a/src/extra/udp.c b/src/extra/udp.c
index 6e6baed..8c44a66 100644
--- a/src/extra/udp.c
+++ b/src/extra/udp.c
@@ -14,6 +14,7 @@
 #include <arpa/inet.h>
 #include <netinet/ip.h>
 #include <netinet/ip6.h>
+#define _GNU_SOURCE
 #include <netinet/udp.h>
 
 #include <libnetfilter_queue/libnetfilter_queue.h>
-- 
2.3.6
