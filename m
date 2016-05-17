From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnetfilter_conntrack PATCH 2/3] src: add support for IPv6 NAT
Date: Tue, 17 May 2016 14:50:37 +0200
Message-ID: <146348943723.4910.7071079736393329605.stgit@nfdev2.cica.es>
References: <146348935823.4910.10745657047372991575.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: fw@strlen.de
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:55669 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752088AbcEQMup (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 May 2016 08:50:45 -0400
In-Reply-To: <146348935823.4910.10745657047372991575.stgit@nfdev2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The conntrackd daemon lacks support for syncing IPv6 NATed connections.

This patch adds support for managing the IPv6 part of struct __nfct_nat,
also updating the corresponsing symbols.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 .../libnetfilter_conntrack.h                       |    2 +
 src/conntrack/build.c                              |   34 ++++++++++++++++++++
 src/conntrack/build_mnl.c                          |   34 ++++++++++++++++++++
 src/conntrack/copy.c                               |   16 +++++++++
 src/conntrack/getter.c                             |   12 +++++++
 src/conntrack/objopt.c                             |   26 ++++++++++++++-
 src/conntrack/setter.c                             |   16 +++++++++
 7 files changed, 138 insertions(+), 2 deletions(-)

diff --git a/include/libnetfilter_conntrack/libnetfilter_conntrack.h b/include/libnetfilter_conntrack/libnetfilter_conntrack.h
index 22af622..6cba578 100644
--- a/include/libnetfilter_conntrack/libnetfilter_conntrack.h
+++ b/include/libnetfilter_conntrack/libnetfilter_conntrack.h
@@ -138,6 +138,8 @@ enum nf_conntrack_attr {
 	ATTR_CONNLABELS_MASK,			/* variable length */
 	ATTR_ORIG_ZONE,				/* u16 bits */
 	ATTR_REPL_ZONE,				/* u16 bits */
+	ATTR_SNAT_IPV6,				/* u128 bits */
+	ATTR_DNAT_IPV6,				/* u128 bits */
 	ATTR_MAX
 };
 
diff --git a/src/conntrack/build.c b/src/conntrack/build.c
index 10d51fe..0b15230 100644
--- a/src/conntrack/build.c
+++ b/src/conntrack/build.c
@@ -284,6 +284,8 @@ static void __build_nat(struct nfnlhdr *req,
 			       &nat->min_ip.v4, sizeof(uint32_t));
 		break;
 	case AF_INET6:
+		nfnl_addattr_l(&req->nlh, size, CTA_NAT_MINIP,
+			       &nat->min_ip.v6, sizeof(struct in6_addr));
 		break;
 	default:
 		break;
@@ -314,6 +316,17 @@ static void __build_snat_ipv4(struct nfnlhdr *req,
 	nfnl_nest_end(&req->nlh, nest);
 }
 
+static void __build_snat_ipv6(struct nfnlhdr *req,
+			      size_t size,
+			      const struct nf_conntrack *ct)
+{
+	struct nfattr *nest;
+
+	nest = nfnl_nest(&req->nlh, size, CTA_NAT_SRC);
+	__build_nat(req, size, &ct->snat, AF_INET6);
+	nfnl_nest_end(&req->nlh, nest);
+}
+
 static void __build_snat_port(struct nfnlhdr *req,
 			      size_t size,
 			      const struct nf_conntrack *ct)
@@ -349,6 +362,17 @@ static void __build_dnat_ipv4(struct nfnlhdr *req,
 	nfnl_nest_end(&req->nlh, nest);
 }
 
+static void __build_dnat_ipv6(struct nfnlhdr *req,
+			      size_t size,
+			      const struct nf_conntrack *ct)
+{
+	struct nfattr *nest;
+
+	nest = nfnl_nest(&req->nlh, size, CTA_NAT_DST);
+	__build_nat(req, size, &ct->dnat, AF_INET6);
+	nfnl_nest_end(&req->nlh, nest);
+}
+
 static void __build_dnat_port(struct nfnlhdr *req,
 			      size_t size,
 			      const struct nf_conntrack *ct)
@@ -528,16 +552,26 @@ int __build_conntrack(struct nfnl_subsys_handle *ssh,
 	if (test_bit(ATTR_SNAT_IPV4, ct->head.set) &&
 	    test_bit(ATTR_SNAT_PORT, ct->head.set))
 		__build_snat(req, size, ct, AF_INET);
+	else if (test_bit(ATTR_SNAT_IPV6, ct->head.set) &&
+		 test_bit(ATTR_SNAT_PORT, ct->head.set))
+		__build_snat(req, size, ct, AF_INET6);
 	else if (test_bit(ATTR_SNAT_IPV4, ct->head.set))
 		__build_snat_ipv4(req, size, ct);
+	else if (test_bit(ATTR_SNAT_IPV6, ct->head.set))
+		__build_snat_ipv6(req, size, ct);
 	else if (test_bit(ATTR_SNAT_PORT, ct->head.set))
 		__build_snat_port(req, size, ct);
 
 	if (test_bit(ATTR_DNAT_IPV4, ct->head.set) &&
 	    test_bit(ATTR_DNAT_PORT, ct->head.set))
 		__build_dnat(req, size, ct, AF_INET);
+	else if (test_bit(ATTR_DNAT_IPV6, ct->head.set) &&
+		 test_bit(ATTR_DNAT_PORT, ct->head.set))
+		__build_dnat(req, size, ct, AF_INET6);
 	else if (test_bit(ATTR_DNAT_IPV4, ct->head.set))
 		__build_dnat_ipv4(req, size, ct);
+	else if (test_bit(ATTR_DNAT_IPV6, ct->head.set))
+		__build_dnat_ipv6(req, size, ct);
 	else if (test_bit(ATTR_DNAT_PORT, ct->head.set))
 		__build_dnat_port(req, size, ct);
 
diff --git a/src/conntrack/build_mnl.c b/src/conntrack/build_mnl.c
index 961b824..2118bf3 100644
--- a/src/conntrack/build_mnl.c
+++ b/src/conntrack/build_mnl.c
@@ -272,6 +272,8 @@ nfct_build_nat(struct nlmsghdr *nlh, const struct __nfct_nat *nat,
 		mnl_attr_put_u32(nlh, CTA_NAT_MINIP, nat->min_ip.v4);
 		break;
 	case AF_INET6:
+		mnl_attr_put(nlh, CTA_NAT_V6_MINIP, sizeof(struct in6_addr),
+			     &nat->min_ip.v6);
 		break;
 	default:
 		break;
@@ -304,6 +306,17 @@ nfct_build_snat_ipv4(struct nlmsghdr *nlh, const struct nf_conntrack *ct)
 }
 
 static int
+nfct_build_snat_ipv6(struct nlmsghdr *nlh, const struct nf_conntrack *ct)
+{
+	struct nlattr *nest;
+
+	nest = mnl_attr_nest_start(nlh, CTA_NAT_SRC);
+	nfct_build_nat(nlh, &ct->snat, AF_INET6);
+	mnl_attr_nest_end(nlh, nest);
+	return 0;
+}
+
+static int
 nfct_build_snat_port(struct nlmsghdr *nlh, const struct nf_conntrack *ct)
 {
 	struct nlattr *nest;
@@ -339,6 +352,17 @@ nfct_build_dnat_ipv4(struct nlmsghdr *nlh, const struct nf_conntrack *ct)
 }
 
 static int
+nfct_build_dnat_ipv6(struct nlmsghdr *nlh, const struct nf_conntrack *ct)
+{
+	struct nlattr *nest;
+
+	nest = mnl_attr_nest_start(nlh, CTA_NAT_DST);
+	nfct_build_nat(nlh, &ct->dnat, AF_INET6);
+	mnl_attr_nest_end(nlh, nest);
+	return 0;
+}
+
+static int
 nfct_build_dnat_port(struct nlmsghdr *nlh, const struct nf_conntrack *ct)
 {
 	struct nlattr *nest;
@@ -510,8 +534,13 @@ nfct_nlmsg_build(struct nlmsghdr *nlh, const struct nf_conntrack *ct)
 	if (test_bit(ATTR_SNAT_IPV4, ct->head.set) &&
 	    test_bit(ATTR_SNAT_PORT, ct->head.set)) {
 		nfct_build_snat(nlh, ct, AF_INET);
+	} else if (test_bit(ATTR_SNAT_IPV6, ct->head.set) &&
+		   test_bit(ATTR_SNAT_PORT, ct->head.set)) {
+		nfct_build_snat(nlh, ct, AF_INET6);
 	} else if (test_bit(ATTR_SNAT_IPV4, ct->head.set)) {
 		nfct_build_snat_ipv4(nlh, ct);
+	} else if (test_bit(ATTR_SNAT_IPV6, ct->head.set)) {
+		nfct_build_snat_ipv6(nlh, ct);
 	} else if (test_bit(ATTR_SNAT_PORT, ct->head.set)) {
 		nfct_build_snat_port(nlh, ct);
 	}
@@ -519,8 +548,13 @@ nfct_nlmsg_build(struct nlmsghdr *nlh, const struct nf_conntrack *ct)
 	if (test_bit(ATTR_DNAT_IPV4, ct->head.set) &&
 	    test_bit(ATTR_DNAT_PORT, ct->head.set)) {
 		nfct_build_dnat(nlh, ct, AF_INET);
+	} else if (test_bit(ATTR_DNAT_IPV6, ct->head.set) &&
+		   test_bit(ATTR_DNAT_PORT, ct->head.set)) {
+		nfct_build_dnat(nlh, ct, AF_INET6);
 	} else if (test_bit(ATTR_DNAT_IPV4, ct->head.set)) {
 		nfct_build_dnat_ipv4(nlh, ct);
+	} else if (test_bit(ATTR_DNAT_IPV6, ct->head.set)) {
+		nfct_build_dnat_ipv6(nlh, ct);
 	} else if (test_bit(ATTR_DNAT_PORT, ct->head.set)) {
 		nfct_build_dnat_port(nlh, ct);
 	}
diff --git a/src/conntrack/copy.c b/src/conntrack/copy.c
index eac977b..e6e4f7a 100644
--- a/src/conntrack/copy.c
+++ b/src/conntrack/copy.c
@@ -296,6 +296,20 @@ static void copy_attr_dnat_ipv4(struct nf_conntrack *dest,
 	dest->dnat.min_ip.v4 = orig->dnat.min_ip.v4;
 }
 
+static void copy_attr_snat_ipv6(struct nf_conntrack *dest,
+				const struct nf_conntrack *orig)
+{
+	memcpy(&dest->snat.min_ip.v6, &orig->snat.min_ip.v6,
+	       sizeof(struct in6_addr));
+}
+
+static void copy_attr_dnat_ipv6(struct nf_conntrack *dest,
+				const struct nf_conntrack *orig)
+{
+	memcpy(&dest->dnat.min_ip.v6, &orig->dnat.min_ip.v6,
+	       sizeof(struct in6_addr));
+}
+
 static void copy_attr_snat_port(struct nf_conntrack *dest,
 				const struct nf_conntrack *orig)
 {
@@ -555,6 +569,8 @@ const copy_attr copy_attr_array[ATTR_MAX] = {
 	[ATTR_HELPER_INFO]		= copy_attr_help_info,
 	[ATTR_CONNLABELS]		= copy_attr_connlabels,
 	[ATTR_CONNLABELS_MASK]		= copy_attr_connlabels_mask,
+	[ATTR_SNAT_IPV6]		= copy_attr_snat_ipv6,
+	[ATTR_DNAT_IPV6]		= copy_attr_dnat_ipv6,
 };
 
 /* this is used by nfct_copy() with the NFCT_CP_OVERRIDE flag set. */
diff --git a/src/conntrack/getter.c b/src/conntrack/getter.c
index 20dd905..e818a05 100644
--- a/src/conntrack/getter.c
+++ b/src/conntrack/getter.c
@@ -214,6 +214,16 @@ static const void *get_attr_dnat_ipv4(const struct nf_conntrack *ct)
 	return &ct->dnat.min_ip.v4;
 }
 
+static const void *get_attr_snat_ipv6(const struct nf_conntrack *ct)
+{
+	return &ct->snat.min_ip.v6;
+}
+
+static const void *get_attr_dnat_ipv6(const struct nf_conntrack *ct)
+{
+	return &ct->dnat.min_ip.v6;
+}
+
 static const void *get_attr_snat_port(const struct nf_conntrack *ct)
 {
 	return &ct->snat.l4min.all;
@@ -430,4 +440,6 @@ const get_attr get_attr_array[ATTR_MAX] = {
 	[ATTR_HELPER_INFO]		= get_attr_helper_info,
 	[ATTR_CONNLABELS]		= get_attr_connlabels,
 	[ATTR_CONNLABELS_MASK]		= get_attr_connlabels_mask,
+	[ATTR_SNAT_IPV6]		= get_attr_snat_ipv6,
+	[ATTR_DNAT_IPV6]		= get_attr_dnat_ipv6,
 };
diff --git a/src/conntrack/objopt.c b/src/conntrack/objopt.c
index 3756bbe..d9e1e0d 100644
--- a/src/conntrack/objopt.c
+++ b/src/conntrack/objopt.c
@@ -60,6 +60,13 @@ static void setobjopt_undo_snat(struct nf_conntrack *ct)
 		set_bit(ATTR_SNAT_IPV4, ct->head.set);
 		break;
 	case AF_INET6:
+		memcpy(&ct->snat.min_ip.v6, &ct->repl.dst.v6,
+		       sizeof(struct in6_addr));
+		memcpy(&ct->snat.max_ip.v6, &ct->snat.min_ip.v6,
+		       sizeof(struct in6_addr));
+		memcpy(&ct->repl.dst.v6, &ct->head.orig.src.v6,
+		       sizeof(struct in6_addr));
+		set_bit(ATTR_SNAT_IPV6, ct->head.set);
 		break;
 	default:
 		break;
@@ -75,6 +82,13 @@ static void setobjopt_undo_dnat(struct nf_conntrack *ct)
 		ct->repl.src.v4 = ct->head.orig.dst.v4;
 		set_bit(ATTR_DNAT_IPV4, ct->head.set);
 	case AF_INET6:
+		memcpy(&ct->dnat.min_ip.v6, &ct->repl.src.v6,
+		       sizeof(struct in6_addr));
+		memcpy(&ct->dnat.max_ip.v6, &ct->dnat.min_ip.v6,
+		       sizeof(struct in6_addr));
+		memcpy(&ct->repl.src.v6, &ct->head.orig.dst.v6,
+		       sizeof(struct in6_addr));
+		set_bit(ATTR_DNAT_IPV6, ct->head.set);
 		break;
 	default:
 		break;
@@ -137,7 +151,11 @@ static int getobjopt_is_snat(const struct nf_conntrack *ct)
 	case AF_INET:
 		return ct->repl.dst.v4 != ct->head.orig.src.v4;
 	case AF_INET6:
-		return 0;
+		if (memcmp(&ct->repl.dst.v6, &ct->head.orig.src.v6,
+			   sizeof(struct in6_addr)) != 0)
+			return 1;
+		else
+			return 0;
 	default:
 		return 0;
 	}
@@ -153,7 +171,11 @@ static int getobjopt_is_dnat(const struct nf_conntrack *ct)
 	case AF_INET:
 		return ct->repl.src.v4 != ct->head.orig.dst.v4;
 	case AF_INET6:
-		return 0;
+		if (memcmp(&ct->repl.src.v6, &ct->head.orig.dst.v6,
+			   sizeof(struct in6_addr)) != 0)
+			return 1;
+		else
+			return 0;
 	default:
 		return 0;
 	}
diff --git a/src/conntrack/setter.c b/src/conntrack/setter.c
index e103646..75ab09e 100644
--- a/src/conntrack/setter.c
+++ b/src/conntrack/setter.c
@@ -247,6 +247,20 @@ set_attr_dnat_ipv4(struct nf_conntrack *ct, const void *value, size_t len)
 }
 
 static void
+set_attr_snat_ipv6(struct nf_conntrack *ct, const void *value, size_t len)
+{
+	memcpy(&ct->snat.min_ip.v6, value, sizeof(struct in6_addr));
+	memcpy(&ct->snat.max_ip.v6, value, sizeof(struct in6_addr));
+}
+
+static void
+set_attr_dnat_ipv6(struct nf_conntrack *ct, const void *value, size_t len)
+{
+	memcpy(&ct->dnat.min_ip.v6, value, sizeof(struct in6_addr));
+	memcpy(&ct->dnat.max_ip.v6, value, sizeof(struct in6_addr));
+}
+
+static void
 set_attr_snat_port(struct nf_conntrack *ct, const void *value, size_t len)
 {
 	ct->snat.l4min.all = ct->snat.l4max.all = *((uint16_t *) value);
@@ -527,4 +541,6 @@ const set_attr set_attr_array[ATTR_MAX] = {
 	[ATTR_HELPER_INFO]	= set_attr_helper_info,
 	[ATTR_CONNLABELS]	= set_attr_connlabels,
 	[ATTR_CONNLABELS_MASK]	= set_attr_connlabels_mask,
+	[ATTR_SNAT_IPV6]	= set_attr_snat_ipv6,
+	[ATTR_DNAT_IPV6]	= set_attr_dnat_ipv6,
 };

