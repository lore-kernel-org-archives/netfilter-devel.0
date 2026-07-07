Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29EB539524E
	for <netfilter-devel@vger.kernel.org>; Tue,  7 Jul 2026 09:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783415485; cv=none; b=YmBBRuwLsF32HLr0kQYhGJYb4Qarb6bQLrRGB6BEpJrxaFqOVpdPBLp6aUlUeTMr7OpLJnyc1V3oIYiOkCxkQzw7VfxBnrfb6NJt+P/hO8MmpxYn0X3+eUxOWFxjjojCcB6+Lc3PK/HuqQfQOJ7lsm0o/xMr44ydj4RbU5AkmCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783415485; c=relaxed/simple;
	bh=c4d0Gn8acxX3dds/zr06bS5e3i/O+AWIqoHlkIL0KS8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I/p3q7xQsxHsogqe0yPYZ/OVx7jknkGRoxyn+BebADH7pomLCBzFp090czdHGNkrcsXdkTSeFwkf7kw4m1SVGyRfor6/pkT10MQGOgx9nt30/fESYSrrMZkukBuyhAyYWb94rIeiQeQuNcTgR6UXnz7VagQ3QoKoEeLJzc1qIQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ce/f//Fa; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ce/f//Fa"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-69a5ecbbfb2so2564387a12.2
        for <netfilter-devel@vger.kernel.org>; Tue, 07 Jul 2026 02:11:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783415483; x=1784020283; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hNuEiSmMfMRS/Sppafm7I7/IS/ncJPWRF2xvpsmHdUI=;
        b=Ce/f//FaaL3NTrWdVqK5Co+8o7I8863hwaNVkbmFgaE5nXKaimMteI/7F8l8kr+PZK
         EEGBEsXMy7w2xLO6YgdBOuwDb/qlsOKsk3Wl03BklMDqBiLyjjHbVkfU8TiA9WTcLE1T
         RZsyFE2d7nob7e5lFs7S5/ex52EIRe1CWXGM0D9En7oEI/qZfQmp1acP4L6VrFHdsVao
         MExKCl0sQp0tZRL5TNpChMA8QW03gWaaqbau+I27XoPn88mPfjrQbLVTM1WvwEo2QGFW
         XqEjEJQ+BY1kSJ5AQ5niuvdDeOsLiGuxTY9d14Vi9oG23lm40WX8ZV8REjmgr9szE6d0
         jyfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783415483; x=1784020283;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=hNuEiSmMfMRS/Sppafm7I7/IS/ncJPWRF2xvpsmHdUI=;
        b=dF9EnyEz7mmdlWBCp/aE0Ju9bf88KpiTZ5po43OJaqfZrjvQv41nVUVjCgl8FZkLyC
         AZnVtPoIRzszmdfFmHN9l+ci6oVEUAeIqlB1VIBGYXazGlGr6mPZsPo45Nf0ZvTI/Yam
         /NL91mlKI2n/t28D0zuHRmS6RjtFIx+/lPopEww7WYxPeUodSZkaAJBewBWsqJsuTwqW
         hxaGOD1hd/0D5iy/VjJkw/BCUXYQw9sJx4zwaQvgWZs361TXxcYjWRzb0KtPpAVKp+xh
         ZwpxRO9doYzGTfDZkLcPrCJ9CBPH3VyZaYgoJyAA7UbGAjOCToA18ZpAixBEhx1zzu9n
         +57w==
X-Forwarded-Encrypted: i=1; AHgh+RrmlOQq5AUlWBg2J+lNd0KMSot+V7J90Co5eNHSm9sB5+oHUCB6rNHrKDpZ6c5SXADfvQPbpyaUGVOr10xV6II=@vger.kernel.org
X-Gm-Message-State: AOJu0YxpJadsapTOni+G0vMm89CjENjZxfUj/KWKPos25PG2Yt25Vk/L
	uCq8uy2nIFb+0ZyqrIqSaZQVQJY4CVG9NpIpPzHoJMJ3Jsru9JRqxTPU
X-Gm-Gg: AfdE7cl7yAkNZDTqyVXOZ2YuBv02/YyBCiA5FXEJK9QMoFxjGEV/fXNd6EN36IkjwuR
	2kfLDZPMXGLACeMz/cMckH5SIKqIgXj5hK1jhAjrs3iGNNbQ3dgDDPyVsIm/EUJbtTOGju/AQYo
	mU1FGK0QuY5st5YwI2bwZY40rzUWZv58Rqr7vOCNIWHP6l7aE4+XuYvV901OG/Z3Ui/8L6Sqs1v
	HiY/q1V43wWO3rNCWxSGdHiq1J3KGMczgfWgtAoNoMHnNBJuoZP0LZ+A7p876PnYVpJy+1TWEaX
	DctVwpgqbFeogBNpMOZK1DWmemDYlgMFhmucYSw/2vLqahRLt86la60WVXl49ITLsnw+HErqwsT
	wgwjsW0dkr27e8xTR6RITl12yMsh6DJ85LY8ooqejDI4R9P42yhpBVTGrIH7oLauKyDqq+19/do
	xK08ez+D8hFRGq/l6JIqGMonI4xLV7GH2/Oj8yl17HfU8Ns4x/Zhl2SC1DPfiW4ANC7lTiGwrIq
	jIBofDTDB7BKEXOjsJhaHyHwVryTZCC+GSCFH7qrk+N
X-Received: by 2002:a05:6402:a2c9:10b0:695:9b77:7c3a with SMTP id 4fb4d7f45d1cf-69a85c1747amr1674170a12.24.1783415482470;
        Tue, 07 Jul 2026 02:11:22 -0700 (PDT)
Received: from eric (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-69a19cd87d6sm5297152a12.6.2026.07.07.02.11.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2026 02:11:22 -0700 (PDT)
From: Eric Woudstra <ericwouds@gmail.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Stanislav Fomichev <sdf.kernel@gmail.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Hangbin Liu <liuhangbin@gmail.com>,
	Krishna Kumar <krikku@gmail.com>,
	Martin Karsten <mkarsten@uwaterloo.ca>
Cc: netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	bridge@lists.linux.dev,
	Eric Woudstra <ericwouds@gmail.com>
Subject: [PATCH v12 nf-next 6/7] netfilter: nft_flow_offload: Add NFPROTO_BRIDGE to validate
Date: Tue,  7 Jul 2026 11:10:44 +0200
Message-ID: <20260707091045.967678-7-ericwouds@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260707091045.967678-1-ericwouds@gmail.com>
References: <20260707091045.967678-1-ericwouds@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Need to add NFPROTO_BRIDGE to nft_flow_offload_validate() to support
the bridge-fastpath.

Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
Signed-off-by: Eric Woudstra <ericwouds@gmail.com>
---
 net/netfilter/nft_flow_offload.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index 4f68fb64f1657..0be62841155b6 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -179,7 +179,8 @@ static int nft_flow_offload_validate(const struct nft_ctx *ctx,
 
 	if (ctx->family != NFPROTO_IPV4 &&
 	    ctx->family != NFPROTO_IPV6 &&
-	    ctx->family != NFPROTO_INET)
+	    ctx->family != NFPROTO_INET &&
+	    ctx->family != NFPROTO_BRIDGE)
 		return -EOPNOTSUPP;
 
 	return nft_chain_validate_hooks(ctx->chain, hook_mask);
-- 
2.53.0

