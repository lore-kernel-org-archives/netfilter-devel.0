From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH][libnetfilter_conntrack] add support for explicit helper assignment
Date: Thu, 09 Oct 2008 12:35:45 +0200
Message-ID: <48EDDE81.9070606@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020501070709090405010402"
To: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42424 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753932AbYJIKfz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Oct 2008 06:35:55 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------020501070709090405010402
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

This patch adds support for the explicit helper assignment to
libnetfilter_conntrack. You can use it to test the load-on-demand helper
 modules via ctnetlink.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers

--------------020501070709090405010402
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

[PATCH][libnetfilter_conntrack] add support for explicit helper assignment

This patch adds support for explicit helper assignment.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

diff --git a/include/internal/extern.h b/include/internal/extern.h
index a43cde7..0caa30c 100644
--- a/include/internal/extern.h
+++ b/include/internal/extern.h
@@ -9,4 +9,6 @@ extern filter_attr 	filter_attr_array[];
 extern set_exp_attr	set_exp_attr_array[];
 extern get_exp_attr	get_exp_attr_array[];
 
+extern const char 	*helper_id_to_name[];
+
 #endif
diff --git a/include/internal/object.h b/include/internal/object.h
index e39a576..509f54b 100644
--- a/include/internal/object.h
+++ b/include/internal/object.h
@@ -137,6 +137,7 @@ struct nf_conntrack {
 	u_int32_t 	status;
 	u_int32_t	use;
 	u_int32_t	id;
+	u_int32_t	helper_id;
 
 	union __nfct_protoinfo 	protoinfo;
 	struct __nfct_counters 	counters[__DIR_MAX];
diff --git a/include/libnetfilter_conntrack/libnetfilter_conntrack.h b/include/libnetfilter_conntrack/libnetfilter_conntrack.h
index 46eed0a..ee22fa9 100644
--- a/include/libnetfilter_conntrack/libnetfilter_conntrack.h
+++ b/include/libnetfilter_conntrack/libnetfilter_conntrack.h
@@ -120,9 +120,26 @@ enum nf_conntrack_attr {
 	ATTR_SCTP_STATE = 52,			/* u8 bits */
 	ATTR_SCTP_VTAG_ORIG,			/* u32 bits */
 	ATTR_SCTP_VTAG_REPL,			/* u32 bits */
+	ATTR_HELPER_ID,				/* u32 bits */
 	ATTR_MAX
 };
 
+/* helper id's */
+
+enum nf_conntrack_helper_id {
+	NFCT_HELPER_UNSPEC = 0,
+	NFCT_HELPER_AMANDA,
+	NFCT_HELPER_FTP,
+	NFCT_HELPER_H323,
+	NFCT_HELPER_IRC = 4,
+	NFCT_HELPER_NETBIOS_NS,
+	NFCT_HELPER_PPTP,
+	NFCT_HELPER_SANE,
+	NFCT_HELPER_SIP = 8,
+	NFCT_HELPER_TFTP,
+	NFCT_HELPER_MAX
+};
+
 /* message type */
 enum nf_conntrack_msg_type {
 	NFCT_T_UNKNOWN = 0,
diff --git a/src/conntrack/build.c b/src/conntrack/build.c
index 1bc87f9..8c7cb7f 100644
--- a/src/conntrack/build.c
+++ b/src/conntrack/build.c
@@ -308,6 +308,38 @@ void __build_secmark(struct nfnlhdr *req,
 	nfnl_addattr32(&req->nlh, size, CTA_SECMARK, htonl(ct->secmark));
 }
 
+const char *helper_id_to_name[] = {
+	[NFCT_HELPER_UNSPEC]		= "unknown-helper",
+	[NFCT_HELPER_AMANDA] 		= "amanda",
+	[NFCT_HELPER_FTP] 		= "ftp",
+	[NFCT_HELPER_H323]		= "h323",
+	[NFCT_HELPER_IRC]		= "irc",
+	[NFCT_HELPER_NETBIOS_NS]	= "netbios_ns",
+	[NFCT_HELPER_PPTP]		= "pptp",
+	[NFCT_HELPER_SANE]		= "sane",
+	[NFCT_HELPER_SIP]		= "sip",
+	[NFCT_HELPER_TFTP]		= "tftp",
+};
+
+void __build_helper_name(struct nfnlhdr *req,
+			 size_t size,
+			 const struct nf_conntrack *ct)
+{
+	struct nfattr *nest;
+
+	/* helper set, but probably unsupported */
+	if (ct->helper_id == 0)
+		return;
+
+	nest = nfnl_nest(&req->nlh, size, CTA_HELP);
+	nfnl_addattr_l(&req->nlh,
+			size, 
+			CTA_HELP_NAME,
+			helper_id_to_name[ct->helper_id],
+			strlen(helper_id_to_name[ct->helper_id]));
+	nfnl_nest_end(&req->nlh, nest);
+}
+
 int __build_conntrack(struct nfnl_subsys_handle *ssh,
 		      struct nfnlhdr *req,
 		      size_t size,
@@ -417,5 +449,8 @@ int __build_conntrack(struct nfnl_subsys_handle *ssh,
 	    test_bit(ATTR_REPL_NAT_SEQ_OFFSET_AFTER, ct->set))
 	    	__build_nat_seq_adj(req, size, ct, __DIR_REPL);
 
+	if (test_bit(ATTR_HELPER_ID, ct->set))
+		__build_helper_name(req, size, ct);
+
 	return 0;
 }
diff --git a/src/conntrack/getter.c b/src/conntrack/getter.c
index 20a2a35..65035f0 100644
--- a/src/conntrack/getter.c
+++ b/src/conntrack/getter.c
@@ -282,6 +282,11 @@ static const void *get_attr_repl_off_aft(const struct nf_conntrack *ct)
 	return &ct->tuple[__DIR_REPL].natseq.offset_after;
 }
 
+static const void *get_attr_helper_id(const struct nf_conntrack *ct)
+{
+	return &ct->helper_id;
+}
+
 get_attr get_attr_array[] = {
 	[ATTR_ORIG_IPV4_SRC]		= get_attr_orig_ipv4_src,
 	[ATTR_ORIG_IPV4_DST] 		= get_attr_orig_ipv4_dst,
@@ -338,4 +343,5 @@ get_attr get_attr_array[] = {
 	[ATTR_SCTP_STATE]		= get_attr_sctp_state,
 	[ATTR_SCTP_VTAG_ORIG]		= get_attr_sctp_vtag_orig,
 	[ATTR_SCTP_VTAG_REPL]		= get_attr_sctp_vtag_repl,
+	[ATTR_HELPER_ID]		= get_attr_helper_id,
 };
diff --git a/src/conntrack/parse.c b/src/conntrack/parse.c
index 11cf5ff..41c0c26 100644
--- a/src/conntrack/parse.c
+++ b/src/conntrack/parse.c
@@ -356,6 +356,31 @@ __parse_nat_seq(const struct nfattr *attr, struct nf_conntrack *ct, int dir)
 	}
 }
 
