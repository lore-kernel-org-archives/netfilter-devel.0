From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 8/8] iptables: do not print trailing whitespaces
Date: Mon, 31 Jan 2011 03:16:58 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1101310316230.16889@obet.zrqbmnf.qr>
References: <1296439973-16089-1-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:44707 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750858Ab1AaCQ7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 30 Jan 2011 21:16:59 -0500
In-Reply-To: <1296439973-16089-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

parent bb8be30857edd501e701c2f22db6c59bd6839c87 ()
commit 73866357e4a7a0fdc1b293bf8863fee2bd56da9e
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Sat Dec 18 02:04:59 2010 +0100

iptables: do not print trailing whitespaces

Due to the use of printf("foobar "), iptables emits spaces at the
end-of-line, which looks odd to some users because it causes the
terminal to wrap even if there is seemingly nothing to print.

It may also have other points of annoyance, such as mailers
interpreting a trailing space as an indicator that the paragraph
continues when format=flowed is also on.
And git highlights trailing spaces in red, so let's avoid :)

Preexisting inconsistencies in outputting spaces in the right
spot are also addressed right away.

References: http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=429579
Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 (Diff generated using diff options: -w)
 extensions/libip6t_LOG.c        |    2 +-
 extensions/libip6t_dst.c        |    1 +
 extensions/libip6t_hbh.c        |    3 +--
 extensions/libip6t_icmp6.c      |    7 ++-----
 extensions/libip6t_ipv6header.c |    2 --
 extensions/libip6t_mh.c         |    2 +-
 extensions/libip6t_rt.c         |    4 +---
 extensions/libipt_DNAT.c        |    2 --
 extensions/libipt_LOG.c         |    2 +-
 extensions/libipt_MASQUERADE.c  |    2 --
 extensions/libipt_REDIRECT.c    |    2 --
 extensions/libipt_SAME.c        |    8 ++------
 extensions/libipt_SNAT.c        |    2 --
 extensions/libipt_ULOG.c        |    2 +-
 extensions/libipt_addrtype.c    |    2 --
 extensions/libipt_ah.c          |    1 -
 extensions/libipt_ecn.c         |   16 +++++++---------
 extensions/libipt_icmp.c        |    7 ++-----
 extensions/libxt_AUDIT.c        |    6 +++---
 extensions/libxt_CONNMARK.c     |    3 ---
 extensions/libxt_CT.c           |    1 -
 extensions/libxt_SET.c          |    2 --
 extensions/libxt_conntrack.c    |    2 --
 extensions/libxt_dccp.c         |    2 +-
 extensions/libxt_hashlimit.c    |    2 +-
 extensions/libxt_iprange.c      |    2 --
 extensions/libxt_mac.c          |    1 -
 extensions/libxt_multiport.c    |    4 ----
 extensions/libxt_physdev.c      |    1 -
 extensions/libxt_recent.c       |    2 +-
 extensions/libxt_sctp.c         |    6 ++----
 extensions/libxt_set.c          |    2 --
 extensions/libxt_state.c        |    1 -
 extensions/libxt_string.c       |    2 +-
 extensions/libxt_tcp.c          |    4 +---
 extensions/libxt_time.c         |    5 ++---
 extensions/libxt_u32.c          |    4 ++--
 extensions/libxt_udp.c          |    1 -
 ip6tables.c                     |    2 --
 iptables.c                      |    2 --
 xtables.c                       |    6 +++---
 41 files changed, 37 insertions(+), 93 deletions(-)

diff --git a/extensions/libip6t_LOG.c b/extensions/libip6t_LOG.c
index a33d570..af53705 100644
--- a/extensions/libip6t_LOG.c
+++ b/extensions/libip6t_LOG.c
@@ -230,7 +230,7 @@ static void LOG_print(const void *ip, const struct xt_entry_target *target,
 	}
 
 	if (strcmp(loginfo->prefix, "") != 0)
-		printf("prefix `%s' ", loginfo->prefix);
+		printf(" prefix \"%s\"", loginfo->prefix);
 }
 
 static void LOG_save(const void *ip, const struct xt_entry_target *target)
