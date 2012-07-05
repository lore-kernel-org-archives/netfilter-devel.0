From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: [PATCH 1/3] iptables: change 'iface' part in hash:net,iface set
Date: Thu,  5 Jul 2012 23:34:30 +0100
Message-ID: <24722657a8c6d7c7fc536edf2dfe59a04e67e4cd.1341525006.git.mr.dash.four@googlemail.com>
References: <cover.1341525006.git.mr.dash.four@googlemail.com>
Cc: Mr Dash Four <mr.dash.four@googlemail.com>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Patrick McHardy <kaber@trash.net>
To: Netfilter Core Team <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:54484 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932197Ab2GEWfV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 5 Jul 2012 18:35:21 -0400
Received: by wgbdr13 with SMTP id dr13so8732611wgb.1
        for <netfilter-devel@vger.kernel.org>; Thu, 05 Jul 2012 15:35:20 -0700 (PDT)
In-Reply-To: <cover.1341525006.git.mr.dash.four@googlemail.com>
In-Reply-To: <cover.1341525006.git.mr.dash.four@googlemail.com>
References: <cover.1341525006.git.mr.dash.four@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Userspace changes to iptables, allowing 'in' and 'out' values to be
specified for the 'iface' part of hash:net,iface type sets.

Man pages updated accordingly. This patch also makes some minor
corrections to the syntax of some console messages produced by
the set match and SET target.

Signed-off-by: Mr Dash Four <mr.dash.four@googlemail.com>
---
 extensions/libxt_SET.c                 |    7 ++++++-
 extensions/libxt_SET.man               |   23 ++++++++++++-----------
 extensions/libxt_set.c                 |   11 ++++++++---
 extensions/libxt_set.h                 |   10 +++++++---
 extensions/libxt_set.man               |   20 +++++++++-----------
 include/linux/netfilter/ipset/ip_set.h |    5 +++++
 6 files changed, 47 insertions(+), 29 deletions(-)

diff --git a/extensions/libxt_SET.c b/extensions/libxt_SET.c
index a11db39..d9f60c9 100644
--- a/extensions/libxt_SET.c
+++ b/extensions/libxt_SET.c
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
index 77e3f07..ba478ed 100644
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
index 47c3f5b..23830b2 100644
--- a/extensions/libxt_set.h
+++ b/extensions/libxt_set.h
@@ -115,7 +115,7 @@ parse_dirs_v0(const char *opt_arg, struct xt_set_info_v0 *info)
 			info->u.flags[i++] |= IPSET_DST;
 		else
 			xtables_error(PARAMETER_PROBLEM,
-				"You must spefify (the comma separated list of) 'src' or 'dst'.");
+				"You must specify (comma separated list of) 'src' or 'dst'.");
 	}
 
 	if (tmp)
@@ -135,11 +135,15 @@ parse_dirs(const char *opt_arg, struct xt_set_info *info)
 	while (info->dim < IPSET_DIM_MAX && tmp != NULL) {
 		info->dim++;
 		ptr = strsep(&tmp, ",");
-		if (strncmp(ptr, "src", 3) == 0)
+		if (strncmp(ptr, "in", 2) == 0 && info->dim == IPSET_DIM_TWO)
+			info->flags |= (1 << info->dim | IPSET_DIM_IFACE_INOUT);
+		else if (strncmp(ptr, "out", 3) == 0 && info->dim == IPSET_DIM_TWO)
+			info->flags |= IPSET_DIM_IFACE_INOUT;
+		else if (strncmp(ptr, "src", 3) == 0)
 			info->flags |= (1 << info->dim);
 		else if (strncmp(ptr, "dst", 3) != 0)
 			xtables_error(PARAMETER_PROBLEM,
-				"You must spefify (the comma separated list of) 'src' or 'dst'.");
+				"You must specify (comma separated list of) 'src' or 'dst' with the addition of 'in' or 'out' for the interface part of hash:net,iface set, if used.");
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
index 79cb077..901ec2f 100644
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
@@ -194,6 +198,7 @@ enum ip_set_kopt {
 	IPSET_DIM_ONE_SRC = (1 << IPSET_DIM_ONE),
 	IPSET_DIM_TWO_SRC = (1 << IPSET_DIM_TWO),
 	IPSET_DIM_THREE_SRC = (1 << IPSET_DIM_THREE),
+	IPSET_DIM_IFACE_INOUT = (1 << IPSET_DIM_IFACE),
 };
 
 
-- 
1.7.10.4

