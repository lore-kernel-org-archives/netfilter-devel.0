Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="MqZBDt0I"
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68F0B19A
	for <netfilter-devel@vger.kernel.org>; Wed, 29 Nov 2023 05:15:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=JZqsfWOknLtp2WpFwIXCIyCIxeQ8nhpHi4Q48weCE44=; b=MqZBDt0IfdhpZVsZZMIlCwpkIQ
	9yZIgEOmcbh02guwEbXCLb//7kTeNix2CCqArHOAd43wCnfMCDG965a5yCuxvW4s+hDY4hqbnhPdm
	57uh/tJrE6rzIhCnqtQt5MlDjELg2Er0KAB+c36rGHhnvIlBxy5wlRdo9/RMp+4KSJeQnzjLZDbbV
	Q2qZSdanMTV++jcoX9ci25dvI4P9RSQicMuBR3qqqoeieO5C2lqtRzSfHmjD3z9N7VzpTsHVdomxs
	jIcYpOHZM30+yw0mvmclF73nKTxK1EZU/GJ4hGSHd1MtAobM+c//OcUpP2ZeNqHjsrzNDlEvhRmX1
	1/N0qugQ==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.94.2)
	(envelope-from <phil@nwl.cc>)
	id 1r8KPi-0001j7-Qo
	for netfilter-devel@vger.kernel.org; Wed, 29 Nov 2023 14:15:38 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 06/13] xshared: Support for ebtables' --change-counters command
Date: Wed, 29 Nov 2023 14:28:20 +0100
Message-ID: <20231129132827.18166-7-phil@nwl.cc>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231129132827.18166-1-phil@nwl.cc>
References: <20231129132827.18166-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is tricky because the short-option clashes with the --check
command. OTOH, ebtables supports --check as well (though without
short-option), so making do_parse() detect ebtables based on struct
xtables_args::family is probably still the least messy option.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-cmd.h |  7 ------
 iptables/xshared.c | 57 +++++++++++++++++++++++++++++++++++++++++++++-
 iptables/xshared.h | 11 ++++++++-
 3 files changed, 66 insertions(+), 9 deletions(-)

diff --git a/iptables/nft-cmd.h b/iptables/nft-cmd.h
index 8163b82c3511f..00ecc80249f0d 100644
--- a/iptables/nft-cmd.h
+++ b/iptables/nft-cmd.h
@@ -7,13 +7,6 @@
 
 struct nftnl_rule;
 
