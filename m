Received: from dog.elm.relay.mailchannels.net (dog.elm.relay.mailchannels.net [23.83.212.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25737225D6
	for <netfilter-devel@vger.kernel.org>; Sat, 11 Oct 2025 00:36:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.212.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760142987; cv=pass; b=aBr6049Lo2gtTsk5cMjQYJpJlwjvS0cZkFF58RjTFh2SPZr4AqiMOzRSE6q6u7z7ftjXWANYDqWvpumzJDA/uvUDXxtI7nPIk1MEjSap6dgZ+xv0tDEUUt79L3KsBWpglIXOD6246ju2Upg7vLLuwixp6DCxDoO2oGDN5y2qwnc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760142987; c=relaxed/simple;
	bh=luYsLgUtNyb9TJ+Vu/GZ9RMrLIf3641EJzNWR9g4kkI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gFG4Iu0SCq1QW5stXUkaY4f2dH+Ki3gmIuWBtcN2HDlANgv9OQ9QO4HhGQ3AOAChsH70xevO/O9yL2QzdRXF38ZBtK7QJtY1Q9omvQSFgAzD+1L4syFVD40z4v6DStjCiogaaoGdX1jbpkPPWpZr4rqySr4rF5chPpzZiYiS3Yw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=christoph.anton.mitterer.name; spf=pass smtp.mailfrom=scientia.org; arc=pass smtp.client-ip=23.83.212.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=christoph.anton.mitterer.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=scientia.org
X-Sender-Id: instrampxe0y3a|x-authuser|calestyo@scientia.org
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 2E061100D2C;
	Sat, 11 Oct 2025 00:29:38 +0000 (UTC)
Received: from cpanel-007-fra.hostingww.com (trex-green-4.trex.outbound.svc.cluster.local [100.117.6.49])
	(Authenticated sender: instrampxe0y3a)
	by relay.mailchannels.net (Postfix) with ESMTPA id 6837D100EC0;
	Sat, 11 Oct 2025 00:29:37 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1760142578; a=rsa-sha256;
	cv=none;
	b=nOO42x6Tl9C+O0uPSc9w7K8tRQbVCI9w+/qFHhv40ggfayo2A1/dCRkDdyis3KpXSSyVCk
	00nSkZqKoeaIJjXNYpwe07k5yVef2Din2yScKYDRBnQYlKOt7tR1mMRigK9mZGB63Vt3m7
	AfJAfH0iz5EqAkNTQ3alnWMaIG2wts03Soz/H2B106/qtEINHZyQN8KKyLzikekxdMpgZZ
	RUvSOxbp48zr8ckZv/GX/B1lUTqur7FenxAuHsd4rfDQyoUgMTZaWsHPLGqXcwrw8gKSWq
	hVcc78MDyJsnnIW5Z8yZL3gTfAFkmryOHKtgawbKvOiNbnUbeEpadcoq0jTOuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1760142578;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cZ6MyydypRwNZ45iQ7uKuCZOM4lvL7j2HuU4FJEC6+s=;
	b=MOt2aEVcNE6KPE9RY+jESe8osk+teNlo9NjQfKvH5QZWGuKwsbvz687lIedhkfbi0MpwCw
	3y2UwETUr+8A9hp+zkMpFq0RIXqZnGc+iyOus1+xuOhwxwHp0sPZhpHVVQJHIiI+hpM08A
	uWvZmCWFc26frmZZNIBDbrHC9nLAIeOelDRNYpdwKDLVHGs7GCLORxph4cAz02TXjwvmG9
	cvprjaj2Yo5jhB3H4PBP0eN+KUv6aIQINffbQ6fI8B2DwixTDXnJprarh80DuaGUpDId6h
	RYoeQMZap2nbK1PbKjQsxwkmQgVymZmRBO88nFmBFmDrd2agcwU7rSSoJ51jNA==
ARC-Authentication-Results: i=1;
	rspamd-668c7f7ff9-dj9kz;
	auth=pass smtp.auth=instrampxe0y3a smtp.mailfrom=calestyo@scientia.org
X-Sender-Id: instrampxe0y3a|x-authuser|calestyo@scientia.org
X-MC-Relay: Neutral
X-MC-Copy: stored-urls
X-MailChannels-SenderId: instrampxe0y3a|x-authuser|calestyo@scientia.org
X-MailChannels-Auth-Id: instrampxe0y3a
X-Supply-Print: 6752d462000b6291_1760142578098_3275075740
X-MC-Loop-Signature: 1760142578098:3510100299
X-MC-Ingress-Time: 1760142578098
Received: from cpanel-007-fra.hostingww.com (cpanel-007-fra.hostingww.com
 [3.69.87.180])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.117.6.49 (trex/7.1.3);
	Sat, 11 Oct 2025 00:29:38 +0000
Received: from [212.104.214.84] (port=3908 helo=heisenberg.scientia.org)
	by cpanel-007-fra.hostingww.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <calestyo@scientia.org>)
	id 1v7NUO-00000009bus-0ccJ;
	Sat, 11 Oct 2025 00:29:35 +0000
Received: by heisenberg.scientia.org (Postfix, from userid 1000)
	id 8861B58D12C6; Sat, 11 Oct 2025 02:29:32 +0200 (CEST)
From: Christoph Anton Mitterer <mail@christoph.anton.mitterer.name>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de,
	pablo@netfilter.org
Subject: [PATCH v2 1/7] doc: clarify evaluation of chains
Date: Sat, 11 Oct 2025 02:23:57 +0200
Message-ID: <20251011002928.262644-2-mail@christoph.anton.mitterer.name>
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

In particular:
- Mention that grouping of chains in tables is irrelevant to the evaluation
  order.
- Clarify that priorities only define the ordering of chains per hook.
- Improved potentially ambiguous wording “lower priority values have precedence
  over higher ones”, which could be mistaken as that rules from lower priority
  chains might “win” over such from higher ones (which is however only the case
  if they drop/reject packets).
  The new wording merely describes which chains are evaluated first, implicitly
  referring the question which verdict “wins” to the section where verdicts are
  described, and also should work when lower priority chains mangle packets (in
  which case they might actually be considered as having “precedence”).

Link: https://lore.kernel.org/netfilter-devel/3c7ddca7029fa04baa2402d895f3a594a6480a3a.camel@scientia.org/T/#t
Signed-off-by: Christoph Anton Mitterer <mail@christoph.anton.mitterer.name>
---
 doc/nft.txt | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/doc/nft.txt b/doc/nft.txt
index 87129819..88c08618 100644
--- a/doc/nft.txt
+++ b/doc/nft.txt
@@ -453,8 +453,10 @@ interface specified in the *device* parameter.
 
 The *priority* parameter accepts a signed integer value or a standard priority
 name which specifies the order in which chains with the same *hook* value are
-traversed. The ordering is ascending, i.e. lower priority values have precedence
-over higher ones.
+traversed (regardless of the table to which they belong). The ordering is
+ascending, i.e. per hook, chains with lower priority values are evaluated before
+such with higher ones. The ordering of any with the same priority value is
+undefined.
 
 With *nat* type chains, there's a lower excluding limit of -200 for *priority*
 values, because conntrack hooks at this priority and NAT requires it.
-- 
2.51.0

