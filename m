Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2788322B8DB;
	Tue,  8 Apr 2025 14:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744122508; cv=none; b=HgcEsJLJHhOz3gTOehwkt2WYc2KY96YTthyD7gmpmHI4QbnXysymuNi+CT0RxF+9o7D3kWrNX1GtcdwFUsTTOHhP5jEQ2zH6p7lB0Dhuiy5WG6UOfIjCVeSLn6Eu5EeKsw7pdgoi96jqR7YKZxxBnYg1IHCEGkO3btJBVEi5aVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744122508; c=relaxed/simple;
	bh=Bi1g+FE34fHmwPME0V+bhZ6TtOD/z11DwCQDy4/94MY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=os+1rnW2nBjaiFFCqop3ZXmaByTZXRS29Br7bB0Uw1lg56Le7fq4OGDNqj4XWgiCjeqw3FlJqlcqqxEJ2BEJMS/aIoYewQLFLWHwY/UcV/QlbKse4iVX2Nh1UxEXZkjxxAvRZewBvNUCNhTPGP0kWnZlVEnZPy/bkk6pATa3GM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HtPEDGGq; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HtPEDGGq"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-5e6ff035e9aso10965909a12.0;
        Tue, 08 Apr 2025 07:28:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744122505; x=1744727305; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=acp6QAyrIB7XFPCeY/z2h/Zu51qu9lPNXfDcdrzAIRY=;
        b=HtPEDGGqt5zqKqab/jNNQ2sbcUu3UJmWZL9T4DnEZTnw09KWEshv6p3vX4RWNIqvCH
         uLmBp0rbLgo01DRes6yWGleqBhJmV5+mMSUHgAS32rQePoy4Qnk8aSu7aOOfyNsgGB+M
         Lqq/szu7HOKTf6rpducaenT78z69lUJuYcoFGvXa4vxbs5v0xNZ09Ot8dy9TWbUuT0xV
         jUtXwLZKunO+8D19fFqrwf/LPqpj1FosawlMbiz6637WYaGbuSJ5sSMRwKb+aCYX9Krx
         aosD8UgZ7rRrsslYK+Gm5IPnyi1NezqIcTXRhHDZ7280UcTRRUYZy7m10yt7HLjLAe9c
         KuxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744122505; x=1744727305;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=acp6QAyrIB7XFPCeY/z2h/Zu51qu9lPNXfDcdrzAIRY=;
        b=tY8evtdErJJIeJmoLJbhQqV6ISq1Pm1K2UtHb2XWv/3ffI3aYYsTtLN8ngsmeJFbPW
         curmdETaJ1ntobzf8sI6JRJVlkdSZZcVMgwmm2ugeGklVUMHTCNAF1+GnLNNsTHsX0DB
         +ckONYKl1p6+rD08P/5+ryzElVcimbeGZqqOLdF6pEJ2xLV2kPzdnZ3jc99XA/+A4Rzs
         i4+Y1yoC3La1/CBZ9ezTVfG5KtlSRS8xRJt3PPsEncXfEJKXHtlFYS7Y3JcbtrmUH5qW
         Li+TfLZRmz4xEI9vlpXM7DvdTcFbmQFPl2xNeMrU8GZwcicgS3X5pKn4RPwzTiUOyXIE
         ZSzA==
X-Forwarded-Encrypted: i=1; AJvYcCWzJeuu6b9cTq4uG2JwzcBR8zVm2cglP/gEbZJc8qA+cxYgy5GjeAySApThZuwc9p7s2G5EZX/eloU1aVKvl0E=@vger.kernel.org
X-Gm-Message-State: AOJu0YzXgyZfUZC9xfSTJyq00OIihEvr3taS4sURR3Rd5lisED+tDsxk
	8relUZ+tMtN7zh9tNyV2wICUnf0H+3ELQPbT3G0OapPE4dcA9onQ
X-Gm-Gg: ASbGnctEXs3SQAcLdSiGicf9uqgV4pp+/KdqyfafnbVYWbN8nfCq8M21gJPdfKFuQij
	Kui2JmyPJncOAHsZhJtrjamkFI5qqXuwdnxVBWHHgmwqHHxo30gotBefCEGRzDXhTEC/1aUncPk
	C9WBj+xRGYIFUBd/b0iUIOyCL94qjx6qrh/W+u9TBzfPjXIjUrsgCGKfMSY6orH4lnkQc3puSVK
	R1Gcd1qwMahjlUevfSMPQwO6pz7dKWFO+WCpNaKg/AfYXXV8zMWOiLX6ij0bizKWacTb133SogZ
	njlobe0IaSQAWXzRhTl07iJGClmEIjIN4e8TL1IjWCw82p37QH5ZgfZZ7HZ6nzH/X2HTa401gVH
	ouWFpsJ8NMje88/LzEJO/+wDFWDQITeueAPyq4iyLNzpW7QdO7IcHzhS5FD8PfxU8VKTIcrlvVQ
	==
X-Google-Smtp-Source: AGHT+IH8QHh6kl+s0CP+jLER1QUkzhPO+u0uCrglbs7J+deI7B/II8NFkH8U4zbe5FYa57Az6F/L4g==
X-Received: by 2002:a05:6402:5209:b0:5e5:ba3e:ab04 with SMTP id 4fb4d7f45d1cf-5f0b3e35c08mr12883416a12.26.1744122505239;
        Tue, 08 Apr 2025 07:28:25 -0700 (PDT)
Received: from localhost.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5f1549b3fd0sm2236164a12.35.2025.04.08.07.28.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Apr 2025 07:28:24 -0700 (PDT)
From: Eric Woudstra <ericwouds@gmail.com>
To: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Ahmed Zaki <ahmed.zaki@intel.com>,
	Alexander Lobakin <aleksander.lobakin@intel.com>
Cc: netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	bridge@lists.linux.dev,
	Eric Woudstra <ericwouds@gmail.com>
Subject: [PATCH v11 nf-next 5/6] netfilter: nft_flow_offload: Add NFPROTO_BRIDGE to validate
Date: Tue,  8 Apr 2025 16:28:01 +0200
Message-ID: <20250408142802.96101-6-ericwouds@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250408142802.96101-1-ericwouds@gmail.com>
References: <20250408142802.96101-1-ericwouds@gmail.com>
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
index e77164424891..889393edc629 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -438,7 +438,8 @@ static int nft_flow_offload_validate(const struct nft_ctx *ctx,
 
 	if (ctx->family != NFPROTO_IPV4 &&
 	    ctx->family != NFPROTO_IPV6 &&
-	    ctx->family != NFPROTO_INET)
+	    ctx->family != NFPROTO_INET &&
+	    ctx->family != NFPROTO_BRIDGE)
 		return -EOPNOTSUPP;
 
 	return nft_chain_validate_hooks(ctx->chain, hook_mask);
-- 
2.47.1

