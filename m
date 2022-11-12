Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 220F8C4332F
	for <netfilter-devel@archiver.kernel.org>; Sat, 12 Nov 2022 00:57:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232943AbiKLA5Y (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 11 Nov 2022 19:57:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230037AbiKLA5X (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 11 Nov 2022 19:57:23 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9922F63CD5
        for <netfilter-devel@vger.kernel.org>; Fri, 11 Nov 2022 16:57:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=sUb3+99yBH40P2JfsbkUKby16K6DRpHdETrcGhwgGwg=; b=Eo1cLw3ixr+L47BDcouRbIrDUB
        vEeVhHX2iti2nTYgbD11Idd7OBmzOgfAE03olO8aBaXvtxY02f/mgw7wT609V41mNUEAeODM95ExR
        ktkbqggmPWCB5z1jS4Dvantt1UKyO17Rl41+QOlICsYcep7vDBjVY7euMJICCKG+Sfi2gXT3yAb1Q
        +JIzpN/j8C132q7WPS9nU7uUcUcShOH0HFaT0ba45nbdcMWy0Xlm71SdmSdSPwlauxepRarjGN+Js
        7bTB5JF4eg5XLrI+DdTYBZvkHDPnmSYI1aGDyiV9/dVFzjJO35CZ6HnLygI5J/3N/kejihaGmOhCg
        02cgmbIw==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1otepi-0002Km-SQ
        for netfilter-devel@vger.kernel.org; Sat, 12 Nov 2022 01:57:19 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH] Drop extra newline from xtables_error() calls
Date:   Sat, 12 Nov 2022 01:57:10 +0100
Message-Id: <20221112005710.5778-1-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Since basic_exit_err() appends a newline to the message itself, drop
explicit ones.

While being at it, fix indentation and join texts split over multiple
lines.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/dscp_helper.c        |  4 +--
 extensions/libebt_among.c       |  4 +--
 extensions/libip6t_icmp6.c      |  6 ++--
 extensions/libip6t_mh.c         |  2 +-
 extensions/libipt_CLUSTERIP.c   | 10 +++---
 extensions/libipt_icmp.c        |  6 ++--
 extensions/libxt_CONNSECMARK.c  |  3 +-
 extensions/libxt_CT.c           |  2 +-
 extensions/libxt_SECMARK.c      |  2 +-
 extensions/libxt_bpf.c          |  3 +-
 extensions/libxt_hashlimit.c    |  8 ++---
 extensions/libxt_limit.c        |  4 +--
 extensions/libxt_sctp.c         |  9 +++--
 extensions/libxt_set.c          | 59 +++++++++++++--------------------
 iptables/ip6tables.c            |  4 +--
 iptables/iptables-restore.c     | 38 ++++++++++-----------
 iptables/iptables-save.c        |  5 ++-
 iptables/iptables-xml.c         | 16 ++++-----
 iptables/iptables.c             |  4 +--
 iptables/nft-cache.c            |  3 +-
 iptables/nft.c                  |  2 +-
 iptables/xshared.c              | 30 ++++++++---------
 iptables/xtables-eb-translate.c |  2 +-
 iptables/xtables-eb.c           |  2 +-
 iptables/xtables-restore.c      | 26 +++++++--------
 libxtables/xtoptions.c          |  4 +--
 26 files changed, 121 insertions(+), 137 deletions(-)

diff --git a/extensions/dscp_helper.c b/extensions/dscp_helper.c
index 75b1fece09a63..1f20b2a5f326d 100644
--- a/extensions/dscp_helper.c
+++ b/extensions/dscp_helper.c
@@ -58,7 +58,7 @@ class_to_dscp(const char *name)
 	}
 
 	xtables_error(PARAMETER_PROBLEM,
-			"Invalid DSCP value `%s'\n", name);
+		      "Invalid DSCP value `%s'", name);
 }
 
 
@@ -73,7 +73,7 @@ dscp_to_name(unsigned int dscp)
 			return ds_classes[i].name;
 
 	xtables_error(PARAMETER_PROBLEM,
-			"Invalid DSCP value `%d'\n", dscp);
+		      "Invalid DSCP value `%d'", dscp);
 }
 #endif
 
diff --git a/extensions/libebt_among.c b/extensions/libebt_among.c
index 1eab201984408..a80fb80404ee1 100644
--- a/extensions/libebt_among.c
+++ b/extensions/libebt_among.c
@@ -68,12 +68,12 @@ parse_nft_among_pair(char *buf, struct nft_among_pair *pair, bool have_ip)
 
 		if (!inet_pton(AF_INET, sep + 1, &pair->in))
 			xtables_error(PARAMETER_PROBLEM,
-				      "Invalid IP address '%s'\n", sep + 1);
+				      "Invalid IP address '%s'", sep + 1);
 	}
 	ether = ether_aton(buf);
 	if (!ether)
 		xtables_error(PARAMETER_PROBLEM,
-			      "Invalid MAC address '%s'\n", buf);
+			      "Invalid MAC address '%s'", buf);
 	memcpy(&pair->ether, ether, sizeof(*ether));
 }
 
