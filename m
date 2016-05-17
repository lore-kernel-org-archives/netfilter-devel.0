From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnetfilter_conntrack PATCH 1/3] src: add support for IPv6 to
 struct __nfct_nat
Date: Tue, 17 May 2016 14:50:32 +0200
Message-ID: <146348943198.4910.10995009662328384564.stgit@nfdev2.cica.es>
References: <146348935823.4910.10745657047372991575.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: fw@strlen.de
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:55664 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752304AbcEQMul (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 May 2016 08:50:41 -0400
In-Reply-To: <146348935823.4910.10745657047372991575.stgit@nfdev2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The conntrackd daemon lacks support for syncing IPv6 NATed connections.

This patch prepares the ground to give support to such operations:
 * replace uint32_t with union __nfct_address in struct __nfct_nat.
 * update all users of the former uint32_t to support the new struct

A follow-up patch gives support to actually manage the IPv6 NAT.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 include/internal/object.h |    2 +
 src/conntrack/build.c     |   35 ++++++++++++++++---------
 src/conntrack/build_mnl.c |   31 +++++++++++++++-------
 src/conntrack/copy.c      |    4 +--
 src/conntrack/getter.c    |    4 +--
 src/conntrack/objopt.c    |   63 ++++++++++++++++++++++++++++++++++-----------
 src/conntrack/setter.c    |    4 +--
 7 files changed, 98 insertions(+), 45 deletions(-)

diff --git a/include/internal/object.h b/include/internal/object.h
index ffbcb1f..bb14dc8 100644
--- a/include/internal/object.h
+++ b/include/internal/object.h
@@ -144,7 +144,7 @@ struct __nfct_counters {
 };
 
 struct __nfct_nat {
-	uint32_t 		min_ip, max_ip;
+	union __nfct_address	min_ip, max_ip;
 	union __nfct_l4_src 	l4min, l4max;
 };
 
diff --git a/src/conntrack/build.c b/src/conntrack/build.c
index 01bdefb..10d51fe 100644
--- a/src/conntrack/build.c
+++ b/src/conntrack/build.c
@@ -275,20 +275,30 @@ static void __build_protonat(struct nfnlhdr *req,
 
 static void __build_nat(struct nfnlhdr *req,
 			size_t size,
-			const struct __nfct_nat *nat)
+			const struct __nfct_nat *nat,
+			uint8_t l3protonum)
 {
-	nfnl_addattr_l(&req->nlh, size, CTA_NAT_MINIP,
-		       &nat->min_ip, sizeof(uint32_t));
+	switch (l3protonum) {
+	case AF_INET:
+		nfnl_addattr_l(&req->nlh, size, CTA_NAT_MINIP,
+			       &nat->min_ip.v4, sizeof(uint32_t));
+		break;
+	case AF_INET6:
+		break;
+	default:
+		break;
+	}
 }
 
 static void __build_snat(struct nfnlhdr *req,
 			 size_t size,
-			 const struct nf_conntrack *ct)
+			 const struct nf_conntrack *ct,
+			 uint8_t l3protonum)
 {
 	struct nfattr *nest;
 
 	nest = nfnl_nest(&req->nlh, size, CTA_NAT_SRC);
-	__build_nat(req, size, &ct->snat);
+	__build_nat(req, size, &ct->snat, l3protonum);
 	__build_protonat(req, size, ct, &ct->snat);
 	nfnl_nest_end(&req->nlh, nest);
 }
@@ -300,7 +310,7 @@ static void __build_snat_ipv4(struct nfnlhdr *req,
 	struct nfattr *nest;
 
 	nest = nfnl_nest(&req->nlh, size, CTA_NAT_SRC);
-	__build_nat(req, size, &ct->snat);
+	__build_nat(req, size, &ct->snat, AF_INET);
 	nfnl_nest_end(&req->nlh, nest);
 }
 
@@ -317,12 +327,13 @@ static void __build_snat_port(struct nfnlhdr *req,
 
 static void __build_dnat(struct nfnlhdr *req,
 			 size_t size,
-			 const struct nf_conntrack *ct)
+			 const struct nf_conntrack *ct,
+			 uint8_t l3protonum)
 {
 	struct nfattr *nest;
 
 	nest = nfnl_nest(&req->nlh, size, CTA_NAT_DST);
-	__build_nat(req, size, &ct->dnat);
+	__build_nat(req, size, &ct->dnat, l3protonum);
 	__build_protonat(req, size, ct, &ct->dnat);
 	nfnl_nest_end(&req->nlh, nest);
 }
