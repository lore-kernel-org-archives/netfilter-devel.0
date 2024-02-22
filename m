Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57CF7381A0
	for <netfilter-devel@vger.kernel.org>; Thu, 22 Feb 2024 10:33:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708597996; cv=none; b=t2Z+HnwwxmIZCHLFdWtDD6SyTUbgLkAq5TXB1722iY94qVMk44HSHS5ScjtixlVthkBzA5T8guAGkCHD6E4w0Zmj/9BjvFanLHOaLMmck2wYJZP7oR83Gm9AJCL+uLk+NUUq5o8tQEonLwdyzgcDPo4fQdxi+UrmbmxJf7E0x3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708597996; c=relaxed/simple;
	bh=nY1neliwHgpNmA+KT6eve3RMhr+FupLwc2JcbcnwQPk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=eev1m8zs+/TnzwEFa8MBVUYmQHaRcq+78hvXIQnCx/gDbIUafCEHC8Kox8E6FkdmxHdECr6M1Tstrb5lArXsKXoB7Q1ecIrl4h3GgCgDY9ith5prfHT/Iy0T5OkcgjQdetYFEx9Eu131au6e0o8Fe486FTisaAndxdKB/OUyrpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloudflare.com; spf=pass smtp.mailfrom=cloudflare.com; dkim=pass (2048-bit key) header.d=cloudflare.com header.i=@cloudflare.com header.b=McPWnjwt; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloudflare.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cloudflare.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cloudflare.com header.i=@cloudflare.com header.b="McPWnjwt"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-33d36736d4eso3415969f8f.1
        for <netfilter-devel@vger.kernel.org>; Thu, 22 Feb 2024 02:33:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google09082023; t=1708597992; x=1709202792; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=NgMLy4WcLKJUBpQbmpMpr0DB4cr8d0jy50+DMCwIoCg=;
        b=McPWnjwtTGzzaVks3jwR9YWG6gZOM2D+sV9PiPV01pPRrBMeAVOBH7yu50QQPhKkl9
         LTXbH3Wa/4gj6sm7R7xuB8IIuREO9x9X5Xneh/O5adaXGI5tWhXZvxFBdU9dYe6pLBsW
         6kwiwyoP3iZwXcMBadtxoFQnsVTBfuskvWfG8piW6qeVu9LjLVEd/KVLMskw4wfVIJKc
         81wMzLZOqJB6v0+5HH0tsN2YpLkVSnLv8DMu68M2pVRod8wKGLmNyGgAl/Au8aFKD42+
         JqiJUZIW9hzwGki887Vpg4gOqfv16wqPcOJ5ZzWS252UUjPRfObOjlXAtfktqUSSOaWc
         SfUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708597992; x=1709202792;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NgMLy4WcLKJUBpQbmpMpr0DB4cr8d0jy50+DMCwIoCg=;
        b=ruOEnTnUXInJcoIMzGkBMA+RLv8rlDv+5nVtJoFaWFNqx0GDu6PHZfw7p3w0fHaw87
         sShwzY7e0UySzdEWyHHJavL0iijxggSG6Hp41BQmMbKmm4U8kEA3hev7/L5MmD6MlLdV
         ipMxc6MkZ1KKpExphiC8ByCgB4heteuOTN1Iljj3MNxVlevCEafGe4A/bMh62BRmm6Gi
         WwqDbQ9YSHnbHmtc8aipTWpG1s0rMtGbffAe+kX8geuDbek6UalLFPK0wTyLVrEGjvBa
         986yG115ZSxCvnNfeAM5JWr5xRO8l09b7kj0rTvIwLqvkwUlg2iYD3G2fHJpBa/W41nP
         O6bQ==
X-Forwarded-Encrypted: i=1; AJvYcCUtrL9Jh5K3zvFHVcK4uHgU6ENIqL2ERVtgeLTI+r7bMnc2tt8CBYROeFiVXE2tmPDTe308JEJAyS0Xnq7bCffUIHt1hdo2eCrOvp0B3JO4
X-Gm-Message-State: AOJu0YzPRHVmKRpUxIHVZRhcnmg+H2vhC7BBhtJaGW1CuD48A6Gp3gr/
	CB0A0aDUpqGBAbBSXZ/jSindxgLwLUhk8rjKtQnIn/VojdUNdA/hsOT5tQ+6vAE=
X-Google-Smtp-Source: AGHT+IE/m/3wZ8x6vAGOKJF4LvO1xY/BcliQjuymscAQ/G6z0YMbyceFYPnUS194BAblKOGRNUnzGA==
X-Received: by 2002:adf:f190:0:b0:33d:39de:630a with SMTP id h16-20020adff190000000b0033d39de630amr8851604wro.14.1708597992564;
        Thu, 22 Feb 2024 02:33:12 -0800 (PST)
Received: from localhost.localdomain ([87.74.207.91])
        by smtp.gmail.com with ESMTPSA id v15-20020a5d610f000000b0033d4cf751b2sm13137283wrt.33.2024.02.22.02.33.11
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 22 Feb 2024 02:33:12 -0800 (PST)
From: Ignat Korchagin <ignat@cloudflare.com>
To: pablo@netfilter.org,
	kadlec@netfilter.org,
	fw@strlen.de,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org
Cc: kernel-team@cloudflare.com,
	jgriege@cloudflare.com,
	Ignat Korchagin <ignat@cloudflare.com>
Subject: [PATCH v3] netfilter: nf_tables: allow NFPROTO_INET in nft_(match/target)_validate()
Date: Thu, 22 Feb 2024 10:33:08 +0000
Message-Id: <20240222103308.7910-1-ignat@cloudflare.com>
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

While with legacy iptables one had to independently manage IPv4 and IPv6
tables, with nftables it is possible to have dual-stack tables sharing the
rules. Moreover, it was possible to use rules based on legacy iptables
match/target modules in dual-stack nftables.

As an example, the program from [2] creates an INET dual-stack family table
using an xt_bpf based rule, which looks like the following (the actual output
was generated with a patched nft tool as the current nft tool does not parse
dual stack tables with legacy match rules, so consider it for illustrative
purposes only):

table inet testfw {
  chain input {
    type filter hook prerouting priority filter; policy accept;
    bytecode counter packets 0 bytes 0 accept
  }
}

After d0009effa886 ("netfilter: nf_tables: validate NFPROTO_* family") we get
EOPNOTSUPP for the above program.

Fix this by allowing NFPROTO_INET for nft_(match/target)_validate(), but also
restrict the functions to classic iptables hooks.

Changes in v3:
  * clarify that upstream nft will not display such configuration properly and
    that the output was generated with a patched nft tool
  * remove example program from commit description and link to it instead
  * no code changes otherwise

Changes in v2:
  * restrict nft_(match/target)_validate() to classic iptables hooks
  * rewrite example program to use unmodified libnftnl

Fixes: d0009effa886 ("netfilter: nf_tables: validate NFPROTO_* family")
Link: https://lore.kernel.org/all/Zc1PfoWN38UuFJRI@calendula/T/#mc947262582c90fec044c7a3398cc92fac7afea72 [1]
Link: https://lore.kernel.org/all/20240220145509.53357-1-ignat@cloudflare.com/ [2]
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

