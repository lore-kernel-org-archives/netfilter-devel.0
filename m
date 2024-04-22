Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AC0414F136;
	Mon, 22 Apr 2024 10:38:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713782316; cv=none; b=LGLb2rocpr79byRXJXHKbpES2kYspeaWjgr7bU+Qfs3+jtozZiIY+dCvoZGpxqMYvH2lEa2vJzDU3sTig9CLyngdONZqqrSpSpT2Dmq7047zz24FG8uTQvkI3jCx68T907S2+GJh+Dts/+LWQoVJPxwCK5rzi/mBIoSxSAhfYWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713782316; c=relaxed/simple;
	bh=ew4Q8Zq83nEpysskpHTutw3KdtjFM/em5pA/Zcy1Ts8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Fw1ZeXaQAIg38xWqoDn+fZcidGmRcmM9zm77zCKwBBzqlN346Mb0B47Pk+s44yPhgeGrAXlxTNmsflXOvsfI/l8+ssUeJAcaS5g0t0rAhfApQ3MBFmuHYHYy5tt2P+qtTDvPPT2f2AdBDKimxyFDXZOGK+/s14FI0eGZ6rndAgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1ryr45-0007C0-Do; Mon, 22 Apr 2024 12:38:25 +0200
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net-next] selftests: netfilter: fix conntrack_dump_flush retval on unsupported kernel
Date: Mon, 22 Apr 2024 12:33:53 +0200
Message-ID: <20240422103358.3511-1-fw@strlen.de>
X-Mailer: git-send-email 2.43.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

With CONFIG_NETFILTER=n test passes instead of skip.  Before:

 ./run_kselftest.sh -t net/netfilter:conntrack_dump_flush
[..]
 # Starting 3 tests from 1 test cases.
 #  RUN           conntrack_dump_flush.test_dump_by_zone ...
 mnl_socket_open: Protocol not supported
[..]
 ok 3 conntrack_dump_flush.test_flush_by_zone_default
 # PASSED: 3 / 3 tests passed.
 # Totals: pass:3 fail:0 xfail:0 xpass:0 skip:0 error:0

After:
  mnl_socket_open: Protocol not supported
[..]
  ok 3 conntrack_dump_flush.test_flush_by_zone_default # SKIP cannot open netlink_netfilter socket
  # PASSED: 3 / 3 tests passed.
  # Totals: pass:0 fail:0 xfail:0 xpass:0 skip:3 error:0

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 .../selftests/net/netfilter/conntrack_dump_flush.c        | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/net/netfilter/conntrack_dump_flush.c b/tools/testing/selftests/net/netfilter/conntrack_dump_flush.c
index ca8d6b976c42..bd9317bf5ada 100644
--- a/tools/testing/selftests/net/netfilter/conntrack_dump_flush.c
+++ b/tools/testing/selftests/net/netfilter/conntrack_dump_flush.c
@@ -313,13 +313,11 @@ FIXTURE_SETUP(conntrack_dump_flush)
 	self->sock = mnl_socket_open(NETLINK_NETFILTER);
 	if (!self->sock) {
 		perror("mnl_socket_open");
-		exit(EXIT_FAILURE);
+		SKIP(return, "cannot open netlink_netfilter socket");
 	}
 
-	if (mnl_socket_bind(self->sock, 0, MNL_SOCKET_AUTOPID) < 0) {
-		perror("mnl_socket_bind");
-		exit(EXIT_FAILURE);
-	}
+	ret = mnl_socket_bind(self->sock, 0, MNL_SOCKET_AUTOPID);
+	EXPECT_EQ(ret, 0);
 
 	ret = conntracK_count_zone(self->sock, TEST_ZONE_ID);
 	if (ret < 0 && errno == EPERM)
-- 
2.43.2

