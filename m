Received: from azazel.net (taras.nevrast.org [35.176.194.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A71402107
	for <netfilter-devel@vger.kernel.org>; Sun, 24 Mar 2024 15:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.176.194.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711294194; cv=none; b=Q1CKhUH2ztBTbIKVhedVeOHPGasANK52sq6mmppyIFiPsGsWO/VEdVC59/cenqyb9M3ItxyYkYRZwPWbQez5p+y6FCig+eQUQkcJxm0p6iAF+Sgz0CEesFmZcJPtWj3OHwwzvQwNxWVO+8chAjzyMv4Pl5pmUwDEW6BGN+894WE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711294194; c=relaxed/simple;
	bh=EEd1sRMv/4KPp/yWq14SuXGmDiSoJejYc9H7VyMPCRU=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rVjlf/BX+cnB3OP4rEt44fPvCmSIFT8xe0rLnno0wNiv9VPI1ABqNybEzuNzaYxnE3vvMHkuVL7QxZPcIuEBkQdybkcko/mBAdHL8z621QyBKrPSdwuRkhfdFjvB/4yMsNqmV2idviEGngLVLHzolAUNSPQcWVBmegWP/f/5bio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net; spf=pass smtp.mailfrom=azazel.net; dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b=AqTLCafy; arc=none smtp.client-ip=35.176.194.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=azazel.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="AqTLCafy"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
	s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=mmCRF5bZrva6oRQ5y7poJcJDZ2MBC4QQ1jAbo+0rREs=; b=AqTLCafyHe/wmtsTe8qXs8EeCZ
	wgIz6FQay7E1TFOcqRs6wCNXVXMrCc6FFbRDf2FRe5BTut3pyDxefrd55q5bMr3SrAeVxhMaW9TMn
	m8dPwaW2Jm7rzWSMqCFsw8cvXLeU/xbapC/4bevY1R6UGA64TbbgUfjq5TyQ/P75BbSRpWP1BXDRA
	jv8ERoembN5rLB3SEP/OwqJH6FyEPHbh56SUSfpJ207eSyiFUVxDb40eLmnBqKgvM4yUejBCdxyQJ
	mX4D635tkQp0gklDYW4MVC6tb2PsydB/r1Dfr4/A4IwQ5LtA5kS6a5gVYZwVOFSyI6C5o7AnNNTjL
	Lyzdlnzw==;
Received: from [2001:8b0:fb7d:d6d6:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
	by taras.nevrast.org with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <jeremy@azazel.net>)
	id 1roPJv-007Ivj-2r
	for netfilter-devel@vger.kernel.org;
	Sun, 24 Mar 2024 14:59:35 +0000
From: Jeremy Sowden <jeremy@azazel.net>
To: Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nftables] tests: shell: packetpath/flowtables: open all temporary files in /tmp
Date: Sun, 24 Mar 2024 14:59:08 +0000
Message-ID: <20240324145908.2643098-2-jeremy@azazel.net>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240324145908.2643098-1-jeremy@azazel.net>
References: <20240324145908.2643098-1-jeremy@azazel.net>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d6:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false

The test used to do I/O over a named pipe in $PWD, until Phil changed it
to create the pipe in /tmp.  However, he missed one `socat` command.
Update that too.

Fixes: 3a9f29e21726 ("tests: shell: packetpath/flowtables: Avoid spurious EPERM")
Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 tests/shell/testcases/packetpath/flowtables | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/shell/testcases/packetpath/flowtables b/tests/shell/testcases/packetpath/flowtables
index 18a57a9b2b72..ec7dfeb75c00 100755
--- a/tests/shell/testcases/packetpath/flowtables
+++ b/tests/shell/testcases/packetpath/flowtables
@@ -77,7 +77,7 @@ ip netns exec $R sysctl -w net.netfilter.nf_conntrack_tcp_timeout_established=86
 }
 
 # A trick to control the timing to send a packet
-ip netns exec $S socat TCP6-LISTEN:10001 GOPEN:pipefile,ignoreeof &
+ip netns exec $S socat TCP6-LISTEN:10001 GOPEN:/tmp/pipefile-$rnd,ignoreeof &
 sleep 1
 ip netns exec $C socat -b 2048 PIPE:/tmp/pipefile-$rnd 'TCP:[2001:db8:ffff:22::1]:10001' &
 sleep 1
-- 
2.43.0

