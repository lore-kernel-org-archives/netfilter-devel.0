Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA3CF1AF4DB;
	Thu, 26 Sep 2024 11:07:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727348858; cv=none; b=EFceJ+OGc//WQrFNTCfx0fKWaHFyOExCLPmjlBAynb5srG7PHZpjr4CD5rxN8vg41jxCANvwpkdLVGwxwiR6fPfUCA1jnwcqPKPw8Xf353qwAqdaIHZ6sdTrqsdW2qc2zJbufqe+X8mB4YFVwaa2x0oYkIQWB+xMYApNl0yIO/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727348858; c=relaxed/simple;
	bh=BIHBpMFZA+VLGFCRlyfVxoT4sx3J8q/NIwfNHE8phP0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=W5GK0imkSEioRXO8yJ04/QbHas5vXof8c7UK7+6NoK4JlRgxW2gmp/8JOB4K/ziIZSCL9t1sz48pZuHKen2M5dAg+Sj0ffFK9pRf4n+WmskLlXI7zSoYY24Dv0hwZOxzFg7763MaHVQKa+KxVQe8eIFiqeSlUy/yFN1gw9tYnhs=
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
Subject: [PATCH net 05/14] netfilter: ctnetlink: Guard possible unused functions
Date: Thu, 26 Sep 2024 13:07:08 +0200
Message-Id: <20240926110717.102194-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240926110717.102194-1-pablo@netfilter.org>
References: <20240926110717.102194-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Some of the functions may be unused (CONFIG_NETFILTER_NETLINK_GLUE_CT=n
and CONFIG_NF_CONNTRACK_EVENTS=n), it prevents kernel builds with clang,
`make W=1` and CONFIG_WERROR=y:

net/netfilter/nf_conntrack_netlink.c:657:22: error: unused function 'ctnetlink_acct_size' [-Werror,-Wunused-function]
  657 | static inline size_t ctnetlink_acct_size(const struct nf_conn *ct)
      |                      ^~~~~~~~~~~~~~~~~~~
net/netfilter/nf_conntrack_netlink.c:667:19: error: unused function 'ctnetlink_secctx_size' [-Werror,-Wunused-function]
  667 | static inline int ctnetlink_secctx_size(const struct nf_conn *ct)
      |                   ^~~~~~~~~~~~~~~~~~~~~
net/netfilter/nf_conntrack_netlink.c:683:22: error: unused function 'ctnetlink_timestamp_size' [-Werror,-Wunused-function]
  683 | static inline size_t ctnetlink_timestamp_size(const struct nf_conn *ct)
      |                      ^~~~~~~~~~~~~~~~~~~~~~~~

Fix this by guarding possible unused functions with ifdeffery.

See also commit 6863f5643dd7 ("kbuild: allow Clang to find unused static
inline functions for W=1 build").

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_netlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 123e2e933e9b..8fd2b9e392a7 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -652,7 +652,6 @@ static size_t ctnetlink_proto_size(const struct nf_conn *ct)
 
 	return len + len4;
 }
-#endif
 
 static inline size_t ctnetlink_acct_size(const struct nf_conn *ct)
 {
@@ -690,6 +689,7 @@ static inline size_t ctnetlink_timestamp_size(const struct nf_conn *ct)
 	return 0;
 #endif
 }
+#endif
 
 #ifdef CONFIG_NF_CONNTRACK_EVENTS
 static size_t ctnetlink_nlmsg_size(const struct nf_conn *ct)
-- 
2.30.2

