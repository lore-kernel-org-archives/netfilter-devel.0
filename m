From: Felix Janda <felix.janda@posteo.de>
Subject: [ulogd2 PATCH 4/4] Define _GNU_SOURCE to get members of tcphdr
Date: Sat, 16 May 2015 15:44:32 +0200
Message-ID: <20150516133834.GE14201@euler>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx02.posteo.de ([89.146.194.165]:42312 "EHLO mx02.posteo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750905AbbEPNos (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 16 May 2015 09:44:48 -0400
Received: from dovecot03.posteo.de (unknown [185.67.36.28])
	by mx02.posteo.de (Postfix) with ESMTPS id D574425A211F
	for <netfilter-devel@vger.kernel.org>; Sat, 16 May 2015 15:44:46 +0200 (CEST)
Received: from mail.posteo.de (localhost [127.0.0.1])
	by dovecot03.posteo.de (Postfix) with ESMTPSA id 3lpnsV3wngz5vN4
	for <netfilter-devel@vger.kernel.org>; Sat, 16 May 2015 15:44:46 +0200 (CEST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The source uses linux names for members of tcphdr. For example
"source" instead of "th_sport", ... musl libc's headers need
_GNU_SOURCE defined in order to expose these.

Signed-off-by: Felix Janda <felix.janda@posteo.de>
---
 filter/raw2packet/ulogd_raw2packet_BASE.c | 1 +
 filter/ulogd_filter_PWSNIFF.c             | 1 +
 2 files changed, 2 insertions(+)

diff --git a/filter/raw2packet/ulogd_raw2packet_BASE.c b/filter/raw2packet/ulogd_raw2packet_BASE.c
index 2079c91..9978b94 100644
--- a/filter/raw2packet/ulogd_raw2packet_BASE.c
+++ b/filter/raw2packet/ulogd_raw2packet_BASE.c
@@ -35,6 +35,7 @@
 #include <netinet/ip.h>
 #include <netinet/ip6.h>
 #include <netinet/in.h>
+#define _GNU_SOURCE
 #include <netinet/tcp.h>
 #include <netinet/ip_icmp.h>
 #include <netinet/icmp6.h>
diff --git a/filter/ulogd_filter_PWSNIFF.c b/filter/ulogd_filter_PWSNIFF.c
index 3d965e6..934ff0e 100644
--- a/filter/ulogd_filter_PWSNIFF.c
+++ b/filter/ulogd_filter_PWSNIFF.c
@@ -25,6 +25,7 @@
 #include <sys/socket.h>
 #include <netinet/ip.h>
 #include <netinet/in.h>
+#define _GNU_SOURCE
 #include <netinet/tcp.h>
 #include <ulogd/ulogd.h>
 
-- 
2.3.6
