Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D443A41
	for <netfilter-devel@vger.kernel.org>; Tue, 23 Sep 2025 15:25:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758641125; cv=none; b=DoO0U1KiTJAQQbiPfBgKDG9Osz3PkSeIm9CR49Iy3htsQS79PE46kkvvfBT3u74QuevJ3cBjNY/0yvm6Jwcw4LnuUlZAi+gC0Upxo5wdCr1TfqYxRfJ8mTdeGaNoY/yDH8BYS3fAn8ucfuQtrrmYZZqP1OI9Zu10T4zbmqc4z7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758641125; c=relaxed/simple;
	bh=EslFBfevB3fs7bl04h6FFk/InN45s5NDPv2rcuou79Q=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Cj1AnDeJ8p14uoi2Ix9a2yAryTk1UGzVxKMnM6yJb4ZulKfHfMa/Pp//SuA8/zXjrFk/X1iGQvM4rsxlKmsRFeZpWyf9L3iu0MZnJrM+q+0zbAiciGtiMin5zyadnL2Gc4EVuapn1chhWI/x51Isr3t759o67vvJL2JvyiDnta8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=ThXK4RNC; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=0KlkPO3U; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=ThXK4RNC; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=0KlkPO3U; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="ThXK4RNC";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="0KlkPO3U";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="ThXK4RNC";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="0KlkPO3U"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 6D58021D39;
	Tue, 23 Sep 2025 15:25:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1758641121; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=LHTpB7ULOqxjA11K+WAQLLc4e5yvpGyaYGE0wqbFHL4=;
	b=ThXK4RNC/XT0L+C5o7+ZnvVtUcyzXTUgjcKAM4+AM9BURpwwaB2AFRPYbcF2pC91r6/xjw
	EuMMKFE3BRGn+b5CB+wzTenHXncgBgKZp756Dp8rw57SFe4uTS9MVkB7ojBoFmE9grxR4l
	gcf8Rk3cN90IO1mV6UrAiINSokAxM9k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1758641121;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=LHTpB7ULOqxjA11K+WAQLLc4e5yvpGyaYGE0wqbFHL4=;
	b=0KlkPO3UAGWyP+0KSJ7JAZ2HIprDm8utE4W6OeAwUh9bkBFqA/doMXhhcQEPTC02ogZGC4
	ECVqEGYZGthN2HBw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ThXK4RNC;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=0KlkPO3U
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1758641121; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=LHTpB7ULOqxjA11K+WAQLLc4e5yvpGyaYGE0wqbFHL4=;
	b=ThXK4RNC/XT0L+C5o7+ZnvVtUcyzXTUgjcKAM4+AM9BURpwwaB2AFRPYbcF2pC91r6/xjw
	EuMMKFE3BRGn+b5CB+wzTenHXncgBgKZp756Dp8rw57SFe4uTS9MVkB7ojBoFmE9grxR4l
	gcf8Rk3cN90IO1mV6UrAiINSokAxM9k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1758641121;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=LHTpB7ULOqxjA11K+WAQLLc4e5yvpGyaYGE0wqbFHL4=;
	b=0KlkPO3UAGWyP+0KSJ7JAZ2HIprDm8utE4W6OeAwUh9bkBFqA/doMXhhcQEPTC02ogZGC4
	ECVqEGYZGthN2HBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 221CD1388C;
	Tue, 23 Sep 2025 15:25:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id R3qTBeG70mgPWQAAD6G6ig
	(envelope-from <fmancera@suse.de>); Tue, 23 Sep 2025 15:25:21 +0000
From: Fernando Fernandez Mancera <fmancera@suse.de>
To: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org,
	pablo@netfilter.org,
	Fernando Fernandez Mancera <fmancera@suse.de>
Subject: [PATCH RFC nf-next] netfilter: nf_tables: add math expression support
Date: Tue, 23 Sep 2025 17:24:52 +0200
Message-ID: <20250923152452.3618-1-fmancera@suse.de>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCPT_COUNT_THREE(0.00)[4];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:dkim,suse.de:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Spam-Flag: NO
X-Spam-Level: 
X-Rspamd-Queue-Id: 6D58021D39
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Score: -3.01

Historically, users have requested support for increasing and decreasing
TTL value in nftables in order to migrate from iptables.

Following the nftables spirit of flexible and multipurpose expressions,
this patch introduces "nft_math" expression. This expression allows to
increase and decrease u32, u16 and u8 values stored in the nftables
registers. In addition, it takes into account the byteorder of the value
stored in the source register, so there is no need to do a byteorder
conversion before and after the math expression.

The math expression intends to be flexible enough in case it needs to be
extended in the future, e.g implement bitfields operations. For this
reason, the length of the data is indicated in bits instead of bytes.

