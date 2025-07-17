Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C37FB291C24;
	Thu, 17 Jul 2025 09:51:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752745900; cv=none; b=to2QP76E26CwBQLm/ZhWbyLSDtc7FNr9/fwtb+YJPbu8bxTJdDI2YmkDyLk20SAEEVBErinfc90nNztYGWa6FyLNHjGv31Vl+d2QjMK21AwCPwYXwLMu3cSFxxNyc9oHdPhYwUGrd9p0UO2+on2RDlhJvZmnPngg38LLqdwJnMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752745900; c=relaxed/simple;
	bh=vcFrRw+JJwS2Z62r5aHR2T4DTVavwdN54vki0QR3MnA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=PFblAAcX7tzpqILLcgVsiToWlGAJmbQvdbimJXjFlRzOGgjKbAYS9thvpNPPwtZWGUCgdq57k1qKqAk8YGGBN4GjTsOAXSTdMiyFuDwiFx38sSudV0YnxsJLnoa65IdvyZ+xGIc/S7J5Gzw6rKGHCdp1uY2fuuV0GC7UgOc4gDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=cywUveKx; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=hd9Mu5fT; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="cywUveKx";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="hd9Mu5fT"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 32E32602C0; Thu, 17 Jul 2025 11:51:36 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1752745896;
	bh=TkRlGddvebogkFT2YYs6CD7A3WUzs9z/9tWRdjZTD2s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cywUveKxx9jLikNLpcaqnmsY0HfLGsmNjsGf+Y3eJOT59Z2g8fnsEeJ6q5RW2bM7S
	 iKcD8X5K/RjcrrvBU6LsMyxJyQ4FZNwxd5xDp4mw1uZXE9ZtDMzLQnUD8Vl+RMNyLI
	 AyHa3u+dMJ11koVpL1C0SdBBn80aFs/m7d+1Bl8buIzK7uYmDMrncmybPR10SLIepG
	 QIFpUJGnbSXZjQJHWx3KFrbcgE0DdnmBFL1U/Ad+h7aBPv3bGztjSn+U6Q75D5ubky
	 jo2P9kzWnOxk4rojPZmJDBXBG/I59CsrMjrd8XqxyEM6HtWj7kDAv+sREwkaYDXwLy
	 fNp6zHzvseBRw==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id D2433602B0;
	Thu, 17 Jul 2025 11:51:30 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1752745891;
	bh=TkRlGddvebogkFT2YYs6CD7A3WUzs9z/9tWRdjZTD2s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hd9Mu5fT2lcOIPdJ6WqXD/qEGw/scCnHSprAiAdNy8rJ3hTygNg3Regz4G1Fp4Ncw
	 QwR5y481hmlZdKB4HNpVzApzDdbwrGU8L1iNeKO0Um9P32r6jj3zKXaguaCCjiQPHo
	 AoBjhzR6XOklVg/ulj1O8UbVdfS5zyp/78fAMwc8g4VeiJOVZutnaICaISFowfR6qu
	 K6bSDJK1ALEMTuzDxUF7sXhXSWORr67Ptfj3LeAx2lLXePHMf3pvVaOrj8d9imErFy
	 n/uErjn8r+SqcWoRVL1AjZVkf5BHm5pbjcMBcKkz5pW/db6GDiVG5aN8dISzWQCd8y
	 OEUy4QVFc+M1Q==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 3/7] selftests: netfilter: conntrack_resize.sh: also use udpclash tool
Date: Thu, 17 Jul 2025 11:51:18 +0200
Message-Id: <20250717095122.32086-4-pablo@netfilter.org>
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

Previous patch added a new clash resolution test case.
Also use this during conntrack resize stress test in addition
to icmp ping flood.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 .../selftests/net/netfilter/conntrack_resize.sh | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/tools/testing/selftests/net/netfilter/conntrack_resize.sh b/tools/testing/selftests/net/netfilter/conntrack_resize.sh
index aa1ba07eaf50..788cd56ea4a0 100755
--- a/tools/testing/selftests/net/netfilter/conntrack_resize.sh
+++ b/tools/testing/selftests/net/netfilter/conntrack_resize.sh
@@ -177,6 +177,22 @@ EOF
 	done
 }
 
+ct_udpclash()
+{
+	local ns="$1"
+	local duration="$2"
+	local now=$(date +%s)
+	local end=$((now + duration))
+
+	[ -x udpclash ] || return
+
+        while [ $now -lt $end ]; do
+		ip netns exec "$ns" ./udpclash 127.0.0.1 $((RANDOM%65536)) > /dev/null 2>&1
+
+		now=$(date +%s)
+	done
+}
+
 # dump to /dev/null.  We don't want dumps to cause infinite loops
 # or use-after-free even when conntrack table is altered while dumps
 # are in progress.
@@ -267,6 +283,7 @@ insert_flood()
 
 	ct_pingflood "$n" "$timeout" "floodresize" &
 	ct_udpflood "$n" "$timeout" &
+	ct_udpclash "$n" "$timeout" &
 
 	insert_ctnetlink "$n" "$r" &
 	ctflush "$n" "$timeout" &
-- 
2.39.5

