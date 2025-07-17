Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65492291C2C;
	Thu, 17 Jul 2025 09:51:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752745901; cv=none; b=fJYT1z3Gk3DfaOND6DeEXY/+yN2DPl+rS9Zv9CzVCnUAUH3BAE6O7BVfslmx2X747jaQNjjCWlVFN5y625Vs5U2cUAcOoUBYb0eUSi9nJ/cO00nDf84BSHOKGPc5koUrXOLM5553yDd/gJRlA5zq7QtqZhPuhH1mqd6cf5QaBMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752745901; c=relaxed/simple;
	bh=CPH+5zTOu0899KlOzYa5ijmyJzEzZhzx52MACXGzTCo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=qKHsrz32aIWfHnQp+bDjhVJG1DiyD8DjIFQ4RF4eGoVXpai98jmAPYAu9OOfQjuoln+uSU3vFDumC5RKvgOLqyj4V38JHUVYIusNukMd14xf2aq9vvUF3nVnafHypgEbS33eQmU5v7ErQyZ7CNKIYMsFqW9AAyKRJmNPmeEoEs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=KngGUf2n; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=vQ9oUBw7; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="KngGUf2n";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="vQ9oUBw7"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 33715602AF; Thu, 17 Jul 2025 11:51:37 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1752745897;
	bh=lEp9OEXjBeQNIGDGuWah29VprBXcnKfVSwVskhZ60S8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KngGUf2nT8O02WyMfEZkWEtH4uZ0YgeePvYqe4lTtsmo2dg6V+hmF1wPCdwa7C8WF
	 v+rD+oIcbTH8MrFy+Atbclyy1LfEvcxv3ZnzL2W0dTP1lEBzxXwgkI+2MSXbySUj0X
	 fm8KCwe6EnPwfHB6jfOtYtnt2tx5ngaHGdAZa6NwYNoAd6huLiOA2LBjNUVOLEVdRC
	 pR8k+bfQoE4cjo333fJrgEeef57pjX5Uuu3Ycb9HHARnSWaA/uZJpdGfOxBktvIwU8
	 v1WWJzn3KsPOqqeSKCKs/a4gJGnpx8gNHsAmc2yRzoqNQ7MV9LKjkyDTE/jxa1LEDR
	 uSaibOqt3Oh1A==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id AD12F602AF;
	Thu, 17 Jul 2025 11:51:31 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1752745892;
	bh=lEp9OEXjBeQNIGDGuWah29VprBXcnKfVSwVskhZ60S8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vQ9oUBw7WITfq0t+aCjERAqO+BfXZrhe0OCa62sp+oMgta42SyUFJU2jixHPXIJ6a
	 O3WP0LL3BbpvBwIinewtyZ7q8TtMY+Ez1u5RfFntxwSIe40T6eMdpZAR7sknZgqied
	 CdwsSspRYGxmFh9mQzcvJ5WrU7UyUItWIVtogO3WhKmBYy7rSsLeYYHMIdzI3kd/lR
	 yysPXnFtYFM6c8DuFwVdtOt4NYD9suFyTJmInu8cLQ1dbI2vh2yO8O8Yx2qo09lgMP
	 BU9qhA1zt96nvt598qrgw4k/nrv8bl4SjgpR53UK/q6x5U3WysH77uCjglTQsXrCG9
	 EUQ8Og0KS6pEg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 4/7] selftests: netfilter: nft_concat_range.sh: send packets to empty set
Date: Thu, 17 Jul 2025 11:51:19 +0200
Message-Id: <20250717095122.32086-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250717095122.32086-1-pablo@netfilter.org>
References: <20250717095122.32086-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

The selftest doesn't cover this error path:
 scratch = *raw_cpu_ptr(m->scratch);
 if (unlikely(!scratch)) { // here

cover this too.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tools/testing/selftests/net/netfilter/nft_concat_range.sh | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/testing/selftests/net/netfilter/nft_concat_range.sh b/tools/testing/selftests/net/netfilter/nft_concat_range.sh
index cd12b8b5ac0e..20e76b395c85 100755
--- a/tools/testing/selftests/net/netfilter/nft_concat_range.sh
+++ b/tools/testing/selftests/net/netfilter/nft_concat_range.sh
@@ -1311,6 +1311,9 @@ maybe_send_match() {
 # - remove some elements, check that packets don't match anymore
 test_correctness_main() {
 	range_size=1
+
+	send_nomatch $((end + 1)) $((end + 1 + src_delta)) || return 1
+
 	for i in $(seq "${start}" $((start + count))); do
 		local elem=""
 
-- 
2.39.5

