From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 7/9] extensions: switch parse() return type to bool
Date: Sun,  3 May 2009 21:54:31 +0200
Message-ID: <1241380473-22262-8-git-send-email-jengelh@medozas.de>
References: <1241380473-22262-1-git-send-email-jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:34574 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754007AbZECTyi (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 3 May 2009 15:54:38 -0400
In-Reply-To: <1241380473-22262-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

---
 extensions/libip6t_HL.c         |    6 +++---
 extensions/libip6t_LOG.c        |    6 +++---
 extensions/libip6t_REJECT.c     |    6 +++---
 extensions/libip6t_ah.c         |    6 +++---
 extensions/libip6t_dst.c        |    6 +++---
 extensions/libip6t_eui64.c      |    4 ++--
 extensions/libip6t_frag.c       |    6 +++---
 extensions/libip6t_hbh.c        |    6 +++---
 extensions/libip6t_hl.c         |    6 +++---
 extensions/libip6t_icmp6.c      |    6 +++---
 extensions/libip6t_ipv6header.c |    6 +++---
 extensions/libip6t_mh.c         |    6 +++---
 extensions/libip6t_policy.c     |    6 +++---
 extensions/libip6t_rt.c         |    6 +++---
 extensions/libipt_CLUSTERIP.c   |    6 +++---
 extensions/libipt_DNAT.c        |   16 ++++++++--------
 extensions/libipt_ECN.c         |    6 +++---
 extensions/libipt_LOG.c         |    6 +++---
 extensions/libipt_MASQUERADE.c  |   14 +++++++-------
 extensions/libipt_MIRROR.c      |    4 ++--
 extensions/libipt_NETMAP.c      |    6 +++---
 extensions/libipt_REDIRECT.c    |   17 +++++++++--------
 extensions/libipt_REJECT.c      |    6 +++---
 extensions/libipt_SAME.c        |    6 +++---
 extensions/libipt_SET.c         |    6 +++---
 extensions/libipt_SNAT.c        |   16 ++++++++--------
 extensions/libipt_TTL.c         |    6 +++---
 extensions/libipt_ULOG.c        |    6 +++---
 extensions/libipt_addrtype.c    |   18 +++++++++---------
 extensions/libipt_ah.c          |    6 +++---
 extensions/libipt_ecn.c         |    6 +++---
 extensions/libipt_icmp.c        |    6 +++---
 extensions/libipt_policy.c      |    6 +++---
 extensions/libipt_realm.c       |    6 +++---
 extensions/libipt_set.c         |    6 +++---
 extensions/libipt_ttl.c         |    6 +++---
 extensions/libipt_unclean.c     |    4 ++--
 extensions/libxt_CLASSIFY.c     |   12 ++++++------
 extensions/libxt_CONNMARK.c     |    8 ++++----
 extensions/libxt_CONNSECMARK.c  |    6 +++---
 extensions/libxt_DSCP.c         |    6 +++---
 extensions/libxt_MARK.c         |   14 +++++++-------
 extensions/libxt_NFLOG.c        |    6 +++---
 extensions/libxt_NFQUEUE.c      |    6 +++---
 extensions/libxt_NOTRACK.c      |    4 ++--
 extensions/libxt_RATEEST.c      |   18 +++++++++---------
 extensions/libxt_SECMARK.c      |    6 +++---
 extensions/libxt_TCPMSS.c       |   14 +++++++-------
 extensions/libxt_TCPOPTSTRIP.c  |    2 +-
 extensions/libxt_TOS.c          |    4 ++--
 extensions/libxt_TPROXY.c       |   10 +++++-----
 extensions/libxt_TRACE.c        |    4 ++--
 extensions/libxt_comment.c      |    6 +++---
 extensions/libxt_connbytes.c    |    6 +++---
 extensions/libxt_connlimit.c    |   10 +++++-----
 extensions/libxt_connmark.c     |    8 ++++----
 extensions/libxt_conntrack.c    |   22 +++++++++++-----------
 extensions/libxt_dccp.c         |    6 +++---
 extensions/libxt_dscp.c         |    6 +++---
 extensions/libxt_esp.c          |    6 +++---
 extensions/libxt_hashlimit.c    |   34 +++++++++++++++++-----------------
 extensions/libxt_helper.c       |    6 +++---
 extensions/libxt_iprange.c      |   10 +++++-----
 extensions/libxt_length.c       |    6 +++---
 extensions/libxt_limit.c        |   16 ++++++++--------
 extensions/libxt_mac.c          |    6 +++---
 extensions/libxt_mark.c         |    8 ++++----
 extensions/libxt_multiport.c    |   20 ++++++++++----------
 extensions/libxt_owner.c        |    9 +++++----
 extensions/libxt_physdev.c      |    6 +++---
 extensions/libxt_pkttype.c      |    6 +++---
 extensions/libxt_quota.c        |   10 +++++-----
 extensions/libxt_rateest.c      |   20 ++++++++++----------
 extensions/libxt_recent.c       |    6 +++---
 extensions/libxt_sctp.c         |    6 +++---
 extensions/libxt_socket.c       |    4 ++--
 extensions/libxt_standard.c     |    7 ++++---
 extensions/libxt_state.c        |   12 ++++++------
 extensions/libxt_statistic.c    |    6 +++---
 extensions/libxt_string.c       |   14 +++++++-------
 extensions/libxt_tcp.c          |    6 +++---
 extensions/libxt_tcpmss.c       |    6 +++---
 extensions/libxt_time.c         |   20 ++++++++++----------
 extensions/libxt_tos.c          |    4 ++--
 extensions/libxt_u32.c          |    8 ++++----
 extensions/libxt_udp.c          |    6 +++---
 include/xtables.h.in            |    4 ++--
 ip6tables.c                     |    4 ++--
 iptables.c                      |    4 ++--
 89 files changed, 367 insertions(+), 364 deletions(-)

diff --git a/extensions/libip6t_HL.c b/extensions/libip6t_HL.c
index 47f8e4e..d625b7f 100644
--- a/extensions/libip6t_HL.c
+++ b/extensions/libip6t_HL.c
@@ -25,7 +25,7 @@ static void HL_help(void)
 "  --hl-inc value		Increment HL by <value 1-255>\n");
 }
 
