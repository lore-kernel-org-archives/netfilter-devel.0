Received: from iguana.tulip.relay.mailchannels.net (iguana.tulip.relay.mailchannels.net [23.83.218.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F5CA1A9B58
	for <netfilter-devel@vger.kernel.org>; Sun, 19 Oct 2025 02:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.218.253
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760839526; cv=pass; b=UqSW1/BjrkSnBRk0pj7br/vqe8YU2TLrGnXt4B7jQZGbpEKneGqUgMIFRKbEtmV/C0UTYyBEdeba/eFp5KicP/e2LeOLzDYIWPJp9R8B+LtCYqdLo5PIgafIdXr6Xvqxgl3kPcOah+t3AhMFxtYsUFTcetjotcFXuwHGUssNgbY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760839526; c=relaxed/simple;
	bh=/PD41vmHIbQE0NA3X+tA0CkLiTgXLn+Ta7rTm0tTd0A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JZqdhU5e1HZlUdOr9EsBaFaCyewbLSlxhO2X/m/7XK9YLKRNwpVFRQe5ManKuCosZEAFE4/Adpo875SQmEIinkvgLYSjucMhNy4WGxZPgrxVw9Rhtf+L5vn1QL3whtALLOoPGYt4vqzZTGteqfP0Ci8JWBU3Ygg5KWfIomHLIcU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=christoph.anton.mitterer.name; spf=pass smtp.mailfrom=scientia.org; arc=pass smtp.client-ip=23.83.218.253
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=christoph.anton.mitterer.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=scientia.org
X-Sender-Id: instrampxe0y3a|x-authuser|calestyo@scientia.org
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 19C5A7425EB;
	Sun, 19 Oct 2025 01:40:08 +0000 (UTC)
Received: from cpanel-007-fra.hostingww.com (trex-green-9.trex.outbound.svc.cluster.local [100.119.71.185])
	(Authenticated sender: instrampxe0y3a)
	by relay.mailchannels.net (Postfix) with ESMTPA id 21E04742556;
	Sun, 19 Oct 2025 01:40:06 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1760838007; a=rsa-sha256;
	cv=none;
	b=MCHOYoqSeYmqv2fRC/OixmkcihU6Yni0jwHc2vyrKWavhWgvlkIR/JrDOSheuMtVizlvRU
	ZE43taHRZcVn6t5qX6yaFnbgqZqll9a3W/VqSyBjBLB6n+9mqnkVSOJUkp8c8hdTCTNRDf
	kE2hADaBDPSD4MaZ83pxcBZKuhD898tEY0X46yyyk9T3t7x2WO+0WJga/QnW6hmhg8Y7ke
	ANN+Mfg/dspkB4BVDE0bX3pIk9nQX27o3w1hwO3tX8Bf2c3QRBz80+TuoiM30/mTLtfISh
	bQEwLT1/jhlc41xX/TWZ7+bzHa7q8xAAZ6f/XmSpacImtFzicfoYh9DhYV9kHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1760838007;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VIqqzKKekSpEIt7VEhSbN/e2t8N5k6Sg5gJmWwbMKQA=;
	b=XQNU0aTTLbnc7rtNgeOV0gcoL78/I1ryHIfcYCFvkHAWHWA70DF1SQUPddg2488dyP8Akk
	GjyOoAAihsUngdtRePKioXkcsTkhV2wlaYb4GEDsU3oYF/LRGE3ryd2A7jrJT09a1ESZOz
	MkZnp4xKyFZhg532pwEx7uW1XxSRJ08+F4XQayPEiGMRdcfvJlIKiczy+nRV31RLwa7sZu
	dFX6Uon2ACfYy4oylyLRTLExevu3ws2JIlKVlFIVZAbd1Ancwe/2/IPqGOdpBbxFf49cyw
	1Ud05g73nJZsnn1QAFyxByyVA4Mp4bW2V9rjIcxBSFl4RXBRFctT/X5FgRHsBQ==
ARC-Authentication-Results: i=1;
	rspamd-6c854d7645-7ffz2;
	auth=pass smtp.auth=instrampxe0y3a smtp.mailfrom=calestyo@scientia.org
X-Sender-Id: instrampxe0y3a|x-authuser|calestyo@scientia.org
X-MC-Relay: Neutral
X-MC-Copy: stored-urls
X-MailChannels-SenderId: instrampxe0y3a|x-authuser|calestyo@scientia.org
X-MailChannels-Auth-Id: instrampxe0y3a
X-Desert-Lyrical: 0ad83cd76afd168a_1760838008015_266726504
X-MC-Loop-Signature: 1760838008014:2965849017
X-MC-Ingress-Time: 1760838008014
Received: from cpanel-007-fra.hostingww.com (cpanel-007-fra.hostingww.com
 [3.69.87.180])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.119.71.185 (trex/7.1.3);
	Sun, 19 Oct 2025 01:40:08 +0000
Received: from [212.104.214.84] (port=13319 helo=heisenberg.scientia.org)
	by cpanel-007-fra.hostingww.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <calestyo@scientia.org>)
	id 1vAIP1-0000000DT6d-3rkZ;
	Sun, 19 Oct 2025 01:40:05 +0000
Received: by heisenberg.scientia.org (Postfix, from userid 1000)
	id 959F459EEDEF; Sun, 19 Oct 2025 03:40:02 +0200 (CEST)
From: Christoph Anton Mitterer <mail@christoph.anton.mitterer.name>
To: netfilter-devel@vger.kernel.org
Cc: Florian Westphal <fw@strlen.de>,
	pablo@netfilter.org
Subject: [PATCH v3 5/6] =?UTF-8?q?doc:=20describe=20include=E2=80=99s=20co?= =?UTF-8?q?llation=20order=20to=20be=20that=20of=20the=20C=20locale?=
Date: Sun, 19 Oct 2025 03:38:12 +0200
Message-ID: <20251019014000.49891-6-mail@christoph.anton.mitterer.name>
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

Currently, `nft` doesn’t call `setlocale(3)` and thus `glob(3)` uses the `C`
locale.

Document this as it’s possibly relevant to the ordering of included rules.

This also makes the collation order “official” so any future localisation would
need to adhere to that.

Signed-off-by: Christoph Anton Mitterer <mail@christoph.anton.mitterer.name>
---
 doc/nft.txt | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/doc/nft.txt b/doc/nft.txt
index 09da6f28..15a54f23 100644
--- a/doc/nft.txt
+++ b/doc/nft.txt
@@ -165,8 +165,8 @@ Include statements support the usual shell wildcard symbols (*,?,[]). Having no
 matches for an include statement is not an error, if wildcard symbols are used
 in the include statement. This allows having potentially empty include
 directories for statements like **include "/etc/firewall/rules/*"**. The wildcard
-matches are loaded in alphabetical order. Files beginning with dot (.) are not
-matched by include statements.
+matches are loaded in the collation order of the C locale. Files beginning with
+dot (.) are not matched by include statements.
 
 SYMBOLIC VARIABLES
 ~~~~~~~~~~~~~~~~~~
-- 
2.51.0

