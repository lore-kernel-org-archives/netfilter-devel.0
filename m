Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 037EB4266B1
	for <netfilter-devel@vger.kernel.org>; Wed,  4 Feb 2026 15:24:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218656; cv=none; b=DosvPCZZx/eLajGWv8rxh//5PMAea38QiC9qz5CGgcxoJjP3e1DMwF1Q5ZzqygegdJGVe4KJrzNooLzEvYrSiU+hsQHy+jryhKjCYZAnMUs+FCNMLIPMSTM3FjVJjRCjWh7qzuxAKGe4AzniZCf3Jh2s6ExfdlfzNzr7em1f0no=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218656; c=relaxed/simple;
	bh=BTab8jSI8y7Xhp8gq5GUr43rlsbhORseNGAT39cpxU4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=iNL1XUqfkw2tGeJSpPrgRRY+ZJdyv08E/gs0JNWztNGBjD5a6cACbsPQPyA2iFs7BlaqhtISYq10wBBw0TaAQGoXl2rAmJdtshLVW5jE6JepeZeyB98udLWTfDDcMar6HMVwIGqE0r4tTQt6BKUCUxUYRxZ8TWEguyA4JsdG/Ug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=ZLBVXTry; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=q4LkO+Ei; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=ZLBVXTry; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=q4LkO+Ei; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="ZLBVXTry";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="q4LkO+Ei";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="ZLBVXTry";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="q4LkO+Ei"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 4603F3E74C;
	Wed,  4 Feb 2026 15:24:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1770218654; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=KkJQIigH7MfC9m9BlREZ8erEImMNBAQ5IQUrUKg9z+I=;
	b=ZLBVXTryZ5UZFVgvQCBONp2rvFtMOhjQpL+dvAj6NSe6fbbMgRcXys5D08B/SqrQ9B9Rjh
	2ZIYoTHxCq8STLCzqHy5zZ8m7xFtPeHweYGP5N/miTwWVMn9mm+QyAJsR48sKcjPx3KhB/
	Hf7JGRR9jX/vTSL5s7y2pRxny2GuH24=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1770218654;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=KkJQIigH7MfC9m9BlREZ8erEImMNBAQ5IQUrUKg9z+I=;
	b=q4LkO+EilCfKect6gsRQjFN0xy3oBQzhgkR3gIOMcHoYDBppH+LRy/MPQvyKGgBWIxshKO
	qt/Xa9wGICTE57Bg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1770218654; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=KkJQIigH7MfC9m9BlREZ8erEImMNBAQ5IQUrUKg9z+I=;
	b=ZLBVXTryZ5UZFVgvQCBONp2rvFtMOhjQpL+dvAj6NSe6fbbMgRcXys5D08B/SqrQ9B9Rjh
	2ZIYoTHxCq8STLCzqHy5zZ8m7xFtPeHweYGP5N/miTwWVMn9mm+QyAJsR48sKcjPx3KhB/
	Hf7JGRR9jX/vTSL5s7y2pRxny2GuH24=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1770218654;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=KkJQIigH7MfC9m9BlREZ8erEImMNBAQ5IQUrUKg9z+I=;
	b=q4LkO+EilCfKect6gsRQjFN0xy3oBQzhgkR3gIOMcHoYDBppH+LRy/MPQvyKGgBWIxshKO
	qt/Xa9wGICTE57Bg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BFE8D3EA63;
	Wed,  4 Feb 2026 15:24:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id CzefK51kg2m1QwAAD6G6ig
	(envelope-from <fmancera@suse.de>); Wed, 04 Feb 2026 15:24:13 +0000
From: Fernando Fernandez Mancera <fmancera@suse.de>
To: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org,
	fw@strlen.de,
	pablo@netfilter.org,
	phil@nwl.cc,
	Fernando Fernandez Mancera <fmancera@suse.de>
