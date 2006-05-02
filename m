From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: RFC: NAT configuration over ctnetlink
Date: Wed, 03 May 2006 01:32:09 +0200
Message-ID: <4457EBF9.3080606@netfilter.org>
References: <4451BA40.4050207@trash.net> <445388B9.2010308@netfilter.org>
	<4457677D.7060607@trash.net> <44578E0C.5070705@netfilter.org>
	<4457926D.5010209@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------020405020007040800030607"
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <4457926D.5010209@trash.net>
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
--------------020405020007040800030607
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Patrick McHardy wrote:
> Pablo Neira Ayuso wrote:
> 
>>>I don't know. I would prefer to just remove it. Since the library
>>>takes all parameters as arguments to a single function (one more
>>>thing I definitely don't like), compatibility of the library will
>>>break anyway when we add support for multiple manips. Do you really
>>>think its worth keeping around?
>>
>>Not really, if it's trash better remove this sooner than later. Now that
>>we are going to break backward compatibility, please let me know if you
>>don't like anything else that we could change at this point.
> 
> One thing that would make a lot of sense is to change or introduce a new
> interface in libnetfilter_conntrack that allows to add netfilter
> attributes to a conntrack "object" one at a time, so we don't have to
> change function prototypes each time we're introducing something new.

what do you think about the incomplete patch attached? Still missing the
getters and the expectations.

I think that with the setters/getters we can make private nfct_conntrack
and friends.

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris

--------------020405020007040800030607
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline;
 filename="x"

Index: include/libnetfilter_conntrack/linux_nfnetlink_conntrack.h
===================================================================
--- include/libnetfilter_conntrack/linux_nfnetlink_conntrack.h	(revisión: 6554)
+++ include/libnetfilter_conntrack/linux_nfnetlink_conntrack.h	(copia de trabajo)
@@ -27,13 +27,14 @@
 	CTA_STATUS,
 	CTA_PROTOINFO,
 	CTA_HELP,
-	CTA_NAT,
+	CTA_NAT_SRC,
 	CTA_TIMEOUT,
 	CTA_MARK,
 	CTA_COUNTERS_ORIG,
 	CTA_COUNTERS_REPLY,
 	CTA_USE,
 	CTA_ID,
+	CTA_NAT_DST,
 	__CTA_MAX
 };
 #define CTA_MAX (__CTA_MAX - 1)
Index: include/libnetfilter_conntrack/libnetfilter_conntrack.h
===================================================================
--- include/libnetfilter_conntrack/libnetfilter_conntrack.h	(revisión: 6554)
+++ include/libnetfilter_conntrack/libnetfilter_conntrack.h	(copia de trabajo)
@@ -96,7 +96,8 @@
 
 	union nfct_protoinfo protoinfo;
 	struct nfct_counters counters[NFCT_DIR_MAX];
-	struct nfct_nat nat;
+	struct nfct_nat src_nat;
+	struct nfct_nat dst_nat;
 };
 
 struct nfct_expect {
@@ -193,7 +194,33 @@
 	IPS_DYING = (1 << IPS_DYING_BIT),
 };
 
