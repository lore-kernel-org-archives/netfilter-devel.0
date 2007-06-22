From: Stephane Chazelas <stephane@artesyncp.com>
Subject: [bug+patch] SCTP and chunk types over 0x1f
Date: Fri, 22 Jun 2007 16:19:40 +0100
Message-ID: <20070622151940.GA20467@artesyncp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-Disposition: inline
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Hi guys,

I'm sending this to the list as the bugzilla site seems to be
down at least at the moment.

There seems to be several bugs in the iptable and the kernel
code that prevent the filtering on SCTP chunks of type above 31
to work.

Below is a patch for iptables, the corresponding header files
in the kernel would have to be updated the same way.

The problems:
- the values for the ASCONF and ASCONF_ACK types were incorrect
  (30, 31 instead of 0x80 or 0xC0), I've also added the FTSN
  chunk (RFC 3758)

- the chunkmap, which is a bitmap of which chunk is selected is
  defined as an array of 256 / 4 u32s, that is 256 * 8 bits,
  256 / 32 is enough (256 bits).

- the macros like SCTP_CHUNKMAP_SET_ALL... use
  ELEMCOUNT/ARRAY_SIZE to loop through the u32s of the chunkmap.
  But those macros are sometimes called with a u_int32_t*
  instead of a u_int32_t[8], so that it loops only on the first
  u32.

- bug in print_chunk(), see below.

both the kernel and iptables need to be updated, at least to
take into account the new size of the chunkmap. That patch
doesn't try to be smart wrt to compatibility. It would be nice
to be able to specify chunk using their numerical value (to take
into account future SCTP extensions).

Best regards,
Stephane


