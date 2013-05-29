From: Dash Four <mr.dash.four@googlemail.com>
Subject: [PATCH 4/4] iptables (userspace): add set match "inner" flag support
Date: Wed, 29 May 2013 01:13:53 +0100
Message-ID: <51A54841.9010000@googlemail.com>
References: <51A54267.8050402-git-send-email-mr.dash.four@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Core Team <netfilter-devel@vger.kernel.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f181.google.com ([74.125.82.181]:38212 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932409Ab3E2AN7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 28 May 2013 20:13:59 -0400
Received: by mail-we0-f181.google.com with SMTP id u57so5899128wes.12
        for <netfilter-devel@vger.kernel.org>; Tue, 28 May 2013 17:13:58 -0700 (PDT)
In-Reply-To: <51A54267.8050402-git-send-email-mr.dash.four@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds "inner" flag support for the set match in iptables.

Signed-off-by: Dash Four <mr.dash.four@googlemail.com>
---
  extensions/libxt_set.c                 |  199 ++++++++++++++++++++++++++++++++
  extensions/libxt_set.man               |   10 ++
  include/linux/netfilter/ipset/ip_set.h |    2 +
  3 files changed, 211 insertions(+)

diff --git a/extensions/libxt_set.c b/extensions/libxt_set.c
index 2cb9e78..3b20c94 100644
--- a/extensions/libxt_set.c
+++ b/extensions/libxt_set.c
@@ -497,6 +497,191 @@ set_save_v3(const void *ip, const struct xt_entry_match *match)
  	set_print_v3_matchinfo(info, "--match-set", "--");
  }