diff --git a/extensions/libip6t_icmp6.c b/extensions/libip6t_icmp6.c
index cc7bfaeb72fd7..27cea4ab92c2e 100644
--- a/extensions/libip6t_icmp6.c
+++ b/extensions/libip6t_icmp6.c
@@ -108,13 +108,13 @@ parse_icmpv6(const char *icmpv6type, uint8_t *type, uint8_t code[])
 
 		if (!xtables_strtoui(buffer, NULL, &number, 0, UINT8_MAX))
 			xtables_error(PARAMETER_PROBLEM,
-				   "Invalid ICMPv6 type `%s'\n", buffer);
+				      "Invalid ICMPv6 type `%s'", buffer);
 		*type = number;
 		if (slash) {
 			if (!xtables_strtoui(slash+1, NULL, &number, 0, UINT8_MAX))
 				xtables_error(PARAMETER_PROBLEM,
-					   "Invalid ICMPv6 code `%s'\n",
-					   slash+1);
+					      "Invalid ICMPv6 code `%s'",
+					      slash + 1);
 			code[0] = code[1] = number;
 		} else {
 			code[0] = 0;
diff --git a/extensions/libip6t_mh.c b/extensions/libip6t_mh.c
index 64675405ac724..1410d324b5d42 100644
--- a/extensions/libip6t_mh.c
+++ b/extensions/libip6t_mh.c
@@ -97,7 +97,7 @@ static unsigned int name_to_type(const char *name)
 
 		if (!xtables_strtoui(name, NULL, &number, 0, UINT8_MAX))
 			xtables_error(PARAMETER_PROBLEM,
-				   "Invalid MH type `%s'\n", name);
+				      "Invalid MH type `%s'", name);
 		return number;
 	}
 }
diff --git a/extensions/libipt_CLUSTERIP.c b/extensions/libipt_CLUSTERIP.c
index f4b638b2045ad..b207cde3e3fbd 100644
--- a/extensions/libipt_CLUSTERIP.c
+++ b/extensions/libipt_CLUSTERIP.c
@@ -87,12 +87,13 @@ static void CLUSTERIP_parse(struct xt_option_call *cb)
 		else if (strcmp(cb->arg, "sourceip-sourceport-destport") == 0)
 			cipinfo->hash_mode = CLUSTERIP_HASHMODE_SIP_SPT_DPT;
 		else
-			xtables_error(PARAMETER_PROBLEM, "Unknown hashmode \"%s\"\n",
-				   cb->arg);
+			xtables_error(PARAMETER_PROBLEM,
+				      "Unknown hashmode \"%s\"", cb->arg);
 		break;
 	case O_CLUSTERMAC:
 		if (!(cipinfo->clustermac[0] & 0x01))
-			xtables_error(PARAMETER_PROBLEM, "MAC has to be a multicast ethernet address\n");
+			xtables_error(PARAMETER_PROBLEM,
+				      "MAC has to be a multicast ethernet address");
 		break;
 	case O_LOCAL_NODE:
 		cipinfo->num_local_nodes = 1;
@@ -107,7 +108,8 @@ static void CLUSTERIP_check(struct xt_fcheck_call *cb)
 	if ((cb->xflags & F_FULL) == F_FULL)
 		return;
 
-	xtables_error(PARAMETER_PROBLEM, "CLUSTERIP target: Invalid parameter combination\n");
+	xtables_error(PARAMETER_PROBLEM,
+		      "CLUSTERIP target: Invalid parameter combination");
 }
 
 static const char *hashmode2str(enum clusterip_hashmode mode)
diff --git a/extensions/libipt_icmp.c b/extensions/libipt_icmp.c
index e5e236613f39f..c51375e8e16e3 100644
--- a/extensions/libipt_icmp.c
+++ b/extensions/libipt_icmp.c
@@ -128,13 +128,13 @@ parse_icmp(const char *icmptype, uint8_t *type, uint8_t code[])
 
 		if (!xtables_strtoui(buffer, NULL, &number, 0, UINT8_MAX))
 			xtables_error(PARAMETER_PROBLEM,
-				   "Invalid ICMP type `%s'\n", buffer);
+				      "Invalid ICMP type `%s'", buffer);
 		*type = number;
 		if (slash) {
 			if (!xtables_strtoui(slash+1, NULL, &number, 0, UINT8_MAX))
 				xtables_error(PARAMETER_PROBLEM,
-					   "Invalid ICMP code `%s'\n",
-					   slash+1);
+					      "Invalid ICMP code `%s'",
+					      slash + 1);
 			code[0] = code[1] = number;
 		} else {
 			code[0] = 0;
diff --git a/extensions/libxt_CONNSECMARK.c b/extensions/libxt_CONNSECMARK.c
index 0b3cd79d7ebdf..6da589d307cb0 100644
--- a/extensions/libxt_CONNSECMARK.c
+++ b/extensions/libxt_CONNSECMARK.c
@@ -66,7 +66,8 @@ static void print_connsecmark(const struct xt_connsecmark_target_info *info)
 		break;
 		
 	default:
-		xtables_error(OTHER_PROBLEM, PFX "invalid mode %hhu\n", info->mode);
+		xtables_error(OTHER_PROBLEM,
+			      PFX "invalid mode %hhu", info->mode);
 	}
 }
 
diff --git a/extensions/libxt_CT.c b/extensions/libxt_CT.c
index fbbbe2660e9fc..188246657582d 100644
--- a/extensions/libxt_CT.c
+++ b/extensions/libxt_CT.c
@@ -117,7 +117,7 @@ static void ct_parse_zone_id(const char *opt, unsigned int opt_id,
 
 		if (!xtables_strtoul(opt, NULL, &val, 0, UINT16_MAX))
 			xtables_error(PARAMETER_PROBLEM,
-				      "Cannot parse %s as a zone ID\n", opt);
+				      "Cannot parse %s as a zone ID", opt);
 
 		*zone_id = (uint16_t)val;
 	}
diff --git a/extensions/libxt_SECMARK.c b/extensions/libxt_SECMARK.c
index 24249bd618ffe..a4ee60f0185a0 100644
--- a/extensions/libxt_SECMARK.c
+++ b/extensions/libxt_SECMARK.c
@@ -60,7 +60,7 @@ static void print_secmark(__u8 mode, const char *secctx)
 		break;
 
 	default:
