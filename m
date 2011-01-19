From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 3/3] libxt_connlimit: support for dstaddr-supporting revision 1
Date: Wed, 19 Jan 2011 18:32:28 +0100
Message-ID: <1295458349-14106-4-git-send-email-jengelh@medozas.de>
References: <1295458349-14106-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org, jan.rovner@diadema.cz
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:40845 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753528Ab1ASRcf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 19 Jan 2011 12:32:35 -0500
In-Reply-To: <1295458349-14106-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_connlimit.c           |   97 +++++++++++++++++++++++++++-----
 extensions/libxt_connlimit.man         |   14 ++++-
 include/linux/netfilter/xt_connlimit.h |   14 ++++-
 3 files changed, 106 insertions(+), 19 deletions(-)

diff --git a/extensions/libxt_connlimit.c b/extensions/libxt_connlimit.c
index b249259..75eadf9 100644
--- a/extensions/libxt_connlimit.c
+++ b/extensions/libxt_connlimit.c
@@ -12,6 +12,7 @@
 enum {
 	FL_LIMIT = 1 << 0,
 	FL_MASK  = 1 << 1,
+	FL_ADDR  = 1 << 2,
 };
 
 static void connlimit_help(void)
@@ -20,13 +21,17 @@ static void connlimit_help(void)
 "connlimit match options:\n"
 "  --connlimit-upto n     match if the number of existing connections is 0..n\n"
 "  --connlimit-above n    match if the number of existing connections is >n\n"
-"  --connlimit-mask n     group hosts using prefix length (default: max len)\n");
+"  --connlimit-mask n     group hosts using prefix length (default: max len)\n"
+"  --connlimit-saddr      select source address for grouping\n"
+"  --connlimit-daddr      select destination addresses for grouping\n");
 }
 
 static const struct option connlimit_opts[] = {
 	{.name = "connlimit-upto",  .has_arg = true, .val = 'U'},
 	{.name = "connlimit-above", .has_arg = true, .val = 'A'},
 	{.name = "connlimit-mask",  .has_arg = true, .val = 'M'},
+	{.name = "connlimit-saddr", .has_arg = false, .val = 's'},
+	{.name = "connlimit-daddr", .has_arg = false, .val = 'd'},
 	XT_GETOPT_TABLEEND,
 };
 
@@ -60,9 +65,12 @@ static void prefix_to_netmask(uint32_t *mask, unsigned int prefix_len)
 	mask[3] = htonl(mask[3]);
 }
 
-static int connlimit_parse(int c, char **argv, int invert, unsigned int *flags,
-                           struct xt_connlimit_info *info, unsigned int family)
+static int
+connlimit_parse(int c, char **argv, int invert, unsigned int *flags,
+                struct xt_entry_match **match, unsigned int family)
 {
+	struct xt_connlimit_info *info = (void *)(*match)->data;
+	const unsigned int revision = (*match)->u.user.revision;
 	char *err;
 	int i;
 
@@ -72,7 +80,7 @@ static int connlimit_parse(int c, char **argv, int invert, unsigned int *flags,
 			"--connlimit-{upto,above}", *flags & FL_LIMIT);
 		*flags |= FL_LIMIT;
 		if (invert)
-			info->inverse = true;
+			info->flags |= XT_CONNLIMIT_INVERT;
 		info->limit = strtoul(optarg, NULL, 0);
 		return true;
 	case 'U': /* --connlimit-upto */
@@ -80,7 +88,7 @@ static int connlimit_parse(int c, char **argv, int invert, unsigned int *flags,
 			"--connlimit-{upto,above}", *flags & FL_LIMIT);
 		*flags |= FL_LIMIT;
 		if (!invert)
-			info->inverse = true;
+			info->flags |= XT_CONNLIMIT_INVERT;
 		info->limit = strtoul(optarg, NULL, 0);
 		return true;
 	case 'M': /* --connlimit-mask */
@@ -107,6 +115,16 @@ static int connlimit_parse(int c, char **argv, int invert, unsigned int *flags,
 				info->v4_mask = htonl(0xFFFFFFFF << (32 - i));
 		}
 		return true;
+	case 's': /* --connlimit-saddr */
+		info->flags &= ~XT_CONNLIMIT_DADDR;
+		return true;
+	case 'd': /* --connlimit-daddr */
+		if (revision < 1)
+			xtables_error(PARAMETER_PROBLEM,
+				"xt_connlimit.0 does not support "
+				"--connlimit-daddr");
+		info->flags |= XT_CONNLIMIT_DADDR;
+		return true;
 	}
 	return false;
 }