Payload set operations sometimes need 16 bits for checksum
recalculation. Even it is a 8 bit operation, 16 bits are loaded in the
source register. Handle such cases applying a bitmask when operating
with 8 bits length.

As a last detail, nft_math prevents overflow of the field. If the value
is already at its limit, do nothing.

This implementation comes with a libnftnl patch that allows the user to
generate the following example bytecodes:

- Bytecode to increase the TTL of a packet

table mangle inet flags 0 use 1 handle 5
inet mangle output use 1 type filter hook output prio 0 policy accept packets 0 bytes 0 flags 1
inet mangle output 2
  [ payload load 2b @ network header + 8 => reg 1 ]
  [ math math 8 bits host reg 1 + 1 => 1]
  [ payload write reg 1 => 2b @ network header + 8 csum_type 1 csum_off 10 csum_flags 0x0 ]

- Bytecode to decrease the TTL of a packet

table mangle inet flags 0 use 1 handle 7
inet mangle output use 1 type filter hook output prio 0 policy accept packets 0 bytes 0 flags 1
inet mangle output 2
  [ payload load 2b @ network header + 8 => reg 1 ]
  [ math math 8 bits host reg 1 - 1 => 1]
  [ payload write reg 1 => 2b @ network header + 8 csum_type 1 csum_off 10 csum_flags 0x0 ]

- Bytecode to increase the meta mark of a packet

table mangle inet flags 0 use 1 handle 6
inet mangle output use 1 type filter hook output prio 0 policy accept packets 0 bytes 0 flags 1
inet mangle output 2
  [ meta load mark => reg 1 ]
  [ math math 32 bits host reg 1 + 1 => 1]
  [ meta set mark with reg 1 ]

Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
---
 include/uapi/linux/netfilter/nf_tables.h |  34 +++
 net/netfilter/Kconfig                    |   7 +
 net/netfilter/Makefile                   |   1 +
 net/netfilter/nft_math.c                 | 267 +++++++++++++++++++++++
 4 files changed, 309 insertions(+)
 create mode 100644 net/netfilter/nft_math.c

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 7c0c915f0306..d5ec110ede81 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -2015,4 +2015,38 @@ enum nft_tunnel_attributes {
 };
 #define NFTA_TUNNEL_MAX	(__NFTA_TUNNEL_MAX - 1)
 
+/**
+ * enum nft_math_attributes - nftables math expression netlink attributes
+ *
+ * @NFTA_MATH_SREG: source register (NLA_U32: nft_registers)
+ * @NFTA_MATH_DREG: destination register (NLA_U32: nft_registers)
+ * @NFTA_MATH_OP: operation to be performed (NLA_U8)
+ * @NFTA_MATH_LEN: value length in bits (NLA_U8)
+ * @NFTA_MATH_BYTEORDER: byteorder of the value passed to the SREG (NLA_U8)
+ */
+enum nft_math_attributes {
+	NFTA_MATH_UNSPEC,
+	NFTA_MATH_SREG,
+	NFTA_MATH_DREG,
+	NFTA_MATH_OP,
+	NFTA_MATH_LEN,
+	NFTA_MATH_BYTEORDER,
+	__NFTA_MATH_MAX,
+};
+#define NFTA_MATH_MAX (__NFTA_MATH_MAX - 1)
+
+enum nft_math_op {
+	NFT_MATH_OP_INC,
+	NFT_MATH_OP_DEC,
+	__NFT_MATH_OP_MAX,
+};
+#define NFT_MATH_OP_MAX (__NFT_MATH_OP_MAX - 1)
+
+enum nft_math_byteorder {
+	NFT_MATH_BYTEORDER_HOST,
+	NFT_MATH_BYTEORDER_BIG,
+	__NFT_MATH_BYTEORDER_MAX,
+};
+#define NFT_MATH_BYTEORDER_MAX (__NFT_MATH_BYTEORDER_MAX - 1)
+
 #endif /* _LINUX_NF_TABLES_H */
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 6cdc994fdc8a..4cb4fdaedb49 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -671,6 +671,13 @@ config NFT_SYNPROXY
 	  server. This allows to avoid conntrack and server resource usage
 	  during SYN-flood attacks.
 
+config NFT_MATH
+	tristate "Netfilter nf_tables math expression support"
+	depends on NETFILTER_ADVANCED
+	help
+	  The math expression allows performing mathematical operations like
+	  increase, to packet fields.
+
 if NF_TABLES_NETDEV
 
 config NF_DUP_NETDEV
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index e43e20f529f8..bd560aa50ebf 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -131,6 +131,7 @@ obj-$(CONFIG_NFT_OSF)		+= nft_osf.o
 obj-$(CONFIG_NFT_TPROXY)	+= nft_tproxy.o
 obj-$(CONFIG_NFT_XFRM)		+= nft_xfrm.o
 obj-$(CONFIG_NFT_SYNPROXY)	+= nft_synproxy.o
