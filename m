From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: [PATCH v2 1/3] iptables: change 'iface' part in hash:net,iface set
Date: Mon,  9 Jul 2012 23:23:18 +0100
Message-ID: <09f86300bb1913aa4c6063618fbbcd84fac2e608.1341871200.git.mr.dash.four@googlemail.com>
References: <cover.1341871199.git.mr.dash.four@googlemail.com>
Cc: Mr Dash Four <mr.dash.four@googlemail.com>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Patrick McHardy <kaber@trash.net>
To: Netfilter Core Team <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:53044 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754593Ab2GIWXn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 Jul 2012 18:23:43 -0400
Received: by wibhm11 with SMTP id hm11so3847684wib.1
        for <netfilter-devel@vger.kernel.org>; Mon, 09 Jul 2012 15:23:42 -0700 (PDT)
In-Reply-To: <cover.1341871199.git.mr.dash.four@googlemail.com>
In-Reply-To: <cover.1341871199.git.mr.dash.four@googlemail.com>
References: <cover.1341871199.git.mr.dash.four@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Userspace changes to iptables, allowing 'in' and 'out' values to be
specified for the 'iface' part of hash:net,iface type sets only.

Man pages updated accordingly. This patch also makes some minor
corrections to the syntax of some console messages produced by
the set match and SET target.

Signed-off-by: Mr Dash Four <mr.dash.four@googlemail.com>
---
 extensions/libxt_SET.c                 |    9 +++--
 extensions/libxt_SET.man               |   23 +++++++------
 extensions/libxt_set.c                 |   15 ++++++---
 extensions/libxt_set.h                 |   58 +++++++++++++++++++++++++++++---
 extensions/libxt_set.man               |   20 +++++------
 include/linux/netfilter/ipset/ip_set.h |   32 ++++++++++++++++++
 6 files changed, 123 insertions(+), 34 deletions(-)

diff --git a/extensions/libxt_SET.c b/extensions/libxt_SET.c
index a11db39..967d905 100644
--- a/extensions/libxt_SET.c
+++ b/extensions/libxt_SET.c
@@ -176,7 +176,7 @@ parse_target(char **argv, int invert, struct xt_set_info *info,
 			      "setname `%s' too long, max %d characters.",
 			      optarg, IPSET_MAXNAMELEN - 1);
 
-	get_set_byname(optarg, info);
+	get_set_byname_with_features(optarg, info);
 	parse_dirs(argv[optind], info);
 	optind++;
 }
@@ -206,15 +206,20 @@ print_target(const char *prefix, const struct xt_set_info *info)
 {
 	int i;
 	char setname[IPSET_MAXNAMELEN];
+	char *ptr;
 
 	if (info->index == IPSET_INVALID_ID)
 		return;
 	get_set_byid(setname, info->index);
 	printf(" %s %s", prefix, setname);
 	for (i = 1; i <= info->dim; i++) {
+		if ((info->flags & IPSET_DIM_IFACE_INOUT) && i == IPSET_DIM_TWO)
+			ptr = (info->flags & (1 << i) ? "in" : "out");
+		else
+			ptr = (info->flags & (1 << i) ? "src" : "dst");
 		printf("%s%s",
 		       i == 1 ? " " : ",",
-		       info->flags & (1 << i) ? "src" : "dst");
+			ptr);
 	}
 }
 
diff --git a/extensions/libxt_SET.man b/extensions/libxt_SET.man
index 63eb383..747235f 100644
--- a/extensions/libxt_SET.man
+++ b/extensions/libxt_SET.man
@@ -1,25 +1,26 @@
-This modules adds and/or deletes entries from IP sets which can be defined 
+This module adds and/or deletes entries from IP sets which can be defined 
 by ipset(8).
 .TP
 \fB\-\-add\-set\fP \fIsetname\fP \fIflag\fP[\fB,\fP\fIflag\fP...]
-add the address(es)/port(s) of the packet to the sets
+add the address(es)/port(s) of the packet to the set
 .TP
 \fB\-\-del\-set\fP \fIsetname\fP \fIflag\fP[\fB,\fP\fIflag\fP...]
-delete the address(es)/port(s) of the packet from the sets
+delete the address(es)/port(s) of the packet from the set
 .IP
-where flags are
+where 'flag' above is comma separated list of
 .BR "src"
 and/or
 .BR "dst"