-		xtables_error(OTHER_PROBLEM, PFX "invalid mode %hhu\n", mode);
+		xtables_error(OTHER_PROBLEM, PFX "invalid mode %hhu", mode);
 	}
 }
 
diff --git a/extensions/libxt_bpf.c b/extensions/libxt_bpf.c
index eeae86e5504c0..5e0358374e57b 100644
--- a/extensions/libxt_bpf.c
+++ b/extensions/libxt_bpf.c
@@ -83,8 +83,7 @@ static int bpf_obj_get_readonly(const char *filepath)
 	attr.file_flags = 0;
 	return syscall(__NR_bpf, BPF_OBJ_GET, &attr, sizeof(attr));
 #else
-	xtables_error(OTHER_PROBLEM,
-		      "No bpf header, kernel headers too old?\n");
+	xtables_error(OTHER_PROBLEM, "No bpf header, kernel headers too old?");
 	return -EINVAL;
 #endif
 }
diff --git a/extensions/libxt_hashlimit.c b/extensions/libxt_hashlimit.c
index 3f3c43010ee2a..93ee1c32e54c3 100644
--- a/extensions/libxt_hashlimit.c
+++ b/extensions/libxt_hashlimit.c
@@ -356,12 +356,12 @@ static bool parse_bytes(const char *rate, void *val, struct hashlimit_mt_udata *
 	tmp = (uint64_t) r * factor;
 	if (tmp > max)
 		xtables_error(PARAMETER_PROBLEM,
-			"Rate value too large \"%"PRIu64"\" (max %"PRIu64")\n",
-					tmp, max);
+			      "Rate value too large \"%"PRIu64"\" (max %"PRIu64")",
+			      tmp, max);
 
 	tmp = bytes_to_cost(tmp);
 	if (tmp == 0)
-		xtables_error(PARAMETER_PROBLEM, "Rate too high \"%s\"\n", rate);
+		xtables_error(PARAMETER_PROBLEM, "Rate too high \"%s\"", rate);
 
 	ud->mult = XT_HASHLIMIT_BYTE_EXPIRE;
 
@@ -407,7 +407,7 @@ int parse_rate(const char *rate, void *val, struct hashlimit_mt_udata *ud, int r
 		 * The rate maps to infinity. (1/day is the minimum they can
 		 * specify, so we are ok at that end).
 		 */
-		xtables_error(PARAMETER_PROBLEM, "Rate too fast \"%s\"\n", rate);
+		xtables_error(PARAMETER_PROBLEM, "Rate too fast \"%s\"", rate);
 
 	if(revision == 1)
 		*((uint32_t*)val) = tmp;
diff --git a/extensions/libxt_limit.c b/extensions/libxt_limit.c
index 1b3246575f229..e6ec67f302688 100644
--- a/extensions/libxt_limit.c
+++ b/extensions/libxt_limit.c
@@ -77,7 +77,7 @@ int parse_rate(const char *rate, uint32_t *val)
 		 * The rate maps to infinity. (1/day is the minimum they can
 		 * specify, so we are ok at that end).
 		 */
-		xtables_error(PARAMETER_PROBLEM, "Rate too fast \"%s\"\n", rate);
+		xtables_error(PARAMETER_PROBLEM, "Rate too fast \"%s\"", rate);
 	return 1;
 }
 
@@ -93,7 +93,7 @@ static void limit_init(struct xt_entry_match *m)
 /* FIXME: handle overflow:
 	if (r->avg*r->burst/r->burst != r->avg)
 		xtables_error(PARAMETER_PROBLEM,
-			   "Sorry: burst too large for that avg rate.\n");
+			      "Sorry: burst too large for that avg rate.");
 */
 
 static void limit_parse(struct xt_option_call *cb)
diff --git a/extensions/libxt_sctp.c b/extensions/libxt_sctp.c
index 3fb6cf1ab1b53..8f069a43e7b71 100644
--- a/extensions/libxt_sctp.c
+++ b/extensions/libxt_sctp.c
@@ -144,10 +144,8 @@ save_chunk_flag_info(struct xt_sctp_flag_info *flag_info,
 	}
 	
 	if (*flag_count == XT_NUM_SCTP_FLAGS) {
-		xtables_error (PARAMETER_PROBLEM,
-			"Number of chunk types with flags exceeds currently allowed limit."
-			"Increasing this limit involves changing IPT_NUM_SCTP_FLAGS and"
-			"recompiling both the kernel space and user space modules\n");
+		xtables_error(PARAMETER_PROBLEM,
+			      "Number of chunk types with flags exceeds currently allowed limit. Increasing this limit involves changing IPT_NUM_SCTP_FLAGS and recompiling both the kernel space and user space modules");
 	}
 
 	flag_info[*flag_count].chunktype = chunktype;
@@ -219,7 +217,8 @@ parse_sctp_chunk(struct xt_sctp_info *einfo,
 						isupper(chunk_flags[j]));
 				} else {
 					xtables_error(PARAMETER_PROBLEM,
-						"Invalid flags for chunk type %d\n", i);
+						      "Invalid flags for chunk type %d",
+						      i);
 				}
 			}
 		}
diff --git a/extensions/libxt_set.c b/extensions/libxt_set.c
index a2137ab1eb180..471bde8a815d2 100644
--- a/extensions/libxt_set.c
+++ b/extensions/libxt_set.c
@@ -334,8 +334,7 @@ parse_counter(const char *opt)
 
 	if (!xtables_strtoul(opt, NULL, &value, 0, UINT64_MAX))
 		xtables_error(PARAMETER_PROBLEM,
-			      "Cannot parse %s as a counter value\n",
-			      opt);
+			      "Cannot parse %s as a counter value", opt);
 	return (uint64_t)value;
 }
 
