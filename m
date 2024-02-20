Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0135E6D1D8
	for <netfilter-devel@vger.kernel.org>; Tue, 20 Feb 2024 14:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708440922; cv=none; b=JlvCDKQgnBw+GTjJlaAgn89nQUl0cjQmif0aBSiI5m1J1uDMrgYmN88gLJ5Joj+zWLJ8gfHzpWkBh7mkM9iD1elbPzxDKDv9YPoI6nfnWgchhNtmhFnDN3QfgiCjwToXDsEnT7cloaLEg783ofKIb3/QgstoVsBRzGO44iFsEHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708440922; c=relaxed/simple;
	bh=fCCMZKYJIvIq+/E3Q8v8QEX4oT3yakpoJ2fzALmJviw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Djn1ux3P6hUbxm1l+Ow++kULiN5Shbgnw4dC3qNn0RQs7cJ5OFiJPMA7TV8Qw4sVCBKgT6avsEu8Y19tRY7+g+g3sDW6PeFvm6zETNJvH5AjNSh4m0ogEAZf5WxbbxewVFqTIA8kNhf8hHaPkUiL++JOsWDj5HlCRa9e3dTEAmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloudflare.com; spf=pass smtp.mailfrom=cloudflare.com; dkim=pass (2048-bit key) header.d=cloudflare.com header.i=@cloudflare.com header.b=LNaifaVa; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloudflare.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cloudflare.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cloudflare.com header.i=@cloudflare.com header.b="LNaifaVa"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4127190ad83so2195965e9.0
        for <netfilter-devel@vger.kernel.org>; Tue, 20 Feb 2024 06:55:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google09082023; t=1708440918; x=1709045718; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=xXwTlB1Mz8S0yvA31jmRT6vO0iTxRThf8HVp1JeFxNg=;
        b=LNaifaVaIwXa4Rfbi3MBiaxqmF1oNEM9yQpYGYRBQvYd74p8Mx2nwBHq+VeN5np+NT
         b+8KIC0ovhcQUuKt/B3/9vBwxW/z5yoFAP/Diy/fwSMbdslDBxC2FPINcPf+kDQsZ54u
         wwfBx/Kd+Bz2cTaiAwyHmp5i2KPdrXEhzbUzEXY8Ex8dA1SR0SrOC8n8RD4fUBzJtGMI
         FRufWDzuKPI69P6q+0xwBaQUP9ZNJu5qFQoEyteLyjTf7XfmrcqasHfTeVOl5qZG1z8P
         hLnjEz/3vQ9E2Yapc40EKvtFT+5otUyf1R/ekGq7J8hPSNbunLluMvQHOGWvsRSrawAA
         A8LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708440918; x=1709045718;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xXwTlB1Mz8S0yvA31jmRT6vO0iTxRThf8HVp1JeFxNg=;
        b=MwbyRJidOcev1xgDmTpY0NDStdxSQi+q4QyraunqTXnIjDcgl3bvsBgTN5od3RZExk
         WnQzcQAlMr12ios5WyEnqopjnsX7I1OHinhAZ0iAil3Zz3FdVaT7rl5fbSPjGbhh+j0q
         1zS8kfHp/eAyG/VYHS18t9VYLuqmQDk9JedSUJYmrPZFgN1sFaIYmgxgzSeJQOzV1Q9q
         spI+toT7fYvaRNBWhOSTYnDgAhztf09uJE2EdaoOBFgt/8hivHP/8IdcVT0oMqAwVOas
         BsjYnfIbTQCNGLHjBaO8fXCsazyWUPRkjuJNM/uQRfBO8xm7gHqIlLaZlHR64TPicAgu
         GiPw==
X-Forwarded-Encrypted: i=1; AJvYcCX+IG8tKmrdGluZt9heF4WkB6TmJEg0gCPaqTfNpXgzoiiJh7LMrHocQuzslRSWKkA+30udmgSrMXTJAAhWdm6GTDec9kCDzljokJkXzTIT
X-Gm-Message-State: AOJu0YzAN2soQzi8t3TylNW5sauAi1GrgkcgFHJheJqXB02yHikZAovA
	EHjCxQHEtsATIHFOKQDinNg4SgCX55VvsCnsJ5s/1aV/0Cf4rNfSKOGO5NMhUrFk7fnMdCzOk08
	ynMs=