+/* Attributes of a conntrack "object" */
 enum {
+	NFCT_ATTR_IPV4_SRC = 0,
+	NFCT_ATTR_IPV4_DST,
+	NFCT_ATTR_IPV6_SRC,
+	NFCT_ATTR_IPV6_DST,
+	NFCT_ATTR_L3PROTONUM,
+	NFCT_ATTR_PROTONUM,
+	NFCT_ATTR_PORT_SRC,
+	NFCT_ATTR_PORT_DST,
+	NFCT_ATTR_ICMP_TYPE,
+	NFCT_ATTR_ICMP_CODE,
+	NFCT_ATTR_ICMP_ID,
+	NFCT_ATTR_STATUS,
+	NFCT_ATTR_MARK,
+	NFCT_ATTR_ID,
+	NFCT_ATTR_TCP_STATE,
+	NFCT_ATTR_SRC_NAT,
+	NFCT_ATTR_DST_NAT,
+	NFCT_ATTR_SRC_MINIP_NAT,
+	NFCT_ATTR_SRC_MAXIP_NAT,
+	NFCT_ATTR_DST_MINIP_NAT,
+	NFCT_ATTR_DST_MAXIP_NAT,
+	NFCT_ATTR_MAX,
+};
+
+enum {
 	NFCT_MSG_UNKNOWN,
 	NFCT_MSG_NEW,
 	NFCT_MSG_UPDATE,
@@ -204,16 +231,19 @@
 typedef int (*nfct_callback)(void *arg, unsigned int flags, int, void *data);
 
 /*
- * [Allocate|free] a conntrack
+ * [Allocate|free] a conntrack "object"
  */
-extern struct nfct_conntrack *
-nfct_conntrack_alloc(struct nfct_tuple *orig, struct nfct_tuple *reply,
-		     u_int32_t timeout, union nfct_protoinfo *proto,
-		     u_int32_t status, u_int32_t mark,
-		     u_int32_t id, struct nfct_nat *range);
+extern struct nfct_conntrack *nfct_conntrack_alloc(struct nfct_tuple *orig, 
+						   struct nfct_tuple *r);
 extern void nfct_conntrack_free(struct nfct_conntrack *ct);
 
 /*
+ * Setter functions
+ */
+int nfct_tuple_set(struct nfct_tuple *, void *, unsigned int, int);
+int nfct_conntrack_set(struct nfct_conntrack *, void *, unsigned int, int);
+
+/*
  * [Allocate|free] an expectation
  */
 extern struct nfct_expect *
Index: src/libnetfilter_conntrack.c
===================================================================
--- src/libnetfilter_conntrack.c	(revisión: 6554)
+++ src/libnetfilter_conntrack.c	(copia de trabajo)
@@ -263,21 +263,37 @@
 }
 
 static void nfct_build_nat(struct nfnlhdr *req, int size,
-			   struct nfct_conntrack *ct)
+			   struct nfct_conntrack *ct, int attr)
 {
 	struct nfattr *nest;
 
-	nest = nfnl_nest(&req->nlh, size, CTA_NAT);
+	nest = nfnl_nest(&req->nlh, size, attr);
 
-	nfnl_addattr_l(&req->nlh, size, CTA_NAT_MINIP,
-		       &ct->nat.min_ip, sizeof(u_int32_t));
+	switch(attr) {
+	case CTA_NAT_SRC:
+		nfnl_addattr_l(&req->nlh, size, CTA_NAT_MINIP,
+			       &ct->src_nat.min_ip, sizeof(u_int32_t));
+
+		if (ct->src_nat.min_ip != ct->src_nat.max_ip)
+			nfnl_addattr_l(&req->nlh, size, CTA_NAT_MAXIP,
+				       &ct->src_nat.max_ip, sizeof(u_int32_t));
+		break;
+	case CTA_NAT_DST:
+		nfnl_addattr_l(&req->nlh, size, CTA_NAT_MINIP,
+			       &ct->dst_nat.max_ip, sizeof(u_int32_t));
+		if (ct->dst_nat.min_ip != ct->dst_nat.max_ip)
+			nfnl_addattr_l(&req->nlh, size, CTA_NAT_MAXIP,
+				       &ct->dst_nat.max_ip, sizeof(u_int32_t));
+		break;
+	default:
+		fprintf(stderr, "Unknown attribute to set up NAT\n");
+		return;
+	}
 	
-	if (ct->nat.min_ip != ct->nat.max_ip)
-		nfnl_addattr_l(&req->nlh, size, CTA_NAT_MAXIP,
-			       &ct->nat.max_ip, sizeof(u_int32_t));
-
+#if 0
 	if (ct->nat.l4min.all != ct->nat.l4max.all)
 		nfct_build_protonat(req, size, ct);
+#endif
 
 	nfnl_nest_end(&req->nlh, nest);
 }
