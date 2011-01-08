From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 09/13] extensions: remove no longer necessary default: cases
Date: Sat,  8 Jan 2011 16:20:10 +0100
Message-ID: <1294500015-10691-10-git-send-email-jengelh@medozas.de>
References: <1294500015-10691-1-git-send-email-jengelh@medozas.de>
Cc: kaber@trash.net, netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:32903 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752824Ab1AHPU0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 8 Jan 2011 10:20:26 -0500
In-Reply-To: <1294500015-10691-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Match and target parse functions now only get option characters they
have defined themselves.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libip6t_HL.c         |    4 ----
 extensions/libip6t_LOG.c        |    3 ---
 extensions/libip6t_REJECT.c     |    3 ---
 extensions/libip6t_ah.c         |    2 --
 extensions/libip6t_dst.c        |    2 --
 extensions/libip6t_frag.c       |    2 --
 extensions/libip6t_hbh.c        |    2 --
 extensions/libip6t_hl.c         |    2 --
 extensions/libip6t_icmp6.c      |    3 ---
 extensions/libip6t_ipv6header.c |    2 --
 extensions/libip6t_mh.c         |    3 ---
 extensions/libip6t_rt.c         |    2 --
 extensions/libipt_CLUSTERIP.c   |    2 --
 extensions/libipt_DNAT.c        |    4 +---
 extensions/libipt_ECN.c         |    2 --
 extensions/libipt_LOG.c         |    2 --
 extensions/libipt_MASQUERADE.c  |    4 +---
 extensions/libipt_NETMAP.c      |    4 +---
 extensions/libipt_REDIRECT.c    |    4 +---
 extensions/libipt_REJECT.c      |    2 --
 extensions/libipt_SAME.c        |    3 ---
 extensions/libipt_SNAT.c        |    4 +---
 extensions/libipt_TTL.c         |    4 ----
 extensions/libipt_ULOG.c        |    2 --
 extensions/libipt_addrtype.c    |    4 ----
 extensions/libipt_ah.c          |    2 --
 extensions/libipt_ecn.c         |    2 --
 extensions/libipt_icmp.c        |    3 ---
 extensions/libipt_realm.c       |    3 ---
 extensions/libipt_ttl.c         |    3 ---
 extensions/libxt_CHECKSUM.c     |    2 --
 extensions/libxt_CLASSIFY.c     |    3 ---
 extensions/libxt_CONNMARK.c     |    2 --
 extensions/libxt_CONNSECMARK.c  |    3 ---
 extensions/libxt_CT.c           |    2 --
 extensions/libxt_DSCP.c         |    3 ---
 extensions/libxt_IDLETIMER.c    |    3 ---
 extensions/libxt_MARK.c         |    7 -------
 extensions/libxt_NFLOG.c        |    2 --
 extensions/libxt_NFQUEUE.c      |    4 ----
 extensions/libxt_RATEEST.c      |    3 ---
 extensions/libxt_SECMARK.c      |    2 --
 extensions/libxt_SET.c          |    6 ------
 extensions/libxt_TCPMSS.c       |    3 ---
 extensions/libxt_TOS.c          |    3 ---
 extensions/libxt_cluster.c      |    2 --
 extensions/libxt_comment.c      |    3 ---
 extensions/libxt_connbytes.c    |    2 --
 extensions/libxt_connlimit.c    |    2 --
 extensions/libxt_connmark.c     |    3 ---
 extensions/libxt_conntrack.c    |    6 ------
 extensions/libxt_cpu.c          |    3 ---
 extensions/libxt_dccp.c         |    2 --
 extensions/libxt_dscp.c         |    3 ---
 extensions/libxt_esp.c          |    2 --
 extensions/libxt_hashlimit.c    |    2 --
 extensions/libxt_helper.c       |    3 ---
 extensions/libxt_iprange.c      |    3 ---
 extensions/libxt_ipvs.c         |    5 -----
 extensions/libxt_length.c       |    3 ---
 extensions/libxt_limit.c        |    3 ---
 extensions/libxt_mac.c          |    3 ---
 extensions/libxt_mark.c         |    3 ---
 extensions/libxt_multiport.c    |    6 ------
 extensions/libxt_osf.c          |    2 --
 extensions/libxt_physdev.c      |    3 ---
 extensions/libxt_pkttype.c      |    3 ---
 extensions/libxt_policy.c       |    2 --
 extensions/libxt_quota.c        |    3 ---
 extensions/libxt_rateest.c      |    3 ---
 extensions/libxt_recent.c       |    3 ---
 extensions/libxt_sctp.c         |    3 ---
 extensions/libxt_set.c          |    6 ------
 extensions/libxt_state.c        |    3 ---
 extensions/libxt_statistic.c    |    2 --
 extensions/libxt_string.c       |    3 ---
 extensions/libxt_tcp.c          |    3 ---
 extensions/libxt_tcpmss.c       |    2 --
 extensions/libxt_udp.c          |    3 ---
 79 files changed, 5 insertions(+), 230 deletions(-)

diff --git a/extensions/libip6t_HL.c b/extensions/libip6t_HL.c
index eeab0c9..7430454 100644
--- a/extensions/libip6t_HL.c
+++ b/extensions/libip6t_HL.c
@@ -71,10 +71,6 @@ static int HL_parse(int c, char **argv, int invert, unsigned int *flags,
 
 			info->mode = IP6T_HL_INC;
 			break;
-
-		default:
-			return 0;
-
 	}
 	
 	info->hop_limit = value;
diff --git a/extensions/libip6t_LOG.c b/extensions/libip6t_LOG.c
index bb85acb..a33d570 100644
--- a/extensions/libip6t_LOG.c
+++ b/extensions/libip6t_LOG.c
@@ -191,9 +191,6 @@ static int LOG_parse(int c, char **argv, int invert, unsigned int *flags,
 		loginfo->logflags |= IP6T_LOG_MACDECODE;
 		*flags |= IP6T_LOG_OPT_MACDECODE;
 		break;
-
-	default:
-		return 0;
 	}
 
 	return 1;