@@ -354,60 +353,54 @@ set_parse_v3(int c, char **argv, int invert, unsigned int *flags,
 	case '0':
 		if (info->bytes.op != IPSET_COUNTER_NONE)
 			xtables_error(PARAMETER_PROBLEM,
-				      "only one of the --bytes-[eq|lt|gt]"
-				      " is allowed\n");
+				      "only one of the --bytes-[eq|lt|gt] is allowed");
 		if (invert)
 			xtables_error(PARAMETER_PROBLEM,
-				      "--bytes-gt option cannot be inverted\n");
+				      "--bytes-gt option cannot be inverted");
 		info->bytes.op = IPSET_COUNTER_GT;
 		info->bytes.value = parse_counter(optarg);
 		break;
 	case '9':
 		if (info->bytes.op != IPSET_COUNTER_NONE)
 			xtables_error(PARAMETER_PROBLEM,
-				      "only one of the --bytes-[eq|lt|gt]"
-				      " is allowed\n");
+				      "only one of the --bytes-[eq|lt|gt] is allowed");
 		if (invert)
 			xtables_error(PARAMETER_PROBLEM,
-				      "--bytes-lt option cannot be inverted\n");
+				      "--bytes-lt option cannot be inverted");
 		info->bytes.op = IPSET_COUNTER_LT;
 		info->bytes.value = parse_counter(optarg);
 		break;
 	case '8':
 		if (info->bytes.op != IPSET_COUNTER_NONE)
 			xtables_error(PARAMETER_PROBLEM,
-				      "only one of the --bytes-[eq|lt|gt]"
-				      " is allowed\n");
+				      "only one of the --bytes-[eq|lt|gt] is allowed");
 		info->bytes.op = invert ? IPSET_COUNTER_NE : IPSET_COUNTER_EQ;
 		info->bytes.value = parse_counter(optarg);
 		break;
 	case '7':
 		if (info->packets.op != IPSET_COUNTER_NONE)
 			xtables_error(PARAMETER_PROBLEM,
-				      "only one of the --packets-[eq|lt|gt]"
-				      " is allowed\n");
+				      "only one of the --packets-[eq|lt|gt] is allowed");
 		if (invert)
 			xtables_error(PARAMETER_PROBLEM,
-				      "--packets-gt option cannot be inverted\n");
+				      "--packets-gt option cannot be inverted");
 		info->packets.op = IPSET_COUNTER_GT;
 		info->packets.value = parse_counter(optarg);
 		break;
 	case '6':
 		if (info->packets.op != IPSET_COUNTER_NONE)
 			xtables_error(PARAMETER_PROBLEM,
-				      "only one of the --packets-[eq|lt|gt]"
-				      " is allowed\n");
+				      "only one of the --packets-[eq|lt|gt] is allowed");
 		if (invert)
 			xtables_error(PARAMETER_PROBLEM,
-				      "--packets-lt option cannot be inverted\n");
+				      "--packets-lt option cannot be inverted");
 		info->packets.op = IPSET_COUNTER_LT;
 		info->packets.value = parse_counter(optarg);
 		break;
 	case '5':
 		if (info->packets.op != IPSET_COUNTER_NONE)
 			xtables_error(PARAMETER_PROBLEM,
-				      "only one of the --packets-[eq|lt|gt]"
-				      " is allowed\n");
+				      "only one of the --packets-[eq|lt|gt] is allowed");
 		info->packets.op = invert ? IPSET_COUNTER_NE : IPSET_COUNTER_EQ;
 		info->packets.value = parse_counter(optarg);
 		break;
@@ -418,7 +411,7 @@ set_parse_v3(int c, char **argv, int invert, unsigned int *flags,
 	case '3':
 		if (invert)
 			xtables_error(PARAMETER_PROBLEM,
-				      "--return-nomatch flag cannot be inverted\n");
+				      "--return-nomatch flag cannot be inverted");
 		info->flags |= IPSET_FLAG_RETURN_NOMATCH;
 		break;
 	case '2':
@@ -523,60 +516,54 @@ set_parse_v4(int c, char **argv, int invert, unsigned int *flags,
 	case '0':
 		if (info->bytes.op != IPSET_COUNTER_NONE)
 			xtables_error(PARAMETER_PROBLEM,
-				      "only one of the --bytes-[eq|lt|gt]"
-				      " is allowed\n");
+				      "only one of the --bytes-[eq|lt|gt] is allowed");
 		if (invert)
 			xtables_error(PARAMETER_PROBLEM,
-				      "--bytes-gt option cannot be inverted\n");
+				      "--bytes-gt option cannot be inverted");
 		info->bytes.op = IPSET_COUNTER_GT;
 		info->bytes.value = parse_counter(optarg);
 		break;
 	case '9':
 		if (info->bytes.op != IPSET_COUNTER_NONE)
 			xtables_error(PARAMETER_PROBLEM,
-				      "only one of the --bytes-[eq|lt|gt]"
-				      " is allowed\n");
+				      "only one of the --bytes-[eq|lt|gt] is allowed");
 		if (invert)
 			xtables_error(PARAMETER_PROBLEM,
-				      "--bytes-lt option cannot be inverted\n");
+				      "--bytes-lt option cannot be inverted");
 		info->bytes.op = IPSET_COUNTER_LT;
 		info->bytes.value = parse_counter(optarg);
 		break;
 	case '8':
 		if (info->bytes.op != IPSET_COUNTER_NONE)
 			xtables_error(PARAMETER_PROBLEM,
-				      "only one of the --bytes-[eq|lt|gt]"
-				      " is allowed\n");
+				      "only one of the --bytes-[eq|lt|gt] is allowed");
 		info->bytes.op = invert ? IPSET_COUNTER_NE : IPSET_COUNTER_EQ;
 		info->bytes.value = parse_counter(optarg);
 		break;
 	case '7':
 		if (info->packets.op != IPSET_COUNTER_NONE)
 			xtables_error(PARAMETER_PROBLEM,
-				      "only one of the --packets-[eq|lt|gt]"
-				      " is allowed\n");
+				      "only one of the --packets-[eq|lt|gt] is allowed");
 		if (invert)
 			xtables_error(PARAMETER_PROBLEM,
-				      "--packets-gt option cannot be inverted\n");
+				      "--packets-gt option cannot be inverted");
 		info->packets.op = IPSET_COUNTER_GT;
 		info->packets.value = parse_counter(optarg);
 		break;
 	case '6':
 		if (info->packets.op != IPSET_COUNTER_NONE)
 			xtables_error(PARAMETER_PROBLEM,
-				      "only one of the --packets-[eq|lt|gt]"
-				      " is allowed\n");
+				      "only one of the --packets-[eq|lt|gt] is allowed");
 		if (invert)
 			xtables_error(PARAMETER_PROBLEM,
-				      "--packets-lt option cannot be inverted\n");
+				      "--packets-lt option cannot be inverted");
 		info->packets.op = IPSET_COUNTER_LT;
 		info->packets.value = parse_counter(optarg);
 		break;
 	case '5':
 		if (info->packets.op != IPSET_COUNTER_NONE)
 			xtables_error(PARAMETER_PROBLEM,
-				      "only one of the --packets-[eq|lt|gt]"
-				      " is allowed\n");
+				      "only one of the --packets-[eq|lt|gt] is allowed");
 		info->packets.op = invert ? IPSET_COUNTER_NE : IPSET_COUNTER_EQ;
 		info->packets.value = parse_counter(optarg);
 		break;
