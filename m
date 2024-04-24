Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3C9D158DAE;
	Wed, 24 Apr 2024 09:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713952752; cv=none; b=qyI1iwPEtvbO6xwhwbSgC8t8ncwvXuT9L2CE9a/UgRkIAl6Sip4/wUQv3OTDKCrcQiUG+GpR18X2JXrDRjCDfeOAYpxCGBL5IVT4AmIuVoPvpFS+aJiOlQ9dFb8v3/rLC9HPwj9HB1XpduCTZPUuvFBERhivlsxJaxyo4T2gvxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713952752; c=relaxed/simple;
	bh=XPv6yNocRkD2emrgbQ0btUNBr8cnHWVhXtpvKRThKaY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=r07qiTAkSFOc1dAXhzQNEVM1EkaoFxnrWcKBM8ScxrnL14Qmj1kLX/LHmrY0Rw5aWJKUIU+MeMM2z+U/W9shgyb/2x6Yi4NwJkEBHxLit27J3xd+5msckC5YewClCm69EyPT78Dww8RcoTflV0EZ8s2MyY/L+u3HxgzoIRBEz/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rzZP7-0006zI-7R; Wed, 24 Apr 2024 11:59:05 +0200
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH v2 net-next] tools: testing: selftests: prefer TEST_PROGS for conntrack_dump_flush
Date: Wed, 24 Apr 2024 11:58:20 +0200
Message-ID: <20240424095824.5555-1-fw@strlen.de>
X-Mailer: git-send-email 2.43.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently conntrack_dump_flush test program always runs when passing
TEST_PROGS argument:

% make -C tools/testing/selftests TARGETS=net/netfilter \
 TEST_PROGS=conntrack_ipip_mtu.sh run_tests
make: Entering [..]
TAP version 13
1..2 [..]
  selftests: net/netfilter: conntrack_dump_flush [..]

Move away from TEST_CUSTOM_PROGS to avoid this.  After this,
above command will only run the program specified in TEST_PROGS.

Link: https://lore.kernel.org/netdev/20240423191609.70c14c42@kernel.org/
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 v2: use TEST_GEN_PROGS instead of TEST_PROGS+.sh wrapper

 tools/testing/selftests/net/netfilter/Makefile | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/netfilter/Makefile b/tools/testing/selftests/net/netfilter/Makefile
index 68e4780edfdc..72c6001964a6 100644
--- a/tools/testing/selftests/net/netfilter/Makefile
+++ b/tools/testing/selftests/net/netfilter/Makefile
@@ -28,10 +28,9 @@ TEST_PROGS += nft_zones_many.sh
 TEST_PROGS += rpath.sh
 TEST_PROGS += xt_string.sh
 
-TEST_CUSTOM_PROGS += conntrack_dump_flush
+TEST_GEN_PROGS = conntrack_dump_flush
 
 TEST_GEN_FILES = audit_logread
-TEST_GEN_FILES += conntrack_dump_flush
 TEST_GEN_FILES += connect_close nf_queue
 TEST_GEN_FILES += sctp_collision
 
-- 
2.43.2