diff --git a/extensions/libip6t_REJECT.c b/extensions/libip6t_REJECT.c
index 94d2694..9a4334f 100644
--- a/extensions/libip6t_REJECT.c
+++ b/extensions/libip6t_REJECT.c
@@ -94,9 +94,6 @@ static int REJECT_parse(int c, char **argv, int invert, unsigned int *flags,
 				return 1;
 			}
 		xtables_error(PARAMETER_PROBLEM, "unknown reject type \"%s\"", optarg);
-	default:
-		/* Fall through */
-		break;
 	}
 	return 0;
 }
diff --git a/extensions/libip6t_ah.c b/extensions/libip6t_ah.c
index fc17429..839f14d 100644
--- a/extensions/libip6t_ah.c
+++ b/extensions/libip6t_ah.c
@@ -110,8 +110,6 @@ static int ah_parse(int c, char **argv, int invert, unsigned int *flags,
 		ahinfo->hdrres = 1;
 		*flags |= IP6T_AH_RES;
 		break;
-	default:
-		return 0;
 	}
 
 	return 1;
diff --git a/extensions/libip6t_dst.c b/extensions/libip6t_dst.c
index f4036f0..e4cf431 100644
--- a/extensions/libip6t_dst.c
+++ b/extensions/libip6t_dst.c
@@ -156,8 +156,6 @@ static int dst_parse(int c, char **argv, int invert, unsigned int *flags,
 		optinfo->flags |= IP6T_OPTS_NSTRICT;
 		*flags |= IP6T_OPTS_NSTRICT;
 		break;
-	default:
-		return 0;
 	}
 
 	return 1;
diff --git a/extensions/libip6t_frag.c b/extensions/libip6t_frag.c
index fcaa72b..c342dd8 100644
--- a/extensions/libip6t_frag.c
+++ b/extensions/libip6t_frag.c
@@ -141,8 +141,6 @@ static int frag_parse(int c, char **argv, int invert, unsigned int *flags,
 		fraginfo->flags |= IP6T_FRAG_NMF;
 		*flags |= IP6T_FRAG_NMF;
 		break;
-	default:
-		return 0;
 	}
 
 	return 1;
diff --git a/extensions/libip6t_hbh.c b/extensions/libip6t_hbh.c
index b706f51..f9d59df 100644
--- a/extensions/libip6t_hbh.c
+++ b/extensions/libip6t_hbh.c
@@ -149,8 +149,6 @@ static int hbh_parse(int c, char **argv, int invert, unsigned int *flags,
 		optinfo->flags |= IP6T_OPTS_NSTRICT;
 		*flags |= IP6T_OPTS_NSTRICT;
 		break;
-	default:
-		return 0;
 	}
 
 	return 1;
diff --git a/extensions/libip6t_hl.c b/extensions/libip6t_hl.c
index ce4392e..daefea1 100644
--- a/extensions/libip6t_hl.c
+++ b/extensions/libip6t_hl.c
@@ -71,8 +71,6 @@ static int hl_parse(int c, char **argv, int invert, unsigned int *flags,
 			*flags = 1;
 
 			break;
-		default:
-			return 0;
 	}
 
 	return 1;
diff --git a/extensions/libip6t_icmp6.c b/extensions/libip6t_icmp6.c
index 2adba82..8c39488 100644
--- a/extensions/libip6t_icmp6.c
+++ b/extensions/libip6t_icmp6.c
@@ -166,9 +166,6 @@ static int icmp6_parse(int c, char **argv, int invert, unsigned int *flags,
 			icmpv6info->invflags |= IP6T_ICMP_INV;
 		*flags = 1;
 		break;
-
-	default:
-		return 0;
 	}
 
 	return 1;
diff --git a/extensions/libip6t_ipv6header.c b/extensions/libip6t_ipv6header.c
index d4d64e0..7d2a97f 100644
--- a/extensions/libip6t_ipv6header.c
+++ b/extensions/libip6t_ipv6header.c
@@ -204,8 +204,6 @@ ipv6header_parse(int c, char **argv, int invert, unsigned int *flags,
 			info->modeflag |= 0xFF;
 			*flags |= IPV6_HDR_SOFT;
 			break;
-		default:
-			return 0;
 	}
 
 	return 1;
diff --git a/extensions/libip6t_mh.c b/extensions/libip6t_mh.c
index 16cc9ac..f41c4f4 100644
--- a/extensions/libip6t_mh.c
+++ b/extensions/libip6t_mh.c
@@ -140,9 +140,6 @@ static int mh_parse(int c, char **argv, int invert, unsigned int *flags,
 			mhinfo->invflags |= IP6T_MH_INV_TYPE;
 		*flags |= MH_TYPES;
 		break;
-
-	default:
-		return 0;
 	}
 
 	return 1;
diff --git a/extensions/libip6t_rt.c b/extensions/libip6t_rt.c
index ec0290c..4e27f8a 100644
--- a/extensions/libip6t_rt.c
+++ b/extensions/libip6t_rt.c
@@ -223,8 +223,6 @@ static int rt_parse(int c, char **argv, int invert, unsigned int *flags,
 		rtinfo->flags |= IP6T_RT_FST_NSTRICT;
 		*flags |= IP6T_RT_FST_NSTRICT;
 		break;
-	default:
-		return 0;
 	}
 
 	return 1;
diff --git a/extensions/libipt_CLUSTERIP.c b/extensions/libipt_CLUSTERIP.c
index d622e63..b89baa8 100644
--- a/extensions/libipt_CLUSTERIP.c
+++ b/extensions/libipt_CLUSTERIP.c
@@ -146,8 +146,6 @@ static int CLUSTERIP_parse(int c, char **argv, int invert, unsigned int *flags,
 		cipinfo->hash_initval = num;
 		*flags |= PARAM_HASHINIT;
 		break;
-	default:
-		return 0;
 	}
 
 	return 1;
diff --git a/extensions/libipt_DNAT.c b/extensions/libipt_DNAT.c
index 7afe241..32b94b2 100644
--- a/extensions/libipt_DNAT.c
+++ b/extensions/libipt_DNAT.c
@@ -184,10 +184,8 @@ static int DNAT_parse(int c, char **argv, int invert, unsigned int *flags,
 	case '3':
 		info->mr.range[0].flags |= IP_NAT_RANGE_PERSISTENT;
 		return 1;
-
-	default:
-		return 0;
 	}
