Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F2903B791;
	Mon,  9 Sep 2024 15:41:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725896472; cv=none; b=bC/dGrU+QWwagHNki/GDONDcJXcT6h2tBDfQ2FNwTOADNJsOsRSPa7WJVTrtWP9gVWzKM5Lj6Tx2VYC4l5bsAmiQSSoJ/DMfV8P/cBqeQaPA3cVMepxbaU1gaAgMuVRqAcFLlorKYdNFcsBQfUw13+2PaHqdZSDjof2UcmPkTRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725896472; c=relaxed/simple;
	bh=7vzxP9BH5QXEj6ke5NOg3e9aAiXGq0Kzq6rOQrQSMZw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=S5tpWHpU8hjj6nXz4eLyAHejXlFV3comfBzYuQoH5r5UJ5YBWk41PUXRrGcHx7/s70FsHaFIM+gzFL10N1JtQ5/LYrENtq9exLmAMpmXmNPg0W6D769Zw6YfWOWAyyX0pcTKRn8HbPOXyCen77nbOAjp3fXdHpsTQ/ks7rMIvcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RQqPcnOu; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RQqPcnOu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725896470; x=1757432470;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=7vzxP9BH5QXEj6ke5NOg3e9aAiXGq0Kzq6rOQrQSMZw=;
  b=RQqPcnOui7kvrBYtpBxVNyYIjJ1GTyIXhUvYVW88CfQtu86NAYC+Xk5B
   /wgdLhEBy+GNxJSQdezREQkdu/Gtwn1dOhH48a5rwcKVNgybzNLacjIa5
   uvCrvaJRkHBHNMAWIu/AdcfUAd33xYrr1Eqn9hBH2B3t49ZOtjsZ5n62U
   M2FJpFv7uV+N6xBIKI/4RicJZ/XRzobtZHQbkAt1gxqXKck9VaRyLioFV
   zyajj/8P9wg15HakS8QyarA28XT3izBh6kIORNMvHNUnazgPhnt7hyphm
   SMycdXUifxkxx/oVbc8RWFZvMOrnER/3YWEylXInJEYHkZx6lDDvaspWk
   g==;
X-CSE-ConnectionGUID: jPKw+iZVRQ6qEWVyL8JpwA==
X-CSE-MsgGUID: djd8DkljRvuMcYwR0KywRA==
X-IronPort-AV: E=McAfee;i="6700,10204,11190"; a="24476485"
X-IronPort-AV: E=Sophos;i="6.10,214,1719903600"; 
   d="scan'208";a="24476485"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2024 08:41:09 -0700
X-CSE-ConnectionGUID: TeqJXNiRSZesjnMlHYEQ8A==
X-CSE-MsgGUID: dhkNtVyaR1Gkke20Q2VbRw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,214,1719903600"; 
   d="scan'208";a="66502268"
Received: from black.fi.intel.com ([10.237.72.28])
  by orviesa010.jf.intel.com with ESMTP; 09 Sep 2024 08:41:05 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
	id 1876C18D; Mon, 09 Sep 2024 18:41:04 +0300 (EEST)
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Felix Huettner <felix.huettner@mail.schwarz>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev
Cc: Jozsef Kadlecsik <kadlec@netfilter.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH net-next v2 1/1] netfilter: conntrack: Guard possible unused functions
Date: Mon,  9 Sep 2024 18:39:56 +0300
Message-ID: <20240909154043.1381269-2-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.43.0.rc1.1336.g36b5255a03ac
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Some of the functions may be unused, it prevents kernel builds
with clang, `make W=1` and CONFIG_WERROR=y:

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
---
v2: fixed typo, dropped Fixes (Simon), optimised by reusing existing ifdeffery
 net/netfilter/nf_conntrack_netlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 4cbf71d0786b..39430f333f05 100644
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
2.43.0.rc1.1336.g36b5255a03ac

