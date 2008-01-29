From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: remove unneeded struct member
Date: Tue, 29 Jan 2008 19:30:03 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801291928210.14907@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0801291636390.14907@fbirervta.pbzchgretzou.qr>
 <479F6BEB.8010601@trash.net> <Pine.LNX.4.64.0801291913310.14907@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:58752 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754671AbYA2SaF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Jan 2008 13:30:05 -0500
In-Reply-To: <Pine.LNX.4.64.0801291913310.14907@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Jan 29 2008 19:20, Jan Engelhardt wrote:
>On Jan 29 2008 19:09, Patrick McHardy wrote:
>> Jan Engelhardt wrote:
>>> commit 9cd6d44dfc02166640166a44c27c3dc0a98b4ac3
>>> Author: Jan Engelhardt <jengelh@computergmbh.de>
>>> Date:   Tue Jan 29 16:30:58 2008 +0100
>>> 
>>>     [NETFILTER]: xt_hashlimit: remove unneeded struct member
>>>     
>>>     By allocating ->hinfo, we already have the needed indirection to cope
>>>     with the per-cpu xtables struct match_entry.
>>
>>
>> You already sent this 30 minutes ago. This is not helping me
>> getting rid of my backlog ...

There was a bug in it (extra ";") - git diff just showed me
I had uncommited stuff (need to get used to it first)

@@ -75,7 +75,7 @@ __sctp_chunkmap_is_clear(const u_int32_t *chunkmap, unsigned
i
 }
 
 #define SCTP_CHUNKMAP_IS_ALL_SET(chunkmap) \
-       __sctp_chunkmap_is_all_set((chunkmap), ARRAY_SIZE(chunkmap));
+       __sctp_chunkmap_is_all_set((chunkmap), ARRAY_SIZE(chunkmap))
 static inline bool
 __sctp_chunkmap_is_all_set(const u_int32_t *chunkmap, unsigned int n)
 {



===Full corrected patch===
commit 0000000000000000000000000000000000000000
Author: Jan Engelhardt <jengelh@computergmbh.de>
Date:   Tue Jan 29 16:53:31 2008 +0100

    [NETFILTER]: xt_sctp: simplify xt_sctp.h
    
    The use of xt_sctp.h flagged up -Wshadow warnings in userspace, which
    prompted me to look at it and clean it up. Basic operations have been
    directly replaced by library calls (memcpy, memset is both available
    in the kernel and userspace, and usually faster than a self-made
    loop). The is_set and is_clear functions now use a processing time
    shortcut, too.
    
    Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

diff --git a/include/linux/netfilter/xt_sctp.h b/include/linux/netfilter/xt_sctp.h
index dd5a4fd..3d7e724 100644
--- a/include/linux/netfilter/xt_sctp.h
+++ b/include/linux/netfilter/xt_sctp.h
@@ -37,68 +37,54 @@ struct xt_sctp_info {
 
 #define SCTP_CHUNKMAP_SET(chunkmap, type) 		\
 	do { 						\
-		chunkmap[type / bytes(u_int32_t)] |= 	\
+		(chunkmap)[type / bytes(u_int32_t)] |= 	\
 			1 << (type % bytes(u_int32_t));	\
 	} while (0)
 
 #define SCTP_CHUNKMAP_CLEAR(chunkmap, type)		 	\
 	do {							\
-		chunkmap[type / bytes(u_int32_t)] &= 		\
+		(chunkmap)[type / bytes(u_int32_t)] &= 		\
 			~(1 << (type % bytes(u_int32_t)));	\
 	} while (0)
 
 #define SCTP_CHUNKMAP_IS_SET(chunkmap, type) 			\
 ({								\
-	(chunkmap[type / bytes (u_int32_t)] & 			\
+	((chunkmap)[type / bytes (u_int32_t)] & 		\
 		(1 << (type % bytes (u_int32_t)))) ? 1: 0;	\
 })
 
-#define SCTP_CHUNKMAP_RESET(chunkmap) 				\
-	do {							\
-		int i; 						\
-		for (i = 0; i < ARRAY_SIZE(chunkmap); i++)	\
-			chunkmap[i] = 0;			\
-	} while (0)
-
-#define SCTP_CHUNKMAP_SET_ALL(chunkmap) 			\
-	do {							\
-		int i; 						\
-		for (i = 0; i < ARRAY_SIZE(chunkmap); i++) 	\
-			chunkmap[i] = ~0;			\
-	} while (0)
-
-#define SCTP_CHUNKMAP_COPY(destmap, srcmap) 			\
-	do {							\
-		int i; 						\
-		for (i = 0; i < ARRAY_SIZE(srcmap); i++) 	\
-			destmap[i] = srcmap[i];			\
-	} while (0)
-
-#define SCTP_CHUNKMAP_IS_CLEAR(chunkmap) 		\
-({							\
-	int i; 						\
-	int flag = 1;					\
-	for (i = 0; i < ARRAY_SIZE(chunkmap); i++) {	\
-		if (chunkmap[i]) {			\
-			flag = 0;			\
-			break;				\
-		}					\
-	}						\
-        flag;						\
-})
-
-#define SCTP_CHUNKMAP_IS_ALL_SET(chunkmap) 		\
-({							\
-	int i; 						\
-	int flag = 1;					\
-	for (i = 0; i < ARRAY_SIZE(chunkmap); i++) {	\
-		if (chunkmap[i] != ~0) {		\
-			flag = 0;			\
-				break;			\
-		}					\
-	}						\
-        flag;						\
-})
+#define SCTP_CHUNKMAP_RESET(chunkmap) \
+	memset((chunkmap), 0, sizeof(chunkmap))
+
+#define SCTP_CHUNKMAP_SET_ALL(chunkmap) \
+	memset((chunkmap), ~0U, sizeof(chunkmap))
+
+#define SCTP_CHUNKMAP_COPY(destmap, srcmap) \
+	memcpy((destmap), (srcmap), sizeof(srcmap))
+
+#define SCTP_CHUNKMAP_IS_CLEAR(chunkmap) \
+	__sctp_chunkmap_is_clear((chunkmap), ARRAY_SIZE(chunkmap))
+static inline bool
+__sctp_chunkmap_is_clear(const u_int32_t *chunkmap, unsigned int n)
+{
+	unsigned int i;
+	for (i = 0; i < n; ++i)
+		if (chunkmap[i])
+			return false;
+	return true;
+}
+
+#define SCTP_CHUNKMAP_IS_ALL_SET(chunkmap) \
+	__sctp_chunkmap_is_all_set((chunkmap), ARRAY_SIZE(chunkmap))
+static inline bool
+__sctp_chunkmap_is_all_set(const u_int32_t *chunkmap, unsigned int n)
+{
+	unsigned int i;
+	for (i = 0; i < n; ++i)
+		if (chunkmap[i] != ~0U)
+			return false;
+	return true;
+}
 
 #endif /* _XT_SCTP_H_ */
 


>>
>Oops, was just a glitch in the matrix here I guess :)
>-
>To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