+	return 0;
 }
 
 static void DNAT_check(unsigned int flags)
diff --git a/extensions/libipt_ECN.c b/extensions/libipt_ECN.c
index 75ea011..cad20a8 100644
--- a/extensions/libipt_ECN.c
+++ b/extensions/libipt_ECN.c
@@ -90,8 +90,6 @@ static int ECN_parse(int c, char **argv, int invert, unsigned int *flags,
 		einfo->ip_ect = result;
 		*flags |= IPT_ECN_OP_SET_IP;
 		break;
-	default:
-		return 0;
 	}
 
 	return 1;
diff --git a/extensions/libipt_LOG.c b/extensions/libipt_LOG.c
index 097aec8..e6ccb3b 100644
--- a/extensions/libipt_LOG.c
+++ b/extensions/libipt_LOG.c
@@ -191,8 +191,6 @@ static int LOG_parse(int c, char **argv, int invert, unsigned int *flags,
 		loginfo->logflags |= IPT_LOG_MACDECODE;
 		*flags |= IPT_LOG_OPT_MACDECODE;
 		break;
-	default:
-		return 0;
 	}
 
 	return 1;
diff --git a/extensions/libipt_MASQUERADE.c b/extensions/libipt_MASQUERADE.c
index b6bbd60..3b059ac 100644
--- a/extensions/libipt_MASQUERADE.c
+++ b/extensions/libipt_MASQUERADE.c
@@ -102,10 +102,8 @@ static int MASQUERADE_parse(int c, char **argv, int invert, unsigned int *flags,
 	case '2':
 		mr->range[0].flags |=  IP_NAT_RANGE_PROTO_RANDOM;
 		return 1;
-
-	default:
-		return 0;
 	}
+	return 0;
 }
 
 static void
diff --git a/extensions/libipt_NETMAP.c b/extensions/libipt_NETMAP.c
index 23731af..c7d0307 100644
--- a/extensions/libipt_NETMAP.c
+++ b/extensions/libipt_NETMAP.c
@@ -124,10 +124,8 @@ static int NETMAP_parse(int c, char **argv, int invert, unsigned int *flags,
 		parse_to(optarg, &mr->range[0]);
 		*flags = 1;
 		return 1;
-
-	default:
-		return 0;
 	}
+	return 0;
 }
 
 static void NETMAP_check(unsigned int flags)
diff --git a/extensions/libipt_REDIRECT.c b/extensions/libipt_REDIRECT.c
index 940603a..4760e65 100644
--- a/extensions/libipt_REDIRECT.c
+++ b/extensions/libipt_REDIRECT.c
@@ -113,10 +113,8 @@ static int REDIRECT_parse(int c, char **argv, int invert, unsigned int *flags,
 		} else
 			*flags |= IPT_REDIRECT_OPT_RANDOM;
 		return 1;
-
-	default:
-		return 0;
 	}
+	return 0;
 }
 
 static void REDIRECT_print(const void *ip, const struct xt_entry_target *target,
diff --git a/extensions/libipt_REJECT.c b/extensions/libipt_REJECT.c
index 8c08dd0..4bd5f4a 100644
--- a/extensions/libipt_REJECT.c
+++ b/extensions/libipt_REJECT.c
@@ -115,8 +115,6 @@ static int REJECT_parse(int c, char **argv, int invert, unsigned int *flags,
 			fprintf(stderr, "--reject-with echo-reply no longer"
 				" supported\n");
 		xtables_error(PARAMETER_PROBLEM, "unknown reject type \"%s\"", optarg);
-	default:
-		/* Fall through */
 		break;
 	}
 	return 0;
diff --git a/extensions/libipt_SAME.c b/extensions/libipt_SAME.c
index 5fb1b5b..9531a3b 100644
--- a/extensions/libipt_SAME.c
+++ b/extensions/libipt_SAME.c
@@ -120,9 +120,6 @@ static int SAME_parse(int c, char **argv, int invert, unsigned int *flags,
 		for (count=0; count < mr->rangesize; count++)
 			mr->range[count].flags |= IP_NAT_RANGE_PROTO_RANDOM;
 		break;
-
-	default:
-		return 0;
 	}
 	
 	return 1;
diff --git a/extensions/libipt_SNAT.c b/extensions/libipt_SNAT.c
index 1075c79..2700bcc 100644
--- a/extensions/libipt_SNAT.c
+++ b/extensions/libipt_SNAT.c
@@ -184,10 +184,8 @@ static int SNAT_parse(int c, char **argv, int invert, unsigned int *flags,
 	case '3':
 		info->mr.range[0].flags |= IP_NAT_RANGE_PERSISTENT;
 		return 1;
-
-	default:
-		return 0;
 	}
+	return 0;
 }
 
 static void SNAT_check(unsigned int flags)
diff --git a/extensions/libipt_TTL.c b/extensions/libipt_TTL.c
index 2e0c233..c8e5524 100644
--- a/extensions/libipt_TTL.c
+++ b/extensions/libipt_TTL.c
@@ -71,10 +71,6 @@ static int TTL_parse(int c, char **argv, int invert, unsigned int *flags,
 
 			info->mode = IPT_TTL_INC;
 			break;
-
-		default:
-			return 0;
-
 	}
 	
 	info->ttl = value;
diff --git a/extensions/libipt_ULOG.c b/extensions/libipt_ULOG.c
index 46928c3..0185f98 100644
--- a/extensions/libipt_ULOG.c
+++ b/extensions/libipt_ULOG.c
@@ -138,8 +138,6 @@ static int ULOG_parse(int c, char **argv, int invert, unsigned int *flags,
 		loginfo->qthreshold = atoi(optarg);
 		*flags |= IPT_LOG_OPT_QTHRESHOLD;
 		break;
-	default:
-		return 0;
 	}
 	return 1;
 }
