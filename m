Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 012D91DE3DE;
	Wed,  6 Nov 2024 23:46:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730936804; cv=none; b=CuRZ9XBSpabixaQAjPC0Ld2HQnk/WI0Ph96XZXyEyRQd+FnVlEDKrNjSY5BcanU/X9bEiBUtaV7WbY4WqY4Y6HVlihzekNM6bzl9AEWvnxpIdrZmefdqs5QlyDRAz9CjchxJAit16cKDaPnDnQm4D96sIX0ffgZ3bJBHnUTpHg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730936804; c=relaxed/simple;
	bh=FCPtCk4CbWFDou0Q9B78YNMopnFHk8hDYJhakoxBbdE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BoLOh67WflhE47XXeZ0oFqa/rbWO/e6fb1hOQht/e3OaYPRpoF+8zFV0WdXlpp8bqIo6SWczas277/+uS9jRUGGP1EJwSZId4GU4kyif+Yg+PnohploHQFzix9YlhVrxWMlCbN1eZLZxvksvbSp27LJwRWiSVjyC5D+CArcD34c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de
Subject: [PATCH net-next 03/11] netfilter: nf_tables: replace deprecated strncpy with strscpy_pad
Date: Thu,  7 Nov 2024 00:46:17 +0100
Message-Id: <20241106234625.168468-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20241106234625.168468-1-pablo@netfilter.org>
References: <20241106234625.168468-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Justin Stitt <justinstitt@google.com>

strncpy() is deprecated for use on NUL-terminated destination strings [1] and
as such we should prefer more robust and less ambiguous string interfaces.

In this particular instance, the usage of strncpy() is fine and works as
expected. However, towards the goal of [2], we should consider replacing
it with an alternative as many instances of strncpy() are bug-prone. Its
removal from the kernel promotes better long term health for the
codebase.

The current usage of strncpy() likely just wants the NUL-padding
behavior offered by strncpy() and doesn't care about the
NUL-termination. Since the compiler doesn't know the size of @dest, we
can't use strtomem_pad(). Instead, use strscpy_pad() which behaves
functionally the same as strncpy() in this context -- as we expect
br_dev->name to be NUL-terminated itself.

Link: https://www.kernel.org/doc/html/latest/process/deprecated.html#strncpy-on-nul-terminated-strings [1]
Link: https://github.com/KSPP/linux/issues/90 [2]
Link: https://manpages.debian.org/testing/linux-manual-4.8/strscpy.9.en.html
Cc: Kees Cook <keescook@chromium.org>
Cc: linux-hardening@vger.kernel.org
Signed-off-by: Justin Stitt <justinstitt@google.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/bridge/netfilter/nft_meta_bridge.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bridge/netfilter/nft_meta_bridge.c b/net/bridge/netfilter/nft_meta_bridge.c
index d12a221366d6..5adced1e7d0c 100644
--- a/net/bridge/netfilter/nft_meta_bridge.c
+++ b/net/bridge/netfilter/nft_meta_bridge.c
@@ -63,7 +63,7 @@ static void nft_meta_bridge_get_eval(const struct nft_expr *expr,
 		return nft_meta_get_eval(expr, regs, pkt);
 	}
 
-	strncpy((char *)dest, br_dev ? br_dev->name : "", IFNAMSIZ);
+	strscpy_pad((char *)dest, br_dev ? br_dev->name : "", IFNAMSIZ);
 	return;
 err:
 	regs->verdict.code = NFT_BREAK;
-- 
2.30.2

