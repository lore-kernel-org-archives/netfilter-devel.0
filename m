Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A42024A3847
	for <netfilter-devel@vger.kernel.org>; Fri, 25 Sep 2026 13:50:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790344236; cv=none; b=O54xRyQJbFQGBv8tFns5/HE9WVLGXfZaaWI4kqgSleHA5Wm/OIxBqfQhUDXsdwBWoonbbw/cMkHemJDZZjVieCB5FH8UAgCDUc78X/vVuLhQCwVovGGqgAF16mUFUxuxESsn+qV0oVvo0/x7V+s4uIm59XeVWXE+Mmthoi8WKqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790344236; c=relaxed/simple;
	bh=2nUAvBHoBDAc6COuiUbJ8a8c1UKLw97zrQpnEOHF6hg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DHWME8trEWxgn736rec+HtaTsgBuva1+DxtqJNJZEnZhL+7DXN+xnV4ZL1WAfJaRbi3FZqQv5F71MdcTm22UYMN2FWmXFIoDwiMdEeh7lstpawz8JARxEO8qBN+NZsvL+9zov0NRJTIsTeR2iGPUz3Q2A1JE7bCPeam+XyKYf+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=IQxLzTtL; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=ONAxozdM; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=NOJqzjmF; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Nudo2szi; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="IQxLzTtL";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="ONAxozdM";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="NOJqzjmF";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Nudo2szi"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 417ED21E54;
	Fri, 25 Sep 2026 13:50:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1790344228; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=V0T/vv2+1ttJu//GWuKVgXMphuxAyd0Pp09YPOzekw4=;
	b=IQxLzTtLobdTH01P4Bx/uXaS4d4x/x+pE6GdPW+oPCgYiLj5I+NsqhbOkk/ntNZlIUNDmw
	wXTpm1pDUeDvQ/z2mN5k4Ht2mW8EbwRlReiV6d2dZKUb6NC9vdc66REfaT7QRBkqr3c7OU
	tlccJdj+I9bVdgFIPtVkgJKB3rCKDOM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1790344228;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=V0T/vv2+1ttJu//GWuKVgXMphuxAyd0Pp09YPOzekw4=;
	b=ONAxozdMt1hfH1/iKmjtNpMI534R+ntu+LpCmcepk8+BPyBoSCAM09vZ9c0RNi132/m70+
	bRTcNEu1nGxFX5AQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=NOJqzjmF;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Nudo2szi
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1790344224; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=V0T/vv2+1ttJu//GWuKVgXMphuxAyd0Pp09YPOzekw4=;
	b=NOJqzjmFAp0beMqgfH7yKUCkTTciM3ZIVO0OAotB6nUqlGSqKD/BB/aF0RuuXof+Dez5Or
	fl8k4aL7vlVwrHuEZ3I3aaODlsUQASDQCM83AfRRBH8Z08YcvSDCczPHItcQyWRwyF0oE/
	PC7EMDdj3Iqdr8qIh5i1G8Hw+c1dkWc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1790344224;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=V0T/vv2+1ttJu//GWuKVgXMphuxAyd0Pp09YPOzekw4=;
	b=Nudo2szid6YY5KMts7nMl0YdO5Damq2MOj9CA5Da9FAgN6KQ4YiW6p4tCsM0vjsyOlf1Zm
	m+zS07J4GtKJhMDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B77AC13274;
	Fri, 25 Sep 2026 13:50:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id AaPaIR98tmqJRgAAD6G6ig
	(envelope-from <fmancera@suse.de>); Fri, 25 Sep 2026 13:50:23 +0000
From: Fernando Fernandez Mancera <fmancera@suse.de>
To: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org,
	pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	Fernando Fernandez Mancera <fmancera@suse.de>
Subject: [PATCH nf-next v6] netfilter: nf_tables: add math expression support
Date: Fri, 25 Sep 2026 15:49:52 +0200
Message-ID: <20260925134952.3790-1-fmancera@suse.de>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -3.01
X-Rspamd-Queue-Id: 417ED21E54
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Level: 
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_TLS_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:email,suse.de:mid,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Flag: NO

