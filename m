Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4214E19ABDE
	for <netfilter-devel@vger.kernel.org>; Mon,  3 Nov 2025 14:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762180311; cv=none; b=vFPJOfJ+nDdoT2ipsjoiVHQoJTq9pR2n6WcBvyIUxuOZz65hApcWADA81YmEKBh528c1SRDQF76ysRbPmbEZwCMtK51RCRYrte8S+OjSGhv2zmWxWwlSrssFjZu84S+gSS/lZ/bMjP6X/GaIAKRx8C9VCantcD/DD+QsYQtfrbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762180311; c=relaxed/simple;
	bh=/Yw0LkrekREtVNPv9uJKwIVaaU8yHOYJtVY9amfHi4Q=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Y6IcEinlLVT+axHEk9Kx7hkKHUm+tqoYl0gBSOzzLyAb1jpO9M0sPU8ODhYPx+m0ffIXJaZvOuT/CdfbKr4yet+gICM5wGvEqT/DN+cmB/r0JFj3JJYxGdx982P0WLVCMNoTAReNpVxVpOdu9P6p0B01kzAzCJsa+DK5us10g3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=lKwD5SZ2; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=dt0sxm/g; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=lKwD5SZ2; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=dt0sxm/g; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="lKwD5SZ2";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="dt0sxm/g";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="lKwD5SZ2";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="dt0sxm/g"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 4A7961F7B3;
	Mon,  3 Nov 2025 14:31:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1762180307; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=QPaQASvaOBEuCg6EviRIDdDW9Z/F+jbcYd5R7J9dhoA=;
	b=lKwD5SZ2N4AG1U/BCUdJYYFxAvpX37XjIYEPEE0nLNZHcbwu+0jSccylIOpSxY6RHfXNHu
	54Rrd5aoG1nT8jh7UMhSWAafrI2Y1/uGunHid3Scgj/21t5nTih/mjkHMzkmxDjoRlx1rq
	ujToknzizUVLlQuhYcDGn11Lmg3m/ek=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1762180307;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=QPaQASvaOBEuCg6EviRIDdDW9Z/F+jbcYd5R7J9dhoA=;
	b=dt0sxm/gMwLL6y5GJLp8Vin3hBgyEGA5ml1ghTZ2XMCs8Mce2r/aBl0RrfOYg09cAe8wLb
	7IoYvdV142n9F8CA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=lKwD5SZ2;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="dt0sxm/g"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1762180307; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=QPaQASvaOBEuCg6EviRIDdDW9Z/F+jbcYd5R7J9dhoA=;
	b=lKwD5SZ2N4AG1U/BCUdJYYFxAvpX37XjIYEPEE0nLNZHcbwu+0jSccylIOpSxY6RHfXNHu
	54Rrd5aoG1nT8jh7UMhSWAafrI2Y1/uGunHid3Scgj/21t5nTih/mjkHMzkmxDjoRlx1rq
	ujToknzizUVLlQuhYcDGn11Lmg3m/ek=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1762180307;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=QPaQASvaOBEuCg6EviRIDdDW9Z/F+jbcYd5R7J9dhoA=;
	b=dt0sxm/gMwLL6y5GJLp8Vin3hBgyEGA5ml1ghTZ2XMCs8Mce2r/aBl0RrfOYg09cAe8wLb
	7IoYvdV142n9F8CA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E9032139A9;
	Mon,  3 Nov 2025 14:31:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id qT0tNtK8CGnjXwAAD6G6ig
	(envelope-from <fmancera@suse.de>); Mon, 03 Nov 2025 14:31:46 +0000
From: Fernando Fernandez Mancera <fmancera@suse.de>
To: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org,
	fw@strlen.de,
	pablo@netfilter.org,
	Fernando Fernandez Mancera <fmancera@suse.de>
Subject: [PATCH nf-next v2] netfilter: nf_tables: add math expression support
Date: Mon,  3 Nov 2025 15:31:34 +0100
Message-ID: <20251103143134.23300-1-fmancera@suse.de>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4A7961F7B3
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	ARC_NA(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_COUNT_TWO(0.00)[2];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.de:email,suse.de:mid,suse.de:dkim];
	RCVD_TLS_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -3.01
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
---
 include/uapi/linux/netfilter/nf_tables.h |  27 +++
 net/netfilter/Kconfig                    |   7 +
 net/netfilter/Makefile                   |   1 +
 net/netfilter/nft_math.c                 | 201 +++++++++++++++++++++++
 4 files changed, 236 insertions(+)
 create mode 100644 net/netfilter/nft_math.c

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 7c0c915f0306..06e91cdbd615 100644
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
+	  increase to packet fields.
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
index 000000000000..2cbb7854354c
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
+	u8		 	sreg;
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
+static void nft_math_eval_bitmask(uint32_t *src, uint32_t *dst,
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
+			return EINVAL;
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
2.51.0

