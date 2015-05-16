From: Felix Janda <felix.janda@posteo.de>
Subject: [conntrack-tools PATCH 4/6] Include <sys/select.h> for fd_set
Date: Sat, 16 May 2015 11:50:25 +0200
Message-ID: <20150516094004.GF14201@euler>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx02.posteo.de ([89.146.194.165]:44078 "EHLO mx02.posteo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932183AbbEPJur (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 16 May 2015 05:50:47 -0400
Received: from dovecot03.posteo.de (unknown [185.67.36.28])
	by mx02.posteo.de (Postfix) with ESMTPS id 6343225AF52C
	for <netfilter-devel@vger.kernel.org>; Sat, 16 May 2015 11:50:46 +0200 (CEST)
Received: from mail.posteo.de (localhost [127.0.0.1])
	by dovecot03.posteo.de (Postfix) with ESMTPSA id 3lphgV1rxMz5vN2
	for <netfilter-devel@vger.kernel.org>; Sat, 16 May 2015 11:50:46 +0200 (CEST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Felix Janda <felix.janda@posteo.de>
---
 include/mcast.h | 1 +
 include/tcp.h   | 1 +
 include/udp.h   | 1 +
 3 files changed, 3 insertions(+)

diff --git a/include/mcast.h b/include/mcast.h
index 402a033..f0225aa 100644
--- a/include/mcast.h
+++ b/include/mcast.h
@@ -4,6 +4,7 @@
 #include <stdint.h>
 #include <netinet/in.h>
 #include <net/if.h>
+#include <sys/select.h>
 
 struct mcast_conf {
 	int ipproto;
diff --git a/include/tcp.h b/include/tcp.h
index 2f0fd0a..068d43a 100644
--- a/include/tcp.h
+++ b/include/tcp.h
@@ -3,6 +3,7 @@
 
 #include <stdint.h>
 #include <netinet/in.h>
+#include <sys/select.h>
 
 struct tcp_conf {
 	int ipproto;
diff --git a/include/udp.h b/include/udp.h
index 9f9c17a..53d713d 100644
--- a/include/udp.h
+++ b/include/udp.h
@@ -3,6 +3,7 @@
 
 #include <stdint.h>
 #include <netinet/in.h>
+#include <sys/select.h>
 
 struct udp_conf {
 	int ipproto;
-- 
2.3.6
