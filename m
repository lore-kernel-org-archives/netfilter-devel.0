Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D04F629;
	Tue, 16 Apr 2024 05:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713245925; cv=none; b=WuQ2fpON+dNuGYwvgRm9oZVBZ2zt8gSg/9ZsR3ZzJdFLuuD6rlcoclYo/RRa/F5hBznKEQvN9QFWltE6sDMTy0RlVoT3oeRQDaCMANRAr4IVcnzzc6NIjVCY3erN+UuIQUhaJote4SPGZeqePpA8vYKZyzZU57E6MF1yGwE2Tqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713245925; c=relaxed/simple;
	bh=tuRBjBN4erHITLvn6gXpC3urGog8I/ntuAIUO1UvQDo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=RTLaZCb2aa5B2IaROtGzTHgfVL+AJBKoNDErN6Q1eq2Y3UeIriiRfjjBsNNss8z8Uq9dStWfFrWjLWBxBLZws+6n0lsU6fROX1wprH5QJ1EElpsvnJNuJwET0IU/pKOQOzXW9kQLejhNETaPwuCv7kXv/0FGk6QpaIRvNv1c7Uo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kauThYCr; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kauThYCr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713245924; x=1744781924;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=tuRBjBN4erHITLvn6gXpC3urGog8I/ntuAIUO1UvQDo=;
  b=kauThYCrY6IJ2Tr0bdQ+gyWG1UQx6jYiq8/QG3Siltk2Rv/TEW40uy6+
   NZe/T2dyKODDwYyb0gqVlf8zmkeHRWUGCePr7Rq/pdG60e/kBsitJrko8
   zrG8Ws9WVmNmpCPicqRkM0PpphQtqwRGsl3FlfQYfWyL4MyqmajkTTsgq
   FeaayYx+fbX+9285hO6nph21dDcQtXKYVAp7l6YmGftAL00dMZXyasSOd
   VLExjNIak2d58L+/uWvZ7KNaNoZSjfrH1WQMpZvsDNOdxfb9aOPEUQ9dn
   a7Zy990k20ps7euwWhlO61aJRP9EgIIW1Ny/D4GsQNS9kbOXs7kn7nimc
   A==;
X-CSE-ConnectionGUID: 2pO4qg3gR0uT2Bu/+unnrw==
X-CSE-MsgGUID: 5hLgfD2qRdi1K2CLV3Yvjw==
X-IronPort-AV: E=McAfee;i="6600,9927,11045"; a="8525511"
X-IronPort-AV: E=Sophos;i="6.07,205,1708416000"; 
   d="scan'208";a="8525511"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2024 22:38:44 -0700
X-CSE-ConnectionGUID: f43FR2cBQN+/BmdYxuEd6w==
X-CSE-MsgGUID: cj5NTgTjS2aArYF+E9rrhg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,205,1708416000"; 
   d="scan'208";a="26801372"
Received: from yujie-x299.sh.intel.com ([10.239.159.77])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2024 22:38:41 -0700
From: Yujie Liu <yujie.liu@intel.com>
To: netdev@vger.kernel.org,
	Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org,
	Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	kernel test robot <lkp@intel.com>
Subject: [PATCH net-next] selftests: fix netfilter path in Makefile
Date: Tue, 16 Apr 2024 13:32:10 +0800
Message-Id: <20240416053210.721056-1-yujie.liu@intel.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Netfilter tests have been moved to a subdir under selftests/net by
patch series [1]. Fix the path in selftests/Makefile accordingly.

This helps fix the following error:

    tools/testing/selftests$ make
    ...
    make[1]: Entering directory 'tools/testing/selftests'
    make[1]: *** netfilter: No such file or directory.  Stop.
    make[1]: Leaving directory 'tools/testing/selftests'

[1] https://lore.kernel.org/all/20240411233624.8129-1-fw@strlen.de/

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Yujie Liu <yujie.liu@intel.com>
---
 tools/testing/selftests/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
index 6dab886d6f7a..c785b6256a45 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -64,7 +64,7 @@ TARGETS += net/hsr
 TARGETS += net/mptcp
 TARGETS += net/openvswitch
 TARGETS += net/tcp_ao
-TARGETS += netfilter
+TARGETS += net/netfilter
 TARGETS += nsfs
 TARGETS += perf_events
 TARGETS += pidfd
-- 
2.34.1

