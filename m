Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BC6D423783;
	Fri, 21 Aug 2026 15:38:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787326740; cv=none; b=fGcJbIDE4+Q5gMnTGmCe7aEpzPT5dkQNnvITsidz0ppVeZnHx9DBkjho5uteFM4VXslBpuuzr/+AHmKHWJly+ICSKVjgE8DpfJXCQt516zq8b4df4OC5ocY0lc0tBWSFF90IqBKm0wxQ0VA0fX6Xt+4m6SUjm8rMrWglTPVKy7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787326740; c=relaxed/simple;
	bh=DIwIO7gHKhiB/sRByuXebFiAyWANSiBRDqNq60e3r+s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kSBmHtkjqpU4/zsVZuoNY3ldpbpZjTllWhGJ3RqsDWUOZDNSqy3kjuv0nt7dWUSmi8eKeZ+gEIGyXyvTykonbBamLF2dDx+1yYj4PzM3C1Bcr7nk1grBzUI8nNV3HhXznz/CdPJZNeLmUgaUXIY9Yn07GsCIcpIsUYzS0Ifj5XM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=H+L6zMXB; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="H+L6zMXB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1787326731;
	bh=WHYjj8635dYTX1Z524P/VXGZH8ftQYCSrPWpmmURYYM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H+L6zMXBAjTwmKLVSPotQVIoHQQVCE2MhK7UcMYAiu6O5S2u0XLj94tJsIi74PKra
	 TdlVi4sj8/7GEQ/BpOQPqAs1SwHcqPpFdbSzSquIorrk7d6VGrc2DS6/e9pCF1f/xd
	 WZAhBUG7H0Db/64JoC9KZbLZs/kFI0+SWBOhdm1oH7MbEby4+U37AcJKymja5ly3Im
	 tcQlxBDZMHPSa0+zX8M6PzVVLMp+/u+/TLn3KJme87RiH8P87VhKgXYx3XFa/TEazW
	 iwpzeRB9zuAERKRYHQwwC4qJ1c6Row7UtqbSs/QnK0M5pVgRRgUbj2zmSPPNiijM24
	 D9tJDruNS6J7g==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 321B660097;
	Fri, 21 Aug 2026 17:38:50 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: [PATCH net 05/10] netfilter: x_tables: remove pr_debug
Date: Fri, 21 Aug 2026 17:38:28 +0200
Message-ID: <20260821153833.245589-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260821153833.245589-1-pablo@netfilter.org>
References: <20260821153833.245589-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Remove pr_debug() for these xtables extensions, these have no use these
days. Still, turn pr_debug() into pr_info_ratelimited() in the .check
path since this helps provide a hint via dmesg in legacy iptables.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv4/netfilter/ipt_ah.c    | 10 +----
 net/ipv6/netfilter/ip6t_ah.c   | 27 +-------------
 net/ipv6/netfilter/ip6t_frag.c | 41 +-------------------
 net/ipv6/netfilter/ip6t_hbh.c  | 40 +++++---------------
 net/ipv6/netfilter/ip6t_mh.c   |  3 --
 net/ipv6/netfilter/ip6t_rt.c   |  6 +--
 net/netfilter/xt_IDLETIMER.c   | 68 ++++++----------------------------
 net/netfilter/xt_LOG.c         |  4 +-
 net/netfilter/xt_MASQUERADE.c  |  4 +-
 net/netfilter/xt_NETMAP.c      |  4 +-
 net/netfilter/xt_REDIRECT.c    |  4 +-
 net/netfilter/xt_esp.c         | 10 +----
 net/netfilter/xt_ipcomp.c      |  8 +---
 net/netfilter/xt_iprange.c     | 32 ++--------------
 net/netfilter/xt_ipvs.c        |  1 -
 net/netfilter/xt_multiport.c   |  4 --
 net/netfilter/xt_sctp.c        | 19 +---------
 net/netfilter/xt_tcpudp.c      |  8 +---
 18 files changed, 47 insertions(+), 246 deletions(-)

diff --git a/net/ipv4/netfilter/ipt_ah.c b/net/ipv4/netfilter/ipt_ah.c
index 161ba412cb08..7131f297ada2 100644
--- a/net/ipv4/netfilter/ipt_ah.c
+++ b/net/ipv4/netfilter/ipt_ah.c
@@ -19,12 +19,7 @@ MODULE_DESCRIPTION("Xtables: IPv4 IPsec-AH SPI match");
 static inline bool
 spi_match(u_int32_t min, u_int32_t max, u_int32_t spi, bool invert)
 {
-	bool r;
-	pr_debug("spi_match:%c 0x%x <= 0x%x <= 0x%x\n",
-		 invert ? '!' : ' ', min, spi, max);
-	r = (spi >= min && spi <= max) ^ invert;
-	pr_debug(" result %s\n", r ? "PASS" : "FAILED");
-	return r;
+	return (spi >= min && spi <= max) ^ invert;
 }
 
 static bool ah_mt(const struct sk_buff *skb, struct xt_action_param *par)
@@ -42,7 +37,6 @@ static bool ah_mt(const struct sk_buff *skb, struct xt_action_param *par)
 		/* We've been asked to examine this packet, and we
 		 * can't.  Hence, no choice but to drop.
 		 */
-		pr_debug("Dropping evil AH tinygram.\n");
 		par->hotdrop = true;
 		return false;
 	}
@@ -58,7 +52,7 @@ static int ah_mt_check(const struct xt_mtchk_param *par)
 
 	/* Must specify no unknown invflags */
 	if (ahinfo->invflags & ~IPT_AH_INV_MASK) {
-		pr_debug("unknown flags %X\n", ahinfo->invflags);
+		pr_info_ratelimited("unknown flags %X\n", ahinfo->invflags);
 		return -EINVAL;
 	}
 	return 0;