X-Google-Smtp-Source: AGHT+IHxG74xnVWjpnGPFEvJ70Mkcc8VuGshOoOYxTUFt3lXxuJx7WzwFkEuxQA2zb7lFxHEt9qf/Q==
X-Received: by 2002:a05:6000:1813:b0:33d:70a8:457d with SMTP id m19-20020a056000181300b0033d70a8457dmr933352wrh.30.1708440918302;
        Tue, 20 Feb 2024 06:55:18 -0800 (PST)
Received: from localhost.localdomain ([104.28.158.165])
        by smtp.gmail.com with ESMTPSA id e6-20020adffd06000000b0033cf60e268fsm13659907wrr.116.2024.02.20.06.55.17
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 20 Feb 2024 06:55:17 -0800 (PST)
From: Ignat Korchagin <ignat@cloudflare.com>
To: pablo@netfilter.org,
	kadlec@netfilter.org,
	fw@strlen.de,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org
Cc: kernel-team@cloudflare.com,
	jgriege@cloudflare.com,
	Ignat Korchagin <ignat@cloudflare.com>
Subject: [PATCH v2] netfilter: nf_tables: allow NFPROTO_INET in nft_(match/target)_validate()
Date: Tue, 20 Feb 2024 14:55:09 +0000
Message-Id: <20240220145509.53357-1-ignat@cloudflare.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-145)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit d0009effa886 ("netfilter: nf_tables: validate NFPROTO_* family") added
some validation of NFPROTO_* families in the nft_compat module, but it broke
the ability to use legacy iptables modules in dual-stack nftables.

While with legacy iptables one had to independently manage IPv4 and IPv6 tables,
with nftables it is possible to have dual-stack tables sharing the rules.
Moreover, it was possible to use rules based on legacy iptables match/target
modules in dual-stack nftables. Consider the following program:

