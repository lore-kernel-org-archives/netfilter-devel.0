From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 02/02]: xt_sctp: fix mistake to pass a pointer where array is required
Date: Thu, 18 Oct 2007 12:12:25 +0200 (MEST)
Message-ID: <20071018101202.28424.49568.sendpatchset@localhost.localdomain>
References: <20071018101159.28424.36079.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:33485 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755282AbXJRKM0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 18 Oct 2007 06:12:26 -0400
In-Reply-To: <20071018101159.28424.36079.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

[NETFILTER]: xt_sctp: fix mistake to pass a pointer where array is required

Macros like SCTP_CHUNKMAP_XXX(chukmap) require chukmap to be an array,
but match_packet() passes a pointer to these macros. Also remove the
ELEMCOUNT macro and fix a bug in SCTP_CHUNKMAP_COPY.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 49091cc16abab0ee62d22b36371f720f5727537e
tree fbd19a12cad171095c2a0fd9f87c174bbbad0b2f
parent 9768fafed7a5588757d972b2f511cb17a874f496
author Li Zefan <lizf@cn.fujitsu.com> Thu, 18 Oct 2007 12:09:53 +0200
committer Patrick McHardy <kaber@trash.net> Thu, 18 Oct 2007 12:09:53 +0200

 include/linux/netfilter/xt_sctp.h |   13 +++++--------
 net/netfilter/xt_sctp.c           |   18 ++++++++----------
 2 files changed, 13 insertions(+), 18 deletions(-)

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
diff --git a/net/netfilter/xt_sctp.c b/net/netfilter/xt_sctp.c
index f907770..3358273 100644
--- a/net/netfilter/xt_sctp.c
+++ b/net/netfilter/xt_sctp.c
@@ -42,21 +42,21 @@ match_flags(const struct xt_sctp_flag_info *flag_info,
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
 
 #ifdef DEBUG_SCTP
 	int i = 0;
 #endif
 
 	if (chunk_match_type == SCTP_CHUNK_MATCH_ALL)
-		SCTP_CHUNKMAP_COPY(chunkmapcopy, chunkmap);
+		SCTP_CHUNKMAP_COPY(chunkmapcopy, info->chunkmap);
 
 	do {
 		sch = skb_header_pointer(skb, offset, sizeof(_sch), &_sch);
@@ -73,7 +73,7 @@ match_packet(const struct sk_buff *skb,
 
 		duprintf("skb->len: %d\toffset: %d\n", skb->len, offset);
 
-		if (SCTP_CHUNKMAP_IS_SET(chunkmap, sch->type)) {
+		if (SCTP_CHUNKMAP_IS_SET(info->chunkmap, sch->type)) {
 			switch (chunk_match_type) {
 			case SCTP_CHUNK_MATCH_ANY:
 				if (match_flags(flag_info, flag_count,
@@ -104,7 +104,7 @@ match_packet(const struct sk_buff *skb,
 
 	switch (chunk_match_type) {
 	case SCTP_CHUNK_MATCH_ALL:
-		return SCTP_CHUNKMAP_IS_CLEAR(chunkmap);
+		return SCTP_CHUNKMAP_IS_CLEAR(info->chunkmap);
 	case SCTP_CHUNK_MATCH_ANY:
 		return false;
 	case SCTP_CHUNK_MATCH_ONLY:
@@ -148,9 +148,7 @@ match(const struct sk_buff *skb,
 			&& ntohs(sh->dest) <= info->dpts[1],
 			XT_SCTP_DEST_PORTS, info->flags, info->invflags)
 		&& SCCHECK(match_packet(skb, protoff + sizeof (sctp_sctphdr_t),
-					info->chunkmap, info->chunk_match_type,
-					info->flag_info, info->flag_count,
-					hotdrop),
+					info, hotdrop),
 			   XT_SCTP_CHUNK_TYPES, info->flags, info->invflags);
 }
 