diff --git a/extensions/libipt_addrtype.c b/extensions/libipt_addrtype.c
index 8a64211..fa6cc1e 100644
--- a/extensions/libipt_addrtype.c
+++ b/extensions/libipt_addrtype.c
@@ -122,8 +122,6 @@ addrtype_parse_v0(int c, char **argv, int invert, unsigned int *flags,
 			info->invert_dest = 1;
 		*flags |= IPT_ADDRTYPE_OPT_DSTTYPE;
 		break;
-	default:
-		return 0;
 	}
 	
 	return 1;
@@ -171,8 +169,6 @@ addrtype_parse_v1(int c, char **argv, int invert, unsigned int *flags,
 		info->flags |= IPT_ADDRTYPE_LIMIT_IFACE_OUT;
 		*flags |= IPT_ADDRTYPE_OPT_LIMIT_IFACE_OUT;
 		break;
-	default:
-		return 0;
 	}
 	
 	return 1;
diff --git a/extensions/libipt_ah.c b/extensions/libipt_ah.c
index 3369c66..9359062 100644
--- a/extensions/libipt_ah.c
+++ b/extensions/libipt_ah.c
@@ -89,8 +89,6 @@ static int ah_parse(int c, char **argv, int invert, unsigned int *flags,
 			ahinfo->invflags |= IPT_AH_INV_SPI;
 		*flags |= AH_SPI;
 		break;
-	default:
-		return 0;
 	}
 
 	return 1;
diff --git a/extensions/libipt_ecn.c b/extensions/libipt_ecn.c
index 3f1fc3b..27e46b3 100644
--- a/extensions/libipt_ecn.c
+++ b/extensions/libipt_ecn.c
@@ -76,8 +76,6 @@ static int ecn_parse(int c, char **argv, int invert, unsigned int *flags,
 				   "ECN match: Value out of range");
 		einfo->ip_ect = result;
 		break;
-	default:
-		return 0;
 	}
 
 	return 1;
diff --git a/extensions/libipt_icmp.c b/extensions/libipt_icmp.c
index 2204027..a233520 100644
--- a/extensions/libipt_icmp.c
+++ b/extensions/libipt_icmp.c
@@ -191,9 +191,6 @@ static int icmp_parse(int c, char **argv, int invert, unsigned int *flags,
 			icmpinfo->invflags |= IPT_ICMP_INV;
 		*flags = 1;
 		break;
-
-	default:
-		return 0;
 	}
 
 	return 1;
diff --git a/extensions/libipt_realm.c b/extensions/libipt_realm.c
index 1d48546..a5ec6d8 100644
--- a/extensions/libipt_realm.c
+++ b/extensions/libipt_realm.c
@@ -180,9 +180,6 @@ static int realm_parse(int c, char **argv, int invert, unsigned int *flags,
 			realminfo->invert = 1;
 		*flags = 1;
 		break;
-
-	default:
-		return 0;
 	}
 	return 1;
 }
diff --git a/extensions/libipt_ttl.c b/extensions/libipt_ttl.c
index 34d0f23..05de9f7 100644
--- a/extensions/libipt_ttl.c
+++ b/extensions/libipt_ttl.c
@@ -68,9 +68,6 @@ static int ttl_parse(int c, char **argv, int invert, unsigned int *flags,
 			info->mode = IPT_TTL_GT;
 			info->ttl = value;
 			break;
-		default:
-			return 0;
-
 	}
 
 	if (*flags) 
diff --git a/extensions/libxt_CHECKSUM.c b/extensions/libxt_CHECKSUM.c
index 101a54c..a4a60b3 100644
--- a/extensions/libxt_CHECKSUM.c
+++ b/extensions/libxt_CHECKSUM.c
@@ -42,8 +42,6 @@ static int CHECKSUM_parse(int c, char **argv, int invert, unsigned int *flags,
 		einfo->operation = XT_CHECKSUM_OP_FILL;
 		*flags |= XT_CHECKSUM_OP_FILL;
 		break;
-	default:
-		return 0;
 	}
 
 	return 1;
diff --git a/extensions/libxt_CLASSIFY.c b/extensions/libxt_CLASSIFY.c
index ab5127c..2920ee8 100644
--- a/extensions/libxt_CLASSIFY.c
+++ b/extensions/libxt_CLASSIFY.c
@@ -53,9 +53,6 @@ CLASSIFY_parse(int c, char **argv, int invert, unsigned int *flags,
 			           "CLASSIFY: Can't specify --set-class twice");
 		*flags = 1;
 		break;
-
-	default:
-		return 0;
 	}
 
 	return 1;
diff --git a/extensions/libxt_CONNMARK.c b/extensions/libxt_CONNMARK.c
index 0d43a0d..4657411 100644
--- a/extensions/libxt_CONNMARK.c
+++ b/extensions/libxt_CONNMARK.c
@@ -147,8 +147,6 @@ CONNMARK_parse(int c, char **argv, int invert, unsigned int *flags,
 		if (*end != '\0' || end == optarg)
 			xtables_error(PARAMETER_PROBLEM, "Bad MASK value \"%s\"", optarg);
 		break;
-	default:
-		return 0;
 	}
 
 	return 1;
diff --git a/extensions/libxt_CONNSECMARK.c b/extensions/libxt_CONNSECMARK.c
index 8df2363..75d0e3b 100644
--- a/extensions/libxt_CONNSECMARK.c
+++ b/extensions/libxt_CONNSECMARK.c
@@ -52,9 +52,6 @@ CONNSECMARK_parse(int c, char **argv, int invert, unsigned int *flags,
 		info->mode = CONNSECMARK_RESTORE;
 		*flags |= CONNSECMARK_RESTORE;
 		break;
-
-	default:
-		return 0;
 	}
 
 	return 1;
diff --git a/extensions/libxt_CT.c b/extensions/libxt_CT.c
index 8952b75..682dd83 100644
--- a/extensions/libxt_CT.c
+++ b/extensions/libxt_CT.c
@@ -127,8 +127,6 @@ static int ct_parse(int c, char **argv, int invert, unsigned int *flags,
 			xtables_error(PARAMETER_PROBLEM, "Bad zone value \"%s\"", optarg);
 		info->zone = zone;
 		break;
-	default:
-		return 0;
 	}
 
 	*flags |= c;