diff --git a/extensions/libip6t_dst.c b/extensions/libip6t_dst.c
index e4cf431..3ba804f 100644
--- a/extensions/libip6t_dst.c
+++ b/extensions/libip6t_dst.c
@@ -166,6 +166,7 @@ print_options(unsigned int optsnr, uint16_t *optsp)
 {
 	unsigned int i;
 
+	printf(" ");
 	for(i = 0; i < optsnr; i++) {
 		printf("%d", (optsp[i] & 0xFF00) >> 8);
 
diff --git a/extensions/libip6t_hbh.c b/extensions/libip6t_hbh.c
index f9d59df..e51569e 100644
--- a/extensions/libip6t_hbh.c
+++ b/extensions/libip6t_hbh.c
@@ -160,11 +160,11 @@ print_options(unsigned int optsnr, uint16_t *optsp)
 	unsigned int i;
 
 	for(i=0; i<optsnr; i++){
+		printf("%c", (i==0)?' ':',');
 		printf("%d", (optsp[i] & 0xFF00)>>8);
 		if ((optsp[i] & 0x00FF) != 0x00FF){
 			printf(":%d", (optsp[i] & 0x00FF));
 		} 
-		printf("%c", (i!=optsnr-1)?',':' ');
 	}
 }
 
@@ -178,7 +178,6 @@ static void hbh_print(const void *ip, const struct xt_entry_match *match,
 		printf("length");
 		printf(":%s", optinfo->invflags & IP6T_OPTS_INV_LEN ? "!" : "");
 		printf("%u", optinfo->hdrlen);
-		printf(" ");
 	}
 	if (optinfo->flags & IP6T_OPTS_OPTS) printf("opts ");
 	print_options(optinfo->optsnr, (uint16_t *)optinfo->opts);
diff --git a/extensions/libip6t_icmp6.c b/extensions/libip6t_icmp6.c
index 8c39488..fa87b69 100644
--- a/extensions/libip6t_icmp6.c
+++ b/extensions/libip6t_icmp6.c
@@ -197,11 +197,9 @@ static void print_icmpv6type(uint8_t type,
 		printf("!");
 
 	printf("type %u", type);
-	if (code_min == 0 && code_max == 0xFF)
-		printf(" ");
-	else if (code_min == code_max)
+	if (code_min == code_max)
 		printf(" code %u ", code_min);
-	else
+	else if (code_min != 0 || code_max != 0xFF)
 		printf(" codes %u-%u ", code_min, code_max);
 }
 
@@ -230,7 +228,6 @@ static void icmp6_save(const void *ip, const struct xt_entry_match *match)
 	printf("--icmpv6-type %u", icmpv6->type);
 	if (icmpv6->code[0] != 0 || icmpv6->code[1] != 0xFF)
 		printf("/%u", icmpv6->code[0]);
-	printf(" ");
 }
 
 static void icmp6_check(unsigned int flags)
diff --git a/extensions/libip6t_ipv6header.c b/extensions/libip6t_ipv6header.c
index 7d2a97f..da832e2 100644
--- a/extensions/libip6t_ipv6header.c
+++ b/extensions/libip6t_ipv6header.c
@@ -248,7 +248,6 @@ static void ipv6header_print(const void *ip,
                         printf("0x%02X ", info->matchflags);
                 else {
                         print_header(info->matchflags);
-                        printf(" ");
                 }
         }
 
@@ -263,7 +262,6 @@ static void ipv6header_save(const void *ip, const struct xt_entry_match *match)
 
 	printf("%s--header ", info->invflags ? "! " : "");
 	print_header(info->matchflags);
-	printf(" ");
 	if (info->modeflag)
 		printf("--soft ");
 }
diff --git a/extensions/libip6t_mh.c b/extensions/libip6t_mh.c
index f41c4f4..460f9e4 100644
--- a/extensions/libip6t_mh.c
+++ b/extensions/libip6t_mh.c
@@ -170,6 +170,7 @@ static void print_types(uint8_t min, uint8_t max, int invert, int numeric)
 	const char *inv = invert ? "!" : "";
 
 	if (min != 0 || max != 0xFF || invert) {
+		printf(" ");
 		if (min == max) {
 			printf("%s", inv);
 			print_type(min, numeric);
@@ -179,7 +180,6 @@ static void print_types(uint8_t min, uint8_t max, int invert, int numeric)
 			printf(":");
 			print_type(max, numeric);
 		}
-		printf(" ");
 	}
 }
 
diff --git a/extensions/libip6t_rt.c b/extensions/libip6t_rt.c
index 4e27f8a..bd2da59 100644
--- a/extensions/libip6t_rt.c
+++ b/extensions/libip6t_rt.c
@@ -245,7 +245,6 @@ print_nums(const char *name, uint32_t min, uint32_t max,
 			printf(":");
 			printf("%u",max);
 		}
-		printf(" ");
 	}
 }
 
@@ -255,7 +254,7 @@ print_addresses(unsigned int addrnr, struct in6_addr *addrp)
 	unsigned int i;
 
 	for(i=0; i<addrnr; i++){
-		printf("%s%c", addr_to_numeric(&(addrp[i])), (i!=addrnr-1)?',':' ');
+		printf("%c%s", (i==0)?' ':',', addr_to_numeric(&(addrp[i])));
 	}
 }
 
