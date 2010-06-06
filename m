From: Shan Wei <shanwei@cn.fujitsu.com>
Subject: [IPTABLES][PATCH 2/2] xt_sctp: support FORWARD_TSN chunk type
Date: Mon, 07 Jun 2010 02:08:22 +0800
Message-ID: <4C0BE416.4070503@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: linux-sctp@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:51331 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752724Ab0FGCI2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 6 Jun 2010 22:08:28 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The latest kernel has implemented Partial Reliability Extension
that defined in RFC3758.

This patch adds FORWARD_TSN chunk for tracing.

Signed-off-by: Shan Wei<shanwei@cn.fujitsu.com>
---
 extensions/libxt_sctp.c   |    1 +
 extensions/libxt_sctp.man |    2 +-
 2 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/extensions/libxt_sctp.c b/extensions/libxt_sctp.c
index 92bdb07..8f352fd 100644
--- a/extensions/libxt_sctp.c
+++ b/extensions/libxt_sctp.c
@@ -114,6 +114,7 @@ static const struct sctp_chunk_names sctp_chunk_names[]
     { .name = "SHUTDOWN_COMPLETE", .chunk_type = 14,  .valid_flags = "-------T"},
     { .name = "ASCONF",		.chunk_type = 193,  .valid_flags = "--------"},
     { .name = "ASCONF_ACK",	.chunk_type = 128,  .valid_flags = "--------"},
+    { .name = "FORWARD_TSN",	.chunk_type = 192,  .valid_flags = "--------"},
 };
 
 static void
diff --git a/extensions/libxt_sctp.man b/extensions/libxt_sctp.man
index 01a2e79..eefc850 100644
--- a/extensions/libxt_sctp.man
+++ b/extensions/libxt_sctp.man
@@ -7,7 +7,7 @@
 The flag letter in upper case indicates that the flag is to match if set,
 in the lower case indicates to match if unset.
 
-Chunk types: DATA INIT INIT_ACK SACK HEARTBEAT HEARTBEAT_ACK ABORT SHUTDOWN SHUTDOWN_ACK ERROR COOKIE_ECHO COOKIE_ACK ECN_ECNE ECN_CWR SHUTDOWN_COMPLETE ASCONF ASCONF_ACK
+Chunk types: DATA INIT INIT_ACK SACK HEARTBEAT HEARTBEAT_ACK ABORT SHUTDOWN SHUTDOWN_ACK ERROR COOKIE_ECHO COOKIE_ACK ECN_ECNE ECN_CWR SHUTDOWN_COMPLETE ASCONF ASCONF_ACK FORWARD_TSN
 
 chunk type            available flags      
 .br
-- 
1.6.3.3