@@ -115,16 +133,14 @@ static int connlimit_parse4(int c, char **argv, int invert,
                             unsigned int *flags, const void *entry,
                             struct xt_entry_match **match)
 {
-	return connlimit_parse(c, argv, invert, flags,
-	       (void *)(*match)->data, NFPROTO_IPV4);
+	return connlimit_parse(c, argv, invert, flags, match, NFPROTO_IPV4);
 }
 
 static int connlimit_parse6(int c, char **argv, int invert,
                             unsigned int *flags, const void *entry,
                             struct xt_entry_match **match)
 {
-	return connlimit_parse(c, argv, invert, flags,
-	       (void *)(*match)->data, NFPROTO_IPV6);
+	return connlimit_parse(c, argv, invert, flags, match, NFPROTO_IPV6);
 }
 
 static void connlimit_check(unsigned int flags)
@@ -160,43 +176,93 @@ static void connlimit_print4(const void *ip,
 {
 	const struct xt_connlimit_info *info = (const void *)match->data;
 
-	printf("#conn/%u %s %u ", count_bits4(info->v4_mask),
-	       info->inverse ? "<=" : ">", info->limit);
+	printf("#conn %s/%u %s %u ",
+	       (info->flags & XT_CONNLIMIT_DADDR) ? "dst" : "src",
+	       count_bits4(info->v4_mask),
+	       (info->flags & XT_CONNLIMIT_INVERT) ? "<=" : ">", info->limit);
 }
 
 static void connlimit_print6(const void *ip,
                              const struct xt_entry_match *match, int numeric)
 {
 	const struct xt_connlimit_info *info = (const void *)match->data;
-	printf("#conn/%u %s %u ", count_bits6(info->v6_mask),
-	       info->inverse ? "<=" : ">", info->limit);
+
+	printf("#conn %s/%u %s %u ",
+	       (info->flags & XT_CONNLIMIT_DADDR) ? "dst" : "src",
+	       count_bits6(info->v6_mask),
+	       (info->flags & XT_CONNLIMIT_INVERT) ? "<=" : ">", info->limit);
 }
 
 static void connlimit_save4(const void *ip, const struct xt_entry_match *match)
 {
 	const struct xt_connlimit_info *info = (const void *)match->data;
+	const int revision = match->u.user.revision;
 
-	if (info->inverse)
+	if (info->flags & XT_CONNLIMIT_INVERT)
 		printf("--connlimit-upto %u ", info->limit);
 	else
 		printf("--connlimit-above %u ", info->limit);
 	printf("--connlimit-mask %u ", count_bits4(info->v4_mask));
+	if (revision >= 1) {
+		if (info->flags & XT_CONNLIMIT_DADDR)
+			printf("--connlimit-daddr ");
+		else
+			printf("--connlimit-saddr ");
+	}
 }
 
 static void connlimit_save6(const void *ip, const struct xt_entry_match *match)
 {
 	const struct xt_connlimit_info *info = (const void *)match->data;
+	const int revision = match->u.user.revision;
 
-	if (info->inverse)
+	if (info->flags & XT_CONNLIMIT_INVERT)
 		printf("--connlimit-upto %u ", info->limit);
 	else
 		printf("--connlimit-above %u ", info->limit);
 	printf("--connlimit-mask %u ", count_bits6(info->v6_mask));
+	if (revision >= 1) {
+		if (info->flags & XT_CONNLIMIT_DADDR)
+			printf("--connlimit-daddr ");
+		else
+			printf("--connlimit-saddr ");
+	}
 }
 
 static struct xtables_match connlimit_mt_reg[] = {
 	{
 		.name          = "connlimit",
+		.revision      = 0,
+		.family        = NFPROTO_IPV4,
+		.version       = XTABLES_VERSION,
+		.size          = XT_ALIGN(sizeof(struct xt_connlimit_info)),
+		.userspacesize = offsetof(struct xt_connlimit_info, data),
+		.help          = connlimit_help,
+		.init          = connlimit_init,
+		.parse         = connlimit_parse4,
+		.final_check   = connlimit_check,
+		.print         = connlimit_print4,
+		.save          = connlimit_save4,
+		.extra_opts    = connlimit_opts,
+	},
+	{
+		.name          = "connlimit",
+		.revision      = 0,
+		.family        = NFPROTO_IPV6,
+		.version       = XTABLES_VERSION,
+		.size          = XT_ALIGN(sizeof(struct xt_connlimit_info)),
+		.userspacesize = offsetof(struct xt_connlimit_info, data),
+		.help          = connlimit_help,
+		.init          = connlimit_init,
+		.parse         = connlimit_parse6,
+		.final_check   = connlimit_check,
+		.print         = connlimit_print6,
+		.save          = connlimit_save6,
+		.extra_opts    = connlimit_opts,
+	},
+	{
+		.name          = "connlimit",
+		.revision      = 1,
 		.family        = NFPROTO_IPV4,
 		.version       = XTABLES_VERSION,
 		.size          = XT_ALIGN(sizeof(struct xt_connlimit_info)),
@@ -211,6 +277,7 @@ static struct xtables_match connlimit_mt_reg[] = {
 	},
 	{
 		.name          = "connlimit",
+		.revision      = 1,
 		.family        = NFPROTO_IPV6,
 		.version       = XTABLES_VERSION,
 		.size          = XT_ALIGN(sizeof(struct xt_connlimit_info)),
diff --git a/extensions/libxt_connlimit.man b/extensions/libxt_connlimit.man
index ecc8027..bd369a6 100644
--- a/extensions/libxt_connlimit.man
+++ b/extensions/libxt_connlimit.man
@@ -11,7 +11,13 @@ Match if the number of existing connections is above \fIn\fP.
 Group hosts using the prefix length. For IPv4, this must be a number between
 (including) 0 and 32. For IPv6, between 0 and 128. If not specified, the
 maximum prefix length for the applicable protocol is used.
-.P
+.TP
+\fB\-\-connlimit\-saddr\fP
+Apply the limit onto the source group.
+.TP
+\fB\-\-connlimit\-daddr\fP
+Apply the limit onto the destination group.
+.PP
 Examples:
 .TP
 # allow 2 telnet connections per client host
@@ -21,7 +27,7 @@ iptables \-A INPUT \-p tcp \-\-syn \-\-dport 23 \-m connlimit \-\-connlimit\-abo
 iptables \-A INPUT \-p tcp \-\-syn \-\-dport 23 \-m connlimit \-\-connlimit\-upto 2 \-j ACCEPT
 .TP
 # limit the number of parallel HTTP requests to 16 per class C sized \
-network (24 bit netmask)
+source network (24 bit netmask)
 iptables \-p tcp \-\-syn \-\-dport 80 \-m connlimit \-\-connlimit\-above 16
 \-\-connlimit\-mask 24 \-j REJECT
 .TP
@@ -29,3 +35,7 @@ iptables \-p tcp \-\-syn \-\-dport 80 \-m connlimit \-\-connlimit\-above 16
 (ipv6)
 ip6tables \-p tcp \-\-syn \-\-dport 80 \-s fe80::/64 \-m connlimit \-\-connlimit\-above
 16 \-\-connlimit\-mask 64 \-j REJECT
+.TP
+# Limit the number of connections to a particular host:
+ip6tables \-p tcp \-\-syn \-\-dport 49152:65535 \-d 2001:db8::1 \-m connlimit
+\-\-connlimit-above 100 \-j REJECT
diff --git a/include/linux/netfilter/xt_connlimit.h b/include/linux/netfilter/xt_connlimit.h
index 7e3284b..d6c84c9 100644
--- a/include/linux/netfilter/xt_connlimit.h
+++ b/include/linux/netfilter/xt_connlimit.h
@@ -3,17 +3,27 @@
 
 struct xt_connlimit_data;
 
+enum {
+	XT_CONNLIMIT_INVERT = 1 << 0,
+	XT_CONNLIMIT_DADDR  = 1 << 1,
+};
+
 struct xt_connlimit_info {
 	union {
 		union nf_inet_addr mask;
-#ifndef __KERNEL__
 		union {
 			__be32 v4_mask;
 			__be32 v6_mask[4];
 		};
-#endif
 	};
 	unsigned int limit, inverse;
+	union {
+		/* revision 0 */
+		unsigned int inverse;
+
+		/* revision 1 */
+		__u32 flags;
+	};
 
 	/* Used internally by the kernel */
 	struct xt_connlimit_data *data __attribute__((aligned(8)));
-- 
1.7.1

