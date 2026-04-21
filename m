Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A2A736308D
	for <netfilter-devel@vger.kernel.org>; Tue, 21 Apr 2026 15:59:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776787186; cv=none; b=urNBHE6a7WC7zGxKX3DVXRLtuigyYFpXSnxsujxHSYEeCvsJv30pzO5dLYSR+KGx7OmW8AookEyllc48hiaoAS8Jgde4n4UJ7FlRAUySPGHqga0X8bnV+LWFkMfoy4ks11nx88rY+vUBLJB/q7dVxVeDBGRsTtQRX8eFOVYmNEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776787186; c=relaxed/simple;
	bh=zPE3UKhhk/EVnndzgkhk+hRJsvyTe75LjsDZeWukCrA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TlnKRGLblwjrVOUVsTP+w8bGI5KkOxKpxhgsZ2ns3jxS02e3gYuqRbtXBfA7k2WqaYEQEeoMtxBbdH0phoaSnhPBQ/CAFtOWnibpldhVBL7iXN0ZZZkxPPsly65l4b5gyWAPAwaaqcX6wn+QlQm8EAA94TwwPsC0WGP10SgBM+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Y8EHpmLx; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=u5nE6djo; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Y8EHpmLx; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=u5nE6djo; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Y8EHpmLx";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="u5nE6djo";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Y8EHpmLx";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="u5nE6djo"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 5D4376A7EC;
	Tue, 21 Apr 2026 15:59:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776787183; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=gOYUMpySdcb9AwbtQbqy2D5TlPD3Oke7iB6OguMfQAI=;
	b=Y8EHpmLxajrwS7qHcypv7HAGw85trUKVghzJACFJP8TVP8GGTG6NWZKBwflCgPZEK6VmjI
	fPOxkQk+7w6kNueqpcZo6bb3Yign6t2fHGIKZpgUtrh01ZK26aB0nX65QqwZbibj6HqyOi
	Mpwd9dXuETxkkb/KxQkSefw0zGCraok=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776787183;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=gOYUMpySdcb9AwbtQbqy2D5TlPD3Oke7iB6OguMfQAI=;
	b=u5nE6djodfwv88JyxY+o6oVOXxSfC7K1WnCMmocWtSaz1xyE7C0HMLV8Si2YrXxN8neq+S
	hqf735jthCWo62DA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776787183; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=gOYUMpySdcb9AwbtQbqy2D5TlPD3Oke7iB6OguMfQAI=;
	b=Y8EHpmLxajrwS7qHcypv7HAGw85trUKVghzJACFJP8TVP8GGTG6NWZKBwflCgPZEK6VmjI
	fPOxkQk+7w6kNueqpcZo6bb3Yign6t2fHGIKZpgUtrh01ZK26aB0nX65QqwZbibj6HqyOi
	Mpwd9dXuETxkkb/KxQkSefw0zGCraok=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776787183;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=gOYUMpySdcb9AwbtQbqy2D5TlPD3Oke7iB6OguMfQAI=;
	b=u5nE6djodfwv88JyxY+o6oVOXxSfC7K1WnCMmocWtSaz1xyE7C0HMLV8Si2YrXxN8neq+S
	hqf735jthCWo62DA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E870B593AF;
	Tue, 21 Apr 2026 15:59:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id LkOuNe6e52mtJAAAD6G6ig
	(envelope-from <fmancera@suse.de>); Tue, 21 Apr 2026 15:59:42 +0000
From: Fernando Fernandez Mancera <fmancera@suse.de>
To: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org,
	phil@nwl.cc,
	fw@strlen.de,
	pablo@netfilter.org,
	Fernando Fernandez Mancera <fmancera@suse.de>
Subject: [PATCH nf-next v5] netfilter: nf_tables: add math expression support
Date: Tue, 21 Apr 2026 17:59:00 +0200
Message-ID: <20260421155859.7049-2-fmancera@suse.de>
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
---
 include/uapi/linux/netfilter/nf_tables.h |  25 ++++
 net/netfilter/Kconfig                    |   9 ++
 net/netfilter/Makefile                   |   1 +
 net/netfilter/nft_math.c                 | 157 +++++++++++++++++++++++
 4 files changed, 192 insertions(+)
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
index f3ea0cb26f36..49e723f0dcc8 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -667,6 +667,15 @@ config NFT_SYNPROXY
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
index 000000000000..87dc4ec801d8
--- /dev/null
+++ b/net/netfilter/nft_math.c
@@ -0,0 +1,157 @@
+// SPDX-License-Identifier: GPL-2.0
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
+	[NFTA_MATH_SREG]	= { .type = NLA_U32 },
+	[NFTA_MATH_DREG]	= { .type = NLA_U32 },
+	[NFTA_MATH_OP]		= { .type = NLA_U32 },
+	[NFTA_MATH_BITMASK]	= { .type = NLA_U32 },
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
+		DEBUG_NET_WARN_ONCE(true, "unknown operation path in nft_math");
+		*dst = *src;
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
+	nft_math_eval_bitmask(src, dst, priv);
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
+	op = nla_get_u32(tb[NFTA_MATH_OP]);
+	if (op > NFT_MATH_OP_MAX)
+		return -EOPNOTSUPP;
+	priv->op = op;
+
+	priv->bitmask = nla_get_u32(tb[NFTA_MATH_BITMASK]);
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
+	if (nla_put_u32(skb, NFTA_MATH_BITMASK, priv->bitmask))
+		goto nla_put_failure;
+	if (nla_put_u32(skb, NFTA_MATH_OP, priv->op))
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
2.53.0

