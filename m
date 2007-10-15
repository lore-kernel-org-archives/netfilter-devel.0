From: lizf <lizf@cn.fujitsu.com>
Subject: Re: [PATCH 2/2] netfilter: remove ELEMCOUNT]
Date: Mon, 15 Oct 2007 18:07:21 +0800
Message-ID: <47133BD9.2090103@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------030209050805020805070700"
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from [222.73.24.84] ([222.73.24.84]:61202 "EHLO song.cn.fujitsu.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757249AbXJOKJb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Oct 2007 06:09:31 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------030209050805020805070700
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


Sorry for the noise. I have to resend this patch due to the
mailer replaced tabs to spaces. This patch remove macro ELEMCOUNT
and fix a bug in SCTP_CHUNKMAP_COPY.

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
-


--------------030209050805020805070700
Content-Type: text/x-patch;
 name="remove_ELEMCOUNT.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="remove_ELEMCOUNT.patch"

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

--------------030209050805020805070700--
