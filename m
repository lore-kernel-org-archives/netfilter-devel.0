Received: from bee.birch.relay.mailchannels.net (bee.birch.relay.mailchannels.net [23.83.209.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1C47258CD9
	for <netfilter-devel@vger.kernel.org>; Fri, 24 Oct 2025 02:35:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.209.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761273333; cv=pass; b=KmG5WcsmnocOfBRm/WaSYl1f38CVO5SNCok8GPHVyg2sSbygm11bzdzliRg2P36B4vVw6E1fzQvZMPCopOSpenrcuueLhcbTMyp0clXos5eEmSiHHm+KHICnLS1Jc+8mEVMx51lk/TpU7OFeAIRpr2KD6GktDUzoh2jA9nZKGf8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761273333; c=relaxed/simple;
	bh=OQmiPBaGWDn1pF8IBTLpncmo9DB0VhgJZRR1Hs9HaXw=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d5q1l+c4jgj3HJkh8jtMc75D7qaayAG+qLldVOYGD7L6pyNroMsmEAh6XvXd/PILM8u5i55bsH0x4dRZnJBQChHKAlh33HVLG9fJ86e0Iy0BXaV4gWQXH5lq2dnECslHujJHR1rFxeVDFKD+RzREdfC/rAgqC649nGjL4TbjYSg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=christoph.anton.mitterer.name; spf=pass smtp.mailfrom=scientia.org; arc=pass smtp.client-ip=23.83.209.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=christoph.anton.mitterer.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=scientia.org
X-Sender-Id: instrampxe0y3a|x-authuser|calestyo@scientia.org
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id E91F6360E35;
	Fri, 24 Oct 2025 02:35:24 +0000 (UTC)
Received: from cpanel-007-fra.hostingww.com (trex-green-5.trex.outbound.svc.cluster.local [100.121.167.245])
	(Authenticated sender: instrampxe0y3a)
	by relay.mailchannels.net (Postfix) with ESMTPA id 517853612FC
	for <netfilter-devel@vger.kernel.org>; Fri, 24 Oct 2025 02:35:20 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1761273320; a=rsa-sha256;
	cv=none;
	b=RHwC5Ct3wt7TVfMmGZQ4/eztVmqGFHnH0Qq8N0DSbiMX1KMY9mqd16Mu/9vJpuzewPpCPP
	mOXLsEcniFZIyxEfTzkYFfc81kfIzmFDzMVAsoSisRcvtsrqFqLT6gxNVevxo20PxhgCY+
	orf0Pdf6b2MVtmB1pc1i2EBA0v+UF5Me3DsaydwsQ6fn58yVfqxN45X5JYTyJKAGDpIFfy
	C/DFxtR5qAUnPAofnbSW6pCUPLojLTAx41F7nu2mPJm37Nua+4DD9zYvWUnDt03fK1PnSY
	GiVdLta9LS+k9rvx7FmJWr2ytbgmK6bGd4DUknYSpYJ9DhHMm3Tbr+QIfyqXaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1761273320;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pKo3ao61jEqo7yQpw/fcQiB/oaFAbmI8JWNm176svow=;
	b=iyv18/ITXue3hgpY5kqMVWN8EbCEurzuWEWE6zFMen4FuWO9XjxQqpUQEM36wzbYJRO2RE
	yEkr18AwZcLl3qKL0SF0jFL9xttru2B0BZM3h3PyzvOH91HtYEcE7gP3x2PxcWWXpR3Tc4
	D68e7V8nfHwBWBtCCSnycw5lvJr/ZDgD133m8GYjmvHRkJBERlAOGmfvucCT3Q/rx0Jnn+
	69sIrwDHi8Kc4d1bXtOZDKc6wTDOeE79p9m9stlks89aUP5BSpvOzTiYWd5nLz2glbl1vs
	0JPTbVSpsHpLC+A0Dr+CobYulRM3ZZ3SMG58ulUz6opmQKHAEZcHZmLrU9kThQ==
ARC-Authentication-Results: i=1;
	rspamd-674f557ffc-nf8js;
	auth=pass smtp.auth=instrampxe0y3a smtp.mailfrom=calestyo@scientia.org
X-Sender-Id: instrampxe0y3a|x-authuser|calestyo@scientia.org
X-MC-Relay: Neutral
X-MC-Copy: stored-urls
X-MailChannels-SenderId: instrampxe0y3a|x-authuser|calestyo@scientia.org
X-MailChannels-Auth-Id: instrampxe0y3a
X-Scare-Hook: 323b3d2e1e651cd1_1761273324827_1675692138
X-MC-Loop-Signature: 1761273324827:3927627020
X-MC-Ingress-Time: 1761273324826
Received: from cpanel-007-fra.hostingww.com (cpanel-007-fra.hostingww.com
 [3.69.87.180])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.121.167.245 (trex/7.1.3);
	Fri, 24 Oct 2025 02:35:24 +0000
Received: from [212.104.214.84] (port=34144 helo=heisenberg.scientia.org)
	by cpanel-007-fra.hostingww.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <calestyo@scientia.org>)
	id 1vC7eC-0000000FtVw-0z1A
	for netfilter-devel@vger.kernel.org;
	Fri, 24 Oct 2025 02:35:18 +0000
Received: by heisenberg.scientia.org (Postfix, from userid 1000)
	id F35995AA5BFE; Fri, 24 Oct 2025 04:35:16 +0200 (CEST)
From: Christoph Anton Mitterer <mail@christoph.anton.mitterer.name>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH 4/9] tools: reorder options
Date: Fri, 24 Oct 2025 04:08:19 +0200
Message-ID: <20251024023513.1000918-5-mail@christoph.anton.mitterer.name>
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

This groups related options, orders options/groups by importance and
separates sections/groups with empty lines.

In `[Unit]` this groups general, dependency and condition options.
In `[Service]` this groups general, execution and hardening options.

Signed-off-by: Christoph Anton Mitterer <mail@christoph.anton.mitterer.name>
---
 tools/nftables.service.in | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/tools/nftables.service.in b/tools/nftables.service.in
index ca2ef684..15c3b5da 100644
--- a/tools/nftables.service.in
+++ b/tools/nftables.service.in
@@ -1,20 +1,26 @@
 [Unit]
 Description=nftables static rule set
 Documentation=man:nftables.service(8) man:nft(8) https://wiki.nftables.org
+
 Wants=network-pre.target
 Before=network-pre.target shutdown.target
 Conflicts=shutdown.target
 DefaultDependencies=no
+
 ConditionPathExists=@pkgsysconfdir@/rules/main.nft
 
+
 [Service]
 Type=oneshot
 RemainAfterExit=yes
-ProtectSystem=full
-ProtectHome=yes
+
 ExecStart=@sbindir@/nft 'flush ruleset; include "@pkgsysconfdir@/rules/main.nft"'
 ExecReload=@sbindir@/nft 'flush ruleset; include "@pkgsysconfdir@/rules/main.nft"'
 ExecStop=@sbindir@/nft flush ruleset
 
+ProtectSystem=full
+ProtectHome=yes
+
+
 [Install]
 WantedBy=sysinit.target
-- 
2.51.0