@@ -587,7 +574,7 @@ set_parse_v4(int c, char **argv, int invert, unsigned int *flags,
 	case '3':
 		if (invert)
 			xtables_error(PARAMETER_PROBLEM,
-				      "--return-nomatch flag cannot be inverted\n");
+				      "--return-nomatch flag cannot be inverted");
 		info->flags |= IPSET_FLAG_RETURN_NOMATCH;
 		break;
 	case '2':
diff --git a/iptables/ip6tables.c b/iptables/ip6tables.c
index 75984cc1bcdd8..3636634dd3b43 100644
--- a/iptables/ip6tables.c
+++ b/iptables/ip6tables.c
@@ -800,8 +800,8 @@ int do_command6(int argc, char *argv[], char **table,
 #ifdef IP6T_F_GOTO
 			if (cs.fw6.ipv6.flags & IP6T_F_GOTO)
 				xtables_error(PARAMETER_PROBLEM,
-						"goto '%s' is not a chain\n",
-						cs.jumpto);
+					      "goto '%s' is not a chain",
+					      cs.jumpto);
 #endif
 			xtables_find_target(cs.jumpto, XTF_LOAD_MUST_SUCCEED);
 		} else {
diff --git a/iptables/iptables-restore.c b/iptables/iptables-restore.c
index 4410a587597ba..05661bf6ceee3 100644
--- a/iptables/iptables-restore.c
+++ b/iptables/iptables-restore.c
@@ -78,8 +78,9 @@ create_handle(const struct iptables_restore_cb *cb, const char *tablename)
 	}
 
 	if (!handle)
-		xtables_error(PARAMETER_PROBLEM, "%s: unable to initialize "
-			"table '%s'\n", xt_params->program_name, tablename);
+		xtables_error(PARAMETER_PROBLEM,
+			      "%s: unable to initialize table '%s'",
+			      xt_params->program_name, tablename);
 
 	return handle;
 }
@@ -209,8 +210,8 @@ ip46tables_restore_main(const struct iptables_restore_cb *cb,
 			DEBUGP("line %u, table '%s'\n", line, table);
 			if (!table)
 				xtables_error(PARAMETER_PROBLEM,
-					"%s: line %u table name invalid\n",
-					xt_params->program_name, line);
+					      "%s: line %u table name invalid",
+					      xt_params->program_name, line);
 
 			strncpy(curtable, table, XT_TABLE_MAXNAMELEN);
 			curtable[XT_TABLE_MAXNAMELEN] = '\0';
@@ -249,8 +250,8 @@ ip46tables_restore_main(const struct iptables_restore_cb *cb,
 			DEBUGP("line %u, chain '%s'\n", line, chain);
 			if (!chain)
 				xtables_error(PARAMETER_PROBLEM,
-					   "%s: line %u chain name invalid\n",
-					   xt_params->program_name, line);
+					      "%s: line %u chain name invalid",
+					      xt_params->program_name, line);
 
 			if (strlen(chain) >= XT_EXTENSION_MAXNAMELEN)
 				xtables_error(PARAMETER_PROBLEM,
@@ -263,16 +264,14 @@ ip46tables_restore_main(const struct iptables_restore_cb *cb,
 					DEBUGP("Flushing existing user defined chain '%s'\n", chain);
 					if (!cb->ops->flush_entries(chain, handle))
 						xtables_error(PARAMETER_PROBLEM,
-							   "error flushing chain "
-							   "'%s':%s\n", chain,
-							   strerror(errno));
+							      "error flushing chain '%s':%s",
+							      chain, strerror(errno));
 				} else {
 					DEBUGP("Creating new chain '%s'\n", chain);
 					if (!cb->ops->create_chain(chain, handle))
 						xtables_error(PARAMETER_PROBLEM,
-							   "error creating chain "
-							   "'%s':%s\n", chain,
-							   strerror(errno));
+							      "error creating chain '%s':%s",
+							      chain, strerror(errno));
 				}
 			}
 