```

/* #define TBL_FAMILY NFPROTO_IPV4 */

/*
 * creates something like below
 * table inet testfw {
 *   chain input {
 *     type filter hook prerouting priority filter; policy accept;
 *     bytecode counter packets 0 bytes 0 accept
 *   }
 * }
 *
 * compile:
 * cc -o nftbpf nftbpf.c -lnftnl -lmnl
 */
int main(void)
{
    uint8_t buf[MNL_SOCKET_BUFFER_SIZE];
    uint32_t seq, rule_seq, portid;
    struct mnl_nlmsg_batch *batch;
	struct nlmsghdr *nlh;
	struct mnl_socket *nl;
	int ret;
	struct xt_bpf_info_v1 *xt_bpf_info = malloc(sizeof(*xt_bpf_info));
	struct nftnl_expr *m, *cnt, *im;
	struct nftnl_rule *r;
	struct nftnl_chain *c;
    struct nftnl_table *t = nftnl_table_alloc();
    if (t == NULL) {
        perror("TABLE OOM");
        exit(EXIT_FAILURE);
    }
    nftnl_table_set_u32(t, NFTNL_TABLE_FAMILY, TBL_FAMILY);
	nftnl_table_set_str(t, NFTNL_TABLE_NAME, TBL_NAME);

	c = nftnl_chain_alloc();
	if (c == NULL) {
		perror("CHAIN OOM");
		exit(EXIT_FAILURE);
	}
	nftnl_chain_set_str(c, NFTNL_CHAIN_TABLE, TBL_NAME);
	nftnl_chain_set_str(c, NFTNL_CHAIN_NAME, CHAIN_NAME);
	nftnl_chain_set_u32(c, NFTNL_CHAIN_HOOKNUM, NF_INET_PRE_ROUTING);
	nftnl_chain_set_u32(c, NFTNL_CHAIN_PRIO, 0);

	r = nftnl_rule_alloc();
	if (r == NULL) {
		perror("RULE OOM");
		exit(EXIT_FAILURE);
	}
	nftnl_rule_set_str(r, NFTNL_RULE_TABLE, TBL_NAME);
	nftnl_rule_set_str(r, NFTNL_RULE_CHAIN, CHAIN_NAME);
	nftnl_rule_set_u32(r, NFTNL_RULE_FAMILY, TBL_FAMILY);

	m = nftnl_expr_alloc("match");
	if (m == NULL) {
		perror("MATCH OOM");
		exit(EXIT_FAILURE);
	}
	nftnl_expr_set_str(m, NFTNL_EXPR_MT_NAME, "bpf");
	nftnl_expr_set_u32(m, NFTNL_EXPR_MT_REV, 1);

	if (xt_bpf_info == NULL) {
		perror("XT_BPF OOM");
		exit(EXIT_FAILURE);
	}

	/*
	 * example from https://ipset.netfilter.org/iptables-extensions.man.html
	 * should match TCP packets
	 */
	xt_bpf_info->mode = XT_BPF_MODE_BYTECODE;
	xt_bpf_info->bpf_program_num_elem = 4;

	xt_bpf_info->bpf_program[0].code = 48;
	xt_bpf_info->bpf_program[0].jt = 0;
	xt_bpf_info->bpf_program[0].jf = 0;
	xt_bpf_info->bpf_program[0].k = 9;

	xt_bpf_info->bpf_program[1].code = 21;
	xt_bpf_info->bpf_program[1].jt = 0;
	xt_bpf_info->bpf_program[1].jf = 1;
	xt_bpf_info->bpf_program[1].k = 6;

	xt_bpf_info->bpf_program[2].code = 6;
	xt_bpf_info->bpf_program[2].jt = 0;
	xt_bpf_info->bpf_program[2].jf = 0;
	xt_bpf_info->bpf_program[2].k = 1;

	xt_bpf_info->bpf_program[3].code = 6;
	xt_bpf_info->bpf_program[3].jt = 0;
	xt_bpf_info->bpf_program[3].jf = 0;
	xt_bpf_info->bpf_program[3].k = 0;

	nftnl_expr_set(m, NFTNL_EXPR_MT_INFO, xt_bpf_info, sizeof(*xt_bpf_info));
	nftnl_rule_add_expr(r, m);

	cnt = nftnl_expr_alloc("counter");
	if (cnt == NULL) {
		perror("COUNTER OOM");
		exit(EXIT_FAILURE);
	}
	nftnl_expr_set_u64(cnt, NFTNL_EXPR_CTR_PACKETS, 0);
	nftnl_expr_set_u64(cnt, NFTNL_EXPR_CTR_BYTES, 0);
	nftnl_rule_add_expr(r, cnt);

	im = nftnl_expr_alloc("immediate");
	if (im == NULL) {
		perror("IMMEDIATE OOM");
		exit(EXIT_FAILURE);
	}
	nftnl_expr_set_u32(im, NFTNL_EXPR_IMM_DREG, 0);
	nftnl_expr_set_u32(im, NFTNL_EXPR_IMM_VERDICT, 1);
	nftnl_rule_add_expr(r, im);

	seq = time(NULL);
	batch = mnl_nlmsg_batch_start(buf, sizeof(buf));

	nftnl_batch_begin(mnl_nlmsg_batch_current(batch), seq++);
	mnl_nlmsg_batch_next(batch);

	nlh = nftnl_nlmsg_build_hdr(mnl_nlmsg_batch_current(batch),
				    NFT_MSG_NEWTABLE, TBL_FAMILY,
				    NLM_F_CREATE, seq++);
	nftnl_table_nlmsg_build_payload(nlh, t);
	nftnl_table_free(t);
	mnl_nlmsg_batch_next(batch);

	nlh = nftnl_nlmsg_build_hdr(mnl_nlmsg_batch_current(batch),
				    NFT_MSG_NEWCHAIN, TBL_FAMILY,
				    NLM_F_CREATE, seq++);
	nftnl_chain_nlmsg_build_payload(nlh, c);
	nftnl_chain_free(c);
	mnl_nlmsg_batch_next(batch);

	rule_seq = seq;
	nlh = nftnl_nlmsg_build_hdr(mnl_nlmsg_batch_current(batch),
				    NFT_MSG_NEWRULE, TBL_FAMILY,
				    NLM_F_APPEND | NLM_F_CREATE | NLM_F_ACK,
				    seq++);
	nftnl_rule_nlmsg_build_payload(nlh, r);
	nftnl_rule_free(r);
	mnl_nlmsg_batch_next(batch);

	nftnl_batch_end(mnl_nlmsg_batch_current(batch), seq++);
	mnl_nlmsg_batch_next(batch);

	nftnl_batch_end(mnl_nlmsg_batch_current(batch), seq++);
	mnl_nlmsg_batch_next(batch);

	nl = mnl_socket_open(NETLINK_NETFILTER);
	if (nl == NULL) {
		perror("mnl_socket_open");
		exit(EXIT_FAILURE);
	}

	if (mnl_socket_bind(nl, 0, MNL_SOCKET_AUTOPID) < 0) {
		perror("mnl_socket_bind");
		exit(EXIT_FAILURE);
	}
	portid = mnl_socket_get_portid(nl);

	if (mnl_socket_sendto(nl, mnl_nlmsg_batch_head(batch),
			      mnl_nlmsg_batch_size(batch)) < 0) {
		perror("mnl_socket_send");
		exit(EXIT_FAILURE);
	}

	mnl_nlmsg_batch_stop(batch);

	ret = mnl_socket_recvfrom(nl, buf, sizeof(buf));
	while (ret > 0) {
		ret = mnl_cb_run(buf, ret, rule_seq, portid, NULL, NULL);
		if (ret <= 0)
			break;
		ret = mnl_socket_recvfrom(nl, buf, sizeof(buf));
	}
	if (ret == -1) {
		perror("error");
		exit(EXIT_FAILURE);
	}
	mnl_socket_close(nl);

	return EXIT_SUCCESS;
}
```