+obj-$(CONFIG_NFT_MATH)		+= nft_math.o
 
 obj-$(CONFIG_NFT_NAT)		+= nft_chain_nat.o
 
diff --git a/net/netfilter/nft_math.c b/net/netfilter/nft_math.c
new file mode 100644
index 000000000000..fe2d1c6a8fbf
--- /dev/null
+++ b/net/netfilter/nft_math.c
@@ -0,0 +1,267 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <net/netlink.h>
+#include <net/netfilter/nf_tables.h>
+#include <linux/netfilter/nf_tables.h>
+
+struct nft_math {
+	u8		 	sreg;
+	u8		 	dreg;
+	u8		 	len;
+	enum nft_math_op	op;
+	enum nft_math_byteorder byteorder;
+};
+
+static const struct nla_policy nft_math_policy[NFTA_MATH_MAX + 1] = {
+	[NFTA_MATH_SREG]	= { .type = NLA_U32 },
+	[NFTA_MATH_DREG]	= { .type = NLA_U32 },
+	[NFTA_MATH_OP]		= { .type = NLA_U8 },
+	[NFTA_MATH_LEN]		= NLA_POLICY_MIN(NLA_U8, 8),
+	[NFTA_MATH_BYTEORDER]	= { .type = NLA_U8 },
+};
+
+static void nft_math_eval_u8(uint32_t *src, uint32_t *dst,
+			      const struct nft_math *priv)
+{
+	u8 tmp;
+
+	/* For payload set if checksum needs to be adjusted 16 bits are stored
+	 * in the source register instead of 8. Therefore, use a bitmask to
+	 * operate with the less significant byte. */
+	switch (priv->op) {
+	case NFT_MATH_OP_INC:
+		tmp = *src & 0xff;
+		if (tmp != U8_MAX) {
+			tmp++;
+			*dst = (*src & ~0xff) | tmp;
+		} else {
+			*dst = *src;
+		}
+		break;
+	case NFT_MATH_OP_DEC:
+		tmp = *src & 0xff;
+		if (tmp != 0) {
+			tmp--;
+			*dst = (*src & ~0xff) | tmp;
+		} else {
+			*dst = *src;
+		}
+		break;
+	default:
+		break;
+	}
+}
+
+static void nft_math_eval_u16(uint32_t *src, uint32_t *dst,
+			      const struct nft_math *priv)
+{
+	u16 tmp;
+
+	switch (priv->op) {
+	case NFT_MATH_OP_INC:
+		switch (priv->byteorder) {
+		case NFT_MATH_BYTEORDER_HOST:
+			tmp = nft_reg_load16(src);
+			if (tmp != U16_MAX)
+				tmp++;
+			nft_reg_store16(dst, tmp);
+			break;
+		case NFT_MATH_BYTEORDER_BIG:
+			tmp = ntohs(nft_reg_load_be16(src));
+			if (tmp != U16_MAX)
+				tmp++;
+			nft_reg_store_be16(dst, htons(tmp));
+			break;
+		default:
+			break;
+		}
+		break;
+	case NFT_MATH_OP_DEC:
+		switch (priv->byteorder) {
+		case NFT_MATH_BYTEORDER_HOST:
+			tmp = nft_reg_load16(src);
+			if (tmp != 0)
+				tmp--;
+			nft_reg_store16(dst, tmp);
+			break;
+		case NFT_MATH_BYTEORDER_BIG:
+			tmp = ntohs(nft_reg_load_be16(src));
+			if (tmp != 0)
+				tmp--;
+			nft_reg_store_be16(dst, htons(tmp));
+			break;
+		default:
+			break;
+		}
+		break;
+	default:
+		break;
+	}
+}
+
+static void nft_math_eval_u32(uint32_t *src, uint32_t *dst,
+			      const struct nft_math *priv)
+{
+	u32 tmp;
+
+	switch (priv->op) {
+	case NFT_MATH_OP_INC:
+		switch (priv->byteorder) {
+		case NFT_MATH_BYTEORDER_HOST:
+			if (*src != U32_MAX)
+				*dst = *src + 1;
+			else
+				*dst = *src;
+			break;
+		case NFT_MATH_BYTEORDER_BIG:
+			tmp = ntohl(*src);
+			if (tmp != U32_MAX)
+				tmp++;
+			*dst = (__force __u32)htonl(tmp);
+			break;
+		default:
+			break;
+		}
+		break;
+	case NFT_MATH_OP_DEC:
+		switch (priv->byteorder) {
+		case NFT_MATH_BYTEORDER_HOST:
+			if (*src != 0)
+				*dst = *src - 1;
+			break;
+		case NFT_MATH_BYTEORDER_BIG:
+			tmp = ntohl(*src);
+			if (tmp != 0)
+				tmp--;
+			*dst = (__force __u32)htonl(tmp);
+			break;
+		default:
+			break;
+		}
+		break;
+	default:
+		break;
+	}
+}
+
+static void nft_math_eval(const struct nft_expr *expr,
+			  struct nft_regs *regs,
+			  const struct nft_pktinfo *pkt)
+{
+	const struct nft_math *priv = nft_expr_priv(expr);
+	u32 *src = &regs->data[priv->sreg];
+	u32 *dst = &regs->data[priv->dreg];
+
+	switch (priv->len) {
+	case 8:
+		nft_math_eval_u8(src, dst, priv);
+		break;
+	case 16:
+		nft_math_eval_u16(src, dst, priv);
+		break;
+	case 32:
+		nft_math_eval_u32(src, dst, priv);
+		break;
+	default:
+		break;
+	}
+}
+
+static int nft_math_init(const struct nft_ctx *ctx,
+			 const struct nft_expr *expr,
+			 const struct nlattr * const tb[])
+{
+	struct nft_math *priv = nft_expr_priv(expr);
+	int err;
+
+	if (tb[NFTA_MATH_SREG] == NULL ||
+	    tb[NFTA_MATH_DREG] == NULL ||
+	    tb[NFTA_MATH_LEN] == NULL ||
+	    tb[NFTA_MATH_OP] == NULL ||
+	    tb[NFTA_MATH_BYTEORDER] == NULL)
+		return -EINVAL;
+
+	priv->op = nla_get_u8(tb[NFTA_MATH_OP]);
+	priv->byteorder = nla_get_u8(tb[NFTA_MATH_BYTEORDER]);
+	priv->len = nla_get_u8(tb[NFTA_MATH_LEN]);
+
+	if (priv->byteorder > NFT_MATH_BYTEORDER_MAX)
+		return -EINVAL;
+
+	if (priv->op > NFT_MATH_OP_MAX)
+		return -EOPNOTSUPP;
+
+	switch (priv->len) {
+	case 8:
+	case 16:
+	case 32:
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	err = nft_parse_register_load(ctx, tb[NFTA_MATH_SREG], &priv->sreg,
+				      priv->len / BITS_PER_BYTE);
+	if (err < 0)
+		return err;
+
+	return nft_parse_register_store(ctx, tb[NFTA_MATH_DREG],
+					&priv->dreg, NULL, NFT_DATA_VALUE,
+					priv->len / BITS_PER_BYTE);
+}
+
+static int nft_math_dump(struct sk_buff *skb,
+			 const struct nft_expr *expr, bool reset)
+{
+	const struct nft_math *priv = nft_expr_priv(expr);
+
+	if (nft_dump_register(skb, NFTA_MATH_SREG, priv->sreg))
+		goto nla_put_failure;
+	if (nft_dump_register(skb, NFTA_MATH_DREG, priv->dreg))
+		goto nla_put_failure;
+	if (nla_put_u8(skb, NFTA_MATH_LEN, priv->len))
+		goto nla_put_failure;
+	if (nla_put_u8(skb, NFTA_MATH_OP, priv->op))
+		goto nla_put_failure;
+	if (nla_put_u8(skb, NFTA_MATH_BYTEORDER, priv->byteorder))
+		goto nla_put_failure;
+	return 0;
+
+nla_put_failure:
+	return -1;
+}
+
+static struct nft_expr_type nft_math_type;
+static const struct nft_expr_ops nft_math_op = {
+	.eval		= nft_math_eval,
+	.size		= NFT_EXPR_SIZE(sizeof(struct nft_math)),
+	.init		= nft_math_init,
+	.dump		= nft_math_dump,
+	.type		= &nft_math_type,
+};
+
+static struct nft_expr_type nft_math_type __read_mostly = {
+	.ops		= &nft_math_op,
+	.name		= "math",
+	.owner		= THIS_MODULE,
+	.policy		= nft_math_policy,
+	.maxattr	= NFTA_MATH_MAX,
+};
+
+static int __init nft_math_module_init(void)
+{
+	return nft_register_expr(&nft_math_type);
+}
+
+static void __exit nft_math_module_exit(void)
+{
+	return nft_unregister_expr(&nft_math_type);
+}
+
+module_init(nft_math_module_init);
+module_exit(nft_math_module_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Fernando Fernandez Mancera <fmancera@suse.de>");
+MODULE_ALIAS_NFT_EXPR("math");
+MODULE_DESCRIPTION("nftables math support to operate with values");
-- 
2.51.0