-specifications and there can be no more than six of them.
+with the exception of hash:ip,iface where in addition to the above flags, the following is also allowed for the 'iface' part of that set:
+.BR "in"
+or
+.BR "out" 
+corresponding to the incoming or outgoing network interface. The above flags cannot exceed six in total for a given set.
 .TP
 \fB\-\-timeout\fP \fIvalue\fP
-when adding entry, the timeout value to use instead of the default
-one from the set definition
+when adding an entry, the timeout value to use instead of the default one from the set definition.
 .TP
 \fB\-\-exist\fP
-when adding entry if it already exists, reset the timeout value
-to the specified one or to the default from the set definition
+when adding an entry, if such entry already exists, reset the timeout value to the specified one or to the default from the set definition.
 .PP
-Use of -j SET requires that ipset kernel support is provided, which, for
-standard kernels, is the case since Linux 2.6.39.
+Use of -j SET requires that ipset kernel support is provided, which, for standard kernels, is the case since Linux 2.6.39.
diff --git a/extensions/libxt_set.c b/extensions/libxt_set.c
index 77e3f07..dfc311a 100644
--- a/extensions/libxt_set.c
+++ b/extensions/libxt_set.c
@@ -60,7 +60,7 @@ set_parse_v0(int c, char **argv, int invert, unsigned int *flags,
 	case '2':
 		fprintf(stderr,
 			"--set option deprecated, please use --match-set\n");
-	case '1':		/* --match-set <set> <flag>[,<flag> */
+	case '1':		/* --match-set <set> <flag>[,<flag>] */
 		if (info->u.flags[0])
 			xtables_error(PARAMETER_PROBLEM,
 				      "--match-set can be specified only once");
@@ -140,7 +140,7 @@ set_parse_v1(int c, char **argv, int invert, unsigned int *flags,
 	case '2':
 		fprintf(stderr,
 			"--set option deprecated, please use --match-set\n");
-	case '1':		/* --match-set <set> <flag>[,<flag> */
+	case '1':		/* --match-set <set> <flag>[,<flag>] */
 		if (info->dim)
 			xtables_error(PARAMETER_PROBLEM,
 				      "--match-set can be specified only once");
@@ -158,9 +158,9 @@ set_parse_v1(int c, char **argv, int invert, unsigned int *flags,
 				      "setname `%s' too long, max %d characters.",
 				      optarg, IPSET_MAXNAMELEN - 1);
 
-		get_set_byname(optarg, info);
+		get_set_byname_with_features(optarg, info);
 		parse_dirs(argv[optind], info);
-		DEBUGP("parse: set index %u\n", info->index);
+		DEBUGP("parse: set index %u, set flags %u\n", info->index, info->flags);
 		optind++;
 		
 		*flags = 1;
@@ -175,6 +175,7 @@ print_match(const char *prefix, const struct xt_set_info *info)
 {
 	int i;
 	char setname[IPSET_MAXNAMELEN];
+	char *ptr;
 
 	get_set_byid(setname, info->index);
 	printf("%s %s %s",
@@ -182,9 +183,13 @@ print_match(const char *prefix, const struct xt_set_info *info)
 	       prefix,
 	       setname); 
 	for (i = 1; i <= info->dim; i++) {		
+		if ((info->flags & IPSET_DIM_IFACE_INOUT) && i == IPSET_DIM_TWO)
+			ptr = (info->flags & (1 << i) ? "in" : "out");
+		else
+			ptr = (info->flags & (1 << i) ? "src" : "dst");
 		printf("%s%s",
 		       i == 1 ? " " : ",",
-		       info->flags & (1 << i) ? "src" : "dst");
+		       ptr);
 	}
 }
 
diff --git a/extensions/libxt_set.h b/extensions/libxt_set.h
index 47c3f5b..d47e263 100644
--- a/extensions/libxt_set.h
+++ b/extensions/libxt_set.h
@@ -101,6 +101,39 @@ get_set_byname(const char *setname, struct xt_set_info *info)
 }
 
 static void
