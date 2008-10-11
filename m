From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH][libnetfilter_conntrack] add support for explicit helper
 assignment
Date: Sat, 11 Oct 2008 14:44:00 +0200
Message-ID: <48F09F90.1040701@netfilter.org>
References: <48EDDE81.9070606@netfilter.org> <alpine.LNX.1.10.0810091814490.13257@bizon.gios.gov.pl> <48EE386A.1010602@netfilter.org> <48EF524F.7070705@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010508080109000508010307"
Cc: Krzysztof Oledzki <ole@ans.pl>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49010 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752582AbYJKMoN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 11 Oct 2008 08:44:13 -0400
In-Reply-To: <48EF524F.7070705@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------010508080109000508010307
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Patrick McHardy wrote:
> Pablo Neira Ayuso wrote:
>> Krzysztof Oledzki wrote:
>>> Any chances to make it more frendly to new helpers and compatible with
>>> out-of-tree helpers by registering a name directly from a helper and
>>> using it? We may for example introduce something like
>>> /proc/net/nf_helpers.
>>
>> We may directly set the name of the helper using the string that
>> identifies it instead of this id. However, this means more memory
>> consumption but more flexibility. I have another patch here that uses
>> strings to do so. The problem is that helpers doesn't have a limitation
>> in the name length and I don't like the idea of having a field
>> "helper_name" with variable length inside the nf_conntrack object. We
>> could make some reasonable assumptions, like considering that the helper
>> name would not be larger than 32 bytes.
> 
> Limiting the name makes sense. The helper match can only match
> on I think 16 bytes, and that seems big enough.

Fine, I have set it to the same size used in xt_helper (30 bytes, that
seems a lot to me, I actually prefer 16 bytes as you said).

BTW, the helper name support for libnetfilter_conntrack looks like the
patch attached.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers

--------------010508080109000508010307
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

diff --git a/include/internal/object.h b/include/internal/object.h
index e39a576..f68d340 100644
--- a/include/internal/object.h
+++ b/include/internal/object.h
@@ -138,6 +138,9 @@ struct nf_conntrack {
 	u_int32_t	use;
 	u_int32_t	id;
 
+#define __NFCT_HELPER_NAMELEN		30	/* same length in xt_helper */
+	char 		helper_name[__NFCT_HELPER_NAMELEN];
+
 	union __nfct_protoinfo 	protoinfo;
 	struct __nfct_counters 	counters[__DIR_MAX];
 	struct __nfct_nat 	snat;
diff --git a/include/libnetfilter_conntrack/libnetfilter_conntrack.h b/include/libnetfilter_conntrack/libnetfilter_conntrack.h
index 46eed0a..e66f0f8 100644
--- a/include/libnetfilter_conntrack/libnetfilter_conntrack.h
+++ b/include/libnetfilter_conntrack/libnetfilter_conntrack.h
@@ -120,6 +120,7 @@ enum nf_conntrack_attr {
 	ATTR_SCTP_STATE = 52,			/* u8 bits */
 	ATTR_SCTP_VTAG_ORIG,			/* u32 bits */
 	ATTR_SCTP_VTAG_REPL,			/* u32 bits */
+	ATTR_HELPER_NAME,			/* string (30 bytes max) */
 	ATTR_MAX
 };
 
diff --git a/src/conntrack/build.c b/src/conntrack/build.c
index 1bc87f9..f9d6f8e 100644
--- a/src/conntrack/build.c
+++ b/src/conntrack/build.c
@@ -308,6 +308,21 @@ void __build_secmark(struct nfnlhdr *req,
 	nfnl_addattr32(&req->nlh, size, CTA_SECMARK, htonl(ct->secmark));
 }
 
+void __build_helper_name(struct nfnlhdr *req,
+			 size_t size,
+			 const struct nf_conntrack *ct)
+{
+	struct nfattr *nest;
+
+	nest = nfnl_nest(&req->nlh, size, CTA_HELP);
+	nfnl_addattr_l(&req->nlh,
+		       size, 
+		       CTA_HELP_NAME,
+		       ct->helper_name,
+		       strlen(ct->helper_name));
+	nfnl_nest_end(&req->nlh, nest);
+}
+
 int __build_conntrack(struct nfnl_subsys_handle *ssh,
 		      struct nfnlhdr *req,
 		      size_t size,
@@ -417,5 +432,8 @@ int __build_conntrack(struct nfnl_subsys_handle *ssh,
 	    test_bit(ATTR_REPL_NAT_SEQ_OFFSET_AFTER, ct->set))
 	    	__build_nat_seq_adj(req, size, ct, __DIR_REPL);
 
+	if (test_bit(ATTR_HELPER_NAME, ct->set))
+		__build_helper_name(req, size, ct);
+
 	return 0;
 }
diff --git a/src/conntrack/getter.c b/src/conntrack/getter.c
index 20a2a35..658d010 100644
--- a/src/conntrack/getter.c
+++ b/src/conntrack/getter.c
@@ -282,6 +282,11 @@ static const void *get_attr_repl_off_aft(const struct nf_conntrack *ct)
 	return &ct->tuple[__DIR_REPL].natseq.offset_after;
 }
 
