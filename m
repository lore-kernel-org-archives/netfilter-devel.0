Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79EDB1BAECD;
	Fri, 30 Aug 2024 17:23:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725038592; cv=none; b=ZhDiWJNez05bXTMKRp4C5xxPjq0f0giNY/+pIz8xaoBqLPIhLoWAFyOixG7bWAOHqD/LdtZTorMlJZUSusxc/N03Q9mmmzSKYHgDV/NEvks0BTlykUxCltV8SwEvMYHyFFkJ5LCjjrXx9HyaD8SPv4CmzvoAe014rWPsViKDzig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725038592; c=relaxed/simple;
	bh=qmS35JHQXhfUq0wqjmXPQ6Bmv30dZKpJpDOvrVZ8w6g=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=m+kR4B+96rImkfv9pBYVlRgXyrfD7jQwGrXEWcIwil6lH3K9dxQarhXzTxaSDHbH5eU5E4nwt0PrGcvk8LI3ydKmYYHKm+ICOcnZCEcGQeQFCFz9FdOQ7ognU98COYNvbTOLJCd55HuAZwYNVv10PAdzxQpry4HJUi0aYwF4aLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=awd9PZcg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="awd9PZcg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48C13C4CEC2;
	Fri, 30 Aug 2024 17:23:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725038592;
	bh=qmS35JHQXhfUq0wqjmXPQ6Bmv30dZKpJpDOvrVZ8w6g=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=awd9PZcgSDwTDX675XIOfIWXpeZe4Tzv5gWFMPWCAFXDEm8J7L4D7stNoeTsd/hLQ
	 +m4OsV5EY+IblC3XV3zX1iXggi3KUlHCeyBP/SWAtjtgs/GR//E8vKIj3zTVa52G9R
	 pKuz9a62ZUuXmMPXZp0wDaxopfjNIa9T42teXkTSU9NKKYGLU9QcBKElCYvOPkYbvK
	 Ip+cu/jtV+PWUD3NSgagnjIDkTDixfQ50EAWKnFJCWjrQlUKWMDj0fLA1hqzWwvQBp
	 MGYghs5h13hi6zpnezeoIq0Ys/PU2VjiVl5tiP9G4lsJWJ5wH/5gQyh9p4z9S6R88o
	 gpPViNlMHjGWA==
From: Simon Horman <horms@kernel.org>
Date: Fri, 30 Aug 2024 18:23:01 +0100
Subject: [PATCH nf-next 2/2] netfilter: tproxy: Add missing Kernel doc to
 nf_tproxy.h
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240830-nf-kdoc-v1-2-b974bb701b61@kernel.org>
References: <20240830-nf-kdoc-v1-0-b974bb701b61@kernel.org>
In-Reply-To: <20240830-nf-kdoc-v1-0-b974bb701b61@kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>, 
 Jozsef Kadlecsik <kadlec@netfilter.org>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
 netdev@vger.kernel.org
X-Mailer: b4 0.14.0

Add missing documentation of function parameter.

Flagged by ./scripts/kernel-doc -none.

No functional change intended.
Compile tested only.

Signed-off-by: Simon Horman <horms@kernel.org>
---
 include/net/netfilter/nf_tproxy.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/net/netfilter/nf_tproxy.h b/include/net/netfilter/nf_tproxy.h
index faa108b1ba67..5adf6fda11e8 100644
--- a/include/net/netfilter/nf_tproxy.h
+++ b/include/net/netfilter/nf_tproxy.h
@@ -36,6 +36,7 @@ __be32 nf_tproxy_laddr4(struct sk_buff *skb, __be32 user_laddr, __be32 daddr);
 
 /**
  * nf_tproxy_handle_time_wait4 - handle IPv4 TCP TIME_WAIT reopen redirections
+ * @net:	The network namespace.
  * @skb:	The skb being processed.
  * @laddr:	IPv4 address to redirect to or zero.
  * @lport:	TCP port to redirect to or zero.

-- 
2.45.2

