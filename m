Received: from eastern.birch.relay.mailchannels.net (eastern.birch.relay.mailchannels.net [23.83.209.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0776426ACC
	for <netfilter-devel@vger.kernel.org>; Sun, 19 Oct 2025 01:58:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.209.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760839115; cv=pass; b=pSRpP82SyHJBeAgsLWHugBcJXWCdzqGHp/bTfGTUIhuo7KEOcVZQWlmWKTdB4yTlKrYOYfspUrDMC8+RIBgmIRFfkAK9FMyYRsoieOxTSYfIJDDtyUcqii96pv2jnwkI9IHWnDb6Xw3ihwPfzeS0wsU/FuM64JoF2OsJMA1fZNo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760839115; c=relaxed/simple;
	bh=ZGBF1xXorly4mer+p2XusNts6zQ8Ylm9vAdIdgoq5jM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nuTumA0k8w2QILxoqTavNAwQyibc1k94AzKMKyKEOzpiytKFOO5fd/a+hCwmX2M+t2cQgIgFyFaJgQY2I7gQW4e6sqFcjowvegpuzG67ihXYRD9Upwpcpm5cz3r6GWJh1PMwdo/DzVl0vchOa+IT7qkXj/v2RRZq5rOiOjXQZRg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=christoph.anton.mitterer.name; spf=pass smtp.mailfrom=scientia.org; arc=pass smtp.client-ip=23.83.209.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=christoph.anton.mitterer.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=scientia.org
X-Sender-Id: instrampxe0y3a|x-authuser|calestyo@scientia.org
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 789C1416FF;
	Sun, 19 Oct 2025 01:40:06 +0000 (UTC)
Received: from cpanel-007-fra.hostingww.com (100-121-87-189.trex-nlb.outbound.svc.cluster.local [100.121.87.189])
	(Authenticated sender: instrampxe0y3a)
	by relay.mailchannels.net (Postfix) with ESMTPA id A106641572;
	Sun, 19 Oct 2025 01:40:05 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1760838006; a=rsa-sha256;
	cv=none;
	b=6Mm0WI2heGNI/kU06ZhiKncc8aMN9GAtTdacIVw2nKgHflu7alkalKubK9IdeCQmIHj/fC
	2hGiKSJEcwTeBnyH0k4GMqw5InGEItTWwBvq7E4dPLEdImLxhYs6No3AFxaJKWsUvtJG0o
	+wbJ1/6v4r4xRXvgsJ679krdRXVpFgOSrZl3ZdPCPtkVfjdaaddxcTB83H5potLZDrGf44
	y2S5Mcgv49GlQOqL9eB3a1p5P9UzhPiCDbMtnX4SWPKa6g2YLvsxeshjdu20xjO/iG4rKV
	DU8jIWUYMPRYF+1AOOG5kvC5smh5J6cpa1CMfI824I2g29QRyoAH2DjL50zN1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1760838006;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cXUlnD3JaioK3X+6sLoVF1LKyMFxVX2g7vLFivESyXM=;
	b=zE6UFfBfZ+NOMoNKraIiWJDeemKQIDg2P9ZHdCB7AXu65WHYg+YlbGqgJ86x0z5IZKhiYt
	Taz8FlSHFByNGMUAvnZ0khuYGaHesKdtNEz+SNMbL+v+hcgvckiFgAGZJRUA7cJ0OawgJt
	ch/CO7pYI0TF1HFq49xKtCizZ/lnr8ipjnRHGhEbDrjYm577yEzOUSPm07cY0fjkUkqsfh
	pDDVyd3A0r0/233A8fLYuUodHe3Lz99XR33EQaBh1UB7giP184HhgCS3RGhiyCzriMUm9e
	NLzXy1qIkqpjwhigeiCQ9VfnDkAO5p3iSfPCTLZfUSLQrCUkMc2yI15X/JmNXg==
ARC-Authentication-Results: i=1;
	rspamd-6c854d7645-z2qqq;
	auth=pass smtp.auth=instrampxe0y3a smtp.mailfrom=calestyo@scientia.org
X-Sender-Id: instrampxe0y3a|x-authuser|calestyo@scientia.org
X-MC-Relay: Neutral
X-MC-Copy: stored-urls
X-MailChannels-SenderId: instrampxe0y3a|x-authuser|calestyo@scientia.org
X-MailChannels-Auth-Id: instrampxe0y3a
X-Cooing-Befitting: 542dce8c4e4e3035_1760838006340_2340451130
X-MC-Loop-Signature: 1760838006340:3703172208
X-MC-Ingress-Time: 1760838006340
Received: from cpanel-007-fra.hostingww.com (cpanel-007-fra.hostingww.com
 [3.69.87.180])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.121.87.189 (trex/7.1.3);
	Sun, 19 Oct 2025 01:40:06 +0000
Received: from [212.104.214.84] (port=46602 helo=heisenberg.scientia.org)
	by cpanel-007-fra.hostingww.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <calestyo@scientia.org>)
	id 1vAIP0-0000000DT4j-1qpg;
	Sun, 19 Oct 2025 01:40:04 +0000
Received: by heisenberg.scientia.org (Postfix, from userid 1000)
	id 8637759EEDE9; Sun, 19 Oct 2025 03:40:02 +0200 (CEST)
From: Christoph Anton Mitterer <mail@christoph.anton.mitterer.name>
To: netfilter-devel@vger.kernel.org
Cc: Florian Westphal <fw@strlen.de>,
	pablo@netfilter.org
Subject: [PATCH v3 2/6] =?UTF-8?q?doc:=20minor=20improvements=20with=20res?= =?UTF-8?q?pect=20to=20the=20term=20=E2=80=9Cruleset=E2=80=9D?=
Date: Sun, 19 Oct 2025 03:38:09 +0200
Message-ID: <20251019014000.49891-3-mail@christoph.anton.mitterer.name>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251019014000.49891-1-mail@christoph.anton.mitterer.name>
References: <6bb455009ebd3a2fe17581dfa74addc9186f33ea.camel@scientia.org>
 <20251019014000.49891-1-mail@christoph.anton.mitterer.name>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-AuthUser: calestyo@scientia.org

Statements are elements of rules. Non-terminal statement are in particular
passive with respect to their rules (and thus automatically with respect to the
whole ruleset).

In “Continue ruleset evaluation”, it’s not necessary to mention the ruleset as
it’s obvious that the evaluation of the current chain will be continued.

Signed-off-by: Christoph Anton Mitterer <mail@christoph.anton.mitterer.name>
---
 doc/nft.txt        | 6 +++---
 doc/statements.txt | 4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/doc/nft.txt b/doc/nft.txt
index 78dbef66..49fffe2f 100644
--- a/doc/nft.txt
+++ b/doc/nft.txt
@@ -932,9 +932,9 @@ actions, such as logging, rejecting a packet, etc. +
 Statements exist in two kinds. Terminal statements unconditionally terminate
 evaluation of the current rule, non-terminal statements either only
 conditionally or never terminate evaluation of the current rule, in other words,
-they are passive from the ruleset evaluation perspective. There can be an
-arbitrary amount of non-terminal statements in a rule, but only a single
-terminal statement as the final statement.
+they are passive from the rule evaluation perspective. There can be an arbitrary
+amount of non-terminal statements in a rule, but only a single terminal
+statement as the final statement.
 
 include::statements.txt[]
 
diff --git a/doc/statements.txt b/doc/statements.txt
index 1338471e..61a4614d 100644
--- a/doc/statements.txt
+++ b/doc/statements.txt
@@ -63,8 +63,8 @@ Terminate ruleset evaluation and drop the packet. This occurs
  either the base chain or a regular chain that was reached solely via *goto*
  verdicts) end evaluation of the current base chain (and any regular chains
  called from it) using the base chain’s policy as implicit verdict.
-*continue*:: Continue ruleset evaluation with the next rule. This
- is the default behaviour in case a rule issues no verdict.
+*continue*:: Continue evaluation with the next rule. This is the default
+ behaviour in case a rule issues no verdict.
 *queue*:: Terminate ruleset evaluation and queue the packet to userspace.
  Userspace must provide a drop or accept verdict.  In case of accept, processing
  resumes with the next base chain hook, not the rule following the queue
-- 
2.51.0

