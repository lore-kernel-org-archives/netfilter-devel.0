From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [NETFILTER]: Deploy a prefix length to network mask mapping
 table
Date: Mon, 3 Mar 2008 12:34:19 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0803031226430.7660@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0802211633500.26109@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0802291946560.24056@fbirervta.pbzchgretzou.qr>
 <47CB67DB.1060800@netfilter.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: kaber@trash.net,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:48056 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752911AbYCCLeU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 3 Mar 2008 06:34:20 -0500
In-Reply-To: <47CB67DB.1060800@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Mar 3 2008 03:52, Pablo Neira Ayuso wrote:
>Jan Engelhardt wrote:
>> On Feb 21 2008 16:38, Jan Engelhardt wrote:
>>> this is now the proposed memory reduction of xt_conntrack as previously 
>>> mentioned in http://marc.info/?l=netfilter-devel&m=120334779109237&w=2 .
>>>
>>> Since xt_conntrack r1 is new, we can still modify it.
>>>
>>> ===
>>> commit 84622a5c5190ea1bf0a37695961714a04a99a9c0
>>> Author: Jan Engelhardt <jengelh@computergmbh.de>
>>> Date:   Thu Feb 21 16:33:32 2008 +0100
>>>
>>>    [NETFILTER]: Deploy a prefix length to network mask mapping table
>>>    
>>>    Userspace utilities commonly transform a prefix length (CIDR notation
>>>    like 192.168.222.1/32) into a full netmask before submitting it to
>>>    the kernel.
>>>    
>>>    The size of struct xt_conntrack_mtinfo1 is currently 152 bytes, of
>>>    which 64 bytes are for masks. By submitting prefix lengths to the
>>>    kernel, we can save 60 bytes (almost 40%) as prefix lengths can fit
>>>    into one uint8_t. Since we do not want to recompute the mask for each
>>>    invocation of the match function, a static translation table will be
>>>    used (net/core/pfxlen.c).
>>>    
>>>    The patch also removes xt_hashlimit's obsolete mask computation.
>> 
>> 
>> Can we merge this while r1 is not yet used by userspace?
>> If not, that's fine too, will queue it for 2.6.26.
>
>Attention, I'm about to release iptables-1.4.1 which includes the
>userspace part for this. I can still delay it a couple of days and
>rework the release tarball if you pass me the userspace part asap.

commit 55ad85c12405b61b8c3c082888c75d1559a93c1e
Author: Jan Engelhardt <jengelh@computergmbh.de>
Date:   Tue Feb 19 23:47:31 2008 +0100

    Reduce size of struct xt_conntrack_mtinfo1
    
    Reduce size of struct xt_conntrack_mtinfo1 by sending the prefix
    length to kernel-space and let it do a lookup to full IPv6 mask there.
    
    Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

