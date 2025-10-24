Received: from slateblue.cherry.relay.mailchannels.net (slateblue.cherry.relay.mailchannels.net [23.83.223.168])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70E6054262
	for <netfilter-devel@vger.kernel.org>; Fri, 24 Oct 2025 02:43:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.223.168
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761273806; cv=pass; b=uFml0qcNhy1DHU2rUN8bzs0hdlt/6tIAUdiSxYapL8UPVClrklgX7xckWwGPWyqwKnj4x7vXgdesq4QmWfg6GjvLM9hE0TzBn1n93o59qKuvNpk9vnLYMXExFTwoBLFIS3xB8rCcCYlA3Y5Asir9SRRmdUvdpPIrruvyiPQ21ns=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761273806; c=relaxed/simple;
	bh=k3cR6nVPDHOj6BeaY01/oDxSqIovV14T7DcPJw1RdNA=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KOMsmf+2pu1bHDWzNnEtH6aRRykcg0YlUelsryFfaLIYEArTSrZSLZBj1znMqIhmdtvcynFwqvXjdmbDdV/IuzCo9ghARXuDk9OOd+3O772iLq6usDkyo/a/FlJQUQfYxSVsSQYc7OEY65KeRUrEQsM/Uz6jwbkuuDgt1pbElUY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=christoph.anton.mitterer.name; spf=pass smtp.mailfrom=scientia.org; arc=pass smtp.client-ip=23.83.223.168
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=christoph.anton.mitterer.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=scientia.org
X-Sender-Id: instrampxe0y3a|x-authuser|calestyo@scientia.org
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 40A13860CC0;
	Fri, 24 Oct 2025 02:35:24 +0000 (UTC)
Received: from cpanel-007-fra.hostingww.com (trex-green-7.trex.outbound.svc.cluster.local [100.119.151.11])
	(Authenticated sender: instrampxe0y3a)
	by relay.mailchannels.net (Postfix) with ESMTPA id 92848861693
	for <netfilter-devel@vger.kernel.org>; Fri, 24 Oct 2025 02:35:19 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1761273319; a=rsa-sha256;
	cv=none;
	b=NFNaD63042n+GEPczOvmGVUSow0nZfDBqfR1g2PZr0haha/kjadIUxpG3rjOKLwb3yzmsU
	bRJoZgO4ro6L7GjVCwBF7b/zmNFYVCO2NsAxgJlNcAj9W15wGQsyX1eu71PHmcqd2IrRj8
	RF8+DvU/RfYLAtXFrEFbDCdGt8GgiwxRT6TPSs4xVDz5r7lvQTEn9tC0n0A2IQ2HbM+kvd
	12l3F+fU1p3r/tQyashzU+EReY0Tvqa5akakOPQZrnoxJcbfsTMAvVdDyzoaxUAYyBHSZA
	PIPYS3cUUW5uldkgeXJwrfP5f1RaKpIqKa8zh8ubWZJFuHYYvUU53A6+xt3kpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1761273319;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5zJDyh3wzutPq4ejsGgUPSZNnyJkToM14OMuCywBenA=;
	b=OS/sl/I8XLhSovMXfUgDS6ZDF89pjtV2W1blv6Jez8b8lwhwCMYo9vfXHLxdK6N7ngeXBW
	H1y1AlNqCUIr1m81jKIqOL8sKsBqjPfvCDvJDuvxfko5jWwbGmvuQW7x7O9QlUWlxi/U1b
	AKKpk9a1gV2dYoqfkyFQ9NyvoEXUOOz4iSTFik1NVQhGeg9UPHCLpH2SToAvdOUb66epPj
	hClhJQg1ZXZtetqWQZUtrmItgHeZpL8qDDaU6gIoUpM6PW3y9OTzkSGw4vzJ0ySYICPOLJ
	ntxwY4KoHRwvR2XICZXN6Y8CDHm5xUL7h/8m2fLPra2c+5uq2dSxeb/WIRzcEA==
ARC-Authentication-Results: i=1;
	rspamd-674f557ffc-b6rbj;
	auth=pass smtp.auth=instrampxe0y3a smtp.mailfrom=calestyo@scientia.org
X-Sender-Id: instrampxe0y3a|x-authuser|calestyo@scientia.org
X-MC-Relay: Neutral
X-MC-Copy: stored-urls
X-MailChannels-SenderId: instrampxe0y3a|x-authuser|calestyo@scientia.org
X-MailChannels-Auth-Id: instrampxe0y3a
X-Blushing-Unite: 233556ec64207442_1761273324151_971196988
X-MC-Loop-Signature: 1761273324151:2437522981
X-MC-Ingress-Time: 1761273324151
Received: from cpanel-007-fra.hostingww.com (cpanel-007-fra.hostingww.com
 [3.69.87.180])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.119.151.11 (trex/7.1.3);
	Fri, 24 Oct 2025 02:35:24 +0000
Received: from [212.104.214.84] (port=8080 helo=heisenberg.scientia.org)
	by cpanel-007-fra.hostingww.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <calestyo@scientia.org>)
	id 1vC7eC-0000000FtVu-0qmK
	for netfilter-devel@vger.kernel.org;
	Fri, 24 Oct 2025 02:35:18 +0000
Received: by heisenberg.scientia.org (Postfix, from userid 1000)
	id E90595AA5BFA; Fri, 24 Oct 2025 04:35:16 +0200 (CEST)
From: Christoph Anton Mitterer <mail@christoph.anton.mitterer.name>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH 2/9] tools: use the same pair of boolean literals
Date: Fri, 24 Oct 2025 04:08:17 +0200
Message-ID: <20251024023513.1000918-3-mail@christoph.anton.mitterer.name>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251024023513.1000918-1-mail@christoph.anton.mitterer.name>
References: <20251024023513.1000918-1-mail@christoph.anton.mitterer.name>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-AuthUser: calestyo@scientia.org

Signed-off-by: Christoph Anton Mitterer <mail@christoph.anton.mitterer.name>
---
 tools/nftables.service.in | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/nftables.service.in b/tools/nftables.service.in
index e694f2f7..edc7c831 100644
--- a/tools/nftables.service.in
+++ b/tools/nftables.service.in
@@ -11,7 +11,7 @@ ConditionPathExists=@pkgsysconfdir@/rules/main.nft
 Type=oneshot
 RemainAfterExit=yes
 ProtectSystem=full
-ProtectHome=true
+ProtectHome=yes
 ExecStart=@sbindir@/nft 'flush ruleset; include "@pkgsysconfdir@/rules/main.nft"'
 ExecReload=@sbindir@/nft 'flush ruleset; include "@pkgsysconfdir@/rules/main.nft"'
 ExecStop=@sbindir@/nft flush ruleset
-- 
2.51.0