diff --git a/extensions/libxt_DSCP.c b/extensions/libxt_DSCP.c
index a6280bf..468516c 100644
--- a/extensions/libxt_DSCP.c
+++ b/extensions/libxt_DSCP.c
@@ -92,9 +92,6 @@ static int DSCP_parse(int c, char **argv, int invert, unsigned int *flags,
 		parse_class(optarg, dinfo);
 		*flags = 1;
 		break;
-
-	default:
-		return 0;
 	}
 
 	return 1;
diff --git a/extensions/libxt_IDLETIMER.c b/extensions/libxt_IDLETIMER.c
index 1562e02..05db0e9 100644
--- a/extensions/libxt_IDLETIMER.c
+++ b/extensions/libxt_IDLETIMER.c
@@ -78,9 +78,6 @@ static int idletimer_tg_parse(int c, char **argv, int invert,
 		strcpy(info->label, optarg);
 		*flags |= IDLETIMER_TG_OPT_LABEL;
 		break;
-
-	default:
-		return false;
 	}
 
 	return true;
diff --git a/extensions/libxt_MARK.c b/extensions/libxt_MARK.c
index e33e0c3..cbb18ba 100644
--- a/extensions/libxt_MARK.c
+++ b/extensions/libxt_MARK.c
@@ -93,8 +93,6 @@ MARK_parse_v0(int c, char **argv, int invert, unsigned int *flags,
 	case '3':
 		xtables_error(PARAMETER_PROBLEM,
 			   "MARK target: kernel too old for --or-mark");
-	default:
-		return 0;
 	}
 
 	return 1;
@@ -126,8 +124,6 @@ MARK_parse_v1(int c, char **argv, int invert, unsigned int *flags,
 	case '3':
 	        markinfo->mode = XT_MARK_OR;
 		break;
-	default:
-		return 0;
 	}
 
 	if (!xtables_strtoui(optarg, NULL, &mark, 0, UINT32_MAX))
@@ -193,9 +189,6 @@ static int mark_tg_parse(int c, char **argv, int invert, unsigned int *flags,
 		info->mark = value;
 		info->mask = 0;
 		break;
-
-	default:
-		return false;
 	}
 
 	*flags |= F_MARK;
diff --git a/extensions/libxt_NFLOG.c b/extensions/libxt_NFLOG.c
index 2cf279a..2da5d64 100644
--- a/extensions/libxt_NFLOG.c
+++ b/extensions/libxt_NFLOG.c
@@ -103,8 +103,6 @@ static int NFLOG_parse(int c, char **argv, int invert, unsigned int *flags,
 				   "Invalid --nflog-threshold, must be >= 1");
 		info->threshold = n;
 		break;
-	default:
-		return 0;
 	}
 	*flags |= c;
 	return 1;
diff --git a/extensions/libxt_NFQUEUE.c b/extensions/libxt_NFQUEUE.c
index e412153..995134e 100644
--- a/extensions/libxt_NFQUEUE.c
+++ b/extensions/libxt_NFQUEUE.c
@@ -70,8 +70,6 @@ NFQUEUE_parse(int c, char **argv, int invert, unsigned int *flags,
 	case 'B':
 		xtables_error(PARAMETER_PROBLEM, "NFQUEUE target: "
 				   "--queue-balance not supported (kernel too old?)");
-	default:
-		return 0;
 	}
 
 	return 1;
@@ -114,8 +112,6 @@ NFQUEUE_parse_v1(int c, char **argv, int invert, unsigned int *flags,
 							firstqueue, lastqueue);
 		info->queues_total = lastqueue - firstqueue + 1;
 		break;
-	default:
-		return 0;
 	}
 
 	return 1;
diff --git a/extensions/libxt_RATEEST.c b/extensions/libxt_RATEEST.c
index d89f818..173fee3 100644
--- a/extensions/libxt_RATEEST.c
+++ b/extensions/libxt_RATEEST.c
@@ -130,9 +130,6 @@ RATEEST_parse(int c, char **argv, int invert, unsigned int *flags,
 				   "RATEEST: bad ewmalog value `%s'", optarg);
 
 		break;
-
-	default:
-		return 0;
 	}
 
 	return 1;
diff --git a/extensions/libxt_SECMARK.c b/extensions/libxt_SECMARK.c
index 7bf4ff0..b800d4a 100644
--- a/extensions/libxt_SECMARK.c
+++ b/extensions/libxt_SECMARK.c
@@ -49,8 +49,6 @@ static int SECMARK_parse(int c, char **argv, int invert, unsigned int *flags,
 		strcpy(info->secctx, optarg);
 		*flags |= SECMARK_MODE_SEL;
 		break;
-	default:
-		return 0;
 	}
 
 	return 1;
diff --git a/extensions/libxt_SET.c b/extensions/libxt_SET.c
index c05811e..2d186c5 100644
--- a/extensions/libxt_SET.c
+++ b/extensions/libxt_SET.c
@@ -102,9 +102,6 @@ set_target_parse_v0(int c, char **argv, int invert, unsigned int *flags,
 		parse_target_v0(argv, invert, flags,
 				&myinfo->del_set, "del-set");
 		break;
-
-	default:
-		return 0;
 	}
 	return 1;
 }
@@ -204,9 +201,6 @@ set_target_parse(int c, char **argv, int invert, unsigned int *flags,
 		parse_target(argv, invert, flags,
 			     &myinfo->del_set, "del-set");
 		break;
-
-	default:
-		return 0;
 	}
 	return 1;
 }
diff --git a/extensions/libxt_TCPMSS.c b/extensions/libxt_TCPMSS.c
index b24789a..1468dee 100644
--- a/extensions/libxt_TCPMSS.c
+++ b/extensions/libxt_TCPMSS.c
@@ -71,9 +71,6 @@ static int __TCPMSS_parse(int c, char **argv, int invert, unsigned int *flags,
 		mssinfo->mss = XT_TCPMSS_CLAMP_PMTU;
 		*flags = 1;
 		break;
-
-	default:
-		return 0;
 	}
 
 	return 1;