diff --git a/net/ipv6/netfilter/ip6t_ah.c b/net/ipv6/netfilter/ip6t_ah.c
index 1258783ed876..dab7dbc6a675 100644
--- a/net/ipv6/netfilter/ip6t_ah.c
+++ b/net/ipv6/netfilter/ip6t_ah.c
@@ -24,13 +24,7 @@ MODULE_AUTHOR("Andras Kis-Szabo <kisza@sch.bme.hu>");
 static inline bool
 spi_match(u_int32_t min, u_int32_t max, u_int32_t spi, bool invert)
 {
-	bool r;
-
-	pr_debug("spi_match:%c 0x%x <= 0x%x <= 0x%x\n",
-		 invert ? '!' : ' ', min, spi, max);
-	r = (spi >= min && spi <= max) ^ invert;
-	pr_debug(" result %s\n", r ? "PASS" : "FAILED");
-	return r;
+	return (spi >= min && spi <= max) ^ invert;
 }
 
 static bool ah_mt6(const struct sk_buff *skb, struct xt_action_param *par)
@@ -62,23 +56,6 @@ static bool ah_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 		return false;
 	}
 
-	pr_debug("IPv6 AH LEN %u %u ", hdrlen, ah->hdrlen);
-	pr_debug("RES %04X ", ah->reserved);
-	pr_debug("SPI %u %08X\n", ntohl(ah->spi), ntohl(ah->spi));
-
-	pr_debug("IPv6 AH spi %02X ",
-		 spi_match(ahinfo->spis[0], ahinfo->spis[1],
-			   ntohl(ah->spi),
-			   !!(ahinfo->invflags & IP6T_AH_INV_SPI)));
-	pr_debug("len %02X %04X %02X ",
-		 ahinfo->hdrlen, hdrlen,
-		 (!ahinfo->hdrlen ||
-		  (ahinfo->hdrlen == hdrlen) ^
-		  !!(ahinfo->invflags & IP6T_AH_INV_LEN)));
-	pr_debug("res %02X %04X %02X\n",
-		 ahinfo->hdrres, ah->reserved,
-		 !(ahinfo->hdrres && ah->reserved));
-
 	return spi_match(ahinfo->spis[0], ahinfo->spis[1],
 			  ntohl(ah->spi),
 			  !!(ahinfo->invflags & IP6T_AH_INV_SPI)) &&
@@ -93,7 +70,7 @@ static int ah_mt6_check(const struct xt_mtchk_param *par)
 	const struct ip6t_ah *ahinfo = par->matchinfo;
 
 	if (ahinfo->invflags & ~IP6T_AH_INV_MASK) {
-		pr_debug("unknown flags %X\n", ahinfo->invflags);
+		pr_info_ratelimited("unknown flags %X\n", ahinfo->invflags);
 		return -EINVAL;
 	}
 	return 0;
diff --git a/net/ipv6/netfilter/ip6t_frag.c b/net/ipv6/netfilter/ip6t_frag.c
index 3aad6439386b..f5f3cfb8704c 100644
--- a/net/ipv6/netfilter/ip6t_frag.c
+++ b/net/ipv6/netfilter/ip6t_frag.c
@@ -23,12 +23,7 @@ MODULE_AUTHOR("Andras Kis-Szabo <kisza@sch.bme.hu>");
 static inline bool
 id_match(u_int32_t min, u_int32_t max, u_int32_t id, bool invert)
 {
-	bool r;
-	pr_debug("id_match:%c 0x%x <= 0x%x <= 0x%x\n", invert ? '!' : ' ',
-		 min, id, max);
-	r = (id >= min && id <= max) ^ invert;
-	pr_debug(" result %s\n", r ? "PASS" : "FAILED");
-	return r;
+	return (id >= min && id <= max) ^ invert;
 }
 
 static bool
@@ -53,38 +48,6 @@ frag_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 		return false;
 	}
 
-	pr_debug("INFO %04X ", fh->frag_off);
-	pr_debug("OFFSET %04X ", ntohs(fh->frag_off) & ~0x7);
-	pr_debug("RES %02X %04X", fh->reserved, ntohs(fh->frag_off) & 0x6);
-	pr_debug("MF %04X ", fh->frag_off & htons(IP6_MF));
-	pr_debug("ID %u %08X\n", ntohl(fh->identification),
-		 ntohl(fh->identification));
-
-	pr_debug("IPv6 FRAG id %02X ",
-		 id_match(fraginfo->ids[0], fraginfo->ids[1],
-			  ntohl(fh->identification),
-			  !!(fraginfo->invflags & IP6T_FRAG_INV_IDS)));
-	pr_debug("res %02X %02X%04X %02X ",
-		 fraginfo->flags & IP6T_FRAG_RES, fh->reserved,
-		 ntohs(fh->frag_off) & 0x6,
-		 !((fraginfo->flags & IP6T_FRAG_RES) &&
-		   (fh->reserved || (ntohs(fh->frag_off) & 0x06))));
-	pr_debug("first %02X %02X %02X ",
-		 fraginfo->flags & IP6T_FRAG_FST,
-		 ntohs(fh->frag_off) & ~0x7,
-		 !((fraginfo->flags & IP6T_FRAG_FST) &&
-		   (ntohs(fh->frag_off) & ~0x7)));
-	pr_debug("mf %02X %02X %02X ",
-		 fraginfo->flags & IP6T_FRAG_MF,
-		 ntohs(fh->frag_off) & IP6_MF,
-		 !((fraginfo->flags & IP6T_FRAG_MF) &&
-		   !((ntohs(fh->frag_off) & IP6_MF))));
-	pr_debug("last %02X %02X %02X\n",
-		 fraginfo->flags & IP6T_FRAG_NMF,
-		 ntohs(fh->frag_off) & IP6_MF,
-		 !((fraginfo->flags & IP6T_FRAG_NMF) &&
-		   (ntohs(fh->frag_off) & IP6_MF)));
-
 	return id_match(fraginfo->ids[0], fraginfo->ids[1],
 			 ntohl(fh->identification),
 			 !!(fraginfo->invflags & IP6T_FRAG_INV_IDS)) &&
