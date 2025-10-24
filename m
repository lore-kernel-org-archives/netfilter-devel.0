Received: from bee.birch.relay.mailchannels.net (bee.birch.relay.mailchannels.net [23.83.209.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3D82259CA5
	for <netfilter-devel@vger.kernel.org>; Fri, 24 Oct 2025 02:35:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.209.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761273329; cv=pass; b=X/bRgRkRFUTVx41bt78nLFHxNmAHgBbv7esW+p6hmbEQX8a0+nhzT84TQmLp23KtKJPaDtVm8219jaSmLlwYtV7v0VKbp9jRobDUQVz+GWXXCp6/SStr4NEhyKzeRIlL/xjgJda5b909KlrmaNYdfzrdAkxhp0vjXcB5Ur5fcvo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761273329; c=relaxed/simple;
	bh=F0hsnXk55LQZwjUx8jNrVSOdPvwTM9MyMl2GrV63uEM=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=P7Zj+5W/WiPPBfnHq4XVE/p2LfRyS0gpMGcFqaH3+xI+OHFkCF4dlH7BwnEL44B2kEAzrGYRX4AuSezHKqzPFWvycHreQGgWKdryh3GDdWW/Rxtva+SoUsjmzMKyHgjwrVlyxjTcxDz+izw3SZaklSg+7MROh6IUdLGNcAJ+lCg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=christoph.anton.mitterer.name; spf=pass smtp.mailfrom=scientia.org; arc=pass smtp.client-ip=23.83.209.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=christoph.anton.mitterer.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=scientia.org
X-Sender-Id: instrampxe0y3a|x-authuser|calestyo@scientia.org
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 506CF861581;
	Fri, 24 Oct 2025 02:35:21 +0000 (UTC)
Received: from cpanel-007-fra.hostingww.com (trex-green-4.trex.outbound.svc.cluster.local [100.119.74.21])
	(Authenticated sender: instrampxe0y3a)
	by relay.mailchannels.net (Postfix) with ESMTPA id CE23C86117B
	for <netfilter-devel@vger.kernel.org>; Fri, 24 Oct 2025 02:35:20 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1761273321; a=rsa-sha256;
	cv=none;
	b=MSzz3KotadYYOXkoUxv80SPiiS6kXb4ykH9mjnX3dLzfQhMnf1FI7RhyNgo6gdmLESWoLO
	UOH5IUe4wxtkVrJS5gM8Gvt79QkF1ohFcOs7EFsnyQBJbb6uuumtf9Uq23xpyMARAfJqA2
	Ws4V2v7CM9sPcpFGQ0UrgGu3Q3B6+E71UjVnncgSrk6oV7O/2iwBU0yL5zVBlx7OHpZHId
	MaydTZmC+RknVLL/FSkxieQ7m2GbqteEVh9VBZ50svmRcq63p6Sik2z7E5jAaI3VTCR8LX
	b8CXJaOVZoujcXN5uwooV3tuYjjaq4y26cJ6l3SJQKPSdWdcXv8nCXxM7+NjOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1761273321;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3Tz1RpS4nZn/6Nm3uSsbUxUUbNDidrQAxWpabrQRCwo=;
	b=kS+V05wk3O29/WNt4gcOfY9n7/Pi/66/BzU8Fe2WYo9TNiGaWy3YYob9PFTCK0oRp0TTke
	GORTLQYHlaEQniAE4vv6/iD8//Z3Disl5cjbGccFN9MspzdbQFqnpnz57LqCVli16TVp1t
	cIRCLjGsRi/jgWR168DrClZaaZdJcR3XKal/HZudokQ5W63qbF0RK6oZnj5cwBZyK8B5It
	u+6HK6NW2heH5V1EUd9f2f44tz929/E0sD2IZYIg1znxFvK8hTCsl+JqPbFeLX+CWEwjG7
	uCKZLc6dCu+wAMqlJXPtxRSmen4w5QUMqlTDF1pQlr44WTF63BP75bMCfAOnVw==
ARC-Authentication-Results: i=1;
	rspamd-674f557ffc-b6rbj;
	auth=pass smtp.auth=instrampxe0y3a smtp.mailfrom=calestyo@scientia.org
X-Sender-Id: instrampxe0y3a|x-authuser|calestyo@scientia.org
X-MC-Relay: Neutral
X-MC-Copy: stored-urls
X-MailChannels-SenderId: instrampxe0y3a|x-authuser|calestyo@scientia.org
X-MailChannels-Auth-Id: instrampxe0y3a
X-Chief-Well-Made: 3cd8aa7767599230_1761273321221_373771213
X-MC-Loop-Signature: 1761273321221:1839118636
X-MC-Ingress-Time: 1761273321221
Received: from cpanel-007-fra.hostingww.com (cpanel-007-fra.hostingww.com
 [3.69.87.180])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.119.74.21 (trex/7.1.3);
	Fri, 24 Oct 2025 02:35:21 +0000
Received: from [212.104.214.84] (port=15594 helo=heisenberg.scientia.org)
	by cpanel-007-fra.hostingww.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <calestyo@scientia.org>)
	id 1vC7eD-0000000FtWK-0yFM
	for netfilter-devel@vger.kernel.org;
	Fri, 24 Oct 2025 02:35:19 +0000
Received: by heisenberg.scientia.org (Postfix, from userid 1000)
	id 075105AA5C02; Fri, 24 Oct 2025 04:35:17 +0200 (CEST)
From: Christoph Anton Mitterer <mail@christoph.anton.mitterer.name>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH 6/9] =?UTF-8?q?tools:=20don=E2=80=99t=20stop=20`nftables.s?= =?UTF-8?q?ervice`=20(and=20flush=20the=20ruleset)=20on=20shutdown?=
Date: Fri, 24 Oct 2025 04:08:21 +0200
Message-ID: <20251024023513.1000918-7-mail@christoph.anton.mitterer.name>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251024023513.1000918-1-mail@christoph.anton.mitterer.name>
References: <20251024023513.1000918-1-mail@christoph.anton.mitterer.name>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-AuthUser: calestyo@scientia.org

There doesn’t seem any compelling reason to stop the service on shutdown.
`nftables.service` is anyway a `Type=oneshot` service, so unless for some
extreme cases (like when the shutdown happens while service commands still
haven’t finished (and exited)), no processes from it should be left anyway.

At best, flushing the ruleset on shutdown, merely and needlessly executes yet
another `nft` process.
At worst it could flush the ruleset when networking is still running for
whatever reason.

Signed-off-by: Christoph Anton Mitterer <mail@christoph.anton.mitterer.name>
---
 tools/nftables.service.in | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/tools/nftables.service.in b/tools/nftables.service.in
index 8388ae68..ea428ee7 100644
--- a/tools/nftables.service.in
+++ b/tools/nftables.service.in
@@ -4,9 +4,8 @@ Documentation=man:nftables.service(8) man:nft(8) https://wiki.nftables.org
 
 Wants=network-pre.target
 Requires=sysinit.target
-Before=network-pre.target shutdown.target
+Before=network-pre.target
 After=sysinit.target
-Conflicts=shutdown.target
 DefaultDependencies=no
 
 ConditionPathExists=@pkgsysconfdir@/rules/main.nft
-- 
2.51.0

