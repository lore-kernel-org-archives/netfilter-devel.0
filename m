From: Felix Janda <felix.janda@posteo.de>
Subject: [arptables PATCH 1/2] Use stdint types
Date: Sat, 16 May 2015 10:31:24 +0200
Message-ID: <20150516082831.GA14201@euler>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx02.posteo.de ([89.146.194.165]:60007 "EHLO mx02.posteo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932145AbbEPIbr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 16 May 2015 04:31:47 -0400
Received: from dovecot03.posteo.de (unknown [185.67.36.28])
	by mx02.posteo.de (Postfix) with ESMTPS id DCFA925ACC5E
	for <netfilter-devel@vger.kernel.org>; Sat, 16 May 2015 10:31:45 +0200 (CEST)
Received: from mail.posteo.de (localhost [127.0.0.1])
	by dovecot03.posteo.de (Postfix) with ESMTPSA id 3lpfwK4cy4z5vN5
	for <netfilter-devel@vger.kernel.org>; Sat, 16 May 2015 10:31:45 +0200 (CEST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Felix Janda <felix.janda@posteo.de>
---
 arptables.c                 | 8 ++++----
 include/arptables.h         | 7 ++++---
 include/libarptc/libarptc.h | 2 +-
 libarptc/libarptc.c         | 4 ++--
 libarptc/libarptc_incl.c    | 2 +-
 5 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/arptables.c b/arptables.c
index fbe7350..4e9af67 100644
--- a/arptables.c
+++ b/arptables.c
@@ -230,7 +230,7 @@ extern void dump_entries(const arptc_handle_t handle);
    /etc/protocols */
 struct pprot {
 	char *name;
-	u_int8_t num;
+	uint8_t num;
 };
 
 /* Primitive headers... */
@@ -926,7 +926,7 @@ mask_to_dotted(const struct in_addr *mask)
 {
 	int i;
 	static char buf[20];
-	u_int32_t maskaddr, bits;
+	uint32_t maskaddr, bits;
 
 	maskaddr = ntohl(mask->s_addr);
 
@@ -968,7 +968,7 @@ string_to_number(const char *s, unsigned int min, unsigned int max,
 }
 
 static void
-set_option(unsigned int *options, unsigned int option, u_int16_t *invflg,
+set_option(unsigned int *options, unsigned int option, uint16_t *invflg,
 	   int invert)
 {
 	if (*options & option)
@@ -1108,7 +1108,7 @@ register_target(struct arptables_target *me)
 }
 
 static void
-print_num(u_int64_t number, unsigned int format)
+print_num(uint64_t number, unsigned int format)
 {
 	if (format & FMT_KILOMEGAGIGA) {
 		if (number > 99999) {
diff --git a/include/arptables.h b/include/arptables.h
index 82e6e9a..34f53c1 100644
--- a/include/arptables.h
+++ b/include/arptables.h
@@ -1,6 +1,7 @@
 #ifndef _ARPTABLES_USER_H
 #define _ARPTABLES_USER_H
 
+#include <stdint.h>
 #include "arptables_common.h"
 #include "libarptc/libarptc.h"
 
@@ -33,7 +34,7 @@ struct arptables_match
 	size_t userspacesize;
 
 	/* Revision of target (0 by default). */
-	u_int8_t revision;
+	uint8_t revision;
 
 	/* Function which prints out usage message. */
 	void (*help)(void);
@@ -85,7 +86,7 @@ struct arptables_target
 	size_t userspacesize;
 
 	/* Revision of target (0 by default). */
-	u_int8_t revision;
+	uint8_t revision;
 
 	/* Function which prints out usage message. */
 	void (*help)(void);
@@ -132,7 +133,7 @@ extern char *mask_to_dotted(const struct in_addr *mask);
 
 extern void parse_hostnetworkmask(const char *name, struct in_addr **addrpp,
                       struct in_addr *maskp, unsigned int *naddrs);
-extern u_int16_t parse_protocol(const char *s);
+extern uint16_t parse_protocol(const char *s);
 
 extern int do_command(int argc, char *argv[], char **table,
 		      arptc_handle_t *handle);
diff --git a/include/libarptc/libarptc.h b/include/libarptc/libarptc.h
index ff4606f..e4350a6 100644
--- a/include/libarptc/libarptc.h
+++ b/include/libarptc/libarptc.h
@@ -7,7 +7,7 @@
 #include <linux/netfilter_arp/arp_tables.h>
 
 #ifndef ARPT_MIN_ALIGN
-/* arpt_entry has pointers and u_int64_t's in it, so if you align to
+/* arpt_entry has pointers and uint64_t's in it, so if you align to
    it, you'll also align to any crazy matches and targets someone
    might write */
 #define ARPT_MIN_ALIGN (__alignof__(struct arpt_entry))
diff --git a/libarptc/libarptc.c b/libarptc/libarptc.c
index 0025a75..f03dd0b 100644
--- a/libarptc/libarptc.c
+++ b/libarptc/libarptc.c
@@ -256,8 +256,8 @@ unconditional(const struct arpt_arp *arp)
 {
 	unsigned int i;
 
-	for (i = 0; i < sizeof(*arp)/sizeof(u_int32_t); i++)
-		if (((u_int32_t *)arp)[i])
+	for (i = 0; i < sizeof(*arp)/sizeof(uint32_t); i++)
+		if (((uint32_t *)arp)[i])
 			return 0;
 
 	return 1;
diff --git a/libarptc/libarptc_incl.c b/libarptc/libarptc_incl.c
index 87404ce..ca23da6 100644
--- a/libarptc/libarptc_incl.c
+++ b/libarptc/libarptc_incl.c
@@ -1688,7 +1688,7 @@ TC_COMMIT(TC_HANDLE_T *handle)
 		/* Kernel will think that pointer should be 64-bits, and get
 		   padding.  So we accomodate here (assumption: alignment of
 		   `counters' is on 64-bit boundary). */
-		u_int64_t *kernptr = (u_int64_t *)&newcounters->counters;
+		uint64_t *kernptr = (uint64_t *)&newcounters->counters;
 		if ((unsigned long)&newcounters->counters % 8 != 0) {
 			fprintf(stderr,
 				"counters alignment incorrect! Mail rusty!\n");
-- 
2.3.6