-enum {
-	CTR_OP_INC_PKTS = 1 << 0,
-	CTR_OP_DEC_PKTS = 1 << 1,
-	CTR_OP_INC_BYTES = 1 << 2,
-	CTR_OP_DEC_BYTES = 1 << 3,
-};
-
 struct nft_cmd {
 	struct list_head		head;
 	int				command;
diff --git a/iptables/xshared.c b/iptables/xshared.c
index 62ae4141325ed..50f23757d4aff 100644
--- a/iptables/xshared.c
+++ b/iptables/xshared.c
@@ -937,7 +937,7 @@ static void parse_rule_range(struct xt_cmd_parse *p, const char *argv)
 
 /* list the commands an option is allowed with */
 #define CMD_IDRAC	CMD_INSERT | CMD_DELETE | CMD_REPLACE | \
-			CMD_APPEND | CMD_CHECK
+			CMD_APPEND | CMD_CHECK | CMD_CHANGE_COUNTERS
 static const unsigned int options_v_commands[NUMBER_OF_OPT] = {
 /*OPT_NUMERIC*/		CMD_LIST,
 /*OPT_SOURCE*/		CMD_IDRAC,
@@ -1392,10 +1392,58 @@ static void parse_interface(const char *arg, char *iface)
 	strcpy(iface, arg);
 }
 
+static bool
+parse_signed_counter(char *argv, unsigned long long *val, uint8_t *ctr_op,
+		     uint8_t flag_inc, uint8_t flag_dec)
+{
+	char *endptr, *p = argv;
+
+	switch (*p) {
+	case '+':
+		*ctr_op |= flag_inc;
+		p++;
+		break;
+	case '-':
+		*ctr_op |= flag_dec;
+		p++;
+		break;
+	}
+	*val = strtoull(p, &endptr, 10);
+	return *endptr == '\0';
+}
+
+static void parse_change_counters_rule(int argc, char **argv,
+				       struct xt_cmd_parse *p,
+				       struct xtables_args *args)
+{
+	if (optind + 1 >= argc ||
+	    (argv[optind][0] == '-' && !isdigit(argv[optind][1])) ||
+	    (argv[optind + 1][0] == '-' && !isdigit(argv[optind + 1][1])))
+		xtables_error(PARAMETER_PROBLEM,
+			      "The command -C needs at least 2 arguments");
+	if (optind + 2 < argc &&
+	    (argv[optind + 2][0] != '-' || isdigit(argv[optind + 2][1]))) {
+		if (optind + 3 != argc)
+			xtables_error(PARAMETER_PROBLEM,
+				      "No extra options allowed with -C start_nr[:end_nr] pcnt bcnt");
+		parse_rule_range(p, argv[optind++]);
+	}
+
+	if (!parse_signed_counter(argv[optind++], &args->pcnt_cnt,
+				  &args->counter_op,
+				  CTR_OP_INC_PKTS, CTR_OP_DEC_PKTS) ||
+	    !parse_signed_counter(argv[optind++], &args->bcnt_cnt,
+				  &args->counter_op,
+				  CTR_OP_INC_BYTES, CTR_OP_DEC_BYTES))
+		xtables_error(PARAMETER_PROBLEM,
+			      "Packet counter '%s' invalid", argv[optind - 1]);
+}
+
 void do_parse(int argc, char *argv[],
 	      struct xt_cmd_parse *p, struct iptables_command_state *cs,
 	      struct xtables_args *args)
 {
+	bool family_is_bridge = args->family == NFPROTO_BRIDGE;
 	struct xtables_match *m;
 	struct xtables_rule_match *matchp;
 	bool wait_interval_set = false;
@@ -1435,6 +1483,13 @@ void do_parse(int argc, char *argv[],
 			break;
 
 		case 'C':
+			if (family_is_bridge) {
+				add_command(&p->command, CMD_CHANGE_COUNTERS,
+					    CMD_NONE, invert);
+				p->chain = optarg;
+				parse_change_counters_rule(argc, argv, p, args);
+				break;
+			}
 			add_command(&p->command, CMD_CHECK, CMD_NONE, invert);
 			p->chain = optarg;
 			break;
diff --git a/iptables/xshared.h b/iptables/xshared.h
index 2fd15c725faaf..68acfb4b406fb 100644
--- a/iptables/xshared.h
+++ b/iptables/xshared.h
@@ -69,8 +69,9 @@ enum {
 	CMD_LIST_RULES		= 1 << 12,
 	CMD_ZERO_NUM		= 1 << 13,
 	CMD_CHECK		= 1 << 14,
+	CMD_CHANGE_COUNTERS	= 1 << 15, /* ebtables only */
 };
-#define NUMBER_OF_CMD		16
+#define NUMBER_OF_CMD		17
 
 struct xtables_globals;
 struct xtables_rule_match;
@@ -247,6 +248,13 @@ struct addr_mask {
 	} mask;
 };
 
+enum {
+	CTR_OP_INC_PKTS = 1 << 0,
+	CTR_OP_DEC_PKTS = 1 << 1,
+	CTR_OP_INC_BYTES = 1 << 2,
+	CTR_OP_DEC_BYTES = 1 << 3,
+};
+
 struct xtables_args {
 	int		family;
 	uint8_t		flags;
@@ -261,6 +269,7 @@ struct xtables_args {
 	const char	*arp_hlen, *arp_opcode;
 	const char	*arp_htype, *arp_ptype;
 	unsigned long long pcnt_cnt, bcnt_cnt;
+	uint8_t		counter_op;
 	int		wait;
 };
 
-- 
2.41.0