@@ -280,8 +279,8 @@ ip46tables_restore_main(const struct iptables_restore_cb *cb,
 			DEBUGP("line %u, policy '%s'\n", line, policy);
 			if (!policy)
 				xtables_error(PARAMETER_PROBLEM,
-					   "%s: line %u policy invalid\n",
-					   xt_params->program_name, line);
+					      "%s: line %u policy invalid",
+					      xt_params->program_name, line);
 
 			if (strcmp(policy, "-") != 0) {
 				struct xt_counters count = {};
@@ -292,8 +291,8 @@ ip46tables_restore_main(const struct iptables_restore_cb *cb,
 
 					if (!ctrs || !parse_counters(ctrs, &count))
 						xtables_error(PARAMETER_PROBLEM,
-							  "invalid policy counters "
-							  "for chain '%s'\n", chain);
+							      "invalid policy counters for chain '%s'",
+							      chain);
 				}
 
 				DEBUGP("Setting policy of chain %s to %s\n",
@@ -302,10 +301,9 @@ ip46tables_restore_main(const struct iptables_restore_cb *cb,
 				if (!cb->ops->set_policy(chain, policy, &count,
 						     handle))
 					xtables_error(OTHER_PROBLEM,
-						"Can't set policy `%s'"
-						" on `%s' line %u: %s\n",
-						policy, chain, line,
-						cb->ops->strerror(errno));
+						      "Can't set policy `%s' on `%s' line %u: %s",
+						      policy, chain, line,
+						      cb->ops->strerror(errno));
 			}
 
 			xtables_announce_chain(chain);
diff --git a/iptables/iptables-save.c b/iptables/iptables-save.c
index a8dded639cbad..094adf22b12d2 100644
--- a/iptables/iptables-save.c
+++ b/iptables/iptables-save.c
@@ -61,8 +61,7 @@ for_each_table(int (*func)(struct iptables_save_cb *cb, const char *tablename),
 	while (fgets(tablename, sizeof(tablename), procfile)) {
 		if (tablename[strlen(tablename) - 1] != '\n')
 			xtables_error(OTHER_PROBLEM,
-				   "Badly formed tablename `%s'\n",
-				   tablename);
+				      "Badly formed tablename `%s'", tablename);
 		tablename[strlen(tablename) - 1] = '\0';
 		ret &= func(cb, tablename);
 	}
@@ -85,7 +84,7 @@ static int do_output(struct iptables_save_cb *cb, const char *tablename)
 		h = cb->ops->init(tablename);
 	}
 	if (!h)
-		xtables_error(OTHER_PROBLEM, "Cannot initialize: %s\n",
+		xtables_error(OTHER_PROBLEM, "Cannot initialize: %s",
 			      cb->ops->strerror(errno));
 
 	time_t now = time(NULL);
diff --git a/iptables/iptables-xml.c b/iptables/iptables-xml.c
index 6cf059fb67292..d28cf7481b55d 100644
--- a/iptables/iptables-xml.c
+++ b/iptables/iptables-xml.c
@@ -210,8 +210,8 @@ saveChain(char *chain, char *policy, struct xt_counters *ctr)
 {
 	if (nextChain >= maxChains)
 		xtables_error(PARAMETER_PROBLEM,
-			   "%s: line %u chain name invalid\n",
-			   prog_name, line);
+			      "%s: line %u chain name invalid",
+			      prog_name, line);
 
 	chains[nextChain].chain = xtables_strdup(chain);
 	chains[nextChain].policy = xtables_strdup(policy);
@@ -610,8 +610,8 @@ iptables_xml_main(int argc, char *argv[])
 			DEBUGP("line %u, table '%s'\n", line, table);
 			if (!table)
 				xtables_error(PARAMETER_PROBLEM,
-					   "%s: line %u table name invalid\n",
-					   prog_name, line);
+					      "%s: line %u table name invalid",
+					      prog_name, line);
 
 			openTable(table);
 
@@ -626,8 +626,8 @@ iptables_xml_main(int argc, char *argv[])
 			DEBUGP("line %u, chain '%s'\n", line, chain);
 			if (!chain)
 				xtables_error(PARAMETER_PROBLEM,
-					   "%s: line %u chain name invalid\n",
-					   prog_name, line);
+					      "%s: line %u chain name invalid",
+					      prog_name, line);
 
 			DEBUGP("Creating new chain '%s'\n", chain);
 
@@ -635,8 +635,8 @@ iptables_xml_main(int argc, char *argv[])
 			DEBUGP("line %u, policy '%s'\n", line, policy);
 			if (!policy)
 				xtables_error(PARAMETER_PROBLEM,
-					   "%s: line %u policy invalid\n",
-					   prog_name, line);
+					      "%s: line %u policy invalid",
+					      prog_name, line);
 
 			ctrs = strtok(NULL, " \t\n");
 			parse_counters(ctrs, &count);
diff --git a/iptables/iptables.c b/iptables/iptables.c
index e5207ba106057..75dfd4196ca28 100644
--- a/iptables/iptables.c
+++ b/iptables/iptables.c
@@ -795,8 +795,8 @@ int do_command4(int argc, char *argv[], char **table,
 #ifdef IPT_F_GOTO
 			if (cs.fw.ip.flags & IPT_F_GOTO)
 				xtables_error(PARAMETER_PROBLEM,
-					   "goto '%s' is not a chain\n",
-					   cs.jumpto);
+					      "goto '%s' is not a chain",
+					      cs.jumpto);
 #endif
 			xtables_find_target(cs.jumpto, XTF_LOAD_MUST_SUCCEED);
 		} else {
diff --git a/iptables/nft-cache.c b/iptables/nft-cache.c
index 608e42a7aa01b..2403508c684aa 100644
--- a/iptables/nft-cache.c
+++ b/iptables/nft-cache.c
@@ -105,7 +105,8 @@ static void mnl_genid_get(struct nft_handle *h, uint32_t *genid)
 		return;
 
 	xtables_error(RESOURCE_PROBLEM,
-		      "Could not fetch rule set generation id: %s\n", nft_strerror(errno));
+		      "Could not fetch rule set generation id: %s",
+		      nft_strerror(errno));
 }
 
 static int nftnl_table_list_cb(const struct nlmsghdr *nlh, void *data)
