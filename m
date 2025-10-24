Received: from dog.birch.relay.mailchannels.net (dog.birch.relay.mailchannels.net [23.83.209.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D994728DC4
	for <netfilter-devel@vger.kernel.org>; Fri, 24 Oct 2025 02:53:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.209.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761274405; cv=pass; b=oACUFh4CNch2v/pK4zipxkLFoesIiLBTvSQKOzQ6rl2EHuYhXYJM2tYuo5dddS97PCCJ/ygbwNuDtYu9Tl6WDAPLxUPEqiyOloqymzGp9RY5X84bus/5kBT9cD6DPgkNXIawfBWOVKjiWE5tCyzxu9Z8rX4JS/8DB/1IAOapT6U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761274405; c=relaxed/simple;
	bh=MFTC1My9HLm1NA3WqkM92G2icscxCIf86SyxlPTWV84=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Sjh3xL5n1v1vVAuhpd5VvmejbAO5x6PLK9k+cYr4QVMPfeQHUujqSPTeEudmbsy5ecmzBqho9xvxoTcG3DNhaAKiIIVesluVwW7pvjAA/lKrx9zo+mlBBtDUnGb7/FKnsZO/Ske9KddaWzWZuxS9kYcSwUPCdCorzsw3/t3Spm4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=christoph.anton.mitterer.name; spf=pass smtp.mailfrom=scientia.org; arc=pass smtp.client-ip=23.83.209.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=christoph.anton.mitterer.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=scientia.org
X-Sender-Id: instrampxe0y3a|x-authuser|calestyo@scientia.org
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 83F4C741CB0;
	Fri, 24 Oct 2025 02:35:21 +0000 (UTC)
Received: from cpanel-007-fra.hostingww.com (trex-green-8.trex.outbound.svc.cluster.local [100.119.46.77])
	(Authenticated sender: instrampxe0y3a)
	by relay.mailchannels.net (Postfix) with ESMTPA id 0C40B741A51
	for <netfilter-devel@vger.kernel.org>; Fri, 24 Oct 2025 02:35:20 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1761273321; a=rsa-sha256;
	cv=none;
	b=Pvcwbxr2cNV65k0ZPH7qlMCzQX9KnIrEKEk2Iz4oR0V2FyIW9GpzZ2MjNnL5KlE3LdaH27
	AzfoVFnrjip7ZJj71Ho7bjMaKnVnhbu44rwN4GuuKD+Ob4EpF2Xhv5y0ejEoycMc/F4oQc
	m7CouKZlKD9Ara+gwi0Xg0+Oa9tVtOBPhyHjD5yK2tLMq3o6FUARn18g2a+F6i0hr7c2I1
	27v00ZQvgNiAE2cmYdlu2AvnZKHUZH0LiLGJv9NK0vm6vJzzuQxm0V3N010ydZXNRN9xH4
	5w4L+U9VnmekuJIZXQO5AJ9zTjRAWObKNrM+wb39/42ltyPUzpCP1dSs8iw8YQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1761273321;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=olvYycJ/TIclrChjRMyklsMe5qkR39WaBzl+id+427k=;
	b=tJYgHo0Jd19EYltjGbuQha6sEy6ldcVEDiWMXLasoBJwtPc13tpD+TdHWqrAIRrwU27yNL
	6EVPAa7ePCrY/+9fCykh7x2CZTPxeW27azM0B/ymUrxhjEfvm6uIALlEiju2IOd8l+47MS
	azchd0+dVdK2rcuqeTpnlE/eGIRqSxsTu6BDWIr5FqpOMoDhH+j7RiC5FFhL5V0Lr88VIQ
	S2pMjR864DLJKVzrYJdLDKg/CtsmNfoApF9g8uaALXhaWfiPx5/S/4THosDfB1X9eIrGNT
	OGQnnvb2nKye54I6MDkD03LBHaGspTqrRwznmjtswYgCkWH+MHi1TvND+prirA==
ARC-Authentication-Results: i=1;
	rspamd-674f557ffc-d5fx4;
	auth=pass smtp.auth=instrampxe0y3a smtp.mailfrom=calestyo@scientia.org
X-Sender-Id: instrampxe0y3a|x-authuser|calestyo@scientia.org
X-MC-Relay: Neutral
X-MC-Copy: stored-urls
X-MailChannels-SenderId: instrampxe0y3a|x-authuser|calestyo@scientia.org
X-MailChannels-Auth-Id: instrampxe0y3a
X-Battle-Versed: 46b33bb74ddb024f_1761273321429_4065605571
X-MC-Loop-Signature: 1761273321429:769175294
X-MC-Ingress-Time: 1761273321429
Received: from cpanel-007-fra.hostingww.com (cpanel-007-fra.hostingww.com
 [3.69.87.180])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.119.46.77 (trex/7.1.3);
	Fri, 24 Oct 2025 02:35:21 +0000
Received: from [212.104.214.84] (port=3820 helo=heisenberg.scientia.org)
	by cpanel-007-fra.hostingww.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <calestyo@scientia.org>)
	id 1vC7eD-0000000FtWW-21is
	for netfilter-devel@vger.kernel.org;
	Fri, 24 Oct 2025 02:35:19 +0000
Received: by heisenberg.scientia.org (Postfix, from userid 1000)
	id 159905AA5C08; Fri, 24 Oct 2025 04:35:17 +0200 (CEST)
From: Christoph Anton Mitterer <mail@christoph.anton.mitterer.name>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH 9/9] tools: let the unit fail if the rules file is missing
Date: Fri, 24 Oct 2025 04:08:24 +0200
Message-ID: <20251024023513.1000918-10-mail@christoph.anton.mitterer.name>
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

The idea is that if `nftables.service` is enabled it’s likely meant to load
firewall rules and shall thus rather fail loudly if that can’t be done because
the rules file is (perhaps accidentally) missing.
The default should be hardened/secure behaviour, so if someone actually wants
the conditional a systemd drop-in configuration should be used in that case.

If no rules shall be loaded by `nftables.service` it can simply be disabled (for
example, when shipped as part of a downstream package that also contains the
`nft` program).

Signed-off-by: Christoph Anton Mitterer <mail@christoph.anton.mitterer.name>
---
 tools/nftables.service.in | 2 --
 1 file changed, 2 deletions(-)

diff --git a/tools/nftables.service.in b/tools/nftables.service.in
index 0ad66b8c..81082882 100644
--- a/tools/nftables.service.in
+++ b/tools/nftables.service.in
@@ -10,8 +10,6 @@ DefaultDependencies=no
 
 IgnoreOnIsolate=yes
 
-ConditionPathExists=@pkgsysconfdir@/rules/main.nft
-
 
 [Service]
 Type=oneshot
-- 
2.51.0

