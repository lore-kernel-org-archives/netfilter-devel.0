From: Eric Leblond <eric@regit.org>
Subject: [PATCH 4/4] graphite: fix warning about gnu extension usage
Date: Sat, 19 Jan 2013 10:53:51 +0100
Message-ID: <1358589231-1358-5-git-send-email-eric@regit.org>
References: <1358589231-1358-1-git-send-email-eric@regit.org>
Cc: eric@regit.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:37682 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906Ab3ASJyh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 19 Jan 2013 04:54:37 -0500
In-Reply-To: <1358589231-1358-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

clang is complaining about missing = being a gnu extension. This
patch adds equal sign to fix the warning.

Signed-off-by: Eric Leblond <eric@regit.org>
---
 output/ulogd_output_GRAPHITE.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/output/ulogd_output_GRAPHITE.c b/output/ulogd_output_GRAPHITE.c
index 25b578e..a4b31a5 100644
--- a/output/ulogd_output_GRAPHITE.c
+++ b/output/ulogd_output_GRAPHITE.c
@@ -42,19 +42,19 @@ enum {
 
 
 static struct ulogd_key graphite_inp[] = {
-	[KEY_SUM_NAME] {
+	[KEY_SUM_NAME] = {
 		.type	= ULOGD_RET_STRING,
 		.name	= "sum.name",
 	},
-	[KEY_SUM_PKTS] {
+	[KEY_SUM_PKTS] = {
 		.type	= ULOGD_RET_UINT64,
 		.name	= "sum.pkts",
 	},
-	[KEY_SUM_BYTES] {
+	[KEY_SUM_BYTES] = {
 		.type	= ULOGD_RET_UINT64,
 		.name	= "sum.bytes",
 	},
-	[KEY_OOB_TIME_SEC] {
+	[KEY_OOB_TIME_SEC] = {
 		.type = ULOGD_RET_UINT32,
 		.name = "oob.time.sec",
 	},
-- 
1.7.10.4