Above creates an INET dual-stack family table using xt_bpf based rule. After
d0009effa886 ("netfilter: nf_tables: validate NFPROTO_* family") we get
EOPNOTSUPP for the above configuration.

Fix this by allowing NFPROTO_INET for nft_(match/target)_validate(), but also
restrict the functions to classic iptables hooks.

Changes in v2:
  * restrict nft_(match/target)_validate() to classic iptables hooks
  * rewrite example program to use unmodified libnftnl

Fixes: d0009effa886 ("netfilter: nf_tables: validate NFPROTO_* family")
Link: https://lore.kernel.org/all/Zc1PfoWN38UuFJRI@calendula/T/#mc947262582c90fec044c7a3398cc92fac7afea72
Reported-by: Jordan Griege <jgriege@cloudflare.com>
Signed-off-by: Ignat Korchagin <ignat@cloudflare.com>
---
 net/netfilter/nft_compat.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/net/netfilter/nft_compat.c b/net/netfilter/nft_compat.c
index 1f9474fefe84..d3d11dede545 100644
--- a/net/netfilter/nft_compat.c
+++ b/net/netfilter/nft_compat.c
@@ -359,10 +359,20 @@ static int nft_target_validate(const struct nft_ctx *ctx,
 
 	if (ctx->family != NFPROTO_IPV4 &&
 	    ctx->family != NFPROTO_IPV6 &&
+	    ctx->family != NFPROTO_INET &&
 	    ctx->family != NFPROTO_BRIDGE &&
 	    ctx->family != NFPROTO_ARP)
 		return -EOPNOTSUPP;
 
+	ret = nft_chain_validate_hooks(ctx->chain,
+				       (1 << NF_INET_PRE_ROUTING) |
+				       (1 << NF_INET_LOCAL_IN) |
+				       (1 << NF_INET_FORWARD) |
+				       (1 << NF_INET_LOCAL_OUT) |
+				       (1 << NF_INET_POST_ROUTING));
+	if (ret)
+		return ret;
+
 	if (nft_is_base_chain(ctx->chain)) {
 		const struct nft_base_chain *basechain =
 						nft_base_chain(ctx->chain);
@@ -610,10 +620,20 @@ static int nft_match_validate(const struct nft_ctx *ctx,
 
 	if (ctx->family != NFPROTO_IPV4 &&
 	    ctx->family != NFPROTO_IPV6 &&
+	    ctx->family != NFPROTO_INET &&
 	    ctx->family != NFPROTO_BRIDGE &&
 	    ctx->family != NFPROTO_ARP)
 		return -EOPNOTSUPP;
 
+	ret = nft_chain_validate_hooks(ctx->chain,
+				       (1 << NF_INET_PRE_ROUTING) |
+				       (1 << NF_INET_LOCAL_IN) |
+				       (1 << NF_INET_FORWARD) |
+				       (1 << NF_INET_LOCAL_OUT) |
+				       (1 << NF_INET_POST_ROUTING));
+	if (ret)
+		return ret;
+
 	if (nft_is_base_chain(ctx->chain)) {
 		const struct nft_base_chain *basechain =
 						nft_base_chain(ctx->chain);
-- 
2.39.2

