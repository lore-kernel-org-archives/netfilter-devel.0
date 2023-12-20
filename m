Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AB5C487B4
	for <netfilter-devel@vger.kernel.org>; Wed, 20 Dec 2023 16:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="GsfLt/Y+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=+XtTB3zMYOyr0BxBGjYqyP+JQAj5w7iiAH1nmo6aV7o=; b=GsfLt/Y+EebygwjB3uZUTrbFd8
	clIqY4kA2L6hY2dxaT0MnhI5bbBHwuHb8ad68fgdKR4xHdKBIehx/35nOefKGxlGAHYltiWn8BR8M
	7idpTxBi9XtMs5ePffB9VZgUqpBY2JIIcrLoubGXcGQWi/Ewfo2AHIDjqteOeqbbaqtnCiMwfYNQY
	//+ai9jOCUiVgypUS7PBiKBJ0Qcz5Cjzj33abN2JMg05I+Fu/8XKebdxkKhseTL7x//XOix2pHpDr
	0YUru+0Tbmf/z1Gm7UGd7n75qg4h/yIcPGDZvZPrbkb63zV9pm9y/T3fXKfSKIz0Owoxh6gMyaqan
	numJHadg==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.94.2)
	(envelope-from <phil@nwl.cc>)
	id 1rFz5u-0004MA-IV
	for netfilter-devel@vger.kernel.org; Wed, 20 Dec 2023 17:06:50 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 06/23] extensions: libebt_*: Drop some needless init callbacks
Date: Wed, 20 Dec 2023 17:06:19 +0100
Message-ID: <20231220160636.11778-7-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231220160636.11778-1-phil@nwl.cc>
References: <20231220160636.11778-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Extension data is zero by default.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libebt_802_3.c  |  9 ---------
 extensions/libebt_ip.c     |  9 ---------
 extensions/libebt_ip6.c    | 13 -------------
 extensions/libebt_mark_m.c | 11 -----------
 4 files changed, 42 deletions(-)

diff --git a/extensions/libebt_802_3.c b/extensions/libebt_802_3.c
index f05d02ead5a4a..8cbcdcea4912f 100644
--- a/extensions/libebt_802_3.c
+++ b/extensions/libebt_802_3.c
@@ -36,14 +36,6 @@ static void br802_3_print_help(void)
 "  Type implies SAP value 0xaa\n");
 }
 
-static void br802_3_init(struct xt_entry_match *match)
-{
-	struct ebt_802_3_info *info = (struct ebt_802_3_info *)match->data;
-
-	info->invflags = 0;
-	info->bitmask = 0;
-}
-
 static int
 br802_3_parse(int c, char **argv, int invert, unsigned int *flags,
 	      const void *entry, struct xt_entry_match **match)
@@ -119,7 +111,6 @@ static struct xtables_match br802_3_match =
 	.family		= NFPROTO_BRIDGE,
 	.size		= XT_ALIGN(sizeof(struct ebt_802_3_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct ebt_802_3_info)),
-	.init		= br802_3_init,
 	.help		= br802_3_print_help,
 	.parse		= br802_3_parse,
 	.final_check	= br802_3_final_check,
diff --git a/extensions/libebt_ip.c b/extensions/libebt_ip.c
index 68f34bff97deb..97ec4160942da 100644
--- a/extensions/libebt_ip.c
+++ b/extensions/libebt_ip.c
@@ -69,14 +69,6 @@ static void brip_print_help(void)
 	xt_print_icmp_types(igmp_types, ARRAY_SIZE(igmp_types));
 }
 
-static void brip_init(struct xt_entry_match *match)
-{
-	struct ebt_ip_info *info = (struct ebt_ip_info *)match->data;
-
-	info->invflags = 0;
-	info->bitmask = 0;
-}
-
 static void
 parse_port_range(const char *protocol, const char *portstring, uint16_t *ports)
 {
@@ -503,7 +495,6 @@ static struct xtables_match brip_match = {
 	.family		= NFPROTO_BRIDGE,
 	.size		= XT_ALIGN(sizeof(struct ebt_ip_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct ebt_ip_info)),
-	.init		= brip_init,
 	.help		= brip_print_help,
 	.parse		= brip_parse,
 	.final_check	= brip_final_check,
diff --git a/extensions/libebt_ip6.c b/extensions/libebt_ip6.c
index 18bb2720ccbec..d926e86a585f4 100644
--- a/extensions/libebt_ip6.c
+++ b/extensions/libebt_ip6.c
@@ -127,18 +127,6 @@ static void brip6_print_help(void)
 	xt_print_icmp_types(icmpv6_codes, ARRAY_SIZE(icmpv6_codes));
 }
 
-static void brip6_init(struct xt_entry_match *match)
-{
-	struct ebt_ip6_info *ipinfo = (struct ebt_ip6_info *)match->data;
-
-	ipinfo->invflags = 0;
-	ipinfo->bitmask = 0;
-	memset(ipinfo->saddr.s6_addr, 0, sizeof(ipinfo->saddr.s6_addr));
-	memset(ipinfo->smsk.s6_addr, 0, sizeof(ipinfo->smsk.s6_addr));
-	memset(ipinfo->daddr.s6_addr, 0, sizeof(ipinfo->daddr.s6_addr));
-	memset(ipinfo->dmsk.s6_addr, 0, sizeof(ipinfo->dmsk.s6_addr));
-}
-
 /* wrap xtables_ip6parse_any(), ignoring any but the first returned address */
 static void ebt_parse_ip6_address(char *address,
 				  struct in6_addr *addr, struct in6_addr *msk)
@@ -452,7 +440,6 @@ static struct xtables_match brip6_match = {
 	.family		= NFPROTO_BRIDGE,
 	.size		= XT_ALIGN(sizeof(struct ebt_ip6_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct ebt_ip6_info)),
-	.init		= brip6_init,
 	.help		= brip6_print_help,
 	.parse		= brip6_parse,
 	.final_check	= brip6_final_check,
diff --git a/extensions/libebt_mark_m.c b/extensions/libebt_mark_m.c
index 2462d0af7d0bc..178c9ecef94da 100644
--- a/extensions/libebt_mark_m.c
+++ b/extensions/libebt_mark_m.c
@@ -30,16 +30,6 @@ static void brmark_m_print_help(void)
 "--mark    [!] [value][/mask]: Match nfmask value (see man page)\n");
 }
 
-static void brmark_m_init(struct xt_entry_match *match)
-{
-	struct ebt_mark_m_info *info = (struct ebt_mark_m_info *)match->data;
-
-	info->mark = 0;
-	info->mask = 0;
-	info->invert = 0;
-	info->bitmask = 0;
-}
-
 #define OPT_MARK 0x01
 static int
 brmark_m_parse(int c, char **argv, int invert, unsigned int *flags,
@@ -128,7 +118,6 @@ static struct xtables_match brmark_m_match = {
 	.family		= NFPROTO_BRIDGE,
 	.size		= XT_ALIGN(sizeof(struct ebt_mark_m_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct ebt_mark_m_info)),
-	.init		= brmark_m_init,
 	.help		= brmark_m_print_help,
 	.parse		= brmark_m_parse,
 	.final_check	= brmark_m_final_check,
-- 
2.43.0