diff --git a/iptables/nft.c b/iptables/nft.c
index 09cb19c987322..b65da37125209 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -3857,6 +3857,6 @@ void nft_assert_table_compatible(struct nft_handle *h,
 		chain = "";
 	}
 	xtables_error(OTHER_PROBLEM,
-		      "%s%s%stable `%s' is incompatible, use 'nft' tool.\n",
+		      "%s%s%stable `%s' is incompatible, use 'nft' tool.",
 		      pfx, chain, sfx, table);
 }
diff --git a/iptables/xshared.c b/iptables/xshared.c
index 695157896d521..b230515d75384 100644
--- a/iptables/xshared.c
+++ b/iptables/xshared.c
@@ -400,15 +400,15 @@ bool tokenize_rule_counters(char **bufferp, char **pcntp, char **bcntp, int line
 
 	ptr = strchr(buffer, ']');
 	if (!ptr)
-		xtables_error(PARAMETER_PROBLEM, "Bad line %u: need ]\n", line);
+		xtables_error(PARAMETER_PROBLEM, "Bad line %u: need ]", line);
 
 	pcnt = strtok(buffer+1, ":");
 	if (!pcnt)
-		xtables_error(PARAMETER_PROBLEM, "Bad line %u: need :\n", line);
+		xtables_error(PARAMETER_PROBLEM, "Bad line %u: need :", line);
 
 	bcnt = strtok(NULL, "]");
 	if (!bcnt)
-		xtables_error(PARAMETER_PROBLEM, "Bad line %u: need ]\n", line);
+		xtables_error(PARAMETER_PROBLEM, "Bad line %u: need ]", line);
 
 	*pcntp = pcnt;
 	*bcntp = bcnt;
@@ -433,10 +433,10 @@ void add_argv(struct argv_store *store, const char *what, int quoted)
 
 	if (store->argc + 1 >= MAX_ARGC)
 		xtables_error(PARAMETER_PROBLEM,
-			      "Parser cannot handle more arguments\n");
+			      "Parser cannot handle more arguments");
 	if (!what)
 		xtables_error(PARAMETER_PROBLEM,
-			      "Trying to store NULL argument\n");
+			      "Trying to store NULL argument");
 
 	store->argv[store->argc] = xtables_strdup(what);
 	store->argvattr[store->argc] = quoted;
@@ -900,8 +900,7 @@ static char cmd2char(int option)
 		;
 	if (i >= ARRAY_SIZE(cmdflags))
 		xtables_error(OTHER_PROBLEM,
-			      "cmd2char(): Invalid command number %u.\n",
-			      1 << i);
+			      "cmd2char(): Invalid command number %u.", 1 << i);
 	return cmdflags[i];
 }
 
@@ -911,8 +910,8 @@ static void add_command(unsigned int *cmd, const int newcmd,
 	if (invert)
 		xtables_error(PARAMETER_PROBLEM, "unexpected '!' flag");
 	if (*cmd & (~othercmds))
-		xtables_error(PARAMETER_PROBLEM, "Cannot use -%c with -%c\n",
-			   cmd2char(newcmd), cmd2char(*cmd & (~othercmds)));
+		xtables_error(PARAMETER_PROBLEM, "Cannot use -%c with -%c",
+			      cmd2char(newcmd), cmd2char(*cmd & (~othercmds)));
 	*cmd |= newcmd;
 }
 
@@ -979,9 +978,8 @@ static void generic_opt_check(int command, int options)
 			if (!(options & (1<<i))) {
 				if (commands_v_options[j][i] == '+')
 					xtables_error(PARAMETER_PROBLEM,
-						   "You need to supply the `-%c' "
-						   "option for this command\n",
-						   optflags[i]);
+						      "You need to supply the `-%c' option for this command",
+						      optflags[i]);
 			} else {
 				if (commands_v_options[j][i] != 'x')
 					legal = 1;
@@ -991,8 +989,8 @@ static void generic_opt_check(int command, int options)
 		}
 		if (legal == -1)
 			xtables_error(PARAMETER_PROBLEM,
-				   "Illegal option `-%c' with this command\n",
-				   optflags[i]);
+				      "Illegal option `-%c' with this command",
+				      optflags[i]);
 	}
 }
 
@@ -1060,12 +1058,12 @@ void assert_valid_chain_name(const char *chainname)
 
 	if (*chainname == '-' || *chainname == '!')
 		xtables_error(PARAMETER_PROBLEM,
-			      "chain name not allowed to start with `%c'\n",
+			      "chain name not allowed to start with `%c'",
 			      *chainname);
 
 	if (xtables_find_target(chainname, XTF_TRY_LOAD))
 		xtables_error(PARAMETER_PROBLEM,
-			      "chain name may not clash with target name\n");
+			      "chain name may not clash with target name");
 
 	for (ptr = chainname; *ptr; ptr++)
 		if (isspace(*ptr))
diff --git a/iptables/xtables-eb-translate.c b/iptables/xtables-eb-translate.c
index 86177024ec703..f09883cd518c0 100644
--- a/iptables/xtables-eb-translate.c
+++ b/iptables/xtables-eb-translate.c
@@ -294,7 +294,7 @@ static int do_commandeb_xlate(struct nft_handle *h, int argc, char *argv[], char
 					      "Multiple commands are not allowed");
 			if (exec_style == EXEC_STYLE_DAEMON)
 				xtables_error(PARAMETER_PROBLEM,
-					      "%s %s\n", prog_name, prog_vers);
+					      "%s %s", prog_name, prog_vers);
 			printf("%s %s\n", prog_name, prog_vers);
 			exit(0);
 		case 'h':