+static const void *get_attr_helper_name(const struct nf_conntrack *ct)
+{
+	return ct->helper_name;
+}
+
 get_attr get_attr_array[] = {
 	[ATTR_ORIG_IPV4_SRC]		= get_attr_orig_ipv4_src,
 	[ATTR_ORIG_IPV4_DST] 		= get_attr_orig_ipv4_dst,
@@ -338,4 +343,5 @@ get_attr get_attr_array[] = {
 	[ATTR_SCTP_STATE]		= get_attr_sctp_state,
 	[ATTR_SCTP_VTAG_ORIG]		= get_attr_sctp_vtag_orig,
 	[ATTR_SCTP_VTAG_REPL]		= get_attr_sctp_vtag_repl,
+	[ATTR_HELPER_NAME]		= get_attr_helper_name,
 };
diff --git a/src/conntrack/parse.c b/src/conntrack/parse.c
index 11cf5ff..d453bc6 100644
--- a/src/conntrack/parse.c
+++ b/src/conntrack/parse.c
@@ -356,6 +356,22 @@ __parse_nat_seq(const struct nfattr *attr, struct nf_conntrack *ct, int dir)
 	}
 }
 
+static void 
+__parse_helper(const struct nfattr *attr, struct nf_conntrack *ct)
+{
+	struct nfattr *tb[CTA_HELP_MAX];
+
+	nfnl_parse_nested(tb, CTA_HELP_MAX, attr);
+	if (!tb[CTA_HELP_NAME-1])
+		return;
+
+	strncpy(ct->helper_name, 
+		NFA_DATA(tb[CTA_HELP_NAME-1]),
+		__NFCT_HELPER_NAMELEN);
+	ct->helper_name[__NFCT_HELPER_NAMELEN-1] = '\0';
+	set_bit(ATTR_HELPER_NAME, ct->set);
+}
+
 int __parse_message_type(const struct nlmsghdr *nlh)
 {
 	u_int16_t type = NFNL_MSG_TYPE(nlh->nlmsg_type);
@@ -447,4 +463,7 @@ void __parse_conntrack(const struct nlmsghdr *nlh,
 		ct->id = ntohl(*(u_int32_t *)NFA_DATA(cda[CTA_ID-1]));
 		set_bit(ATTR_ID, ct->set);
 	}
+
+	if (cda[CTA_HELP-1])
+		__parse_helper(cda[CTA_HELP-1], ct);
 }
diff --git a/src/conntrack/setter.c b/src/conntrack/setter.c
index 6759652..3291bd1 100644
--- a/src/conntrack/setter.c
+++ b/src/conntrack/setter.c
@@ -308,6 +308,12 @@ static void set_attr_repl_off_aft(struct nf_conntrack *ct, const void *value)
 	ct->tuple[__DIR_REPL].natseq.offset_after = *((u_int32_t *) value);
 }
 
+static void set_attr_helper_name(struct nf_conntrack *ct, const void *value)
+{
+	strncpy(ct->helper_name, value, __NFCT_HELPER_NAMELEN);
+	ct->helper_name[__NFCT_HELPER_NAMELEN-1] = '\0';
+}
+
 static void set_attr_do_nothing(struct nf_conntrack *ct, const void *value) {}
 
 set_attr set_attr_array[] = {
@@ -366,4 +372,5 @@ set_attr set_attr_array[] = {
 	[ATTR_SCTP_STATE]	= set_attr_sctp_state,
 	[ATTR_SCTP_VTAG_ORIG]	= set_attr_sctp_vtag_orig,
 	[ATTR_SCTP_VTAG_REPL]	= set_attr_sctp_vtag_repl,
+	[ATTR_HELPER_NAME]	= set_attr_helper_name,
 };
diff --git a/utils/conntrack_create.c b/utils/conntrack_create.c
index bc591b5..34efa57 100644
--- a/utils/conntrack_create.c
+++ b/utils/conntrack_create.c
@@ -29,6 +29,7 @@ int main()
 
 	nfct_set_attr_u8(ct, ATTR_TCP_STATE, TCP_CONNTRACK_LISTEN);
 	nfct_set_attr_u32(ct, ATTR_TIMEOUT, 100);
+	nfct_set_attr(ct, ATTR_HELPER_NAME, "ftp");
 
 	h = nfct_open(CONNTRACK, 0);
 	if (!h) {

--------------010508080109000508010307--
