From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH] [LIBNETFILTER_CONNTRACK] SCTP support
Date: Wed, 21 May 2008 00:56:07 +0200
Message-ID: <48335707.4030408@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------030201000506040503020200"
To: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50726 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762099AbYETW4R (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 20 May 2008 18:56:17 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------030201000506040503020200
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Attached SCTP support for libnetfilter_conntrack in case that you want
to test the kernel [PATCH 2/4].

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers

--------------030201000506040503020200
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

diff --git a/include/internal.h b/include/internal.h
index 039c64c..6661dbe 100644
--- a/include/internal.h
+++ b/include/internal.h
@@ -130,6 +130,11 @@ union __nfct_protoinfo {
 			u_int8_t mask;
 		} flags[__DIR_MAX];
 	} tcp;
+	struct {
+		u_int8_t state;
+		u_int32_t vtag[__DIR_MAX];
+	} sctp;
+
 };
 
 struct __nfct_counters {
diff --git a/include/libnetfilter_conntrack/libnetfilter_conntrack.h b/include/libnetfilter_conntrack/libnetfilter_conntrack.h
index 075ac3a..a043f91 100644
--- a/include/libnetfilter_conntrack/libnetfilter_conntrack.h
+++ b/include/libnetfilter_conntrack/libnetfilter_conntrack.h
@@ -117,6 +117,9 @@ enum nf_conntrack_attr {
 	ATTR_REPL_NAT_SEQ_CORRECTION_POS,	/* u32 bits */
 	ATTR_REPL_NAT_SEQ_OFFSET_BEFORE,	/* u32 bits */
 	ATTR_REPL_NAT_SEQ_OFFSET_AFTER,		/* u32 bits */
+	ATTR_SCTP_STATE = 52,			/* u8 bits */
+	ATTR_SCTP_VTAG_ORIG,			/* u32 bits */
+	ATTR_SCTP_VTAG_REPL,			/* u32 bits */
 	ATTR_MAX
 };
 
diff --git a/include/libnetfilter_conntrack/linux_nfnetlink_conntrack.h b/include/libnetfilter_conntrack/linux_nfnetlink_conntrack.h
index 7f0fe96..3b2d869 100644
--- a/include/libnetfilter_conntrack/linux_nfnetlink_conntrack.h
+++ b/include/libnetfilter_conntrack/linux_nfnetlink_conntrack.h
@@ -84,6 +84,8 @@ enum ctattr_l4proto {
 enum ctattr_protoinfo {
 	CTA_PROTOINFO_UNSPEC,
 	CTA_PROTOINFO_TCP,
+	CTA_PROTOINFO_DCCP,
+	CTA_PROTOINFO_SCTP,
 	__CTA_PROTOINFO_MAX
 };
 #define CTA_PROTOINFO_MAX (__CTA_PROTOINFO_MAX - 1)
@@ -99,6 +101,22 @@ enum ctattr_protoinfo_tcp {
 };
 #define CTA_PROTOINFO_TCP_MAX (__CTA_PROTOINFO_TCP_MAX - 1)
 
+enum ctattr_protoinfo_dccp {
+	CTA_PROTOINFO_DCCP_UNSPEC,
+	CTA_PROTOINFO_DCCP_STATE,
+	__CTA_PROTOINFO_DCCP_MAX
+};
+#define CTA_PROTOINFO_DCCP_MAX (__CTA_PROTOINFO_DCCP_MAX - 1)
+
+enum ctattr_protoinfo_sctp {
+	CTA_PROTOINFO_SCTP_UNSPEC,
+	CTA_PROTOINFO_SCTP_STATE,
+	CTA_PROTOINFO_SCTP_VTAG_ORIGINAL,
+	CTA_PROTOINFO_SCTP_VTAG_REPLY,
+	__CTA_PROTOINFO_SCTP_MAX
+};
+#define CTA_PROTOINFO_SCTP_MAX (__CTA_PROTOINFO_SCTP_MAX - 1)
+
 enum ctattr_counters {
 	CTA_COUNTERS_UNSPEC,
 	CTA_COUNTERS_PACKETS,		/* old 64bit counters */
diff --git a/src/conntrack/build.c b/src/conntrack/build.c
index 638fbe2..f11af42 100644
--- a/src/conntrack/build.c
+++ b/src/conntrack/build.c
@@ -123,6 +123,25 @@ void __build_protoinfo(struct nfnlhdr *req,
 		nfnl_nest_end(&req->nlh, nest_proto);
 		nfnl_nest_end(&req->nlh, nest);
 		break;
+	case IPPROTO_SCTP:
+		nest = nfnl_nest(&req->nlh, size, CTA_PROTOINFO);
+		nest_proto = nfnl_nest(&req->nlh, size, CTA_PROTOINFO_SCTP);
+		if (test_bit(ATTR_SCTP_STATE, ct->set))
+			nfnl_addattr_l(&req->nlh, size,
+				       CTA_PROTOINFO_SCTP_STATE,
+				       &ct->protoinfo.sctp.state,
+				       sizeof(u_int8_t));
+		if (test_bit(ATTR_SCTP_VTAG_ORIG, ct->set))
+			nfnl_addattr32(&req->nlh, size,
+				    CTA_PROTOINFO_SCTP_VTAG_ORIGINAL,
+				    htonl(ct->protoinfo.sctp.vtag[__DIR_ORIG]));
+		if (test_bit(ATTR_SCTP_VTAG_REPL, ct->set))
+			nfnl_addattr32(&req->nlh, size,
+				    CTA_PROTOINFO_SCTP_VTAG_REPLY,
+				    htonl(ct->protoinfo.sctp.vtag[__DIR_REPL]));
+		nfnl_nest_end(&req->nlh, nest_proto);
+		nfnl_nest_end(&req->nlh, nest);
+		break;
 	default:
 		break;
 	}
diff --git a/src/conntrack/compare.c b/src/conntrack/compare.c
index cd51f9d..d30a902 100644
--- a/src/conntrack/compare.c
+++ b/src/conntrack/compare.c
@@ -222,6 +222,11 @@ static int cmp_meta(const struct nf_conntrack *ct1,
 	    ct1->protoinfo.tcp.state != ct2->protoinfo.tcp.state)
 	    	return 0;
 
+	if (test_bit(ATTR_SCTP_STATE, ct1->set) &&
+	    test_bit(ATTR_SCTP_STATE, ct2->set) &&
+	    ct1->protoinfo.sctp.state != ct2->protoinfo.sctp.state)
+	    	return 0;
+
 	return 1;
 }
 
diff --git a/src/conntrack/copy.c b/src/conntrack/copy.c
index 142f868..562f801 100644
--- a/src/conntrack/copy.c
+++ b/src/conntrack/copy.c
@@ -224,6 +224,26 @@ static void copy_attr_tcp_mask_repl(struct nf_conntrack *dest,
 		orig->protoinfo.tcp.flags[__DIR_REPL].mask;
 }
 
+static void copy_attr_sctp_state(struct nf_conntrack *dest,
+				 const struct nf_conntrack *orig)
+{
+	dest->protoinfo.sctp.state = orig->protoinfo.sctp.state;
+}
+
+static void copy_attr_sctp_vtag_orig(struct nf_conntrack *dest,
+				     const struct nf_conntrack *orig)
+{
+	dest->protoinfo.sctp.vtag[__DIR_ORIG] =
+		orig->protoinfo.sctp.vtag[__DIR_ORIG];
+}
+
+static void copy_attr_sctp_vtag_repl(struct nf_conntrack *dest,
+				     const struct nf_conntrack *orig)
+{
+	dest->protoinfo.sctp.vtag[__DIR_REPL] =
+		orig->protoinfo.sctp.vtag[__DIR_REPL];
+}
+
 static void copy_attr_snat_ipv4(struct nf_conntrack *dest,
 				const struct nf_conntrack *orig)
 {
@@ -403,4 +423,7 @@ copy_attr copy_attr_array[] = {
 	[ATTR_REPL_NAT_SEQ_CORRECTION_POS]	= copy_attr_repl_cor_pos,
 	[ATTR_REPL_NAT_SEQ_OFFSET_BEFORE]	= copy_attr_repl_off_bfr,
 	[ATTR_REPL_NAT_SEQ_OFFSET_AFTER]	= copy_attr_repl_off_aft,
+	[ATTR_SCTP_STATE]		= copy_attr_sctp_state,
+	[ATTR_SCTP_VTAG_ORIG]		= copy_attr_sctp_vtag_orig,
+	[ATTR_SCTP_VTAG_REPL]		= copy_attr_sctp_vtag_repl,
 };
diff --git a/src/conntrack/getter.c b/src/conntrack/getter.c
index 48ba386..8591f88 100644
--- a/src/conntrack/getter.c
+++ b/src/conntrack/getter.c
@@ -167,6 +167,21 @@ static const void *get_attr_tcp_mask_repl(const struct nf_conntrack *ct)
 	return &ct->protoinfo.tcp.flags[__DIR_REPL].mask;
 }
 
+static const void *get_attr_sctp_state(const struct nf_conntrack *ct)
+{
+	return &ct->protoinfo.sctp.state;
+}
+
+static const void *get_attr_sctp_vtag_orig(const struct nf_conntrack *ct)
+{
+	return &ct->protoinfo.sctp.vtag[__DIR_ORIG];
+}
+
+static const void *get_attr_sctp_vtag_repl(const struct nf_conntrack *ct)
+{
+	return &ct->protoinfo.sctp.vtag[__DIR_REPL];
+}
+
 static const void *get_attr_snat_ipv4(const struct nf_conntrack *ct)
 {
 	return &ct->snat.min_ip;
@@ -320,4 +335,7 @@ get_attr get_attr_array[] = {
 	[ATTR_REPL_NAT_SEQ_CORRECTION_POS]	= get_attr_repl_cor_pos,
 	[ATTR_REPL_NAT_SEQ_OFFSET_BEFORE]	= get_attr_repl_off_bfr,
 	[ATTR_REPL_NAT_SEQ_OFFSET_AFTER]	= get_attr_repl_off_aft,
+	[ATTR_SCTP_STATE]		= get_attr_sctp_state,
+	[ATTR_SCTP_VTAG_ORIG]		= get_attr_sctp_vtag_orig,
+	[ATTR_SCTP_VTAG_REPL]		= get_attr_sctp_vtag_repl,
 };
diff --git a/src/conntrack/parse.c b/src/conntrack/parse.c
index c21f304..a18e3ad 100644
--- a/src/conntrack/parse.c
+++ b/src/conntrack/parse.c
@@ -217,6 +217,33 @@ static void __parse_protoinfo_tcp(const struct nfattr *attr,
 	}
 }
 
+static void __parse_protoinfo_sctp(const struct nfattr *attr, 
+				   struct nf_conntrack *ct)
+{
+	struct nfattr *tb[CTA_PROTOINFO_SCTP_MAX];
+
+	nfnl_parse_nested(tb, CTA_PROTOINFO_SCTP_MAX, attr);
+
+	if (tb[CTA_PROTOINFO_SCTP_STATE-1]) {
+                ct->protoinfo.sctp.state =
+                        *(u_int8_t *)NFA_DATA(tb[CTA_PROTOINFO_SCTP_STATE-1]);
+		set_bit(ATTR_SCTP_STATE, ct->set);
+	}
+
+	if (tb[CTA_PROTOINFO_SCTP_VTAG_ORIGINAL-1]) {
+		ct->protoinfo.sctp.vtag[__DIR_ORIG] = 
+			ntohl(*(u_int32_t *)NFA_DATA(tb[CTA_PROTOINFO_SCTP_VTAG_ORIGINAL-1]));
+		set_bit(ATTR_SCTP_VTAG_ORIG, ct->set);
+	}
+
+	if (tb[CTA_PROTOINFO_SCTP_VTAG_REPLY-1]) {
+		ct->protoinfo.sctp.vtag[__DIR_ORIG] = 
+			ntohl(*(u_int32_t *)NFA_DATA(tb[CTA_PROTOINFO_SCTP_VTAG_REPLY-1]));
+		set_bit(ATTR_SCTP_VTAG_ORIG, ct->set);
+	}
+
+}
+
 static void __parse_protoinfo(const struct nfattr *attr,
 			      struct nf_conntrack *ct)
 {
@@ -224,10 +251,11 @@ static void __parse_protoinfo(const struct nfattr *attr,
 
 	nfnl_parse_nested(tb, CTA_PROTOINFO_MAX, attr);
 
-	if (!tb[CTA_PROTOINFO_TCP-1])
-		return;
+	if (tb[CTA_PROTOINFO_TCP-1])
+		__parse_protoinfo_tcp(tb[CTA_PROTOINFO_TCP-1], ct);
 
-	__parse_protoinfo_tcp(tb[CTA_PROTOINFO_TCP-1], ct);
+	if (tb[CTA_PROTOINFO_SCTP-1])
+		__parse_protoinfo_sctp(tb[CTA_PROTOINFO_SCTP-1], ct);
 }
 
 static void __parse_counters(const struct nfattr *attr,
diff --git a/src/conntrack/setter.c b/src/conntrack/setter.c
index 52a2aab..53698bf 100644
--- a/src/conntrack/setter.c
+++ b/src/conntrack/setter.c
@@ -170,6 +170,21 @@ static void set_attr_tcp_mask_repl(struct nf_conntrack *ct, const void *value)
 	ct->protoinfo.tcp.flags[__DIR_REPL].mask = *((u_int8_t *) value);
 }
 
+static void set_attr_sctp_state(struct nf_conntrack *ct, const void *value)
+{
+	ct->protoinfo.sctp.state = *((u_int8_t *) value);
+}
+
+static void set_attr_sctp_vtag_orig(struct nf_conntrack *ct, const void *value)
+{
+	ct->protoinfo.sctp.vtag[__DIR_ORIG] = *((u_int32_t *) value);
+}
+
+static void set_attr_sctp_vtag_repl(struct nf_conntrack *ct, const void *value)
+{
+	ct->protoinfo.sctp.vtag[__DIR_REPL] = *((u_int32_t *) value);
+}
+
 static void set_attr_snat_ipv4(struct nf_conntrack *ct, const void *value)
 {
 	ct->snat.min_ip = ct->snat.max_ip = *((u_int32_t *) value);
@@ -340,4 +355,7 @@ set_attr set_attr_array[] = {
 	[ATTR_REPL_NAT_SEQ_CORRECTION_POS] 	= set_attr_repl_cor_pos,
 	[ATTR_REPL_NAT_SEQ_OFFSET_BEFORE] 	= set_attr_repl_off_aft,
 	[ATTR_REPL_NAT_SEQ_OFFSET_AFTER] 	= set_attr_repl_off_bfr,
+	[ATTR_SCTP_STATE]	= set_attr_sctp_state,
+	[ATTR_SCTP_VTAG_ORIG]	= set_attr_sctp_vtag_orig,
+	[ATTR_SCTP_VTAG_REPL]	= set_attr_sctp_vtag_repl,
 };
diff --git a/src/conntrack/snprintf_default.c b/src/conntrack/snprintf_default.c
index e2573df..a0e3a30 100644
--- a/src/conntrack/snprintf_default.c
+++ b/src/conntrack/snprintf_default.c
@@ -34,6 +34,17 @@ static const char *states[] = {
 	"LISTEN"
 };
 
+static const char *sctp_states[] = {
+	"NONE",
+	"CLOSED",
+	"COOKIE_WAIT",
+	"COOKIE_ECHOED",
+	"ESTABLISHED",
+	"SHUTDOWN_SENT",
+	"SHUTDOWN_RECD",
+	"SHUTDOWN_ACK_SENT",
+};
+
 static int __snprintf_l3protocol(char *buf,
 				 unsigned int len,
 				 const struct nf_conntrack *ct)
@@ -65,8 +76,15 @@ int __snprintf_protoinfo(char *buf,
 			 unsigned int len,
 			 const struct nf_conntrack *ct)
 {
+
 	return snprintf(buf, len, "%s ", states[ct->protoinfo.tcp.state]);
 }
+int __snprintf_protoinfo_sctp(char *buf, 
+			      unsigned int len,
+			      const struct nf_conntrack *ct)
+{
+	return snprintf(buf, len, "%s ", sctp_states[ct->protoinfo.sctp.state]);
+}
 
 int __snprintf_address_ipv4(char *buf,
 			    unsigned int len,
@@ -260,6 +278,11 @@ int __snprintf_conntrack_default(char *buf,
 		BUFFER_SIZE(ret, size, len, offset);
 	}
 
+	if (test_bit(ATTR_SCTP_STATE, ct->set)) {
+		ret = __snprintf_protoinfo_sctp(buf+offset, len, ct);
+		BUFFER_SIZE(ret, size, len, offset);
+	}
+
 	ret = __snprintf_address(buf+offset, len, &ct->tuple[__DIR_ORIG]);
 	BUFFER_SIZE(ret, size, len, offset);
 

--------------030201000506040503020200--