@@ -274,7 +273,6 @@ static void rt_print(const void *ip, const struct xt_entry_match *match,
 		printf("length");
 		printf(":%s", rtinfo->invflags & IP6T_RT_INV_LEN ? "!" : "");
 		printf("%u", rtinfo->hdrlen);
-		printf(" ");
 	}
 	if (rtinfo->flags & IP6T_RT_RES) printf("reserved ");
 	if (rtinfo->flags & IP6T_RT_FST) printf("0-addrs ");
diff --git a/extensions/libipt_DNAT.c b/extensions/libipt_DNAT.c
index 32b94b2..34d3777 100644
--- a/extensions/libipt_DNAT.c
+++ b/extensions/libipt_DNAT.c
@@ -224,7 +224,6 @@ static void DNAT_print(const void *ip, const struct xt_entry_target *target,
 	printf("to:");
 	for (i = 0; i < info->mr.rangesize; i++) {
 		print_range(&info->mr.range[i]);
-		printf(" ");
 		if (info->mr.range[i].flags & IP_NAT_RANGE_PROTO_RANDOM)
 			printf("random ");
 		if (info->mr.range[i].flags & IP_NAT_RANGE_PERSISTENT)
@@ -240,7 +239,6 @@ static void DNAT_save(const void *ip, const struct xt_entry_target *target)
 	for (i = 0; i < info->mr.rangesize; i++) {
 		printf("--to-destination ");
 		print_range(&info->mr.range[i]);
-		printf(" ");
 		if (info->mr.range[i].flags & IP_NAT_RANGE_PROTO_RANDOM)
 			printf("--random ");
 		if (info->mr.range[i].flags & IP_NAT_RANGE_PERSISTENT)
diff --git a/extensions/libipt_LOG.c b/extensions/libipt_LOG.c
index e6ccb3b..233bd9a 100644
--- a/extensions/libipt_LOG.c
+++ b/extensions/libipt_LOG.c
@@ -230,7 +230,7 @@ static void LOG_print(const void *ip, const struct xt_entry_target *target,
 	}
 
 	if (strcmp(loginfo->prefix, "") != 0)
-		printf("prefix `%s' ", loginfo->prefix);
+		printf(" prefix \"%s\"", loginfo->prefix);
 }
 
 static void LOG_save(const void *ip, const struct xt_entry_target *target)
diff --git a/extensions/libipt_MASQUERADE.c b/extensions/libipt_MASQUERADE.c
index 3b059ac..00baf25 100644
--- a/extensions/libipt_MASQUERADE.c
+++ b/extensions/libipt_MASQUERADE.c
@@ -118,7 +118,6 @@ MASQUERADE_print(const void *ip, const struct xt_entry_target *target,
 		printf("%hu", ntohs(r->min.tcp.port));
 		if (r->max.tcp.port != r->min.tcp.port)
 			printf("-%hu", ntohs(r->max.tcp.port));
-		printf(" ");
 	}
 
 	if (r->flags & IP_NAT_RANGE_PROTO_RANDOM)
@@ -135,7 +134,6 @@ MASQUERADE_save(const void *ip, const struct xt_entry_target *target)
 		printf("--to-ports %hu", ntohs(r->min.tcp.port));
 		if (r->max.tcp.port != r->min.tcp.port)
 			printf("-%hu", ntohs(r->max.tcp.port));
-		printf(" ");
 	}
 
 	if (r->flags & IP_NAT_RANGE_PROTO_RANDOM)
diff --git a/extensions/libipt_REDIRECT.c b/extensions/libipt_REDIRECT.c
index 74b3aa1..471ff29 100644
--- a/extensions/libipt_REDIRECT.c
+++ b/extensions/libipt_REDIRECT.c
@@ -128,7 +128,6 @@ static void REDIRECT_print(const void *ip, const struct xt_entry_target *target,
 		printf("%hu", ntohs(r->min.tcp.port));
 		if (r->max.tcp.port != r->min.tcp.port)
 			printf("-%hu", ntohs(r->max.tcp.port));
-		printf(" ");
 		if (mr->range[0].flags & IP_NAT_RANGE_PROTO_RANDOM)
 			printf("random ");
 	}
@@ -144,7 +143,6 @@ static void REDIRECT_save(const void *ip, const struct xt_entry_target *target)
 		printf("%hu", ntohs(r->min.tcp.port));
 		if (r->max.tcp.port != r->min.tcp.port)
 			printf("-%hu", ntohs(r->max.tcp.port));
-		printf(" ");
 		if (mr->range[0].flags & IP_NAT_RANGE_PROTO_RANDOM)
 			printf("--random ");
 	}
