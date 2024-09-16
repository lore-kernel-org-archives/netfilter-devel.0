Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19E3C158866;
	Mon, 16 Sep 2024 15:14:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726499697; cv=none; b=fnZLkL8A8ayMU6q+sMFexM3IVbad6/nMEbe6Pu9YxVF04jRyANBwAak7SCDFVA74o3odX8M0thzYS8ToMxc0Rr+fnWVsqZO8O9vPCJTX1mcO+FuPBuSanU9PcT7sAFg5FsO2zdNFNtmL3EBFE7YYDALT6ITFmkPwcMT0q0BHDE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726499697; c=relaxed/simple;
	bh=OIBh/0baW7ACKehuo5TRfPDRDt7fKE/BEc8K0THsT0Y=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=hpMtql73qOfo+/YxTYAa+t0/bLhoQH51IaEIK+F8+TQkRvKS+t4JyrSiRebdsOKzLwjYBGDXAMJ9c2JWu4S13JziRi6Z4brn41hlzJhKHjx46xLV896CGq03WTFHL1Jq6QVLTDUzEMzsCt7TzmmWiJbzLyfKZdbUdFgxEXe/4Fg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lrKuAHXy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lrKuAHXy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB9D9C4CECE;
	Mon, 16 Sep 2024 15:14:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726499696;
	bh=OIBh/0baW7ACKehuo5TRfPDRDt7fKE/BEc8K0THsT0Y=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=lrKuAHXyOrZko7ATpHmsjgj8bU/jUQ3sCYA7LKdcW0cwJzLz28bCSDhCwah9atfmn
	 T1CFA4UutXJ2D7H+GckA8VO25fl8wPXBKdxmKhFn/JSI0wWRlOFHPhlhj1Uok1MnRF
	 suxMH/MciD4WuCTV8mRZHgcRq86lu7pLMutR+W4paIOibgVyeRFGYwCY3Fy6Fyc2uZ
	 k61YLjLCN9XQlnGqdzG18f1ka/iKgWejiJALf6gq5hQt8PhCtr+Js2z7PcIWKcU86l
	 JQn7rcsJu4+SRUeQAQk4SUp4jpSYfbAfUzOZjeoICie90I6MARnL4t90Ool2oU0nnj
	 w7c+nGwM3lA0A==
From: Simon Horman <horms@kernel.org>
Date: Mon, 16 Sep 2024 16:14:42 +0100
Subject: [PATCH nf-next 2/2] netfilter: conntrack: conditionally compile
 ctnetlink_label_size
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240916-ct-ifdef-v1-2-81ef1798143b@kernel.org>
References: <20240916-ct-ifdef-v1-0-81ef1798143b@kernel.org>
In-Reply-To: <20240916-ct-ifdef-v1-0-81ef1798143b@kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>, 
 Jozsef Kadlecsik <kadlec@netfilter.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Nathan Chancellor <nathan@kernel.org>, 
 Nick Desaulniers <ndesaulniers@google.com>, 
 Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, 
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
 netdev@vger.kernel.org, llvm@lists.linux.dev
X-Mailer: b4 0.14.0

Only provide ctnetlink_label_size when it is used,
which is when CONFIG_NF_CONNTRACK_EVENTS is configured.

Flagged by clang-18 W=1 builds as:

.../nf_conntrack_netlink.c:385:19: warning: unused function 'ctnetlink_label_size' [-Wunused-function]
  385 | static inline int ctnetlink_label_size(const struct nf_conn *ct)
      |                   ^~~~~~~~~~~~~~~~~~~~

Found by manually tweaking .config.
Compile tested only.

Link: https://lore.kernel.org/netfilter-devel/20240909151712.GZ2097826@kernel.org/
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Simon Horman <horms@kernel.org>
---
 net/netfilter/nf_conntrack_netlink.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index f1f7dff08953..cac48277a7d5 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -382,6 +382,7 @@ static int ctnetlink_dump_secctx(struct sk_buff *skb, const struct nf_conn *ct)
 #define ctnetlink_dump_secctx(a, b) (0)
 #endif
 
+#ifdef CONFIG_NF_CONNTRACK_EVENTS
 static inline int ctnetlink_label_size(const struct nf_conn *ct)
 {
 	struct nf_conn_labels *labels = nf_ct_labels_find(ct);
@@ -390,6 +391,7 @@ static inline int ctnetlink_label_size(const struct nf_conn *ct)
 		return 0;
 	return nla_total_size(sizeof(labels->bits));
 }
+#endif
 
 static int
 ctnetlink_dump_labels(struct sk_buff *skb, const struct nf_conn *ct)

-- 
2.45.2

