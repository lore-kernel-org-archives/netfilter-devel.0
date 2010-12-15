From: Patrick McHardy <kaber@trash.net>
Subject: libxt_conntrack: add support for specifying port ranges
Date: Wed, 15 Dec 2010 17:20:35 +0100
Message-ID: <4D08EAD3.9010802@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080609040803010109080008"
To: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:54430 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040Ab0LOQUi (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Dec 2010 11:20:38 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by stinky.trash.net (Postfix) with ESMTP id EFB37B2C47
	for <netfilter-devel@vger.kernel.org>; Wed, 15 Dec 2010 17:20:35 +0100 (MET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------080609040803010109080008
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

This is the corresponding userspace patch for the xt_conntrack
port range patch I sent earlier.


--------------080609040803010109080008
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="x"

commit 884a6f8c1cbdeeca2394ee25ca88b8a87e1d1ae3
Author: Patrick McHardy <kaber@trash.net>
Date:   Wed Dec 15 08:09:28 2010 +0100

    libxt_conntrack: add support for specifying port ranges
    
    Add support for revision 3 of the conntrack match, which allows to specify port ranges
    for origsrc/origdst/replsrc/repldst.
    
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/extensions/libxt_conntrack.c b/extensions/libxt_conntrack.c
index dd3fb6f..7e0ac94 100644
--- a/extensions/libxt_conntrack.c
+++ b/extensions/libxt_conntrack.c
@@ -149,7 +149,7 @@ parse_states(const char *arg, struct xt_conntrack_info *sinfo)
 }
 
 static bool
-conntrack_ps_state(struct xt_conntrack_mtinfo2 *info, const char *state,
+conntrack_ps_state(struct xt_conntrack_mtinfo3 *info, const char *state,
                    size_t z)
 {
 	if (strncasecmp(state, "INVALID", z) == 0)
@@ -172,7 +172,7 @@ conntrack_ps_state(struct xt_conntrack_mtinfo2 *info, const char *state,
 }
 
 static void
-conntrack_ps_states(struct xt_conntrack_mtinfo2 *info, const char *arg)
+conntrack_ps_states(struct xt_conntrack_mtinfo3 *info, const char *arg)
 {
 	const char *comma;
 
@@ -223,7 +223,7 @@ parse_statuses(const char *arg, struct xt_conntrack_info *sinfo)
 }
 
 static bool
-conntrack_ps_status(struct xt_conntrack_mtinfo2 *info, const char *status,
+conntrack_ps_status(struct xt_conntrack_mtinfo3 *info, const char *status,
                     size_t z)
 {
 	if (strncasecmp(status, "NONE", z) == 0)
@@ -242,7 +242,7 @@ conntrack_ps_status(struct xt_conntrack_mtinfo2 *info, const char *status,
 }
 
 static void
-conntrack_ps_statuses(struct xt_conntrack_mtinfo2 *info, const char *arg)
+conntrack_ps_statuses(struct xt_conntrack_mtinfo3 *info, const char *arg)
 {
 	const char *comma;
 
@@ -297,7 +297,7 @@ parse_expires(const char *s, struct xt_conntrack_info *sinfo)
 }
 
 static void
-conntrack_ps_expires(struct xt_conntrack_mtinfo2 *info, const char *s)
+conntrack_ps_expires(struct xt_conntrack_mtinfo3 *info, const char *s)
 {
 	unsigned int min, max;
 	char *end;
@@ -470,11 +470,51 @@ static int conntrack_parse(int c, char **argv, int invert, unsigned int *flags,
 	return 1;
 }
 
+static void
+ct_parse_ports(const char *param, const char *str,
+	       u_int16_t *port_low, u_int16_t *port_high)
+{
+	unsigned int port;
+	char *buf, *cp;
+
+	buf = strdup(str);
+	cp = strchr(buf, ':');
+	if (cp != NULL)
+		*cp = '\0';
+
+	if (!xtables_strtoui(buf, NULL, &port, 0, UINT16_MAX))
+		xtables_param_act(XTF_BAD_VALUE, "conntrack", param, buf);
+
+	if (port_high == NULL) {
+		/* revision 0-2 do not support ranges */
+		if (cp != NULL)
+			xtables_error(PARAMETER_PROBLEM, "conntrack: "
+				      "port ranges not supported");
+
+		*port_low = htons(port);
+	} else {
+		*port_low = port;
+
+		if (cp != NULL) {
+			if (!xtables_strtoui(cp + 1, NULL, &port, 0, UINT16_MAX))
+				xtables_param_act(XTF_BAD_VALUE, "conntrack", param, buf);
+
+			*port_high = port;
+			if (*port_low > *port_high)
+				xtables_error(PARAMETER_PROBLEM,
+					      "invalid portrange (min > max)");
+		} else
+			*port_high = port;
+	}
+
+	free(buf);
+}
+
+
 static int
 conntrack_mt_parse(int c, bool invert, unsigned int *flags,
-                   struct xt_conntrack_mtinfo2 *info)
+                   struct xt_conntrack_mtinfo3 *info, bool v3)
 {
-	unsigned int port;
 	char *p;
 
 	switch (c) {
@@ -515,41 +555,41 @@ conntrack_mt_parse(int c, bool invert, unsigned int *flags,
 		break;
 
 	case 'a': /* --ctorigsrcport */
-		if (!xtables_strtoui(optarg, NULL, &port, 0, UINT16_MAX))
-			xtables_param_act(XTF_BAD_VALUE, "conntrack",
-			          "--ctorigsrcport", optarg);
+		ct_parse_ports("--ctorigsrcport", optarg,
+			       &info->origsrc_port,
+			       v3 ? &info->origsrc_port_high : NULL);
+
 		info->match_flags |= XT_CONNTRACK_ORIGSRC_PORT;
-		info->origsrc_port = htons(port);
 		if (invert)
 			info->invert_flags |= XT_CONNTRACK_ORIGSRC_PORT;
 		break;
 
 	case 'b': /* --ctorigdstport */
-		if (!xtables_strtoui(optarg, NULL, &port, 0, UINT16_MAX))
-			xtables_param_act(XTF_BAD_VALUE, "conntrack",
-			          "--ctorigdstport", optarg);
+		ct_parse_ports("--ctorigdstport", optarg,
+			       &info->origdst_port,
+			       v3 ? &info->origdst_port_high : NULL);
+
 		info->match_flags |= XT_CONNTRACK_ORIGDST_PORT;
-		info->origdst_port = htons(port);
 		if (invert)
 			info->invert_flags |= XT_CONNTRACK_ORIGDST_PORT;
 		break;
 
 	case 'c': /* --ctreplsrcport */
-		if (!xtables_strtoui(optarg, NULL, &port, 0, UINT16_MAX))
-			xtables_param_act(XTF_BAD_VALUE, "conntrack",
-			          "--ctreplsrcport", optarg);
+		ct_parse_ports("--ctreplsrcport", optarg,
+			       &info->replsrc_port,
+			       v3 ? &info->replsrc_port_high : NULL);
+
 		info->match_flags |= XT_CONNTRACK_REPLSRC_PORT;
-		info->replsrc_port = htons(port);
 		if (invert)
 			info->invert_flags |= XT_CONNTRACK_REPLSRC_PORT;
 		break;
 
 	case 'd': /* --ctrepldstport */
-		if (!xtables_strtoui(optarg, NULL, &port, 0, UINT16_MAX))
-			xtables_param_act(XTF_BAD_VALUE, "conntrack",
-			          "--ctrepldstport", optarg);
+		ct_parse_ports("--ctrepldstport", optarg,
+			       &info->repldst_port,
+			       v3 ? &info->repldst_port_high : NULL);
+
 		info->match_flags |= XT_CONNTRACK_REPLDST_PORT;
-		info->repldst_port = htons(port);
 		if (invert)
 			info->invert_flags |= XT_CONNTRACK_REPLDST_PORT;
 		break;
@@ -577,7 +617,7 @@ conntrack_mt_parse(int c, bool invert, unsigned int *flags,
 
 static int
 conntrack_mt4_parse(int c, bool invert, unsigned int *flags,
-                    struct xt_conntrack_mtinfo2 *info)
+                    struct xt_conntrack_mtinfo3 *info, bool v3)
 {
 	struct in_addr *addr = NULL;
 	unsigned int naddrs = 0;
@@ -637,7 +677,7 @@ conntrack_mt4_parse(int c, bool invert, unsigned int *flags,
 
 
 	default:
-		return conntrack_mt_parse(c, invert, flags, info);
+		return conntrack_mt_parse(c, invert, flags, info, v3);
 	}
 
 	*flags = info->match_flags;
@@ -646,7 +686,7 @@ conntrack_mt4_parse(int c, bool invert, unsigned int *flags,
 
 static int
 conntrack_mt6_parse(int c, bool invert, unsigned int *flags,
-                    struct xt_conntrack_mtinfo2 *info)
+                    struct xt_conntrack_mtinfo3 *info, bool v3)
 {
 	struct in6_addr *addr = NULL;
 	unsigned int naddrs = 0;
@@ -706,7 +746,7 @@ conntrack_mt6_parse(int c, bool invert, unsigned int *flags,
 
 
 	default:
-		return conntrack_mt_parse(c, invert, flags, info);
+		return conntrack_mt_parse(c, invert, flags, info, v3);
 	}
 
 	*flags = info->match_flags;
@@ -725,10 +765,10 @@ conntrack1_mt4_parse(int c, char **argv, int invert, unsigned int *flags,
                      const void *entry, struct xt_entry_match **match)
 {
 	struct xt_conntrack_mtinfo1 *info = (void *)(*match)->data;
-	struct xt_conntrack_mtinfo2 up;
+	struct xt_conntrack_mtinfo3 up;
 
 	cinfo_transform(&up, info);
-	if (!conntrack_mt4_parse(c, invert, flags, &up))
+	if (!conntrack_mt4_parse(c, invert, flags, &up, false))
 		return false;
 	cinfo_transform(info, &up);
 	return true;
@@ -739,10 +779,10 @@ conntrack1_mt6_parse(int c, char **argv, int invert, unsigned int *flags,
                      const void *entry, struct xt_entry_match **match)
 {
 	struct xt_conntrack_mtinfo1 *info = (void *)(*match)->data;
-	struct xt_conntrack_mtinfo2 up;
+	struct xt_conntrack_mtinfo3 up;
 
 	cinfo_transform(&up, info);
-	if (!conntrack_mt6_parse(c, invert, flags, &up))
+	if (!conntrack_mt6_parse(c, invert, flags, &up, false))
 		return false;
 	cinfo_transform(info, &up);
 	return true;
@@ -752,14 +792,28 @@ static int
 conntrack2_mt4_parse(int c, char **argv, int invert, unsigned int *flags,
                      const void *entry, struct xt_entry_match **match)
 {
-	return conntrack_mt4_parse(c, invert, flags, (void *)(*match)->data);
+	return conntrack_mt4_parse(c, invert, flags, (void *)(*match)->data, false);
 }
 
 static int
 conntrack2_mt6_parse(int c, char **argv, int invert, unsigned int *flags,
                      const void *entry, struct xt_entry_match **match)
 {
-	return conntrack_mt6_parse(c, invert, flags, (void *)(*match)->data);
+	return conntrack_mt6_parse(c, invert, flags, (void *)(*match)->data, false);
+}
+
+static int
+conntrack3_mt4_parse(int c, char **argv, int invert, unsigned int *flags,
+                     const void *entry, struct xt_entry_match **match)
+{
+	return conntrack_mt4_parse(c, invert, flags, (void *)(*match)->data, true);
+}
+
+static int
+conntrack3_mt6_parse(int c, char **argv, int invert, unsigned int *flags,
+                     const void *entry, struct xt_entry_match **match)
+{
+	return conntrack_mt6_parse(c, invert, flags, (void *)(*match)->data, true);
 }
 
 static void conntrack_mt_check(unsigned int flags)
@@ -982,8 +1036,18 @@ matchinfo_print(const void *ip, const struct xt_entry_match *match, int numeric,
 }
 
 static void
-conntrack_dump(const struct xt_conntrack_mtinfo2 *info, const char *prefix,
-               unsigned int family, bool numeric)
+conntrack_dump_ports(const char *prefix, const char *opt,
+		     u_int16_t port_low, u_int16_t port_high)
+{
+	if (port_high == 0 || port_low == port_high)
+		printf("%s%s %u ", prefix, opt, port_low);
+	else
+		printf("%s%s %u:%u ", prefix, opt, port_low, port_high);
+}
+
+static void
+conntrack_dump(const struct xt_conntrack_mtinfo3 *info, const char *prefix,
+               unsigned int family, bool numeric, bool v3)
 {
 	if (info->match_flags & XT_CONNTRACK_STATE) {
 		if (info->invert_flags & XT_CONNTRACK_STATE)
@@ -1033,29 +1097,33 @@ conntrack_dump(const struct xt_conntrack_mtinfo2 *info, const char *prefix,
 	if (info->match_flags & XT_CONNTRACK_ORIGSRC_PORT) {
 		if (info->invert_flags & XT_CONNTRACK_ORIGSRC_PORT)
 			printf("! ");
-		printf("%sctorigsrcport %u ", prefix,
-		       ntohs(info->origsrc_port));
+		conntrack_dump_ports(prefix, "ctorigsrcport",
+				     v3 ? info->origsrc_port : ntohs(info->origsrc_port),
+				     v3 ? info->origsrc_port_high : 0);
 	}
 
 	if (info->match_flags & XT_CONNTRACK_ORIGDST_PORT) {
 		if (info->invert_flags & XT_CONNTRACK_ORIGDST_PORT)
 			printf("! ");
-		printf("%sctorigdstport %u ", prefix,
-		       ntohs(info->origdst_port));
+		conntrack_dump_ports(prefix, "ctorigdstport",
+				     v3 ? info->origdst_port : ntohs(info->origdst_port),
+				     v3 ? info->origdst_port_high : 0);
 	}
 
 	if (info->match_flags & XT_CONNTRACK_REPLSRC_PORT) {
 		if (info->invert_flags & XT_CONNTRACK_REPLSRC_PORT)
 			printf("! ");
-		printf("%sctreplsrcport %u ", prefix,
-		       ntohs(info->replsrc_port));
+		conntrack_dump_ports(prefix, "ctreplsrcport",
+				     v3 ? info->replsrc_port : ntohs(info->replsrc_port),
+				     v3 ? info->replsrc_port_high : 0);
 	}
 
 	if (info->match_flags & XT_CONNTRACK_REPLDST_PORT) {
 		if (info->invert_flags & XT_CONNTRACK_REPLDST_PORT)
 			printf("! ");
-		printf("%sctrepldstport %u ", prefix,
-		       ntohs(info->repldst_port));
+		conntrack_dump_ports(prefix, "ctrepldstport",
+				     v3 ? info->repldst_port : ntohs(info->repldst_port),
+				     v3 ? info->repldst_port_high : 0);
 	}
 
 	if (info->match_flags & XT_CONNTRACK_STATUS) {
@@ -1096,10 +1164,10 @@ conntrack1_mt4_print(const void *ip, const struct xt_entry_match *match,
                      int numeric)
 {
 	const struct xt_conntrack_mtinfo1 *info = (void *)match->data;
-	struct xt_conntrack_mtinfo2 up;
+	struct xt_conntrack_mtinfo3 up;
 
 	cinfo_transform(&up, info);
-	conntrack_dump(&up, "", NFPROTO_IPV4, numeric);
+	conntrack_dump(&up, "", NFPROTO_IPV4, numeric, false);
 }
 
 static void
@@ -1107,24 +1175,38 @@ conntrack1_mt6_print(const void *ip, const struct xt_entry_match *match,
                      int numeric)
 {
 	const struct xt_conntrack_mtinfo1 *info = (void *)match->data;
-	struct xt_conntrack_mtinfo2 up;
+	struct xt_conntrack_mtinfo3 up;
 
 	cinfo_transform(&up, info);
-	conntrack_dump(&up, "", NFPROTO_IPV6, numeric);
+	conntrack_dump(&up, "", NFPROTO_IPV6, numeric, false);
 }
 
 static void
-conntrack_mt_print(const void *ip, const struct xt_entry_match *match,
-                   int numeric)
+conntrack2_mt_print(const void *ip, const struct xt_entry_match *match,
+                    int numeric)
 {
-	conntrack_dump((const void *)match->data, "", NFPROTO_IPV4, numeric);
+	conntrack_dump((const void *)match->data, "", NFPROTO_IPV4, numeric, false);
 }
 
 static void
-conntrack_mt6_print(const void *ip, const struct xt_entry_match *match,
+conntrack2_mt6_print(const void *ip, const struct xt_entry_match *match,
+                     int numeric)
+{
+	conntrack_dump((const void *)match->data, "", NFPROTO_IPV6, numeric, false);
+}
+
+static void
+conntrack3_mt_print(const void *ip, const struct xt_entry_match *match,
                     int numeric)
 {
-	conntrack_dump((const void *)match->data, "", NFPROTO_IPV6, numeric);
+	conntrack_dump((const void *)match->data, "", NFPROTO_IPV4, numeric, true);
+}
+
+static void
+conntrack3_mt6_print(const void *ip, const struct xt_entry_match *match,
+                     int numeric)
+{
+	conntrack_dump((const void *)match->data, "", NFPROTO_IPV6, numeric, true);
 }
 
 static void conntrack_save(const void *ip, const struct xt_entry_match *match)
@@ -1132,36 +1214,48 @@ static void conntrack_save(const void *ip, const struct xt_entry_match *match)
 	matchinfo_print(ip, match, 1, "--");
 }
 
-static void conntrack_mt_save(const void *ip,
-                              const struct xt_entry_match *match)
+static void conntrack3_mt_save(const void *ip,
+                               const struct xt_entry_match *match)
+{
+	conntrack_dump((const void *)match->data, "--", NFPROTO_IPV4, true, true);
+}
+
+static void conntrack3_mt6_save(const void *ip,
+                                const struct xt_entry_match *match)
 {
-	conntrack_dump((const void *)match->data, "--", NFPROTO_IPV4, true);
+	conntrack_dump((const void *)match->data, "--", NFPROTO_IPV6, true, true);
 }
 
-static void conntrack_mt6_save(const void *ip,
+static void conntrack2_mt_save(const void *ip,
                                const struct xt_entry_match *match)
 {
-	conntrack_dump((const void *)match->data, "--", NFPROTO_IPV6, true);
+	conntrack_dump((const void *)match->data, "--", NFPROTO_IPV4, true, false);
+}
+
+static void conntrack2_mt6_save(const void *ip,
+                                const struct xt_entry_match *match)
+{
+	conntrack_dump((const void *)match->data, "--", NFPROTO_IPV6, true, false);
 }
 
 static void
 conntrack1_mt4_save(const void *ip, const struct xt_entry_match *match)
 {
 	const struct xt_conntrack_mtinfo1 *info = (void *)match->data;
-	struct xt_conntrack_mtinfo2 up;
+	struct xt_conntrack_mtinfo3 up;
 
 	cinfo_transform(&up, info);
-	conntrack_dump(&up, "--", NFPROTO_IPV4, true);
+	conntrack_dump(&up, "--", NFPROTO_IPV4, true, false);
 }
 
 static void
 conntrack1_mt6_save(const void *ip, const struct xt_entry_match *match)
 {
 	const struct xt_conntrack_mtinfo1 *info = (void *)match->data;
-	struct xt_conntrack_mtinfo2 up;
+	struct xt_conntrack_mtinfo3 up;
 
 	cinfo_transform(&up, info);
-	conntrack_dump(&up, "--", NFPROTO_IPV6, true);
+	conntrack_dump(&up, "--", NFPROTO_IPV6, true, false);
 }
 
 static struct xtables_match conntrack_mt_reg[] = {
@@ -1217,8 +1311,8 @@ static struct xtables_match conntrack_mt_reg[] = {
 		.help          = conntrack_mt_help,
 		.parse         = conntrack2_mt4_parse,
 		.final_check   = conntrack_mt_check,
-		.print         = conntrack_mt_print,
-		.save          = conntrack_mt_save,
+		.print         = conntrack2_mt_print,
+		.save          = conntrack2_mt_save,
 		.extra_opts    = conntrack_mt_opts,
 	},
 	{
@@ -1231,8 +1325,36 @@ static struct xtables_match conntrack_mt_reg[] = {
 		.help          = conntrack_mt_help,
 		.parse         = conntrack2_mt6_parse,
 		.final_check   = conntrack_mt_check,
-		.print         = conntrack_mt6_print,
-		.save          = conntrack_mt6_save,
+		.print         = conntrack2_mt6_print,
+		.save          = conntrack2_mt6_save,
+		.extra_opts    = conntrack_mt_opts,
+	},
+	{
+		.version       = XTABLES_VERSION,
+		.name          = "conntrack",
+		.revision      = 3,
+		.family        = NFPROTO_IPV4,
+		.size          = XT_ALIGN(sizeof(struct xt_conntrack_mtinfo3)),
+		.userspacesize = XT_ALIGN(sizeof(struct xt_conntrack_mtinfo3)),
+		.help          = conntrack_mt_help,
+		.parse         = conntrack3_mt4_parse,
+		.final_check   = conntrack_mt_check,
+		.print         = conntrack3_mt_print,
+		.save          = conntrack3_mt_save,
+		.extra_opts    = conntrack_mt_opts,
+	},
+	{
+		.version       = XTABLES_VERSION,
+		.name          = "conntrack",
+		.revision      = 3,
+		.family        = NFPROTO_IPV6,
+		.size          = XT_ALIGN(sizeof(struct xt_conntrack_mtinfo3)),
+		.userspacesize = XT_ALIGN(sizeof(struct xt_conntrack_mtinfo3)),
+		.help          = conntrack_mt_help,
+		.parse         = conntrack3_mt6_parse,
+		.final_check   = conntrack_mt_check,
+		.print         = conntrack3_mt6_print,
+		.save          = conntrack3_mt6_save,
 		.extra_opts    = conntrack_mt_opts,
 	},
 };
diff --git a/extensions/libxt_conntrack.man b/extensions/libxt_conntrack.man
index d37ed17..c397f74 100644
--- a/extensions/libxt_conntrack.man
+++ b/extensions/libxt_conntrack.man
@@ -17,14 +17,15 @@ Layer-4 protocol to match (by number or name)
 [\fB!\fP] \fB\-\-ctrepldst\fP \fIaddress\fP[\fB/\fP\fImask\fP]
 Match against original/reply source/destination address
 .TP
-[\fB!\fP] \fB\-\-ctorigsrcport\fP \fIport\fP
+[\fB!\fP] \fB\-\-ctorigsrcport\fP \fIport\fP[\fB:\fP\fIport\fP]
 .TP
-[\fB!\fP] \fB\-\-ctorigdstport\fP \fIport\fP
+[\fB!\fP] \fB\-\-ctorigdstport\fP \fIport\fP[\fB:\fP\fIport\fP]
 .TP
-[\fB!\fP] \fB\-\-ctreplsrcport\fP \fIport\fP
+[\fB!\fP] \fB\-\-ctreplsrcport\fP \fIport\fP[\fB:\fP\fIport\fP]
 .TP
-[\fB!\fP] \fB\-\-ctrepldstport\fP \fIport\fP
+[\fB!\fP] \fB\-\-ctrepldstport\fP \fIport\fP[\fB:\fP\fIport\fP]
 Match against original/reply source/destination port (TCP/UDP/etc.) or GRE key.
+Matching against port ranges is only supported in kernel versions above 2.6.38.
 .TP
 [\fB!\fP] \fB\-\-ctstatus\fP \fIstatelist\fP
 \fIstatuslist\fP is a comma separated list of the connection statuses to match.
diff --git a/include/linux/netfilter/xt_conntrack.h b/include/linux/netfilter/xt_conntrack.h
index 54f47a2..74b904d 100644
--- a/include/linux/netfilter/xt_conntrack.h
+++ b/include/linux/netfilter/xt_conntrack.h
@@ -58,4 +58,19 @@ struct xt_conntrack_mtinfo2 {
 	__u16 state_mask, status_mask;
 };
 
+struct xt_conntrack_mtinfo3 {
+	union nf_inet_addr origsrc_addr, origsrc_mask;
+	union nf_inet_addr origdst_addr, origdst_mask;
+	union nf_inet_addr replsrc_addr, replsrc_mask;
+	union nf_inet_addr repldst_addr, repldst_mask;
+	__u32 expires_min, expires_max;
+	__u16 l4proto;
+	__u16 origsrc_port, origdst_port;
+	__u16 replsrc_port, repldst_port;
+	__u16 match_flags, invert_flags;
+	__u16 state_mask, status_mask;
+	__u16 origsrc_port_high, origdst_port_high;
+	__u16 replsrc_port_high, repldst_port_high;
+};
+
 #endif /*_XT_CONNTRACK_H*/

--------------080609040803010109080008--
