Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 801CD14B96A
	for <netfilter-devel@vger.kernel.org>; Tue,  4 Jun 2024 21:40:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717537225; cv=none; b=KA9jd93poH09MdvuzYviGljixAdQ/uMxjrZpE7p56v6qHuu6GEgxy0614Ij63q9/x2nx51rJOGKyTxHrH1WXBPFlLtBpAXR9BcVlnj6oz6SiRTCKV+pPfwgo0nniZIpaKPxK9D357m/fmhm8vzp8b8aptxb8S4rJSgblThbXEBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717537225; c=relaxed/simple;
	bh=kj+DjAiSae41Bxuj53wUf0RED4SiOjnAegp2lUnfMRs=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=ThA01dCd7lddsjOVab6Or85RgfkZ4MjpGn845SYStWeeZ0e6EPJ5JJDiTSTpqTczhkgxWjTTJsoBfx2vwwHfI4WBGlAsZlJx8SxOae1Lq8fpVFuKjtQECoQz9pP6w+kK0o9H6yJ5RYlPflMUd2tVNbSL1Bk03A/KfAjFNdVHvXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RoPDFtn/; arc=none smtp.client-ip=209.85.167.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RoPDFtn/"
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-52b936c958dso4254615e87.0
        for <netfilter-devel@vger.kernel.org>; Tue, 04 Jun 2024 14:40:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717537222; x=1718142022; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=31KMZloGNKPu4Ebz9kDyf4fWSFvrV5kPTUoogq3lT+g=;
        b=RoPDFtn/NedeuLoB2rojpgKKWmxvhlocX4jyNr3b51JrEdvap+XMVHCh6r5hUpZCza
         2jHxl+xVriE3oXdQ8R5fDGc/H/2HH7CgBDAUITdXBf/+8ttHAnMw4Kl/dJ2zf82R4qg+
         wo5g/cTwfMQaDM1M5BP6xPNjb5WplUNzg+rJt/w5UG86XtU/axRI9kVAMXEIpBwwY4Dh
         +h+0S1d67t3CdXR2zKJG8QMflNSfg9K6AdA7drqbVh73EoRTFwg05UjdxezLoWvKbLqp
         /y0H1QEtnmbos2tHw5vNNoQjyW6/EYs8vfOrhrsPo/X79dIv6x2N7u/j3v++ySHtq/qZ
         oUSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717537222; x=1718142022;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=31KMZloGNKPu4Ebz9kDyf4fWSFvrV5kPTUoogq3lT+g=;
        b=G+XnWVOdgzkfzR3uK3Hb/ralWO5T7449AyIif7xZDTPVvpgSnQ42iPOqPW4TXT5ibA
         P0tQHTJlybd6TAf1bBvthrp8Slw4HpflXbnpdQSJ4wWvETL/0H6nVnwsvpkVclx1br7W
         k220Bf68/MdvnK82g2bm2nz1irV1oDFBWPbjFkuy8fcfaKstOhKqpVyElq/ptkdOYVzZ
         O2eh/GAlHAjFJ/IKCd8cjU2pnFSnmkeY6gIuLQyLNVpnCpIxRUfhymzZkG3KpWZgRBEc
         ID1kFbGSSy1aofq2RLDoFzfXJZUgcpo7jNywf3eSEZdxBe6r9gyCBRPgw2sDtVwy+Fzw
         yvOQ==
X-Gm-Message-State: AOJu0Yz09eQ5yUclIWtTbabgOsfzmuaY3kjq51p3FTkk4UgCQ8sywDKU
	Pw3up7i78V3RCRVVOdv+n+u1OO8zPxQVq/b5wFV40lvpFKVShNMGDPQvrjmZU5OQaV0fRDw5sam
	tnQImiY5LSD+BLjOGjdTN1KD3LmMvG3OufLg=
X-Google-Smtp-Source: AGHT+IHqwn93cn4m56rJLLSePIPCTgupyc1Nmx29zrM8ya7YB37KzCB/ETzM0rszaIApV4VG+Roh645jnggZwBZOQZE=
X-Received: by 2002:ac2:5226:0:b0:520:dc1c:3c5d with SMTP id
 2adb3069b0e04-52bab4f6fb0mr376816e87.42.1717537221450; Tue, 04 Jun 2024
 14:40:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Davide Ornaghi <d.ornaghi97@gmail.com>
Date: Tue, 4 Jun 2024 23:40:10 +0200
Message-ID: <CAHH-0Ud7C2TBP9VQZY54kFBkSz4-V0g9eXK+nzdgV9rcwexJXw@mail.gmail.com>
Subject: [PATCH nft] Check for NULL netlink attributes
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, kadlec@netfilter.org, davem@davemloft.net, 
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, fw@strlen.de
Content-Type: text/plain; charset="UTF-8"

Payload and meta nftables exprs can be embedded into inner exprs via
nft_expr_inner_parse, which doesn't check for NULL netlink attributes,
unlike other exprs passing through select_ops.
Add the missing checks to nft_meta_inner_init and nft_payload_inner_init
to prevent dereferencing NULL pointers and eventually causing UAF reads
on commit_mutex.

Signed-off-by: Davide Ornaghi <d.ornaghi97@gmail.com>
---
 net/netfilter/nft_meta.c    | 2 ++
 net/netfilter/nft_payload.c | 3 +++
 2 files changed, 5 insertions(+)

diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index ba0d3683a..e2893077b 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -839,6 +839,8 @@ static int nft_meta_inner_init(const struct nft_ctx *ctx,
        struct nft_meta *priv = nft_expr_priv(expr);
        unsigned int len;

+       if (!tb[NFTA_META_KEY] || !tb[NFTA_META_DREG])
+               return -EINVAL;
        priv->key = ntohl(nla_get_be32(tb[NFTA_META_KEY]));
        switch (priv->key) {
        case NFT_META_PROTOCOL:
diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index 0c43d748e..4c6f15ad0 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -650,6 +650,9 @@ static int nft_payload_inner_init(const struct nft_ctx *ctx,
        struct nft_payload *priv = nft_expr_priv(expr);
        u32 base;

+       if (!tb[NFTA_PAYLOAD_BASE] || !tb[NFTA_PAYLOAD_OFFSET] ||
+           !tb[NFTA_PAYLOAD_LEN] || !tb[NFTA_PAYLOAD_DREG])
+               return -EINVAL;
        base   = ntohl(nla_get_be32(tb[NFTA_PAYLOAD_BASE]));
        switch (base) {
        case NFT_PAYLOAD_TUN_HEADER:
--
2.34.1
