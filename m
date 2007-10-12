From: lizf <lizf@cn.fujitsu.com>
Subject: [PATCH] extension/sctp: fix - mistake to pass a pointer where array
 is required
Date: Fri, 12 Oct 2007 13:35:59 +0800
Message-ID: <470F07BF.80606@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: kaber@trash.net, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from [222.73.24.84] ([222.73.24.84]:53490 "EHLO song.cn.fujitsu.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932398AbXJLFiG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 12 Oct 2007 01:38:06 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi,

Macros like SCTP_CHUNKMAP_XXX(chukmap) require chukmap to be an array,
We can see from below:
 
#define ELEMCOUNT(x) (sizeof(x)/sizeof(x[0]))

#define SCTP_CHUNKMAP_RESET(chunkmap)				\
	do {							\
	int i;							\
		for (i = 0; i < ELEMCOUNT(chunkmap); i++)	\
		chunkmap[i] = 0;				\
	} while (0)

But print_chunks() passes a pointer to these macros. Here's the patch. 

--- iptables.orig/extensions/libxt_sctp.c	2007-10-12 11:04:23.000000000 +0800
+++ iptables/extensions/libxt_sctp.c	2007-10-12 11:10:11.000000000 +0800
@@ -398,15 +398,15 @@ print_chunk(u_int32_t chunknum, int nume
 }
 
 static void
-print_chunks(u_int32_t chunk_match_type, 
-	     const u_int32_t *chunkmap, 
-	     const struct xt_sctp_flag_info *flag_info,
-	     int flag_count,
-	     int numeric)
+print_chunks(const struct xt_sctp_info *einfo, int numeric)
 {
 	int i, j;
 	int flag;
 
+	u_int32_t chunk_match_type = einfo->chunk_match_type;
+	const struct xt_sctp_flag_info *flag_info = einfo->flag_info;
+	int flag_count = einfo->flag_count;
+
 	switch (chunk_match_type) {
 		case SCTP_CHUNK_MATCH_ANY:	printf("any "); break;
 		case SCTP_CHUNK_MATCH_ALL:	printf("all "); break;
@@ -414,19 +414,19 @@ print_chunks(u_int32_t chunk_match_type,
 		default:	printf("Never reach herer\n"); break;
 	}
 
-	if (SCTP_CHUNKMAP_IS_CLEAR(chunkmap)) {
+	if (SCTP_CHUNKMAP_IS_CLEAR(einfo->chunkmap)) {
 		printf("NONE ");
 		goto out;
 	}
 	
-	if (SCTP_CHUNKMAP_IS_ALL_SET(chunkmap)) {
+	if (SCTP_CHUNKMAP_IS_ALL_SET(einfo->chunkmap)) {
 		printf("ALL ");
 		goto out;
 	}
 	
 	flag = 0;
 	for (i = 0; i < 256; i++) {
-		if (SCTP_CHUNKMAP_IS_SET(chunkmap, i)) {
+		if (SCTP_CHUNKMAP_IS_SET(einfo->chunkmap, i)) {
 			if (flag)
 				printf(",");
 			flag = 1;
@@ -473,8 +473,7 @@ sctp_print(const void *ip, const struct 
 		if (einfo->invflags & XT_SCTP_CHUNK_TYPES) {
 			printf("! ");
 		}
-		print_chunks(einfo->chunk_match_type, einfo->chunkmap,
-			einfo->flag_info, einfo->flag_count, numeric);
+		print_chunks(einfo, numeric);
 	}
 }
 
@@ -509,8 +508,7 @@ static void sctp_save(const void *ip, co
 			printf("! ");
 		printf("--chunk-types ");
 
-		print_chunks(einfo->chunk_match_type, einfo->chunkmap, 
-			einfo->flag_info, einfo->flag_count, 0);
+		print_chunks(einfo, 0);
 	}
 }
 