Index: include/linux/netfilter_ipv4/ipt_sctp.h
===================================================================
--- include/linux/netfilter_ipv4/ipt_sctp.h	(revision 6882)
+++ include/linux/netfilter_ipv4/ipt_sctp.h	(working copy)
@@ -22,7 +22,7 @@ struct ipt_sctp_info {
 	u_int16_t dpts[2];  /* Min, Max */
 	u_int16_t spts[2];  /* Min, Max */
 
-	u_int32_t chunkmap[256 / sizeof (u_int32_t)];  /* Bit mask of chunks to be matched according to RFC 2960 */
+	u_int32_t chunkmap[256 / 32];  /* Bit mask of chunks to be matched according to RFC 2960 */
 
 #define SCTP_CHUNK_MATCH_ANY   0x01  /* Match if any of the chunk types are present */
 #define SCTP_CHUNK_MATCH_ALL   0x02  /* Match if all of the chunk types are present */
@@ -36,44 +36,42 @@ struct ipt_sctp_info {
 	u_int32_t invflags;
 };
 
-#define bytes(type) (sizeof(type) * 8)
-
 #define SCTP_CHUNKMAP_SET(chunkmap, type) 		\
 	do { 						\
-		chunkmap[type / bytes(u_int32_t)] |= 	\
-			1 << (type % bytes(u_int32_t));	\
+		chunkmap[type / 32] |= 	\
+			1 << (type % 32);	\
 	} while (0)
 
 #define SCTP_CHUNKMAP_CLEAR(chunkmap, type)		 	\
 	do {							\
-		chunkmap[type / bytes(u_int32_t)] &= 		\
-			~(1 << (type % bytes(u_int32_t)));	\
+		chunkmap[type / 32] &= 		\
+			~(1 << (type % 32));	\
 	} while (0)
 
 #define SCTP_CHUNKMAP_IS_SET(chunkmap, type) 			\
 ({								\
-	(chunkmap[type / bytes (u_int32_t)] & 			\
-		(1 << (type % bytes (u_int32_t)))) ? 1: 0;	\
+	(chunkmap[type / 32] & 			\
+		(1 << (type % 32))) ? 1: 0;	\
 })
 
 #define SCTP_CHUNKMAP_RESET(chunkmap) 				\
 	do {							\
 		int i; 						\
-		for (i = 0; i < ELEMCOUNT(chunkmap); i++)	\
+		for (i = 0; i < (256 / 32); i++)	\
 			chunkmap[i] = 0;			\
 	} while (0)
 
 #define SCTP_CHUNKMAP_SET_ALL(chunkmap) 			\
 	do {							\
 		int i; 						\
-		for (i = 0; i < ELEMCOUNT(chunkmap); i++) 	\
+		for (i = 0; i < (256 / 32); i++) 	\
 			chunkmap[i] = ~0;			\
 	} while (0)
 
 #define SCTP_CHUNKMAP_COPY(destmap, srcmap) 			\
 	do {							\
 		int i; 						\
-		for (i = 0; i < ELEMCOUNT(chunkmap); i++) 	\
+		for (i = 0; i < (256 / 32); i++) 	\
 			destmap[i] = srcmap[i];			\
 	} while (0)
 
@@ -81,7 +79,7 @@ struct ipt_sctp_info {
 ({							\
 	int i; 						\
 	int flag = 1;					\
-	for (i = 0; i < ELEMCOUNT(chunkmap); i++) {	\
+	for (i = 0; i < (256 / 32); i++) {	\
 		if (chunkmap[i]) {			\
 			flag = 0;			\
 			break;				\
@@ -94,7 +92,7 @@ struct ipt_sctp_info {
 ({							\
 	int i; 						\
 	int flag = 1;					\
-	for (i = 0; i < ELEMCOUNT(chunkmap); i++) {	\
+	for (i = 0; i < (256 / 32); i++) {	\
 		if (chunkmap[i] != ~0) {		\
 			flag = 0;			\
 				break;			\
Index: extensions/libipt_sctp.c
===================================================================
--- extensions/libipt_sctp.c	(revision 6882)
+++ extensions/libipt_sctp.c	(working copy)
@@ -66,7 +66,7 @@ static void help(void)
 " --dport ...\n" 
 " --chunk-types [!] (all|any|none) (chunktype[:flags])+	match if all, any or none of\n"
 "						        chunktypes are present\n"
-"chunktypes - DATA INIT INIT_ACK SACK HEARTBEAT HEARTBEAT_ACK ABORT SHUTDOWN SHUTDOWN_ACK ERROR COOKIE_ECHO COOKIE_ACK ECN_ECNE ECN_CWR SHUTDOWN_COMPLETE ASCONF ASCONF_ACK ALL NONE\n",
+"chunktypes - DATA INIT INIT_ACK SACK HEARTBEAT HEARTBEAT_ACK ABORT SHUTDOWN SHUTDOWN_ACK ERROR COOKIE_ECHO COOKIE_ACK ECN_ECNE ECN_CWR SHUTDOWN_COMPLETE FTSN ASCONF ASCONF_ACK ALL NONE\n",
 	IPTABLES_VERSION);
 }
 
@@ -128,8 +128,9 @@ static struct sctp_chunk_names sctp_chun
     { .name = "ECN_ECNE",	.chunk_type = 12,  .valid_flags = "--------"},
     { .name = "ECN_CWR",	.chunk_type = 13,  .valid_flags = "--------"},
     { .name = "SHUTDOWN_COMPLETE", .chunk_type = 14,  .valid_flags = "-------T"},
-    { .name = "ASCONF",		.chunk_type = 31,  .valid_flags = "--------"},
-    { .name = "ASCONF_ACK",	.chunk_type = 30,  .valid_flags = "--------"},
+    { .name = "FTSN",		.chunk_type = 0xC0,  .valid_flags = "--------"},
+    { .name = "ASCONF",		.chunk_type = 0xC1,  .valid_flags = "--------"},
+    { .name = "ASCONF_ACK",	.chunk_type = 0x80,  .valid_flags = "--------"},
 };
 
 static void
@@ -402,14 +403,14 @@ print_chunk(u_int32_t chunknum, int nume
 
 		for (i = 0; i < ELEMCOUNT(sctp_chunk_names); i++) {
 			if (sctp_chunk_names[i].chunk_type == chunknum)
-				printf("%s", sctp_chunk_names[chunknum].name);
+				printf("%s", sctp_chunk_names[i].name);
 		}
 	}
 }
 
 static void
 print_chunks(u_int32_t chunk_match_type, 
-	     const u_int32_t *chunkmap, 
+	     const u_int32_t *chunkmap,
 	     const struct ipt_sctp_flag_info *flag_info,
 	     int flag_count,
 	     int numeric)
Index: extensions/libip6t_sctp.c
===================================================================
--- extensions/libip6t_sctp.c	(revision 6882)
+++ extensions/libip6t_sctp.c	(working copy)
@@ -66,7 +66,7 @@ static void help(void)
 " --dport ...\n" 
 " --chunk-types [!] (all|any|none) (chunktype[:flags])+	match if all, any or none of\n"
 "						        chunktypes are present\n"
-"chunktypes - DATA INIT INIT_ACK SACK HEARTBEAT HEARTBEAT_ACK ABORT SHUTDOWN SHUTDOWN_ACK ERROR COOKIE_ECHO COOKIE_ACK ECN_ECNE ECN_CWR SHUTDOWN_COMPLETE ASCONF ASCONF_ACK ALL NONE\n",
+"chunktypes - DATA INIT INIT_ACK SACK HEARTBEAT HEARTBEAT_ACK ABORT SHUTDOWN SHUTDOWN_ACK ERROR COOKIE_ECHO COOKIE_ACK ECN_ECNE ECN_CWR SHUTDOWN_COMPLETE FTSN ASCONF ASCONF_ACK ALL NONE\n",
 	IPTABLES_VERSION);
 }
 
@@ -128,8 +128,9 @@ static struct sctp_chunk_names sctp_chun
     { .name = "ECN_ECNE",	.chunk_type = 12,  .valid_flags = "--------"},
     { .name = "ECN_CWR",	.chunk_type = 13,  .valid_flags = "--------"},
     { .name = "SHUTDOWN_COMPLETE", .chunk_type = 14,  .valid_flags = "-------T"},
-    { .name = "ASCONF",		.chunk_type = 31,  .valid_flags = "--------"},
-    { .name = "ASCONF_ACK",	.chunk_type = 30,  .valid_flags = "--------"},
+    { .name = "FTSN",		.chunk_type = 0xC0,  .valid_flags = "--------"},
+    { .name = "ASCONF",		.chunk_type = 0xC1,  .valid_flags = "--------"},
+    { .name = "ASCONF_ACK",	.chunk_type = 0x80,  .valid_flags = "--------"},
 };
 
 static void
@@ -402,7 +403,7 @@ print_chunk(u_int32_t chunknum, int nume
 
 		for (i = 0; i < ELEMCOUNT(sctp_chunk_names); i++) {
 			if (sctp_chunk_names[i].chunk_type == chunknum)
-				printf("%s", sctp_chunk_names[chunknum].name);
+				printf("%s", sctp_chunk_names[i].name);
 		}
 	}
 }
