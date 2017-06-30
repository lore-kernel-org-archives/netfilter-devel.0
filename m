From: Varsha Rao <rvarsha016@gmail.com>
Subject: [PATCH nft 1/3] include: Remove datatype_register().
Date: Fri, 30 Jun 2017 14:56:19 +0530
Message-ID: <b88dbf72f3c57fb3e4d55ddb3685547aedd08b61.1498814530.git.rvarsha016@gmail.com>
References: <cover.1498814530.git.rvarsha016@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:33505 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751545AbdF3J0Z (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 30 Jun 2017 05:26:25 -0400
Received: by mail-pg0-f67.google.com with SMTP id u62so14821128pgb.0
        for <netfilter-devel@vger.kernel.org>; Fri, 30 Jun 2017 02:26:24 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <cover.1498814530.git.rvarsha016@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Remove datatype_register() function and its calling __init functions.
Add arguments of datatype_register() function to datatype array.

Signed-off-by: Varsha Rao <rvarsha016@gmail.com>
---
 include/ct.h       |  3 +++
 include/datatype.h |  1 -
 include/exthdr.h   |  1 +
 include/fib.h      |  2 ++
 include/meta.h     |  7 ++++++-
 include/proto.h    |  8 ++++++++
 include/rt.h       |  1 +
 src/ct.c           | 13 +++----------
 src/datatype.c     | 25 +++++++++++++++++++------
 src/exthdr.c       |  7 +------
 src/fib.c          |  7 +------
 src/meta.c         | 44 +++++---------------------------------------
 src/proto.c        | 24 ++++++------------------
 src/rt.c           |  7 +------
 14 files changed, 57 insertions(+), 93 deletions(-)

diff --git a/include/ct.h b/include/ct.h
index ae900ee..b8cd7bf 100644
--- a/include/ct.h
+++ b/include/ct.h
@@ -23,6 +23,9 @@ struct ct_template {
 	.len		= (__len),				\
 }
 
+extern const struct datatype ct_dir_type;
+extern const struct datatype ct_state_type;
+extern const struct datatype ct_status_type;
 extern struct expr *ct_expr_alloc(const struct location *loc,
 				  enum nft_ct_keys key, int8_t direction);
 extern void ct_expr_update_type(struct proto_ctx *ctx, struct expr *expr);
diff --git a/include/datatype.h b/include/datatype.h
index 58c4d3e..2e34591 100644
--- a/include/datatype.h
+++ b/include/datatype.h
@@ -152,7 +152,6 @@ struct datatype {
 	const struct symbol_table	*sym_tbl;
 };
 
-extern void datatype_register(const struct datatype *dtype);
 extern const struct datatype *datatype_lookup(enum datatypes type);
 extern const struct datatype *datatype_lookup_byname(const char *name);
 
diff --git a/include/exthdr.h b/include/exthdr.h
index a2647ee..97ccc38 100644
--- a/include/exthdr.h
+++ b/include/exthdr.h
@@ -89,5 +89,6 @@ extern const struct exthdr_desc exthdr_rt2;
 extern const struct exthdr_desc exthdr_frag;
 extern const struct exthdr_desc exthdr_dst;
 extern const struct exthdr_desc exthdr_mh;
+extern const struct datatype mh_type_type;
 
 #endif /* NFTABLES_EXTHDR_H */
diff --git a/include/fib.h b/include/fib.h
index 3a019e6..9ce681c 100644
--- a/include/fib.h
+++ b/include/fib.h
@@ -4,4 +4,6 @@
 extern struct expr *fib_expr_alloc(const struct location *loc,
 				   unsigned int flags,
 				   unsigned int result);
+extern const struct datatype fib_addr_type;
+
 #endif /* NFTABLES_FIB_H */
diff --git a/include/meta.h b/include/meta.h
index 5578460..ebef7d8 100644
--- a/include/meta.h
+++ b/include/meta.h
@@ -28,7 +28,12 @@ extern struct expr *meta_expr_alloc(const struct location *loc,
 
 struct stmt *meta_stmt_meta_iiftype(const struct location *loc, uint16_t type);
 
-const struct datatype ifindex_type;
+extern const struct datatype ifindex_type;
+extern const struct datatype tchandle_type;
+extern const struct datatype gid_type;
+extern const struct datatype uid_type;
+extern const struct datatype devgroup_type;
+extern const struct datatype pkttype_type;
 
 struct error_record *meta_key_parse(const struct location *loc,
 				    const char *name,
diff --git a/include/proto.h b/include/proto.h
index 01188ab..39aa485 100644
--- a/include/proto.h
+++ b/include/proto.h
@@ -322,4 +322,12 @@ extern const struct proto_desc proto_netdev;
 extern const struct proto_desc proto_unknown;
 extern const struct proto_hdr_template proto_unknown_template;
 
+extern const struct datatype icmp_type_type;
+extern const struct datatype tcp_flag_type;
+extern const struct datatype dccp_pkttype_type;
+extern const struct datatype arpop_type;
+extern const struct datatype icmp6_type_type;
+extern const struct datatype dscp_type;
+extern const struct datatype ecn_type;
+
 #endif /* NFTABLES_PROTO_H */
diff --git a/include/rt.h b/include/rt.h
index 728cf5f..bbffa74 100644
--- a/include/rt.h
+++ b/include/rt.h
@@ -26,6 +26,7 @@ struct rt_template {
 	.invalid	= (__invalid),					\
 }
 
+extern const struct datatype realm_type;
 extern struct expr *rt_expr_alloc(const struct location *loc,
 				  enum nft_rt_keys key, bool invalid);
 extern void rt_expr_update_type(struct proto_ctx *ctx, struct expr *expr);
diff --git a/src/ct.c b/src/ct.c
index c705750..9b7140b 100644
--- a/src/ct.c
+++ b/src/ct.c
@@ -44,7 +44,7 @@ static const struct symbol_table ct_state_tbl = {
 	}
 };
 
-static const struct datatype ct_state_type = {
+const struct datatype ct_state_type = {
 	.type		= TYPE_CT_STATE,
 	.name		= "ct_state",
 	.desc		= "conntrack state",
@@ -63,7 +63,7 @@ static const struct symbol_table ct_dir_tbl = {
 	}
 };
 
-static const struct datatype ct_dir_type = {
+const struct datatype ct_dir_type = {
 	.type		= TYPE_CT_DIR,
 	.name		= "ct_dir",
 	.desc		= "conntrack direction",
@@ -90,7 +90,7 @@ static const struct symbol_table ct_status_tbl = {
 	},
 };
 
-static const struct datatype ct_status_type = {
+const struct datatype ct_status_type = {
 	.type		= TYPE_CT_STATUS,
 	.name		= "ct_status",
 	.desc		= "conntrack status",
@@ -485,10 +485,3 @@ struct stmt *notrack_stmt_alloc(const struct location *loc)
 {
 	return stmt_alloc(loc, &notrack_stmt_ops);
 }
-
-static void __init ct_init(void)
-{
-	datatype_register(&ct_state_type);
-	datatype_register(&ct_dir_type);
-	datatype_register(&ct_status_type);
-}
diff --git a/src/datatype.c b/src/datatype.c
index 899e9c0..b3c8f66 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -40,23 +40,36 @@ static const struct datatype *datatypes[TYPE_MAX + 1] = {
 	[TYPE_IP6ADDR]		= &ip6addr_type,
 	[TYPE_ETHERADDR]	= &etheraddr_type,
 	[TYPE_ETHERTYPE]	= &ethertype_type,
+	[TYPE_ARPOP]		= &arpop_type,
 	[TYPE_INET_PROTOCOL]	= &inet_protocol_type,
 	[TYPE_INET_SERVICE]	= &inet_service_type,
+	[TYPE_ICMP_TYPE]	= &icmp_type_type,
+	[TYPE_TCP_FLAG]		= &tcp_flag_type,
+	[TYPE_DCCP_PKTTYPE]	= &dccp_pkttype_type,
+	[TYPE_MH_TYPE]		= &mh_type_type,
 	[TYPE_TIME]		= &time_type,
 	[TYPE_MARK]		= &mark_type,
+	[TYPE_IFINDEX]		= &ifindex_type,
 	[TYPE_ARPHRD]		= &arphrd_type,
+	[TYPE_REALM]		= &realm_type,
+	[TYPE_CLASSID]		= &tchandle_type,
+	[TYPE_UID]		= &uid_type,
+	[TYPE_GID]		= &gid_type,
+	[TYPE_CT_STATE]		= &ct_state_type,
+	[TYPE_CT_DIR]		= &ct_dir_type,
+	[TYPE_CT_STATUS]	= &ct_status_type,
+	[TYPE_ICMP6_TYPE]	= &icmp6_type_type,
+	[TYPE_PKTTYPE]		= &pkttype_type,
 	[TYPE_ICMP_CODE]	= &icmp_code_type,
 	[TYPE_ICMPV6_CODE]	= &icmpv6_code_type,
 	[TYPE_ICMPX_CODE]	= &icmpx_code_type,
+	[TYPE_DEVGROUP]		= &devgroup_type,
+	[TYPE_DSCP]		= &dscp_type,
+	[TYPE_ECN]		= &ecn_type,
+	[TYPE_FIB_ADDR]         = &fib_addr_type,
 	[TYPE_BOOLEAN]		= &boolean_type,
 };
 
-void datatype_register(const struct datatype *dtype)
-{
-	BUILD_BUG_ON(TYPE_MAX & ~TYPE_MASK);
-	datatypes[dtype->type] = dtype;
-}
-
 const struct datatype *datatype_lookup(enum datatypes type)
 {
 	if (type > TYPE_MAX)
diff --git a/src/exthdr.c b/src/exthdr.c
index f31deea..a678115 100644
--- a/src/exthdr.c
+++ b/src/exthdr.c
@@ -322,7 +322,7 @@ static const struct symbol_table mh_type_tbl = {
 	},
 };
 
-static const struct datatype mh_type_type = {
+const struct datatype mh_type_type = {
 	.type		= TYPE_MH_TYPE,
 	.name		= "mh_type",
 	.desc		= "Mobility Header Type",
@@ -343,8 +343,3 @@ const struct exthdr_desc exthdr_mh = {
 		[MHHDR_CHECKSUM]	= MH_FIELD("checksum", ip6mh_cksum, &integer_type),
 	},
 };
-
-static void __init exthdr_init(void)
-{
-	datatype_register(&mh_type_type);
-}
diff --git a/src/fib.c b/src/fib.c
index 28d2b1d..b3488af 100644
--- a/src/fib.c
+++ b/src/fib.c
@@ -42,7 +42,7 @@ static const struct symbol_table addrtype_tbl = {
 	}
 };
 
-static const struct datatype fib_addr_type = {
+const struct datatype fib_addr_type = {
 	.type		= TYPE_FIB_ADDR,
 	.name		= "fib_addrtype",
 	.desc		= "fib address type",
@@ -141,8 +141,3 @@ struct expr *fib_expr_alloc(const struct location *loc,
 
 	return expr;
 }
-
-static void __init fib_init(void)
-{
-	datatype_register(&fib_addr_type);
-}
diff --git a/src/meta.c b/src/meta.c
index a303318..e9334b8 100644
--- a/src/meta.c
+++ b/src/meta.c
@@ -47,29 +47,6 @@ static void __exit realm_table_exit(void)
 	rt_symbol_table_free(realm_tbl);
 }
 
-static void realm_type_print(const struct expr *expr, struct output_ctx *octx)
-{
-	return symbolic_constant_print(realm_tbl, expr, true, octx);
-}
-
-static struct error_record *realm_type_parse(const struct expr *sym,
-					     struct expr **res)
-{
-	return symbolic_constant_parse(sym, realm_tbl, res);
-}
-
-static const struct datatype realm_type = {
-	.type		= TYPE_REALM,
-	.name		= "realm",
-	.desc		= "routing realm",
-	.byteorder	= BYTEORDER_HOST_ENDIAN,
-	.size		= 4 * BITS_PER_BYTE,
-	.basetype	= &integer_type,
-	.print		= realm_type_print,
-	.parse		= realm_type_parse,
-	.flags		= DTYPE_F_PREFIX,
-};
-
 static void tchandle_type_print(const struct expr *expr,
 				struct output_ctx *octx)
 {
@@ -139,7 +116,7 @@ err:
 	return error(&sym->location, "Could not parse %s", sym->dtype->desc);
 }
 
-static const struct datatype tchandle_type = {
+const struct datatype tchandle_type = {
 	.type		= TYPE_CLASSID,
 	.name		= "classid",
 	.desc		= "TC classid",
@@ -264,7 +241,7 @@ static struct error_record *uid_type_parse(const struct expr *sym,
 	return NULL;
 }
 
-static const struct datatype uid_type = {
+const struct datatype uid_type = {
 	.type		= TYPE_UID,
 	.name		= "uid",
 	.desc		= "user ID",
@@ -316,7 +293,7 @@ static struct error_record *gid_type_parse(const struct expr *sym,
 	return NULL;
 }
 
-static const struct datatype gid_type = {
+const struct datatype gid_type = {
 	.type		= TYPE_GID,
 	.name		= "gid",
 	.desc		= "group ID",
@@ -344,7 +321,7 @@ static void pkttype_type_print(const struct expr *expr, struct output_ctx *octx)
 	return symbolic_constant_print(&pkttype_type_tbl, expr, false, octx);
 }
 
-static const struct datatype pkttype_type = {
+const struct datatype pkttype_type = {
 	.type		= TYPE_PKTTYPE,
 	.name		= "pkt_type",
 	.desc		= "packet type",
@@ -378,7 +355,7 @@ static struct error_record *devgroup_type_parse(const struct expr *sym,
 	return symbolic_constant_parse(sym, devgroup_tbl, res);
 }
 
-static const struct datatype devgroup_type = {
+const struct datatype devgroup_type = {
 	.type		= TYPE_DEVGROUP,
 	.name		= "devgroup",
 	.desc		= "devgroup name",
@@ -621,17 +598,6 @@ struct stmt *meta_stmt_alloc(const struct location *loc, enum nft_meta_keys key,
 	return stmt;
 }
 
-static void __init meta_init(void)
-{
-	datatype_register(&ifindex_type);
-	datatype_register(&realm_type);
-	datatype_register(&tchandle_type);
-	datatype_register(&uid_type);
-	datatype_register(&gid_type);
-	datatype_register(&devgroup_type);
-	datatype_register(&pkttype_type);
-}
-
 /*
  * @expr:	payload expression
  * @res:	dependency expression
diff --git a/src/proto.c b/src/proto.c
index 64d0632..7ac0ee0 100644
--- a/src/proto.c
+++ b/src/proto.c
@@ -406,7 +406,7 @@ static const struct symbol_table tcp_flag_tbl = {
 	},
 };
 
-static const struct datatype tcp_flag_type = {
+const struct datatype tcp_flag_type = {
 	.type		= TYPE_TCP_FLAG,
 	.name		= "tcp_flag",
 	.desc		= "TCP flag",
@@ -467,7 +467,7 @@ static const struct symbol_table dccp_pkttype_tbl = {
 	},
 };
 
-static const struct datatype dccp_pkttype_type = {
+const struct datatype dccp_pkttype_type = {
 	.type		= TYPE_DCCP_PKTTYPE,
 	.name		= "dccp_pkttype",
 	.desc		= "DCCP packet type",
@@ -545,7 +545,7 @@ static const struct symbol_table dscp_type_tbl = {
 	},
 };
 
-static const struct datatype dscp_type = {
+const struct datatype dscp_type = {
 	.type		= TYPE_DSCP,
 	.name		= "dscp",
 	.desc		= "Differentiated Services Code Point",
@@ -567,7 +567,7 @@ static const struct symbol_table ecn_type_tbl = {
 	},
 };
 
-static const struct datatype ecn_type = {
+const struct datatype ecn_type = {
 	.type		= TYPE_ECN,
 	.name		= "ecn",
 	.desc		= "Explicit Congestion Notification",
@@ -662,7 +662,7 @@ static const struct symbol_table icmp6_type_tbl = {
 	},
 };
 
-static const struct datatype icmp6_type_type = {
+const struct datatype icmp6_type_type = {
 	.type		= TYPE_ICMP6_TYPE,
 	.name		= "icmpv6_type",
 	.desc		= "ICMPv6 type",
@@ -807,7 +807,7 @@ static const struct symbol_table arpop_tbl = {
 	},
 };
 
-static const struct datatype arpop_type = {
+const struct datatype arpop_type = {
 	.type		= TYPE_ARPOP,
 	.name		= "arp_op",
 	.desc		= "ARP operation",
@@ -960,15 +960,3 @@ const struct proto_desc proto_netdev = {
 		[0]	= PROTO_META_TEMPLATE("protocol", &ethertype_type, NFT_META_PROTOCOL, 16),
 	},
 };
-
-static void __init proto_init(void)
-{
-	datatype_register(&icmp_type_type);
-	datatype_register(&tcp_flag_type);
-	datatype_register(&dccp_pkttype_type);
-	datatype_register(&arpop_type);
-	datatype_register(&ethertype_type);
-	datatype_register(&icmp6_type_type);
-	datatype_register(&dscp_type);
-	datatype_register(&ecn_type);
-}
diff --git a/src/rt.c b/src/rt.c
index eb5f9c3..530ebe6 100644
--- a/src/rt.c
+++ b/src/rt.c
@@ -45,7 +45,7 @@ static struct error_record *realm_type_parse(const struct expr *sym,
 	return symbolic_constant_parse(sym, realm_tbl, res);
 }
 
-static const struct datatype realm_type = {
+const struct datatype realm_type = {
 	.type		= TYPE_REALM,
 	.name		= "realm",
 	.desc		= "routing realm",
@@ -134,8 +134,3 @@ void rt_expr_update_type(struct proto_ctx *ctx, struct expr *expr)
 		break;
 	}
 }
-
-static void __init rt_init(void)
-{
-	datatype_register(&realm_type);
-}
-- 
2.9.4

