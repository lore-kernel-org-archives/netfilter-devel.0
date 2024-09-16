Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0849915884A;
	Mon, 16 Sep 2024 15:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726499694; cv=none; b=MR1hZD3n2e/V4E2+qYEBnMdttuKhSpqn+dGTIHuQ4Mx8ZgAeTfhQeDr5ffUCJ1WubdO0m+681Z3+JlfU+9kcYuYkHnlacTCITIUZvZatg2ttEMxi3qRZ85wYXk5uhWRBx3rMyiRfXGWKfsiSDlDe+kMCUOqyMQAsV662gVZgaDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726499694; c=relaxed/simple;
	bh=jrRofr/U5OtmLYNGeEnCahQZRnPI1mplJUHcOcBZ8IE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=JLU/YGjFtbbLTkdtlrDwJUiddwE5VMKd7eFve4r2WXo6+wZ7gf2NuqaGYe5S1q1EcSXEXd7nrQHUH6hOuthvMnb6bcWhRceyrQ01EboZI7lvUIoKCAFAPinfpuqoTJStEZcXdVZQYyhP9n3CATmbQ+VDrSb8eh2tl2vS0srdpIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AkMgaGGd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AkMgaGGd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEED1C4CECF;
	Mon, 16 Sep 2024 15:14:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726499693;
	bh=jrRofr/U5OtmLYNGeEnCahQZRnPI1mplJUHcOcBZ8IE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=AkMgaGGdY2LprBLSHL/Jmlx0ZcTaj8ETlqhYB4FY2WVEmI1YYK0/FPlokk3BpghtJ
	 zAUsMWcefvmDfjEaxDAG6EZnERiKD6K5QqQK1YejoO2y8zRHo5NcouNHZ3hX9JcXh4
	 im2LlDePeUx4/Lehp8QtF0mTV5kyJqx4qXgGM+cIxCBsrhw/CjO088NirqkL3qPT/I
	 O4cH9fmL04b/pruWC9ZKBqWzjZuxsHcdLUsE7iesUjb04z4tZDqMlPvtMdeASpTA6n
	 WVnfCEkmx9W+EFKOjvKe1yiGWegvw0XLOCJl3x1wg4SDQVPJZGTsC0/e30owRGkGQ1
	 6qPbDtPuxVaQA==
From: Simon Horman <horms@kernel.org>
Date: Mon, 16 Sep 2024 16:14:41 +0100
Subject: [PATCH nf-next 1/2] netfilter: conntrack: compile label helpers
 unconditionally
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240916-ct-ifdef-v1-1-81ef1798143b@kernel.org>
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

The condition on CONFIG_NF_CONNTRACK_LABELS being removed by
this patch guards compilation of non-trivial implementations
of ctnetlink_dump_labels() and ctnetlink_label_size().

However, this is not necessary as each of these functions
will always return 0 if CONFIG_NF_CONNTRACK_LABELS is not defined
as each function starts with the equivalent of:

	struct nf_conn_labels *labels = nf_ct_labels_find(ct);

	if (!labels)
		return 0;

And nf_ct_labels_find always returns NULL if CONFIG_NF_CONNTRACK_LABELS
is not enabled.  So I believe that the compiler optimises the code away
in such cases anyway.

Some advantages of this approach are:

1. Fewer #ifdefs, fewer headaches
2. The trivial implementations can be dropped
3. A follow-up patch, to conditionally compile ctnetlink_label_size
   only when it is used becomes simpler (see point 1)

Found by inspection.
Compile tested only.

Signed-off-by: Simon Horman <horms@kernel.org>
---
 net/netfilter/nf_conntrack_netlink.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 123e2e933e9b..f1f7dff08953 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -382,7 +382,6 @@ static int ctnetlink_dump_secctx(struct sk_buff *skb, const struct nf_conn *ct)
 #define ctnetlink_dump_secctx(a, b) (0)
 #endif
 
-#ifdef CONFIG_NF_CONNTRACK_LABELS
 static inline int ctnetlink_label_size(const struct nf_conn *ct)
 {
 	struct nf_conn_labels *labels = nf_ct_labels_find(ct);
@@ -411,10 +410,6 @@ ctnetlink_dump_labels(struct sk_buff *skb, const struct nf_conn *ct)
 
 	return 0;
 }
-#else
-#define ctnetlink_dump_labels(a, b) (0)
-#define ctnetlink_label_size(a)	(0)
-#endif
 
 #define master_tuple(ct) &(ct->master->tuplehash[IP_CT_DIR_ORIGINAL].tuple)
 

-- 
2.45.2