+get_set_byname_with_features(const char *setname, struct xt_set_info *info)
+{
+	struct ip_set_req_get_features req;
+	socklen_t size = sizeof(struct ip_set_req_get_features);
+	int res, sockfd;
+
+	sockfd = get_version(&req.version);
+	req.op = IP_SET_OP_GET_FEATURES;
+	strncpy(req.set.name, setname, IPSET_MAXNAMELEN);
+	req.set.name[IPSET_MAXNAMELEN - 1] = '\0';
+	res = getsockopt(sockfd, SOL_IP, SO_IP_SET, &req, &size);
+	close(sockfd);
+	if (res != 0 && errno== EBADMSG) { /* IP_SET_OP_GET_FEATURES not supported, revert back to IP_SET_OP_GET_BYNAME */
+		get_set_byname(setname, info);
+	} else {
+		if (res != 0)
+			xtables_error(OTHER_PROBLEM,
+				"Problem when communicating with ipset, errno=%d.\n",
+				errno);
+		if (size != sizeof(struct ip_set_req_get_features))
+			xtables_error(OTHER_PROBLEM,
+				"Incorrect return size from kernel during ipset lookup, "
+				"(want %zu, got %zu)\n",
+				sizeof(struct ip_set_req_get_features), (size_t)size);
+		if (req.set.index == IPSET_INVALID_ID)
+			xtables_error(PARAMETER_PROBLEM,
+				      "Set %s doesn't exist.\n", setname);
+		info->index = req.set.index;
+		info->flags |= req.features;
+	}
+}
+
+static void
 parse_dirs_v0(const char *opt_arg, struct xt_set_info_v0 *info)
 {
 	char *saved = strdup(opt_arg);
@@ -115,7 +148,7 @@ parse_dirs_v0(const char *opt_arg, struct xt_set_info_v0 *info)
 			info->u.flags[i++] |= IPSET_DST;
 		else
 			xtables_error(PARAMETER_PROBLEM,
-				"You must spefify (the comma separated list of) 'src' or 'dst'.");
+				"You must specify (comma separated list of) 'src' or 'dst'.");
 	}
 
 	if (tmp)
@@ -130,16 +163,31 @@ static void
 parse_dirs(const char *opt_arg, struct xt_set_info *info)
 {
 	char *saved = strdup(opt_arg);
+	__u8 saved_flags = info->flags;
 	char *ptr, *tmp = saved;
-	
+
+	/* clear everything else, but IPSET_INV_MATCH */
+	info->flags &= IPSET_INV_MATCH;
+
 	while (info->dim < IPSET_DIM_MAX && tmp != NULL) {
 		info->dim++;
 		ptr = strsep(&tmp, ",");
-		if (strncmp(ptr, "src", 3) == 0)
-			info->flags |= (1 << info->dim);
+		if (strncmp(ptr, "in", 2) == 0 && 	/* 'in' */
+			info->dim == IPSET_DIM_TWO && 	/* x,'in' */
+			saved_flags & IPSET_TYPE_IFACE)	/* hash:net,iface type set */
+				info->flags |= (1 << info->dim | IPSET_DIM_IFACE_INOUT);
+
+		else if (strncmp(ptr, "out", 3) == 0 && /* 'out' */
+			info->dim == IPSET_DIM_TWO && 	/* x,'out' */
+			saved_flags & IPSET_TYPE_IFACE)	/* hash:net,iface type set */
+				info->flags |= IPSET_DIM_IFACE_INOUT;
+
+		else if (strncmp(ptr, "src", 3) == 0)
+				info->flags |= (1 << info->dim);
+
 		else if (strncmp(ptr, "dst", 3) != 0)
 			xtables_error(PARAMETER_PROBLEM,
-				"You must spefify (the comma separated list of) 'src' or 'dst'.");
+				"You must specify (comma separated list of) 'src'|'dst' or 'in'|'out' just for the interface part of hash:net,iface set, if used.");
 	}
 
 	if (tmp)
diff --git a/extensions/libxt_set.man b/extensions/libxt_set.man
index 1ad9085..31be0eb 100644
--- a/extensions/libxt_set.man
+++ b/extensions/libxt_set.man
@@ -1,22 +1,20 @@
 This module matches IP sets which can be defined by ipset(8).
 .TP
 [\fB!\fP] \fB\-\-match\-set\fP \fIsetname\fP \fIflag\fP[\fB,\fP\fIflag\fP]...
-where flags are the comma separated list of
+where 'flag' above is comma separated list of
 .BR "src"
 and/or
 .BR "dst" 