diff --git a/extensions/libipt_SAME.c b/extensions/libipt_SAME.c
index 9531a3b..9c548f5 100644
--- a/extensions/libipt_SAME.c
+++ b/extensions/libipt_SAME.c
@@ -150,9 +150,7 @@ static void SAME_print(const void *ip, const struct xt_entry_target *target,
 		printf("%s", xtables_ipaddr_to_numeric(&a));
 		a.s_addr = r->max_ip;
 		
-		if (r->min_ip == r->max_ip)
-			printf(" ");
-		else
+		if (r->min_ip != r->max_ip)
 			printf("-%s ", xtables_ipaddr_to_numeric(&a));
 		if (r->flags & IP_NAT_RANGE_PROTO_RANDOM) 
 			random_selection = 1;
@@ -179,9 +177,7 @@ static void SAME_save(const void *ip, const struct xt_entry_target *target)
 		printf("--to %s", xtables_ipaddr_to_numeric(&a));
 		a.s_addr = r->max_ip;
 
-		if (r->min_ip == r->max_ip)
-			printf(" ");
-		else
+		if (r->min_ip != r->max_ip)
 			printf("-%s ", xtables_ipaddr_to_numeric(&a));
 		if (r->flags & IP_NAT_RANGE_PROTO_RANDOM) 
 			random_selection = 1;
diff --git a/extensions/libipt_SNAT.c b/extensions/libipt_SNAT.c
index 2700bcc..532770d 100644
--- a/extensions/libipt_SNAT.c
+++ b/extensions/libipt_SNAT.c
@@ -224,7 +224,6 @@ static void SNAT_print(const void *ip, const struct xt_entry_target *target,
 	printf("to:");
 	for (i = 0; i < info->mr.rangesize; i++) {
 		print_range(&info->mr.range[i]);
-		printf(" ");
 		if (info->mr.range[i].flags & IP_NAT_RANGE_PROTO_RANDOM)
 			printf("random ");
 		if (info->mr.range[i].flags & IP_NAT_RANGE_PERSISTENT)
@@ -240,7 +239,6 @@ static void SNAT_save(const void *ip, const struct xt_entry_target *target)
 	for (i = 0; i < info->mr.rangesize; i++) {
 		printf("--to-source ");
 		print_range(&info->mr.range[i]);
-		printf(" ");
 		if (info->mr.range[i].flags & IP_NAT_RANGE_PROTO_RANDOM)
 			printf("--random ");
 		if (info->mr.range[i].flags & IP_NAT_RANGE_PERSISTENT)
diff --git a/extensions/libipt_ULOG.c b/extensions/libipt_ULOG.c
index 0185f98..8eeccf0 100644
--- a/extensions/libipt_ULOG.c
+++ b/extensions/libipt_ULOG.c
@@ -173,7 +173,7 @@ static void ULOG_print(const void *ip, const struct xt_entry_target *target,
 	printf("copy_range %u nlgroup ", (unsigned int)loginfo->copy_range);
 	print_groups(loginfo->nl_group);
 	if (strcmp(loginfo->prefix, "") != 0)
-		printf("prefix `%s' ", loginfo->prefix);
+		printf(" prefix \"%s\"", loginfo->prefix);
 	printf("queue_threshold %u ", (unsigned int)loginfo->qthreshold);
 }
 
diff --git a/extensions/libipt_addrtype.c b/extensions/libipt_addrtype.c
index fa6cc1e..a592f0d 100644
--- a/extensions/libipt_addrtype.c
+++ b/extensions/libipt_addrtype.c
@@ -203,8 +203,6 @@ static void print_types(uint16_t mask)
 			printf("%s%s", sep, rtn_names[i]);
 			sep = ",";
 		}
-
-	printf(" ");
 }
 
 static void addrtype_print_v0(const void *ip, const struct xt_entry_match *match,
diff --git a/extensions/libipt_ah.c b/extensions/libipt_ah.c
index 9359062..c50eecc 100644
--- a/extensions/libipt_ah.c
+++ b/extensions/libipt_ah.c
@@ -111,7 +111,6 @@ print_spis(const char *name, uint32_t min, uint32_t max,
 			printf(":");
 			printf("%u",max);
 		}
-		printf(" ");
 	}
 }
 
diff --git a/extensions/libipt_ecn.c b/extensions/libipt_ecn.c
index 27e46b3..81d7b58 100644
--- a/extensions/libipt_ecn.c
+++ b/extensions/libipt_ecn.c
@@ -97,21 +97,19 @@ static void ecn_print(const void *ip, const struct xt_entry_match *match,
 	printf("ECN match ");
 
 	if (einfo->operation & IPT_ECN_OP_MATCH_ECE) {
-		if (einfo->invert & IPT_ECN_OP_MATCH_ECE)
-			fputc('!', stdout);
-		printf("ECE ");
+		printf(" %sECE",
+		       (einfo->invert & IPT_ECN_OP_MATCH_ECE) ? "!" : "");
 	}
 
 	if (einfo->operation & IPT_ECN_OP_MATCH_CWR) {
-		if (einfo->invert & IPT_ECN_OP_MATCH_CWR)
-			fputc('!', stdout);
-		printf("CWR ");
+		printf(" %sCWR",
+		       (einfo->invert & IPT_ECN_OP_MATCH_CWR) ? "!" : "");
 	}
 
 	if (einfo->operation & IPT_ECN_OP_MATCH_IP) {
-		if (einfo->invert & IPT_ECN_OP_MATCH_IP)
-			fputc('!', stdout);
-		printf("ECT=%d ", einfo->ip_ect);
+		printf(" %sECT=%d",
+		       (einfo->invert & IPT_ECN_OP_MATCH_IP) ? "!" : "",
+		       einfo->ip_ect);
 	}
 }
 
diff --git a/extensions/libipt_icmp.c b/extensions/libipt_icmp.c
index a233520..c75713d 100644
--- a/extensions/libipt_icmp.c
+++ b/extensions/libipt_icmp.c
@@ -222,11 +222,9 @@ static void print_icmptype(uint8_t type,
 		printf("!");
 
 	printf("type %u", type);
-	if (code_min == 0 && code_max == 0xFF)
-		printf(" ");
-	else if (code_min == code_max)
+	if (code_min == code_max)
 		printf(" code %u ", code_min);
-	else
+	else if (code_min != 0 || code_max != 0xFF)
 		printf(" codes %u-%u ", code_min, code_max);
 }
 
@@ -259,7 +257,6 @@ static void icmp_save(const void *ip, const struct xt_entry_match *match)
 		printf("--icmp-type %u", icmp->type);
 		if (icmp->code[0] != 0 || icmp->code[1] != 0xFF)
 			printf("/%u", icmp->code[0]);
-		printf(" ");
 	}
 }
 
