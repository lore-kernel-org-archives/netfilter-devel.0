Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 591F719D897;
	Thu,  5 Sep 2024 20:36:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725568583; cv=none; b=sX9uioPZ3xZjrazUaIQ0jX0ko8NT82EG/qgx3HghVrV5sBSdpxTPyVNDSTc9QogwNfManA9R9s6enafJtojL7Ub/ezMTrN1JKt+RUVfxuNDgn0X0pWnn9suBgCBIHbKUJl4zU9O6FppaYE1Ec7w79lMCBFQKvGT3r1LRPJQn6kw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725568583; c=relaxed/simple;
	bh=3smZTLdjqVJBDU000AvNAnMsFP19IXssykG6fzVljXY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=MbfMkucZe10Mh7rmQXibXE4sGChxbVLFDlFC/clqZJKGqzh16cYYHCFEHuEEhVD6qT7mMSTzkLq+otN7AOs0Zu1ZwdP8S2js0JzoVb2qMvo6mvI9ITU9XRp0vTkrgAzORhgsJ1yRXQgPAT0jF5HDa/pwhMLtGrq4ZJkSUWlbK/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DZrjHtZP; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DZrjHtZP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725568580; x=1757104580;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=3smZTLdjqVJBDU000AvNAnMsFP19IXssykG6fzVljXY=;
  b=DZrjHtZP7nbQHRsCnhwN5h8ndJsIPitXEW88XnOxDz2wLRSM0948RpdN
   fPfqZc5jwf0iNAJKV0juGM6wgIZkIW+q3Nzqs3COp320H6QxZ2vTPRpZR
   UKvogGRLlxILbNaEzS9WW7EKs2Ilvw99WxOjfGWGZE8GccLGvn3yCKr+H
   dCw7d8ChBIKlHtaMGGAgHwhJK+Wkdn8kfoHFtVsqjnqVEWFqRvyMi/Cs+
   srZkoO0CFoy+fiveJGZwtFbKkz59yfzl6MwAgxdZIHyng8049xm4ug0GO
   9DmxiX49IfCl5IljfCLLUFWMCJxP6Zg672r3fdXbIFCmCWwLu6dP5aa0f
   Q==;
X-CSE-ConnectionGUID: Tcb14q8OT6ezXZo8a3N+nQ==
X-CSE-MsgGUID: AhAFBgpbQ4az1108hYgtgw==
X-IronPort-AV: E=McAfee;i="6700,10204,11186"; a="23816962"
X-IronPort-AV: E=Sophos;i="6.10,205,1719903600"; 
   d="scan'208";a="23816962"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Sep 2024 13:36:20 -0700
X-CSE-ConnectionGUID: 2w8SmdCORLyvd1eRSuY3pA==
X-CSE-MsgGUID: PKoY7JYeQ9+U8pEPP5ELsA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,205,1719903600"; 
   d="scan'208";a="96520887"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmviesa001.fm.intel.com with ESMTP; 05 Sep 2024 13:36:16 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
	id C737E31E; Thu, 05 Sep 2024 23:36:14 +0300 (EEST)
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
Subject: [PATCH net v1 1/1] netfilter: conntrack: Guard possoble unused functions
Date: Thu,  5 Sep 2024 23:36:12 +0300
Message-ID: <20240905203612.333421-1-andriy.shevchenko@linux.intel.com>
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

Fixes: 4a96300cec88 ("netfilter: ctnetlink: restore inlining for netlink message size calculation")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 net/netfilter/nf_conntrack_netlink.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 4cbf71d0786b..7ab7dc7569e7 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -654,6 +654,7 @@ static size_t ctnetlink_proto_size(const struct nf_conn *ct)
 }
 #endif
 
+#if defined(CONFIG_NF_CONNTRACK_EVENTS) || defined(CONFIG_NETFILTER_NETLINK_GLUE_CT)
 static inline size_t ctnetlink_acct_size(const struct nf_conn *ct)
 {
 	if (!nf_ct_ext_exist(ct, NF_CT_EXT_ACCT))
@@ -690,6 +691,7 @@ static inline size_t ctnetlink_timestamp_size(const struct nf_conn *ct)
 	return 0;
 #endif
 }
+#endif
 
 #ifdef CONFIG_NF_CONNTRACK_EVENTS
 static size_t ctnetlink_nlmsg_size(const struct nf_conn *ct)
-- 
2.43.0.rc1.1336.g36b5255a03ac