+static void 
+__parse_helper(const struct nfattr *attr, struct nf_conntrack *ct)
+{
+	int i, found = 0;
+	struct nfattr *tb[CTA_NAT_SEQ_MAX];
+
+	nfnl_parse_nested(tb, CTA_NAT_SEQ_MAX, attr);
+	if (!tb[CTA_HELP_NAME-1])
+		return;
+
+	for (i=0; i<NFCT_HELPER_MAX; i++) {
+		if (strcmp(NFA_DATA(tb[CTA_HELP_NAME-1]), 
+			   helper_id_to_name[i]) == 0) {
+			found = 1;
+			break;
+		}
+	}
+
+	if (!found)
+		return;
+
+	ct->helper_id = i;
+	set_bit(ATTR_HELPER_ID, ct->set);
+}
+
 int __parse_message_type(const struct nlmsghdr *nlh)
 {
 	u_int16_t type = NFNL_MSG_TYPE(nlh->nlmsg_type);
@@ -447,4 +472,7 @@ void __parse_conntrack(const struct nlmsghdr *nlh,
 		ct->id = ntohl(*(u_int32_t *)NFA_DATA(cda[CTA_ID-1]));
 		set_bit(ATTR_ID, ct->set);
 	}
+
+	if (cda[CTA_HELP-1])
+		__parse_helper(cda[CTA_HELP-1], ct);
 }
diff --git a/src/conntrack/setter.c b/src/conntrack/setter.c
index 6759652..b9e93ca 100644
--- a/src/conntrack/setter.c
+++ b/src/conntrack/setter.c
@@ -308,6 +308,16 @@ static void set_attr_repl_off_aft(struct nf_conntrack *ct, const void *value)
 	ct->tuple[__DIR_REPL].natseq.offset_after = *((u_int32_t *) value);
 }
 
+static void set_attr_helper_id(struct nf_conntrack *ct, const void *value)
+{
+	u_int32_t val = *((u_int32_t *)value);
+
+	if (val >= NFCT_HELPER_MAX)
+		val = 0;
+
+	ct->helper_id = val;
+}
+
 static void set_attr_do_nothing(struct nf_conntrack *ct, const void *value) {}
 
 set_attr set_attr_array[] = {
@@ -366,4 +376,5 @@ set_attr set_attr_array[] = {
 	[ATTR_SCTP_STATE]	= set_attr_sctp_state,
 	[ATTR_SCTP_VTAG_ORIG]	= set_attr_sctp_vtag_orig,
 	[ATTR_SCTP_VTAG_REPL]	= set_attr_sctp_vtag_repl,
+	[ATTR_HELPER_ID]	= set_attr_helper_id,
 };
diff --git a/utils/conntrack_create.c b/utils/conntrack_create.c
index bc591b5..04b9807 100644
--- a/utils/conntrack_create.c
+++ b/utils/conntrack_create.c
@@ -29,6 +29,7 @@ int main()
 
 	nfct_set_attr_u8(ct, ATTR_TCP_STATE, TCP_CONNTRACK_LISTEN);
 	nfct_set_attr_u32(ct, ATTR_TIMEOUT, 100);
+	nfct_set_attr_u32(ct, ATTR_HELPER_ID, NFCT_HELPER_FTP);
 
 	h = nfct_open(CONNTRACK, 0);
 	if (!h) {

--------------020501070709090405010402--