diff --git a/extensions/libxt_AUDIT.c b/extensions/libxt_AUDIT.c
index 1f2dee4..a6ab37f 100644
--- a/extensions/libxt_AUDIT.c
+++ b/extensions/libxt_AUDIT.c
@@ -92,13 +92,13 @@ static void audit_save(const void *ip, const struct xt_entry_target *target)
 
 	switch(einfo->type) {
 	case XT_AUDIT_TYPE_ACCEPT:
-		printf("--type=accept");
+		printf(" --type accept");
 		break;
 	case XT_AUDIT_TYPE_DROP:
-		printf("--type=drop");
+		printf(" --type drop");
 		break;
 	case XT_AUDIT_TYPE_REJECT:
-		printf("--type=reject");
+		printf(" --type reject");
 		break;
 	}
 }
diff --git a/extensions/libxt_CONNMARK.c b/extensions/libxt_CONNMARK.c
index 4657411..dbb9dc5 100644
--- a/extensions/libxt_CONNMARK.c
+++ b/extensions/libxt_CONNMARK.c
@@ -285,12 +285,10 @@ static void CONNMARK_print(const void *ip,
 	    printf("CONNMARK set ");
 	    print_mark(markinfo->mark);
 	    print_mask("/", markinfo->mask);
-	    printf(" ");
 	    break;
 	case XT_CONNMARK_SAVE:
 	    printf("CONNMARK save ");
 	    print_mask("mask ", markinfo->mask);
-	    printf(" ");
 	    break;
 	case XT_CONNMARK_RESTORE:
 	    printf("CONNMARK restore ");
@@ -358,7 +356,6 @@ static void CONNMARK_save(const void *ip, const struct xt_entry_target *target)
 	    printf("--set-mark ");
 	    print_mark(markinfo->mark);
 	    print_mask("/", markinfo->mask);
-	    printf(" ");
 	    break;
 	case XT_CONNMARK_SAVE:
 	    printf("--save-mark ");
diff --git a/extensions/libxt_CT.c b/extensions/libxt_CT.c
index 682dd83..38ee17b 100644
--- a/extensions/libxt_CT.c
+++ b/extensions/libxt_CT.c
@@ -94,7 +94,6 @@ static void ct_print_events(const char *pfx, const struct event_tbl *tbl,
 			sep = ",";
 		}
 	}
-	printf(" ");
 }
 
 static int ct_parse(int c, char **argv, int invert, unsigned int *flags,
diff --git a/extensions/libxt_SET.c b/extensions/libxt_SET.c
index 37da6ec..2f915bc 100644
--- a/extensions/libxt_SET.c
+++ b/extensions/libxt_SET.c
@@ -123,7 +123,6 @@ print_target_v0(const char *prefix, const struct xt_set_info_v0 *info)
 		       i == 0 ? " " : ",",
 		       info->u.flags[i] & IPSET_SRC ? "src" : "dst");
 	}
-	printf(" ");
 }
 
 static void
@@ -220,7 +219,6 @@ print_target(const char *prefix, const struct xt_set_info *info)
 		       i == 1 ? " " : ",",
 		       info->flags & (1 << i) ? "src" : "dst");
 	}
-	printf(" ");
 }
 
 static void
