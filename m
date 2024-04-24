Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA298156F46
	for <netfilter-devel@vger.kernel.org>; Wed, 24 Apr 2024 22:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713996051; cv=none; b=U4EgWBrewOWn+myEepeU+GlJQazw47CrZiBofKTYHeUDnMfb0I54PqEvksch20uqvGiXjs1qyWFe2lsBcYKfTouiCCX7um5LojM/5ZHGpfA9MmzFqyeB8XMM52rqGKvelZMEIWR9Pt5V69qh0niMmmGUqZnsJfX2PuAoXx0VaFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713996051; c=relaxed/simple;
	bh=77rRAKRLoX2+PF5bKCRU+RUYrX4Zufk0ZP6RkcOtJ/I=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SSZkGE9+Jv5lwNe+l/B1uIHaDbECiSYSgAqODuqZ3uy/ckb5zNsLOqK5GJxeQwAR1EOVA0FC/+ocdlIAchNqy2bFS3fmnUhTPOxZ8byaRtVMnPeT0RgJF2Ce0utuu0go7pIJUgaoGWlop32K72ytujJSxPPCWz57ftwVoHfAnUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=PIhu4LXe; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="PIhu4LXe"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=yjftzZj6lZ0ZdFwLO8M82JWjBLt27jWsUoISIR9D3yk=; b=PIhu4LXeS8ZqImIeRi/ua2tT/+
	4hwpPI4vBpRbIMH+ED1yCOQCXH0OveBjE6Krr/xdi0pzMO159zykVQE8neJ09ahzqCF46FJzdUawX
	1wgqEoB+E2vIX5sU7SKoXapNfim3uyHGStKOKcnbw01wzsVulSLKhNNymiH006Y82wwbBv+AirVlN
	TVW/LMtNq5FSW/qt5SksEZORK8LHgSZiruVSR4El5pLcqVimmw6tOGhWy4T/MVq1djjxREoeY0Hs5
	RvEIS++zSMWmFaMLewvkYarvYLYHmt2oZEgA2XVngPAaKNLUyoS2zRtkzcTN7yUPwbmpl8ynoBAYH
	kZMascmw==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1rzkfY-000000003v9-1Etg
	for netfilter-devel@vger.kernel.org;
	Thu, 25 Apr 2024 00:00:48 +0200
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: [nft PATCH 2/2] doc: nft.8: Highlight "hook" in flowtable description
Date: Thu, 25 Apr 2024 00:00:48 +0200
Message-ID: <20240424220048.19935-2-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240424220048.19935-1-phil@nwl.cc>
References: <20240424220048.19935-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Lacking an explicit description of possible hook values, emphasising the
word in the description text should draw readers' attention in the right
direction.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 doc/nft.txt | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/doc/nft.txt b/doc/nft.txt
index 2080c07350f6d..e4eb982e75af8 100644
--- a/doc/nft.txt
+++ b/doc/nft.txt
@@ -747,8 +747,8 @@ protocols. Each entry also caches the destination interface and the gateway
 address - to update the destination link-layer address - to forward packets.
 The ttl and hoplimit fields are also decremented. Hence, flowtables provides an
 alternative path that allow packets to bypass the classic forwarding path.
-Flowtables reside in the ingress hook that is located before the prerouting
-hook. You can select which flows you want to offload through the flow
+Flowtables reside in the ingress *hook* that is located before the prerouting
+*hook*. You can select which flows you want to offload through the flow
 expression from the forward chain. Flowtables are identified by their address
 family and their name. The address family must be one of ip, ip6, or inet. The inet
 address family is a dummy family which is used to create hybrid IPv4/IPv6
-- 
2.43.0

