From: Pablo Neira <pablo@netfilter.org>
Subject: [PATCH 1/7] don't check nfattr_parse_nested return value
Date: Fri, 04 Nov 2005 19:00:16 +0100
Message-ID: <436BA1B0.9010702@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------050100080507040304080001"
Cc: Harald Welte <laforge@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
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
--------------050100080507040304080001
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

nfattr_parse_nested always returns success. So we don't need such
checking. It's unlikely that nfattr_parse would return something
different than 0 in the future, if that day comes for whatever reason we
could get the checking back.

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris

--------------050100080507040304080001
Content-Type: text/plain;
 name="04-parse_nested.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="04-parse_nested.patch"

nfattr_parse_nested always returns success. So we don't need such checking.
It's unlikely that nfattr_parse would return something different than 0 in
the future, if that day comes for whatever reason we could get the checking
back.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Index: net-2.6.git/net/ipv4/netfilter/ip_conntrack_netlink.c
===================================================================
--- net-2.6.git.orig/net/ipv4/netfilter/ip_conntrack_netlink.c	2005-11-04 17:45:17.000000000 +0100
+++ net-2.6.git/net/ipv4/netfilter/ip_conntrack_netlink.c	2005-11-04 18:31:07.000000000 +0100
@@ -482,9 +482,7 @@ ctnetlink_parse_tuple_ip(struct nfattr *
 
 	DEBUGP("entered %s\n", __FUNCTION__);
 
-	
-	if (nfattr_parse_nested(tb, CTA_IP_MAX, attr) < 0)
-		goto nfattr_failure;
+	nfattr_parse_nested(tb, CTA_IP_MAX, attr); 
 
 	if (nfattr_bad_size(tb, CTA_IP_MAX, cta_min_ip))
 		return -EINVAL;
@@ -500,9 +498,6 @@ ctnetlink_parse_tuple_ip(struct nfattr *
 	DEBUGP("leaving\n");
 
 	return 0;
-
-nfattr_failure:
-	return -1;
 }
 
 static const int cta_min_proto[CTA_PROTO_MAX] = {
@@ -524,8 +519,7 @@ ctnetlink_parse_tuple_proto(struct nfatt
 
 	DEBUGP("entered %s\n", __FUNCTION__);
 
-	if (nfattr_parse_nested(tb, CTA_PROTO_MAX, attr) < 0)
-		goto nfattr_failure;
+	nfattr_parse_nested(tb, CTA_PROTO_MAX, attr);
 
 	if (nfattr_bad_size(tb, CTA_PROTO_MAX, cta_min_proto))
 		return -EINVAL;
@@ -542,9 +536,6 @@ ctnetlink_parse_tuple_proto(struct nfatt
 	}
 	
 	return ret;
-
-nfattr_failure:
-	return -1;
 }
 
 static inline int
@@ -558,8 +549,7 @@ ctnetlink_parse_tuple(struct nfattr *cda
 
 	memset(tuple, 0, sizeof(*tuple));
 
-	if (nfattr_parse_nested(tb, CTA_TUPLE_MAX, cda[type-1]) < 0)
-		goto nfattr_failure;
+	nfattr_parse_nested(tb, CTA_TUPLE_MAX, cda[type-1]); 
 
 	if (!tb[CTA_TUPLE_IP-1])
 		return -EINVAL;
@@ -586,9 +576,6 @@ ctnetlink_parse_tuple(struct nfattr *cda
 	DEBUGP("leaving\n");
 
 	return 0;
-
-nfattr_failure:
-	return -1;
 }
 
 #ifdef CONFIG_IP_NF_NAT_NEEDED
@@ -606,11 +593,10 @@ static int ctnetlink_parse_nat_proto(str
 
 	DEBUGP("entered %s\n", __FUNCTION__);
 
-	if (nfattr_parse_nested(tb, CTA_PROTONAT_MAX, attr) < 0)
-		goto nfattr_failure;
+	nfattr_parse_nested(tb, CTA_PROTONAT_MAX, attr);
 
 	if (nfattr_bad_size(tb, CTA_PROTONAT_MAX, cta_min_protonat))
-		goto nfattr_failure;
+		return -EINVAL;
 
 	npt = ip_nat_proto_find_get(ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.protonum);
 	if (!npt)
@@ -629,9 +615,6 @@ static int ctnetlink_parse_nat_proto(str
 
 	DEBUGP("leaving\n");
 	return 0;
-
-nfattr_failure:
-	return -1;
 }
 
 static inline int
@@ -645,8 +628,7 @@ ctnetlink_parse_nat(struct nfattr *cda[]
 
 	memset(range, 0, sizeof(*range));
 	
-	if (nfattr_parse_nested(tb, CTA_NAT_MAX, cda[CTA_NAT-1]) < 0)
-		goto nfattr_failure;
+	nfattr_parse_nested(tb, CTA_NAT_MAX, cda[CTA_NAT-1]);
 
 	if (tb[CTA_NAT_MINIP-1])
 		range->min_ip = *(u_int32_t *)NFA_DATA(tb[CTA_NAT_MINIP-1]);
@@ -668,9 +650,6 @@ ctnetlink_parse_nat(struct nfattr *cda[]
 
 	DEBUGP("leaving\n");
 	return 0;
-
-nfattr_failure:
-	return -1;
 }
 #endif
 
@@ -681,8 +660,7 @@ ctnetlink_parse_help(struct nfattr *attr
 
 	DEBUGP("entered %s\n", __FUNCTION__);
 
-	if (nfattr_parse_nested(tb, CTA_HELP_MAX, attr) < 0)
-		goto nfattr_failure;
+	nfattr_parse_nested(tb, CTA_HELP_MAX, attr); 
 
 	if (!tb[CTA_HELP_NAME-1])
 		return -EINVAL;
@@ -690,9 +668,6 @@ ctnetlink_parse_help(struct nfattr *attr
 	*helper_name = NFA_DATA(tb[CTA_HELP_NAME-1]);
 
 	return 0;
-
-nfattr_failure:
-	return -1;
 }
 
 static int
@@ -960,8 +935,7 @@ ctnetlink_change_protoinfo(struct ip_con
 	u_int16_t npt = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.protonum;
 	int err = 0;
 
-	if (nfattr_parse_nested(tb, CTA_PROTOINFO_MAX, attr) < 0)
-		goto nfattr_failure;
+	nfattr_parse_nested(tb, CTA_PROTOINFO_MAX, attr); 
 
 	proto = ip_conntrack_proto_find_get(npt);
 	if (!proto)
@@ -972,9 +946,6 @@ ctnetlink_change_protoinfo(struct ip_con
 	ip_conntrack_proto_put(proto); 
 
 	return err;
-
-nfattr_failure:
-	return -ENOMEM;
 }
 
 static int

--------------050100080507040304080001--