@@ -865,11 +881,137 @@
 	return 0;
 }
 
+static size_t attrsize[NFCT_ATTR_MAX] = {
+	[NFCT_ATTR_IPV4_SRC]		=	sizeof(u_int32_t),
+	[NFCT_ATTR_IPV4_DST]		=	sizeof(u_int32_t),
+	[NFCT_ATTR_IPV6_SRC]		=	sizeof(u_int32_t)*4,
+	[NFCT_ATTR_IPV6_DST]		= 	sizeof(u_int32_t)*4,
+	[NFCT_ATTR_L3PROTONUM]		=	sizeof(u_int8_t),
+	[NFCT_ATTR_PROTONUM]		=	sizeof(u_int8_t),
+	[NFCT_ATTR_PORT_SRC]		=	sizeof(u_int16_t),
+	[NFCT_ATTR_PORT_DST]		= 	sizeof(u_int16_t),
+	[NFCT_ATTR_ICMP_TYPE]		=	sizeof(u_int8_t),
+	[NFCT_ATTR_ICMP_CODE]		= 	sizeof(u_int8_t),
+	[NFCT_ATTR_ICMP_ID]		=	sizeof(u_int16_t),
+	[NFCT_ATTR_STATUS]		=	sizeof(u_int32_t),
+	[NFCT_ATTR_MARK]		=	sizeof(u_int32_t),
+	[NFCT_ATTR_ID]			=	sizeof(u_int32_t),
+	[NFCT_ATTR_TCP_STATE]		=	sizeof(u_int8_t),
+	[NFCT_ATTR_SRC_NAT]		=	sizeof(u_int32_t),
+	[NFCT_ATTR_DST_NAT]		=	sizeof(u_int32_t),
+	[NFCT_ATTR_SRC_MINIP_NAT]	=	sizeof(u_int32_t),
+	[NFCT_ATTR_SRC_MAXIP_NAT]	=	sizeof(u_int32_t),
+	[NFCT_ATTR_DST_MINIP_NAT]	=	sizeof(u_int32_t),
+	[NFCT_ATTR_DST_MAXIP_NAT]	=	sizeof(u_int32_t),
+};
+
+int nfct_tuple_set(struct nfct_tuple *tuple, void *data, 
+		   unsigned int datasize, int attr)
+{
+	union {
+		u_int32_t unsig32;
+		u_int16_t unsig16;
+		u_int8_t unsig8;
+	} *attrdata = data;
+
+	if (datasize != attrsize[attr])
+		return -1;
+
+	switch(attr) {
+	case NFCT_ATTR_IPV4_SRC:
+		tuple->src.v4 = attrdata->unsig32;
+		break;
+	case NFCT_ATTR_IPV4_DST:
+		tuple->dst.v4 = attrdata->unsig32;
+		break;
+	case NFCT_ATTR_IPV6_SRC:
+		memcpy(tuple->src.v6, &attrdata->unsig32, sizeof(u_int32_t)*4);
+		break;
+	case NFCT_ATTR_IPV6_DST:
+		memcpy(tuple->dst.v6, &attrdata->unsig32, sizeof(u_int32_t)*4);
+		break;
+	case NFCT_ATTR_L3PROTONUM:
+		tuple->l3protonum = attrdata->unsig8;
+		break;
+	case NFCT_ATTR_PROTONUM:
+		tuple->protonum = attrdata->unsig8;
+		break;
+	case NFCT_ATTR_PORT_SRC:
+		tuple->l4src.all = attrdata->unsig16;
+		break;
+	case NFCT_ATTR_PORT_DST:
+		tuple->l4dst.all = attrdata->unsig16;
+		break;
+	case NFCT_ATTR_ICMP_TYPE:
+		tuple->l4dst.icmp.type = attrdata->unsig8;
+		break;
+	case NFCT_ATTR_ICMP_CODE:
+		tuple->l4dst.icmp.code = attrdata->unsig8;
+		break;
+	case NFCT_ATTR_ICMP_ID:
+		tuple->l4src.icmp.id = attrdata->unsig16;
+		break;
+	default:
+		fprintf(stderr, "invalid attribute %d\n", attr);
+		return -1;
+	}
+
+	return 0;
+}
+
+int nfct_conntrack_set(struct nfct_conntrack *ct, void *data,
+		       unsigned int datasize, int attr)
+{
+	union {
+		u_int32_t unsig32;
+		u_int16_t unsig16;
+		u_int8_t unsig8;
+	} *attrdata = data;
+
+	if (datasize != attrsize[attr])
+		return -1;
+
+	switch(attr) {
+	case NFCT_ATTR_STATUS:
+		ct->status = attrdata->unsig32;
+		break;
+	case NFCT_ATTR_MARK:
+		ct->mark = attrdata->unsig32;
+		break;
+	case NFCT_ATTR_ID:
+		ct->id = attrdata->unsig32;
+		break;
+	case NFCT_ATTR_TCP_STATE:
+		ct->protoinfo.tcp.state = attrdata->unsig8;
+	case NFCT_ATTR_SRC_NAT:
+		ct->src_nat.min_ip = attrdata->unsig32;
+		ct->src_nat.max_ip = attrdata->unsig32;
+		break;
+	case NFCT_ATTR_DST_NAT:
+		ct->dst_nat.min_ip = attrdata->unsig32;
+		ct->dst_nat.max_ip = attrdata->unsig32;
+		break;
+	case NFCT_ATTR_SRC_MINIP_NAT:
+		ct->src_nat.min_ip = attrdata->unsig32;
+		break;
+	case NFCT_ATTR_SRC_MAXIP_NAT:
+		ct->src_nat.max_ip = attrdata->unsig32;
+		break;
+	case NFCT_ATTR_DST_MINIP_NAT:
+		ct->dst_nat.min_ip = attrdata->unsig32;
+		break;
+	case NFCT_ATTR_DST_MAXIP_NAT:
+		ct->dst_nat.max_ip = attrdata->unsig32;
+		break;
+	default:
+		fprintf(stderr, "invalid attribute %d", attr);
+		return -1;
+	}
+	return 0;
+}
+
 struct nfct_conntrack *