diff --git a/extensions/libxt_conntrack.c b/extensions/libxt_conntrack.c
index d1c0aa0..d459611 100644
--- a/extensions/libxt_conntrack.c
+++ b/extensions/libxt_conntrack.c
@@ -548,63 +548,41 @@ conntrack_mt4_parse(int c, char **argv, int invert, unsigned int *flags,
                     const void *entry, struct xt_entry_match **match)
 {
 	struct xt_conntrack_mtinfo1 *info = (void *)(*match)->data;
-	struct in_addr *addr = NULL;
-	unsigned int naddrs = 0;
+	unsigned int pfx;
 
 	switch (c) {
 	case '3': /* --ctorigsrc */
-		ipparse_hostnetworkmask(optarg, &addr, &info->origsrc_mask.in,
-		                        &naddrs);
-		if (naddrs > 1)
-			exit_error(PARAMETER_PROBLEM,
-			           "multiple IP addresses not allowed");
-		if (naddrs == 1)
-			memcpy(&info->origsrc_addr.in, addr, sizeof(*addr));
+		ipparse_hostnetworkpfx(optarg, &info->origsrc_addr, &pfx);
+		info->origsrc_pfx  = pfx;
 		info->match_flags |= XT_CONNTRACK_ORIGSRC;
 		if (invert)
 			info->invert_flags |= XT_CONNTRACK_ORIGSRC;
 		break;
 
 	case '4': /* --ctorigdst */
-		ipparse_hostnetworkmask(optarg, &addr, &info->origdst_mask.in,
-		                        &naddrs);
-		if (naddrs > 1)
-			exit_error(PARAMETER_PROBLEM,
-			           "multiple IP addresses not allowed");
-		if (naddrs == 1)
-			memcpy(&info->origdst_addr.in, addr, sizeof(*addr));
+		ipparse_hostnetworkpfx(optarg, &info->origdst_addr, &pfx);
+		info->origdst_pfx  = pfx;
 		info->match_flags |= XT_CONNTRACK_ORIGDST;
 		if (invert)
 			info->invert_flags |= XT_CONNTRACK_ORIGDST;
 		break;
 
 	case '5': /* --ctreplsrc */
-		ipparse_hostnetworkmask(optarg, &addr, &info->replsrc_mask.in,
-		                        &naddrs);
-		if (naddrs > 1)
-			exit_error(PARAMETER_PROBLEM,
-			           "multiple IP addresses not allowed");
-		if (naddrs == 1)
-			memcpy(&info->replsrc_addr.in, addr, sizeof(*addr));
+		ipparse_hostnetworkpfx(optarg, &info->replsrc_addr, &pfx);
+		info->replsrc_pfx  = pfx;
 		info->match_flags |= XT_CONNTRACK_REPLSRC;
 		if (invert)
 			info->invert_flags |= XT_CONNTRACK_REPLSRC;
 		break;
 
 	case '6': /* --ctrepldst */
-		ipparse_hostnetworkmask(optarg, &addr, &info->repldst_mask.in,
-		                        &naddrs);
-		if (naddrs > 1)
-			exit_error(PARAMETER_PROBLEM,
-			           "multiple IP addresses not allowed");
-		if (naddrs == 1)
-			memcpy(&info->repldst_addr.in, addr, sizeof(*addr));
+		ipparse_hostnetworkpfx(optarg, &info->repldst_addr, &pfx);
+		info->repldst_pfx  = pfx;
 		info->match_flags |= XT_CONNTRACK_REPLDST;
 		if (invert)
 			info->invert_flags |= XT_CONNTRACK_REPLDST;
 		break;
 
-
 	default:
 		return conntrack_mt_parse(c, argv, invert, flags, match);
 	}
@@ -618,63 +596,41 @@ conntrack_mt6_parse(int c, char **argv, int invert, unsigned int *flags,
                     const void *entry, struct xt_entry_match **match)
 {
 	struct xt_conntrack_mtinfo1 *info = (void *)(*match)->data;
-	struct in6_addr *addr = NULL;
-	unsigned int naddrs = 0;
+	unsigned int pfx;
 
 	switch (c) {
 	case '3': /* --ctorigsrc */
-		ip6parse_hostnetworkmask(optarg, &addr,
-		                         &info->origsrc_mask.in6, &naddrs);
-		if (naddrs > 1)
-			exit_error(PARAMETER_PROBLEM,
-			           "multiple IP addresses not allowed");
-		if (naddrs == 1)
-			memcpy(&info->origsrc_addr.in6, addr, sizeof(*addr));
+		ip6parse_hostnetworkpfx(optarg, &info->origsrc_addr, &pfx);
+		info->origsrc_pfx  = pfx;
 		info->match_flags |= XT_CONNTRACK_ORIGSRC;
 		if (invert)
 			info->invert_flags |= XT_CONNTRACK_ORIGSRC;
 		break;
 
 	case '4': /* --ctorigdst */
-		ip6parse_hostnetworkmask(optarg, &addr,
-		                         &info->origdst_mask.in6, &naddrs);
-		if (naddrs > 1)
-			exit_error(PARAMETER_PROBLEM,
-			           "multiple IP addresses not allowed");
-		if (naddrs == 1)
-			memcpy(&info->origdst_addr.in, addr, sizeof(*addr));
+		ip6parse_hostnetworkpfx(optarg, &info->origdst_addr, &pfx);
+		info->origdst_pfx  = pfx;
 		info->match_flags |= XT_CONNTRACK_ORIGDST;
 		if (invert)
 			info->invert_flags |= XT_CONNTRACK_ORIGDST;
 		break;
 
 	case '5': /* --ctreplsrc */
-		ip6parse_hostnetworkmask(optarg, &addr,
-		                         &info->replsrc_mask.in6, &naddrs);
-		if (naddrs > 1)
-			exit_error(PARAMETER_PROBLEM,
-			           "multiple IP addresses not allowed");
-		if (naddrs == 1)
-			memcpy(&info->replsrc_addr.in, addr, sizeof(*addr));
+		ip6parse_hostnetworkpfx(optarg, &info->replsrc_addr, &pfx);
+		info->replsrc_pfx  = pfx;
 		info->match_flags |= XT_CONNTRACK_REPLSRC;
 		if (invert)
 			info->invert_flags |= XT_CONNTRACK_REPLSRC;
 		break;
 
 	case '6': /* --ctrepldst */
-		ip6parse_hostnetworkmask(optarg, &addr,
-		                         &info->repldst_mask.in6, &naddrs);
-		if (naddrs > 1)
-			exit_error(PARAMETER_PROBLEM,
-			           "multiple IP addresses not allowed");
-		if (naddrs == 1)
-			memcpy(&info->repldst_addr.in, addr, sizeof(*addr));
+		ip6parse_hostnetworkpfx(optarg, &info->repldst_addr, &pfx);
+		info->repldst_pfx  = pfx;
 		info->match_flags |= XT_CONNTRACK_REPLDST;
 		if (invert)
 			info->invert_flags |= XT_CONNTRACK_REPLDST;
 		break;
 
-
 	default:
 		return conntrack_mt_parse(c, argv, invert, flags, match);
 	}
@@ -753,23 +709,26 @@ print_status(unsigned int statusmask)
 }
 
 static void
-conntrack_dump_addr(const union nf_inet_addr *addr,
-                    const union nf_inet_addr *mask,
+conntrack_dump_addr(const union nf_inet_addr *addr, unsigned int prefix,
                     unsigned int family, bool numeric)
 {
 	if (family == AF_INET) {
-		if (!numeric && addr->ip == 0) {
+		if (numeric)
+			printf("%s/%u ", ipaddr_to_numeric(&addr->in), prefix);
+		else if (addr->ip == 0)
 			printf("anywhere ");
-			return;
-		}
-		printf("%s ", ipaddr_to_anyname(&addr->in));
+		else
+			printf("%s/%u ", ipaddr_to_anyname(&addr->in), prefix);
 	} else if (family == AF_INET6) {
-		if (!numeric && addr->ip6[0] == 0 && addr->ip6[1] == 0 &&
-		    addr->ip6[2] == 0 && addr->ip6[3] == 0) {
+		if (numeric)
+			printf("%s/%u ", ip6addr_to_numeric(&addr->in6),
+			       prefix);
+		else if ((addr->ip6[0] | addr->ip6[1] | addr->ip6[2] |
+		    addr->ip6[3]) == 0)
 			printf("anywhere ");
-			return;
-		}
-		printf("%s ", ip6addr_to_anyname(&addr->in6));
+		else
+			printf("%s/%u ", ip6addr_to_anyname(&addr->in6),
+			       prefix);
 	}
 }
 
@@ -901,7 +860,7 @@ conntrack_dump(const struct xt_conntrack_mtinfo1 *info, const char *prefix,
 		if (info->invert_flags & XT_CONNTRACK_PROTO)
 			printf("! ");
 		printf("%sctorigsrc ", prefix);
-		conntrack_dump_addr(&info->origsrc_addr, &info->origsrc_mask,
+		conntrack_dump_addr(&info->origsrc_addr, info->origsrc_pfx,
 		                    family, numeric);
 	}
 
@@ -909,7 +868,7 @@ conntrack_dump(const struct xt_conntrack_mtinfo1 *info, const char *prefix,
 		if (info->invert_flags & XT_CONNTRACK_PROTO)
 			printf("! ");
 		printf("%sctorigdst ", prefix);
-		conntrack_dump_addr(&info->origdst_addr, &info->origdst_mask,
+		conntrack_dump_addr(&info->origdst_addr, info->origdst_pfx,
 		                    family, numeric);
 	}
 
@@ -917,7 +876,7 @@ conntrack_dump(const struct xt_conntrack_mtinfo1 *info, const char *prefix,
 		if (info->invert_flags & XT_CONNTRACK_PROTO)
 			printf("! ");
 		printf("%sctreplsrc ", prefix);
-		conntrack_dump_addr(&info->replsrc_addr, &info->replsrc_mask,
+		conntrack_dump_addr(&info->replsrc_addr, info->replsrc_pfx,
 		                    family, numeric);
 	}
 
@@ -925,7 +884,7 @@ conntrack_dump(const struct xt_conntrack_mtinfo1 *info, const char *prefix,
 		if (info->invert_flags & XT_CONNTRACK_PROTO)
 			printf("! ");
 		printf("%sctrepldst ", prefix);
-		conntrack_dump_addr(&info->repldst_addr, &info->repldst_mask,
+		conntrack_dump_addr(&info->repldst_addr, info->repldst_pfx,
 		                    family, numeric);
 	}
 
diff --git a/include/linux/netfilter/xt_conntrack.h b/include/linux/netfilter/xt_conntrack.h
index 9e35ccd..d787786 100644
--- a/include/linux/netfilter/xt_conntrack.h
+++ b/include/linux/netfilter/xt_conntrack.h
@@ -68,16 +68,18 @@ struct xt_conntrack_info
 };
 
 struct xt_conntrack_mtinfo1 {
-	union nf_inet_addr origsrc_addr, origsrc_mask;
-	union nf_inet_addr origdst_addr, origdst_mask;
-	union nf_inet_addr replsrc_addr, replsrc_mask;
-	union nf_inet_addr repldst_addr, repldst_mask;
+	union nf_inet_addr origsrc_addr;
+	union nf_inet_addr origdst_addr;
+	union nf_inet_addr replsrc_addr;
+	union nf_inet_addr repldst_addr;
 	u_int32_t expires_min, expires_max;
 	u_int16_t l4proto;
-	u_int16_t origsrc_port, origdst_port;
-	u_int16_t replsrc_port, repldst_port;
+	__be16 origsrc_port, origdst_port;
+	__be16 replsrc_port, repldst_port;
 	u_int16_t match_flags, invert_flags;
 	u_int8_t state_mask, status_mask;
+	u_int8_t origsrc_pfx, origdst_pfx;
+	u_int8_t replsrc_pfx, repldst_pfx;
 };
 
 #endif /*_XT_CONNTRACK_H*/
diff --git a/include/xtables.h b/include/xtables.h
index 484e436..7a25b59 100644
--- a/include/xtables.h
+++ b/include/xtables.h
@@ -171,6 +171,8 @@ struct xtables_target
 #endif
 };
 
+union nf_inet_addr;
+
 extern char *lib_dir;
 
 extern void *fw_calloc(size_t count, size_t size);
@@ -241,6 +243,8 @@ extern const char *ipaddr_to_anyname(const struct in_addr *);
 extern const char *ipmask_to_numeric(const struct in_addr *);
 extern struct in_addr *numeric_to_ipaddr(const char *);
 extern struct in_addr *numeric_to_ipmask(const char *);
+extern void ipparse_hostnetworkpfx(const char *, union nf_inet_addr *,
+	unsigned int *);
 extern void ipparse_hostnetworkmask(const char *, struct in_addr **,
 	struct in_addr *, unsigned int *);
 
@@ -248,6 +252,8 @@ extern struct in6_addr *numeric_to_ip6addr(const char *);
 extern const char *ip6addr_to_numeric(const struct in6_addr *);
 extern const char *ip6addr_to_anyname(const struct in6_addr *);
 extern const char *ip6mask_to_numeric(const struct in6_addr *);
+extern void ip6parse_hostnetworkpfx(const char *, union nf_inet_addr *,
+	unsigned int *);
 extern void ip6parse_hostnetworkmask(const char *, struct in6_addr **,
 	struct in6_addr *, unsigned int *);
 
diff --git a/xtables.c b/xtables.c
index af4d3dc..4a9bedd 100644
--- a/xtables.c
+++ b/xtables.c
@@ -32,6 +32,7 @@
 #include <arpa/inet.h>
 
 #include <xtables.h>
+#include <linux/netfilter.h>
 
 #ifndef NO_SHARED_LIBS
 #include <dlfcn.h>
@@ -909,6 +910,36 @@ static struct in_addr *parse_ipmask(const char *mask)
 	return &maskaddr;
 }
 
+void ipparse_hostnetworkpfx(const char *name, union nf_inet_addr *addrp,
+                            unsigned int *maskp)
+{
+	unsigned int naddrs = 0;
+	struct in_addr *res;
+	char buf[256], *p;
+
+	strncpy(buf, name, sizeof(buf) - 1);
+	if ((p = strchr(buf, '/')) != NULL) {
+		*p = '\0';
+		if (!strtonum(p + 1, NULL, maskp, 0, 32))
+			exit_error(PARAMETER_PROBLEM, "Invalid mask");
+	} else {
+		*maskp = 32;
+	}
+
+	/* if a null mask is given, the name is ignored, like in "any/0" */
+	if (*maskp == 0)
+		strcpy(buf, "0.0.0.0");
+
+	res = ipparse_hostnetwork(buf, &naddrs);
+	if (naddrs == 0)
+		exit_error(PARAMETER_PROBLEM, "%s did not resolve to an address", name);
+	if (naddrs > 1)
+		exit_error(PARAMETER_PROBLEM, "%s resolved to more than one address", name);
+
+	memcpy(&addrp->in, res, sizeof(struct in_addr));
+	free(res);
+}
+
 void ipparse_hostnetworkmask(const char *name, struct in_addr **addrpp,
                              struct in_addr *maskp, unsigned int *naddrs)
 {
@@ -1133,6 +1164,36 @@ static struct in6_addr *parse_ip6mask(char *mask)
 	return &maskaddr;
 }
 
+void ip6parse_hostnetworkpfx(const char *name, union nf_inet_addr *addrp,
+                             unsigned int *maskp)
+{
+	unsigned int naddrs = 0;
+	struct in6_addr *res;
+	char buf[256], *p;
+
+	strncpy(buf, name, sizeof(buf) - 1);
+	if ((p = strchr(buf, '/')) != NULL) {
+		*p = '\0';
+		if (!strtonum(p + 1, NULL, maskp, 0, 128))
+			exit_error(PARAMETER_PROBLEM, "Invalid mask");
+	} else {
+		*maskp = 128;
+	}
+
+	/* if a null mask is given, the name is ignored, like in "any/0" */
+	if (*maskp == 0)
+		strcpy(buf, "::");
+
+	res = ip6parse_hostnetwork(buf, &naddrs);
+	if (naddrs == 0)
+		exit_error(PARAMETER_PROBLEM, "%s did not resolve to an address", name);
+	if (naddrs > 1)
+		exit_error(PARAMETER_PROBLEM, "%s resolved to more than one address", name);
+
+	memcpy(&addrp->in6, res, sizeof(struct in6_addr));
+	free(res);
+}
+
 void ip6parse_hostnetworkmask(const char *name, struct in6_addr **addrpp,
                               struct in6_addr *maskp, unsigned int *naddrs)
 {


