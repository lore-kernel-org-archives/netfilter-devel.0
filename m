From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [IPTABLES] the same options for different kinds of matches don't
 work
Date: Sat, 16 Aug 2008 20:21:58 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0808161947450.20963@blackhole.kfki.hu>
References: <412e6f7f0808150951u2f2d58afn8340c64fed9de2a2@mail.gmail.com>
 <48A5CEFE.5090407@netfilter.org>  <alpine.LNX.1.10.0808151633500.10478@fbirervta.pbzchgretzou.qr>
  <Pine.LNX.4.64.0808152243280.20098@blackhole.kfki.hu>
 <alpine.LNX.1.10.0808151743310.10478@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0808160037390.20328@blackhole.kfki.hu>
 <412e6f7f0808151738k3b03cafax900b01f45726051e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Jan Engelhardt <jengelh@medozas.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Changli Gao <xiaosuo@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:46554 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752105AbYHPSWB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 16 Aug 2008 14:22:01 -0400
In-Reply-To: <412e6f7f0808151738k3b03cafax900b01f45726051e@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, 16 Aug 2008, Changli Gao wrote:

> > But as the ECN options has not been documented so far, I think it'd be
> > better to rename them at the same time to something like
> >
> > --ecn-tcp-cwr-remove
> > --ecn-tcp-ece-remove
> > --ecn-ip-ect-set
> >
> > and clashing with the ecn options were resolved.
> 
> It sounds a good idae. But in order to avoid clashing, we'd better
> change all the options for all matches in this way:
> 
> match: foo
> match-options: --foo-bar

I think changing the existing clashing option names (with keeping the old 
ones for backward compatibility) is just enough - we can use the "rule" 
above for future new matches.

The patch below implements what I suggest:

---
 extensions/libipt_ECN.c       |   24 ++++++++++++------------
 extensions/libipt_realm.c     |    2 +-
 extensions/libipt_set.c       |   19 +++++++++++--------
 extensions/libipt_set.man     |    3 ++-
 extensions/libxt_connmark.c   |   27 ++++++++++++++++-----------
 extensions/libxt_connmark.man |    3 ++-
 6 files changed, 44 insertions(+), 34 deletions(-)

diff --git a/extensions/libipt_ECN.c b/extensions/libipt_ECN.c
index 9526c37..b455b1d 100644
--- a/extensions/libipt_ECN.c
+++ b/extensions/libipt_ECN.c
@@ -26,17 +26,17 @@ static void ECN_help(void)
 
 #if 0
 "ECN target v%s EXPERIMENTAL options (use with extreme care!)\n"
-"  --ecn-ip-ect			Set the IPv4 ECT codepoint (0 to 3)\n"
-"  --ecn-tcp-cwr		Set the IPv4 CWR bit (0 or 1)\n"
-"  --ecn-tcp-ece		Set the IPv4 ECE bit (0 or 1)\n",
+"  --ecn-ip-ect-set		Set the IPv4 ECT codepoint (0 to 3)\n"
+"  --ecn-tcp-cwr-set		Set the IPv4 CWR bit (0 or 1)\n"
+"  --ecn-tcp-ece-set		Set the IPv4 ECE bit (0 or 1)\n",
 #endif
 
 
 static const struct option ECN_opts[] = {
 	{ "ecn-tcp-remove", 0, NULL, 'F' },
-	{ "ecn-tcp-cwr", 1, NULL, 'G' },
-	{ "ecn-tcp-ece", 1, NULL, 'H' },
-	{ "ecn-ip-ect", 1, NULL, '9' },
+	{ "ecn-tcp-cwr-set", 1, NULL, 'G' },
+	{ "ecn-tcp-ece-set", 1, NULL, 'H' },
+	{ "ecn-ip-ect-set", 1, NULL, '9' },
 	{ .name = NULL }
 };
 
