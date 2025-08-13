Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 389E92868B2
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Aug 2025 17:05:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755104761; cv=none; b=Hy2yjaxq9J2B3mHyDxrPntzOpd7cgSNpesY0Ap01cGB3/alokhj9HIPX/eu8vQcg5/DlQzRBSjyHsJ7vsCXvBAhBppmRRWc6SOannRlR7SNjcvJIbo8OwaKsnWxik0biRJRSTAF+G9odrhNar2gbaBpMgNtzRYSP4BHJU3Iaid8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755104761; c=relaxed/simple;
	bh=HFjEP2twctQsMt7mMgda/9DXS8I6JtUjhiFE+5Ab/W0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Us0cuPC6O/3KyloLrDx5TEp5JA2ByB9Fdig7Muen+CF4bbQqFMv0yv9+EuMYGDMes78jf4gx2Mj+2bo4Eiw4S+Ms3SbrMDxV3uHw3o4ur7m43n8rqES7US2K56BJAggxyCs9xH9EzxGuLzLTkhWCP6gc06d/F6jq+eSkSS3jkPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=j7Nj0ZbY; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="j7Nj0ZbY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Vfy+WH7aNmnOcUDUg+MNJtghSB4l2eJP30ZLSB5kl9Q=; b=j7Nj0ZbYrNcR62q+pj428Tttaj
	Gp3t92mgbeaSLHO/0o6EdGo25+X1v18+BeO/eQAF5ABQJsWVSQeAj6BMmJCM+nrTFdm1Oztq01tZZ
	O+pnAQ/eGgQaGj+/y/wUCRzAfMCV2prZtA1Dx8cYkta6J59aV+Z7zGIkwEdOKUspjUC/wDfq13Dq7
	C5zs9yHQSkaaQ8Z8cD6RBGPxdjvUKLlYXX9ZWfGRae7om9GV/7l+pSL2+c8fquXSMgeQ4EYmev366
	s9lP6vxx1HoPhhb6eFLys8SvLXYgo5TaRlS9mUo8oUcElTVGbPGJ9zWcqg1z4X4Aj5kJIu7+4x+tP
	m5jA3FjA==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1umEvF-000000003nk-22IQ;
	Wed, 13 Aug 2025 19:05:57 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH 09/14] tests: py: Drop redundant payloads for ip/ip.t
Date: Wed, 13 Aug 2025 19:05:44 +0200
Message-ID: <20250813170549.27880-10-phil@nwl.cc>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250813170549.27880-1-phil@nwl.cc>
References: <20250813170549.27880-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Each was present multiple times, introduced probably by copying from a
respective .got file.

Fixes: 77def2d43466e ("netlink_delinearize: support for bitfield payload statement with binary operation")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/py/ip/ip.t.payload.bridge | 261 --------------------------------
 tests/py/ip/ip.t.payload.inet   | 176 ---------------------
 2 files changed, 437 deletions(-)