+/* Revision 4 - add --inner flag */
+static void
+set_help_v4(void)
+{
+	printf("set match options:\n"
+	       " [!] --match-set name flags [--return-nomatch] [--inner]\n"
+	       "   [! --update-counters] [! --update-subcounters]\n"
+	       "   [[!] --packets-eq value | --packets-lt value | --packets-gt value\n"
+	       "   [[!] --bytes-eq value | --bytes-lt value | --bytes-gt value\n"
+	       "		 'name' is the set name from to match,\n"
+	       "		 'flags' are the comma separated list of\n"
+	       "		 'src' and 'dst' specifications.\n");
+}
+
+static const struct option set_opts_v4[] = {
+	{.name = "match-set",		.has_arg = true,	.val = '1'},
+	{.name = "set",			.has_arg = true,	.val = '2'},
+	{.name = "return-nomatch",	.has_arg = false,	.val = '3'},
+	{.name = "update-counters",	.has_arg = false,	.val = '4'},
+	{.name = "packets-eq",		.has_arg = true,	.val = '5'},
+	{.name = "packets-lt",		.has_arg = true,	.val = '6'},
+	{.name = "packets-gt",		.has_arg = true,	.val = '7'},
+	{.name = "bytes-eq",		.has_arg = true,	.val = '8'},
+	{.name = "bytes-lt",		.has_arg = true,	.val = '9'},
+	{.name = "bytes-gt",		.has_arg = true,	.val = '0'},
+	{.name = "update-subcounters",	.has_arg = false,	.val = 'a'},
+	{.name = "inner",		.has_arg = false,	.val = 'b'},
+	XT_GETOPT_TABLEEND,
+};
+
+static int
+set_parse_v4(int c, char **argv, int invert, unsigned int *flags,
+	     const void *entry, struct xt_entry_match **match)
+{
+	struct xt_set_info_match_v3 *info =
+		(struct xt_set_info_match_v3 *) (*match)->data;
+
+	switch (c) {
+	case 'b':
+		if (invert)
+			xtables_error(PARAMETER_PROBLEM,
+				      "--inner flag cannot be inverted\n");
+		info->flags |= IPSET_FLAG_INNER;
+		break;
+	case 'a':
+		if (invert)
+			info->flags |= IPSET_FLAG_SKIP_SUBCOUNTER_UPDATE;
+		break;
+	case '0':
+		if (info->bytes.op != IPSET_COUNTER_NONE)
+			xtables_error(PARAMETER_PROBLEM,
+				      "only one of the --bytes-[eq|lt|gt]"
+				      " is allowed\n");
+		if (invert)
+			xtables_error(PARAMETER_PROBLEM,
+				      "--bytes-gt option cannot be inverted\n");
+		info->bytes.op = IPSET_COUNTER_GT;
+		info->bytes.value = parse_counter(optarg);
+		break;
+	case '9':
+		if (info->bytes.op != IPSET_COUNTER_NONE)
+			xtables_error(PARAMETER_PROBLEM,
+				      "only one of the --bytes-[eq|lt|gt]"
+				      " is allowed\n");
+		if (invert)
+			xtables_error(PARAMETER_PROBLEM,
+				      "--bytes-lt option cannot be inverted\n");
+		info->bytes.op = IPSET_COUNTER_LT;
+		info->bytes.value = parse_counter(optarg);
+		break;
+	case '8':
+		if (info->bytes.op != IPSET_COUNTER_NONE)
+			xtables_error(PARAMETER_PROBLEM,
+				      "only one of the --bytes-[eq|lt|gt]"
+				      " is allowed\n");
+		info->bytes.op = invert ? IPSET_COUNTER_NE : IPSET_COUNTER_EQ;
+		info->bytes.value = parse_counter(optarg);
+		break;
+	case '7':
+		if (info->packets.op != IPSET_COUNTER_NONE)
+			xtables_error(PARAMETER_PROBLEM,
+				      "only one of the --packets-[eq|lt|gt]"
+				      " is allowed\n");
+		if (invert)
+			xtables_error(PARAMETER_PROBLEM,
+				      "--packets-gt option cannot be inverted\n");
+		info->packets.op = IPSET_COUNTER_GT;
+		info->packets.value = parse_counter(optarg);
+		break;
+	case '6':
+		if (info->packets.op != IPSET_COUNTER_NONE)
+			xtables_error(PARAMETER_PROBLEM,
+				      "only one of the --packets-[eq|lt|gt]"
+				      " is allowed\n");
+		if (invert)
+			xtables_error(PARAMETER_PROBLEM,
+				      "--packets-lt option cannot be inverted\n");
+		info->packets.op = IPSET_COUNTER_LT;
+		info->packets.value = parse_counter(optarg);
+		break;
+	case '5':
+		if (info->packets.op != IPSET_COUNTER_NONE)
+			xtables_error(PARAMETER_PROBLEM,
+				      "only one of the --packets-[eq|lt|gt]"
+				      " is allowed\n");
+		info->packets.op = invert ? IPSET_COUNTER_NE : IPSET_COUNTER_EQ;
+		info->packets.value = parse_counter(optarg);
+		break;
+	case '4':
+		if (invert)
+			info->flags |= IPSET_FLAG_SKIP_COUNTER_UPDATE;
+		break;
+	case '3':
+		if (invert)
+			xtables_error(PARAMETER_PROBLEM,
+				      "--return-nomatch flag cannot be inverted\n");
+		info->flags |= IPSET_FLAG_RETURN_NOMATCH;
+		break;
+	case '2':
+		fprintf(stderr,
+			"--set option deprecated, please use --match-set\n");
+	case '1':		/* --match-set <set> <flag>[,<flag> */
+		if (info->match_set.dim)
+			xtables_error(PARAMETER_PROBLEM,
+				      "--match-set can be specified only once");
+		if (invert)
+			info->match_set.flags |= IPSET_INV_MATCH;
+
+		if (!argv[optind]
+		    || argv[optind][0] == '-'
+		    || argv[optind][0] == '!')
+			xtables_error(PARAMETER_PROBLEM,
+				      "--match-set requires two args.");
+
+		if (strlen(optarg) > IPSET_MAXNAMELEN - 1)
+			xtables_error(PARAMETER_PROBLEM,
+				      "setname `%s' too long, max %d characters.",
+				      optarg, IPSET_MAXNAMELEN - 1);
+
+		get_set_byname(optarg, &info->match_set);
+		parse_dirs(argv[optind], &info->match_set);
+		DEBUGP("parse: set index %u\n", info->match_set.index);
+		optind++;
+		
+		*flags = 1;
+		break;
+	}
+
+	return 1;
+}
+
+static void
+set_print_v4_matchinfo(const struct xt_set_info_match_v3 *info,
+		       const char *opt, const char *sep)
+{
+	print_match(opt, &info->match_set);
+	if (info->flags & IPSET_FLAG_RETURN_NOMATCH)
+		printf(" %sreturn-nomatch", sep);
+	if (info->flags & IPSET_FLAG_INNER)
+		printf(" %sinner", sep);
+	if ((info->flags & IPSET_FLAG_SKIP_COUNTER_UPDATE))
+		printf(" ! %supdate-counters", sep);
+	if ((info->flags & IPSET_FLAG_SKIP_SUBCOUNTER_UPDATE))
+		printf(" ! %supdate-subcounters", sep);
+	set_printv3_counter(&info->packets, "packets", sep);
+	set_printv3_counter(&info->bytes, "bytes", sep);
+}
+
+/* Prints out the matchinfo. */
+static void
+set_print_v4(const void *ip, const struct xt_entry_match *match, int numeric)
+{
+	const struct xt_set_info_match_v3 *info = (const void *)match->data;
+
+	set_print_v4_matchinfo(info, "match-set", "");
+}
+
+static void
+set_save_v4(const void *ip, const struct xt_entry_match *match)
+{
+	const struct xt_set_info_match_v3 *info = (const void *)match->data;
+
+	set_print_v4_matchinfo(info, "--match-set", "--");
+}
+
  static struct xtables_match set_mt_reg[] = {
  	{
  		.name		= "set",
@@ -554,6 +739,20 @@ static struct xtables_match set_mt_reg[] = {
  		.save		= set_save_v3,
  		.extra_opts	= set_opts_v3,
  	},
+	{
+		.name		= "set",
+		.revision	= 4,
+		.version	= XTABLES_VERSION,
+		.family		= NFPROTO_UNSPEC,
+		.size		= XT_ALIGN(sizeof(struct xt_set_info_match_v3)),
+		.userspacesize	= XT_ALIGN(sizeof(struct xt_set_info_match_v3)),
+		.help		= set_help_v4,
+		.parse		= set_parse_v4,
+		.final_check	= set_check_v0,
+		.print		= set_print_v4,
+		.save		= set_save_v4,
+		.extra_opts	= set_opts_v4,
+	},
  };

  void _init(void)
diff --git a/extensions/libxt_set.man b/extensions/libxt_set.man
index 7012ef2..21e443c 100644
--- a/extensions/libxt_set.man
+++ b/extensions/libxt_set.man
@@ -21,6 +21,16 @@ supports the \fBnomatch\fP flag, then the matching is reversed: a match
  with an element flagged with \fBnomatch\fP returns \fBtrue\fP, while a
  match with a plain element returns \fBfalse\fP.
  .TP
+\fB\-\-inner\fP
+Please note that this option will only produce matches in the event of
+the following ICMPv4 and ICMPv6 messages: \fBdestination-unreachable\fP
+(ICMPv4 code 3 and ICMPv6 code 1), \fBsource-quench\fP (ICMPv4 code 4),
+\fBtime-exceeded\fP (ICMPv4 code 11 and ICMPv6 code 3) and
+\fBpacket-too-big\fP (ICMPv6 code 2). If the \fB\-\-inner\fP option is
+specified, then element matching is based on the properties
+(source/destination IP address, protocol, port and so on) of the original
+(inner) connection, which produced the above ICMP[v6] type messages.
+.TP
  \fB!\fP \fB\-\-update\-counters\fP
  If the \fB\-\-update\-counters\fP flag is negated, then the packet and
  byte counters of the matching element in the set won't be updated. Default
diff --git a/include/linux/netfilter/ipset/ip_set.h b/include/linux/netfilter/ipset/ip_set.h
index eb9123e..1b3d9cb 100644
--- a/include/linux/netfilter/ipset/ip_set.h
+++ b/include/linux/netfilter/ipset/ip_set.h
@@ -161,6 +161,8 @@ enum ipset_cmd_flags {
  		(1 << IPSET_FLAG_BIT_SKIP_SUBCOUNTER_UPDATE),
  	IPSET_FLAG_BIT_MATCH_COUNTERS = 5,
  	IPSET_FLAG_MATCH_COUNTERS = (1 << IPSET_FLAG_BIT_MATCH_COUNTERS),
+	IPSET_FLAG_BIT_INNER = 6,
+	IPSET_FLAG_INNER = (1 << IPSET_FLAG_BIT_INNER),
  	IPSET_FLAG_BIT_RETURN_NOMATCH = 7,
  	IPSET_FLAG_RETURN_NOMATCH = (1 << IPSET_FLAG_BIT_RETURN_NOMATCH),
  	IPSET_FLAG_CMD_MAX = 15,