diff --git a/extensions/libxt_conntrack.c b/extensions/libxt_conntrack.c
index 8d8e1b2..8312d04 100644
--- a/extensions/libxt_conntrack.c
+++ b/extensions/libxt_conntrack.c
@@ -850,7 +850,6 @@ print_state(unsigned int statemask)
 		printf("%sDNAT", sep);
 		sep = ",";
 	}
-	printf(" ");
 }
 
 static void
@@ -876,7 +875,6 @@ print_status(unsigned int statusmask)
 	}
 	if (statusmask == 0)
 		printf("%sNONE", sep);
-	printf(" ");
 }
 
 static void
diff --git a/extensions/libxt_dccp.c b/extensions/libxt_dccp.c
index 7a0e96b..3b2dc6b 100644
--- a/extensions/libxt_dccp.c
+++ b/extensions/libxt_dccp.c
@@ -226,7 +226,6 @@ print_ports(const char *name, uint16_t min, uint16_t max,
 			printf(":");
 			print_port(max, numeric);
 		}
-		printf(" ");
 	}
 }
 
@@ -238,6 +237,7 @@ print_types(uint16_t types, int inverted, int numeric)
 	if (inverted)
 		printf("! ");
 
+	printf(" ");
 	while (types) {
 		unsigned int i;
 
diff --git a/extensions/libxt_hashlimit.c b/extensions/libxt_hashlimit.c
index 352e530..d766987 100644
--- a/extensions/libxt_hashlimit.c
+++ b/extensions/libxt_hashlimit.c
@@ -495,6 +495,7 @@ static void print_mode(unsigned int mode, char separator)
 {
 	bool prevmode = false;
 
+	putchar(' ');
 	if (mode & XT_HASHLIMIT_HASH_SIP) {
 		fputs("srcip", stdout);
 		prevmode = 1;
@@ -516,7 +517,6 @@ static void print_mode(unsigned int mode, char separator)
 			putchar(separator);
 		fputs("dstport", stdout);
 	}
-	putchar(' ');
 }
 
 static void hashlimit_print(const void *ip,
diff --git a/extensions/libxt_iprange.c b/extensions/libxt_iprange.c
index 2ac2fa4..2a91416 100644
--- a/extensions/libxt_iprange.c
+++ b/extensions/libxt_iprange.c
@@ -287,8 +287,6 @@ static void iprange_save(const void *ip, const struct xt_entry_match *match)
 			printf("! ");
 		printf("--src-range ");
 		print_iprange(&info->src);
-		if (info->flags & IPRANGE_DST)
-			fputc(' ', stdout);
 	}
 	if (info->flags & IPRANGE_DST) {
 		if (info->flags & IPRANGE_DST_INV)
diff --git a/extensions/libxt_mac.c b/extensions/libxt_mac.c
index 15a7f3c..d7e65da 100644
--- a/extensions/libxt_mac.c
+++ b/extensions/libxt_mac.c
@@ -76,7 +76,6 @@ static void print_mac(const unsigned char macaddress[ETH_ALEN])
 	printf("%02X", macaddress[0]);
 	for (i = 1; i < ETH_ALEN; i++)
 		printf(":%02X", macaddress[i]);
-	printf(" ");
 }
 
 static void mac_check(unsigned int flags)
diff --git a/extensions/libxt_multiport.c b/extensions/libxt_multiport.c
index 2f52383..163c7dc 100644
--- a/extensions/libxt_multiport.c
+++ b/extensions/libxt_multiport.c
@@ -340,7 +340,6 @@ __multiport_print(const struct xt_entry_match *match, int numeric,
 		printf("%s", i ? "," : "");
 		print_port(multiinfo->ports[i], proto, numeric);
 	}
-	printf(" ");
 }
 
 static void multiport_print(const void *ip_void,
@@ -395,7 +394,6 @@ static void __multiport_print_v1(const struct xt_entry_match *match,
 			print_port(multiinfo->ports[++i], proto, numeric);
 		}
 	}
-	printf(" ");
 }
 
 static void multiport_print_v1(const void *ip_void,
@@ -438,7 +436,6 @@ static void __multiport_save(const struct xt_entry_match *match,
 		printf("%s", i ? "," : "");
 		print_port(multiinfo->ports[i], proto, 1);
 	}
-	printf(" ");
 }
 
 static void multiport_save(const void *ip_void,
@@ -487,7 +484,6 @@ static void __multiport_save_v1(const struct xt_entry_match *match,
 			print_port(multiinfo->ports[++i], proto, 1);
 		}
 	}
