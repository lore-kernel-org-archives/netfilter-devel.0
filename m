From: Stephane Chazelas <stephane@artesyncp.com>
Subject: Re: [bug+patch] SCTP and chunk types over 0x1f
Date: Mon, 25 Jun 2007 14:50:40 +0100
Message-ID: <20070625135040.GV20467@artesyncp.com>
References: <20070622151940.GA20467@artesyncp.com> <467FC5CB.9080608@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-Disposition: inline
In-Reply-To: <467FC5CB.9080608@trash.net>
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

On Mon, Jun 25, 2007 at 03:40:27PM +0200, Patrick McHardy wrote:
> Stephane Chazelas wrote:
> > There seems to be several bugs in the iptable and the kernel
> > code that prevent the filtering on SCTP chunks of type above 31
> > to work.
> > 
> > Below is a patch for iptables, the corresponding header files
> > in the kernel would have to be updated the same way.
> > 
> > The problems:
> > - the values for the ASCONF and ASCONF_ACK types were incorrect
> >   (30, 31 instead of 0x80 or 0xC0), I've also added the FTSN
> >   chunk (RFC 3758)
> > 
> > - the chunkmap, which is a bitmap of which chunk is selected is
> >   defined as an array of 256 / 4 u32s, that is 256 * 8 bits,
> >   256 / 32 is enough (256 bits).
> 
> 
> We can't change that since it breaks userspace compatibility.

Hi Patrick,

I see. But that doesn't look very tidy. Maybe some transitional
code with a warning in both the kernel and iptables?

[...]
> Could you please resend without the chunkmap changes? Thanks.

That's just a matter of removing the first change:

Index: include/linux/netfilter_ipv4/ipt_sctp.h
===================================================================
--- include/linux/netfilter_ipv4/ipt_sctp.h	(revision 6882)
+++ include/linux/netfilter_ipv4/ipt_sctp.h	(working copy)
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

Best regards,
Stephane
