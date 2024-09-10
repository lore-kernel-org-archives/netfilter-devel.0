Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 301F6183CB0;
	Tue, 10 Sep 2024 08:36:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725957412; cv=none; b=MkMw313qUnX/oK/HUsdgS7GOjP3qCfgclOIVOo5LL4TnU7ha14d/Mlnei5UiIpP9ZsrOVAGj995oLmljal6I1C3vT97cT5WlaQ2snN++ZqA8x+8tagxZ9VW7M9P0bHBmUtzjWatk41eiD/48dWRdqfw4WcrcopyPKMoQcifVyag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725957412; c=relaxed/simple;
	bh=BQGYlJ0DC8YIrx6+Mr6rYMoYhXFpvP8CHsOYUrBmHzs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lMhUCvew0qPZyZ1SsTRzKtaZh30DpBb8OrGjC3uyUsq/H4+O+MafI1PypRt/0fKE8dVsgjLI52IA7BZMLPFt3q9Y5bQKcEEUizctF1ndnGJYxPaSOLB0OD3d3DLPxwWpMO5Ig8YylVW0dxNDtFgeAxtOED57+0YhBfwcaYmNa64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=noYzfqdp; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="noYzfqdp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725957411; x=1757493411;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=BQGYlJ0DC8YIrx6+Mr6rYMoYhXFpvP8CHsOYUrBmHzs=;
  b=noYzfqdpn/h671YOVe3Gz6jQ4Bjm2BpkOS4gieqig9lSZzQ+FAcEZnKl
   mI3P2/PPiMh5CI0KmJzx7fP/BX3VpDZTHL7brKhA+ndqkIYQcOoab3JWI
   GVsgNcSnRpz3jKpU3eJrtJMSLNMF6tKGu/V6xNcYi2AVIhxCi6jSLIDrU
   gwx2w1jmeyEKgJVm4MsBHTX6abagW+n7q6zgi0SXRiyl0JkgNuubX933Q
   G+988ndJUhRD3XMADFN4edOxChJH3fjataledxCdji2yVUthX5LJbbtbl
   lbabx0SN5lHJ2KgTYqDwCpdxaKuzt0kBcw0r2+uttBAjo1WZlfnOrtntx
   w==;
X-CSE-ConnectionGUID: Ul0d/OFIRDS7532oxUwiOQ==
X-CSE-MsgGUID: XX1hrtn1TMucXLheK+kdzg==
X-IronPort-AV: E=McAfee;i="6700,10204,11190"; a="36070487"
X-IronPort-AV: E=Sophos;i="6.10,216,1719903600"; 
   d="scan'208";a="36070487"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2024 01:36:48 -0700
X-CSE-ConnectionGUID: U1aMLAZkQXabRNzWsVv1fA==
X-CSE-MsgGUID: SkRnGgpBTkykZc253NDaig==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,216,1719903600"; 
   d="scan'208";a="71357816"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmviesa005.fm.intel.com with ESMTP; 10 Sep 2024 01:36:43 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
	id EC0E520B; Tue, 10 Sep 2024 11:36:41 +0300 (EEST)
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
Subject: [PATCH net-next v3 1/1] netfilter: conntrack: Guard possible unused functions
Date: Tue, 10 Sep 2024 11:35:33 +0300
Message-ID: <20240910083640.1485541-1-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.43.0.rc1.1336.g36b5255a03ac
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
---

v3: explicitly mentioned the configuration options that lead to issue (Simon)
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