@@ -103,7 +66,7 @@ static int frag_mt6_check(const struct xt_mtchk_param *par)
 	const struct ip6t_frag *fraginfo = par->matchinfo;
 
 	if (fraginfo->invflags & ~IP6T_FRAG_INV_MASK) {
-		pr_debug("unknown flags %X\n", fraginfo->invflags);
+		pr_info_ratelimited("unknown flags %X\n", fraginfo->invflags);
 		return -EINVAL;
 	}
 	return 0;
diff --git a/net/ipv6/netfilter/ip6t_hbh.c b/net/ipv6/netfilter/ip6t_hbh.c
index 6d1a5d2026a6..37c207d3152a 100644
--- a/net/ipv6/netfilter/ip6t_hbh.c
+++ b/net/ipv6/netfilter/ip6t_hbh.c
@@ -79,14 +79,6 @@ hbh_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 		return false;
 	}
 
-	pr_debug("IPv6 OPTS LEN %u %u ", hdrlen, oh->hdrlen);
-
-	pr_debug("len %02X %04X %02X ",
-		 optinfo->hdrlen, hdrlen,
-		 (!(optinfo->flags & IP6T_OPTS_LEN) ||
-		  ((optinfo->hdrlen == hdrlen) ^
-		   !!(optinfo->invflags & IP6T_OPTS_INV_LEN))));
-
 	ret = (!(optinfo->flags & IP6T_OPTS_LEN) ||
 	       ((optinfo->hdrlen == hdrlen) ^
 		!!(optinfo->invflags & IP6T_OPTS_INV_LEN)));
@@ -96,8 +88,6 @@ hbh_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 	if (!(optinfo->flags & IP6T_OPTS_OPTS)) {
 		return ret;
 	} else {
-		pr_debug("Strict ");
-		pr_debug("#%d ", optinfo->optsnr);
 		for (temp = 0; temp < optinfo->optsnr; temp++) {
 			/* type field exists ? */
 			if (hdrlen < 1)
@@ -108,13 +98,9 @@ hbh_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 				break;
 
 			/* Type check */
-			if (*tp != (optinfo->opts[temp] & 0xFF00) >> 8) {
-				pr_debug("Tbad %02X %02X\n", *tp,
-					 (optinfo->opts[temp] & 0xFF00) >> 8);
+			if (*tp != (optinfo->opts[temp] & 0xFF00) >> 8)
 				return false;
-			} else {
-				pr_debug("Tok ");
-			}
+
 			/* Length check */
 			if (*tp) {
 				u16 spec_len;
@@ -129,26 +115,18 @@ hbh_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 					break;
 				spec_len = optinfo->opts[temp] & 0x00FF;
 
-				if (spec_len != 0x00FF && spec_len != *lp) {
-					pr_debug("Lbad %02X %04X\n", *lp,
-						 spec_len);
+				if (spec_len != 0x00FF && spec_len != *lp)
 					return false;
-				}
-				pr_debug("Lok ");
+
 				optlen = *lp + 2;
 			} else {
-				pr_debug("Pad1\n");
 				optlen = 1;
 			}
 
-			/* Step to the next */
-			pr_debug("len%04X\n", optlen);
-
 			if ((ptr > skb->len - optlen || hdrlen < optlen) &&
-			    temp < optinfo->optsnr - 1) {
-				pr_debug("new pointer is too large!\n");
+			    temp < optinfo->optsnr - 1)
 				break;
-			}
+
 			ptr += optlen;
 			hdrlen -= optlen;
 		}
@@ -166,16 +144,16 @@ static int hbh_mt6_check(const struct xt_mtchk_param *par)
 	const struct ip6t_opts *optsinfo = par->matchinfo;
 
 	if (optsinfo->invflags & ~IP6T_OPTS_INV_MASK) {
-		pr_debug("unknown flags %X\n", optsinfo->invflags);
+		pr_info_ratelimited("unknown flags %X\n", optsinfo->invflags);
 		return -EINVAL;
 	}
 	if (optsinfo->optsnr > IP6T_OPTS_OPTSNR) {
-		pr_debug("too many supported opts specified\n");
+		pr_info_ratelimited("too many supported opts specified\n");
 		return -EINVAL;
 	}
 
 	if (optsinfo->flags & IP6T_OPTS_NSTRICT) {
-		pr_debug("Not strict - not implemented");
+		pr_info_ratelimited("Not strict - not implemented");
 		return -EINVAL;
 	}
 
diff --git a/net/ipv6/netfilter/ip6t_mh.c b/net/ipv6/netfilter/ip6t_mh.c
index fd492b69acbc..ba6dcc7791a0 100644
--- a/net/ipv6/netfilter/ip6t_mh.c
+++ b/net/ipv6/netfilter/ip6t_mh.c
@@ -42,14 +42,11 @@ static bool mh_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 	if (mh == NULL) {
 		/* We've been asked to examine this packet, and we
 		   can't.  Hence, no choice but to drop. */
-		pr_debug("Dropping evil MH tinygram.\n");
 		par->hotdrop = true;
 		return false;
 	}
 
 	if (mh->ip6mh_proto != IPPROTO_NONE) {
-		pr_debug("Dropping invalid MH Payload Proto: %u\n",
-			 mh->ip6mh_proto);
 		par->hotdrop = true;
 		return false;
 	}