diff --git a/extensions/libxt_TOS.c b/extensions/libxt_TOS.c
index 6ad2216..29bc693 100644
--- a/extensions/libxt_TOS.c
+++ b/extensions/libxt_TOS.c
@@ -145,9 +145,6 @@ static int tos_tg_parse(int c, char **argv, int invert, unsigned int *flags,
 		info->tos_value = bits;
 		info->tos_mask  = 0;
 		break;
-
-	default:
-		return false;
 	}
 
 	*flags |= FLAG_TOS;
diff --git a/extensions/libxt_cluster.c b/extensions/libxt_cluster.c
index 1591045..c94741f 100644
--- a/extensions/libxt_cluster.c
+++ b/extensions/libxt_cluster.c
@@ -134,8 +134,6 @@ cluster_parse(int c, char **argv, int invert, unsigned int *flags,
 		info->hash_seed = num;
 		*flags |= 1 << c;
 		break;
-	default:
-		return 0;
 	}
 
 	return 1;
diff --git a/extensions/libxt_comment.c b/extensions/libxt_comment.c
index dba8bb2..bfdccb2 100644
--- a/extensions/libxt_comment.c
+++ b/extensions/libxt_comment.c
@@ -55,9 +55,6 @@ comment_parse(int c, char **argv, int invert, unsigned int *flags,
 		parse_comment(optarg, commentinfo);
 		*flags = 1;
 		break;
-
-	default:
-		return 0;
 	}
 	return 1;
 }
diff --git a/extensions/libxt_connbytes.c b/extensions/libxt_connbytes.c
index 2e20862..7c96c32 100644
--- a/extensions/libxt_connbytes.c
+++ b/extensions/libxt_connbytes.c
@@ -89,8 +89,6 @@ connbytes_parse(int c, char **argv, int invert, unsigned int *flags,
 				   "Unknown --connbytes-mode `%s'", optarg);
 		*flags |= 4;
 		break;
-	default:
-		return 0;
 	}
 
 	return 1;
diff --git a/extensions/libxt_connlimit.c b/extensions/libxt_connlimit.c
index 0cbcf01..85c0ca8 100644
--- a/extensions/libxt_connlimit.c
+++ b/extensions/libxt_connlimit.c
@@ -94,8 +94,6 @@ static int connlimit_parse(int c, char **argv, int invert, unsigned int *flags,
 				info->v4_mask = htonl(0xFFFFFFFF << (32 - i));
 		}
 		break;
-	default:
-		return 0;
 	}
 
 	return 1;
diff --git a/extensions/libxt_connmark.c b/extensions/libxt_connmark.c
index a953443..4cc59ac 100644
--- a/extensions/libxt_connmark.c
+++ b/extensions/libxt_connmark.c
@@ -102,9 +102,6 @@ connmark_parse(int c, char **argv, int invert, unsigned int *flags,
 			markinfo->invert = 1;
 		*flags = 1;
 		break;
-
-	default:
-		return 0;
 	}
 	return 1;
 }
diff --git a/extensions/libxt_conntrack.c b/extensions/libxt_conntrack.c
index dcb1771..f21d1ab 100644
--- a/extensions/libxt_conntrack.c
+++ b/extensions/libxt_conntrack.c
@@ -461,9 +461,6 @@ static int conntrack_parse(int c, char **argv, int invert, unsigned int *flags,
 		}
 		sinfo->flags |= XT_CONNTRACK_EXPIRES;
 		break;
-
-	default:
-		return 0;
 	}
 
 	*flags = sinfo->flags;
@@ -566,9 +563,6 @@ conntrack_mt_parse(int c, bool invert, unsigned int *flags,
 			xtables_param_act(XTF_BAD_VALUE, "conntrack", "--ctdir", optarg);
 		}
 		break;
-
-	default:
-		return false;
 	}
 
 	*flags = info->match_flags;
diff --git a/extensions/libxt_cpu.c b/extensions/libxt_cpu.c
index ee02996..b4ad456 100644
--- a/extensions/libxt_cpu.c
+++ b/extensions/libxt_cpu.c
@@ -49,9 +49,6 @@ cpu_parse(int c, char **argv, int invert, unsigned int *flags,
 			cpuinfo->invert = 1;
 		*flags = 1;
 		break;
-
-	default:
-		return 0;
 	}
 
 	return 1;
diff --git a/extensions/libxt_dccp.c b/extensions/libxt_dccp.c
index 84f1536..7a0e96b 100644
--- a/extensions/libxt_dccp.c
+++ b/extensions/libxt_dccp.c
@@ -183,8 +183,6 @@ dccp_parse(int c, char **argv, int invert, unsigned int *flags,
 			einfo->invflags |= XT_DCCP_OPTION;
 		*flags |= XT_DCCP_OPTION;
 		break;
-	default:
-		return 0;
 	}
 	return 1;
 }
diff --git a/extensions/libxt_dscp.c b/extensions/libxt_dscp.c
index 4f81f2f..1d7fadf 100644
--- a/extensions/libxt_dscp.c
+++ b/extensions/libxt_dscp.c
@@ -100,9 +100,6 @@ dscp_parse(int c, char **argv, int invert, unsigned int *flags,
 			dinfo->invert = 1;
 		*flags = 1;
 		break;
-
-	default:
-		return 0;
 	}
 
 	return 1;
diff --git a/extensions/libxt_esp.c b/extensions/libxt_esp.c
index b95ae1c..82ca301 100644
--- a/extensions/libxt_esp.c
+++ b/extensions/libxt_esp.c
@@ -95,8 +95,6 @@ esp_parse(int c, char **argv, int invert, unsigned int *flags,
 			espinfo->invflags |= XT_ESP_INV_SPI;
 		*flags |= ESP_SPI;
 		break;
-	default:
-		return 0;
 	}
 
 	return 1;
diff --git a/extensions/libxt_hashlimit.c b/extensions/libxt_hashlimit.c
index b26628a..352e530 100644
--- a/extensions/libxt_hashlimit.c
+++ b/extensions/libxt_hashlimit.c
@@ -298,8 +298,6 @@ hashlimit_parse(int c, char **argv, int invert, unsigned int *flags,
 		strncpy(r->name, optarg, sizeof(r->name));
 		*flags |= PARAM_NAME;
 		break;
-	default:
-		return 0;
 	}
 
 	if (invert)