-	printf(" ");
 }
 
 static void multiport_save_v1(const void *ip_void,
diff --git a/extensions/libxt_physdev.c b/extensions/libxt_physdev.c
index abd182c..1c0de97 100644
--- a/extensions/libxt_physdev.c
+++ b/extensions/libxt_physdev.c
@@ -131,7 +131,6 @@ physdev_print(const void *ip, const struct xt_entry_match *match, int numeric)
 	if (info->bitmask & XT_PHYSDEV_OP_BRIDGED)
 		printf("%s --physdev-is-bridged",
 		       info->invert & XT_PHYSDEV_OP_BRIDGED ? " !":"");
-	printf(" ");
 }
 
 static void physdev_save(const void *ip, const struct xt_entry_match *match)
diff --git a/extensions/libxt_recent.c b/extensions/libxt_recent.c
index 85f3613..e4a7f4d 100644
--- a/extensions/libxt_recent.c
+++ b/extensions/libxt_recent.c
@@ -162,7 +162,7 @@ static void recent_print(const void *ip, const struct xt_entry_match *match,
 	const struct xt_recent_mtinfo *info = (const void *)match->data;
 
 	if (info->invert)
-		fputc('!', stdout);
+		printf(" !");
 
 	printf("recent: ");
 	if (info->check_set & XT_RECENT_SET)
diff --git a/extensions/libxt_sctp.c b/extensions/libxt_sctp.c
index 016a9f9..718d4c4 100644
--- a/extensions/libxt_sctp.c
+++ b/extensions/libxt_sctp.c
@@ -339,7 +339,6 @@ print_ports(const char *name, uint16_t min, uint16_t max,
 			printf(":");
 			print_port(max, numeric);
 		}
-		printf(" ");
 	}
 }
 
@@ -412,6 +411,8 @@ print_chunks(const struct xt_sctp_info *einfo, int numeric)
 		if (SCTP_CHUNKMAP_IS_SET(einfo->chunkmap, i)) {
 			if (flag)
 				printf(",");
+			else
+				putchar(' ');
 			flag = 1;
 			print_chunk(i, numeric);
 			for (j = 0; j < flag_count; j++) {
@@ -422,9 +423,6 @@ print_chunks(const struct xt_sctp_info *einfo, int numeric)
 			}
 		}
 	}
-
-	if (flag)
-		printf(" ");
 out:
 	return;
 }
diff --git a/extensions/libxt_set.c b/extensions/libxt_set.c
index 6364011..78bf7c1 100644
--- a/extensions/libxt_set.c
+++ b/extensions/libxt_set.c
@@ -108,7 +108,6 @@ print_match_v0(const char *prefix, const struct xt_set_info_v0 *info)
 		       i == 0 ? " " : ",",
 		       info->u.flags[i] & IPSET_SRC ? "src" : "dst");
 	}
-	printf(" ");
 }
 
 /* Prints out the matchinfo. */
@@ -188,7 +187,6 @@ print_match(const char *prefix, const struct xt_set_info *info)
 		       i == 1 ? " " : ",",
 		       info->flags & (1 << i) ? "src" : "dst");
 	}
-	printf(" ");
 }
 
 /* Prints out the matchinfo. */
diff --git a/extensions/libxt_state.c b/extensions/libxt_state.c
index a236a3f..9a631aa 100644
--- a/extensions/libxt_state.c
+++ b/extensions/libxt_state.c
@@ -114,7 +114,6 @@ static void state_print_state(unsigned int statemask)
 		printf("%sUNTRACKED", sep);
 		sep = ",";
 	}
-	printf(" ");
 }
 
 static void
diff --git a/extensions/libxt_string.c b/extensions/libxt_string.c
index c78f9cd..4f75757 100644
--- a/extensions/libxt_string.c
+++ b/extensions/libxt_string.c
@@ -295,7 +295,7 @@ print_string(const char *str, const unsigned short int len)
 			printf("%c", 0x5c);
 		printf("%c", (unsigned char) str[i]);
 	}
-	printf("\" ");  /* closing space and quote */
+	printf("\"");  /* closing quote */
 }
 
 static void
diff --git a/extensions/libxt_tcp.c b/extensions/libxt_tcp.c
index 8bcb0dd..d9bcbd0 100644
--- a/extensions/libxt_tcp.c
+++ b/extensions/libxt_tcp.c
@@ -247,7 +247,6 @@ print_ports(const char *name, uint16_t min, uint16_t max,
 			printf(":");
 			print_port(max, numeric);
 		}
-		printf(" ");
 	}
 }
 
@@ -288,10 +287,10 @@ print_flags(uint8_t mask, uint8_t cmp, int invert, int numeric)
 		if (numeric)
 			printf("0x%02X/0x%02X ", mask, cmp);
 		else {
+			printf(" ");
 			print_tcpf(mask);
 			printf("/");
 			print_tcpf(cmp);
-			printf(" ");
 		}
 	}
 }
@@ -368,7 +367,6 @@ static void tcp_save(const void *ip, const struct xt_entry_match *match)
 		}
 		printf(" ");
 		print_tcpf(tcpinfo->flg_cmp);
