From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [iptables-nftables RFC PATCH - v2 - 2/6] xtables: Combine IPv6 support with IPv4 support
Date: Fri, 11 Jan 2013 11:10:21 +0200
Message-ID: <1357895421-4765-1-git-send-email-tomasz.bursztyka@linux.intel.com>
References: <1357828179-18664-3-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:33911 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754449Ab3AKJK0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 11 Jan 2013 04:10:26 -0500
In-Reply-To: <1357828179-18664-3-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Instead of having separate binaries for IPv4 and IPv6, it combines
both supports together in the same place and let the nft handle
knows about which family is in use.

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 iptables/xtables.c | 389 +++++++++++++++++++++++++++++++++++++----------------
 1 file changed, 272 insertions(+), 117 deletions(-)

diff --git a/iptables/xtables.c b/iptables/xtables.c
index 89ccd7f..821c93b 100644
--- a/iptables/xtables.c
+++ b/iptables/xtables.c
@@ -204,6 +204,20 @@ enum {
 	IPT_DOTTED_MASK
 };
 
+struct addr_mask {
+	union {
+		struct in_addr	*v4;
+		struct in6_addr *v6;
+	} addr;
+
+	unsigned int naddrs;
+
+	union {
+		struct in_addr	*v4;
+		struct in6_addr *v6;
+	} mask;
+};
+
 static void __attribute__((noreturn))
 exit_tryhelp(int status)
 {
@@ -370,6 +384,15 @@ add_command(unsigned int *cmd, const int newcmd, const int othercmds,
  *	return global static data.
 */
 
+/* These are invalid numbers as upper layer protocol */
+static int is_exthdr(uint16_t proto)
+{
+	return (proto == IPPROTO_ROUTING ||
+		proto == IPPROTO_FRAGMENT ||
+		proto == IPPROTO_AH ||
+		proto == IPPROTO_DSTOPTS);
+}
+
 /* Christophe Burki wants `-p 6' to imply `-m tcp'.  */
 /* Can't be zero. */
 static int
@@ -430,26 +453,38 @@ static int
 add_entry(const char *chain,
 	  const char *table,
 	  struct iptables_command_state *cs,
-	  unsigned int nsaddrs,
-	  const struct in_addr saddrs[],
-	  const struct in_addr smasks[],
-	  unsigned int ndaddrs,
-	  const struct in_addr daddrs[],
-	  const struct in_addr dmasks[],
+	  int family,
+	  const struct addr_mask s,
+	  const struct addr_mask d,
 	  bool verbose, struct nft_handle *h, bool append)
 {
 	unsigned int i, j;
 	int ret = 1;
 
-	for (i = 0; i < nsaddrs; i++) {
-		cs->fw.ip.src.s_addr = saddrs[i].s_addr;
-		cs->fw.ip.smsk.s_addr = smasks[i].s_addr;
-		for (j = 0; j < ndaddrs; j++) {
-			cs->fw.ip.dst.s_addr = daddrs[j].s_addr;
-			cs->fw.ip.dmsk.s_addr = dmasks[j].s_addr;
+	for (i = 0; i < s.naddrs; i++) {
+		if (family == AF_INET) {
+			cs->fw.ip.src.s_addr = s.addr.v4[i].s_addr;
+			cs->fw.ip.smsk.s_addr = s.mask.v4[i].s_addr;
+			for (j = 0; j < d.naddrs; j++) {
+				cs->fw.ip.dst.s_addr = d.addr.v4[j].s_addr;
+				cs->fw.ip.dmsk.s_addr = d.mask.v4[j].s_addr;
 
-			ret = nft_rule_add(h, chain, table,
-					   cs, append, 0, verbose);
+				ret = nft_rule_add(h, chain, table,
+						   cs, append, 0, verbose);
+			}
+		} else if (family == AF_INET6) {
+			memcpy(&cs->fw6.ipv6.src,
+			       &s.addr.v6[i], sizeof(struct in6_addr));
+			memcpy(&cs->fw6.ipv6.smsk,
+			       &s.mask.v6[i], sizeof(struct in6_addr));
+			for (j = 0; j < d.naddrs; j++) {
+				memcpy(&cs->fw6.ipv6.dst,
+				       &d.addr.v6[j], sizeof(struct in6_addr));
+				memcpy(&cs->fw6.ipv6.dmsk,
+				       &d.mask.v6[j], sizeof(struct in6_addr));
+				ret = nft_rule_add(h, chain, table,
+						   cs, append, 0, verbose);
+			}
 		}
 	}
 
@@ -460,14 +495,23 @@ static int
 replace_entry(const char *chain, const char *table,
 	      struct iptables_command_state *cs,
 	      unsigned int rulenum,
-	      const struct in_addr *saddr, const struct in_addr *smask,
-	      const struct in_addr *daddr, const struct in_addr *dmask,
+	      int family,
+	      const struct addr_mask s,
+	      const struct addr_mask d,
 	      bool verbose, struct nft_handle *h)
 {
-	cs->fw.ip.src.s_addr = saddr->s_addr;
-	cs->fw.ip.dst.s_addr = daddr->s_addr;
-	cs->fw.ip.smsk.s_addr = smask->s_addr;
-	cs->fw.ip.dmsk.s_addr = dmask->s_addr;
+	if (family == AF_INET) {
+		cs->fw.ip.src.s_addr = s.addr.v4->s_addr;
+		cs->fw.ip.dst.s_addr = d.addr.v4->s_addr;
+		cs->fw.ip.smsk.s_addr = s.mask.v4->s_addr;
+		cs->fw.ip.dmsk.s_addr = d.mask.v4->s_addr;
+	} else if (family == AF_INET6) {
+		memcpy(&cs->fw6.ipv6.src, s.addr.v6, sizeof(struct in6_addr));
+		memcpy(&cs->fw6.ipv6.dst, d.addr.v6, sizeof(struct in6_addr));
+		memcpy(&cs->fw6.ipv6.smsk, s.mask.v6, sizeof(struct in6_addr));
+		memcpy(&cs->fw6.ipv6.dmsk, d.mask.v6, sizeof(struct in6_addr));
+	} else
+		return 1;
 
 	return nft_rule_replace(h, chain, table, cs, rulenum, verbose);
 }
@@ -475,25 +519,38 @@ replace_entry(const char *chain, const char *table,
 static int
 delete_entry(const char *chain, const char *table,
 	     struct iptables_command_state *cs,
-	     unsigned int nsaddrs,
-	     const struct in_addr saddrs[],
-	     const struct in_addr smasks[],
-	     unsigned int ndaddrs,
-	     const struct in_addr daddrs[],
-	     const struct in_addr dmasks[],
+	     int family,
+	     const struct addr_mask s,
+	     const struct addr_mask d,
 	     bool verbose,
 	     struct nft_handle *h)
 {
 	unsigned int i, j;
 	int ret = 1;
 
-	for (i = 0; i < nsaddrs; i++) {
-		cs->fw.ip.src.s_addr = saddrs[i].s_addr;
-		cs->fw.ip.smsk.s_addr = smasks[i].s_addr;
-		for (j = 0; j < ndaddrs; j++) {
-			cs->fw.ip.dst.s_addr = daddrs[j].s_addr;
-			cs->fw.ip.dmsk.s_addr = dmasks[j].s_addr;
-			ret = nft_rule_delete(h, chain, table, cs, verbose);
+	for (i = 0; i < s.naddrs; i++) {
+		if (family == AF_INET) {
+			cs->fw.ip.src.s_addr = s.addr.v4[i].s_addr;
+			cs->fw.ip.smsk.s_addr = s.mask.v4[i].s_addr;
+			for (j = 0; j < d.naddrs; j++) {
+				cs->fw.ip.dst.s_addr = d.addr.v4[j].s_addr;
+				cs->fw.ip.dmsk.s_addr = d.mask.v4[j].s_addr;
+				ret = nft_rule_delete(h, chain,
+						      table, cs, verbose);
+			}
+		} else if (family == AF_INET6) {
+			memcpy(&cs->fw6.ipv6.src,
+			       &s.addr.v6[i], sizeof(struct in6_addr));
+			memcpy(&cs->fw6.ipv6.smsk,
+			       &s.mask.v6[i], sizeof(struct in6_addr));
+			for (j = 0; j < d.naddrs; j++) {
+				memcpy(&cs->fw6.ipv6.dst,
+				       &d.addr.v6[j], sizeof(struct in6_addr));
+				memcpy(&cs->fw6.ipv6.dmsk,
+				       &d.mask.v6[j], sizeof(struct in6_addr));
+				ret = nft_rule_delete(h, chain,
+						      table, cs, verbose);
+			}
 		}
 	}
 
@@ -503,21 +560,37 @@ delete_entry(const char *chain, const char *table,
 static int
 check_entry(const char *chain, const char *table,
 	    struct iptables_command_state *cs,
-	    unsigned int nsaddrs, const struct in_addr *saddrs,
-	    const struct in_addr *smasks, unsigned int ndaddrs,
-	    const struct in_addr *daddrs, const struct in_addr *dmasks,
+	    int family,
+	    const struct addr_mask s,
+	    const struct addr_mask d,
 	    bool verbose, struct nft_handle *h)
 {
 	unsigned int i, j;
 	int ret = 1;
 
-	for (i = 0; i < nsaddrs; i++) {
-		cs->fw.ip.src.s_addr = saddrs[i].s_addr;
-		cs->fw.ip.smsk.s_addr = smasks[i].s_addr;
-		for (j = 0; j < ndaddrs; j++) {
-			cs->fw.ip.dst.s_addr = daddrs[j].s_addr;
-			cs->fw.ip.dmsk.s_addr = dmasks[j].s_addr;
-			ret = nft_rule_check(h, chain, table, cs, verbose);
+	for (i = 0; i < s.naddrs; i++) {
+		if (family == AF_INET) {
+			cs->fw.ip.src.s_addr = s.addr.v4[i].s_addr;
+			cs->fw.ip.smsk.s_addr = s.mask.v4[i].s_addr;
+			for (j = 0; j < d.naddrs; j++) {
+				cs->fw.ip.dst.s_addr = d.addr.v4[j].s_addr;
+				cs->fw.ip.dmsk.s_addr = d.mask.v4[j].s_addr;
+				ret = nft_rule_check(h, chain,
+						     table, cs, verbose);
+			}
+		} else if (family == AF_INET6) {
+			memcpy(&cs->fw6.ipv6.src,
+			       &s.addr.v6[i], sizeof(struct in6_addr));
+			memcpy(&cs->fw6.ipv6.smsk,
+			       &s.mask.v6[i], sizeof(struct in6_addr));
+			for (j = 0; j < d.naddrs; j++) {
+				memcpy(&cs->fw6.ipv6.dst,
+				       &d.addr.v6[j], sizeof(struct in6_addr));
+				memcpy(&cs->fw6.ipv6.dmsk,
+				       &d.mask.v6[j], sizeof(struct in6_addr));
+				ret = nft_rule_check(h, chain,
+						     table, cs, verbose);
+			}
 		}
 	}
 
@@ -657,9 +730,8 @@ static void command_match(struct iptables_command_state *cs)
 int do_commandx(struct nft_handle *h, int argc, char *argv[], char **table)
 {
 	struct iptables_command_state cs;
-	unsigned int nsaddrs = 0, ndaddrs = 0;
-	struct in_addr *saddrs = NULL, *smasks = NULL;
-	struct in_addr *daddrs = NULL, *dmasks = NULL;
+	struct addr_mask s;
+	struct addr_mask d;
 
 	int verbose = 0;
 	const char *chain = NULL;
@@ -671,7 +743,16 @@ int do_commandx(struct nft_handle *h, int argc, char *argv[], char **table)
 	struct xtables_match *m;
 	struct xtables_rule_match *matchp;
 	struct xtables_target *t;
-	unsigned long long cnt;
+	unsigned long long pcnt_cnt = 0, bcnt_cnt = 0;
+
+	int family = AF_INET;
+	u_int16_t proto = 0;
+	u_int8_t flags = 0, invflags = 0;
+	char iniface[IFNAMSIZ], outiface[IFNAMSIZ];
+	unsigned char iniface_mask[IFNAMSIZ], outiface_mask[IFNAMSIZ];
+
+	memset(&s, 0, sizeof(s));
+	memset(&d, 0, sizeof(d));
 
 	memset(&cs, 0, sizeof(cs));
 	cs.jumpto = "";
@@ -861,7 +942,7 @@ int do_commandx(struct nft_handle *h, int argc, char *argv[], char **table)
 			 * Option selection
 			 */
 		case 'p':
-			set_option(&cs.options, OPT_PROTOCOL, &cs.fw.ip.invflags,
+			set_option(&cs.options, OPT_PROTOCOL, &invflags,
 				   cs.invert);
 
 			/* Canonicalize into lower case */
@@ -869,31 +950,29 @@ int do_commandx(struct nft_handle *h, int argc, char *argv[], char **table)
 				*cs.protocol = tolower(*cs.protocol);
 
 			cs.protocol = optarg;
-			cs.fw.ip.proto = xtables_parse_protocol(cs.protocol);
+			proto = xtables_parse_protocol(cs.protocol);
 
-			if (cs.fw.ip.proto == 0
-			    && (cs.fw.ip.invflags & XT_INV_PROTO))
+			if (proto == 0 && (invflags & XT_INV_PROTO))
 				xtables_error(PARAMETER_PROBLEM,
 					   "rule would never match protocol");
 			break;
 
 		case 's':
-			set_option(&cs.options, OPT_SOURCE, &cs.fw.ip.invflags,
+			set_option(&cs.options, OPT_SOURCE, &invflags,
 				   cs.invert);
 			shostnetworkmask = optarg;
 			break;
 
 		case 'd':
-			set_option(&cs.options, OPT_DESTINATION, &cs.fw.ip.invflags,
+			set_option(&cs.options, OPT_DESTINATION, &invflags,
 				   cs.invert);
 			dhostnetworkmask = optarg;
 			break;
 
 #ifdef IPT_F_GOTO
 		case 'g':
-			set_option(&cs.options, OPT_JUMP, &cs.fw.ip.invflags,
+			set_option(&cs.options, OPT_JUMP, &invflags,
 				   cs.invert);
-			cs.fw.ip.flags |= IPT_F_GOTO;
 			cs.jumpto = parse_target(optarg);
 			break;
 #endif
@@ -908,11 +987,11 @@ int do_commandx(struct nft_handle *h, int argc, char *argv[], char **table)
 				xtables_error(PARAMETER_PROBLEM,
 					"Empty interface is likely to be "
 					"undesired");
-			set_option(&cs.options, OPT_VIANAMEIN, &cs.fw.ip.invflags,
+			set_option(&cs.options, OPT_VIANAMEIN, &invflags,
 				   cs.invert);
 			xtables_parse_interface(optarg,
-					cs.fw.ip.iniface,
-					cs.fw.ip.iniface_mask);
+						iniface,
+						iniface_mask);
 			break;
 
 		case 'o':
@@ -920,23 +999,23 @@ int do_commandx(struct nft_handle *h, int argc, char *argv[], char **table)
 				xtables_error(PARAMETER_PROBLEM,
 					"Empty interface is likely to be "
 					"undesired");
-			set_option(&cs.options, OPT_VIANAMEOUT, &cs.fw.ip.invflags,
+			set_option(&cs.options, OPT_VIANAMEOUT, &invflags,
 				   cs.invert);
 			xtables_parse_interface(optarg,
-					cs.fw.ip.outiface,
-					cs.fw.ip.outiface_mask);
+						outiface,
+						outiface_mask);
 			break;
 
 		case 'f':
-			set_option(&cs.options, OPT_FRAGMENT, &cs.fw.ip.invflags,
+			set_option(&cs.options, OPT_FRAGMENT, &invflags,
 				   cs.invert);
-			cs.fw.ip.flags |= IPT_F_FRAG;
+			flags |= IPT_F_FRAG;
 			break;
 
 		case 'v':
 			if (!verbose)
 				set_option(&cs.options, OPT_VERBOSE,
-					   &cs.fw.ip.invflags, cs.invert);
+					   &invflags, cs.invert);
 			verbose++;
 			break;
 
@@ -945,7 +1024,7 @@ int do_commandx(struct nft_handle *h, int argc, char *argv[], char **table)
 			break;
 
 		case 'n':
-			set_option(&cs.options, OPT_NUMERIC, &cs.fw.ip.invflags,
+			set_option(&cs.options, OPT_NUMERIC, &invflags,
 				   cs.invert);
 			break;
 
@@ -957,7 +1036,7 @@ int do_commandx(struct nft_handle *h, int argc, char *argv[], char **table)
 			break;
 
 		case 'x':
-			set_option(&cs.options, OPT_EXPANDED, &cs.fw.ip.invflags,
+			set_option(&cs.options, OPT_EXPANDED, &invflags,
 				   cs.invert);
 			break;
 
@@ -970,7 +1049,7 @@ int do_commandx(struct nft_handle *h, int argc, char *argv[], char **table)
 			exit(0);
 
 		case '0':
-			set_option(&cs.options, OPT_LINENUMBERS, &cs.fw.ip.invflags,
+			set_option(&cs.options, OPT_LINENUMBERS, &invflags,
 				   cs.invert);
 			break;
 
@@ -980,7 +1059,7 @@ int do_commandx(struct nft_handle *h, int argc, char *argv[], char **table)
 
 		case 'c':
 
-			set_option(&cs.options, OPT_COUNTERS, &cs.fw.ip.invflags,
+			set_option(&cs.options, OPT_COUNTERS, &invflags,
 				   cs.invert);
 			pcnt = optarg;
 			bcnt = strchr(pcnt + 1, ',');
@@ -994,29 +1073,25 @@ int do_commandx(struct nft_handle *h, int argc, char *argv[], char **table)
 					"-%c requires packet and byte counter",
 					opt2char(OPT_COUNTERS));
 
-			if (sscanf(pcnt, "%llu", &cnt) != 1)
+			if (sscanf(pcnt, "%llu", &pcnt_cnt) != 1)
 				xtables_error(PARAMETER_PROBLEM,
 					"-%c packet counter not numeric",
 					opt2char(OPT_COUNTERS));
-			cs.counters.pcnt = cnt;
 
-			if (sscanf(bcnt, "%llu", &cnt) != 1)
+			if (sscanf(bcnt, "%llu", &bcnt_cnt) != 1)
 				xtables_error(PARAMETER_PROBLEM,
 					"-%c byte counter not numeric",
 					opt2char(OPT_COUNTERS));
-			cs.counters.bcnt = cnt;
 			break;
 
 		case '4':
-			/* This is indeed the IPv4 iptables */
+			if (family != AF_INET)
+				exit_tryhelp(2);
 			break;
 
 		case '6':
-			/* This is not the IPv6 ip6tables */
-			if (line != -1)
-				return 1; /* success: line ignored */
-			fprintf(stderr, "This is the IPv4 version of iptables.\n");
-			exit_tryhelp(2);
+			family = AF_INET6;
+			break;
 
 		case 1: /* non option */
 			if (optarg[0] == '!' && optarg[1] == '\0') {
@@ -1063,27 +1138,109 @@ int do_commandx(struct nft_handle *h, int argc, char *argv[], char **table)
 		xtables_error(PARAMETER_PROBLEM,
 			   "nothing appropriate following !");
 
-	if (command & (CMD_REPLACE | CMD_INSERT | CMD_DELETE | CMD_APPEND | CMD_CHECK)) {
-		if (!(cs.options & OPT_DESTINATION))
-			dhostnetworkmask = "0.0.0.0/0";
-		if (!(cs.options & OPT_SOURCE))
-			shostnetworkmask = "0.0.0.0/0";
-	}
+	switch (family) {
+	case AF_INET:
+		cs.fw.ip.proto = proto;
+		cs.fw.ip.invflags = invflags;
+		cs.fw.ip.flags = flags;
 
-	if (shostnetworkmask)
-		xtables_ipparse_multiple(shostnetworkmask, &saddrs,
-					 &smasks, &nsaddrs);
+		strncpy(cs.fw.ip.iniface, iniface, IFNAMSIZ);
+		memcpy(cs.fw.ip.iniface_mask,
+		       iniface_mask, IFNAMSIZ*sizeof(unsigned char));
 
-	if (dhostnetworkmask)
-		xtables_ipparse_multiple(dhostnetworkmask, &daddrs,
-					 &dmasks, &ndaddrs);
+		strncpy(cs.fw.ip.outiface, outiface, IFNAMSIZ);
+		memcpy(cs.fw.ip.outiface_mask,
+		       outiface_mask, IFNAMSIZ*sizeof(unsigned char));
 
-	if ((nsaddrs > 1 || ndaddrs > 1) &&
-	    (cs.fw.ip.invflags & (IPT_INV_SRCIP | IPT_INV_DSTIP)))
-		xtables_error(PARAMETER_PROBLEM, "! not allowed with multiple"
-			   " source or destination IP addresses");
+		if (strlen(cs.jumpto) != 0)
+			cs.fw.ip.flags |= IPT_F_GOTO;
 
-	if (command == CMD_REPLACE && (nsaddrs != 1 || ndaddrs != 1))
+		cs.counters.pcnt = pcnt_cnt;
+		cs.counters.bcnt = bcnt_cnt;
+
+		if (command & (CMD_REPLACE | CMD_INSERT |
+				CMD_DELETE | CMD_APPEND | CMD_CHECK)) {
+			if (!(cs.options & OPT_DESTINATION))
+				dhostnetworkmask = "0.0.0.0/0";
+			if (!(cs.options & OPT_SOURCE))
+				shostnetworkmask = "0.0.0.0/0";
+		}
+
+		if (shostnetworkmask)
+			xtables_ipparse_multiple(shostnetworkmask, &s.addr.v4,
+						 &s.mask.v4, &s.naddrs);
+		if (dhostnetworkmask)
+			xtables_ipparse_multiple(dhostnetworkmask, &d.addr.v4,
+						 &d.mask.v4, &d.naddrs);
+
+		if ((s.naddrs > 1 || d.naddrs > 1) &&
+		    (cs.fw.ip.invflags & (IPT_INV_SRCIP | IPT_INV_DSTIP)))
+			xtables_error(PARAMETER_PROBLEM,
+				      "! not allowed with multiple"
+				      " source or destination IP addresses");
+		break;
+	case AF_INET6:
+		if (proto != 0)
+			flags |= IP6T_F_PROTO;
+
+		cs.fw6.ipv6.proto = proto;
+		cs.fw6.ipv6.invflags = invflags;
+		cs.fw6.ipv6.flags = flags;
+
+		if (flags & IPT_F_FRAG)
+			xtables_error(PARAMETER_PROBLEM,
+				      "-f is not valid on IPv6");
+
+		if (is_exthdr(cs.fw6.ipv6.proto)
+		    && (cs.fw6.ipv6.invflags & XT_INV_PROTO) == 0)
+			fprintf(stderr,
+				"Warning: never matched protocol: %s. "
+				"use extension match instead.\n",
+				cs.protocol);
+
+		strncpy(cs.fw6.ipv6.iniface, iniface, IFNAMSIZ);
+		memcpy(cs.fw6.ipv6.iniface_mask,
+		       iniface_mask, IFNAMSIZ*sizeof(unsigned char));
+
+		strncpy(cs.fw6.ipv6.outiface, outiface, IFNAMSIZ);
+		memcpy(cs.fw6.ipv6.outiface_mask,
+		       outiface_mask, IFNAMSIZ*sizeof(unsigned char));
+
+		if (strlen(cs.jumpto) != 0)
+			cs.fw6.ipv6.flags |= IP6T_F_GOTO;
+
+		cs.fw6.counters.pcnt = pcnt_cnt;
+		cs.fw6.counters.bcnt = bcnt_cnt;
+
+		if (command & (CMD_REPLACE | CMD_INSERT |
+				CMD_DELETE | CMD_APPEND | CMD_CHECK)) {
+			if (!(cs.options & OPT_DESTINATION))
+				dhostnetworkmask = "::0/0";
+			if (!(cs.options & OPT_SOURCE))
+				shostnetworkmask = "::0/0";
+		}
+
+		if (shostnetworkmask)
+			xtables_ip6parse_multiple(shostnetworkmask, &s.addr.v6,
+						  &s.mask.v6, &s.naddrs);
+		if (dhostnetworkmask)
+			xtables_ip6parse_multiple(dhostnetworkmask, &d.addr.v6,
+						  &d.mask.v6, &d.naddrs);
+
+		if ((s.naddrs > 1 || d.naddrs > 1) &&
+		    (cs.fw6.ipv6.invflags & (IP6T_INV_SRCIP | IP6T_INV_DSTIP)))
+			xtables_error(PARAMETER_PROBLEM,
+				      "! not allowed with multiple"
+				      " source or destination IP addresses");
+		break;
+	default:
+		exit_tryhelp(2);
+		break;
+	}
+
+	h->family = family;
+
+	if (command == CMD_REPLACE && (s.naddrs != 1 || d.naddrs != 1))
 		xtables_error(PARAMETER_PROBLEM, "Replacement rule does not "
 			   "specify a unique address");
 
@@ -1128,39 +1285,30 @@ int do_commandx(struct nft_handle *h, int argc, char *argv[], char **table)
 
 	switch (command) {
 	case CMD_APPEND:
-		ret = add_entry(chain, *table, &cs,
-				nsaddrs, saddrs, smasks,
-				ndaddrs, daddrs, dmasks,
-				cs.options&OPT_VERBOSE,
+		ret = add_entry(chain, *table, &cs, family,
+				s, d, cs.options&OPT_VERBOSE,
 				h, true);
 		break;
 	case CMD_DELETE:
-		ret = delete_entry(chain, *table, &cs,
-				   nsaddrs, saddrs, smasks,
-				   ndaddrs, daddrs, dmasks,
-				   cs.options&OPT_VERBOSE, h);
+		ret = delete_entry(chain, *table, &cs, family,
+				   s, d, cs.options&OPT_VERBOSE, h);
 		break;
 	case CMD_DELETE_NUM:
 		ret = nft_rule_delete_num(h, chain, *table, rulenum - 1, verbose);
 		break;
 	case CMD_CHECK:
-		ret = check_entry(chain, *table, &cs,
-				   nsaddrs, saddrs, smasks,
-				   ndaddrs, daddrs, dmasks,
-				   cs.options&OPT_VERBOSE, h);
+		ret = check_entry(chain, *table, &cs, family,
+				   s, d, cs.options&OPT_VERBOSE, h);
 		break;
 	case CMD_REPLACE:
 		/* FIXME replace at rulenum */
 		ret = replace_entry(chain, *table, &cs, rulenum - 1,
-				    saddrs, smasks, daddrs, dmasks,
-				    cs.options&OPT_VERBOSE, h);
+				    family, s, d, cs.options&OPT_VERBOSE, h);
 		break;
 	case CMD_INSERT:
 		/* FIXME insert at rulenum */
-		ret = add_entry(chain, *table, &cs,
-				nsaddrs, saddrs, smasks,
-				ndaddrs, daddrs, dmasks,
-				cs.options&OPT_VERBOSE, h, false);
+		ret = add_entry(chain, *table, &cs, family,
+				s, d, cs.options&OPT_VERBOSE, h, false);
 		break;
 	case CMD_FLUSH:
 		ret = nft_rule_flush(h, chain, *table);
@@ -1226,10 +1374,17 @@ int do_commandx(struct nft_handle *h, int argc, char *argv[], char **table)
 
 	clear_rule_matches(&cs.matches);
 
-	free(saddrs);
-	free(smasks);
-	free(daddrs);
-	free(dmasks);
+	if (family == AF_INET) {
+		free(s.addr.v4);
+		free(s.mask.v4);
+		free(d.addr.v4);
+		free(d.mask.v4);
+	} else if (family == AF_INET6) {
+		free(s.addr.v6);
+		free(s.mask.v6);
+		free(d.addr.v6);
+		free(d.mask.v6);
+	}
 	xtables_free_opts(1);
 
 	return ret;
-- 
1.8.0.2