Subject: [PATCH nf-next v3] netfilter: nf_tables: add math expression support
Date: Wed,  4 Feb 2026 16:23:58 +0100
Message-ID: <20260204152358.11396-1-fmancera@suse.de>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	ARC_NA(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO
X-Spam-Score: -2.80
X-Spam-Level: 

Historically, users have requested support for increasing and decreasing
TTL value in nftables in order to migrate from iptables.

Following the nftables spirit of flexible and multipurpose expressions,
this patch introduces "nft_math" expression. This expression allows to
increase and decrease u32, u16 and u8 values stored in the nftables
registers.

The math expression intends to be flexible enough in case it needs to be
extended in the future, e.g implement bitfields operations. For this
reason, the length of the data is indicated in bits instead of bytes.

When loading a u8 or u16 payload into a register we don't know if the
value is stored at least significant byte or most significant byte. In
order to handle such cases, introduce a bitmask indicating what is the
target bit and also use it to handle limits to prevent overflow.

This implementation comes with a libnftnl patch that allows the user to
generate the following example bytecodes:

- Bytecode to increase the TTL of a packet

table filter inet flags 0 use 1 handle 3
inet filter input use 1 type filter hook input prio 0 policy accept packets 0 bytes 0 flags 1
inet filter input 4
  [ payload load 2b @ network header + 8 => reg 1 ]
  [ math 8 bits mask 0x000000ff reg 1 + 1 => 1]
  [ payload write reg 1 => 2b @ network header + 8 csum_type 1 csum_off 10 csum_flags 0x0 ]

- Bytecode to decrease the TTL of a packet

table filter inet flags 0 use 1 handle 3
inet filter input use 1 type filter hook input prio 0 policy accept packets 0 bytes 0 flags 1
inet filter input 4
  [ payload load 2b @ network header + 8 => reg 1 ]
  [ math 8 bits mask 0x000000ff reg 1 - 1 => 1]
  [ payload write reg 1 => 2b @ network header + 8 csum_type 1 csum_off 10 csum_flags 0x0 ]

- Bytecode to increase the meta mark of a packet

table mangle inet flags 0 use 1 handle 6
inet mangle output use 1 type filter hook output prio 0 policy accept packets 0 bytes 0 flags 1
inet mangle output 2
  [ meta load mark => reg 1 ]
  [ math 32 bits reg 1 + 1 => 1]
  [ meta set mark with reg 1 ]

Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
---
v2: dropped the byteorder netlink attribute, added bitmask to handle
LSB/MSB when dealing with u8 and u16, simplified eval logic. I've kept
nft_math as module, IMHO it would be too much to make it built-in.
v3: fixed checkpatch warnings, improved Kconfig description and fixed a
wrong EINVAL return.
---
 include/uapi/linux/netfilter/nf_tables.h |  27 +++
 net/netfilter/Kconfig                    |   9 +
 net/netfilter/Makefile                   |   1 +
 net/netfilter/nft_math.c                 | 201 +++++++++++++++++++++++
 4 files changed, 238 insertions(+)
 create mode 100644 net/netfilter/nft_math.c

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 45c71f7d21c2..e0a0c7cae1b5 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -2015,4 +2015,31 @@ enum nft_tunnel_attributes {
 };
 #define NFTA_TUNNEL_MAX	(__NFTA_TUNNEL_MAX - 1)
 
+/**
+ * enum nft_math_attributes - nftables math expression netlink attributes
+ *
+ * @NFTA_MATH_SREG: source register (NLA_U32: nft_registers)
+ * @NFTA_MATH_DREG: destination register (NLA_U32: nft_registers)
+ * @NFTA_MATH_OP: operation to be performed (NLA_U32)
+ * @NFTA_MATH_BITMASK: bitmask to be applied on the operation (NLA_U32)
+ * @NFTA_MATH_LEN: value length in bits (NLA_U32)
+ */
+enum nft_math_attributes {
+	NFTA_MATH_UNSPEC,
+	NFTA_MATH_SREG,
+	NFTA_MATH_DREG,
+	NFTA_MATH_OP,
+	NFTA_MATH_BITMASK,
+	NFTA_MATH_LEN,
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
 #endif /* _LINUX_NF_TABLES_H */
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 6cdc994fdc8a..4a0f6e037c61 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -671,6 +671,15 @@ config NFT_SYNPROXY
 	  server. This allows to avoid conntrack and server resource usage
 	  during SYN-flood attacks.
 
+config NFT_MATH
+	tristate "Netfilter nf_tables math expression support"
+	depends on NETFILTER_ADVANCED
+	help
+	  This option enables support for the nftables math expression.
+	  It allows arithmetic operation to be performed on nft registers,
+	  such as incrementing or decrementing values. Math expressions
+	  can be used in nftables rules to modify packet fields.
+
 if NF_TABLES_NETDEV
 
 config NF_DUP_NETDEV
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 6bfc250e474f..fe25b1d1ce0a 100644
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
index 000000000000..dd0022dc5f56
--- /dev/null
+++ b/net/netfilter/nft_math.c
@@ -0,0 +1,201 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <net/netlink.h>
+#include <net/netfilter/nf_tables.h>
+#include <linux/netfilter/nf_tables.h>
+
+struct nft_math {
+	u8			sreg;
+	u8			dreg;
+	u32			len;
+	u32			bitmask;
+	enum nft_math_op	op;
+};
+
+static const struct nla_policy nft_math_policy[NFTA_MATH_MAX + 1] = {
+	[NFTA_MATH_SREG]	= { .type = NLA_U32 },
+	[NFTA_MATH_DREG]	= { .type = NLA_U32 },
+	[NFTA_MATH_OP]		= { .type = NLA_U32 },
+	[NFTA_MATH_BITMASK]	= { .type = NLA_U32 },
+	[NFTA_MATH_LEN]		= NLA_POLICY_MIN(NLA_U32, 8),
+};
+
+static void nft_math_eval_bitmask(u32 *src, u32 *dst,
+				  const struct nft_math *priv)
+{
+	u32 target, keep, bit_unit;
+
+	target = *src & priv->bitmask;
+	keep = *src & ~priv->bitmask;
+	bit_unit = priv->bitmask & -priv->bitmask;
+
+	switch (priv->op) {
+	case NFT_MATH_OP_INC:
+		if (target == priv->bitmask) {
+			*dst = *src;
+			break;
+		}
+
+		target = target + bit_unit;
+		*dst = target | keep;
+		break;
+	case NFT_MATH_OP_DEC:
+		if (!target) {
+			*dst = *src;
+			break;
+		}
+
+		target = target - bit_unit;
+		*dst = target | keep;
+		break;
+	default:
+		break;
+	}
+}
+
+static void nft_math_eval_u32(uint32_t *src, uint32_t *dst,
+			      const struct nft_math *priv)
+{
+	switch (priv->op) {
+	case NFT_MATH_OP_INC:
+		if (*src != U32_MAX)
+			*dst = *src + 1;
+		else
+			*dst = *src;
+		break;
+	case NFT_MATH_OP_DEC:
+		if (*src != 0)
+			*dst = *src - 1;
+		else
+			*dst = *src;
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
+	case 32:
+		nft_math_eval_u32(src, dst, priv);
+		break;
+	default:
+		nft_math_eval_bitmask(src, dst, priv);
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
+	    tb[NFTA_MATH_OP] == NULL)
+		return -EINVAL;
+
+	priv->op = ntohl(nla_get_u32(tb[NFTA_MATH_OP]));
+	priv->len = ntohl(nla_get_u32(tb[NFTA_MATH_LEN]));
+
+	if (tb[NFTA_MATH_BITMASK])
+		priv->bitmask = ntohl(nla_get_u32(tb[NFTA_MATH_BITMASK]));
+
+	if (priv->op > NFT_MATH_OP_MAX)
+		return -EOPNOTSUPP;
+
+	switch (priv->len) {
+	case 8:
+		if (!priv->bitmask)
+			priv->bitmask = 0xff;
+		if (priv->bitmask != 0xff && priv->bitmask != 0xff000000)
+			return -EINVAL;
+		break;
+	case 16:
+		if (!priv->bitmask)
+			priv->bitmask = 0xffff;
+		if (priv->bitmask != 0xffff && priv->bitmask != 0xffff0000)
+			return -EINVAL;
+		break;
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
+	if (priv->bitmask &&
+	    nla_put_u32(skb, NFTA_MATH_BITMASK, htonl(priv->bitmask)))
+		goto nla_put_failure;
+	if (nla_put_u32(skb, NFTA_MATH_OP, htonl(priv->op)))
+		goto nla_put_failure;
+	if (nla_put_u32(skb, NFTA_MATH_LEN, htonl(priv->len)))
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
2.52.0