diff --git a/iptables/xtables-eb.c b/iptables/xtables-eb.c
index 631a3cebf11a7..c5fc338575f67 100644
--- a/iptables/xtables-eb.c
+++ b/iptables/xtables-eb.c
@@ -883,7 +883,7 @@ int do_commandeb(struct nft_handle *h, int argc, char *argv[], char **table,
 		case 't': /* Table */
 			if (restore && table_set)
 				xtables_error(PARAMETER_PROBLEM,
-					      "The -t option cannot be used in %s.\n",
+					      "The -t option cannot be used in %s.",
 					      xt_params->program_name);
 			else if (table_set)
 				xtables_error(PARAMETER_PROBLEM,
diff --git a/iptables/xtables-restore.c b/iptables/xtables-restore.c
index c9d4ffbf8405d..abe56374289f4 100644
--- a/iptables/xtables-restore.c
+++ b/iptables/xtables-restore.c
@@ -115,14 +115,14 @@ static void xtables_restore_parse_line(struct nft_handle *h,
 		DEBUGP("line %u, table '%s'\n", line, table);
 		if (!table)
 			xtables_error(PARAMETER_PROBLEM,
-				"%s: line %u table name invalid\n",
-				xt_params->program_name, line);
+				      "%s: line %u table name invalid",
+				      xt_params->program_name, line);
 
 		state->curtable = nft_table_builtin_find(h, table);
 		if (!state->curtable)
 			xtables_error(PARAMETER_PROBLEM,
-				"%s: line %u table name '%s' invalid\n",
-				xt_params->program_name, line, table);
+				      "%s: line %u table name '%s' invalid",
+				      xt_params->program_name, line, table);
 
 		if (p->tablename && (strcmp(p->tablename, table) != 0))
 			return;
@@ -152,8 +152,8 @@ static void xtables_restore_parse_line(struct nft_handle *h,
 		DEBUGP("line %u, chain '%s'\n", line, chain);
 		if (!chain)
 			xtables_error(PARAMETER_PROBLEM,
-				   "%s: line %u chain name invalid\n",
-				   xt_params->program_name, line);
+				      "%s: line %u chain name invalid",
+				      xt_params->program_name, line);
 
 		xtables_announce_chain(chain);
 		assert_valid_chain_name(chain);
@@ -162,8 +162,8 @@ static void xtables_restore_parse_line(struct nft_handle *h,
 		DEBUGP("line %u, policy '%s'\n", line, policy);
 		if (!policy)
 			xtables_error(PARAMETER_PROBLEM,
-				   "%s: line %u policy invalid\n",
-				   xt_params->program_name, line);
+				      "%s: line %u policy invalid",
+				      xt_params->program_name, line);
 
 		if (nft_chain_builtin_find(state->curtable, chain)) {
 			if (counters) {
@@ -172,15 +172,15 @@ static void xtables_restore_parse_line(struct nft_handle *h,
 
 				if (!ctrs || !parse_counters(ctrs, &count))
 					xtables_error(PARAMETER_PROBLEM,
-						   "invalid policy counters for chain '%s'\n",
-						   chain);
+						      "invalid policy counters for chain '%s'",
+						      chain);
 
 			}
 			if (cb->chain_set &&
 			    cb->chain_set(h, state->curtable->name,
 					  chain, policy, &count) < 0) {
 				xtables_error(OTHER_PROBLEM,
-					      "Can't set policy `%s' on `%s' line %u: %s\n",
+					      "Can't set policy `%s' on `%s' line %u: %s",
 					      policy, chain, line,
 					      strerror(errno));
 			}
@@ -189,13 +189,13 @@ static void xtables_restore_parse_line(struct nft_handle *h,
 		} else if (cb->chain_restore(h, chain, state->curtable->name) < 0 &&
 			   errno != EEXIST) {
 			xtables_error(PARAMETER_PROBLEM,
-				      "cannot create chain '%s' (%s)\n",
+				      "cannot create chain '%s' (%s)",
 				      chain, strerror(errno));
 		} else if (h->family == NFPROTO_BRIDGE &&
 			   !ebt_cmd_user_chain_policy(h, state->curtable->name,
 						      chain, policy)) {
 			xtables_error(OTHER_PROBLEM,
-				      "Can't set policy `%s' on `%s' line %u: %s\n",
+				      "Can't set policy `%s' on `%s' line %u: %s",
 				      policy, chain, line,
 				      strerror(errno));
 		}
diff --git a/libxtables/xtoptions.c b/libxtables/xtoptions.c
index 8174a560ec4df..b16bbfbe32311 100644
--- a/libxtables/xtoptions.c
+++ b/libxtables/xtoptions.c
@@ -924,7 +924,7 @@ void xtables_option_tpcall(unsigned int c, char **argv, bool invert,
 	cb.entry = xtables_option_lookup(t->x6_options, c);
 	if (cb.entry == NULL)
 		xtables_error(OTHER_PROBLEM,
-			"Extension does not know id %u\n", c);
+			      "Extension does not know id %u", c);
 	cb.arg      = optarg;
 	cb.invert   = invert;
 	cb.ext_name = t->name;
@@ -960,7 +960,7 @@ void xtables_option_mpcall(unsigned int c, char **argv, bool invert,
 	cb.entry = xtables_option_lookup(m->x6_options, c);
 	if (cb.entry == NULL)
 		xtables_error(OTHER_PROBLEM,
-			"Extension does not know id %u\n", c);
+			      "Extension does not know id %u", c);
 	cb.arg      = optarg;
 	cb.invert   = invert;
 	cb.ext_name = m->name;
-- 
2.38.0