-static int HL_parse(int c, char **argv, bool invert, unsigned int *flags,
+static bool HL_parse(int c, char **argv, bool invert, unsigned int *flags,
                     const void *entry, struct xt_entry_target **target)
 {
 	struct ip6t_HL_info *info = (struct ip6t_HL_info *) (*target)->data;
@@ -73,14 +73,14 @@ static int HL_parse(int c, char **argv, bool invert, unsigned int *flags,
 			break;
 
 		default:
-			return 0;
+			return false;
 
 	}
 	
 	info->hop_limit = value;
 	*flags |= IP6T_HL_USED;
 
-	return 1;
+	return true;
 }
 
 static void HL_check(unsigned int flags)
diff --git a/extensions/libip6t_LOG.c b/extensions/libip6t_LOG.c
index a163487..824671e 100644
--- a/extensions/libip6t_LOG.c
+++ b/extensions/libip6t_LOG.c
@@ -101,7 +101,7 @@ parse_level(const char *level)
 #define IP6T_LOG_OPT_IPOPT 0x10
 #define IP6T_LOG_OPT_UID 0x20
 
-static int LOG_parse(int c, char **argv, bool invert, unsigned int *flags,
+static bool LOG_parse(int c, char **argv, bool invert, unsigned int *flags,
                      const void *entry, struct xt_entry_target **target)
 {
 	struct ip6t_log_info *loginfo = (struct ip6t_log_info *)(*target)->data;
@@ -184,10 +184,10 @@ static int LOG_parse(int c, char **argv, bool invert, unsigned int *flags,
 		break;
 
 	default:
-		return 0;
+		return false;
 	}
 
-	return 1;
+	return true;
 }
 
 static void LOG_print(const void *ip, const struct xt_entry_target *target,
diff --git a/extensions/libip6t_REJECT.c b/extensions/libip6t_REJECT.c
index c3077d4..38d3534 100644
--- a/extensions/libip6t_REJECT.c
+++ b/extensions/libip6t_REJECT.c
@@ -75,7 +75,7 @@ static void REJECT_init(struct xt_entry_target *t)
 
 }
 
-static int REJECT_parse(int c, char **argv, bool invert, unsigned int *flags,
+static bool REJECT_parse(int c, char **argv, bool invert, unsigned int *flags,
                         const void *entry, struct xt_entry_target **target)
 {
 	struct ip6t_reject_info *reject = 
@@ -92,7 +92,7 @@ static int REJECT_parse(int c, char **argv, bool invert, unsigned int *flags,
 			if ((strncasecmp(reject_table[i].name, optarg, strlen(optarg)) == 0)
 			    || (strncasecmp(reject_table[i].alias, optarg, strlen(optarg)) == 0)) {
 				reject->with = reject_table[i].with;
-				return 1;
+				return true;
 			}
 		}
 		xtables_error(PARAMETER_PROBLEM, "unknown reject type \"%s\"", optarg);
@@ -100,7 +100,7 @@ static int REJECT_parse(int c, char **argv, bool invert, unsigned int *flags,
 		/* Fall through */
 		break;
 	}
-	return 0;
+	return false;
 }
 
 static void REJECT_print(const void *ip, const struct xt_entry_target *target,
diff --git a/extensions/libip6t_ah.c b/extensions/libip6t_ah.c
index c7d0763..1682e73 100644
--- a/extensions/libip6t_ah.c
+++ b/extensions/libip6t_ah.c
@@ -77,7 +77,7 @@ static void ah_init(struct xt_entry_match *m)
 	ahinfo->hdrres = 0;
 }
 
-static int ah_parse(int c, char **argv, bool invert, unsigned int *flags,
+static bool ah_parse(int c, char **argv, bool invert, unsigned int *flags,
                     const void *entry, struct xt_entry_match **match)
 {
 	struct ip6t_ah *ahinfo = (struct ip6t_ah *)(*match)->data;
@@ -111,10 +111,10 @@ static int ah_parse(int c, char **argv, bool invert, unsigned int *flags,
 		*flags |= IP6T_AH_RES;
 		break;
 	default:
-		return 0;
+		return false;
 	}
 
-	return 1;
+	return true;
 }
 
 static void
diff --git a/extensions/libip6t_dst.c b/extensions/libip6t_dst.c
index 6c54507..8cb078d 100644
--- a/extensions/libip6t_dst.c
+++ b/extensions/libip6t_dst.c
@@ -116,7 +116,7 @@ static void dst_init(struct xt_entry_match *m)
 	optinfo->optsnr = 0;
 }
 
-static int dst_parse(int c, char **argv, bool invert, unsigned int *flags,
+static bool dst_parse(int c, char **argv, bool invert, unsigned int *flags,
                      const void *entry, struct xt_entry_match **match)
 {
 	struct ip6t_opts *optinfo = (struct ip6t_opts *)(*match)->data;
@@ -157,10 +157,10 @@ static int dst_parse(int c, char **argv, bool invert, unsigned int *flags,
 		*flags |= IP6T_OPTS_NSTRICT;
 		break;
 	default:
-		return 0;
+		return false;
 	}
 
-	return 1;
+	return true;
 }
 
 static void
diff --git a/extensions/libip6t_eui64.c b/extensions/libip6t_eui64.c
index 715a176..5b3d6a7 100644
--- a/extensions/libip6t_eui64.c
+++ b/extensions/libip6t_eui64.c
@@ -20,10 +20,10 @@ static void eui64_help(void)
 " This module checks for EUI64 IPv6 addresses\n");
 }
 
-static int eui64_parse(int c, char **argv, bool invert, unsigned int *flags,
+static bool eui64_parse(int c, char **argv, bool invert, unsigned int *flags,
                        const void *entry, struct xt_entry_match **match)
 {
-	return 0;
+	return false;
 }
 
 static struct xtables_match eui64_mt6_reg = {
diff --git a/extensions/libip6t_frag.c b/extensions/libip6t_frag.c
index d3be868..3803c07 100644
--- a/extensions/libip6t_frag.c
+++ b/extensions/libip6t_frag.c
@@ -85,7 +85,7 @@ static void frag_init(struct xt_entry_match *m)
 	fraginfo->invflags = 0;
 }
 
-static int frag_parse(int c, char **argv, bool invert, unsigned int *flags,
+static bool frag_parse(int c, char **argv, bool invert, unsigned int *flags,
                       const void *entry, struct xt_entry_match **match)
 {
 	struct ip6t_frag *fraginfo = (struct ip6t_frag *)(*match)->data;
@@ -142,10 +142,10 @@ static int frag_parse(int c, char **argv, bool invert, unsigned int *flags,
 		*flags |= IP6T_FRAG_NMF;
 		break;
 	default:
-		return 0;
+		return false;
 	}
 
-	return 1;
+	return true;
 }
 
 static void
diff --git a/extensions/libip6t_hbh.c b/extensions/libip6t_hbh.c
index 29e4a23..2c751e5 100644
--- a/extensions/libip6t_hbh.c
+++ b/extensions/libip6t_hbh.c
@@ -111,7 +111,7 @@ static void hbh_init(struct xt_entry_match *m)
 	optinfo->optsnr = 0;
 }
 
-static int hbh_parse(int c, char **argv, bool invert, unsigned int *flags,
+static bool hbh_parse(int c, char **argv, bool invert, unsigned int *flags,
                      const void *entry, struct xt_entry_match **match)
 {
 	struct ip6t_opts *optinfo = (struct ip6t_opts *)(*match)->data;
@@ -151,10 +151,10 @@ static int hbh_parse(int c, char **argv, bool invert, unsigned int *flags,
 		*flags |= IP6T_OPTS_NSTRICT;
 		break;
 	default:
-		return 0;
+		return false;
 	}
 
-	return 1;
+	return true;
 }
 
 static void
diff --git a/extensions/libip6t_hl.c b/extensions/libip6t_hl.c
index 76d7760..cc84018 100644
--- a/extensions/libip6t_hl.c
+++ b/extensions/libip6t_hl.c
@@ -24,7 +24,7 @@ static void hl_help(void)
 "  --hl-gt value	Match HL > value\n");
 }
 
-static int hl_parse(int c, char **argv, bool invert, unsigned int *flags,
+static bool hl_parse(int c, char **argv, bool invert, unsigned int *flags,
                     const void *entry, struct xt_entry_match **match)
 {
 	struct ip6t_hl_info *info = (struct ip6t_hl_info *) (*match)->data;
@@ -73,10 +73,10 @@ static int hl_parse(int c, char **argv, bool invert, unsigned int *flags,
 
 			break;
 		default:
-			return 0;
+			return false;
 	}
 
-	return 1;
+	return true;
 }
 
 static void hl_check(unsigned int flags)
diff --git a/extensions/libip6t_icmp6.c b/extensions/libip6t_icmp6.c
index 68fe2fa..c10a06e 100644
--- a/extensions/libip6t_icmp6.c
+++ b/extensions/libip6t_icmp6.c
@@ -149,7 +149,7 @@ static void icmp6_init(struct xt_entry_match *m)
 	icmpv6info->code[1] = 0xFF;
 }
 
-static int icmp6_parse(int c, char **argv, bool invert, unsigned int *flags,
+static bool icmp6_parse(int c, char **argv, bool invert, unsigned int *flags,
                        const void *entry, struct xt_entry_match **match)
 {
 	struct ip6t_icmp *icmpv6info = (struct ip6t_icmp *)(*match)->data;
@@ -168,10 +168,10 @@ static int icmp6_parse(int c, char **argv, bool invert, unsigned int *flags,
 		break;
 
 	default:
-		return 0;
+		return false;
 	}
 
-	return 1;
+	return true;
 }
 
 static void print_icmpv6type(u_int8_t type,
diff --git a/extensions/libip6t_ipv6header.c b/extensions/libip6t_ipv6header.c
index fd03d65..da6c0b0 100644
--- a/extensions/libip6t_ipv6header.c
+++ b/extensions/libip6t_ipv6header.c
@@ -179,7 +179,7 @@ parse_header(const char *flags) {
 #define IPV6_HDR_HEADER	0x01
 #define IPV6_HDR_SOFT	0x02
 
-static int
+static bool
 ipv6header_parse(int c, char **argv, bool invert, unsigned int *flags,
                  const void *entry, struct xt_entry_match **match)
 {
@@ -211,10 +211,10 @@ ipv6header_parse(int c, char **argv, bool invert, unsigned int *flags,
 			*flags |= IPV6_HDR_SOFT;
 			break;
 		default:
-			return 0;
+			return false;
 	}
 
-	return 1;
+	return true;
 }
 
 static void ipv6header_check(unsigned int flags)
diff --git a/extensions/libip6t_mh.c b/extensions/libip6t_mh.c
index 69e3150..f7b699f 100644
--- a/extensions/libip6t_mh.c
+++ b/extensions/libip6t_mh.c
@@ -124,7 +124,7 @@ static void parse_mh_types(const char *mhtype, u_int8_t *types)
 
 #define MH_TYPES 0x01
 
-static int mh_parse(int c, char **argv, bool invert, unsigned int *flags,
+static bool mh_parse(int c, char **argv, bool invert, unsigned int *flags,
                     const void *entry, struct xt_entry_match **match)
 {
 	struct ip6t_mh *mhinfo = (struct ip6t_mh *)(*match)->data;
@@ -142,10 +142,10 @@ static int mh_parse(int c, char **argv, bool invert, unsigned int *flags,
 		break;
 
 	default:
-		return 0;
+		return false;
 	}
 
-	return 1;
+	return true;
 }
 
 static const char *type_to_name(u_int8_t type)
diff --git a/extensions/libip6t_policy.c b/extensions/libip6t_policy.c
index 9a85f98..4ee3cfd 100644
--- a/extensions/libip6t_policy.c
+++ b/extensions/libip6t_policy.c
@@ -151,7 +151,7 @@ static int parse_mode(char *s)
 	xtables_error(PARAMETER_PROBLEM, "policy match: invalid mode \"%s\"", s);
 }
 
-static int policy_parse(int c, char **argv, bool invert, unsigned int *flags,
+static bool policy_parse(int c, char **argv, bool invert, unsigned int *flags,
                         const void *entry, struct xt_entry_match **match)
 {
 	struct ip6t_policy_info *info = (void *)(*match)->data;
@@ -276,11 +276,11 @@ static int policy_parse(int c, char **argv, bool invert, unsigned int *flags,
 			           "policy match: maximum policy depth reached");
 		break;
 	default:
-		return 0;
+		return false;
 	}
 
 	policy_info = info;
-	return 1;
+	return true;
 }
 
 static void policy_check(unsigned int flags)
diff --git a/extensions/libip6t_rt.c b/extensions/libip6t_rt.c
index e560661..67606e6 100644
--- a/extensions/libip6t_rt.c
+++ b/extensions/libip6t_rt.c
@@ -149,7 +149,7 @@ static void rt_init(struct xt_entry_match *m)
 	rtinfo->addrnr = 0;
 }
 
-static int rt_parse(int c, char **argv, bool invert, unsigned int *flags,
+static bool rt_parse(int c, char **argv, bool invert, unsigned int *flags,
                     const void *entry, struct xt_entry_match **match)
 {
 	struct ip6t_rt *rtinfo = (struct ip6t_rt *)(*match)->data;
@@ -224,10 +224,10 @@ static int rt_parse(int c, char **argv, bool invert, unsigned int *flags,
 		*flags |= IP6T_RT_FST_NSTRICT;
 		break;
 	default:
-		return 0;
+		return false;
 	}
 
-	return 1;
+	return true;
 }
 
 static void
diff --git a/extensions/libipt_CLUSTERIP.c b/extensions/libipt_CLUSTERIP.c
index f6bc373..b9fea2d 100644
--- a/extensions/libipt_CLUSTERIP.c
+++ b/extensions/libipt_CLUSTERIP.c
@@ -75,7 +75,7 @@ parse_mac(const char *mac, char *macbuf)
 	}
 }
 
-static int
+static bool
 CLUSTERIP_parse(int c, char **argv, bool invert, unsigned int *flags,
                 const void *entry, struct xt_entry_target **target)
 {
@@ -148,10 +148,10 @@ CLUSTERIP_parse(int c, char **argv, bool invert, unsigned int *flags,
 		*flags |= PARAM_HASHINIT;
 		break;
 	default:
-		return 0;
+		return false;
 	}
 
-	return 1;
+	return true;
 }
 
 static void CLUSTERIP_check(unsigned int flags)
diff --git a/extensions/libipt_DNAT.c b/extensions/libipt_DNAT.c
index 026c0ef..4f35aa2 100644
--- a/extensions/libipt_DNAT.c
+++ b/extensions/libipt_DNAT.c
@@ -137,21 +137,21 @@ parse_to(char *arg, int portok, struct ipt_natinfo *info)
 	return &(append_range(info, &range)->t);
 }
 
-static int DNAT_parse(int c, char **argv, bool invert, unsigned int *flags,
+static bool DNAT_parse(int c, char **argv, bool invert, unsigned int *flags,
                       const void *e, struct xt_entry_target **target)
 {
 	const struct ipt_entry *entry = e;
 	struct ipt_natinfo *info = (void *)*target;
-	int portok;
+	bool portok;
 
 	if (entry->ip.proto == IPPROTO_TCP
 	    || entry->ip.proto == IPPROTO_UDP
 	    || entry->ip.proto == IPPROTO_SCTP
 	    || entry->ip.proto == IPPROTO_DCCP
 	    || entry->ip.proto == IPPROTO_ICMP)
-		portok = 1;
+		portok = true;
 	else
-		portok = 0;
+		portok = false;
 
 	switch (c) {
 	case '1':
@@ -171,7 +171,7 @@ static int DNAT_parse(int c, char **argv, bool invert, unsigned int *flags,
 		if (*flags & IPT_DNAT_OPT_RANDOM)
 			info->mr.range[0].flags |= IP_NAT_RANGE_PROTO_RANDOM;
 		*flags |= IPT_DNAT_OPT_DEST;
-		return 1;
+		return true;
 
 	case '2':
 		if (*flags & IPT_DNAT_OPT_DEST) {
@@ -179,14 +179,14 @@ static int DNAT_parse(int c, char **argv, bool invert, unsigned int *flags,
 			*flags |= IPT_DNAT_OPT_RANDOM;
 		} else
 			*flags |= IPT_DNAT_OPT_RANDOM;
-		return 1;
+		return true;
 
 	case '3':
 		info->mr.range[0].flags |= IP_NAT_RANGE_PERSISTENT;
-		return 1;
+		return true;
 
 	default:
-		return 0;
+		return false;
 	}
 }
 
diff --git a/extensions/libipt_ECN.c b/extensions/libipt_ECN.c
index 38b70dd..19dd4ac 100644
--- a/extensions/libipt_ECN.c
+++ b/extensions/libipt_ECN.c
@@ -40,7 +40,7 @@ static const struct option ECN_opts[] = {
 	{ .name = NULL }
 };
 
-static int ECN_parse(int c, char **argv, bool invert, unsigned int *flags,
+static bool ECN_parse(int c, char **argv, bool invert, unsigned int *flags,
                      const void *entry, struct xt_entry_target **target)
 {
 	unsigned int result;
@@ -91,10 +91,10 @@ static int ECN_parse(int c, char **argv, bool invert, unsigned int *flags,
 		*flags |= IPT_ECN_OP_SET_IP;
 		break;
 	default:
-		return 0;
+		return false;
 	}
 
-	return 1;
+	return true;
 }
 
 static void ECN_check(unsigned int flags)
diff --git a/extensions/libipt_LOG.c b/extensions/libipt_LOG.c
index 047201f..59a08d6 100644
--- a/extensions/libipt_LOG.c
+++ b/extensions/libipt_LOG.c
@@ -101,7 +101,7 @@ parse_level(const char *level)
 #define IPT_LOG_OPT_IPOPT 0x10
 #define IPT_LOG_OPT_UID 0x20
 
-static int LOG_parse(int c, char **argv, bool invert, unsigned int *flags,
+static bool LOG_parse(int c, char **argv, bool invert, unsigned int *flags,
                      const void *entry, struct xt_entry_target **target)
 {
 	struct ipt_log_info *loginfo = (struct ipt_log_info *)(*target)->data;
@@ -184,10 +184,10 @@ static int LOG_parse(int c, char **argv, bool invert, unsigned int *flags,
 		break;
 
 	default:
-		return 0;
+		return false;
 	}
 
-	return 1;
+	return true;
 }
 
 static void LOG_print(const void *ip, const struct xt_entry_target *target,
diff --git a/extensions/libipt_MASQUERADE.c b/extensions/libipt_MASQUERADE.c
index f0d4c40..6d2446e 100644
--- a/extensions/libipt_MASQUERADE.c
+++ b/extensions/libipt_MASQUERADE.c
@@ -69,12 +69,12 @@ parse_ports(const char *arg, struct nf_nat_multi_range *mr)
 	}
 }
 
-static int
+static bool
 MASQUERADE_parse(int c, char **argv, bool invert, unsigned int *flags,
                  const void *e, struct xt_entry_target **target)
 {
 	const struct ipt_entry *entry = e;
-	int portok;
+	bool portok;
 	struct nf_nat_multi_range *mr
 		= (struct nf_nat_multi_range *)(*target)->data;
 
@@ -83,9 +83,9 @@ MASQUERADE_parse(int c, char **argv, bool invert, unsigned int *flags,
 	    || entry->ip.proto == IPPROTO_SCTP
 	    || entry->ip.proto == IPPROTO_DCCP
 	    || entry->ip.proto == IPPROTO_ICMP)
-		portok = 1;
+		portok = true;
 	else
-		portok = 0;
+		portok = false;
 
 	switch (c) {
 	case '1':
@@ -98,14 +98,14 @@ MASQUERADE_parse(int c, char **argv, bool invert, unsigned int *flags,
 				   "Unexpected `!' after --to-ports");
 
 		parse_ports(optarg, mr);
-		return 1;
+		return true;
 
 	case '2':
 		mr->range[0].flags |=  IP_NAT_RANGE_PROTO_RANDOM;
-		return 1;
+		return true;
 
 	default:
-		return 0;
+		return false;
 	}
 }
 
diff --git a/extensions/libipt_MIRROR.c b/extensions/libipt_MIRROR.c
index 8c62721..de8de86 100644
--- a/extensions/libipt_MIRROR.c
+++ b/extensions/libipt_MIRROR.c
@@ -12,10 +12,10 @@ static void MIRROR_help(void)
 	printf("MIRROR target takes no options\n");
 }
 
-static int MIRROR_parse(int c, char **argv, bool invert, unsigned int *flags,
+static bool MIRROR_parse(int c, char **argv, bool invert, unsigned int *flags,
                         const void *entry, struct xt_entry_target **target)
 {
-	return 0;
+	return false;
 }
 
 static struct xtables_target mirror_tg_reg = {
diff --git a/extensions/libipt_NETMAP.c b/extensions/libipt_NETMAP.c
index e65d434..4d4b125 100644
--- a/extensions/libipt_NETMAP.c
+++ b/extensions/libipt_NETMAP.c
@@ -110,7 +110,7 @@ parse_to(char *arg, struct nf_nat_range *range)
 	range->max_ip = range->min_ip | ~netmask;
 }
 
-static int NETMAP_parse(int c, char **argv, bool invert, unsigned int *flags,
+static bool NETMAP_parse(int c, char **argv, bool invert, unsigned int *flags,
                         const void *entry, struct xt_entry_target **target)
 {
 	struct nf_nat_multi_range *mr
@@ -124,10 +124,10 @@ static int NETMAP_parse(int c, char **argv, bool invert, unsigned int *flags,
 
 		parse_to(optarg, &mr->range[0]);
 		*flags = 1;
-		return 1;
+		return true;
 
 	default:
-		return 0;
+		return false;
 	}
 }
 
diff --git a/extensions/libipt_REDIRECT.c b/extensions/libipt_REDIRECT.c
index 09053df..83b0f22 100644
--- a/extensions/libipt_REDIRECT.c
+++ b/extensions/libipt_REDIRECT.c
@@ -76,22 +76,23 @@ parse_ports(const char *arg, struct nf_nat_multi_range *mr)
 	}
 }
 
-static int REDIRECT_parse(int c, char **argv, bool invert, unsigned int *flags,
-                          const void *e, struct xt_entry_target **target)
+static bool
+REDIRECT_parse(int c, char **argv, bool invert, unsigned int *flags,
+               const void *e, struct xt_entry_target **target)
 {
 	const struct ipt_entry *entry = e;
 	struct nf_nat_multi_range *mr
 		= (struct nf_nat_multi_range *)(*target)->data;
-	int portok;
+	bool portok;
 
 	if (entry->ip.proto == IPPROTO_TCP
 	    || entry->ip.proto == IPPROTO_UDP
 	    || entry->ip.proto == IPPROTO_SCTP
 	    || entry->ip.proto == IPPROTO_DCCP
 	    || entry->ip.proto == IPPROTO_ICMP)
-		portok = 1;
+		portok = true;
 	else
-		portok = 0;
+		portok = false;
 
 	switch (c) {
 	case '1':
@@ -107,7 +108,7 @@ static int REDIRECT_parse(int c, char **argv, bool invert, unsigned int *flags,
 		if (*flags & IPT_REDIRECT_OPT_RANDOM)
 			mr->range[0].flags |= IP_NAT_RANGE_PROTO_RANDOM;
 		*flags |= IPT_REDIRECT_OPT_DEST;
-		return 1;
+		return true;
 
 	case '2':
 		if (*flags & IPT_REDIRECT_OPT_DEST) {
@@ -115,10 +116,10 @@ static int REDIRECT_parse(int c, char **argv, bool invert, unsigned int *flags,
 			*flags |= IPT_REDIRECT_OPT_RANDOM;
 		} else
 			*flags |= IPT_REDIRECT_OPT_RANDOM;
-		return 1;
+		return true;
 
 	default:
-		return 0;
+		return false;
 	}
 }
 
diff --git a/extensions/libipt_REJECT.c b/extensions/libipt_REJECT.c
index 75bc5fc..9014fe4 100644
--- a/extensions/libipt_REJECT.c
+++ b/extensions/libipt_REJECT.c
@@ -90,7 +90,7 @@ static void REJECT_init(struct xt_entry_target *t)
 
 }
 
-static int REJECT_parse(int c, char **argv, bool invert, unsigned int *flags,
+static bool REJECT_parse(int c, char **argv, bool invert, unsigned int *flags,
                         const void *entry, struct xt_entry_target **target)
 {
 	struct ipt_reject_info *reject = (struct ipt_reject_info *)(*target)->data;
@@ -106,7 +106,7 @@ static int REJECT_parse(int c, char **argv, bool invert, unsigned int *flags,
 			if ((strncasecmp(reject_table[i].name, optarg, strlen(optarg)) == 0)
 			    || (strncasecmp(reject_table[i].alias, optarg, strlen(optarg)) == 0)) {
 				reject->with = reject_table[i].with;
-				return 1;
+				return true;
 			}
 		}
 		/* This due to be dropped late in 2.4 pre-release cycle --RR */
@@ -119,7 +119,7 @@ static int REJECT_parse(int c, char **argv, bool invert, unsigned int *flags,
 		/* Fall through */
 		break;
 	}
-	return 0;
+	return false;
 }
 
 static void REJECT_print(const void *ip, const struct xt_entry_target *target,
diff --git a/extensions/libipt_SAME.c b/extensions/libipt_SAME.c
index 266bce0..bbd63c7 100644
--- a/extensions/libipt_SAME.c
+++ b/extensions/libipt_SAME.c
@@ -79,7 +79,7 @@ parse_to(char *arg, struct nf_nat_range *range)
 #define IPT_SAME_OPT_NODST		0x02
 #define IPT_SAME_OPT_RANDOM		0x04
 
-static int SAME_parse(int c, char **argv, bool invert, unsigned int *flags,
+static bool SAME_parse(int c, char **argv, bool invert, unsigned int *flags,
                       const void *entry, struct xt_entry_target **target)
 {
 	struct ipt_same_info *mr
@@ -122,10 +122,10 @@ static int SAME_parse(int c, char **argv, bool invert, unsigned int *flags,
 		break;
 
 	default:
-		return 0;
+		return false;
 	}
 	
-	return 1;
+	return true;
 }
 
 static void SAME_check(unsigned int flags)
diff --git a/extensions/libipt_SET.c b/extensions/libipt_SET.c
index 0ce09c9..6f409a1 100644
--- a/extensions/libipt_SET.c
+++ b/extensions/libipt_SET.c
@@ -78,7 +78,7 @@ parse_target(char **argv, bool invert, unsigned int *flags,
 	*flags = 1;
 }
 
-static int SET_parse(int c, char **argv, bool invert, unsigned int *flags,
+static bool SET_parse(int c, char **argv, bool invert, unsigned int *flags,
                      const void *entry, struct xt_entry_target **target)
 {
 	struct ipt_set_info_target *myinfo =
@@ -95,9 +95,9 @@ static int SET_parse(int c, char **argv, bool invert, unsigned int *flags,
 		break;
 
 	default:
-		return 0;
+		return false;
 	}
-	return 1;
+	return true;
 }
 
 static void SET_check(unsigned int flags)
diff --git a/extensions/libipt_SNAT.c b/extensions/libipt_SNAT.c
index 1367494..11ef08f 100644
--- a/extensions/libipt_SNAT.c
+++ b/extensions/libipt_SNAT.c
@@ -137,21 +137,21 @@ parse_to(char *arg, int portok, struct ipt_natinfo *info)
 	return &(append_range(info, &range)->t);
 }
 
-static int SNAT_parse(int c, char **argv, bool invert, unsigned int *flags,
+static bool SNAT_parse(int c, char **argv, bool invert, unsigned int *flags,
                       const void *e, struct xt_entry_target **target)
 {
 	const struct ipt_entry *entry = e;
 	struct ipt_natinfo *info = (void *)*target;
-	int portok;
+	bool portok;
 
 	if (entry->ip.proto == IPPROTO_TCP
 	    || entry->ip.proto == IPPROTO_UDP
 	    || entry->ip.proto == IPPROTO_SCTP
 	    || entry->ip.proto == IPPROTO_DCCP
 	    || entry->ip.proto == IPPROTO_ICMP)
-		portok = 1;
+		portok = true;
 	else
-		portok = 0;
+		portok = false;
 
 	switch (c) {
 	case '1':
@@ -171,7 +171,7 @@ static int SNAT_parse(int c, char **argv, bool invert, unsigned int *flags,
 		if (*flags & IPT_SNAT_OPT_RANDOM)
 			info->mr.range[0].flags |= IP_NAT_RANGE_PROTO_RANDOM;
 		*flags |= IPT_SNAT_OPT_SOURCE;
-		return 1;
+		return true;
 
 	case '2':
 		if (*flags & IPT_SNAT_OPT_SOURCE) {
@@ -179,14 +179,14 @@ static int SNAT_parse(int c, char **argv, bool invert, unsigned int *flags,
 			*flags |= IPT_SNAT_OPT_RANDOM;
 		} else
 			*flags |= IPT_SNAT_OPT_RANDOM;
-		return 1;
+		return true;
 
 	case '3':
 		info->mr.range[0].flags |= IP_NAT_RANGE_PERSISTENT;
-		return 1;
+		return true;
 
 	default:
-		return 0;
+		return false;
 	}
 }
 
diff --git a/extensions/libipt_TTL.c b/extensions/libipt_TTL.c
index c25cb44..b42d68e 100644
--- a/extensions/libipt_TTL.c
+++ b/extensions/libipt_TTL.c
@@ -25,7 +25,7 @@ static void TTL_help(void)
 "  --ttl-inc value		Increment TTL by <value 1-255>\n");
 }
 
-static int TTL_parse(int c, char **argv, bool invert, unsigned int *flags,
+static bool TTL_parse(int c, char **argv, bool invert, unsigned int *flags,
                      const void *entry, struct xt_entry_target **target)
 {
 	struct ipt_TTL_info *info = (struct ipt_TTL_info *) (*target)->data;
@@ -73,14 +73,14 @@ static int TTL_parse(int c, char **argv, bool invert, unsigned int *flags,
 			break;
 
 		default:
-			return 0;
+			return false;
 
 	}
 	
 	info->ttl = value;
 	*flags |= IPT_TTL_USED;
 
-	return 1;
+	return true;
 }
 
 static void TTL_check(unsigned int flags)
diff --git a/extensions/libipt_ULOG.c b/extensions/libipt_ULOG.c
index 78f5d0a..466564b 100644
--- a/extensions/libipt_ULOG.c
+++ b/extensions/libipt_ULOG.c
@@ -64,7 +64,7 @@ static void ULOG_init(struct xt_entry_target *t)
 #define IPT_LOG_OPT_CPRANGE 0x04
 #define IPT_LOG_OPT_QTHRESHOLD 0x08
 
-static int ULOG_parse(int c, char **argv, bool invert, unsigned int *flags,
+static bool ULOG_parse(int c, char **argv, bool invert, unsigned int *flags,
                       const void *entry, struct xt_entry_target **target)
 {
 	struct ipt_ulog_info *loginfo =
@@ -139,9 +139,9 @@ static int ULOG_parse(int c, char **argv, bool invert, unsigned int *flags,
 		*flags |= IPT_LOG_OPT_QTHRESHOLD;
 		break;
 	default:
-		return 0;
+		return false;
 	}
-	return 1;
+	return true;
 }
 
 static void ULOG_save(const void *ip, const struct xt_entry_target *target)
diff --git a/extensions/libipt_addrtype.c b/extensions/libipt_addrtype.c
index 1d72119..91e469f 100644
--- a/extensions/libipt_addrtype.c
+++ b/extensions/libipt_addrtype.c
@@ -60,7 +60,7 @@ static void addrtype_help_v1(void)
 	addrtype_help_types();
 }
 
-static int
+static bool
 parse_type(const char *name, size_t len, u_int16_t *mask)
 {
 	int i;
@@ -69,10 +69,10 @@ parse_type(const char *name, size_t len, u_int16_t *mask)
 		if (strncasecmp(name, rtn_names[i], len) == 0) {
 			/* build up bitmask for kernel module */
 			*mask |= (1 << i);
-			return 1;
+			return true;
 		}
 
-	return 0;
+	return false;
 }
 
 static void parse_types(const char *arg, u_int16_t *mask)
@@ -95,7 +95,7 @@ static void parse_types(const char *arg, u_int16_t *mask)
 #define IPT_ADDRTYPE_OPT_LIMIT_IFACE_IN		0x4
 #define IPT_ADDRTYPE_OPT_LIMIT_IFACE_OUT	0x8
 
-static int
+static bool
 addrtype_parse_v0(int c, char **argv, bool invert, unsigned int *flags,
                   const void *entry, struct xt_entry_match **match)
 {
@@ -124,13 +124,13 @@ addrtype_parse_v0(int c, char **argv, bool invert, unsigned int *flags,
 		*flags |= IPT_ADDRTYPE_OPT_DSTTYPE;
 		break;
 	default:
-		return 0;
+		return false;
 	}
 	
-	return 1;
+	return true;
 }
 
-static int
+static bool
 addrtype_parse_v1(int c, char **argv, bool invert, unsigned int *flags,
                   const void *entry, struct xt_entry_match **match)
 {
@@ -173,10 +173,10 @@ addrtype_parse_v1(int c, char **argv, bool invert, unsigned int *flags,
 		*flags |= IPT_ADDRTYPE_OPT_LIMIT_IFACE_OUT;
 		break;
 	default:
-		return 0;
+		return false;
 	}
 	
-	return 1;
+	return true;
 }
 
 static void addrtype_check_v0(unsigned int flags)
diff --git a/extensions/libipt_ah.c b/extensions/libipt_ah.c
index 089220e..00b43ab 100644
--- a/extensions/libipt_ah.c
+++ b/extensions/libipt_ah.c
@@ -73,7 +73,7 @@ static void ah_init(struct xt_entry_match *m)
 
 #define AH_SPI 0x01
 
-static int ah_parse(int c, char **argv, bool invert, unsigned int *flags,
+static bool ah_parse(int c, char **argv, bool invert, unsigned int *flags,
                     const void *entry, struct xt_entry_match **match)
 {
 	struct ipt_ah *ahinfo = (struct ipt_ah *)(*match)->data;
@@ -90,10 +90,10 @@ static int ah_parse(int c, char **argv, bool invert, unsigned int *flags,
 		*flags |= AH_SPI;
 		break;
 	default:
-		return 0;
+		return false;
 	}
 
-	return 1;
+	return true;
 }
 
 static void
diff --git a/extensions/libipt_ecn.c b/extensions/libipt_ecn.c
index 6fbf601..fee0098 100644
--- a/extensions/libipt_ecn.c
+++ b/extensions/libipt_ecn.c
@@ -32,7 +32,7 @@ static const struct option ecn_opts[] = {
 	{ .name = NULL }
 };
 
-static int ecn_parse(int c, char **argv, bool invert, unsigned int *flags,
+static bool ecn_parse(int c, char **argv, bool invert, unsigned int *flags,
                      const void *entry, struct xt_entry_match **match)
 {
 	unsigned int result;
@@ -77,10 +77,10 @@ static int ecn_parse(int c, char **argv, bool invert, unsigned int *flags,
 		einfo->ip_ect = result;
 		break;
 	default:
-		return 0;
+		return false;
 	}
 
-	return 1;
+	return true;
 }
 
 static void ecn_check(unsigned int flags)
diff --git a/extensions/libipt_icmp.c b/extensions/libipt_icmp.c
index a5b6517..f823677 100644
--- a/extensions/libipt_icmp.c
+++ b/extensions/libipt_icmp.c
@@ -174,7 +174,7 @@ static void icmp_init(struct xt_entry_match *m)
 	icmpinfo->code[1] = 0xFF;
 }
 
-static int icmp_parse(int c, char **argv, bool invert, unsigned int *flags,
+static bool icmp_parse(int c, char **argv, bool invert, unsigned int *flags,
                       const void *entry, struct xt_entry_match **match)
 {
 	struct ipt_icmp *icmpinfo = (struct ipt_icmp *)(*match)->data;
@@ -193,10 +193,10 @@ static int icmp_parse(int c, char **argv, bool invert, unsigned int *flags,
 		break;
 
 	default:
-		return 0;
+		return false;
 	}
 
-	return 1;
+	return true;
 }
 
 static void print_icmptype(u_int8_t type,
diff --git a/extensions/libipt_policy.c b/extensions/libipt_policy.c
index fcd2564..67c529f 100644
--- a/extensions/libipt_policy.c
+++ b/extensions/libipt_policy.c
@@ -119,7 +119,7 @@ static int parse_mode(char *s)
 	xtables_error(PARAMETER_PROBLEM, "policy match: invalid mode \"%s\"", s);
 }
 
-static int policy_parse(int c, char **argv, bool invert, unsigned int *flags,
+static bool policy_parse(int c, char **argv, bool invert, unsigned int *flags,
                         const void *entry, struct xt_entry_match **match)
 {
 	struct ipt_policy_info *info = (void *)(*match)->data;
@@ -244,11 +244,11 @@ static int policy_parse(int c, char **argv, bool invert, unsigned int *flags,
 			           "policy match: maximum policy depth reached");
 		break;
 	default:
-		return 0;
+		return false;
 	}
 
 	policy_info = info;
-	return 1;
+	return true;
 }
 
 static void policy_check(unsigned int flags)
diff --git a/extensions/libipt_realm.c b/extensions/libipt_realm.c
index 05626dc..bde3472 100644
--- a/extensions/libipt_realm.c
+++ b/extensions/libipt_realm.c
@@ -149,7 +149,7 @@ static const char *realm_id2name(int id)
 	return NULL;
 }
 
-static int realm_parse(int c, char **argv, bool invert, unsigned int *flags,
+static bool realm_parse(int c, char **argv, bool invert, unsigned int *flags,
                        const void *entry, struct xt_entry_match **match)
 {
 	struct ipt_realm_info *realminfo = (struct ipt_realm_info *)(*match)->data;
@@ -183,9 +183,9 @@ static int realm_parse(int c, char **argv, bool invert, unsigned int *flags,
 		break;
 
 	default:
-		return 0;
+		return false;
 	}
-	return 1;
+	return true;
 }
 
 static void
diff --git a/extensions/libipt_set.c b/extensions/libipt_set.c
index c3ffc70..b704852 100644
--- a/extensions/libipt_set.c
+++ b/extensions/libipt_set.c
@@ -46,7 +46,7 @@ static void set_init(struct xt_entry_match *match)
 
 }
 
-static int set_parse(int c, char **argv, bool invert, unsigned int *flags,
+static bool set_parse(int c, char **argv, bool invert, unsigned int *flags,
                      const void *entry, struct xt_entry_match **match)
 {
 	struct ipt_set_info_match *myinfo = 
@@ -83,10 +83,10 @@ static int set_parse(int c, char **argv, bool invert, unsigned int *flags,
 		break;
 
 	default:
-		return 0;
+		return false;
 	}
 
-	return 1;
+	return true;
 }
 
 static void set_check(unsigned int flags)
diff --git a/extensions/libipt_ttl.c b/extensions/libipt_ttl.c
index 21cbf0d..f0be535 100644
--- a/extensions/libipt_ttl.c
+++ b/extensions/libipt_ttl.c
@@ -23,7 +23,7 @@ static void ttl_help(void)
 "  --ttl-gt value	Match TTL > value\n");
 }
 
-static int ttl_parse(int c, char **argv, bool invert, unsigned int *flags,
+static bool ttl_parse(int c, char **argv, bool invert, unsigned int *flags,
                      const void *entry, struct xt_entry_match **match)
 {
 	struct ipt_ttl_info *info = (struct ipt_ttl_info *) (*match)->data;
@@ -70,7 +70,7 @@ static int ttl_parse(int c, char **argv, bool invert, unsigned int *flags,
 			info->ttl = value;
 			break;
 		default:
-			return 0;
+			return false;
 
 	}
 
@@ -79,7 +79,7 @@ static int ttl_parse(int c, char **argv, bool invert, unsigned int *flags,
 				"Can't specify TTL option twice");
 	*flags = 1;
 
-	return 1;
+	return true;
 }
 
 static void ttl_check(unsigned int flags)
diff --git a/extensions/libipt_unclean.c b/extensions/libipt_unclean.c
index 96c58bb..6f8ca20 100644
--- a/extensions/libipt_unclean.c
+++ b/extensions/libipt_unclean.c
@@ -10,10 +10,10 @@ static void unclean_help(void)
 	printf("unclean match takes no options\n");
 }
 
-static int unclean_parse(int c, char **argv, bool invert, unsigned int *flags,
+static bool unclean_parse(int c, char **argv, bool invert, unsigned int *flags,
                          const void *entry, struct xt_entry_match **match)
 {
-	return 0;
+	return false;
 }
 
 static struct xtables_match unclean_mt_reg = {
diff --git a/extensions/libxt_CLASSIFY.c b/extensions/libxt_CLASSIFY.c
index c5d37f9..1bd7133 100644
--- a/extensions/libxt_CLASSIFY.c
+++ b/extensions/libxt_CLASSIFY.c
@@ -24,18 +24,18 @@ static const struct option CLASSIFY_opts[] = {
 	{ .name = NULL }
 };
 
-static int CLASSIFY_string_to_priority(const char *s, unsigned int *p)
+static bool CLASSIFY_string_to_priority(const char *s, unsigned int *p)
 {
 	unsigned int i, j;
 
 	if (sscanf(s, "%x:%x", &i, &j) != 2)
-		return 1;
+		return true;
 	
 	*p = TC_H_MAKE(i<<16, j);
-	return 0;
+	return false;
 }
 
-static int
+static bool
 CLASSIFY_parse(int c, char **argv, bool invert, unsigned int *flags,
       const void *entry,
       struct xt_entry_target **target)
@@ -55,10 +55,10 @@ CLASSIFY_parse(int c, char **argv, bool invert, unsigned int *flags,
 		break;
 
 	default:
-		return 0;
+		return false;
 	}
 
-	return 1;
+	return true;
 }
 
 static void
diff --git a/extensions/libxt_CONNMARK.c b/extensions/libxt_CONNMARK.c
index 2905fea..1aab593 100644
--- a/extensions/libxt_CONNMARK.c
+++ b/extensions/libxt_CONNMARK.c
@@ -95,7 +95,7 @@ static void connmark_tg_init(struct xt_entry_target *target)
 	info->nfmask = UINT32_MAX;
 }
 
-static int
+static bool
 CONNMARK_parse(int c, char **argv, bool invert, unsigned int *flags,
                const void *entry, struct xt_entry_target **target)
 {
@@ -142,13 +142,13 @@ CONNMARK_parse(int c, char **argv, bool invert, unsigned int *flags,
 			xtables_error(PARAMETER_PROBLEM, "Bad MASK value \"%s\"", optarg);
 		break;
 	default:
-		return 0;
+		return false;
 	}
 
-	return 1;
+	return true;
 }
 
-static int connmark_tg_parse(int c, char **argv, bool invert,
+static bool connmark_tg_parse(int c, char **argv, bool invert,
                              unsigned int *flags, const void *entry,
                              struct xt_entry_target **target)
 {
diff --git a/extensions/libxt_CONNSECMARK.c b/extensions/libxt_CONNSECMARK.c
index c32d03c..d48d1f6 100644
--- a/extensions/libxt_CONNSECMARK.c
+++ b/extensions/libxt_CONNSECMARK.c
@@ -29,7 +29,7 @@ static const struct option CONNSECMARK_opts[] = {
 	{ .name = NULL }
 };
 
-static int
+static bool
 CONNSECMARK_parse(int c, char **argv, bool invert, unsigned int *flags,
                   const void *entry, struct xt_entry_target **target)
 {
@@ -54,10 +54,10 @@ CONNSECMARK_parse(int c, char **argv, bool invert, unsigned int *flags,
 		break;
 
 	default:
-		return 0;
+		return false;
 	}
 
-	return 1;
+	return true;
 }
 
 static void CONNSECMARK_check(unsigned int flags)
diff --git a/extensions/libxt_DSCP.c b/extensions/libxt_DSCP.c
index 7af4166..ac49022 100644
--- a/extensions/libxt_DSCP.c
+++ b/extensions/libxt_DSCP.c
@@ -71,7 +71,7 @@ parse_class(const char *s, struct xt_DSCP_info *dinfo)
 }
 
 
-static int DSCP_parse(int c, char **argv, bool invert, unsigned int *flags,
+static bool DSCP_parse(int c, char **argv, bool invert, unsigned int *flags,
                       const void *entry, struct xt_entry_target **target)
 {
 	struct xt_DSCP_info *dinfo
@@ -94,10 +94,10 @@ static int DSCP_parse(int c, char **argv, bool invert, unsigned int *flags,
 		break;
 
 	default:
-		return 0;
+		return false;
 	}
 
-	return 1;
+	return true;
 }
 
 static void DSCP_check(unsigned int flags)
diff --git a/extensions/libxt_MARK.c b/extensions/libxt_MARK.c
index 64292ed..1729452 100644
--- a/extensions/libxt_MARK.c
+++ b/extensions/libxt_MARK.c
@@ -52,7 +52,7 @@ static void mark_tg_help(void)
 
 /* Function which parses command options; returns true if it
    ate an option */
-static int
+static bool
 MARK_parse_v0(int c, char **argv, bool invert, unsigned int *flags,
               const void *entry, struct xt_entry_target **target)
 {
@@ -77,10 +77,10 @@ MARK_parse_v0(int c, char **argv, bool invert, unsigned int *flags,
 		xtables_error(PARAMETER_PROBLEM,
 			   "MARK target: kernel too old for --or-mark");
 	default:
-		return 0;
+		return false;
 	}
 
-	return 1;
+	return true;
 }
 
 static void MARK_check(unsigned int flags)
@@ -91,7 +91,7 @@ static void MARK_check(unsigned int flags)
 			   " is required");
 }
 
-static int
+static bool
 MARK_parse_v1(int c, char **argv, bool invert, unsigned int *flags,
               const void *entry, struct xt_entry_target **target)
 {
@@ -110,7 +110,7 @@ MARK_parse_v1(int c, char **argv, bool invert, unsigned int *flags,
 	        markinfo->mode = XT_MARK_OR;
 		break;
 	default:
-		return 0;
+		return false;
 	}
 
 	if (!xtables_strtoui(optarg, NULL, &mark, 0, UINT32_MAX))
@@ -121,10 +121,10 @@ MARK_parse_v1(int c, char **argv, bool invert, unsigned int *flags,
 			   "MARK target: Can't specify --set-mark twice");
 
 	*flags = 1;
-	return 1;
+	return true;
 }
 
-static int mark_tg_parse(int c, char **argv, bool invert, unsigned int *flags,
+static bool mark_tg_parse(int c, char **argv, bool invert, unsigned int *flags,
                          const void *entry, struct xt_entry_target **target)
 {
 	struct xt_mark_tginfo2 *info = (void *)(*target)->data;
diff --git a/extensions/libxt_NFLOG.c b/extensions/libxt_NFLOG.c
index 023cfda..c0237c7 100644
--- a/extensions/libxt_NFLOG.c
+++ b/extensions/libxt_NFLOG.c
@@ -40,7 +40,7 @@ static void NFLOG_init(struct xt_entry_target *t)
 	info->threshold	= XT_NFLOG_DEFAULT_THRESHOLD;
 }
 
-static int NFLOG_parse(int c, char **argv, bool invert, unsigned int *flags,
+static bool NFLOG_parse(int c, char **argv, bool invert, unsigned int *flags,
                        const void *entry, struct xt_entry_target **target)
 {
 	struct xt_nflog_info *info = (struct xt_nflog_info *)(*target)->data;
@@ -104,10 +104,10 @@ static int NFLOG_parse(int c, char **argv, bool invert, unsigned int *flags,
 		info->threshold = n;
 		break;
 	default:
-		return 0;
+		return false;
 	}
 	*flags |= c;
-	return 1;
+	return true;
 }
 
 static void nflog_print(const struct xt_nflog_info *info, char *prefix)
diff --git a/extensions/libxt_NFQUEUE.c b/extensions/libxt_NFQUEUE.c
index 9dcdd42..323c7e2 100644
--- a/extensions/libxt_NFQUEUE.c
+++ b/extensions/libxt_NFQUEUE.c
@@ -41,7 +41,7 @@ parse_num(const char *s, struct xt_NFQ_info *tinfo)
     	tinfo->queuenum = num & 0xffff;
 }
 
-static int
+static bool
 NFQUEUE_parse(int c, char **argv, bool invert, unsigned int *flags,
               const void *entry, struct xt_entry_target **target)
 {
@@ -56,10 +56,10 @@ NFQUEUE_parse(int c, char **argv, bool invert, unsigned int *flags,
 		parse_num(optarg, tinfo);
 		break;
 	default:
-		return 0;
+		return false;
 	}
 
-	return 1;
+	return true;
 }
 
 static void NFQUEUE_print(const void *ip,
diff --git a/extensions/libxt_NOTRACK.c b/extensions/libxt_NOTRACK.c
index 0621d15..652d8d8 100644
--- a/extensions/libxt_NOTRACK.c
+++ b/extensions/libxt_NOTRACK.c
@@ -13,11 +13,11 @@ static void NOTRACK_help(void)
 	printf("NOTRACK target takes no options\n");
 }
 
-static int
+static bool
 NOTRACK_parse(int c, char **argv, bool invert, unsigned int *flags,
               const void *entry, struct xt_entry_target **target)
 {
-	return 0;
+	return false;
 }
 
 static struct xtables_target notrack_target = {
diff --git a/extensions/libxt_RATEEST.c b/extensions/libxt_RATEEST.c
index d5d391d..bd70852 100644
--- a/extensions/libxt_RATEEST.c
+++ b/extensions/libxt_RATEEST.c
@@ -41,7 +41,7 @@ static const struct option RATEEST_opts[] = {
 /* Copied from iproute */
 #define TIME_UNITS_PER_SEC	1000000
 
-static int
+static bool
 RATEEST_get_time(unsigned int *time, const char *str)
 {
 	double t;
@@ -49,7 +49,7 @@ RATEEST_get_time(unsigned int *time, const char *str)
 
 	t = strtod(str, &p);
 	if (p == str)
-		return -1;
+		return false;
 
 	if (*p) {
 		if (strcasecmp(p, "s") == 0 || strcasecmp(p, "sec")==0 ||
@@ -62,11 +62,11 @@ RATEEST_get_time(unsigned int *time, const char *str)
 			 strcasecmp(p, "usecs") == 0)
 			t *= TIME_UNITS_PER_SEC/1000000;
 		else
-			return -1;
+			return false;
 	}
 
 	*time = t;
-	return 0;
+	return true;
 }
 
 static void
@@ -89,7 +89,7 @@ RATEEST_init(struct xt_entry_target *target)
 	ewma_log = 0;
 }
 
-static int
+static bool
 RATEEST_parse(int c, char **argv, bool invert, unsigned int *flags,
 	      const void *entry, struct xt_entry_target **target)
 {
@@ -113,7 +113,7 @@ RATEEST_parse(int c, char **argv, bool invert, unsigned int *flags,
 				   "RATEEST: can't specify --rateest-interval twice");
 		*flags |= 1 << c;
 
-		if (RATEEST_get_time(&interval, optarg) < 0)
+		if (!RATEEST_get_time(&interval, optarg))
 			xtables_error(PARAMETER_PROBLEM,
 				   "RATEEST: bad interval value `%s'", optarg);
 
@@ -125,17 +125,17 @@ RATEEST_parse(int c, char **argv, bool invert, unsigned int *flags,
 				   "RATEEST: can't specify --rateest-ewmalog twice");
 		*flags |= 1 << c;
 
-		if (RATEEST_get_time(&ewma_log, optarg) < 0)
+		if (!RATEEST_get_time(&ewma_log, optarg))
 			xtables_error(PARAMETER_PROBLEM,
 				   "RATEEST: bad ewmalog value `%s'", optarg);
 
 		break;
 
 	default:
-		return 0;
+		return false;
 	}
 
-	return 1;
+	return true;
 }
 
 static void
diff --git a/extensions/libxt_SECMARK.c b/extensions/libxt_SECMARK.c
index 82752e8..36f9d7c 100644
--- a/extensions/libxt_SECMARK.c
+++ b/extensions/libxt_SECMARK.c
@@ -27,7 +27,7 @@ static const struct option SECMARK_opts[] = {
 	{ .name = NULL }
 };
 
-static int SECMARK_parse(int c, char **argv, bool invert, unsigned int *flags,
+static bool SECMARK_parse(int c, char **argv, bool invert, unsigned int *flags,
                          const void *entry, struct xt_entry_target **target)
 {
 	struct xt_secmark_target_info *info =
@@ -50,10 +50,10 @@ static int SECMARK_parse(int c, char **argv, bool invert, unsigned int *flags,
 		*flags |= SECMARK_MODE_SEL;
 		break;
 	default:
-		return 0;
+		return false;
 	}
 
-	return 1;
+	return true;
 }
 
 static void SECMARK_check(unsigned int flags)
diff --git a/extensions/libxt_TCPMSS.c b/extensions/libxt_TCPMSS.c
index 54ae373..d1c5cc0 100644
--- a/extensions/libxt_TCPMSS.c
+++ b/extensions/libxt_TCPMSS.c
@@ -42,9 +42,9 @@ static const struct option TCPMSS_opts[] = {
 	{ .name = NULL }
 };
 
-static int __TCPMSS_parse(int c, char **argv, bool invert, unsigned int *flags,
-                          const void *entry, struct xt_entry_target **target,
-                          int hdrsize)
+static bool
+__TCPMSS_parse(int c, char **argv, bool invert, unsigned int *flags,
+               const void *entry, struct xt_entry_target **target, int hdrsize)
 {
 	struct xt_tcpmss_info *mssinfo
 		= (struct xt_tcpmss_info *)(*target)->data;
@@ -73,19 +73,19 @@ static int __TCPMSS_parse(int c, char **argv, bool invert, unsigned int *flags,
 		break;
 
 	default:
-		return 0;
+		return false;
 	}
 
-	return 1;
+	return true;
 }
 
-static int TCPMSS_parse(int c, char **argv, bool invert, unsigned int *flags,
+static bool TCPMSS_parse(int c, char **argv, bool invert, unsigned int *flags,
                         const void *entry, struct xt_entry_target **target)
 {
 	return __TCPMSS_parse(c, argv, invert, flags, entry, target, 40);
 }
 
-static int TCPMSS_parse6(int c, char **argv, bool invert, unsigned int *flags,
+static bool TCPMSS_parse6(int c, char **argv, bool invert, unsigned int *flags,
                          const void *entry, struct xt_entry_target **target)
 {
 	return __TCPMSS_parse(c, argv, invert, flags, entry, target, 60);
diff --git a/extensions/libxt_TCPOPTSTRIP.c b/extensions/libxt_TCPOPTSTRIP.c
index 1c361e1..761a2f2 100644
--- a/extensions/libxt_TCPOPTSTRIP.c
+++ b/extensions/libxt_TCPOPTSTRIP.c
@@ -102,7 +102,7 @@ static void parse_list(struct xt_tcpoptstrip_target_info *info, char *arg)
 	}
 }
 
-static int tcpoptstrip_tg_parse(int c, char **argv, bool invert,
+static bool tcpoptstrip_tg_parse(int c, char **argv, bool invert,
                                 unsigned int *flags, const void *entry,
                                 struct xt_entry_target **target)
 {
diff --git a/extensions/libxt_TOS.c b/extensions/libxt_TOS.c
index a12e3fc..c380b0a 100644
--- a/extensions/libxt_TOS.c
+++ b/extensions/libxt_TOS.c
@@ -75,7 +75,7 @@ XTABLES_VERSION);
 );
 }
 
-static int
+static bool
 tos_tg_parse_v0(int c, char **argv, bool invert, unsigned int *flags,
                 const void *entry, struct xt_entry_target **target)
 {
@@ -100,7 +100,7 @@ tos_tg_parse_v0(int c, char **argv, bool invert, unsigned int *flags,
 	return false;
 }
 
-static int tos_tg_parse(int c, char **argv, bool invert, unsigned int *flags,
+static bool tos_tg_parse(int c, char **argv, bool invert, unsigned int *flags,
                          const void *entry, struct xt_entry_target **target)
 {
 	struct xt_tos_target_info *info = (void *)(*target)->data;
diff --git a/extensions/libxt_TPROXY.c b/extensions/libxt_TPROXY.c
index bf5b145..adab436 100644
--- a/extensions/libxt_TPROXY.c
+++ b/extensions/libxt_TPROXY.c
@@ -73,7 +73,7 @@ static void parse_tproxy_mark(char *s, struct xt_tproxy_target_info *info)
 	info->mark_value = value;
 }
 
-static int
+static bool
 tproxy_tg_parse(int c, char **argv, bool invert, unsigned int *flags,
                 const void *entry, struct xt_entry_target **target)
 {
@@ -85,22 +85,22 @@ tproxy_tg_parse(int c, char **argv, bool invert, unsigned int *flags,
 		xtables_param_act(XTF_NO_INVERT, "TPROXY", "--on-port", invert);
 		parse_tproxy_lport(optarg, tproxyinfo);
 		*flags |= PARAM_ONPORT;
-		return 1;
+		return true;
 	case '2':
 		xtables_param_act(XTF_ONLY_ONCE, "TPROXY", "--on-ip", *flags & PARAM_ONIP);
 		xtables_param_act(XTF_NO_INVERT, "TPROXY", "--on-ip", invert);
 		parse_tproxy_laddr(optarg, tproxyinfo);
 		*flags |= PARAM_ONIP;
-		return 1;
+		return true;
 	case '3':
 		xtables_param_act(XTF_ONLY_ONCE, "TPROXY", "--tproxy-mark", *flags & PARAM_MARK);
 		xtables_param_act(XTF_NO_INVERT, "TPROXY", "--tproxy-mark", invert);
 		parse_tproxy_mark(optarg, tproxyinfo);
 		*flags |= PARAM_MARK;
-		return 1;
+		return true;
 	}
 
-	return 0;
+	return false;
 }
 
 static void tproxy_tg_check(unsigned int flags)
diff --git a/extensions/libxt_TRACE.c b/extensions/libxt_TRACE.c
index 1361356..45e2252 100644
--- a/extensions/libxt_TRACE.c
+++ b/extensions/libxt_TRACE.c
@@ -13,10 +13,10 @@ static void TRACE_help(void)
 	printf("TRACE target takes no options\n");
 }
 
-static int TRACE_parse(int c, char **argv, bool invert, unsigned int *flags,
+static bool TRACE_parse(int c, char **argv, bool invert, unsigned int *flags,
                        const void *entry, struct xt_entry_target **target)
 {
-	return 0;
+	return false;
 }
 
 static struct xtables_target trace_target = {
diff --git a/extensions/libxt_comment.c b/extensions/libxt_comment.c
index ff38f64..79d1594 100644
--- a/extensions/libxt_comment.c
+++ b/extensions/libxt_comment.c
@@ -39,7 +39,7 @@ parse_comment(const char *s, struct xt_comment_info *info)
 	strcpy((char *)info->comment, s);
 }
 
-static int
+static bool
 comment_parse(int c, char **argv, bool invert, unsigned int *flags,
               const void *entry, struct xt_entry_match **match)
 {
@@ -57,9 +57,9 @@ comment_parse(int c, char **argv, bool invert, unsigned int *flags,
 		break;
 
 	default:
-		return 0;
+		return false;
 	}
-	return 1;
+	return true;
 }
 
 static void comment_check(unsigned int flags)
diff --git a/extensions/libxt_connbytes.c b/extensions/libxt_connbytes.c
index 4fdf21c..d465fc4 100644
--- a/extensions/libxt_connbytes.c
+++ b/extensions/libxt_connbytes.c
@@ -44,7 +44,7 @@ parse_range(const char *arg, struct xt_connbytes_info *si)
 			   (unsigned long long)si->count.to);
 }
 
-static int
+static bool
 connbytes_parse(int c, char **argv, bool invert, unsigned int *flags,
                 const void *entry, struct xt_entry_match **match)
 {
@@ -90,10 +90,10 @@ connbytes_parse(int c, char **argv, bool invert, unsigned int *flags,
 		*flags |= 4;
 		break;
 	default:
-		return 0;
+		return false;
 	}
 
-	return 1;
+	return true;
 }
 
 static void connbytes_check(unsigned int flags)
diff --git a/extensions/libxt_connlimit.c b/extensions/libxt_connlimit.c
index 15bd317..fe1394b 100644
--- a/extensions/libxt_connlimit.c
+++ b/extensions/libxt_connlimit.c
@@ -52,7 +52,7 @@ static void prefix_to_netmask(u_int32_t *mask, unsigned int prefix_len)
 	mask[3] = htonl(mask[3]);
 }
 
-static int
+static bool
 connlimit_parse(int c, char **argv, bool invert, unsigned int *flags,
                 struct xt_connlimit_info *info, unsigned int family)
 {
@@ -94,13 +94,13 @@ connlimit_parse(int c, char **argv, bool invert, unsigned int *flags,
 		}
 		break;
 	default:
-		return 0;
+		return false;
 	}
 
-	return 1;
+	return true;
 }
 
-static int connlimit_parse4(int c, char **argv, bool invert,
+static bool connlimit_parse4(int c, char **argv, bool invert,
                             unsigned int *flags, const void *entry,
                             struct xt_entry_match **match)
 {
@@ -108,7 +108,7 @@ static int connlimit_parse4(int c, char **argv, bool invert,
 	       (void *)(*match)->data, NFPROTO_IPV4);
 }
 
-static int connlimit_parse6(int c, char **argv, bool invert,
+static bool connlimit_parse6(int c, char **argv, bool invert,
                             unsigned int *flags, const void *entry,
                             struct xt_entry_match **match)
 {
diff --git a/extensions/libxt_connmark.c b/extensions/libxt_connmark.c
index 17fe03b..fa16e96 100644
--- a/extensions/libxt_connmark.c
+++ b/extensions/libxt_connmark.c
@@ -45,7 +45,7 @@ static const struct option connmark_mt_opts[] = {
 	{ .name = NULL }
 };
 
-static int
+static bool
 connmark_mt_parse(int c, char **argv, bool invert, unsigned int *flags,
                   const void *entry, struct xt_entry_match **match)
 {
@@ -74,7 +74,7 @@ connmark_mt_parse(int c, char **argv, bool invert, unsigned int *flags,
 	return false;
 }
 
-static int
+static bool
 connmark_parse(int c, char **argv, bool invert, unsigned int *flags,
                const void *entry, struct xt_entry_match **match)
 {
@@ -99,9 +99,9 @@ connmark_parse(int c, char **argv, bool invert, unsigned int *flags,
 		break;
 
 	default:
-		return 0;
+		return false;
 	}
-	return 1;
+	return true;
 }
 
 static void print_mark(unsigned int mark, unsigned int mask)
diff --git a/extensions/libxt_conntrack.c b/extensions/libxt_conntrack.c
index 2ed6e9a..4b6c3c5 100644
--- a/extensions/libxt_conntrack.c
+++ b/extensions/libxt_conntrack.c
@@ -74,7 +74,7 @@ static const struct option conntrack_mt_opts[] = {
 	{.name = NULL},
 };
 
-static int
+static bool
 parse_state(const char *state, size_t len, struct xt_conntrack_info *sinfo)
 {
 	if (strncasecmp(state, "INVALID", len) == 0)
@@ -92,8 +92,8 @@ parse_state(const char *state, size_t len, struct xt_conntrack_info *sinfo)
 	else if (strncasecmp(state, "DNAT", len) == 0)
 		sinfo->statemask |= XT_CONNTRACK_STATE_DNAT;
 	else
-		return 0;
-	return 1;
+		return false;
+	return true;
 }
 
 static void
@@ -153,7 +153,7 @@ conntrack_ps_states(struct xt_conntrack_mtinfo1 *info, const char *arg)
 		xtables_error(PARAMETER_PROBLEM, "Bad ctstate \"%s\"", arg);
 }
 
-static int
+static bool
 parse_status(const char *status, size_t len, struct xt_conntrack_info *sinfo)
 {
 	if (strncasecmp(status, "NONE", len) == 0)
@@ -169,8 +169,8 @@ parse_status(const char *status, size_t len, struct xt_conntrack_info *sinfo)
 		sinfo->statusmask |= IPS_CONFIRMED;
 #endif
 	else
-		return 0;
-	return 1;
+		return false;
+	return true;
 }
 
 static void
@@ -286,7 +286,7 @@ conntrack_ps_expires(struct xt_conntrack_mtinfo1 *info, const char *s)
 	info->expires_max = max;
 }
 
-static int
+static bool
 conntrack_parse(int c, char **argv, bool invert, unsigned int *flags,
                 const void *entry, struct xt_entry_match **match)
 {
@@ -430,11 +430,11 @@ conntrack_parse(int c, char **argv, bool invert, unsigned int *flags,
 		break;
 
 	default:
-		return 0;
+		return false;
 	}
 
 	*flags = sinfo->flags;
-	return 1;
+	return true;
 }
 
 static int
@@ -543,7 +543,7 @@ conntrack_mt_parse(int c, char **argv, bool invert, unsigned int *flags,
 	return true;
 }
 
-static int
+static bool
 conntrack_mt4_parse(int c, char **argv, bool invert, unsigned int *flags,
                     const void *entry, struct xt_entry_match **match)
 {
@@ -613,7 +613,7 @@ conntrack_mt4_parse(int c, char **argv, bool invert, unsigned int *flags,
 	return true;
 }
 
-static int
+static bool
 conntrack_mt6_parse(int c, char **argv, bool invert, unsigned int *flags,
                     const void *entry, struct xt_entry_match **match)
 {
diff --git a/extensions/libxt_dccp.c b/extensions/libxt_dccp.c
index 12180d4..e5e2edc 100644
--- a/extensions/libxt_dccp.c
+++ b/extensions/libxt_dccp.c
@@ -129,7 +129,7 @@ static u_int8_t parse_dccp_option(char *optstring)
 	return ret;
 }
 
-static int
+static bool
 dccp_parse(int c, char **argv, bool invert, unsigned int *flags,
            const void *entry, struct xt_entry_match **match)
 {
@@ -185,9 +185,9 @@ dccp_parse(int c, char **argv, bool invert, unsigned int *flags,
 		*flags |= XT_DCCP_OPTION;
 		break;
 	default:
-		return 0;
+		return false;
 	}
-	return 1;
+	return true;
 }
 
 static char *
diff --git a/extensions/libxt_dscp.c b/extensions/libxt_dscp.c
index 64ceedb..7dddd1f 100644
--- a/extensions/libxt_dscp.c
+++ b/extensions/libxt_dscp.c
@@ -71,7 +71,7 @@ parse_class(const char *s, struct xt_dscp_info *dinfo)
 }
 
 
-static int
+static bool
 dscp_parse(int c, char **argv, bool invert, unsigned int *flags,
            const void *entry, struct xt_entry_match **match)
 {
@@ -102,10 +102,10 @@ dscp_parse(int c, char **argv, bool invert, unsigned int *flags,
 		break;
 
 	default:
-		return 0;
+		return false;
 	}
 
-	return 1;
+	return true;
 }
 
 static void dscp_check(unsigned int flags)
diff --git a/extensions/libxt_esp.c b/extensions/libxt_esp.c
index 1cb906f..9a61070 100644
--- a/extensions/libxt_esp.c
+++ b/extensions/libxt_esp.c
@@ -78,7 +78,7 @@ static void esp_init(struct xt_entry_match *m)
 
 #define ESP_SPI 0x01
 
-static int
+static bool
 esp_parse(int c, char **argv, bool invert, unsigned int *flags,
           const void *entry, struct xt_entry_match **match)
 {
@@ -96,10 +96,10 @@ esp_parse(int c, char **argv, bool invert, unsigned int *flags,
 		*flags |= ESP_SPI;
 		break;
 	default:
-		return 0;
+		return false;
 	}
 
-	return 1;
+	return true;
 }
 
 static void
diff --git a/extensions/libxt_hashlimit.c b/extensions/libxt_hashlimit.c
index 4d7f74b..4fd844f 100644
--- a/extensions/libxt_hashlimit.c
+++ b/extensions/libxt_hashlimit.c
@@ -95,7 +95,7 @@ static const struct option hashlimit_mt_opts[] = {
 };
 
 static
-int parse_rate(const char *rate, u_int32_t *val)
+bool parse_rate(const char *rate, u_int32_t *val)
 {
 	const char *delim;
 	u_int32_t r;
@@ -104,7 +104,7 @@ int parse_rate(const char *rate, u_int32_t *val)
 	delim = strchr(rate, '/');
 	if (delim) {
 		if (strlen(delim+1) == 0)
-			return 0;
+			return false;
 
 		if (strncasecmp(delim+1, "second", strlen(delim+1)) == 0)
 			mult = 1;
@@ -115,11 +115,11 @@ int parse_rate(const char *rate, u_int32_t *val)
 		else if (strncasecmp(delim+1, "day", strlen(delim+1)) == 0)
 			mult = 24*60*60;
 		else
-			return 0;
+			return false;
 	}
 	r = atoi(rate);
 	if (!r)
-		return 0;
+		return false;
 
 	/* This would get mapped to infinite (1/day is minimum they
            can specify, so we're ok at that end). */
@@ -127,7 +127,7 @@ int parse_rate(const char *rate, u_int32_t *val)
 		xtables_error(PARAMETER_PROBLEM, "Rate too fast \"%s\"\n", rate);
 
 	*val = XT_HASHLIMIT_SCALE * mult / r;
-	return 1;
+	return true;
 }
 
 static void hashlimit_init(struct xt_entry_match *m)
@@ -166,13 +166,13 @@ static void hashlimit_mt6_init(struct xt_entry_match *match)
 }
 
 /* Parse a 'mode' parameter into the required bitmask */
-static int parse_mode(uint32_t *mode, char *option_arg)
+static bool parse_mode(uint32_t *mode, char *option_arg)
 {
 	char *tok;
 	char *arg = strdup(option_arg);
 
 	if (!arg)
-		return -1;
+		return false;
 
 	for (tok = strtok(arg, ",|");
 	     tok;
@@ -187,11 +187,11 @@ static int parse_mode(uint32_t *mode, char *option_arg)
 			*mode |= XT_HASHLIMIT_HASH_DPT;
 		else {
 			free(arg);
-			return -1;
+			return false;
 		}
 	}
 	free(arg);
-	return 0;
+	return true;
 }
 
 enum {
@@ -207,7 +207,7 @@ enum {
 	PARAM_DSTMASK    = 1 << 9,
 };
 
-static int
+static bool
 hashlimit_parse(int c, char **argv, bool invert, unsigned int *flags,
                 const void *entry, struct xt_entry_match **match)
 {
@@ -284,7 +284,7 @@ hashlimit_parse(int c, char **argv, bool invert, unsigned int *flags,
 		xtables_param_act(XTF_ONLY_ONCE, "hashlimit", "--hashlimit-mode",
 		          *flags & PARAM_MODE);
 		if (xtables_check_inverse(argv[optind-1], &invert, &optind, 0)) break;
-		if (parse_mode(&r->cfg.mode, optarg) < 0)
+		if (!parse_mode(&r->cfg.mode, optarg))
 			xtables_error(PARAMETER_PROBLEM,
 				   "bad --hashlimit-mode: `%s'\n", optarg);
 		*flags |= PARAM_MODE;
@@ -299,17 +299,17 @@ hashlimit_parse(int c, char **argv, bool invert, unsigned int *flags,
 		*flags |= PARAM_NAME;
 		break;
 	default:
-		return 0;
+		return false;
 	}
 
 	if (invert)
 		xtables_error(PARAMETER_PROBLEM,
 			   "hashlimit does not support invert");
 
-	return 1;
+	return true;
 }
 
-static int
+static bool
 hashlimit_mt_parse(struct xt_hashlimit_mtinfo1 *info, unsigned int *flags,
                    int c, bool invert, unsigned int maxmask)
 {
@@ -394,7 +394,7 @@ hashlimit_mt_parse(struct xt_hashlimit_mtinfo1 *info, unsigned int *flags,
 	case '_':
 		xtables_param_act(XTF_ONLY_ONCE, "hashlimit", "--hashlimit-mode",
 		          *flags & PARAM_MODE);
-		if (parse_mode(&info->cfg.mode, optarg) < 0)
+		if (!parse_mode(&info->cfg.mode, optarg))
 			xtables_param_act(XTF_BAD_VALUE, "hashlimit",
 			          "--hashlimit-mode", optarg);
 		*flags |= PARAM_MODE;
@@ -433,7 +433,7 @@ hashlimit_mt_parse(struct xt_hashlimit_mtinfo1 *info, unsigned int *flags,
 	return false;
 }
 
-static int
+static bool
 hashlimit_mt4_parse(int c, char **argv, bool invert, unsigned int *flags,
                     const void *entry, struct xt_entry_match **match)
 {
@@ -441,7 +441,7 @@ hashlimit_mt4_parse(int c, char **argv, bool invert, unsigned int *flags,
 	       flags, c, invert, 32);
 }
 
-static int
+static bool
 hashlimit_mt6_parse(int c, char **argv, bool invert, unsigned int *flags,
                     const void *entry, struct xt_entry_match **match)
 {
diff --git a/extensions/libxt_helper.c b/extensions/libxt_helper.c
index f29dd85..d5e5670 100644
--- a/extensions/libxt_helper.c
+++ b/extensions/libxt_helper.c
@@ -21,7 +21,7 @@ static const struct option helper_opts[] = {
 	{ .name = NULL }
 };
 
-static int
+static bool
 helper_parse(int c, char **argv, bool invert, unsigned int *flags,
              const void *entry, struct xt_entry_match **match)
 {
@@ -41,9 +41,9 @@ helper_parse(int c, char **argv, bool invert, unsigned int *flags,
 		break;
 
 	default:
-		return 0;
+		return false;
 	}
-	return 1;
+	return true;
 }
 
 static void helper_check(unsigned int flags)
diff --git a/extensions/libxt_iprange.c b/extensions/libxt_iprange.c
index 33c0cb1..b7d95c2 100644
--- a/extensions/libxt_iprange.c
+++ b/extensions/libxt_iprange.c
@@ -58,7 +58,7 @@ parse_iprange(char *arg, struct ipt_iprange *range)
 	}
 }
 
-static int iprange_parse(int c, char **argv, bool invert, unsigned int *flags,
+static bool iprange_parse(int c, char **argv, bool invert, unsigned int *flags,
                          const void *entry, struct xt_entry_match **match)
 {
 	struct ipt_iprange_info *info = (struct ipt_iprange_info *)(*match)->data;
@@ -94,12 +94,12 @@ static int iprange_parse(int c, char **argv, bool invert, unsigned int *flags,
 		break;
 
 	default:
-		return 0;
+		return false;
 	}
-	return 1;
+	return true;
 }
 
-static int
+static bool
 iprange_mt4_parse(int c, char **argv, bool invert, unsigned int *flags,
                   const void *entry, struct xt_entry_match **match)
 {
@@ -149,7 +149,7 @@ iprange_mt4_parse(int c, char **argv, bool invert, unsigned int *flags,
 	return false;
 }
 
-static int
+static bool
 iprange_mt6_parse(int c, char **argv, bool invert, unsigned int *flags,
                   const void *entry, struct xt_entry_match **match)
 {
diff --git a/extensions/libxt_length.c b/extensions/libxt_length.c
index 7ee0e65..d2231fd 100644
--- a/extensions/libxt_length.c
+++ b/extensions/libxt_length.c
@@ -59,7 +59,7 @@ parse_lengths(const char *s, struct xt_length_info *info)
 	
 }
 
-static int
+static bool
 length_parse(int c, char **argv, bool invert, unsigned int *flags,
              const void *entry, struct xt_entry_match **match)
 {
@@ -79,9 +79,9 @@ length_parse(int c, char **argv, bool invert, unsigned int *flags,
 			break;
 			
 		default:
-			return 0;
+			return false;
 	}
-	return 1;
+	return true;
 }
 
 static void length_check(unsigned int flags)
diff --git a/extensions/libxt_limit.c b/extensions/libxt_limit.c
index c96c39a..e408e3e 100644
--- a/extensions/libxt_limit.c
+++ b/extensions/libxt_limit.c
@@ -36,7 +36,7 @@ static const struct option limit_opts[] = {
 };
 
 static
-int parse_rate(const char *rate, u_int32_t *val)
+bool parse_rate(const char *rate, u_int32_t *val)
 {
 	const char *delim;
 	u_int32_t r;
@@ -45,7 +45,7 @@ int parse_rate(const char *rate, u_int32_t *val)
 	delim = strchr(rate, '/');
 	if (delim) {
 		if (strlen(delim+1) == 0)
-			return 0;
+			return false;
 
 		if (strncasecmp(delim+1, "second", strlen(delim+1)) == 0)
 			mult = 1;
@@ -56,11 +56,11 @@ int parse_rate(const char *rate, u_int32_t *val)
 		else if (strncasecmp(delim+1, "day", strlen(delim+1)) == 0)
 			mult = 24*60*60;
 		else
-			return 0;
+			return false;
 	}
 	r = atoi(rate);
 	if (!r)
-		return 0;
+		return false;
 
 	/* This would get mapped to infinite (1/day is minimum they
            can specify, so we're ok at that end). */
@@ -68,7 +68,7 @@ int parse_rate(const char *rate, u_int32_t *val)
 		xtables_error(PARAMETER_PROBLEM, "Rate too fast \"%s\"\n", rate);
 
 	*val = XT_LIMIT_SCALE * mult / r;
-	return 1;
+	return true;
 }
 
 static void limit_init(struct xt_entry_match *m)
@@ -86,7 +86,7 @@ static void limit_init(struct xt_entry_match *m)
 			   "Sorry: burst too large for that avg rate.\n");
 */
 
-static int
+static bool
 limit_parse(int c, char **argv, bool invert, unsigned int *flags,
             const void *entry, struct xt_entry_match **match)
 {
@@ -110,14 +110,14 @@ limit_parse(int c, char **argv, bool invert, unsigned int *flags,
 		break;
 
 	default:
-		return 0;
+		return false;
 	}
 
 	if (invert)
 		xtables_error(PARAMETER_PROBLEM,
 			   "limit does not support invert");
 
-	return 1;
+	return true;
 }
 
 static const struct rates
diff --git a/extensions/libxt_mac.c b/extensions/libxt_mac.c
index 27388af..afdb214 100644
--- a/extensions/libxt_mac.c
+++ b/extensions/libxt_mac.c
@@ -50,7 +50,7 @@ parse_mac(const char *mac, struct xt_mac_info *info)
 	}
 }
 
-static int
+static bool
 mac_parse(int c, char **argv, bool invert, unsigned int *flags,
           const void *entry, struct xt_entry_match **match)
 {
@@ -66,10 +66,10 @@ mac_parse(int c, char **argv, bool invert, unsigned int *flags,
 		break;
 
 	default:
-		return 0;
+		return false;
 	}
 
-	return 1;
+	return true;
 }
 
 static void print_mac(const unsigned char macaddress[ETH_ALEN])
diff --git a/extensions/libxt_mark.c b/extensions/libxt_mark.c
index 481e341..c6299ff 100644
--- a/extensions/libxt_mark.c
+++ b/extensions/libxt_mark.c
@@ -25,7 +25,7 @@ static const struct option mark_mt_opts[] = {
 	{ .name = NULL }
 };
 
-static int mark_mt_parse(int c, char **argv, bool invert, unsigned int *flags,
+static bool mark_mt_parse(int c, char **argv, bool invert, unsigned int *flags,
                          const void *entry, struct xt_entry_match **match)
 {
 	struct xt_mark_mtinfo1 *info = (void *)(*match)->data;
@@ -53,7 +53,7 @@ static int mark_mt_parse(int c, char **argv, bool invert, unsigned int *flags,
 	return false;
 }
 
-static int
+static bool
 mark_parse(int c, char **argv, bool invert, unsigned int *flags,
            const void *entry, struct xt_entry_match **match)
 {
@@ -76,9 +76,9 @@ mark_parse(int c, char **argv, bool invert, unsigned int *flags,
 		break;
 
 	default:
-		return 0;
+		return false;
 	}
-	return 1;
+	return true;
 }
 
 static void print_mark(unsigned int mark, unsigned int mask)
diff --git a/extensions/libxt_multiport.c b/extensions/libxt_multiport.c
index ce14d2f..4f01d97 100644
--- a/extensions/libxt_multiport.c
+++ b/extensions/libxt_multiport.c
@@ -154,7 +154,7 @@ check_proto(u_int16_t pnum, u_int8_t invflags)
 
 /* Function which parses command options; returns true if it
    ate an option */
-static int
+static bool
 __multiport_parse(int c, char **argv, bool invert, unsigned int *flags,
                   struct xt_entry_match **match, u_int16_t pnum,
                   u_int8_t invflags)
@@ -189,7 +189,7 @@ __multiport_parse(int c, char **argv, bool invert, unsigned int *flags,
 		break;
 
 	default:
-		return 0;
+		return false;
 	}
 
 	if (invert)
@@ -200,10 +200,10 @@ __multiport_parse(int c, char **argv, bool invert, unsigned int *flags,
 		xtables_error(PARAMETER_PROBLEM,
 			   "multiport can only have one option");
 	*flags = 1;
-	return 1;
+	return true;
 }
 
-static int
+static bool
 multiport_parse(int c, char **argv, bool invert, unsigned int *flags,
                 const void *e, struct xt_entry_match **match)
 {
@@ -212,7 +212,7 @@ multiport_parse(int c, char **argv, bool invert, unsigned int *flags,
 	       entry->ip.proto, entry->ip.invflags);
 }
 
-static int
+static bool
 multiport_parse6(int c, char **argv, bool invert, unsigned int *flags,
                  const void *e, struct xt_entry_match **match)
 {
@@ -221,7 +221,7 @@ multiport_parse6(int c, char **argv, bool invert, unsigned int *flags,
 	       entry->ipv6.proto, entry->ipv6.invflags);
 }
 
-static int
+static bool
 __multiport_parse_v1(int c, char **argv, bool invert, unsigned int *flags,
                      struct xt_entry_match **match, u_int16_t pnum,
                      u_int8_t invflags)
@@ -253,7 +253,7 @@ __multiport_parse_v1(int c, char **argv, bool invert, unsigned int *flags,
 		break;
 
 	default:
-		return 0;
+		return false;
 	}
 
 	if (invert)
@@ -263,10 +263,10 @@ __multiport_parse_v1(int c, char **argv, bool invert, unsigned int *flags,
 		xtables_error(PARAMETER_PROBLEM,
 			   "multiport can only have one option");
 	*flags = 1;
-	return 1;
+	return true;
 }
 
-static int
+static bool
 multiport_parse_v1(int c, char **argv, bool invert, unsigned int *flags,
                    const void *e, struct xt_entry_match **match)
 {
@@ -275,7 +275,7 @@ multiport_parse_v1(int c, char **argv, bool invert, unsigned int *flags,
 	       entry->ip.proto, entry->ip.invflags);
 }
 
-static int
+static bool
 multiport_parse6_v1(int c, char **argv, bool invert, unsigned int *flags,
                     const void *e, struct xt_entry_match **match)
 {
diff --git a/extensions/libxt_owner.c b/extensions/libxt_owner.c
index ba9b17f..1a4037c 100644
--- a/extensions/libxt_owner.c
+++ b/extensions/libxt_owner.c
@@ -101,7 +101,7 @@ static const struct option owner_mt_opts[] = {
 	{ .name = NULL }
 };
 
-static int
+static bool
 owner_mt_parse_v0(int c, char **argv, bool invert, unsigned int *flags,
                   const void *entry, struct xt_entry_match **match)
 {
@@ -180,7 +180,7 @@ owner_mt_parse_v0(int c, char **argv, bool invert, unsigned int *flags,
 	return false;
 }
 
-static int
+static bool
 owner_mt6_parse_v0(int c, char **argv, bool invert, unsigned int *flags,
                    const void *entry, struct xt_entry_match **match)
 {
@@ -261,8 +261,9 @@ static void owner_parse_range(const char *s, unsigned int *from,
 		xtables_param_act(XTF_BAD_VALUE, "owner", opt, s);
 }
 
-static int owner_mt_parse(int c, char **argv, bool invert, unsigned int *flags,
-                          const void *entry, struct xt_entry_match **match)
+static bool
+owner_mt_parse(int c, char **argv, bool invert, unsigned int *flags,
+               const void *entry, struct xt_entry_match **match)
 {
 	struct xt_owner_match_info *info = (void *)(*match)->data;
 	struct passwd *pwd;
diff --git a/extensions/libxt_physdev.c b/extensions/libxt_physdev.c
index e181633..1ce408c 100644
--- a/extensions/libxt_physdev.c
+++ b/extensions/libxt_physdev.c
@@ -33,7 +33,7 @@ static const struct option physdev_opts[] = {
 	{ .name = NULL }
 };
 
-static int
+static bool
 physdev_parse(int c, char **argv, bool invert, unsigned int *flags,
               const void *entry, struct xt_entry_match **match)
 {
@@ -96,10 +96,10 @@ physdev_parse(int c, char **argv, bool invert, unsigned int *flags,
 		break;
 
 	default:
-		return 0;
+		return false;
 	}
 
-	return 1;
+	return true;
 multiple_use:
 	xtables_error(PARAMETER_PROBLEM,
 	   "multiple use of the same physdev option is not allowed");
diff --git a/extensions/libxt_pkttype.c b/extensions/libxt_pkttype.c
index 9a7b53b..294c854 100644
--- a/extensions/libxt_pkttype.c
+++ b/extensions/libxt_pkttype.c
@@ -84,7 +84,7 @@ static void parse_pkttype(const char *pkttype, struct xt_pkttype_info *info)
 	xtables_error(PARAMETER_PROBLEM, "Bad packet type '%s'", pkttype);
 }
 
-static int pkttype_parse(int c, char **argv, bool invert, unsigned int *flags,
+static bool pkttype_parse(int c, char **argv, bool invert, unsigned int *flags,
                          const void *entry, struct xt_entry_match **match)
 {
 	struct xt_pkttype_info *info = (struct xt_pkttype_info *)(*match)->data;
@@ -100,10 +100,10 @@ static int pkttype_parse(int c, char **argv, bool invert, unsigned int *flags,
 			break;
 
 		default: 
-			return 0;
+			return false;
 	}
 
-	return 1;
+	return true;
 }
 
 static void pkttype_check(unsigned int flags)
diff --git a/extensions/libxt_quota.c b/extensions/libxt_quota.c
index 119e13d..6843841 100644
--- a/extensions/libxt_quota.c
+++ b/extensions/libxt_quota.c
@@ -38,7 +38,7 @@ quota_save(const void *ip, const struct xt_entry_match *match)
 }
 
 /* parse quota option */
-static int
+static bool
 parse_quota(const char *s, u_int64_t * quota)
 {
 	*quota = strtoull(s, NULL, 10);
@@ -50,10 +50,10 @@ parse_quota(const char *s, u_int64_t * quota)
 	if (*quota == UINT64_MAX)
 		xtables_error(PARAMETER_PROBLEM, "quota invalid: '%s'\n", s);
 	else
-		return 1;
+		return true;
 }
 
-static int
+static bool
 quota_parse(int c, char **argv, bool invert, unsigned int *flags,
 	    const void *entry, struct xt_entry_match **match)
 {
@@ -69,9 +69,9 @@ quota_parse(int c, char **argv, bool invert, unsigned int *flags,
 		break;
 
 	default:
-		return 0;
+		return false;
 	}
-	return 1;
+	return true;
 }
 
 static struct xtables_match quota_match = {
diff --git a/extensions/libxt_rateest.c b/extensions/libxt_rateest.c
index 22a934b..2c17326 100644
--- a/extensions/libxt_rateest.c
+++ b/extensions/libxt_rateest.c
@@ -83,7 +83,7 @@ static const struct rate_suffix {
 	{ .name = NULL }
 };
 
-static int
+static bool
 rateest_get_rate(u_int32_t *rate, const char *str)
 {
 	char *p;
@@ -91,24 +91,24 @@ rateest_get_rate(u_int32_t *rate, const char *str)
 	const struct rate_suffix *s;
 
 	if (p == str)
-		return -1;
+		return false;
 
 	if (*p == '\0') {
 		*rate = bps / 8.;	/* assume bytes/sec */
-		return 0;
+		return true;
 	}
 
 	for (s = suffixes; s->name; ++s) {
 		if (strcasecmp(s->name, p) == 0) {
 			*rate = (bps * s->scale) / 8.;
-			return 0;
+			return true;
 		}
 	}
 
-	return -1;
+	return false;
 }
 
-static int
+static bool
 rateest_parse(int c, char **argv, bool invert, unsigned int *flags,
 	      const void *entry, struct xt_entry_match **match)
 {
@@ -164,7 +164,7 @@ rateest_parse(int c, char **argv, bool invert, unsigned int *flags,
 		if (!argv[optind] || *argv[optind] == '-' || *argv[optind] == '!')
 			break;
 
-		if (rateest_get_rate(&info->bps1, argv[optind]) < 0)
+		if (!rateest_get_rate(&info->bps1, argv[optind]))
 			xtables_error(PARAMETER_PROBLEM,
 				   "rateest: could not parse rate `%s'",
 				   argv[optind]);
@@ -213,7 +213,7 @@ rateest_parse(int c, char **argv, bool invert, unsigned int *flags,
 		if (!argv[optind] || *argv[optind] == '-' || *argv[optind] == '!')
 			break;
 
-		if (rateest_get_rate(&info->bps2, argv[optind]) < 0)
+		if (!rateest_get_rate(&info->bps2, argv[optind]))
 			xtables_error(PARAMETER_PROBLEM,
 				   "rateest: could not parse rate `%s'",
 				   argv[optind]);
@@ -299,10 +299,10 @@ rateest_parse(int c, char **argv, bool invert, unsigned int *flags,
 		break;
 
 	default:
-		return 0;
+		return false;
 	}
 
-	return 1;
+	return true;
 }
 
 static void
diff --git a/extensions/libxt_recent.c b/extensions/libxt_recent.c
index 2d1f6d5..5a2631e 100644
--- a/extensions/libxt_recent.c
+++ b/extensions/libxt_recent.c
@@ -63,7 +63,7 @@ static void recent_init(struct xt_entry_match *match)
 	(XT_RECENT_SET | XT_RECENT_CHECK | \
 	XT_RECENT_UPDATE | XT_RECENT_REMOVE)
 
-static int recent_parse(int c, char **argv, bool invert, unsigned int *flags,
+static bool recent_parse(int c, char **argv, bool invert, unsigned int *flags,
                         const void *entry, struct xt_entry_match **match)
 {
 	struct xt_recent_mtinfo *info = (void *)(*match)->data;
@@ -144,10 +144,10 @@ static int recent_parse(int c, char **argv, bool invert, unsigned int *flags,
 			break;
 
 		default:
-			return 0;
+			return false;
 	}
 
-	return 1;
+	return true;
 }
 
 static void recent_check(unsigned int flags)
diff --git a/extensions/libxt_sctp.c b/extensions/libxt_sctp.c
index 928c33d..85b2bce 100644
--- a/extensions/libxt_sctp.c
+++ b/extensions/libxt_sctp.c
@@ -258,7 +258,7 @@ parse_sctp_chunks(struct xt_sctp_info *einfo,
 	parse_sctp_chunk(einfo, chunks);
 }
 
-static int
+static bool
 sctp_parse(int c, char **argv, bool invert, unsigned int *flags,
            const void *entry, struct xt_entry_match **match)
 {
@@ -310,9 +310,9 @@ sctp_parse(int c, char **argv, bool invert, unsigned int *flags,
 		break;
 
 	default:
-		return 0;
+		return false;
 	}
-	return 1;
+	return true;
 }
 
 static char *
diff --git a/extensions/libxt_socket.c b/extensions/libxt_socket.c
index ed191b5..211c8c4 100644
--- a/extensions/libxt_socket.c
+++ b/extensions/libxt_socket.c
@@ -13,11 +13,11 @@ static void socket_mt_help(void)
 	printf("socket v%s has no options\n\n", XTABLES_VERSION);
 }
 
-static int
+static bool
 socket_mt_parse(int c, char **argv, bool invert, unsigned int *flags,
                 const void *entry, struct xt_entry_match **match)
 {
-	return 0;
+	return false;
 }
 
 static void socket_mt_check(unsigned int flags)
diff --git a/extensions/libxt_standard.c b/extensions/libxt_standard.c
index 3a0d8c8..5029c01 100644
--- a/extensions/libxt_standard.c
+++ b/extensions/libxt_standard.c
@@ -15,10 +15,11 @@ static void standard_help(void)
 "(If target is DROP, ACCEPT, RETURN or nothing)\n");
 }
 
-static int standard_parse(int c, char **argv, bool invert, unsigned int *flags,
-                          const void *entry, struct xt_entry_target **target)
+static bool
+standard_parse(int c, char **argv, bool invert, unsigned int *flags,
+               const void *entry, struct xt_entry_target **target)
 {
-	return 0;
+	return false;
 }
 
 static struct xtables_target standard_target = {
diff --git a/extensions/libxt_state.c b/extensions/libxt_state.c
index b5f0593..97afe45 100644
--- a/extensions/libxt_state.c
+++ b/extensions/libxt_state.c
@@ -27,7 +27,7 @@ static const struct option state_opts[] = {
 	{ .name = NULL }
 };
 
-static int
+static bool
 state_parse_state(const char *state, size_t len, struct xt_state_info *sinfo)
 {
 	if (strncasecmp(state, "INVALID", len) == 0)
@@ -41,8 +41,8 @@ state_parse_state(const char *state, size_t len, struct xt_state_info *sinfo)
 	else if (strncasecmp(state, "UNTRACKED", len) == 0)
 		sinfo->statemask |= XT_STATE_UNTRACKED;
 	else
-		return 0;
-	return 1;
+		return false;
+	return true;
 }
 
 static void
@@ -63,7 +63,7 @@ state_parse_states(const char *arg, struct xt_state_info *sinfo)
 		xtables_error(PARAMETER_PROBLEM, "Bad state \"%s\"", arg);
 }
 
-static int
+static bool
 state_parse(int c, char **argv, bool invert, unsigned int *flags,
       const void *entry,
       struct xt_entry_match **match)
@@ -81,10 +81,10 @@ state_parse(int c, char **argv, bool invert, unsigned int *flags,
 		break;
 
 	default:
-		return 0;
+		return false;
 	}
 
-	return 1;
+	return true;
 }
 
 static void state_final_check(unsigned int flags)
diff --git a/extensions/libxt_statistic.c b/extensions/libxt_statistic.c
index ca65782..139f878 100644
--- a/extensions/libxt_statistic.c
+++ b/extensions/libxt_statistic.c
@@ -36,7 +36,7 @@ static void statistic_mt_init(struct xt_entry_match *match)
 	global_info = (void *)match->data;
 }
 
-static int
+static bool
 statistic_parse(int c, char **argv, bool invert, unsigned int *flags,
                 const void *entry, struct xt_entry_match **match)
 {
@@ -91,9 +91,9 @@ statistic_parse(int c, char **argv, bool invert, unsigned int *flags,
 		*flags |= 0x8;
 		break;
 	default:
-		return 0;
+		return false;
 	}
-	return 1;
+	return true;
 }
 
 static void statistic_check(unsigned int flags)
diff --git a/extensions/libxt_string.c b/extensions/libxt_string.c
index fc17d6c..a718850 100644
--- a/extensions/libxt_string.c
+++ b/extensions/libxt_string.c
@@ -169,7 +169,7 @@ parse_hex_string(const char *s, struct xt_string_info *info)
 #define TO     0x8
 #define ICASE  0x10
 
-static int
+static bool
 string_parse(int c, char **argv, bool invert, unsigned int *flags,
              const void *entry, struct xt_entry_match **match)
 {
@@ -240,9 +240,9 @@ string_parse(int c, char **argv, bool invert, unsigned int *flags,
 		break;
 
 	default:
-		return 0;
+		return false;
 	}
-	return 1;
+	return true;
 }
 
 static void string_check(unsigned int flags)
@@ -257,17 +257,17 @@ static void string_check(unsigned int flags)
 }
 
 /* Test to see if the string contains non-printable chars or quotes */
-static unsigned short int
+static bool
 is_hex_string(const char *str, const unsigned short int len)
 {
 	unsigned int i;
 	for (i=0; i < len; i++)
 		if (! isprint(str[i]))
-			return 1;  /* string contains at least one non-printable char */
+			return true;  /* string contains at least one non-printable char */
 	/* use hex output if the last char is a "\" */
 	if ((unsigned char) str[len-1] == 0x5c)
-		return 1;
-	return 0;
+		return true;
+	return false;
 }
 
 /* Print string with "|" chars included as one would pass to --hex-string */
diff --git a/extensions/libxt_tcp.c b/extensions/libxt_tcp.c
index cbf813a..e98ab76 100644
--- a/extensions/libxt_tcp.c
+++ b/extensions/libxt_tcp.c
@@ -140,7 +140,7 @@ static void tcp_init(struct xt_entry_match *m)
 #define TCP_FLAGS 0x04
 #define TCP_OPTION	0x08
 
-static int
+static bool
 tcp_parse(int c, char **argv, bool invert, unsigned int *flags,
           const void *entry, struct xt_entry_match **match)
 {
@@ -208,10 +208,10 @@ tcp_parse(int c, char **argv, bool invert, unsigned int *flags,
 		break;
 
 	default:
-		return 0;
+		return false;
 	}
 
-	return 1;
+	return true;
 }
 
 static char *
diff --git a/extensions/libxt_tcpmss.c b/extensions/libxt_tcpmss.c
index d3e8b21..9488095 100644
--- a/extensions/libxt_tcpmss.c
+++ b/extensions/libxt_tcpmss.c
@@ -54,7 +54,7 @@ parse_tcp_mssvalues(const char *mssvaluestring,
 	free(buffer);
 }
 
-static int
+static bool
 tcpmss_parse(int c, char **argv, bool invert, unsigned int *flags,
              const void *entry, struct xt_entry_match **match)
 {
@@ -74,9 +74,9 @@ tcpmss_parse(int c, char **argv, bool invert, unsigned int *flags,
 		*flags = 1;
 		break;
 	default:
-		return 0;
+		return false;
 	}
-	return 1;
+	return true;
 }
 
 static void tcpmss_check(unsigned int flags)
diff --git a/extensions/libxt_time.c b/extensions/libxt_time.c
index 2542fbf..f2db56f 100644
--- a/extensions/libxt_time.c
+++ b/extensions/libxt_time.c
@@ -246,7 +246,7 @@ static unsigned int time_parse_weekdays(const char *arg)
 	return ret;
 }
 
-static int time_parse(int c, char **argv, bool invert, unsigned int *flags,
+static bool time_parse(int c, char **argv, bool invert, unsigned int *flags,
                       const void *entry, struct xt_entry_match **match)
 {
 	struct xt_time_info *info = (void *)(*match)->data;
@@ -261,7 +261,7 @@ static int time_parse(int c, char **argv, bool invert, unsigned int *flags,
 			           "Unexpected \"!\" with --datestart");
 		info->date_start = time_parse_date(optarg, false);
 		*flags |= F_DATE_START;
-		return 1;
+		return true;
 	case 'E': /* --datestop */
 		if (*flags & F_DATE_STOP)
 			xtables_error(PARAMETER_PROBLEM,
@@ -271,7 +271,7 @@ static int time_parse(int c, char **argv, bool invert, unsigned int *flags,
 			           "unexpected \"!\" with --datestop");
 		info->date_stop = time_parse_date(optarg, true);
 		*flags |= F_DATE_STOP;
-		return 1;
+		return true;
 	case 'X': /* --timestart */
 		if (*flags & F_TIME_START)
 			xtables_error(PARAMETER_PROBLEM,
@@ -281,7 +281,7 @@ static int time_parse(int c, char **argv, bool invert, unsigned int *flags,
 			           "Unexpected \"!\" with --timestart");
 		info->daytime_start = time_parse_minutes(optarg);
 		*flags |= F_TIME_START;
-		return 1;
+		return true;
 	case 'Y': /* --timestop */
 		if (*flags & F_TIME_STOP)
 			xtables_error(PARAMETER_PROBLEM,
@@ -291,14 +291,14 @@ static int time_parse(int c, char **argv, bool invert, unsigned int *flags,
 			           "Unexpected \"!\" with --timestop");
 		info->daytime_stop = time_parse_minutes(optarg);
 		*flags |= F_TIME_STOP;
-		return 1;
+		return true;
 	case 'l': /* --localtz */
 		if (*flags & F_TIMEZONE)
 			xtables_error(PARAMETER_PROBLEM,
 			           "Can only specify exactly one of --localtz or --utc");
 		info->flags |= XT_TIME_LOCAL_TZ;
 		*flags |= F_TIMEZONE;
-		return 1;
+		return true;
 	case 'm': /* --monthdays */
 		if (*flags & F_MONTHDAYS)
 			xtables_error(PARAMETER_PROBLEM,
@@ -307,7 +307,7 @@ static int time_parse(int c, char **argv, bool invert, unsigned int *flags,
 		if (invert)
 			info->monthdays_match ^= XT_TIME_ALL_MONTHDAYS;
 		*flags |= F_MONTHDAYS;
-		return 1;
+		return true;
 	case 'w': /* --weekdays */
 		if (*flags & F_WEEKDAYS)
 			xtables_error(PARAMETER_PROBLEM,
@@ -316,16 +316,16 @@ static int time_parse(int c, char **argv, bool invert, unsigned int *flags,
 		if (invert)
 			info->weekdays_match ^= XT_TIME_ALL_WEEKDAYS;
 		*flags |= F_WEEKDAYS;
-		return 1;
+		return true;
 	case 'u': /* --utc */
 		if (*flags & F_TIMEZONE)
 			xtables_error(PARAMETER_PROBLEM,
 			           "Can only specify exactly one of --localtz or --utc");
 		info->flags &= ~XT_TIME_LOCAL_TZ;
 		*flags |= F_TIMEZONE;
-		return 1;
+		return true;
 	}
-	return 0;
+	return false;
 }
 
 static void time_print_date(time_t date, const char *command)
diff --git a/extensions/libxt_tos.c b/extensions/libxt_tos.c
index 90113ee..6ea20a4 100644
--- a/extensions/libxt_tos.c
+++ b/extensions/libxt_tos.c
@@ -42,7 +42,7 @@ static void tos_mt_help(void)
 	printf("\n");
 }
 
-static int
+static bool
 tos_mt_parse_v0(int c, char **argv, bool invert, unsigned int *flags,
                 const void *entry, struct xt_entry_match **match)
 {
@@ -67,7 +67,7 @@ tos_mt_parse_v0(int c, char **argv, bool invert, unsigned int *flags,
 	return false;
 }
 
-static int tos_mt_parse(int c, char **argv, bool invert, unsigned int *flags,
+static bool tos_mt_parse(int c, char **argv, bool invert, unsigned int *flags,
                         const void *entry, struct xt_entry_match **match)
 {
 	struct xt_tos_match_info *info = (void *)(*match)->data;
diff --git a/extensions/libxt_u32.c b/extensions/libxt_u32.c
index 203e646..6195d96 100644
--- a/extensions/libxt_u32.c
+++ b/extensions/libxt_u32.c
@@ -102,7 +102,7 @@ static u_int32_t parse_number(char **s, int pos)
 	return number;
 }
 
-static int u32_parse(int c, char **argv, bool invert, unsigned int *flags,
+static bool u32_parse(int c, char **argv, bool invert, unsigned int *flags,
 		     const void *entry, struct xt_entry_match **match)
 {
 	struct xt_u32 *data = (void *)(*match)->data;
@@ -113,7 +113,7 @@ static int u32_parse(int c, char **argv, bool invert, unsigned int *flags,
 	int state = 0;
 
 	if (c != 'u')
-		return 0;
+		return false;
 
 	data->invert = invert;
 
@@ -122,7 +122,7 @@ static int u32_parse(int c, char **argv, bool invert, unsigned int *flags,
 	 * 0 = looking for numbers and operations,
 	 * 1 = looking for ranges
 	 */
-	while (1) {
+	while (true) {
 		/* read next operand/number or range */
 		while (isspace(*arg))
 			++arg;
@@ -144,7 +144,7 @@ static int u32_parse(int c, char **argv, bool invert, unsigned int *flags,
 				xtables_error(PARAMETER_PROBLEM,
 				           "u32: at char %u: too many \"&&\"s",
 				           (unsigned int)(arg - start));
-			return 1;
+			return true;
 		}
 
 		if (state == 0) {
diff --git a/extensions/libxt_udp.c b/extensions/libxt_udp.c
index 0c5c3df..cc21062 100644
--- a/extensions/libxt_udp.c
+++ b/extensions/libxt_udp.c
@@ -62,7 +62,7 @@ static void udp_init(struct xt_entry_match *m)
 #define UDP_SRC_PORTS 0x01
 #define UDP_DST_PORTS 0x02
 
-static int
+static bool
 udp_parse(int c, char **argv, bool invert, unsigned int *flags,
           const void *entry, struct xt_entry_match **match)
 {
@@ -92,10 +92,10 @@ udp_parse(int c, char **argv, bool invert, unsigned int *flags,
 		break;
 
 	default:
-		return 0;
+		return false;
 	}
 
-	return 1;
+	return true;
 }
 
 static char *
diff --git a/include/xtables.h.in b/include/xtables.h.in
index 97f4eea..23103cd 100644
--- a/include/xtables.h.in
+++ b/include/xtables.h.in
@@ -67,7 +67,7 @@ struct xtables_match
 	/* Function which parses command options; returns true if it
            ate an option */
 	/* entry is struct ipt_entry for example */
-	int (*parse)(int c, char **argv, bool invert, unsigned int *flags,
+	bool (*parse)(int c, char **argv, bool invert, unsigned int *flags,
 		     const void *entry,
 		     struct xt_entry_match **match);
 
@@ -129,7 +129,7 @@ struct xtables_target
 	/* Function which parses command options; returns true if it
            ate an option */
 	/* entry is struct ipt_entry for example */
-	int (*parse)(int c, char **argv, bool invert, unsigned int *flags,
+	bool (*parse)(int c, char **argv, bool invert, unsigned int *flags,
 		     const void *entry,
 		     struct xt_entry_target **targetinfo);
 
diff --git a/ip6tables.c b/ip6tables.c
index 9f70264..6a164d9 100644
--- a/ip6tables.c
+++ b/ip6tables.c
@@ -1702,10 +1702,10 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 
 		default:
 			if (!target
-			    || !(target->parse(c - target->option_offset,
+			    || !target->parse(c - target->option_offset,
 					       argv, invert,
 					       &target->tflags,
-					       &fw, &target->t))) {
+					       &fw, &target->t)) {
 				for (matchp = matches; matchp; matchp = matchp->next) {
 					if (matchp->completed)
 						continue;
diff --git a/iptables.c b/iptables.c
index 27fa084..ba8c3bb 100644
--- a/iptables.c
+++ b/iptables.c
@@ -1729,10 +1729,10 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 
 		default:
 			if (!target
-			    || !(target->parse(c - target->option_offset,
+			    || !target->parse(c - target->option_offset,
 					       argv, invert,
 					       &target->tflags,
-					       &fw, &target->t))) {
+					       &fw, &target->t)) {
 				for (matchp = matches; matchp; matchp = matchp->next) {
 					if (matchp->completed)
 						continue;
-- 
1.6.2.2