@@ -60,7 +60,7 @@ static int ECN_parse(int c, char **argv, int invert, unsigned int *flags,
 	case 'G':
 		if (*flags & IPT_ECN_OP_SET_CWR)
 			exit_error(PARAMETER_PROBLEM,
-				"ECN target: Only use --ecn-tcp-cwr ONCE!");
+				"ECN target: Only use --ecn-tcp-cwr-set ONCE!");
 		if (string_to_number(optarg, 0, 1, &result))
 			exit_error(PARAMETER_PROBLEM,
 				   "ECN target: Value out of range");
@@ -71,7 +71,7 @@ static int ECN_parse(int c, char **argv, int invert, unsigned int *flags,
 	case 'H':
 		if (*flags & IPT_ECN_OP_SET_ECE)
 			exit_error(PARAMETER_PROBLEM,
-				"ECN target: Only use --ecn-tcp-ece ONCE!");
+				"ECN target: Only use --ecn-tcp-ece-set ONCE!");
 		if (string_to_number(optarg, 0, 1, &result))
 			exit_error(PARAMETER_PROBLEM,
 				   "ECN target: Value out of range");
@@ -82,7 +82,7 @@ static int ECN_parse(int c, char **argv, int invert, unsigned int *flags,
 	case '9':
 		if (*flags & IPT_ECN_OP_SET_IP)
 			exit_error(PARAMETER_PROBLEM,
-				"ECN target: Only use --ecn-ip-ect ONCE!");
+				"ECN target: Only use --ecn-ip-ect-set ONCE!");
 		if (string_to_number(optarg, 0, 3, &result))
 			exit_error(PARAMETER_PROBLEM,
 				   "ECN target: Value out of range");
@@ -142,13 +142,13 @@ static void ECN_save(const void *ip, const struct xt_entry_target *target)
 	else {
 
 		if (einfo->operation & IPT_ECN_OP_SET_ECE)
-			printf("--ecn-tcp-ece %d ", einfo->proto.tcp.ece);
+			printf("--ecn-tcp-ece-set %d ", einfo->proto.tcp.ece);
 
 		if (einfo->operation & IPT_ECN_OP_SET_CWR)
-			printf("--ecn-tcp-cwr %d ", einfo->proto.tcp.cwr);
+			printf("--ecn-tcp-cwr-set %d ", einfo->proto.tcp.cwr);
 
 		if (einfo->operation & IPT_ECN_OP_SET_IP)
-			printf("--ecn-ip-ect %d ", einfo->ip_ect);
+			printf("--ecn-ip-ect-set %d ", einfo->ip_ect);
 	}
 }
 
diff --git a/extensions/libipt_realm.c b/extensions/libipt_realm.c
index 1e7f690..e7ce065 100644
--- a/extensions/libipt_realm.c
+++ b/extensions/libipt_realm.c
@@ -234,7 +234,7 @@ static void realm_save(const void *ip, const struct xt_entry_match *match)
 	print_realm(ri->id, ri->mask, 0);
 }
 