-specifications and there can be no more than six of them. Hence the command
+with the exception of hash:ip,iface where, in addition to these two options, the following is also allowed for the 'iface' part:
+.BR "in" 
+or
+.BR "out" 
+corresponding to the incoming or outgoing network interface. The above options cannot exceed six in total for a given set. The command
 .IP
  iptables \-A FORWARD \-m set \-\-match\-set test src,dst
 .IP
-will match packets, for which (if the set type is ipportmap) the source
-address and destination port pair can be found in the specified set. If
-the set type of the specified set is single dimension (for example ipmap),
-then the command will match packets for which the source address can be
-found in the specified set. 
+will match packets for which, if the set is of type hash:ip,port for example, the source IP address and destination port pair can be found and matched successfully. If the specified set is one dimensional (i.e. bitmap:ip), then the command will match packets for which the source address can be found in the set specified.
 .PP
-The option \fB\-\-match\-set\fP can be replaced by \fB\-\-set\fP if that does 
-not clash with an option of other extensions.
+The option \fB\-\-match\-set\fP can be replaced by \fB\-\-set\fP if that does not clash with an option from other extensions.
 .PP
-Use of -m set requires that ipset kernel support is provided, which, for
-standard kernels, is the case since Linux 2.6.39.
+Use of -m set requires that ipset kernel support is provided, which, for standard kernels, is the case since Linux 2.6.39.
diff --git a/include/linux/netfilter/ipset/ip_set.h b/include/linux/netfilter/ipset/ip_set.h
index 79cb077..f2a038c 100644
--- a/include/linux/netfilter/ipset/ip_set.h
+++ b/include/linux/netfilter/ipset/ip_set.h
@@ -186,6 +186,10 @@ enum ip_set_dim {
 	 * If changed, new revision of iptables match/target is required.
 	 */
 	IPSET_DIM_MAX = 6,
+	/* 
+	 * Indicates whether the new 'iface' format (in/out) has been used.
+	 */
+	IPSET_DIM_IFACE = 7, 
 };
 
 /* Option flags for kernel operations */
@@ -194,8 +198,28 @@ enum ip_set_kopt {
 	IPSET_DIM_ONE_SRC = (1 << IPSET_DIM_ONE),
 	IPSET_DIM_TWO_SRC = (1 << IPSET_DIM_TWO),
 	IPSET_DIM_THREE_SRC = (1 << IPSET_DIM_THREE),
+	IPSET_DIM_IFACE_INOUT = (1 << IPSET_DIM_IFACE),
 };
 
+/* Set features */
+enum ip_set_feature {
+	IPSET_TYPE_IP_FLAG = 0,
+	IPSET_TYPE_IP = (1 << IPSET_TYPE_IP_FLAG),
+	IPSET_TYPE_PORT_FLAG = 1,
+	IPSET_TYPE_PORT = (1 << IPSET_TYPE_PORT_FLAG),
+	IPSET_TYPE_MAC_FLAG = 2,
+	IPSET_TYPE_MAC = (1 << IPSET_TYPE_MAC_FLAG),
+	IPSET_TYPE_IP2_FLAG = 3,
+	IPSET_TYPE_IP2 = (1 << IPSET_TYPE_IP2_FLAG),
+	IPSET_TYPE_NAME_FLAG = 4,
+	IPSET_TYPE_NAME = (1 << IPSET_TYPE_NAME_FLAG),
+	IPSET_TYPE_IFACE_FLAG = 5,
+	IPSET_TYPE_IFACE = (1 << IPSET_TYPE_IFACE_FLAG),
+	/* Strictly speaking not a feature, but a flag for dumping:
+	 * this settype must be dumped last */
+	IPSET_DUMP_LAST_FLAG = 7,
+	IPSET_DUMP_LAST = (1 << IPSET_DUMP_LAST_FLAG),
+};
 
 /* Interface to iptables/ip6tables */
 
@@ -216,6 +240,14 @@ struct ip_set_req_get_set {
 #define IP_SET_OP_GET_BYINDEX	0x00000007	/* Get set name by index */
 /* Uses ip_set_req_get_set */
 
+#define IP_SET_OP_GET_FEATURES	0x00000008	/* Get set features by name */
+struct ip_set_req_get_features {
+	unsigned int op;
+	unsigned int version;
+	__u8 features;
+	union ip_set_name_index set;
+};
+
 #define IP_SET_OP_VERSION	0x00000100	/* Ask kernel version */
 struct ip_set_req_version {
 	unsigned op;
-- 
1.7.10.4