Historically, users have requested support for increasing and decreasing
TTL value in nftables in order to migrate from iptables.

Following the nftables spirit of flexible and multipurpose expressions,
this patch introduces "nft_math" expression. This expression allows to
increase and decrease values stored in the register.

The math expression intends to be flexible enough in case it needs to be
extended in the future, e.g implement non-contiguous bitfields
operations. But for now, non-contiguous payloads are not supported.

When loading a u8 or u16 payload into a register we don't know if the
value is stored at least significant byte or most significant byte. In
order to handle such cases, introduce a bitmask indicating what is the
target bit and also use it to handle limits to prevent overflow or
underflow. Keep in mind that math expression expects that the sreg and
dreg are in host byteorder, so the user must use nft_byteorder
expressions as needed.

This implementation comes with a libnftnl patch that allows the user to
generate the following example bytecodes:

- Bytecode to increase the TTL of a packet

table filter inet flags 0 use 1 handle 1
inet filter input use 1 type filter hook input prio 0 policy accept packets 0 bytes 0 flags 1
inet filter input 4
  [ payload load 2b @ network header + 8 => reg 1 ]
  [ math mask 0x000000ff reg 1 + 1 => 1]
  [ payload write reg 1 => 2b @ network header + 8 csum_type 1 csum_off 10 csum_flags 0x0 ]

- Bytecode to decrease the TTL of a packet

table filter inet flags 0 use 1 handle 1
inet filter input use 1 type filter hook input prio 0 policy accept packets 0 bytes 0 flags 1
inet filter input 4
  [ payload load 2b @ network header + 8 => reg 1 ]
  [ math mask 0x000000ff reg 1 - 1 => 1]
  [ payload write reg 1 => 2b @ network header + 8 csum_type 1 csum_off 10 csum_flags 0x0 ]

- Bytecode to increase the meta mark of a packet

table mangle inet flags 0 use 1 handle 6
inet mangle output use 1 type filter hook output prio 0 policy accept packets 0 bytes 0 flags 1
inet mangle output 2
  [ meta load mark => reg 1 ]
  [ math mask 0xffffffff reg 1 + 1 => 1]
  [ meta set mark with reg 1 ]

Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
---
v2: dropped the byteorder netlink attribute, added bitmask to handle
LSB/MSB when dealing with u8 and u16, simplified eval logic. I've kept
nft_math as module, IMHO it would be too much to make it built-in.
v3: fixed checkpatch warnings, improved Kconfig description and fixed a
wrong EINVAL return.
v4: removed NFTA_MATH_LEN as discussed with Phil, added a non-contiguous
bitmask check
v5: fixed check on op max value, fixed byteorder inconsistency now
NLA_U32 for both BITMASK and OP attributes
v6: rebased in top of recent changes, simplified eval logic and made all
netlink attributes be32 instead of u32
---
 include/uapi/linux/netfilter/nf_tables.h |  25 ++++
 net/netfilter/Kconfig                    |   9 ++
 net/netfilter/Makefile                   |   1 +
 net/netfilter/nft_math.c                 | 150 +++++++++++++++++++++++
 4 files changed, 185 insertions(+)
 create mode 100644 net/netfilter/nft_math.c

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 0b708153469c..36a5b42c3ddf 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -2019,4 +2019,29 @@ enum nft_tunnel_attributes {
 };
 #define NFTA_TUNNEL_MAX	(__NFTA_TUNNEL_MAX - 1)
 