diff --git a/extensions/libxt_helper.c b/extensions/libxt_helper.c
index e9551bc..3c744c9 100644
--- a/extensions/libxt_helper.c
+++ b/extensions/libxt_helper.c
@@ -39,9 +39,6 @@ helper_parse(int c, char **argv, int invert, unsigned int *flags,
 			info->invert = 1;
 		*flags = 1;
 		break;
-
-	default:
-		return 0;
 	}
 	return 1;
 }
diff --git a/extensions/libxt_iprange.c b/extensions/libxt_iprange.c
index 6565d42..2ac2fa4 100644
--- a/extensions/libxt_iprange.c
+++ b/extensions/libxt_iprange.c
@@ -128,9 +128,6 @@ static int iprange_parse(int c, char **argv, int invert, unsigned int *flags,
 		info->dst.min_ip = range[0].ip;
 		info->dst.max_ip = range[1].ip;
 		break;
-
-	default:
-		return 0;
 	}
 	return 1;
 }
diff --git a/extensions/libxt_ipvs.c b/extensions/libxt_ipvs.c
index 83de042..3001417 100644
--- a/extensions/libxt_ipvs.c
+++ b/extensions/libxt_ipvs.c
@@ -155,11 +155,6 @@ static int ipvs_mt_parse(int c, char **argv, int invert, unsigned int *flags,
 	case '6': /* --vportctl */
 		data->vportctl = htons(xtables_parse_port(optarg, "tcp"));
 		break;
-
-	default:
-		/* Hu? How did we come here? */
-		assert(false);
-		return 0;
 	}
 
 	if (op & XT_IPVS_ONCE_MASK) {
diff --git a/extensions/libxt_length.c b/extensions/libxt_length.c
index edcb6b5..86ccba0 100644
--- a/extensions/libxt_length.c
+++ b/extensions/libxt_length.c
@@ -77,9 +77,6 @@ length_parse(int c, char **argv, int invert, unsigned int *flags,
 				info->invert = 1;
 			*flags = 1;
 			break;
-			
-		default:
-			return 0;
 	}
 	return 1;
 }
diff --git a/extensions/libxt_limit.c b/extensions/libxt_limit.c
index 350cb24..a62d199 100644
--- a/extensions/libxt_limit.c
+++ b/extensions/libxt_limit.c
@@ -107,9 +107,6 @@ limit_parse(int c, char **argv, int invert, unsigned int *flags,
 				   "bad --limit-burst `%s'", optarg);
 		r->burst = num;
 		break;
-
-	default:
-		return 0;
 	}
 
 	if (invert)
diff --git a/extensions/libxt_mac.c b/extensions/libxt_mac.c
index eb07467..15a7f3c 100644
--- a/extensions/libxt_mac.c
+++ b/extensions/libxt_mac.c
@@ -64,9 +64,6 @@ mac_parse(int c, char **argv, int invert, unsigned int *flags,
 			macinfo->invert = 1;
 		*flags = 1;
 		break;
-
-	default:
-		return 0;
 	}
 
 	return 1;
diff --git a/extensions/libxt_mark.c b/extensions/libxt_mark.c
index d17a7b2..15b08b9 100644
--- a/extensions/libxt_mark.c
+++ b/extensions/libxt_mark.c
@@ -79,9 +79,6 @@ mark_parse(int c, char **argv, int invert, unsigned int *flags,
 			markinfo->invert = 1;
 		*flags = 1;
 		break;
-
-	default:
-		return 0;
 	}
 	return 1;
 }
diff --git a/extensions/libxt_multiport.c b/extensions/libxt_multiport.c
index 9ed5931..2f52383 100644
--- a/extensions/libxt_multiport.c
+++ b/extensions/libxt_multiport.c
@@ -187,9 +187,6 @@ __multiport_parse(int c, char **argv, int invert, unsigned int *flags,
 						     multiinfo->ports, proto);
 		multiinfo->flags = XT_MULTIPORT_EITHER;
 		break;
-
-	default:
-		return 0;
 	}
 
 	if (invert)
@@ -251,9 +248,6 @@ __multiport_parse_v1(int c, char **argv, int invert, unsigned int *flags,
 		parse_multi_ports_v1(optarg, multiinfo, proto);
 		multiinfo->flags = XT_MULTIPORT_EITHER;
 		break;
-
-	default:
-		return 0;
 	}
 
 	if (invert)
diff --git a/extensions/libxt_osf.c b/extensions/libxt_osf.c
index 66c23b4..38c4705 100644
--- a/extensions/libxt_osf.c
+++ b/extensions/libxt_osf.c
@@ -107,8 +107,6 @@ static int osf_parse(int c, char **argv, int invert, unsigned int *flags,
 				xtables_error(PARAMETER_PROBLEM, "Log level parameter is too big");
 			info->flags |= XT_OSF_LOG;
 			break;
-		default:
-			return 0;
 	}
 
 	return 1;
diff --git a/extensions/libxt_physdev.c b/extensions/libxt_physdev.c
index d92df9e..abd182c 100644
--- a/extensions/libxt_physdev.c
+++ b/extensions/libxt_physdev.c
@@ -94,9 +94,6 @@ physdev_parse(int c, char **argv, int invert, unsigned int *flags,
 		*flags |= XT_PHYSDEV_OP_BRIDGED;
 		info->bitmask |= XT_PHYSDEV_OP_BRIDGED;
 		break;
-
-	default:
-		return 0;
 	}
 
 	return 1;
diff --git a/extensions/libxt_pkttype.c b/extensions/libxt_pkttype.c
index d402591..8aefd92 100644
--- a/extensions/libxt_pkttype.c
+++ b/extensions/libxt_pkttype.c
@@ -94,9 +94,6 @@ static int pkttype_parse(int c, char **argv, int invert, unsigned int *flags,
 				info->invert=1;
 			*flags=1;
 			break;
-
-		default: 
-			return 0;
 	}
 
 	return 1;