-		printf(" ");
 	}
 }
 
diff --git a/extensions/libxt_time.c b/extensions/libxt_time.c
index b2e6ffa..56fb135 100644
--- a/extensions/libxt_time.c
+++ b/extensions/libxt_time.c
@@ -357,6 +357,7 @@ static void time_print_monthdays(uint32_t mask, bool human_readable)
 {
 	unsigned int i, nbdays = 0;
 
+	printf(" ");
 	for (i = 1; i <= 31; ++i)
 		if (mask & (1 << i)) {
 			if (nbdays++ > 0)
@@ -378,13 +379,13 @@ static void time_print_monthdays(uint32_t mask, bool human_readable)
 						break;
 				}
 		}
-	printf(" ");
 }
 
 static void time_print_weekdays(unsigned int mask)
 {
 	unsigned int i, nbdays = 0;
 
+	printf(" ");
 	for (i = 1; i <= 7; ++i)
 		if (mask & (1 << i)) {
 			if (nbdays > 0)
@@ -393,7 +394,6 @@ static void time_print_weekdays(unsigned int mask)
 				printf("%s", week_days[i]);
 			++nbdays;
 		}
-	printf(" ");
 }
 
 static inline void divide_time(unsigned int fulltime, unsigned int *hours,
@@ -459,7 +459,6 @@ static void time_save(const void *ip, const struct xt_entry_match *match)
 	if (info->weekdays_match != XT_TIME_ALL_WEEKDAYS) {
 		printf("--weekdays ");
 		time_print_weekdays(info->weekdays_match);
-		printf(" ");
 	}
 	time_print_date(info->date_start, "--datestart");
 	time_print_date(info->date_stop, "--datestop");
diff --git a/extensions/libxt_u32.c b/extensions/libxt_u32.c
index 378de0c..7f102d4 100644
--- a/extensions/libxt_u32.c
+++ b/extensions/libxt_u32.c
@@ -45,7 +45,7 @@ static void u32_dump(const struct xt_u32 *data)
 	const struct xt_u32_test *ct;
 	unsigned int testind, i;
 
-	putchar('\"');
+	printf(" \"");
 	for (testind = 0; testind < data->ntests; ++testind) {
 		ct = &data->tests[testind];
 
@@ -82,7 +82,7 @@ static void u32_dump(const struct xt_u32 *data)
 				       ct->value[i].max);
 		}
 	}
-	printf("\" ");
+	putchar('\"');
 }
 
 /* string_to_number() is not quite what we need here ... */
diff --git a/extensions/libxt_udp.c b/extensions/libxt_udp.c
index 2550d71..505b3c8 100644
--- a/extensions/libxt_udp.c
+++ b/extensions/libxt_udp.c
@@ -134,7 +134,6 @@ print_ports(const char *name, uint16_t min, uint16_t max,
 			printf(":");
 			print_port(max, numeric);
 		}
-		printf(" ");
 	}
 }
 
diff --git a/ip6tables.c b/ip6tables.c
index d4c2339..8c1b504 100644
--- a/ip6tables.c
+++ b/ip6tables.c
@@ -1024,8 +1024,6 @@ print_iface(char letter, const char *iface, const unsigned char *mask,
 			break;
 		}
 	}
-
-	printf(" ");
 }
 
 /* The ip6tables looks up the /etc/protocols. */
diff --git a/iptables.c b/iptables.c
index b45211a..2459b64 100644
--- a/iptables.c
+++ b/iptables.c
@@ -1057,8 +1057,6 @@ print_iface(char letter, const char *iface, const unsigned char *mask,
 			break;
 		}
 	}
-
-	printf(" ");
 }
 
 static int print_match_save(const struct ipt_entry_match *e,
diff --git a/xtables.c b/xtables.c
index be103d7..fc59f75 100644
--- a/xtables.c
+++ b/xtables.c
@@ -1641,14 +1641,14 @@ void xtables_save_string(const char *value)
 	length = strcspn(value, no_quote_chars);
 	if (length > 0 && value[length] == 0) {
 		/* no quoting required */
-		fputs(value, stdout);
 		putchar(' ');
+		fputs(value, stdout);
 	} else {
 		/* there is at least one dangerous character in the
 		   value, which we have to quote.  Write double quotes
 		   around the value and escape special characters with
 		   a backslash */
-		putchar('"');
+		printf(" \"");
 
 		for (p = strpbrk(value, escape_chars); p != NULL;
 		     p = strpbrk(value, escape_chars)) {
@@ -1662,7 +1662,7 @@ void xtables_save_string(const char *value)
 		/* print the rest and finish the double quoted
 		   string */
 		fputs(value, stdout);
-		printf("\" ");
+		putchar('\"');
 	}
 }
 
-- 
# Created with git-export-patch
