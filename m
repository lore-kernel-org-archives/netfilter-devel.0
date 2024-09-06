Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2669172BA9;
	Fri,  6 Sep 2024 14:55:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725634522; cv=none; b=i45r7Ey43p28ZwIORXodcY5Y+kJTft8R+OMvxc2LiFbA3JnsR8+wSpzFcP945ffUTAD6nwlrwX2xXIaVmNNIJ95oaqzMAjvv6TrHxjxL5jYhz6A+kBg6n8ySMoU8EJxaKGN7ETzVWhWb5tVV9NTlmOx5v1NbJe2Nl9gJJajs1iU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725634522; c=relaxed/simple;
	bh=MFuZNLwda90vW+mPXIjOs38OY9mGR52AE5fGXpmm25k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ANh4iGCovB19yFSXCEcHNHk7GMl5bNa1eFrt+nk1xvnk9Sjrzcr44S6wBGLdke7BLznWNLF52+vOp4vofIYAeQkc9IJufyFnpup95Y6NccM7YUDfDXU5ltvwuJO7vC05SOQ7/tJaOCYEqAlF8fH4G1e/F/9y1GJF6K4Mv7QkgZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Y3IAtx+Y; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Y3IAtx+Y"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725634521; x=1757170521;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=MFuZNLwda90vW+mPXIjOs38OY9mGR52AE5fGXpmm25k=;
  b=Y3IAtx+YkuRWCM7NovAjjN6zcjyJ5yYBtNrEicF5e2aLRAGhq8Rhgr61
   IQOf3dWrimUHslCuHnPtulWhGTFMxY5jtHS6+n+SJn93YSA3enuyfB9xb
   ydJRYziumjHfsujXkxNu1J8aM3v+m8ee1n8t4l5nqFeJ0c6xIB9NPiaa4
   kYfDLAnhZIwwgzF7p15eubkE9d/9WYSH0E/wUgOdgR3VEF38zJKE455jm
   bNKX4+Cc9sjq8ECtUw9hZh+0GDP8bsua+imRn0bKZhITDwiP8FbaXn94X
   bI2HAegooDkUJekNg8R+QPs/ljDqIuc9lRSM7Z9R0z9h5rjEj3O+TNEWp
   w==;
X-CSE-ConnectionGUID: pqNaLdhqSJK+kBNTC6TTpw==
X-CSE-MsgGUID: 4j9Hj01uT1OUjCoMmkYjIg==
X-IronPort-AV: E=McAfee;i="6700,10204,11187"; a="23900516"
X-IronPort-AV: E=Sophos;i="6.10,208,1719903600"; 
   d="scan'208";a="23900516"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Sep 2024 07:55:20 -0700
X-CSE-ConnectionGUID: 69DWNT1tTrKmjA8uXnUubQ==
X-CSE-MsgGUID: fXGnhljAQQGHcGChVQ28fw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,208,1719903600"; 
   d="scan'208";a="70917921"
Received: from black.fi.intel.com ([10.237.72.28])
  by orviesa004.jf.intel.com with ESMTP; 06 Sep 2024 07:55:16 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
	id BD38613E; Fri, 06 Sep 2024 17:55:14 +0300 (EEST)
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev
Cc: Jozsef Kadlecsik <kadlec@netfilter.org>,
	"David S. Miller" <davem@davemloft.net>,
	David Ahern <dsahern@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH net v1 1/1] netfilter: nf_reject: Fix build error when CONFIG_BRIDGE_NETFILTER=n
Date: Fri,  6 Sep 2024 17:55:13 +0300
Message-ID: <20240906145513.567781-1-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.43.0.rc1.1336.g36b5255a03ac
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In some cases (CONFIG_BRIDGE_NETFILTER=n) the pointer to IP header
is set but not used, it prevents kernel builds with clang, `make W=1`
and CONFIG_WERROR=y:

ipv6: split nf_send_reset6() in smaller functions
netfilter: nf_reject_ipv4: split nf_send_reset() in smaller functions

net/ipv4/netfilter/nf_reject_ipv4.c:243:16: error: variable 'niph' set but not used [-Werror,-Wunused-but-set-variable]
  243 |         struct iphdr *niph;
      |                       ^
net/ipv6/netfilter/nf_reject_ipv6.c:286:18: error: variable 'ip6h' set but not used [-Werror,-Wunused-but-set-variable]
  286 |         struct ipv6hdr *ip6h;
      |                         ^

Fix these by marking respective variables with __maybe_unused as it
seems more complicated to address that in a better way due to ifdeffery.

Fixes: 8bfcdf6671b1 ("netfilter: nf_reject_ipv6: split nf_send_reset6() in smaller functions")
Fixes: 052b9498eea5 ("netfilter: nf_reject_ipv4: split nf_send_reset() in smaller functions")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 net/ipv4/netfilter/nf_reject_ipv4.c | 2 +-
 net/ipv6/netfilter/nf_reject_ipv6.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/netfilter/nf_reject_ipv4.c b/net/ipv4/netfilter/nf_reject_ipv4.c
index 04504b2b51df..0af42494ac66 100644
--- a/net/ipv4/netfilter/nf_reject_ipv4.c
+++ b/net/ipv4/netfilter/nf_reject_ipv4.c
@@ -240,7 +240,7 @@ void nf_send_reset(struct net *net, struct sock *sk, struct sk_buff *oldskb,
 		   int hook)
 {
 	struct sk_buff *nskb;
-	struct iphdr *niph;
+	struct iphdr *niph __maybe_unused;
 	const struct tcphdr *oth;
 	struct tcphdr _oth;
 
diff --git a/net/ipv6/netfilter/nf_reject_ipv6.c b/net/ipv6/netfilter/nf_reject_ipv6.c
index dedee264b8f6..f5ed4e779b72 100644
--- a/net/ipv6/netfilter/nf_reject_ipv6.c
+++ b/net/ipv6/netfilter/nf_reject_ipv6.c
@@ -283,7 +283,7 @@ void nf_send_reset6(struct net *net, struct sock *sk, struct sk_buff *oldskb,
 	const struct tcphdr *otcph;
 	unsigned int otcplen, hh_len;
 	const struct ipv6hdr *oip6h = ipv6_hdr(oldskb);
-	struct ipv6hdr *ip6h;
+	struct ipv6hdr *ip6h __maybe_unused;
 	struct dst_entry *dst = NULL;
 	struct flowi6 fl6;
 
-- 
2.43.0.rc1.1336.g36b5255a03ac