diff --git a/tests/py/ip/ip.t.payload.bridge b/tests/py/ip/ip.t.payload.bridge
index 94da3e9092d35..663f87d7b4acf 100644
--- a/tests/py/ip/ip.t.payload.bridge
+++ b/tests/py/ip/ip.t.payload.bridge
@@ -829,264 +829,3 @@ bridge test-bridge input
   [ payload load 2b @ network header + 0 => reg 1 ]
   [ bitwise reg 1 = ( reg 1 & 0x0000fff1 ) ^ 0x00000000 ]
   [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
-
-# ip ecn set ip ecn | ect0
-bridge test-bridge input
-  [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
-  [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000fdff ) ^ 0x00000200 ]
-  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
-
-# ip ecn set ip ecn | ect1
-bridge test-bridge input
-  [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
-  [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000feff ) ^ 0x00000100 ]
-  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
-
-# ip ecn set ip ecn & ect0
-bridge test-bridge input
-  [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
-  [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000feff ) ^ 0x00000000 ]
-  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
-
-# ip ecn set ip ecn & ect1
-bridge test-bridge input
-  [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
-  [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000fdff ) ^ 0x00000000 ]
-  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
-
-# ip dscp set ip dscp | lephb
-bridge test-bridge input
-  [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
-  [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000fbff ) ^ 0x00000400 ]
-  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
-# ip dscp set ip dscp & lephb
-bridge test-bridge input
-  [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
-  [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x000007ff ) ^ 0x00000000 ]
-  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
-
-# ip dscp set ip dscp & 0x1f
-bridge test-bridge input
-  [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
-  [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x00007fff ) ^ 0x00000000 ]
-  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
-
-# ip version set ip version | 1
-bridge test-bridge input
-  [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
-  [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000ffef ) ^ 0x00000010 ]
-  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
-
-# ip version set ip version & 1
-bridge test-bridge input
-  [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
-  [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000ff1f ) ^ 0x00000000 ]
-  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
-
-# ip hdrlength set ip hdrlength | 1
-bridge test-bridge input
-  [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
-  [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000fffe ) ^ 0x00000001 ]
-  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
-
-# ip hdrlength set ip hdrlength & 1
-bridge test-bridge input
-  [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
-  [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000fff1 ) ^ 0x00000000 ]
-  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
-
-# ip ecn set ip ecn | ect0
-bridge test-bridge input
-  [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
-  [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000fdff ) ^ 0x00000200 ]
-  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
-
-# ip ecn set ip ecn | ect1
-bridge test-bridge input
-  [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
-  [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000feff ) ^ 0x00000100 ]
-  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
-
-# ip ecn set ip ecn & ect0
-bridge test-bridge input
-  [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
-  [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000feff ) ^ 0x00000000 ]
-  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
-
-# ip ecn set ip ecn & ect1
-bridge test-bridge input
-  [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
-  [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000fdff ) ^ 0x00000000 ]
-  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
-
-# ip dscp set ip dscp | lephb
-bridge test-bridge input
-  [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
-  [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000fbff ) ^ 0x00000400 ]
-  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
-# ip dscp set ip dscp & lephb
-bridge test-bridge input
-  [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
-  [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x000007ff ) ^ 0x00000000 ]
-  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
-
-# ip dscp set ip dscp & 0x1f
-bridge test-bridge input
-  [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
-  [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x00007fff ) ^ 0x00000000 ]
-  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
-
-# ip version set ip version | 1
-bridge test-bridge input
-  [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
-  [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000ffef ) ^ 0x00000010 ]
-  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
-
-# ip version set ip version & 1
-bridge test-bridge input
-  [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
-  [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000ff1f ) ^ 0x00000000 ]
-  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
-
-# ip hdrlength set ip hdrlength | 1
-bridge test-bridge input
-  [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
-  [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000fffe ) ^ 0x00000001 ]
-  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
-
-# ip hdrlength set ip hdrlength & 1
-bridge test-bridge input
-  [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
-  [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000fff1 ) ^ 0x00000000 ]
-  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
-
-# ip ecn set ip ecn | ect0
-bridge test-bridge input
-  [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
-  [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000fdff ) ^ 0x00000200 ]
-  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
-
-# ip ecn set ip ecn | ect1
-bridge test-bridge input
-  [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
-  [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000feff ) ^ 0x00000100 ]
-  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
-
-# ip ecn set ip ecn & ect0
-bridge test-bridge input
-  [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
-  [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000feff ) ^ 0x00000000 ]
-  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
-
-# ip ecn set ip ecn & ect1
-bridge test-bridge input
-  [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
-  [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000fdff ) ^ 0x00000000 ]
-  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
-
-# ip dscp set ip dscp | lephb
-bridge test-bridge input
-  [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
-  [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000fbff ) ^ 0x00000400 ]
-  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
-# ip dscp set ip dscp & lephb
-bridge test-bridge input
-  [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
-  [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x000007ff ) ^ 0x00000000 ]
-  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
-
-# ip dscp set ip dscp & 0x1f
-bridge test-bridge input
-  [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
-  [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x00007fff ) ^ 0x00000000 ]
-  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
-
-# ip version set ip version | 1
-bridge test-bridge input
-  [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
-  [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000ffef ) ^ 0x00000010 ]
-  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
-
-# ip version set ip version & 1
-bridge test-bridge input
-  [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
-  [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000ff1f ) ^ 0x00000000 ]
-  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
-
-# ip hdrlength set ip hdrlength | 1
-bridge test-bridge input
-  [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
-  [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000fffe ) ^ 0x00000001 ]
-  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
-
-# ip hdrlength set ip hdrlength & 1
-bridge test-bridge input
-  [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
-  [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000fff1 ) ^ 0x00000000 ]
-  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
diff --git a/tests/py/ip/ip.t.payload.inet b/tests/py/ip/ip.t.payload.inet
index 2004a3ebd1c06..b8ab49c871430 100644
--- a/tests/py/ip/ip.t.payload.inet
+++ b/tests/py/ip/ip.t.payload.inet
@@ -829,179 +829,3 @@ inet test-inet input
   [ payload load 2b @ network header + 0 => reg 1 ]
   [ bitwise reg 1 = ( reg 1 & 0x0000fff1 ) ^ 0x00000000 ]
   [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
-
-# ip ecn set ip ecn | ect0
-inet test-inet input
-  [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
-  [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000fdff ) ^ 0x00000200 ]
-  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
-
-# ip ecn set ip ecn | ect1
-inet test-inet input
-  [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
-  [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000feff ) ^ 0x00000100 ]
-  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
-
-# ip ecn set ip ecn & ect0
-inet test-inet input
-  [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
-  [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000feff ) ^ 0x00000000 ]
-  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
-
-# ip ecn set ip ecn & ect1
-inet test-inet input
-  [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
-  [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000fdff ) ^ 0x00000000 ]
-  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
-
-# ip dscp set ip dscp | lephb
-inet test-inet input
-  [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
-  [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000fbff ) ^ 0x00000400 ]
-  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
-
-# ip dscp set ip dscp & lephb
-inet test-inet input
-  [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
-  [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x000007ff ) ^ 0x00000000 ]
-  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
-
-# ip dscp set ip dscp & 0x1f
-inet test-inet input
-  [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
-  [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x00007fff ) ^ 0x00000000 ]
-  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
-
-# ip version set ip version | 1
-inet test-inet input
-  [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
-  [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000ffef ) ^ 0x00000010 ]
-  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
-
-# ip version set ip version & 1
-inet test-inet input
-  [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
-  [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000ff1f ) ^ 0x00000000 ]
-  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
-
-# ip hdrlength set ip hdrlength | 1
-inet test-inet input
-  [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
-  [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000fffe ) ^ 0x00000001 ]
-  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
-
-# ip hdrlength set ip hdrlength & 1
-inet test-inet input
-  [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
-  [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000fff1 ) ^ 0x00000000 ]
-  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
-
-# ip ecn set ip ecn | ect0
-inet test-inet input
-  [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
-  [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000fdff ) ^ 0x00000200 ]
-  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
-
-# ip ecn set ip ecn | ect1
-inet test-inet input
-  [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
-  [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000feff ) ^ 0x00000100 ]
-  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
-
-# ip ecn set ip ecn & ect0
-inet test-inet input
-  [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
-  [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000feff ) ^ 0x00000000 ]
-  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
-
-# ip ecn set ip ecn & ect1
-inet test-inet input
-  [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
-  [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000fdff ) ^ 0x00000000 ]
-  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
-
-# ip dscp set ip dscp | lephb
-inet test-inet input
-  [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
-  [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000fbff ) ^ 0x00000400 ]
-  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
-
-# ip dscp set ip dscp & lephb
-inet test-inet input
-  [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
-  [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x000007ff ) ^ 0x00000000 ]
-  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
-
-# ip dscp set ip dscp & 0x1f
-inet test-inet input
-  [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
-  [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x00007fff ) ^ 0x00000000 ]
-  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
-
-# ip version set ip version | 1
-inet test-inet input
-  [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
-  [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000ffef ) ^ 0x00000010 ]
-  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
-
-# ip version set ip version & 1
-inet test-inet input
-  [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
-  [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000ff1f ) ^ 0x00000000 ]
-  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
-
-# ip hdrlength set ip hdrlength | 1
-inet test-inet input
-  [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
-  [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000fffe ) ^ 0x00000001 ]
-  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
-
-# ip hdrlength set ip hdrlength & 1
-inet test-inet input
-  [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
-  [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000fff1 ) ^ 0x00000000 ]
-  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
-- 
2.49.0