+/**
+ * enum nft_math_attributes - nftables math expression netlink attributes
+ *
+ * @NFTA_MATH_SREG: source register (NLA_U32: nft_registers)
+ * @NFTA_MATH_DREG: destination register (NLA_U32: nft_registers)
+ * @NFTA_MATH_OP: operation to be performed (NLA_U32)
+ * @NFTA_MATH_BITMASK: bitmask to be applied on the operation (NLA_U32)
+ */
+enum nft_math_attributes {
+	NFTA_MATH_UNSPEC,
+	NFTA_MATH_SREG,
+	NFTA_MATH_DREG,
+	NFTA_MATH_OP,
+	NFTA_MATH_BITMASK,
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
index 09874c26fd13..b2203d7ac08b 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -657,6 +657,15 @@ config NFT_SYNPROXY
 	  server. This allows to avoid conntrack and server resource usage
 	  during SYN-flood attacks.
 
+config NFT_MATH
+	tristate "Netfilter nf_tables math expression support"
+	depends on NETFILTER_ADVANCED
+	help
+	  This option enables support for the nftables math expression.
+	  It allows arithmetic operations to be performed on nft registers
+	  content, such as incrementing or decrementing values. Math
+	  expressions can be used in nftables rules to modify packet fields.
+
 if NF_TABLES_NETDEV
 
 config NF_DUP_NETDEV
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 6bf74d488a29..ee50c2dd1f29 100644
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
index 000000000000..e8b095a3ef73
--- /dev/null
+++ b/net/netfilter/nft_math.c
@@ -0,0 +1,150 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include <net/netlink.h>
+#include <net/netfilter/nf_tables.h>
+
+struct nft_math {
+	u8			sreg;
+	u8			dreg;
+	u32			bitmask;
+	enum nft_math_op	op;
+};
+
+static const struct nla_policy nft_math_policy[NFTA_MATH_MAX + 1] = {
+	[NFTA_MATH_SREG]	= NLA_POLICY_MAX(NLA_BE32, NFT_REG32_MAX),
+	[NFTA_MATH_DREG]	= NLA_POLICY_MAX(NLA_BE32, NFT_REG32_MAX),
+	[NFTA_MATH_OP]		= { .type = NLA_BE32 },
+	[NFTA_MATH_BITMASK]	= { .type = NLA_BE32 },
+};
+
+static void nft_math_eval(const struct nft_expr *expr,
+			  struct nft_regs *regs,
+			  const struct nft_pktinfo *pkt)
+{
+	const struct nft_math *priv = nft_expr_priv(expr);
+	const u32 *src = &regs->data[priv->sreg];
+	u32 *dst = &regs->data[priv->dreg];
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
+		DEBUG_NET_WARN_ONCE(true, "unknown operation in nft_math");
+		*dst = *src;
+		break;
+	}
+}
+
+static int nft_math_init(const struct nft_ctx *ctx,
+			 const struct nft_expr *expr,
+			 const struct nlattr * const tb[])
+{
+	struct nft_math *priv = nft_expr_priv(expr);
+	u32 bitmask_check;
+	int err;
+	u32 op;
+
+	if (!tb[NFTA_MATH_SREG] ||
+	    !tb[NFTA_MATH_DREG] ||
+	    !tb[NFTA_MATH_BITMASK] ||
+	    !tb[NFTA_MATH_OP])
+		return -EINVAL;
+
+	err = nft_parse_u32_check(tb[NFTA_MATH_OP], NFT_MATH_OP_MAX, &op);
+	if (err < 0)
+		return -EOPNOTSUPP;
+	priv->op = op;
+
+	priv->bitmask = ntohl(nla_get_be32(tb[NFTA_MATH_BITMASK]));
+	if (!priv->bitmask)
+		return -EINVAL;
+
+	/* check if the bitmask is contiguous, otherwise reject it */
+	bitmask_check = priv->bitmask + (priv->bitmask & -priv->bitmask);
+	if (bitmask_check & (bitmask_check - 1))
+		return -EINVAL;
+
+	err = nft_parse_register_load(ctx, tb[NFTA_MATH_SREG], &priv->sreg,
+				      sizeof(u32));
+	if (err < 0)
+		return err;
+
+	return nft_parse_register_store(ctx, tb[NFTA_MATH_DREG],
+					&priv->dreg, NULL, NFT_DATA_VALUE,
+					sizeof(u32));
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
+	if (nla_put_be32(skb, NFTA_MATH_BITMASK, htonl(priv->bitmask)))
+		goto nla_put_failure;
+	if (nla_put_be32(skb, NFTA_MATH_OP, htonl(priv->op)))
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
+	nft_unregister_expr(&nft_math_type);
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
2.55.0

