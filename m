From: Richard Weinberger <richard@nod.at>
Subject: [PATCH] conntrack: Implement ruleid support
Date: Thu, 20 Jan 2011 23:47:09 +0100
Message-ID: <1295563629-14996-6-git-send-email-richard@nod.at>
References: <1295563629-14996-1-git-send-email-richard@nod.at>
 <1295563629-14996-2-git-send-email-richard@nod.at>
 <1295563629-14996-3-git-send-email-richard@nod.at>
 <1295563629-14996-4-git-send-email-richard@nod.at>
 <1295563629-14996-5-git-send-email-richard@nod.at>
Cc: Richard Weinberger <richard@nod.at>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from a.ns.miles-group.at ([95.130.255.143]:39949 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755336Ab1ATWra (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 Jan 2011 17:47:30 -0500
In-Reply-To: <1295563629-14996-5-git-send-email-richard@nod.at>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Signed-off-by: Richard Weinberger <richard@nod.at>
---
 include/internal/object.h                          |    1 +
 .../libnetfilter_conntrack.h                       |    1 +
 .../linux_nfnetlink_conntrack.h                    |    4 +++
 src/conntrack/build.c                              |   13 ++++++++++++
 src/conntrack/compare.c                            |   13 ++++++++++++
 src/conntrack/copy.c                               |   10 +++++++++
 src/conntrack/getter.c                             |    6 +++++
 src/conntrack/parse.c                              |   21 ++++++++++++++++++++
 src/conntrack/setter.c                             |   10 +++++++++
 src/conntrack/snprintf_default.c                   |   13 ++++++++++++
 src/conntrack/snprintf_xml.c                       |   11 ++++++++++
 11 files changed, 103 insertions(+), 0 deletions(-)

diff --git a/include/internal/object.h b/include/internal/object.h
index 76a0566..f955e53 100644
--- a/include/internal/object.h
+++ b/include/internal/object.h
@@ -160,6 +160,7 @@ struct nf_conntrack {
 	u_int32_t	use;
 	u_int32_t	id;
 	u_int16_t	zone;
+	u_int16_t	ruleid[4];
 
 /* xt_helper uses a length size of 30 bytes, however, no helper name in
  * the tree has exceeded 16 bytes length. Since 2.6.29, the maximum
diff --git a/include/libnetfilter_conntrack/libnetfilter_conntrack.h b/include/libnetfilter_conntrack/libnetfilter_conntrack.h
index aaf1638..c72c333 100644
--- a/include/libnetfilter_conntrack/libnetfilter_conntrack.h
+++ b/include/libnetfilter_conntrack/libnetfilter_conntrack.h
@@ -128,6 +128,7 @@ enum nf_conntrack_attr {
 	ATTR_TCP_WSCALE_REPL = 60,		/* u8 bits */
 	ATTR_ZONE,				/* u16 bits */
 	ATTR_SECCTX,				/* string */
+	ATTR_RULEID,				/* u16 bits * 4 */
 	ATTR_MAX
 };
 
diff --git a/include/libnetfilter_conntrack/linux_nfnetlink_conntrack.h b/include/libnetfilter_conntrack/linux_nfnetlink_conntrack.h
index 3b0c009..aef20ac 100644
--- a/include/libnetfilter_conntrack/linux_nfnetlink_conntrack.h
+++ b/include/libnetfilter_conntrack/linux_nfnetlink_conntrack.h
@@ -46,6 +46,10 @@ enum ctattr_type {
 	CTA_SECMARK,		/* obsolete */
 	CTA_ZONE,
 	CTA_SECCTX,
+	CTA_RULEID_ESTABLISHED,
+	CTA_RULEID_RELATED,
+	CTA_RULEID_NEW,
+	CTA_RULEID_REPLY,
 	__CTA_MAX
 };
 #define CTA_MAX (__CTA_MAX - 1)
diff --git a/src/conntrack/build.c b/src/conntrack/build.c
index f80089a..54a97d7 100644
--- a/src/conntrack/build.c
+++ b/src/conntrack/build.c
@@ -367,6 +367,16 @@ static void __build_mark(struct nfnlhdr *req,
 	nfnl_addattr32(&req->nlh, size, CTA_MARK, htonl(ct->mark));
 }
 
+static void __build_ruleid(struct nfnlhdr *req,
+			 size_t size,
+			 const struct nf_conntrack *ct)
+{
+	nfnl_addattr16(&req->nlh, size, CTA_RULEID_ESTABLISHED, htons(ct->ruleid[0]));
+	nfnl_addattr16(&req->nlh, size, CTA_RULEID_RELATED, htons(ct->ruleid[1]));
+	nfnl_addattr16(&req->nlh, size, CTA_RULEID_NEW, htons(ct->ruleid[2]));
+	nfnl_addattr16(&req->nlh, size, CTA_RULEID_REPLY, htons(ct->ruleid[3]));
+}
+
 static void __build_secmark(struct nfnlhdr *req,
 			    size_t size,
 			    const struct nf_conntrack *ct)
@@ -469,6 +479,9 @@ int __build_conntrack(struct nfnl_subsys_handle *ssh,
 	if (test_bit(ATTR_MARK, ct->set))
 		__build_mark(req, size, ct);
 
+	if (test_bit(ATTR_RULEID, ct->set))
+		__build_ruleid(req, size, ct);
+
 	if (test_bit(ATTR_SECMARK, ct->set))
 		__build_secmark(req, size, ct);
 
diff --git a/src/conntrack/compare.c b/src/conntrack/compare.c
index 1cdad1c..ef79011 100644
--- a/src/conntrack/compare.c
+++ b/src/conntrack/compare.c
@@ -300,6 +300,17 @@ cmp_mark(const struct nf_conntrack *ct1,
 }
 
 static int 
+cmp_ruleid(const struct nf_conntrack *ct1,
+	 const struct nf_conntrack *ct2,
+	 unsigned int flags)
+{
+	return (ct1->ruleid[0] == ct2->ruleid[0] &&
+		ct1->ruleid[1] == ct2->ruleid[1] &&
+		ct1->ruleid[2] == ct2->ruleid[2] &&
+		ct1->ruleid[3] == ct2->ruleid[3]);
+}
+
+static int 
 cmp_timeout(const struct nf_conntrack *ct1,
 	    const struct nf_conntrack *ct2,
 	    unsigned int flags)
@@ -398,6 +409,8 @@ static int cmp_meta(const struct nf_conntrack *ct1,
 		return 0;
 	if (!__cmp(ATTR_SECCTX, ct1, ct2, flags, cmp_secctx))
 		return 0;
+	if (!__cmp(ATTR_RULEID, ct1, ct2, flags, cmp_ruleid))
+		return 0;
 
 	return 1;
 }
diff --git a/src/conntrack/copy.c b/src/conntrack/copy.c
index 9148640..ced0427 100644
--- a/src/conntrack/copy.c
+++ b/src/conntrack/copy.c
@@ -312,6 +312,15 @@ static void copy_attr_mark(struct nf_conntrack *dest,
 	dest->mark = orig->mark;
 }
 
+static void copy_attr_ruleid(struct nf_conntrack *dest,
+			   const struct nf_conntrack *orig)
+{
+	dest->ruleid[0] = orig->ruleid[0];
+	dest->ruleid[1] = orig->ruleid[1];
+	dest->ruleid[2] = orig->ruleid[2];
+	dest->ruleid[3] = orig->ruleid[3];
+}
+
 static void copy_attr_secmark(struct nf_conntrack *dest,
 			      const struct nf_conntrack *orig)
 {
@@ -486,5 +495,6 @@ const copy_attr copy_attr_array[ATTR_MAX] = {
 	[ATTR_TCP_WSCALE_ORIG]		= copy_attr_tcp_wscale_orig,
 	[ATTR_TCP_WSCALE_REPL]		= copy_attr_tcp_wscale_repl,
 	[ATTR_ZONE]			= copy_attr_zone,
+	[ATTR_RULEID]			= copy_attr_ruleid,
 	[ATTR_SECCTX]			= copy_attr_secctx,
 };
diff --git a/src/conntrack/getter.c b/src/conntrack/getter.c
index 8a093c6..6601943 100644
--- a/src/conntrack/getter.c
+++ b/src/conntrack/getter.c
@@ -222,6 +222,11 @@ static const void *get_attr_mark(const struct nf_conntrack *ct)
 	return &ct->mark;
 }
 
+static const void *get_attr_ruleid(const struct nf_conntrack *ct)
+{
+	return &ct->ruleid;
+}
+
 static const void *get_attr_secmark(const struct nf_conntrack *ct)
 {
 	return &ct->secmark;
@@ -386,4 +391,5 @@ const get_attr get_attr_array[ATTR_MAX] = {
 	[ATTR_TCP_WSCALE_REPL]		= get_attr_tcp_wscale_repl,
 	[ATTR_ZONE]			= get_attr_zone,
 	[ATTR_SECCTX]			= get_attr_secctx,
+	[ATTR_RULEID]			= get_attr_ruleid,
 };
diff --git a/src/conntrack/parse.c b/src/conntrack/parse.c
index 841693e..4d308e1 100644
--- a/src/conntrack/parse.c
+++ b/src/conntrack/parse.c
@@ -538,4 +538,25 @@ void __parse_conntrack(const struct nlmsghdr *nlh,
 
 	if (cda[CTA_SECCTX-1])
 		__parse_secctx(cda[CTA_SECCTX-1], ct);
+
+	if (cda[CTA_RULEID_ESTABLISHED-1]) {
+		ct->ruleid[0] = ntohs(*(u_int16_t *)NFA_DATA(cda[CTA_RULEID_ESTABLISHED-1]));
+		set_bit(ATTR_RULEID, ct->set);
+	}
+
+	if (cda[CTA_RULEID_RELATED-1]) {
+		ct->ruleid[1] = ntohs(*(u_int16_t *)NFA_DATA(cda[CTA_RULEID_RELATED-1]));
+		set_bit(ATTR_RULEID, ct->set);
+	}
+
+	if (cda[CTA_RULEID_NEW-1]) {
+		ct->ruleid[2] = ntohs(*(u_int16_t *)NFA_DATA(cda[CTA_RULEID_NEW-1]));
+		set_bit(ATTR_RULEID, ct->set);
+	}
+
+	if (cda[CTA_RULEID_REPLY-1]) {
+		ct->ruleid[3] = ntohs(*(u_int16_t *)NFA_DATA(cda[CTA_RULEID_REPLY-1]));
+		set_bit(ATTR_RULEID, ct->set);
+	}
+
 }
diff --git a/src/conntrack/setter.c b/src/conntrack/setter.c
index 99ac8d7..b3025bd 100644
--- a/src/conntrack/setter.c
+++ b/src/conntrack/setter.c
@@ -223,6 +223,15 @@ static void set_attr_mark(struct nf_conntrack *ct, const void *value)
 	ct->mark = *((u_int32_t *) value);
 }
 
+static void set_attr_ruleid(struct nf_conntrack *ct, const void *value)
+{
+	u_int16_t *tmp = value;
+	ct->ruleid[0] = tmp[0];
+	ct->ruleid[1] = tmp[1];
+	ct->ruleid[2] = tmp[2];
+	ct->ruleid[3] = tmp[3];
+}
+
 static void set_attr_secmark(struct nf_conntrack *ct, const void *value)
 {
 	ct->secmark = *((u_int32_t *) value);
@@ -411,4 +420,5 @@ const set_attr set_attr_array[ATTR_MAX] = {
 	[ATTR_TCP_WSCALE_REPL]	= set_attr_tcp_wscale_repl,
 	[ATTR_ZONE]		= set_attr_zone,
 	[ATTR_SECCTX]		= set_attr_do_nothing,
+	[ATTR_RULEID]		= set_attr_ruleid,
 };
diff --git a/src/conntrack/snprintf_default.c b/src/conntrack/snprintf_default.c
index abb9d9f..b7bc287 100644
--- a/src/conntrack/snprintf_default.c
+++ b/src/conntrack/snprintf_default.c
@@ -202,6 +202,14 @@ __snprintf_mark(char *buf, unsigned int len, const struct nf_conntrack *ct)
 }
 
 static int
+__snprintf_ruleid(char *buf, unsigned int len, const struct nf_conntrack *ct)
+{
+	return (snprintf(buf, len, "established=%u related=%u new=%u reply=%u ", 
+		ct->ruleid[0], ct->ruleid[1], ct->ruleid[2], 
+		ct->ruleid[3]));
+}
+
+static int
 __snprintf_secmark(char *buf, unsigned int len, const struct nf_conntrack *ct)
 {
 	return (snprintf(buf, len, "secmark=%u ", ct->secmark));
@@ -322,6 +330,11 @@ int __snprintf_conntrack_default(char *buf,
 		BUFFER_SIZE(ret, size, len, offset);
 	}
 
+	if (test_bit(ATTR_RULEID, ct->set)) {
+		ret = __snprintf_ruleid(buf+offset, len, ct);
+		BUFFER_SIZE(ret, size, len, offset);
+	}
+
 	if (test_bit(ATTR_SECMARK, ct->set)) {
 		ret = __snprintf_secmark(buf+offset, len, ct);
 		BUFFER_SIZE(ret, size, len, offset);
diff --git a/src/conntrack/snprintf_xml.c b/src/conntrack/snprintf_xml.c
index 97f6650..2259dfa 100644
--- a/src/conntrack/snprintf_xml.c
+++ b/src/conntrack/snprintf_xml.c
@@ -339,6 +339,16 @@ int __snprintf_conntrack_xml(char *buf,
 		BUFFER_SIZE(ret, size, len, offset);
 	}
 
+	if (test_bit(ATTR_RULEID, ct->set)) {
+		ret = snprintf(buf+offset, len,
+			"<ruleid><established>%u</established>"
+			"<related>%u</related><new>%u</new>"
+			"<reply>%u</reply></ruleid>",
+			ct->ruleid[0], ct->ruleid[1], ct->ruleid[2],
+			ct->ruleid[3]);
+		BUFFER_SIZE(ret, size, len, offset);
+	}
+
 	if (test_bit(ATTR_SECMARK, ct->set)) {
 		ret = snprintf(buf+offset, len, 
 				"<secmark>%u</secmark>", ct->secmark);
@@ -387,6 +397,7 @@ int __snprintf_conntrack_xml(char *buf,
 	    test_bit(ATTR_ZONE, ct->set) ||
 	    test_bit(ATTR_USE, ct->set) ||
 	    test_bit(ATTR_STATUS, ct->set) ||
+	    test_bit(ATTR_RULEID, ct->set) ||
 	    test_bit(ATTR_ID, ct->set)) {
 	    	ret = snprintf(buf+offset, len, "</meta>");
 		BUFFER_SIZE(ret, size, len, offset);
-- 
1.6.6.1