diff --git a/extensions/libxt_policy.c b/extensions/libxt_policy.c
index 3fea146..565f8a3 100644
--- a/extensions/libxt_policy.c
+++ b/extensions/libxt_policy.c
@@ -261,8 +261,6 @@ static int policy_parse(int c, char **argv, int invert, unsigned int *flags,
 			xtables_error(PARAMETER_PROBLEM,
 			           "policy match: maximum policy depth reached");
 		break;
-	default:
-		return 0;
 	}
 
 	policy_info = info;
diff --git a/extensions/libxt_quota.c b/extensions/libxt_quota.c
index 9a88cba..64100cd 100644
--- a/extensions/libxt_quota.c
+++ b/extensions/libxt_quota.c
@@ -71,9 +71,6 @@ quota_parse(int c, char **argv, int invert, unsigned int *flags,
 			info->flags |= XT_QUOTA_INVERT;
 
 		break;
-
-	default:
-		return 0;
 	}
 	return 1;
 }
diff --git a/extensions/libxt_rateest.c b/extensions/libxt_rateest.c
index 3809fe7..7b6ba00 100644
--- a/extensions/libxt_rateest.c
+++ b/extensions/libxt_rateest.c
@@ -297,9 +297,6 @@ rateest_parse(int c, char **argv, int invert, unsigned int *flags,
 		if (invert)
 			info->flags |= XT_RATEEST_MATCH_INVERT;
 		break;
-
-	default:
-		return 0;
 	}
 
 	return 1;
diff --git a/extensions/libxt_recent.c b/extensions/libxt_recent.c
index 41faeb6..85f3613 100644
--- a/extensions/libxt_recent.c
+++ b/extensions/libxt_recent.c
@@ -138,9 +138,6 @@ static int recent_parse(int c, char **argv, int invert, unsigned int *flags,
 		case 210:
 			info->side = XT_RECENT_DEST;
 			break;
-
-		default:
-			return 0;
 	}
 
 	return 1;
diff --git a/extensions/libxt_sctp.c b/extensions/libxt_sctp.c
index fe010aa..ad26076 100644
--- a/extensions/libxt_sctp.c
+++ b/extensions/libxt_sctp.c
@@ -296,9 +296,6 @@ sctp_parse(int c, char **argv, int invert, unsigned int *flags,
 		optind++;
 		*flags |= XT_SCTP_CHUNK_TYPES;
 		break;
-
-	default:
-		return 0;
 	}
 	return 1;
 }
diff --git a/extensions/libxt_set.c b/extensions/libxt_set.c
index 594e2d4..6364011 100644
--- a/extensions/libxt_set.c
+++ b/extensions/libxt_set.c
@@ -85,9 +85,6 @@ set_parse_v0(int c, char **argv, int invert, unsigned int *flags,
 		
 		*flags = 1;
 		break;
-
-	default:
-		return 0;
 	}
 
 	return 1;
@@ -170,9 +167,6 @@ set_parse(int c, char **argv, int invert, unsigned int *flags,
 		
 		*flags = 1;
 		break;
-
-	default:
-		return 0;
 	}
 
 	return 1;
diff --git a/extensions/libxt_state.c b/extensions/libxt_state.c
index 4064333..a236a3f 100644
--- a/extensions/libxt_state.c
+++ b/extensions/libxt_state.c
@@ -79,9 +79,6 @@ state_parse(int c, char **argv, int invert, unsigned int *flags,
 			sinfo->statemask = ~sinfo->statemask;
 		*flags = 1;
 		break;
-
-	default:
-		return 0;
 	}
 
 	return 1;
diff --git a/extensions/libxt_statistic.c b/extensions/libxt_statistic.c
index 94f2913..f6fbd3b 100644
--- a/extensions/libxt_statistic.c
+++ b/extensions/libxt_statistic.c
@@ -90,8 +90,6 @@ statistic_parse(int c, char **argv, int invert, unsigned int *flags,
 		info->u.nth.packet = val;
 		*flags |= 0x8;
 		break;
-	default:
-		return 0;
 	}
 	return 1;
 }
diff --git a/extensions/libxt_string.c b/extensions/libxt_string.c
index a6c5881..c78f9cd 100644
--- a/extensions/libxt_string.c
+++ b/extensions/libxt_string.c
@@ -238,9 +238,6 @@ string_parse(int c, char **argv, int invert, unsigned int *flags,
 		stringinfo->u.v1.flags |= XT_STRING_FLAG_IGNORECASE;
 		*flags |= ICASE;
 		break;
-
-	default:
-		return 0;
 	}
 	return 1;
 }
diff --git a/extensions/libxt_tcp.c b/extensions/libxt_tcp.c
index df5077f..8bcb0dd 100644
--- a/extensions/libxt_tcp.c
+++ b/extensions/libxt_tcp.c
@@ -203,9 +203,6 @@ tcp_parse(int c, char **argv, int invert, unsigned int *flags,
 			tcpinfo->invflags |= XT_TCP_INV_OPTION;
 		*flags |= TCP_OPTION;
 		break;
-
-	default:
-		return 0;
 	}
 
 	return 1;
diff --git a/extensions/libxt_tcpmss.c b/extensions/libxt_tcpmss.c
index 8dfbb14..35d6d18 100644
--- a/extensions/libxt_tcpmss.c
+++ b/extensions/libxt_tcpmss.c
@@ -73,8 +73,6 @@ tcpmss_parse(int c, char **argv, int invert, unsigned int *flags,
 			mssinfo->invert = 1;
 		*flags = 1;
 		break;
-	default:
-		return 0;
 	}
 	return 1;
 }
diff --git a/extensions/libxt_udp.c b/extensions/libxt_udp.c
index 70e939d..2550d71 100644
--- a/extensions/libxt_udp.c
+++ b/extensions/libxt_udp.c
@@ -90,9 +90,6 @@ udp_parse(int c, char **argv, int invert, unsigned int *flags,
 			udpinfo->invflags |= XT_UDP_INV_DSTPT;
 		*flags |= UDP_DST_PORTS;
 		break;
-
-	default:
-		return 0;
 	}
 
 	return 1;
-- 
1.7.1