diff --git a/net/ipv6/netfilter/ip6t_rt.c b/net/ipv6/netfilter/ip6t_rt.c
index 278b52752f36..0c01ac2746d1 100644
--- a/net/ipv6/netfilter/ip6t_rt.c
+++ b/net/ipv6/netfilter/ip6t_rt.c
@@ -155,18 +155,18 @@ static int rt_mt6_check(const struct xt_mtchk_param *par)
 	const struct ip6t_rt *rtinfo = par->matchinfo;
 
 	if (rtinfo->invflags & ~IP6T_RT_INV_MASK) {
-		pr_debug("unknown flags %X\n", rtinfo->invflags);
+		pr_info_ratelimited("unknown flags %X\n", rtinfo->invflags);
 		return -EINVAL;
 	}
 	if (rtinfo->addrnr > IP6T_RT_HOPS) {
-		pr_debug("too many addresses specified\n");
+		pr_info_ratelimited("too many addresses specified\n");
 		return -EINVAL;
 	}
 	if ((rtinfo->flags & (IP6T_RT_RES | IP6T_RT_FST_MASK)) &&
 	    (!(rtinfo->flags & IP6T_RT_TYP) ||
 	     (rtinfo->rt_type != 0) ||
 	     (rtinfo->invflags & IP6T_RT_INV_TYP))) {
-		pr_debug("`--rt-type 0' required before `--rt-0-*'");
+		pr_info_ratelimited("`--rt-type 0' required before `--rt-0-*'");
 		return -EINVAL;
 	}
 
diff --git a/net/netfilter/xt_IDLETIMER.c b/net/netfilter/xt_IDLETIMER.c
index bfcf2d44e93d..15b698ea98aa 100644
--- a/net/netfilter/xt_IDLETIMER.c
+++ b/net/netfilter/xt_IDLETIMER.c
@@ -102,8 +102,6 @@ static void idletimer_tg_expired(struct timer_list *t)
 {
 	struct idletimer_tg *timer = timer_container_of(timer, t, timer);
 
-	pr_debug("timer %s expired\n", timer->attr.attr.name);
-
 	schedule_work(&timer->work);
 }
 
@@ -111,7 +109,6 @@ static void idletimer_tg_alarmproc(struct alarm *alarm, ktime_t now)
 {
 	struct idletimer_tg *timer = alarm->data;
 
-	pr_debug("alarm %s expired\n", timer->attr.attr.name);
 	schedule_work(&timer->work);
 }
 
@@ -171,7 +168,7 @@ static int idletimer_tg_create(struct idletimer_tg_info *info)
 
 	ret = sysfs_create_file(idletimer_tg_kobj, &info->timer->attr.attr);
 	if (ret < 0) {
-		pr_debug("couldn't add file to sysfs");
+		pr_info_ratelimited("couldn't add file to sysfs");
 		goto out_free_attr;
 	}
 
@@ -220,7 +217,7 @@ static int idletimer_tg_create_v1(struct idletimer_tg_info_v1 *info)
 
 	ret = sysfs_create_file(idletimer_tg_kobj, &info->timer->attr.attr);
 	if (ret < 0) {
-		pr_debug("couldn't add file to sysfs");
+		pr_info_ratelimited("couldn't add file to sysfs");
 		goto out_free_attr;
 	}
 
@@ -228,7 +225,6 @@ static int idletimer_tg_create_v1(struct idletimer_tg_info_v1 *info)
 	kobject_uevent(idletimer_tg_kobj,KOBJ_ADD);
 
 	list_add(&info->timer->entry, &idletimer_tg_list);
-	pr_debug("timer type value is %u", info->timer_type);
 	info->timer->timer_type = info->timer_type;
 	info->timer->refcnt = 1;
 