@@ -334,7 +345,7 @@ static void __build_dnat_ipv4(struct nfnlhdr *req,
 	struct nfattr *nest;
 
 	nest = nfnl_nest(&req->nlh, size, CTA_NAT_DST);
-	__build_nat(req, size, &ct->dnat);
+	__build_nat(req, size, &ct->dnat, AF_INET);
 	nfnl_nest_end(&req->nlh, nest);
 }
 
@@ -514,9 +525,9 @@ int __build_conntrack(struct nfnl_subsys_handle *ssh,
 
 	__build_protoinfo(req, size, ct);
 
-	if (test_bit(ATTR_SNAT_IPV4, ct->head.set) && 
+	if (test_bit(ATTR_SNAT_IPV4, ct->head.set) &&
 	    test_bit(ATTR_SNAT_PORT, ct->head.set))
-		__build_snat(req, size, ct);
+		__build_snat(req, size, ct, AF_INET);
 	else if (test_bit(ATTR_SNAT_IPV4, ct->head.set))
 		__build_snat_ipv4(req, size, ct);
 	else if (test_bit(ATTR_SNAT_PORT, ct->head.set))
@@ -524,7 +535,7 @@ int __build_conntrack(struct nfnl_subsys_handle *ssh,
 
 	if (test_bit(ATTR_DNAT_IPV4, ct->head.set) &&
 	    test_bit(ATTR_DNAT_PORT, ct->head.set))
-		__build_dnat(req, size, ct);
+		__build_dnat(req, size, ct, AF_INET);
 	else if (test_bit(ATTR_DNAT_IPV4, ct->head.set))
 		__build_dnat_ipv4(req, size, ct);
 	else if (test_bit(ATTR_DNAT_PORT, ct->head.set))
diff --git a/src/conntrack/build_mnl.c b/src/conntrack/build_mnl.c
index 8ed0690..961b824 100644
--- a/src/conntrack/build_mnl.c
+++ b/src/conntrack/build_mnl.c
@@ -264,19 +264,29 @@ nfct_build_protonat(struct nlmsghdr *nlh, const struct nf_conntrack *ct,
 }
 
 static int
-nfct_build_nat(struct nlmsghdr *nlh, const struct __nfct_nat *nat)
+nfct_build_nat(struct nlmsghdr *nlh, const struct __nfct_nat *nat,
+	       uint8_t l3protonum)
 {
-	mnl_attr_put_u32(nlh, CTA_NAT_MINIP, nat->min_ip);
+	switch (l3protonum) {
+	case AF_INET:
+		mnl_attr_put_u32(nlh, CTA_NAT_MINIP, nat->min_ip.v4);
+		break;
+	case AF_INET6:
+		break;
+	default:
+		break;
+	}
 	return 0;
 }
 
 static int
-nfct_build_snat(struct nlmsghdr *nlh, const struct nf_conntrack *ct)
+nfct_build_snat(struct nlmsghdr *nlh, const struct nf_conntrack *ct,
+		uint8_t l3protonum)
 {
 	struct nlattr *nest;
 
 	nest = mnl_attr_nest_start(nlh, CTA_NAT_SRC);
-	nfct_build_nat(nlh, &ct->snat);
+	nfct_build_nat(nlh, &ct->snat, l3protonum);
 	nfct_build_protonat(nlh, ct, &ct->snat);
 	mnl_attr_nest_end(nlh, nest);
 	return 0;
@@ -288,7 +298,7 @@ nfct_build_snat_ipv4(struct nlmsghdr *nlh, const struct nf_conntrack *ct)
 	struct nlattr *nest;
 
 	nest = mnl_attr_nest_start(nlh, CTA_NAT_SRC);
-	nfct_build_nat(nlh, &ct->snat);
+	nfct_build_nat(nlh, &ct->snat, AF_INET);
 	mnl_attr_nest_end(nlh, nest);
 	return 0;
 }
@@ -305,12 +315,13 @@ nfct_build_snat_port(struct nlmsghdr *nlh, const struct nf_conntrack *ct)
 }
 
 static int
-nfct_build_dnat(struct nlmsghdr *nlh, const struct nf_conntrack *ct)
+nfct_build_dnat(struct nlmsghdr *nlh, const struct nf_conntrack *ct,
+		uint8_t l3protonum)
 {
 	struct nlattr *nest;
 
 	nest = mnl_attr_nest_start(nlh, CTA_NAT_DST);
-	nfct_build_nat(nlh, &ct->dnat);
+	nfct_build_nat(nlh, &ct->dnat, l3protonum);
 	nfct_build_protonat(nlh, ct, &ct->dnat);
 	mnl_attr_nest_end(nlh, nest);
 	return 0;
@@ -322,7 +333,7 @@ nfct_build_dnat_ipv4(struct nlmsghdr *nlh, const struct nf_conntrack *ct)
 	struct nlattr *nest;
 
 	nest = mnl_attr_nest_start(nlh, CTA_NAT_DST);
-	nfct_build_nat(nlh, &ct->dnat);
+	nfct_build_nat(nlh, &ct->dnat, AF_INET);
 	mnl_attr_nest_end(nlh, nest);
 	return 0;
 }
@@ -498,7 +509,7 @@ nfct_nlmsg_build(struct nlmsghdr *nlh, const struct nf_conntrack *ct)
 
 	if (test_bit(ATTR_SNAT_IPV4, ct->head.set) &&
 	    test_bit(ATTR_SNAT_PORT, ct->head.set)) {
-		nfct_build_snat(nlh, ct);
+		nfct_build_snat(nlh, ct, AF_INET);
 	} else if (test_bit(ATTR_SNAT_IPV4, ct->head.set)) {
 		nfct_build_snat_ipv4(nlh, ct);
 	} else if (test_bit(ATTR_SNAT_PORT, ct->head.set)) {
@@ -507,7 +518,7 @@ nfct_nlmsg_build(struct nlmsghdr *nlh, const struct nf_conntrack *ct)
 
 	if (test_bit(ATTR_DNAT_IPV4, ct->head.set) &&
 	    test_bit(ATTR_DNAT_PORT, ct->head.set)) {
-		nfct_build_dnat(nlh, ct);
+		nfct_build_dnat(nlh, ct, AF_INET);
 	} else if (test_bit(ATTR_DNAT_IPV4, ct->head.set)) {
 		nfct_build_dnat_ipv4(nlh, ct);
 	} else if (test_bit(ATTR_DNAT_PORT, ct->head.set)) {
diff --git a/src/conntrack/copy.c b/src/conntrack/copy.c
index 249e7e0..eac977b 100644
--- a/src/conntrack/copy.c
+++ b/src/conntrack/copy.c
@@ -287,13 +287,13 @@ static void copy_attr_dccp_handshake_seq(struct nf_conntrack *dest,
 static void copy_attr_snat_ipv4(struct nf_conntrack *dest,
 				const struct nf_conntrack *orig)
 {
-	dest->snat.min_ip = orig->snat.min_ip;
+	dest->snat.min_ip.v4 = orig->snat.min_ip.v4;
 }
 
 static void copy_attr_dnat_ipv4(struct nf_conntrack *dest,
 				const struct nf_conntrack *orig)
 {
-	dest->dnat.min_ip = orig->dnat.min_ip;
+	dest->dnat.min_ip.v4 = orig->dnat.min_ip.v4;
 }
 
 static void copy_attr_snat_port(struct nf_conntrack *dest,
diff --git a/src/conntrack/getter.c b/src/conntrack/getter.c
index ef4ec1d..20dd905 100644
--- a/src/conntrack/getter.c
+++ b/src/conntrack/getter.c
@@ -206,12 +206,12 @@ static const void *get_attr_sctp_vtag_repl(const struct nf_conntrack *ct)
 
 static const void *get_attr_snat_ipv4(const struct nf_conntrack *ct)
 {
-	return &ct->snat.min_ip;
+	return &ct->snat.min_ip.v4;
 }
 
 static const void *get_attr_dnat_ipv4(const struct nf_conntrack *ct)
 {
-	return &ct->dnat.min_ip;
+	return &ct->dnat.min_ip.v4;
 }
 
 static const void *get_attr_snat_port(const struct nf_conntrack *ct)
diff --git a/src/conntrack/objopt.c b/src/conntrack/objopt.c
index 5898746..3756bbe 100644
--- a/src/conntrack/objopt.c
+++ b/src/conntrack/objopt.c
@@ -52,18 +52,33 @@ static void __autocomplete(struct nf_conntrack *ct, int dir)
 
 static void setobjopt_undo_snat(struct nf_conntrack *ct)
 {
-	ct->snat.min_ip = ct->repl.dst.v4;
-	ct->snat.max_ip = ct->snat.min_ip;
-	ct->repl.dst.v4 = ct->head.orig.src.v4;
-	set_bit(ATTR_SNAT_IPV4, ct->head.set);
+	switch (ct->head.orig.l3protonum) {
+	case AF_INET:
+		ct->snat.min_ip.v4 = ct->repl.dst.v4;
+		ct->snat.max_ip.v4 = ct->snat.min_ip.v4;
+		ct->repl.dst.v4 = ct->head.orig.src.v4;
+		set_bit(ATTR_SNAT_IPV4, ct->head.set);
+		break;
+	case AF_INET6:
+		break;
+	default:
+		break;
+	}
 }
 
 static void setobjopt_undo_dnat(struct nf_conntrack *ct)
 {
-	ct->dnat.min_ip = ct->repl.src.v4;
-	ct->dnat.max_ip = ct->dnat.min_ip;
-	ct->repl.src.v4 = ct->head.orig.dst.v4;
-	set_bit(ATTR_DNAT_IPV4, ct->head.set);
+	switch (ct->head.orig.l3protonum) {
+	case AF_INET:
+		ct->dnat.min_ip.v4 = ct->repl.src.v4;
+		ct->dnat.max_ip.v4 = ct->dnat.min_ip.v4;
+		ct->repl.src.v4 = ct->head.orig.dst.v4;
+		set_bit(ATTR_DNAT_IPV4, ct->head.set);
+	case AF_INET6:
+		break;
+	default:
+		break;
+	}
 }
 
 static void setobjopt_undo_spat(struct nf_conntrack *ct)
@@ -114,18 +129,34 @@ int __setobjopt(struct nf_conntrack *ct, unsigned int option)
 
 static int getobjopt_is_snat(const struct nf_conntrack *ct)
 {
-	return ((test_bit(ATTR_STATUS, ct->head.set) ?
-		ct->status & IPS_SRC_NAT_DONE : 1) &&
-		ct->repl.dst.v4 != 
-		ct->head.orig.src.v4);
+	if (!(test_bit(ATTR_STATUS, ct->head.set) ?
+		ct->status & IPS_SRC_NAT_DONE : 1))
+		return 0;
+
+	switch (ct->head.orig.l3protonum) {
+	case AF_INET:
+		return ct->repl.dst.v4 != ct->head.orig.src.v4;
+	case AF_INET6:
+		return 0;
+	default:
+		return 0;
+	}
 }
 
 static int getobjopt_is_dnat(const struct nf_conntrack *ct)
 {
-	return ((test_bit(ATTR_STATUS, ct->head.set) ?
-		ct->status & IPS_DST_NAT_DONE : 1) &&
-		ct->repl.src.v4 !=
-		ct->head.orig.dst.v4);
+	if (!(test_bit(ATTR_STATUS, ct->head.set) ?
+		ct->status & IPS_DST_NAT_DONE : 1))
+		return 0;
+
+	switch (ct->head.orig.l3protonum) {
+	case AF_INET:
+		return ct->repl.src.v4 != ct->head.orig.dst.v4;
+	case AF_INET6:
+		return 0;
+	default:
+		return 0;
+	}
 }
 
 static int getobjopt_is_spat(const struct nf_conntrack *ct)
diff --git a/src/conntrack/setter.c b/src/conntrack/setter.c
index a212461..e103646 100644
--- a/src/conntrack/setter.c
+++ b/src/conntrack/setter.c
@@ -237,13 +237,13 @@ set_attr_sctp_vtag_repl(struct nf_conntrack *ct, const void *value, size_t len)
 static void
 set_attr_snat_ipv4(struct nf_conntrack *ct, const void *value, size_t len)
 {
-	ct->snat.min_ip = ct->snat.max_ip = *((uint32_t *) value);
+	ct->snat.min_ip.v4 = ct->snat.max_ip.v4 = *((uint32_t *) value);
 }
 
 static void
 set_attr_dnat_ipv4(struct nf_conntrack *ct, const void *value, size_t len)
 {
-	ct->dnat.min_ip = ct->dnat.max_ip = *((uint32_t *) value);
+	ct->dnat.min_ip.v4 = ct->dnat.max_ip.v4 = *((uint32_t *) value);
 }
 
 static void