-/* Final check; must have specified --mark. */
+/* Final check; must have specified --realm. */
 static void realm_check(unsigned int flags)
 {
 	if (!flags)
diff --git a/extensions/libipt_set.c b/extensions/libipt_set.c
index 759bca3..d90b3a7 100644
--- a/extensions/libipt_set.c
+++ b/extensions/libipt_set.c
@@ -25,14 +25,15 @@
 static void set_help(void)
 {
 	printf("set match options:\n"
-	       " [!] --set     name flags\n"
+	       " [!] --match-set name flags\n"
 	       "		'name' is the set name from to match,\n" 
 	       "		'flags' are the comma separated list of\n"
 	       "		'src' and 'dst'.\n");
 }
 
 static const struct option set_opts[] = {
-	{"set", 1, NULL, '1'},
+	{"match-set", 1, NULL, '1'},
+	{"set", 1, NULL, '2'}, /* Backward compatibility */
 	{ }
 };
 
@@ -56,10 +57,12 @@ static int set_parse(int c, char **argv, int invert, unsigned int *flags,
 	struct ipt_set_info *info = &myinfo->match_set;
 
 	switch (c) {
-	case '1':		/* --set <set> <flag>[,<flag> */
+	case '2': /* --set <set> <flag>[,<flag> */
+		fprintf(stderr, "Option name changed from --set to --match-set. Update your command to suppress this warning!\n");
+	case '1':		/* --match-set <set> <flag>[,<flag> */
 		if (info->flags[0])
 			exit_error(PARAMETER_PROBLEM,
-				   "--set can be specified only once");
+				   "--match-set can be specified only once");
 
 		check_inverse(optarg, &invert, &optind, 0);
 		if (invert)
@@ -69,7 +72,7 @@ static int set_parse(int c, char **argv, int invert, unsigned int *flags,
 		    || argv[optind][0] == '-'
 		    || argv[optind][0] == '!')
 			exit_error(PARAMETER_PROBLEM,
-				   "--set requires two args.");
+				   "--match-set requires two args.");
 
 		if (strlen(argv[optind-1]) > IP_SET_MAXNAMELEN - 1)
 			exit_error(PARAMETER_PROBLEM,
@@ -91,12 +94,12 @@ static int set_parse(int c, char **argv, int invert, unsigned int *flags,
 	return 1;
 }
 
-/* Final check; must have specified --set. */
+/* Final check; must have specified --match-set. */
 static void set_check(unsigned int flags)
 {
 	if (!flags)
 		exit_error(PARAMETER_PROBLEM,
-			   "You must specify `--set' with proper arguments");
+			   "You must specify `--match-set' with proper arguments");
 	DEBUGP("final check OK\n");
 }
 
@@ -137,7 +140,7 @@ static void set_save(const void *ip, const struct xt_entry_match *match)
 	struct ipt_set_info_match *info = 
 		(struct ipt_set_info_match *) match->data;
 
-	print_match("--set", &info->match_set);
+	print_match("--match-set", &info->match_set);
 }
 
 static struct xtables_match set_mt_reg = {
diff --git a/extensions/libipt_set.man b/extensions/libipt_set.man
index c8ff601..7833930 100644
--- a/extensions/libipt_set.man
+++ b/extensions/libipt_set.man
@@ -1,6 +1,6 @@
 This modules macthes IP sets which can be defined by ipset(8).
 .TP
-[\fB!\fP] \fB--set\fP \fIsetname\fP \fIflag\fP[\fB,\fP\fIflag\fP]...
+[\fB!\fP] \fB--match-set\fP \fIsetname\fP \fIflag\fP[\fB,\fP\fIflag\fP]...
 where flags are
 .BR "src"
 and/or
@@ -15,3 +15,4 @@ there is a binding belonging to the mached set element or there is a default
 binding for the given set, then the rule will match the packet only if 
 additionally (depending on the type of the set) the destination address or 
 port number of the packet can be found in the set according to the binding.
+(Old option name \fB--set\fR is still supported.)
diff --git a/extensions/libxt_connmark.c b/extensions/libxt_connmark.c
index eb4060e..2bbc3ef 100644
--- a/extensions/libxt_connmark.c
+++ b/extensions/libxt_connmark.c
@@ -36,11 +36,12 @@ static void connmark_mt_help(void)
 {
 	printf(
 "connmark match options:\n"
-"[!] --mark value[/mask]    Match ctmark value with optional mask\n");
+"[!] --connmark value[/mask]    Match ctmark value with optional mask\n");
 }
 
 static const struct option connmark_mt_opts[] = {
-	{.name = "mark", .has_arg = true, .val = '1'},
+	{.name = "connmark", .has_arg = true, .val = '1'},
+	{.name = "mark", .has_arg = true, .val = '2'}, /* Backward compatibility */
 	{ .name = NULL }
 };
 