@@ -263,9 +259,6 @@ static unsigned int idletimer_tg_target(struct sk_buff *skb,
 {
 	const struct idletimer_tg_info *info = par->targinfo;
 
-	pr_debug("resetting timer %s, timeout period %u\n",
-		 info->label, info->timeout);
-
 	mod_timer(&info->timer->timer,
 		  secs_to_jiffies(info->timeout) + jiffies);
 
@@ -280,9 +273,6 @@ static unsigned int idletimer_tg_target_v1(struct sk_buff *skb,
 {
 	const struct idletimer_tg_info_v1 *info = par->targinfo;
 
-	pr_debug("resetting timer %s, timeout period %u\n",
-		 info->label, info->timeout);
-
 	if (info->timer->timer_type & XT_IDLETIMER_ALARM) {
 		idletimer_start_alarm_sec(info->timer, info->timeout);
 	} else {
@@ -296,17 +286,17 @@ static unsigned int idletimer_tg_target_v1(struct sk_buff *skb,
 static int idletimer_tg_helper(struct idletimer_tg_info *info)
 {
 	if (info->timeout == 0) {
-		pr_debug("timeout value is zero\n");
+		pr_info_ratelimited("timeout value is zero\n");
 		return -EINVAL;
 	}
 	if (info->timeout >= INT_MAX / 1000) {
-		pr_debug("timeout value is too big\n");
+		pr_info_ratelimited("timeout value is too big\n");
 		return -EINVAL;
 	}
 	if (info->label[0] == '\0' ||
 	    strnlen(info->label,
 		    MAX_IDLETIMER_LABEL_SIZE) == MAX_IDLETIMER_LABEL_SIZE) {
-		pr_debug("label is empty or not nul-terminated\n");
+		pr_info_ratelimited("label is empty or not nul-terminated\n");
 		return -EINVAL;
 	}
 	return 0;
@@ -318,34 +308,25 @@ static int idletimer_tg_checkentry(const struct xt_tgchk_param *par)
 	struct idletimer_tg_info *info = par->targinfo;
 	int ret;
 
-	pr_debug("checkentry targinfo%s\n", info->label);
-
 	ret = idletimer_tg_helper(info);
 	if(ret < 0)
-	{
-		pr_debug("checkentry helper return invalid\n");
 		return -EINVAL;
-	}
 	mutex_lock(&list_mutex);
 
 	info->timer = __idletimer_tg_find_by_label(info->label);
 	if (info->timer) {
 		if (info->timer->timer_type & XT_IDLETIMER_ALARM) {
-			pr_debug("Adding/Replacing rule with same label and different timer type is not allowed\n");
 			mutex_unlock(&list_mutex);
+			pr_info_ratelimited("Adding/Replacing rule with same label and different timer type is not allowed\n");
 			return -EINVAL;
 		}
 
 		info->timer->refcnt++;
 		mod_timer(&info->timer->timer,
 			  secs_to_jiffies(info->timeout) + jiffies);
-
-		pr_debug("increased refcnt of timer %s to %u\n",
-			 info->label, info->timer->refcnt);
 	} else {
 		ret = idletimer_tg_create(info);
 		if (ret < 0) {
-			pr_debug("failed to create timer\n");
 			mutex_unlock(&list_mutex);
 			return ret;
 		}
@@ -360,30 +341,23 @@ static int idletimer_tg_checkentry_v1(const struct xt_tgchk_param *par)
 	struct idletimer_tg_info_v1 *info = par->targinfo;
 	int ret;
 
-	pr_debug("checkentry targinfo%s\n", info->label);
-
 	if (info->send_nl_msg)
 		return -EOPNOTSUPP;
 
 	ret = idletimer_tg_helper((struct idletimer_tg_info *)info);
 	if(ret < 0)
-	{
-		pr_debug("checkentry helper return invalid\n");
 		return -EINVAL;
-	}
 
-	if (info->timer_type > XT_IDLETIMER_ALARM) {
-		pr_debug("invalid value for timer type\n");
+	if (info->timer_type > XT_IDLETIMER_ALARM)
 		return -EINVAL;
-	}
 
 	mutex_lock(&list_mutex);
 
 	info->timer = __idletimer_tg_find_by_label(info->label);
 	if (info->timer) {
 		if (info->timer->timer_type != info->timer_type) {
-			pr_debug("Adding/Replacing rule with same label and different timer type is not allowed\n");
 			mutex_unlock(&list_mutex);
+			pr_info_ratelimited("Adding/Replacing rule with same label and different timer type is not allowed\n");
 			return -EINVAL;
 		}
 
@@ -393,21 +367,15 @@ static int idletimer_tg_checkentry_v1(const struct xt_tgchk_param *par)
 			ktime_t tout = alarm_expires_remaining(&info->timer->alarm);
 			struct timespec64 ktimespec = ktime_to_timespec64(tout);
 
-			if (ktimespec.tv_sec > 0) {
-				pr_debug("time_expiry_remaining %lld\n",
-					 ktimespec.tv_sec);
+			if (ktimespec.tv_sec > 0)
 				idletimer_start_alarm_ktime(info->timer, tout);
-			}
 		} else {
 				mod_timer(&info->timer->timer,
 					secs_to_jiffies(info->timeout) + jiffies);
 		}
-		pr_debug("increased refcnt of timer %s to %u\n",
-			 info->label, info->timer->refcnt);
 	} else {
 		ret = idletimer_tg_create_v1(info);
 		if (ret < 0) {
-			pr_debug("failed to create timer\n");
 			mutex_unlock(&list_mutex);
 			return ret;
 		}
@@ -421,19 +389,13 @@ static void idletimer_tg_destroy(const struct xt_tgdtor_param *par)
 {
 	const struct idletimer_tg_info *info = par->targinfo;
 
-	pr_debug("destroy targinfo %s\n", info->label);
-
 	mutex_lock(&list_mutex);
 
 	if (--info->timer->refcnt > 0) {
-		pr_debug("decreased refcnt of timer %s to %u\n",
-			 info->label, info->timer->refcnt);
 		mutex_unlock(&list_mutex);
 		return;
 	}
 
-	pr_debug("deleting timer %s\n", info->label);
-
 	list_del(&info->timer->entry);
 	mutex_unlock(&list_mutex);
 
@@ -448,19 +410,13 @@ static void idletimer_tg_destroy_v1(const struct xt_tgdtor_param *par)
 {
 	const struct idletimer_tg_info_v1 *info = par->targinfo;
 
-	pr_debug("destroy targinfo %s\n", info->label);
-
 	mutex_lock(&list_mutex);
 
 	if (--info->timer->refcnt > 0) {
-		pr_debug("decreased refcnt of timer %s to %u\n",
-			 info->label, info->timer->refcnt);
 		mutex_unlock(&list_mutex);
 		return;
 	}
 
-	pr_debug("deleting timer %s\n", info->label);
-
 	list_del(&info->timer->entry);
 	mutex_unlock(&list_mutex);
 
@@ -534,7 +490,7 @@ static int __init idletimer_tg_init(void)
 	idletimer_tg_class = class_create("xt_idletimer");
 	err = PTR_ERR(idletimer_tg_class);
 	if (IS_ERR(idletimer_tg_class)) {
-		pr_debug("couldn't register device class\n");
+		pr_info_ratelimited("couldn't register device class\n");
 		goto out;
 	}
 
@@ -542,7 +498,7 @@ static int __init idletimer_tg_init(void)
 					    MKDEV(0, 0), NULL, "timers");
 	err = PTR_ERR(idletimer_tg_device);
 	if (IS_ERR(idletimer_tg_device)) {
-		pr_debug("couldn't register system device\n");
+		pr_info_ratelimited("couldn't register system device\n");
 		goto out_class;
 	}
 
@@ -551,7 +507,7 @@ static int __init idletimer_tg_init(void)
 	err = xt_register_targets(idletimer_tg, ARRAY_SIZE(idletimer_tg));
 
 	if (err < 0) {
-		pr_debug("couldn't register xt target\n");
+		pr_info_ratelimited("couldn't register xt target\n");
 		goto out_dev;
 	}
 
diff --git a/net/netfilter/xt_LOG.c b/net/netfilter/xt_LOG.c
index f39244f9c0ed..de3f176792a0 100644
--- a/net/netfilter/xt_LOG.c
+++ b/net/netfilter/xt_LOG.c
@@ -50,12 +50,12 @@ static int log_tg_check(const struct xt_tgchk_param *par)
 		return -EINVAL;
 
 	if (loginfo->level >= 8) {
-		pr_debug("level %u >= 8\n", loginfo->level);
+		pr_info_ratelimited("level %u >= 8\n", loginfo->level);
 		return -EINVAL;
 	}
 
 	if (loginfo->prefix[sizeof(loginfo->prefix)-1] != '\0') {
-		pr_debug("prefix is not null-terminated\n");
+		pr_info_ratelimited("prefix is not null-terminated\n");
 		return -EINVAL;
 	}
 
diff --git a/net/netfilter/xt_MASQUERADE.c b/net/netfilter/xt_MASQUERADE.c
index eae05c178336..cea488cec544 100644
--- a/net/netfilter/xt_MASQUERADE.c
+++ b/net/netfilter/xt_MASQUERADE.c
@@ -21,11 +21,11 @@ static int masquerade_tg_check(const struct xt_tgchk_param *par)
 	const struct nf_nat_ipv4_multi_range_compat *mr = par->targinfo;
 
 	if (mr->range[0].flags & NF_NAT_RANGE_MAP_IPS) {
-		pr_debug("bad MAP_IPS.\n");
+		pr_info_ratelimited("bad MAP_IPS.\n");
 		return -EINVAL;
 	}
 	if (mr->rangesize != 1) {
-		pr_debug("bad rangesize %u\n", mr->rangesize);
+		pr_info_ratelimited("bad rangesize %u\n", mr->rangesize);
 		return -EINVAL;
 	}
 	return nf_ct_netns_get(par->net, par->family);
diff --git a/net/netfilter/xt_NETMAP.c b/net/netfilter/xt_NETMAP.c
index cb2ee80d84fa..8c86d9a43373 100644
--- a/net/netfilter/xt_NETMAP.c
+++ b/net/netfilter/xt_NETMAP.c
@@ -106,11 +106,11 @@ static int netmap_tg4_check(const struct xt_tgchk_param *par)
 	const struct nf_nat_ipv4_multi_range_compat *mr = par->targinfo;
 
 	if (!(mr->range[0].flags & NF_NAT_RANGE_MAP_IPS)) {
-		pr_debug("bad MAP_IPS.\n");
+		pr_info_ratelimited("bad MAP_IPS.\n");
 		return -EINVAL;
 	}
 	if (mr->rangesize != 1) {
-		pr_debug("bad rangesize %u.\n", mr->rangesize);
+		pr_info_ratelimited("bad rangesize %u.\n", mr->rangesize);
 		return -EINVAL;
 	}
 	return nf_ct_netns_get(par->net, par->family);
diff --git a/net/netfilter/xt_REDIRECT.c b/net/netfilter/xt_REDIRECT.c
index ff66b56a3f97..27bc0545c4f7 100644
--- a/net/netfilter/xt_REDIRECT.c
+++ b/net/netfilter/xt_REDIRECT.c
@@ -51,11 +51,11 @@ static int redirect_tg4_check(const struct xt_tgchk_param *par)
 	const struct nf_nat_ipv4_multi_range_compat *mr = par->targinfo;
 
 	if (mr->range[0].flags & NF_NAT_RANGE_MAP_IPS) {
-		pr_debug("bad MAP_IPS.\n");
+		pr_info_ratelimited("bad MAP_IPS.\n");
 		return -EINVAL;
 	}
 	if (mr->rangesize != 1) {
-		pr_debug("bad rangesize %u.\n", mr->rangesize);
+		pr_info_ratelimited("bad rangesize %u.\n", mr->rangesize);
 		return -EINVAL;
 	}
 	return nf_ct_netns_get(par->net, par->family);
diff --git a/net/netfilter/xt_esp.c b/net/netfilter/xt_esp.c
index 2a1c0ad0ff07..68fd75884268 100644
--- a/net/netfilter/xt_esp.c
+++ b/net/netfilter/xt_esp.c
@@ -25,12 +25,7 @@ MODULE_ALIAS("ip6t_esp");
 static inline bool
 spi_match(u_int32_t min, u_int32_t max, u_int32_t spi, bool invert)
 {
-	bool r;
-	pr_debug("spi_match:%c 0x%x <= 0x%x <= 0x%x\n",
-		 invert ? '!' : ' ', min, spi, max);
-	r = (spi >= min && spi <= max) ^ invert;
-	pr_debug(" result %s\n", r ? "PASS" : "FAILED");
-	return r;
+	return (spi >= min && spi <= max) ^ invert;
 }
 
 static bool esp_mt(const struct sk_buff *skb, struct xt_action_param *par)
@@ -48,7 +43,6 @@ static bool esp_mt(const struct sk_buff *skb, struct xt_action_param *par)
 		/* We've been asked to examine this packet, and we
 		 * can't.  Hence, no choice but to drop.
 		 */
-		pr_debug("Dropping evil ESP tinygram.\n");
 		par->hotdrop = true;
 		return false;
 	}
@@ -62,7 +56,7 @@ static int esp_mt_check(const struct xt_mtchk_param *par)
 	const struct xt_esp *espinfo = par->matchinfo;
 
 	if (espinfo->invflags & ~XT_ESP_INV_MASK) {
-		pr_debug("unknown flags %X\n", espinfo->invflags);
+		pr_info_ratelimited("unknown flags %X\n", espinfo->invflags);
 		return -EINVAL;
 	}
 
diff --git a/net/netfilter/xt_ipcomp.c b/net/netfilter/xt_ipcomp.c
index 472da639a32e..3299c1ea60f9 100644
--- a/net/netfilter/xt_ipcomp.c
+++ b/net/netfilter/xt_ipcomp.c
@@ -29,12 +29,7 @@ MODULE_ALIAS("ip6t_ipcomp");
 static inline bool
 spi_match(u_int32_t min, u_int32_t max, u_int32_t spi, bool invert)
 {
-	bool r;
-	pr_debug("spi_match:%c 0x%x <= 0x%x <= 0x%x\n",
-		 invert ? '!' : ' ', min, spi, max);
-	r = (spi >= min && spi <= max) ^ invert;
-	pr_debug(" result %s\n", r ? "PASS" : "FAILED");
-	return r;
+	return (spi >= min && spi <= max) ^ invert;
 }
 
 static bool comp_mt(const struct sk_buff *skb, struct xt_action_param *par)
@@ -52,7 +47,6 @@ static bool comp_mt(const struct sk_buff *skb, struct xt_action_param *par)
 		/* We've been asked to examine this packet, and we
 		 * can't.  Hence, no choice but to drop.
 		 */
-		pr_debug("Dropping evil IPComp tinygram.\n");
 		par->hotdrop = true;
 		return false;
 	}
diff --git a/net/netfilter/xt_iprange.c b/net/netfilter/xt_iprange.c
index 0c9e014e30b4..bf61141fb785 100644
--- a/net/netfilter/xt_iprange.c
+++ b/net/netfilter/xt_iprange.c
@@ -24,27 +24,15 @@ iprange_mt4(const struct sk_buff *skb, struct xt_action_param *par)
 		m  = ntohl(iph->saddr) < ntohl(info->src_min.ip);
 		m |= ntohl(iph->saddr) > ntohl(info->src_max.ip);
 		m ^= !!(info->flags & IPRANGE_SRC_INV);
-		if (m) {
-			pr_debug("src IP %pI4 NOT in range %s%pI4-%pI4\n",
-			         &iph->saddr,
-			         (info->flags & IPRANGE_SRC_INV) ? "(INV) " : "",
-			         &info->src_min.ip,
-			         &info->src_max.ip);
+		if (m)
 			return false;
-		}
 	}
 	if (info->flags & IPRANGE_DST) {
 		m  = ntohl(iph->daddr) < ntohl(info->dst_min.ip);
 		m |= ntohl(iph->daddr) > ntohl(info->dst_max.ip);
 		m ^= !!(info->flags & IPRANGE_DST_INV);
-		if (m) {
-			pr_debug("dst IP %pI4 NOT in range %s%pI4-%pI4\n",
-			         &iph->daddr,
-			         (info->flags & IPRANGE_DST_INV) ? "(INV) " : "",
-			         &info->dst_min.ip,
-			         &info->dst_max.ip);
+		if (m)
 			return false;
-		}
 	}
 	return true;
 }
@@ -73,27 +61,15 @@ iprange_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 		m  = iprange_ipv6_lt(&iph->saddr, &info->src_min.in6);
 		m |= iprange_ipv6_lt(&info->src_max.in6, &iph->saddr);
 		m ^= !!(info->flags & IPRANGE_SRC_INV);
-		if (m) {
-			pr_debug("src IP %pI6 NOT in range %s%pI6-%pI6\n",
-				 &iph->saddr,
-				 (info->flags & IPRANGE_SRC_INV) ? "(INV) " : "",
-				 &info->src_min.in6,
-				 &info->src_max.in6);
+		if (m)
 			return false;
-		}
 	}
 	if (info->flags & IPRANGE_DST) {
 		m  = iprange_ipv6_lt(&iph->daddr, &info->dst_min.in6);
 		m |= iprange_ipv6_lt(&info->dst_max.in6, &iph->daddr);
 		m ^= !!(info->flags & IPRANGE_DST_INV);
-		if (m) {
-			pr_debug("dst IP %pI6 NOT in range %s%pI6-%pI6\n",
-				 &iph->daddr,
-				 (info->flags & IPRANGE_DST_INV) ? "(INV) " : "",
-				 &info->dst_min.in6,
-				 &info->dst_max.in6);
+		if (m)
 			return false;
-		}
 	}
 	return true;
 }
diff --git a/net/netfilter/xt_ipvs.c b/net/netfilter/xt_ipvs.c
index 253c71cc9a63..e13c0ffb73a9 100644
--- a/net/netfilter/xt_ipvs.c
+++ b/net/netfilter/xt_ipvs.c
@@ -148,7 +148,6 @@ ipvs_mt(const struct sk_buff *skb, struct xt_action_param *par)
 out_put_cp:
 	__ip_vs_conn_put(cp);
 out:
-	pr_debug("match=%d\n", match);
 	return match;
 }
 
diff --git a/net/netfilter/xt_multiport.c b/net/netfilter/xt_multiport.c
index a1691ff405d3..bff5f53a9bef 100644
--- a/net/netfilter/xt_multiport.c
+++ b/net/netfilter/xt_multiport.c
@@ -37,7 +37,6 @@ ports_match_v1(const struct xt_multiport_v1 *minfo,
 		if (minfo->pflags[i]) {
 			/* range port matching */
 			e = minfo->ports[++i];
-			pr_debug("src or dst matches with %d-%d?\n", s, e);
 
 			switch (minfo->flags) {
 			case XT_MULTIPORT_SOURCE:
@@ -58,8 +57,6 @@ ports_match_v1(const struct xt_multiport_v1 *minfo,
 			}
 		} else {
 			/* exact port matching */
-			pr_debug("src or dst matches with %d?\n", s);
-
 			switch (minfo->flags) {
 			case XT_MULTIPORT_SOURCE:
 				if (src == s)
@@ -97,7 +94,6 @@ multiport_mt(const struct sk_buff *skb, struct xt_action_param *par)
 		/* We've been asked to examine this packet, and we
 		 * can't.  Hence, no choice but to drop.
 		 */
-		pr_debug("Dropping evil offset=0 tinygram.\n");
 		par->hotdrop = true;
 		return false;
 	}
diff --git a/net/netfilter/xt_sctp.c b/net/netfilter/xt_sctp.c
index b46a6a512058..d35c21d9651b 100644
--- a/net/netfilter/xt_sctp.c
+++ b/net/netfilter/xt_sctp.c
@@ -48,30 +48,17 @@ match_packet(const struct sk_buff *skb,
 	const struct xt_sctp_flag_info *flag_info = info->flag_info;
 	int flag_count = info->flag_count;
 
-#ifdef DEBUG
-	int i = 0;
-#endif
-
 	if (chunk_match_type == SCTP_CHUNK_MATCH_ALL)
 		SCTP_CHUNKMAP_COPY(chunkmapcopy, info->chunkmap);
 
 	do {
 		sch = skb_header_pointer(skb, offset, sizeof(_sch), &_sch);
 		if (sch == NULL || sch->length == 0) {
-			pr_debug("Dropping invalid SCTP packet.\n");
 			*hotdrop = true;
 			return false;
 		}
-#ifdef DEBUG
-		pr_debug("Chunk num: %d\toffset: %d\ttype: %d\tlength: %d"
-			 "\tflags: %x\n",
-			 ++i, offset, sch->type, htons(sch->length),
-			 sch->flags);
-#endif
 		offset += SCTP_PAD4(ntohs(sch->length));
 
-		pr_debug("skb->len: %d\toffset: %d\n", skb->len, offset);
-
 		if (SCTP_CHUNKMAP_IS_SET(info->chunkmap, sch->type)) {
 			switch (chunk_match_type) {
 			case SCTP_CHUNK_MATCH_ANY:
@@ -121,18 +108,14 @@ sctp_mt(const struct sk_buff *skb, struct xt_action_param *par)
 	const struct sctphdr *sh;
 	struct sctphdr _sh;
 
-	if (par->fragoff != 0) {
-		pr_debug("Dropping non-first fragment.. FIXME\n");
+	if (par->fragoff != 0)
 		return false;
-	}
 
 	sh = skb_header_pointer(skb, par->thoff, sizeof(_sh), &_sh);
 	if (sh == NULL) {
-		pr_debug("Dropping evil TCP offset=0 tinygram.\n");
 		par->hotdrop = true;
 		return false;
 	}
-	pr_debug("spt: %d\tdpt: %d\n", ntohs(sh->source), ntohs(sh->dest));
 
 	return  SCCHECK(ntohs(sh->source) >= info->spts[0]
 			&& ntohs(sh->source) <= info->spts[1],
diff --git a/net/netfilter/xt_tcpudp.c b/net/netfilter/xt_tcpudp.c
index f76cf18f1a24..70608b8d06ab 100644
--- a/net/netfilter/xt_tcpudp.c
+++ b/net/netfilter/xt_tcpudp.c
@@ -44,8 +44,6 @@ tcp_find_option(u_int8_t option,
 	u_int8_t _opt[60 - sizeof(struct tcphdr)];
 	unsigned int i;
 
-	pr_debug("finding option\n");
-
 	if (!optlen)
 		return invert;
 
@@ -81,10 +79,8 @@ static bool tcp_mt(const struct sk_buff *skb, struct xt_action_param *par)
 		   causes this. Its a cracker trying to break in by doing a
 		   flag overwrite to pass the direction checks.
 		*/
-		if (par->fragoff == 1) {
-			pr_debug("Dropping evil TCP offset=1 frag.\n");
+		if (par->fragoff == 1)
 			par->hotdrop = true;
-		}
 		/* Must not be a fragment. */
 		return false;
 	}
@@ -93,7 +89,6 @@ static bool tcp_mt(const struct sk_buff *skb, struct xt_action_param *par)
 	if (th == NULL) {
 		/* We've been asked to examine this packet, and we
 		   can't.  Hence, no choice but to drop. */
-		pr_debug("Dropping evil TCP offset=0 tinygram.\n");
 		par->hotdrop = true;
 		return false;
 	}
@@ -145,7 +140,6 @@ static bool udp_mt(const struct sk_buff *skb, struct xt_action_param *par)
 	if (uh == NULL) {
 		/* We've been asked to examine this packet, and we
 		   can't.  Hence, no choice but to drop. */
-		pr_debug("Dropping evil UDP tinygram.\n");
 		par->hotdrop = true;
 		return false;
 	}
-- 
2.47.3

