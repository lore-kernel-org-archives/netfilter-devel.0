Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A51137D126
	for <netfilter-devel@vger.kernel.org>; Mon, 20 Apr 2026 17:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776704762; cv=none; b=BRQLN6PyH3FIGvkseIudFgSxIYOdlvw2GA1x9JdpECsHzWV34MMYaLsGWCHMdW8SL+zUjtZFqD9xYhmJMgsLPPiZPJZIQOLSLmDpVqkQCURLcSsH+OTSNe+57oOKqwb/R5OhjVu6K/oH75rzz85W8vWZhH2wpauif0dAw2UcCO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776704762; c=relaxed/simple;
	bh=Wc9XyJvudYZrV2kjFLhnBq5JSK7wWH/1YudY8tnrN4E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=iIxcwwiYYIITtV7KMHr7eYrGoyJ5pQkM1heEy/scLNmfxZtUIUULrU1/8yoVoTyysWCwUARK/KpjFkORXV5s7H+u3uLsP6qGT0CEViU/aPaoya7y8AArNhd3StEh9/rAFbuW4fmbf2SBUSdrvxUDgC+q7vANkENZ0yOtXzOx9TY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=mXGmO8Qf; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=4OBrUyfR; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=mXGmO8Qf; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=4OBrUyfR; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="mXGmO8Qf";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="4OBrUyfR";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="mXGmO8Qf";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="4OBrUyfR"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 591DC6A7E0;
	Mon, 20 Apr 2026 17:05:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776704759; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=MuCLAXW57Q8lA+x75KHGBeAqfdDiS51Udty/IYN6aw0=;
	b=mXGmO8Qf+70lLq3wKYs98bRNAbs7K91w/urRoQbaCGN5bu129JKJDb1l8Lt8CTOxIb/mhp
	OMQCxDQ8lk1PQPr5I7hRzkFUwtArU52iGDo+Oe4MbS5Wx00TSIcO9sPW2PQnN8mW4eFslw
	FybgzBDR/ky2rGL5II8a2YKMVHUxn4A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776704759;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=MuCLAXW57Q8lA+x75KHGBeAqfdDiS51Udty/IYN6aw0=;
	b=4OBrUyfRD1nqDEvQ/g+hk880W5BmlP25kwIQNYEUTWghK5d1DiI+3yWj6MwzO+5bAPVBHg
	pX5bqcFX+eO3RGCg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776704759; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=MuCLAXW57Q8lA+x75KHGBeAqfdDiS51Udty/IYN6aw0=;
	b=mXGmO8Qf+70lLq3wKYs98bRNAbs7K91w/urRoQbaCGN5bu129JKJDb1l8Lt8CTOxIb/mhp
	OMQCxDQ8lk1PQPr5I7hRzkFUwtArU52iGDo+Oe4MbS5Wx00TSIcO9sPW2PQnN8mW4eFslw
	FybgzBDR/ky2rGL5II8a2YKMVHUxn4A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776704759;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=MuCLAXW57Q8lA+x75KHGBeAqfdDiS51Udty/IYN6aw0=;
	b=4OBrUyfRD1nqDEvQ/g+hk880W5BmlP25kwIQNYEUTWghK5d1DiI+3yWj6MwzO+5bAPVBHg
	pX5bqcFX+eO3RGCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id EB9E0593AE;
	Mon, 20 Apr 2026 17:05:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Mh6VNvZc5mn6AgAAD6G6ig
	(envelope-from <fmancera@suse.de>); Mon, 20 Apr 2026 17:05:58 +0000
From: Fernando Fernandez Mancera <fmancera@suse.de>
To: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org,
	phil@nwl.cc,
	fw@strlen.de,
	pablo@netfilter.org,
	Fernando Fernandez Mancera <fmancera@suse.de>
Subject: [PATCH nf-next v4] netfilter: nf_tables: add math expression support
Date: Mon, 20 Apr 2026 19:05:42 +0200
Message-ID: <20260420170541.22039-2-fmancera@suse.de>
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
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:mid,suse.de:email];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RCPT_COUNT_FIVE(0.00)[6];
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
underflow. Keep on mind that math expression expects that the sreg and
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
---
 include/uapi/linux/netfilter/nf_tables.h |  25 ++++
 net/netfilter/Kconfig                    |   9 ++
 net/netfilter/Makefile                   |   1 +
 net/netfilter/nft_math.c                 | 154 +++++++++++++++++++++++
 4 files changed, 189 insertions(+)
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
index 000000000000..d9538e227bbf
--- /dev/null
+++ b/net/netfilter/nft_math.c
@@ -0,0 +1,154 @@
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
+
+	if (!tb[NFTA_MATH_SREG] ||
+	    !tb[NFTA_MATH_DREG] ||
+	    !tb[NFTA_MATH_BITMASK] ||
+	    !tb[NFTA_MATH_OP])
+		return -EINVAL;
+
+	priv->op = ntohl(nla_get_u32(tb[NFTA_MATH_OP]));
+	priv->bitmask = ntohl(nla_get_u32(tb[NFTA_MATH_BITMASK]));
+
+	if (priv->op > NFT_MATH_OP_MAX)
+		return -EOPNOTSUPP;
+
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
+	if (nla_put_u32(skb, NFTA_MATH_BITMASK, htonl(priv->bitmask)))
+		goto nla_put_failure;
+	if (nla_put_u32(skb, NFTA_MATH_OP, htonl(priv->op)))
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

