From: Felix Janda <felix.janda@posteo.de>
Subject: [PATCH iptables 2/4] xtables.h: Use <stdint.h> types
Date: Tue, 16 Jun 2015 21:23:52 +0200
Message-ID: <20150616192352.GD3247@euler>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx02.posteo.de ([89.146.194.165]:46021 "EHLO mx02.posteo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753324AbbFPTYP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Jun 2015 15:24:15 -0400
Received: from dovecot04.posteo.de (unknown [185.67.36.27])
	by mx02.posteo.de (Postfix) with ESMTPS id 9163725C00B8
	for <netfilter-devel@vger.kernel.org>; Tue, 16 Jun 2015 21:24:14 +0200 (CEST)
Received: from mail.posteo.de (localhost [127.0.0.1])
	by dovecot04.posteo.de (Postfix) with ESMTPSA id 3m9zwt3L5vzFpWJ
	for <netfilter-devel@vger.kernel.org>; Tue, 16 Jun 2015 21:24:14 +0200 (CEST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Felix Janda <felix.janda@posteo.de>
---
 include/xtables.h | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/include/xtables.h b/include/xtables.h
index bad11a8..978ae0d 100644
--- a/include/xtables.h
+++ b/include/xtables.h
@@ -220,12 +220,12 @@ struct xtables_match
 	const char *real_name;
 
 	/* Revision of match (0 by default). */
-	u_int8_t revision;
+	uint8_t revision;
 
 	/* Extension flags */
-	u_int8_t ext_flags;
+	uint8_t ext_flags;
 
-	u_int16_t family;
+	uint16_t family;
 
 	/* Size of match data. */
 	size_t size;
@@ -297,12 +297,12 @@ struct xtables_target
 	const char *real_name;
 
 	/* Revision of target (0 by default). */
-	u_int8_t revision;
+	uint8_t revision;
 
 	/* Extension flags */
-	u_int8_t ext_flags;
+	uint8_t ext_flags;
 
-	u_int16_t family;
+	uint16_t family;
 
 
 	/* Size of target data. */
@@ -373,7 +373,7 @@ struct xtables_rule_match {
  */
 struct xtables_pprot {
 	const char *name;
-	u_int8_t num;
+	uint8_t num;
 };
 
 enum xtables_tryload {
@@ -449,12 +449,12 @@ extern bool xtables_strtoul(const char *, char **, uintmax_t *,
 extern bool xtables_strtoui(const char *, char **, unsigned int *,
 	unsigned int, unsigned int);
 extern int xtables_service_to_port(const char *name, const char *proto);
-extern u_int16_t xtables_parse_port(const char *port, const char *proto);
+extern uint16_t xtables_parse_port(const char *port, const char *proto);
 extern void
 xtables_parse_interface(const char *arg, char *vianame, unsigned char *mask);
 
 /* this is a special 64bit data type that is 8-byte aligned */
-#define aligned_u64 u_int64_t __attribute__((aligned(8)))
+#define aligned_u64 uint64_t __attribute__((aligned(8)))
 
 extern struct xtables_globals *xt_params;
 #define xtables_error (xt_params->exit_err)
@@ -517,7 +517,7 @@ extern void xtables_print_num(uint64_t number, unsigned int format);
 #endif
 
 extern const struct xtables_pprot xtables_chain_protos[];
-extern u_int16_t xtables_parse_protocol(const char *s);
+extern uint16_t xtables_parse_protocol(const char *s);
 
 /* kernel revision handling */
 extern int kernel_version;
-- 
2.3.6
