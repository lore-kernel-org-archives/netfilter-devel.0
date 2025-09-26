Received: from bongo.cedar.relay.mailchannels.net (bongo.cedar.relay.mailchannels.net [23.83.210.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 983A12773E6
	for <netfilter-devel@vger.kernel.org>; Fri, 26 Sep 2025 05:41:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.210.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758865277; cv=pass; b=JisJNEKP3xBtWnji/CWZmQq7nJBKmi2mMXOPjLaV0LXxxjx6t76HvJjBXuwTY3CfZAjOqNczE4GGjdokoyQ8G+aXSsyecsE3wzxdQwT7Zd7232JLF/TFjhzH6rbgMl1kTaAsIjtLSHdmfIo4mfHDr6R5RUMsjQO/uYG62X0HjoA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758865277; c=relaxed/simple;
	bh=2SRiYzUbpudE99dU0Th5u+1gHCeLxQVqy2jmoNyRocw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YPvSBR0tFS4JayHF0OMER+dn45F5zfmEt3GUiDip2ojo1FywwGSH3S9dZRpq21U5+RQWssW3QdVlW5620VMAWkGzaW8VyGMrpH/9xTYIxZF19vtpznLg4SE8UGxPSTJCjwYSGne/FGJJ0SPJigKrJwVQSjb7VGh6bl8DsegTtRg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=christoph.anton.mitterer.name; spf=pass smtp.mailfrom=scientia.org; arc=pass smtp.client-ip=23.83.210.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=christoph.anton.mitterer.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=scientia.org
X-Sender-Id: instrampxe0y3a|x-authuser|calestyo@scientia.org
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 1E3407C133A;
	Fri, 26 Sep 2025 02:11:48 +0000 (UTC)
Received: from cpanel-007-fra.hostingww.com (trex-blue-5.trex.outbound.svc.cluster.local [100.108.153.55])
	(Authenticated sender: instrampxe0y3a)
	by relay.mailchannels.net (Postfix) with ESMTPA id 4D0097C128C;
	Fri, 26 Sep 2025 02:11:47 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1758852707; a=rsa-sha256;
	cv=none;
	b=eQPq+UXehGQL6tw9+M3DyqIsPNuqxRqABAMlqFp2+TmsePAz31gUXHs7BJG7UXy4BS1tkO
	TVYKqk/DUDsWxwGhuJ8kmB/7MaexTGtL/UNPgF4YHg8lM/nAKP9q/P1WS3udeU6RwFMF6e
	+wr4v536SttYFy1ah4grVBkUCBxDRIRu0LckTmeHmVfIZ2dZ/5ZngAHiB0NLLigPca/TvX
	X7vBzTzhw/dfzB8aXNtzO2RxM+ZTMq0CTAXQUveeXuOuC0cndLp0UrckXbs6F0wv2vBliG
	zGQBP1hC4REN+GOop/OmjBIA48QwgPLT9xmtCrPI3O5TY0nICk2vWZrv5nYxcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1758852707;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wf84udpeOIJEPi8MXZZiEeKz+65S9cLYGZfV2Pyq/C8=;
	b=n9/JQvDk1qBwCqwGwg3fa33q9Wqbe8Ot2s9bseVNRsvwvSRRFC+oBcApVRLhtCJHyPJTp+
	HjUjKxv2XldODeihTVJPaHrYJ5VnOUOqAiuk22c7Tm3QQow/1TTuqJMPU2OJI9sKpD5xNE
	8PVp/lu65A1nW4sY2BJXZWYoIB1N0csUPyHTLSnKYGpiNIkD00RY2/buvw49qkw0FpF3HS
	XOYi4vZDSFVNJkLdOu2qo5ZJdH3mokx+QDnBN6uKMoyBdU4YC99QCU+cY/v8VTWkjEmEdU
	dEzQL+MRBKkbJ10DK6Xs8rEsV3dk9xijuLE3ZaLUlG/GDpeyh2bLgdsIt1e87w==
ARC-Authentication-Results: i=1;
	rspamd-598fd7dc44-cxztd;
	auth=pass smtp.auth=instrampxe0y3a smtp.mailfrom=calestyo@scientia.org
X-Sender-Id: instrampxe0y3a|x-authuser|calestyo@scientia.org
X-MC-Relay: Good
X-MC-Copy: stored-urls
X-MailChannels-SenderId: instrampxe0y3a|x-authuser|calestyo@scientia.org
X-MailChannels-Auth-Id: instrampxe0y3a
X-Stretch-Sponge: 3e55a67a3afa0a79_1758852707971_2666459902
X-MC-Loop-Signature: 1758852707971:4154793598
X-MC-Ingress-Time: 1758852707971
Received: from cpanel-007-fra.hostingww.com (cpanel-007-fra.hostingww.com
 [3.69.87.180])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.108.153.55 (trex/7.1.3);
	Fri, 26 Sep 2025 02:11:47 +0000
Received: from [79.127.207.161] (port=55103 helo=heisenberg.scientia.org)
	by cpanel-007-fra.hostingww.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <calestyo@scientia.org>)
	id 1v1xw3-0000000CeCg-3ze7;
	Fri, 26 Sep 2025 02:11:45 +0000
Received: by heisenberg.scientia.org (Postfix, from userid 1000)
	id 916A455FB514; Fri, 26 Sep 2025 04:11:44 +0200 (CEST)
From: Christoph Anton Mitterer <mail@christoph.anton.mitterer.name>
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 3/7] =?UTF-8?q?doc:=20minor=20improvements=20with=20respec?= =?UTF-8?q?t=20to=20the=20term=20=E2=80=9Cruleset=E2=80=9D?=
Date: Fri, 26 Sep 2025 03:52:45 +0200
Message-ID: <20250926021136.757769-4-mail@christoph.anton.mitterer.name>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250926021136.757769-1-mail@christoph.anton.mitterer.name>
References: <aNTwsMd8wSe4aKmz@calendula>
 <20250926021136.757769-1-mail@christoph.anton.mitterer.name>
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
 doc/statements.txt | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/doc/nft.txt b/doc/nft.txt
index c7d8500d..f52b7fef 100644
--- a/doc/nft.txt
+++ b/doc/nft.txt
@@ -910,9 +910,9 @@ actions, such as logging, rejecting a packet, etc. +
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
index b085b3ab..bddbf12f 100644
--- a/doc/statements.txt
+++ b/doc/statements.txt
@@ -41,7 +41,7 @@ evaluated anymore for the packet.
 *queue*:: Terminate ruleset evaluation and queue the packet to userspace.
 Userspace must provide a drop or accept verdict.  In case of accept, processing
 resumes with the next base chain hook, not the rule following the queue verdict.
-*continue*:: Continue ruleset evaluation with the next rule. This
+*continue*:: Continue evaluation with the next rule. This
  is the default behaviour in case a rule issues no verdict.
 *return*:: In a regular chain that was called via *jump*, end evaluation of that
  chain and return to the calling chain, continuing evaluation there at the rule
-- 
2.51.0

