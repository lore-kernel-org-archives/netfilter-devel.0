Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43B3129A33A;
	Thu, 22 May 2025 16:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747932790; cv=none; b=kmnCA6QPWew7lTh3D0FKRWihlc2QZ5bJTuEvApc/QLHtDUhz5r/csTrZkSSrzQK217NO7RFlzbYw9jZb9stee4ydvzhGdPGAYK3mUfABB8T7HUIMbxd+dBcNORuo/j3ZiyQ5Q1pbzXaJB++VUuhPbLRFGuHDWC0tWkkuHw1QXxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747932790; c=relaxed/simple;
	bh=OZVt19+GDnKFoxUykjSkh5UJFFPRYsWRcwwFy4AA3iw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=kbgngEvqkU/kqnek4bQ6s8OoJY41M62gzesevneB4CIFtO/30I+MjRjHBXZnfC9rddWPlFfrOQdbcblZ0clvmtXBO6CjlAGvX7RWQE5N+cxNp/FniLb9sTXKZXCNNUkTQK7A1kPf59fduWgWDUSuHDOpnV8d3BnEP6o198Rfaw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=s5rXzQ8/; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=B/UfPb19; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="s5rXzQ8/";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="B/UfPb19"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 07F3F60745; Thu, 22 May 2025 18:53:08 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1747932788;
	bh=vlEYGqW/LZ5w+PrTbmxs1+ViNcKPPojF+yahjfEFJnk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s5rXzQ8/FDqpsPx4dsiAukKXpRXwAVjRSTpAs1+VNT3F19aOCdUJu71o8NGB9JffZ
	 oIqwFZA9GRRaR0mjH+u++3UMlpQ3Vt7zVHflPO221BqkyEDWeT4+HCKICE51sMzRcj
	 lIp9BJma9KsafmxorAr4A1X8PWvZt+GKKXlwghycD+MogdFKbZ1LCsO9ZLiSjmg+1L
	 spyPdNhaWRaoA9UFQYBWss7s1iAkYPwgr8ybHhWZ5UZhELI39YRDLWrkqZ5qMYBhX7
	 COB1VYljW4UZEMdrPbZRqa5RD7zphbbwdyw3hoF8gF8edI54pcQrmU95v+wX38lUfE
	 B//b7OTGlI2hQ==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id F409960719;
	Thu, 22 May 2025 18:52:51 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1747932772;
	bh=vlEYGqW/LZ5w+PrTbmxs1+ViNcKPPojF+yahjfEFJnk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B/UfPb19SuWceuR+meP160YrLOOgi3PBEWaNEfATPoyHuYW5cVSThNDWuIyX6QvkJ
	 HTlW7UbmLfOOvpX0DFcjrpWuaJp+lxePaSasnxPKWjlZWpibGUjvZCO7TSpA8eQbsd
	 5WTSJY1KiVqewKU5qABr5KvjgRIqWgnLXMSTITwNbDc6MgCeMY4QL4z5eP08THsjtM
	 68FDoI1yeOR9FIkEh6DEVoMqQL6Fy/ARuYCH90zfIVNbbiLuavcBJMuaxfygQmXZYQ
	 u+9X6mpZaPOeKLLMR8/AeM7dPHptVWXafQrELcqOfPmUggoXReGI5QiuiZGzN9anvB
	 KItMfO91Na0hA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next 08/26] netfilter: nft_tunnel: fix geneve_opt dump
Date: Thu, 22 May 2025 18:52:20 +0200
Message-Id: <20250522165238.378456-9-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250522165238.378456-1-pablo@netfilter.org>
References: <20250522165238.378456-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Fernando Fernandez Mancera <fmancera@suse.de>

When dumping a nft_tunnel with more than one geneve_opt configured the
netlink attribute hierarchy should be as follow:

 NFTA_TUNNEL_KEY_OPTS
 |
 |--NFTA_TUNNEL_KEY_OPTS_GENEVE
 |  |
 |  |--NFTA_TUNNEL_KEY_GENEVE_CLASS
 |  |--NFTA_TUNNEL_KEY_GENEVE_TYPE
 |  |--NFTA_TUNNEL_KEY_GENEVE_DATA
 |
 |--NFTA_TUNNEL_KEY_OPTS_GENEVE
 |  |
 |  |--NFTA_TUNNEL_KEY_GENEVE_CLASS
 |  |--NFTA_TUNNEL_KEY_GENEVE_TYPE
 |  |--NFTA_TUNNEL_KEY_GENEVE_DATA
 |
 |--NFTA_TUNNEL_KEY_OPTS_GENEVE
 ...

Otherwise, userspace tools won't be able to fetch the geneve options
configured correctly.

Fixes: 925d844696d9 ("netfilter: nft_tunnel: add support for geneve opts")
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_tunnel.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nft_tunnel.c b/net/netfilter/nft_tunnel.c
index 0c63d1367cf7..a12486ae089d 100644
--- a/net/netfilter/nft_tunnel.c
+++ b/net/netfilter/nft_tunnel.c
@@ -621,10 +621,10 @@ static int nft_tunnel_opts_dump(struct sk_buff *skb,
 		struct geneve_opt *opt;
 		int offset = 0;
 
-		inner = nla_nest_start_noflag(skb, NFTA_TUNNEL_KEY_OPTS_GENEVE);
-		if (!inner)
-			goto failure;
 		while (opts->len > offset) {
+			inner = nla_nest_start_noflag(skb, NFTA_TUNNEL_KEY_OPTS_GENEVE);
+			if (!inner)
+				goto failure;
 			opt = (struct geneve_opt *)(opts->u.data + offset);
 			if (nla_put_be16(skb, NFTA_TUNNEL_KEY_GENEVE_CLASS,
 					 opt->opt_class) ||
@@ -634,8 +634,8 @@ static int nft_tunnel_opts_dump(struct sk_buff *skb,
 				    opt->length * 4, opt->opt_data))
 				goto inner_failure;
 			offset += sizeof(*opt) + opt->length * 4;
+			nla_nest_end(skb, inner);
 		}
-		nla_nest_end(skb, inner);
 	}
 	nla_nest_end(skb, nest);
 	return 0;
-- 
2.30.2

