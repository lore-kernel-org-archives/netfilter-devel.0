From: Felix Janda <felix.janda@posteo.de>
Subject: [PATCH iptables 3/4] ip*_tables.h: Sync with upstream
Date: Tue, 16 Jun 2015 21:24:07 +0200
Message-ID: <20150616192406.GE3247@euler>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx02.posteo.de ([89.146.194.165]:46357 "EHLO mx02.posteo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755036AbbFPTY3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Jun 2015 15:24:29 -0400
Received: from dovecot04.posteo.de (unknown [185.67.36.27])
	by mx02.posteo.de (Postfix) with ESMTPS id E808822B47E0
	for <netfilter-devel@vger.kernel.org>; Tue, 16 Jun 2015 21:24:28 +0200 (CEST)
Received: from mail.posteo.de (localhost [127.0.0.1])
	by dovecot04.posteo.de (Postfix) with ESMTPSA id 3m9zx85x0vzFpVj
	for <netfilter-devel@vger.kernel.org>; Tue, 16 Jun 2015 21:24:28 +0200 (CEST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Felix Janda <felix.janda@posteo.de>
---
Syncing the other headers seems non-trivial. Some don't exist anymore.
Others have a notice saying that they will be removed soon.
---
 include/linux/netfilter_ipv4/ip_tables.h  | 16 ++++++++--------
 include/linux/netfilter_ipv6/ip6_tables.h | 21 ++++++++++++---------
 2 files changed, 20 insertions(+), 17 deletions(-)

diff --git a/include/linux/netfilter_ipv4/ip_tables.h b/include/linux/netfilter_ipv4/ip_tables.h
index 57fd82a..38542b4 100644
--- a/include/linux/netfilter_ipv4/ip_tables.h
+++ b/include/linux/netfilter_ipv4/ip_tables.h
@@ -73,12 +73,12 @@ struct ipt_ip {
 	unsigned char iniface_mask[IFNAMSIZ], outiface_mask[IFNAMSIZ];
 
 	/* Protocol, 0 = ANY */
-	u_int16_t proto;
+	__u16 proto;
 
 	/* Flags word */
-	u_int8_t flags;
+	__u8 flags;
 	/* Inverse flags */
-	u_int8_t invflags;
+	__u8 invflags;
 };
 
 /* Values for "flag" field in struct ipt_ip (general ip structure). */
@@ -106,9 +106,9 @@ struct ipt_entry {
 	unsigned int nfcache;
 
 	/* Size of ipt_entry + matches */
-	u_int16_t target_offset;
+	__u16 target_offset;
 	/* Size of ipt_entry + matches + target */
-	u_int16_t next_offset;
+	__u16 next_offset;
 
 	/* Back pointer */
 	unsigned int comefrom;
@@ -141,9 +141,9 @@ struct ipt_entry {
 
 /* ICMP matching stuff */
 struct ipt_icmp {
-	u_int8_t type;				/* type to match */
-	u_int8_t code[2];			/* range of code */
-	u_int8_t invflags;			/* Inverse flags */
+	__u8 type;				/* type to match */
+	__u8 code[2];				/* range of code */
+	__u8 invflags;				/* Inverse flags */
 };
 
 /* Values for "inv" field for struct ipt_icmp. */
diff --git a/include/linux/netfilter_ipv6/ip6_tables.h b/include/linux/netfilter_ipv6/ip6_tables.h
index 3f19a97..640a1d0 100644
--- a/include/linux/netfilter_ipv6/ip6_tables.h
+++ b/include/linux/netfilter_ipv6/ip6_tables.h
@@ -73,14 +73,14 @@ struct ip6t_ip6 {
 	 *   MH do not match any packets.
 	 * - You also need to set IP6T_FLAGS_PROTO to "flags" to check protocol.
 	 */
-	u_int16_t proto;
+	__u16 proto;
 	/* TOS to match iff flags & IP6T_F_TOS */
-	u_int8_t tos;
+	__u8 tos;
 
 	/* Flags word */
-	u_int8_t flags;
+	__u8 flags;
 	/* Inverse flags */
-	u_int8_t invflags;
+	__u8 invflags;
 };
 
 /* Values for "flag" field in struct ip6t_ip6 (general ip6 structure). */
@@ -110,9 +110,9 @@ struct ip6t_entry {
 	unsigned int nfcache;
 
 	/* Size of ipt_entry + matches */
-	u_int16_t target_offset;
+	__u16 target_offset;
 	/* Size of ipt_entry + matches + target */
-	u_int16_t next_offset;
+	__u16 next_offset;
 
 	/* Back pointer */
 	unsigned int comefrom;
@@ -176,11 +176,14 @@ struct ip6t_error {
 #define IP6T_SO_GET_REVISION_TARGET	(IP6T_BASE_CTL + 5)
 #define IP6T_SO_GET_MAX			IP6T_SO_GET_REVISION_TARGET
 
+/* obtain original address if REDIRECT'd connection */
+#define IP6T_SO_ORIGINAL_DST            80
+
 /* ICMP matching stuff */
 struct ip6t_icmp {
-	u_int8_t type;				/* type to match */
-	u_int8_t code[2];			/* range of code */
-	u_int8_t invflags;			/* Inverse flags */
+	__u8 type;				/* type to match */
+	__u8 code[2];				/* range of code */
+	__u8 invflags;				/* Inverse flags */
 };
 
 /* Values for "inv" field for struct ipt_icmp. */
-- 
2.3.6