-nfct_conntrack_alloc(struct nfct_tuple *orig, struct nfct_tuple *reply,
-		     u_int32_t timeout, union nfct_protoinfo *proto,
-		     u_int32_t status, u_int32_t mark, 
-		     u_int32_t id, struct nfct_nat *range)
+nfct_conntrack_alloc(struct nfct_tuple *orig, struct nfct_tuple *reply)
 {
 	struct nfct_conntrack *ct;
 
@@ -880,14 +1022,6 @@
 
 	ct->tuple[NFCT_DIR_ORIGINAL] = *orig;
 	ct->tuple[NFCT_DIR_REPLY] = *reply;
-	ct->timeout = timeout;
-	ct->status = status;
-	ct->protoinfo = *proto;
-	ct->mark = mark;
-	if (id != NFCT_ANY_ID)
-		ct->id = id;
-	if (range)
-		ct->nat = *range;
 
 	return ct;
 }
@@ -981,8 +1115,10 @@
 			       sizeof(u_int32_t));
 
 	nfct_build_protoinfo(req, sizeof(buf), ct);
-	if (ct->nat.min_ip != 0)
-		nfct_build_nat(req, sizeof(buf), ct);
+	if (ct->src_nat.min_ip != 0)
+		nfct_build_nat(req, sizeof(buf), ct, CTA_NAT_SRC);
+	if (ct->dst_nat.min_ip != 0)
+		nfct_build_nat(req, sizeof(buf), ct, CTA_NAT_DST);
 
 	return nfnl_talk(cth->nfnlh, &req->nlh, 0, 0, NULL, NULL, NULL);
 }

--------------020405020007040800030607--
