From: lizf <lizf@cn.fujitsu.com>
Subject: Re: [PATCH 2/2] netfilter: remove ELEMCOUNT
Date: Fri, 12 Oct 2007 14:07:04 +0800
Message-ID: <470F0F08.7020009@cn.fujitsu.com>
References: <470F0A8F.7010804@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: kaber@trash.net, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from [222.73.24.84] ([222.73.24.84]:59727 "EHLO song.cn.fujitsu.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750856AbXJLGJU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 12 Oct 2007 02:09:20 -0400
In-Reply-To: <470F0A8F.7010804@cn.fujitsu.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


Sorry, I forgot to add the 'signed-off-by'. I resended the patch.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com> 

---
xt_sctp.h |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/include/linux/netfilter/xt_sctp.h b/include/linux/netfilter/xt_sctp.h
index b157897..dd5a4fd 100644
--- a/include/linux/netfilter/xt_sctp.h
+++ b/include/linux/netfilter/xt_sctp.h
@@ -7,9 +7,6 @@
 
 #define XT_SCTP_VALID_FLAGS		0x07
 
-#define ELEMCOUNT(x) (sizeof(x)/sizeof(x[0]))
-
-
 struct xt_sctp_flag_info {
 	u_int8_t chunktype;
 	u_int8_t flag;
@@ -59,21 +56,21 @@ struct xt_sctp_info {
 #define SCTP_CHUNKMAP_RESET(chunkmap) 				\
 	do {							\
 		int i; 						\
-		for (i = 0; i < ELEMCOUNT(chunkmap); i++)	\
+		for (i = 0; i < ARRAY_SIZE(chunkmap); i++)	\
 			chunkmap[i] = 0;			\
 	} while (0)
 
 #define SCTP_CHUNKMAP_SET_ALL(chunkmap) 			\
 	do {							\
 		int i; 						\
-		for (i = 0; i < ELEMCOUNT(chunkmap); i++) 	\
+		for (i = 0; i < ARRAY_SIZE(chunkmap); i++) 	\
 			chunkmap[i] = ~0;			\
 	} while (0)
 
 #define SCTP_CHUNKMAP_COPY(destmap, srcmap) 			\
 	do {							\
 		int i; 						\
-		for (i = 0; i < ELEMCOUNT(chunkmap); i++) 	\
+		for (i = 0; i < ARRAY_SIZE(srcmap); i++) 	\
 			destmap[i] = srcmap[i];			\
 	} while (0)
 
@@ -81,7 +78,7 @@ struct xt_sctp_info {
 ({							\
 	int i; 						\
 	int flag = 1;					\
-	for (i = 0; i < ELEMCOUNT(chunkmap); i++) {	\
+	for (i = 0; i < ARRAY_SIZE(chunkmap); i++) {	\
 		if (chunkmap[i]) {			\
 			flag = 0;			\
 			break;				\
@@ -94,7 +91,7 @@ struct xt_sctp_info {
 ({							\
 	int i; 						\
 	int flag = 1;					\
-	for (i = 0; i < ELEMCOUNT(chunkmap); i++) {	\
+	for (i = 0; i < ARRAY_SIZE(chunkmap); i++) {	\
 		if (chunkmap[i] != ~0) {		\
 			flag = 0;			\
 				break;			\
