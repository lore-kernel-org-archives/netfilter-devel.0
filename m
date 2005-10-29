From: Pablo Neira <pablo@eurodev.net>
Subject: Re: problem with conntrack utility and kernel 2.6.14
Date: Sat, 29 Oct 2005 20:35:57 +0200
Message-ID: <4363C10D.3000903@eurodev.net>
References: <4361EAAB.1090206@fliegl.de>	<4361F6DF.3050106@eurodev.net>	<43621028.40705@fliegl.de>	<43627A8F.9060307@eurodev.net>	<436281BB.2010100@fliegl.de>
	<436373E8.7040606@eurodev.net> <43639684.5030502@fliegl.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------070904050504060504050100"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Deti Fliegl <deti@fliegl.de>
In-Reply-To: <43639684.5030502@fliegl.de>
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

This is a multi-part message in MIME format.
--------------070904050504060504050100
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Deti Fliegl wrote:
> Pablo Neira wrote:
> 
>> Could you give a try to the patch attached and tell me if it fixes the 
>> problem as well?
> 
> Well - Houston, We Have a Problem :(
> 
> nfnl_parse_attr: deficit (4) len (0).

Damn, I'm not able to reproduce this on my x86 box. I tried by stressing 
the conntrack tool with the same method that you've previously described 
with no success, so this must be kind of x86_64 alignment issue.

Please, could you give a try to the patch attached and tell me if it 
fixes the problem? I've reworked the whole netlink message parsing function.

BTW, thanks for the responsiveness.

-- 
Pablo

--------------070904050504060504050100
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

Index: src/libnetfilter_conntrack.c
===================================================================
--- src/libnetfilter_conntrack.c	(revision 4398)
+++ src/libnetfilter_conntrack.c	(working copy)
@@ -431,66 +431,71 @@
 static int nfct_conntrack_netlink_handler(struct nfct_handle *cth, 
 					  struct nlmsghdr *nlh, void *arg)
 {
-	struct nfgenmsg *nfmsg;
-	struct nfattr *attr = NFM_NFA(NLMSG_DATA(nlh));
-	int attrlen = NLMSG_LENGTH(nlh->nlmsg_len) - NFNL_HEADER_LEN;
 	struct nfct_conntrack ct;
 	unsigned int flags = 0;
+	struct nfgenmsg *nfhdr = NLMSG_DATA(nlh);
 	int type = NFNL_MSG_TYPE(nlh->nlmsg_type), ret = 0;
+	int len = nlh->nlmsg_len;
+	struct nfattr *cda[CTA_MAX];
 
+	len -= NLMSG_LENGTH(sizeof(struct nfgenmsg));
+	if (len < 0)
+		return -EINVAL;
+
 	memset(&ct, 0, sizeof(struct nfct_conntrack));
 
-	nfmsg = NLMSG_DATA(nlh);
+	nfnl_parse_attr(cda, CTA_MAX, NFA_DATA(nfhdr), len);
 
-	if (NLMSG_LENGTH(nlh->nlmsg_len) < NFNL_HEADER_LEN)
-		return -EINVAL;
+	if (cda[CTA_TUPLE_ORIG-1])
+		parse_tuple(cda[CTA_TUPLE_ORIG-1], 
+			    &ct.tuple[NFCT_DIR_ORIGINAL]);
+	
+	if (cda[CTA_TUPLE_REPLY-1])
+		parse_tuple(cda[CTA_TUPLE_REPLY-1], 
+			    &ct.tuple[NFCT_DIR_REPLY]);
+	
+	if (cda[CTA_STATUS-1]) {
+		ct.status = ntohl(*(u_int32_t *)NFA_DATA(cda[CTA_STATUS-1]));
+		flags |= NFCT_STATUS;
+	}
 
-	while (NFA_OK(attr, attrlen)) {
-		switch(NFA_TYPE(attr)) {
-		case CTA_TUPLE_ORIG:
-			parse_tuple(attr, &ct.tuple[NFCT_DIR_ORIGINAL]);
-			break;
-		case CTA_TUPLE_REPLY:
-			parse_tuple(attr, &ct.tuple[NFCT_DIR_REPLY]);
-			break;
-		case CTA_STATUS:
-			ct.status = ntohl(*(u_int32_t *)NFA_DATA(attr));
-			flags |= NFCT_STATUS;
-			break;
-		case CTA_PROTOINFO:
-			parse_protoinfo(attr, &ct);
-			flags |= NFCT_PROTOINFO;
-			break;
-		case CTA_TIMEOUT:
-			ct.timeout = ntohl(*(u_int32_t *)NFA_DATA(attr));
-			flags |= NFCT_TIMEOUT;
-			break;
-		case CTA_MARK:
-			ct.mark = ntohl(*(u_int32_t *)NFA_DATA(attr));
-			flags |= NFCT_MARK;
-			break;
-		case CTA_COUNTERS_ORIG:
-			nfct_parse_counters(attr, &ct, NFA_TYPE(attr)-1);
-			flags |= NFCT_COUNTERS_ORIG;
-			break;
-		case CTA_COUNTERS_REPLY:
-			nfct_parse_counters(attr, &ct, NFA_TYPE(attr)-1);
-			flags |= NFCT_COUNTERS_RPLY;
-			break;
-		case CTA_USE:
-			ct.use = ntohl(*(u_int32_t *)NFA_DATA(attr));
-			flags |= NFCT_USE;
-			break;
-		case CTA_ID:
-			ct.id = ntohl(*(u_int32_t *)NFA_DATA(attr));
-			flags |= NFCT_ID;
-			break;
-		default:
-			fprintf(stderr, "Unknown Attribute %d\n", NFA_TYPE(attr));
-			break;
-		}
-		attr = NFA_NEXT(attr, attrlen);
+	if (cda[CTA_PROTOINFO-1]) {
+		parse_protoinfo(cda[CTA_PROTOINFO-1], &ct);
+		flags |= NFCT_PROTOINFO;
 	}
+
+	if (cda[CTA_TIMEOUT-1]) {
+		ct.timeout = ntohl(*(u_int32_t *)NFA_DATA(cda[CTA_TIMEOUT-1]));
+		flags |= NFCT_TIMEOUT;
+	}
+	
+	if (cda[CTA_MARK-1]) {
+		ct.mark = ntohl(*(u_int32_t *)NFA_DATA(cda[CTA_MARK-1]));
+		flags |= NFCT_MARK;
+	}
+	
+	if (cda[CTA_COUNTERS_ORIG-1]) {
+		nfct_parse_counters(cda[CTA_COUNTERS_ORIG-1], &ct, 
+				    NFA_TYPE(cda[CTA_COUNTERS_ORIG-1])-1);
+		flags |= NFCT_COUNTERS_ORIG;
+	}
+
+	if (cda[CTA_COUNTERS_REPLY-1]) {
+		nfct_parse_counters(cda[CTA_COUNTERS_REPLY-1], &ct, 
+				    NFA_TYPE(cda[CTA_COUNTERS_REPLY-1])-1);
+		flags |= NFCT_COUNTERS_RPLY;
+	}
+
+	if (cda[CTA_USE-1]) {
+		ct.use = ntohl(*(u_int32_t *)NFA_DATA(cda[CTA_USE-1]));
+		flags |= NFCT_USE;
+	}
+
+	if (cda[CTA_ID-1]) {
+		ct.id = ntohl(*(u_int32_t *)NFA_DATA(cda[CTA_ID-1]));
+		flags |= NFCT_ID;
+	}
+
 	if (cth->callback)
 		ret = cth->callback((void *) &ct, flags,
 				    typemsg2enum(type, nlh->nlmsg_flags));

--------------070904050504060504050100--
