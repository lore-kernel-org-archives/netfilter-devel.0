From: lizf <lizf@cn.fujitsu.com>
Subject: [PATCH 1/2] netfilter: fix - mistake to pass a pointer where array
 is required
Date: Fri, 12 Oct 2007 13:45:19 +0800
Message-ID: <470F09EF.9080606@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: kaber@trash.net, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from [222.73.24.84] ([222.73.24.84]:64936 "EHLO song.cn.fujitsu.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757914AbXJLFrY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 12 Oct 2007 01:47:24 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi,

Macros like SCTP_CHUNKMAP_XXX(chukmap) require chukmap to be an array,
We can see from below:

#define ELEMCOUNT(x) (sizeof(x)/sizeof(x[0]))

#define SCTP_CHUNKMAP_RESET(chunkmap)				\
	do {							\
		int i;						\
		for (i = 0; i < ELEMCOUNT(chunkmap); i++)	\
			chunkmap[i] = 0;			\
	} while (0)

But match_packet() passes a pointer to these macros. Here's the patch.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

diff --git a/net/netfilter/xt_sctp.c b/net/netfilter/xt_sctp.c
index c002153..f65c71c 100644
--- a/net/netfilter/xt_sctp.c
+++ b/net/netfilter/xt_sctp.c
@@ -41,21 +41,22 @@ match_flags(const struct xt_sctp_flag_info *flag_info,
 static inline bool
 match_packet(const struct sk_buff *skb,
 	     unsigned int offset,
-	     const u_int32_t *chunkmap,
-	     int chunk_match_type,
-	     const struct xt_sctp_flag_info *flag_info,
-	     const int flag_count,
+	     const struct xt_sctp_info *info,
 	     bool *hotdrop)
 {
 	u_int32_t chunkmapcopy[256 / sizeof (u_int32_t)];
 	sctp_chunkhdr_t _sch, *sch;
 
+	int chunk_match_type = info->chunk_match_type;
+	const struct xt_sctp_flag_info *flag_info = info->flag_info;
+	int flag_count = info->flag_count;
+
 #ifdef DEBUG_SCTP
 	int i = 0;
 #endif
 
 	if (chunk_match_type == SCTP_CHUNK_MATCH_ALL)
-		SCTP_CHUNKMAP_COPY(chunkmapcopy, chunkmap);
+		SCTP_CHUNKMAP_COPY(chunkmapcopy, info->chunkmap);
 
 	do {
 		sch = skb_header_pointer(skb, offset, sizeof(_sch), &_sch);
@@ -72,7 +73,7 @@ match_packet(const struct sk_buff *skb,
 
 		duprintf("skb->len: %d\toffset: %d\n", skb->len, offset);
 
-		if (SCTP_CHUNKMAP_IS_SET(chunkmap, sch->type)) {
+		if (SCTP_CHUNKMAP_IS_SET(info->chunkmap, sch->type)) {
 			switch (chunk_match_type) {
 			case SCTP_CHUNK_MATCH_ANY:
 				if (match_flags(flag_info, flag_count,
@@ -103,7 +104,7 @@ match_packet(const struct sk_buff *skb,
 
 	switch (chunk_match_type) {
 	case SCTP_CHUNK_MATCH_ALL:
-		return SCTP_CHUNKMAP_IS_CLEAR(chunkmap);
+		return SCTP_CHUNKMAP_IS_CLEAR(info->chunkmap);
 	case SCTP_CHUNK_MATCH_ANY:
 		return false;
 	case SCTP_CHUNK_MATCH_ONLY:
@@ -147,9 +148,7 @@ match(const struct sk_buff *skb,
 			&& ntohs(sh->dest) <= info->dpts[1],
 			XT_SCTP_DEST_PORTS, info->flags, info->invflags)
 		&& SCCHECK(match_packet(skb, protoff + sizeof (sctp_sctphdr_t),
-					info->chunkmap, info->chunk_match_type,
-					info->flag_info, info->flag_count,
-					hotdrop),
+					info, hotdrop),
 			   XT_SCTP_CHUNK_TYPES, info->flags, info->invflags);
 }
 

