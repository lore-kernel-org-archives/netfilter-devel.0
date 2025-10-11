Received: from sienna.cherry.relay.mailchannels.net (sienna.cherry.relay.mailchannels.net [23.83.223.165])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF2B4DF72
	for <netfilter-devel@vger.kernel.org>; Sat, 11 Oct 2025 00:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.223.165
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760142585; cv=pass; b=sZKNv5/9IiEh50M5XrrkO+6DX7SSUXYledUba9oZtb/rU3btdVTpXe4i56vddg9v54aeo4dVBf9TKhrgEMHQlHiZlP9XcABy62esvWqxazvohcRgcnryaQTzXVfmnP2WGcCSEfI6qtqORPwAIw0m6inAUeX+0Hshy9K4v3wFqrI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760142585; c=relaxed/simple;
	bh=ejLBRZ9RrMm4MQ2wKYHf4Fdr8GDqBjBUr/q9X2CmEqU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AkMXAJAXJLqJhJytBP2g7xFlQHnz7n8lk+hyxc/oaT2XAT44DQGfgKXHKW1qIlLbRvuZK/GQcvdSYMdwedVcqoA+QVqx2pRFs3ZnDr8xepeK4Brht+JVWpH7og6BQ9A8DW+NSfb1T526Qiauo0y54qC75e3XIh+5G9QvClPpMyw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=christoph.anton.mitterer.name; spf=pass smtp.mailfrom=scientia.org; arc=pass smtp.client-ip=23.83.223.165
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=christoph.anton.mitterer.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=scientia.org
X-Sender-Id: instrampxe0y3a|x-authuser|calestyo@scientia.org
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id B6820860E99;
	Sat, 11 Oct 2025 00:29:37 +0000 (UTC)
Received: from cpanel-007-fra.hostingww.com (trex-green-4.trex.outbound.svc.cluster.local [100.117.6.49])
	(Authenticated sender: instrampxe0y3a)
	by relay.mailchannels.net (Postfix) with ESMTPA id EC35B862253;
	Sat, 11 Oct 2025 00:29:36 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1760142577; a=rsa-sha256;
	cv=none;
	b=7w9zd/cW50LTA+IlUGxCdP1vIfPTI6B8okaeeZVV0fj3ymjqSjUP73z7YLVo5T7w0LpAKM
	nxRCrE0OTnDstfR1zfTnhe8hiP5aUwCbjpuHFsq2Or94Gzlc+jFOViPwANUpnH7VZU3djI
	afqSD2bXw+GwAd64oGFLSPPGi4M+cXJ9QtxSK7jvTWKsgdRwTeDt4omyV4c4fphUDPxy85
	XCoZSWH8wstHOd3d2CWrVXyFMiLQQIUezPYrIIZDbdzAHPnblC8sYx5BvUGJuN2PQG1weS
	3pMZj7LNQZGYy2XMYc3AFPtrtswOEP9w/SNO8kYW3pjkTr6BBc2rJFw9fTZGVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1760142577;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DxfFu6Weu/LSeOPV+QtLH3BfwnBjHgtyFjZvcOWvnQY=;
	b=PUiiqVgSaaB1VaMC+bQ/JzJMEVW13/PiS3sd3UJvejpbbRMEAtxVnmoonH7p31XP+viJzU
	4Lf0Ysa458GnmaBb4WrYv/Bu8x+68gluY9II9LJVJQG+tRr2ngDGBDg5fAxzNKuSbxKb2L
	urqE1SUvd0SEwLmtGLSiGQjM2T28aLN5xZptEy3y+rKya/5ea/3sQB6dWGaR7E7/GGiEAj
	7S1ss3/D5C9CmmY3P5qILfKeUABZoGSxgB3TIvBG2UWho6OUPwiieblN9kIVef95iJWnqv
	cXEtXI026jPsdOZvevw5qKKJsJyprP27wGHEOUnTx2zLOKJiiM9SpbtVEdeKyg==
ARC-Authentication-Results: i=1;
	rspamd-668c7f7ff9-vrr96;
	auth=pass smtp.auth=instrampxe0y3a smtp.mailfrom=calestyo@scientia.org
X-Sender-Id: instrampxe0y3a|x-authuser|calestyo@scientia.org
X-MC-Relay: Neutral
X-MC-Copy: stored-urls
X-MailChannels-SenderId: instrampxe0y3a|x-authuser|calestyo@scientia.org
X-MailChannels-Auth-Id: instrampxe0y3a
X-Reaction-Decisive: 5d2e527d45796586_1760142577647_1112933595
X-MC-Loop-Signature: 1760142577647:2522906835
X-MC-Ingress-Time: 1760142577647
Received: from cpanel-007-fra.hostingww.com (cpanel-007-fra.hostingww.com
 [3.69.87.180])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.117.6.49 (trex/7.1.3);
	Sat, 11 Oct 2025 00:29:37 +0000
Received: from [212.104.214.84] (port=34213 helo=heisenberg.scientia.org)
	by cpanel-007-fra.hostingww.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <calestyo@scientia.org>)
	id 1v7NUP-00000009bvQ-2hVP;
	Sat, 11 Oct 2025 00:29:35 +0000
Received: by heisenberg.scientia.org (Postfix, from userid 1000)
	id 9CC6F58D12CE; Sat, 11 Oct 2025 02:29:32 +0200 (CEST)
From: Christoph Anton Mitterer <mail@christoph.anton.mitterer.name>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de,
	pablo@netfilter.org
Subject: [PATCH v2 5/7] doc: add some more documentation on bitmasks
Date: Sat, 11 Oct 2025 02:24:01 +0200
Message-ID: <20251011002928.262644-6-mail@christoph.anton.mitterer.name>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251011002928.262644-1-mail@christoph.anton.mitterer.name>
References: <6bb455009ebd3a2fe17581dfa74addc9186f33ea.camel@scientia.org>
 <20251011002928.262644-1-mail@christoph.anton.mitterer.name>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-AuthUser: calestyo@scientia.org

Signed-off-by: Christoph Anton Mitterer <mail@christoph.anton.mitterer.name>
---
 doc/data-types.txt | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/doc/data-types.txt b/doc/data-types.txt
index 18af266a..47a0d25a 100644
--- a/doc/data-types.txt
+++ b/doc/data-types.txt
@@ -26,6 +26,22 @@ integer
 
 The bitmask type (*bitmask*) is used for bitmasks.
 
+In expressions the bits of a bitmask may be specified as *'bit'[,'bit']...* with
+'bit' being the value of the bit or a pre-defined symbolic constant, if any (for
+example *ct state*’s bit 0x1 has the symbolic constant `new`).
+
+Equality of a value with such bitmask is given, if the value has any of the
+bitmask’s bits set (and optionally others).
+
+The syntax *'expression' 'value' / 'mask'* is identical to
+*'expression' and 'mask' == 'value'*.
+For example `tcp flags syn,ack / syn,ack,fin,rst` is the same as
+`tcp flags and (syn|ack|fin|rst) == syn|ack`.
+
+It should further be noted that *'expression' 'bit'[,'bit']...* is not the same
+as *'expression' {'bit'[,'bit']...}*.
+
+
 STRING TYPE
 ~~~~~~~~~~~~
 [options="header"]
-- 
2.51.0

