From: Shan Wei <shanwei@cn.fujitsu.com>
Subject: [IPTABLES][PATCH 1/2] xt_sctp: Trace DATA chunk that supports SACK-IMMEDIATELY
 extension
Date: Mon, 07 Jun 2010 02:08:08 +0800
Message-ID: <4C0BE408.7070606@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, linux-sctp@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:62198 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752724Ab0FGCIS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 6 Jun 2010 22:08:18 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

SACK-IMMEDIATELY extension has defined in: 
http://tools.ietf.org/html/draft-tuexen-tsvwg-sctp-sack-immediately-03.

And the latest kernel has added a I flag in DATA chunk to support this extension.
So let iptables/netfilter can trace it.

Signed-off-by: Shan Wei<shanwei@cn.fujitsu.com>
---
 extensions/libxt_sctp.c   |    2 +-
 extensions/libxt_sctp.man |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/extensions/libxt_sctp.c b/extensions/libxt_sctp.c
index 441f12e..92bdb07 100644
--- a/extensions/libxt_sctp.c
+++ b/extensions/libxt_sctp.c
@@ -97,7 +97,7 @@ struct sctp_chunk_names {
 
 /*'ALL' and 'NONE' will be treated specially. */
 static const struct sctp_chunk_names sctp_chunk_names[]
-= { { .name = "DATA", 		.chunk_type = 0,   .valid_flags = "-----UBE"},
+= { { .name = "DATA", 		.chunk_type = 0,   .valid_flags = "----IUBE"},
     { .name = "INIT", 		.chunk_type = 1,   .valid_flags = "--------"},
     { .name = "INIT_ACK", 	.chunk_type = 2,   .valid_flags = "--------"},
     { .name = "SACK",		.chunk_type = 3,   .valid_flags = "--------"},
diff --git a/extensions/libxt_sctp.man b/extensions/libxt_sctp.man
index 1ecf05c..01a2e79 100644
--- a/extensions/libxt_sctp.man
+++ b/extensions/libxt_sctp.man
@@ -11,7 +11,7 @@ Chunk types: DATA INIT INIT_ACK SACK HEARTBEAT HEARTBEAT_ACK ABORT SHUTDOWN SHUT
 
 chunk type            available flags      
 .br
-DATA                  U B E u b e         
+DATA                  I U B E i u b e         
 .br
 ABORT                 T t                 
 .br
-- 
1.6.3.3