@@ -53,15 +54,17 @@ connmark_mt_parse(int c, char **argv, int invert, unsigned int *flags,
 	char *end;
 
 	switch (c) {
-	case '1': /* --mark */
-		param_act(P_ONLY_ONCE, "connmark", "--mark", *flags & F_MARK);
+	case '2': /* --mark */
+		fprintf(stderr, "Option name changed from --mark to --connmark. Update your command to suppress this warning!\n");
+	case '1': /* --connmark */
+		param_act(P_ONLY_ONCE, "connmark", "--connmark", *flags & F_MARK);
 		if (!strtonum(optarg, &end, &mark, 0, ~0U))
-			param_act(P_BAD_VALUE, "connmark", "--mark", optarg);
+			param_act(P_BAD_VALUE, "connmark", "--connmark", optarg);
 		if (*end == '/')
 			if (!strtonum(end + 1, &end, &mask, 0, ~0U))
-				param_act(P_BAD_VALUE, "connmark", "--mark", optarg);
+				param_act(P_BAD_VALUE, "connmark", "--connmark", optarg);
 		if (*end != '\0')
-			param_act(P_BAD_VALUE, "connmark", "--mark", optarg);
+			param_act(P_BAD_VALUE, "connmark", "--connmark", optarg);
 
 		if (invert)
 			info->invert = true;
@@ -83,6 +86,8 @@ connmark_parse(int c, char **argv, int invert, unsigned int *flags,
 
 	switch (c) {
 		char *end;
+	case '2':
+		fprintf(stderr, "Option name changed from --mark to --connmark. Update your command to suppress this warning!\n");
 	case '1':
 		check_inverse(optarg, &invert, &optind, 0);
 
@@ -93,7 +98,7 @@ connmark_parse(int c, char **argv, int invert, unsigned int *flags,
 			markinfo->mask = strtoul(end+1, &end, 0);
 
 		if (*end != '\0' || end == optarg)
-			exit_error(PARAMETER_PROBLEM, "Bad MARK value `%s'", optarg);
+			exit_error(PARAMETER_PROBLEM, "Bad CONNMARK value `%s'", optarg);
 		if (invert)
 			markinfo->invert = 1;
 		*flags = 1;
@@ -117,7 +122,7 @@ static void connmark_mt_check(unsigned int flags)
 {
 	if (flags == 0)
 		exit_error(PARAMETER_PROBLEM,
-		           "connmark: The --mark option is required");
+		           "connmark: The --connmark option is required");
 }
 
 /* Prints out the matchinfo. */
@@ -151,7 +156,7 @@ static void connmark_save(const void *ip, const struct xt_entry_match *match)
 	if (info->invert)
 		printf("! ");
 
-	printf("--mark ");
+	printf("--connmark ");
 	print_mark(info->mark, info->mask);
 }
 
@@ -163,7 +168,7 @@ connmark_mt_save(const void *ip, const struct xt_entry_match *match)
 	if (info->invert)
 		printf("! ");
 
-	printf("--mark ");
+	printf("--connmark ");
 	print_mark(info->mark, info->mask);
 }
 
diff --git a/extensions/libxt_connmark.man b/extensions/libxt_connmark.man
index a50c537..9e10e97 100644
--- a/extensions/libxt_connmark.man
+++ b/extensions/libxt_connmark.man
@@ -1,6 +1,7 @@
 This module matches the netfilter mark field associated with a connection
 (which can be set using the \fBCONNMARK\fR target below).
 .TP
-[\fB!\fP] \fB--mark\fR \fIvalue\fR[\fB/\fR\fImask\fR]
+[\fB!\fP] \fB--connmark\fR \fIvalue\fR[\fB/\fR\fImask\fR]
 Matches packets in connections with the given mark value (if a mask is
 specified, this is logically ANDed with the mark before the comparison).
+(Old option name \fB--mark\fR is still supported.)
-- 
1.5.3.4

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
