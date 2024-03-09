Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31F2E364DC
	for <netfilter-devel@vger.kernel.org>; Sat,  9 Mar 2024 11:35:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709984137; cv=none; b=elabU0FqXDRkN/F0VdusESBMNxG2nKBGDXhL0B1HxzIN3MsXrhqln1SGQZXUq5SIgCsDaTyY+fyeSJmq7SgJSaXuBqQZ5F0dLF8+4628b0HpofJyg823GaQOt4x5G+7xdRVOoVugbgJy8QHjnUiupwz2C0ArAXLuUHi5k54LGrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709984137; c=relaxed/simple;
	bh=rn//vveocJAFIVYfpU9Y/cxLN3dhEQtWUrVrsygR/Aw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vCb2ndlMccc8Jx/lDnmTUvQjpuveuNmECNCklHxrN3xFRMXUhuQ/RxmOYzC1lm7CCWQyFacIPa08daOk8P5A96oSbJwpopXKt2NL0EUQXn7X2orgBTH3oHOACuyfBUUjwSXpt75e9VXDz7DjAIf1khGRDcSTloH53yt07D2GSQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=TpJdA4uF; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="TpJdA4uF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=V1jxi2tAQqoTxrscT8asWGGdemBElOP9/imKrm5y60Y=; b=TpJdA4uFbpDnxF1tuEQgFqEdui
	1gGUXR+7HVT5AJD+cFEwJ01GkrBxby8PLPsLIh8jCp8o8/MUHuToBsKbLObUHnVkohq+7EaZd2FXQ
	otPqRpMJcjJrDSBVfdWNiQXI+INokuW9Yk6YZBRoYb7PPkAgD/99PegTf4LIT2JaC8U15tkApobD/
	3ITpEJJeu1ibG2WuirEURQ5rz5s8tYfB48tCCLHGYkfSQIPmSs4nWoq1//rCwQKFM3Kca8pinakaz
	hEIPirejzAS/zD+9UxwjQ/nBbc41iumdGlY1d+wBjNzRWn6xO/e6s6NDbGcQX+dEMQSWkIBrAObc7
	yoDadHug==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1riuzG-000000003hV-1fsw;
	Sat, 09 Mar 2024 12:35:34 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>
Subject: [nft PATCH 2/7] tests: shell: packetpath/flowtables: Avoid spurious EPERM
Date: Sat,  9 Mar 2024 12:35:22 +0100
Message-ID: <20240309113527.8723-3-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240309113527.8723-1-phil@nwl.cc>
References: <20240309113527.8723-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On my system for testing, called socat is not allowed to create the pipe
file in local directory (probably due to sshfs). Specify a likely unique
path in /tmp to avoid such problems.

Fixes: 419c0199774c6 ("tests: shell: add test to cover ct offload by using nft flowtables")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/shell/testcases/packetpath/flowtables | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tests/shell/testcases/packetpath/flowtables b/tests/shell/testcases/packetpath/flowtables
index 852a05c6d0ab1..18a57a9b2b726 100755
--- a/tests/shell/testcases/packetpath/flowtables
+++ b/tests/shell/testcases/packetpath/flowtables
@@ -79,17 +79,17 @@ ip netns exec $R sysctl -w net.netfilter.nf_conntrack_tcp_timeout_established=86
 # A trick to control the timing to send a packet
 ip netns exec $S socat TCP6-LISTEN:10001 GOPEN:pipefile,ignoreeof &
 sleep 1
-ip netns exec $C socat -b 2048 PIPE:pipefile TCP:[2001:db8:ffff:22::1]:10001 &
+ip netns exec $C socat -b 2048 PIPE:/tmp/pipefile-$rnd 'TCP:[2001:db8:ffff:22::1]:10001' &
 sleep 1
 ip netns exec $R grep 'OFFLOAD' /proc/net/nf_conntrack   || { echo "check [OFFLOAD] tag (failed)"; exit 1; }
 ip netns exec $R cat /proc/net/nf_conntrack
 sleep 6
 ip netns exec $R grep 'OFFLOAD' /proc/net/nf_conntrack   && { echo "CT OFFLOAD timeout, fail back to classical path (failed)"; exit 1; }
 ip netns exec $R grep '8639[0-9]' /proc/net/nf_conntrack || { echo "check nf_conntrack_tcp_timeout_established (failed)"; exit 1; }
-ip netns exec $C echo "send sth" >> pipefile
+ip netns exec $C echo "send sth" >> /tmp/pipefile-$rnd
 ip netns exec $R grep 'OFFLOAD' /proc/net/nf_conntrack   || { echo "traffic seen, back to OFFLOAD path (failed)"; exit 1; }
 ip netns exec $C sleep 3
-ip netns exec $C echo "send sth" >> pipefile
+ip netns exec $C echo "send sth" >> /tmp/pipefile-$rnd
 ip netns exec $C sleep 3
 ip netns exec $R grep 'OFFLOAD' /proc/net/nf_conntrack   || { echo "Traffic seen in 5s (nf_flowtable_tcp_timeout), so stay in OFFLOAD (failed)"; exit 1; }
 
-- 
2.43.0

