Received: from cockroach.pear.relay.mailchannels.net (cockroach.pear.relay.mailchannels.net [23.83.216.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0CE42AE68
	for <netfilter-devel@vger.kernel.org>; Fri, 26 Sep 2025 02:21:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.216.37
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758853281; cv=pass; b=rS5HB2EHx8OACZFNDvzpFSMm4iwjeKWVyq344OsFxJxDGEuvE20GRs8JsJVh3pbvZW/WleCA+gdiqYYrAa9ZVkzHNHd4quMqPZYObNb9NtSz8pV4CHUmeLdgcrWztiEuptVD5LgV034jwPMAUJRDU9p7Y1PjyBcg9D26Cj1Oh9A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758853281; c=relaxed/simple;
	bh=+0aHaBDdVAwoJvIt7Kpu4t9kwtbpndlbQM0SRdTCjwc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HTz02Fq+N4+wJKcEBhdke3+KYNJvycGW33gxgNgDd7Cp9gzVlt5a8KUzKvcIRgKeUO2DqT/BUSrSNHnAJLBeT/IfitPPykst2oJOuSa3xEsyf4wIoP/Zu6xfc8AEpsxcxOHpbneXGVAuvC1ut8GA+4WOJb73VEn4AN6k/OkASIk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=christoph.anton.mitterer.name; spf=pass smtp.mailfrom=scientia.org; arc=pass smtp.client-ip=23.83.216.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=christoph.anton.mitterer.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=scientia.org
X-Sender-Id: instrampxe0y3a|x-authuser|calestyo@scientia.org
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id B55C57214DB;
	Fri, 26 Sep 2025 02:11:48 +0000 (UTC)
Received: from cpanel-007-fra.hostingww.com (100-110-207-248.trex-nlb.outbound.svc.cluster.local [100.110.207.248])
	(Authenticated sender: instrampxe0y3a)
	by relay.mailchannels.net (Postfix) with ESMTPA id E76847217E8;
	Fri, 26 Sep 2025 02:11:47 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1758852708; a=rsa-sha256;
	cv=none;
	b=b1JyYc09WQ7d0RQsx0IASMRvdhNoOkusXj5bsXqqu9/IpQo5HDkB3kxE6vcWtgLpnaO3lK
	aI7ljGLRAdvXY8j/NHYGH4x/bgZTsCXfsDGdJRwFzAT+17LKjLXSenCCxjHv/VI84Gynpw
	pe81Fga8GRtyThMBNL4kt3jF6e6OpsegkGVFwzxjgX1VeB4zMh2iVsvrcuiG6ZkTOuM7x1
	ZQKRqJVY2F0KHm831zIXOUlSCY8Lhyg5aTnwP9Lw+BFRCfmHBVnNhAgFvIJVog7ZahhWLF
	V4APJSuE6gAmSDDwGbnvH5O4yQ7kY9bt1Ts9RyzdXyP/2wy7m9GJ7nH+Dq76+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1758852708;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SL/PkH2hhc3M6lIKpkdSf//Rc0tNlWnJS+HDZzUce2g=;
	b=jiOsiLl1PxtCl10Ne8O4yuA6NDpADEaHHqVMjnLPBLRmVGn8+XkhNL7hDyL07JB0SQIUT8
	vXFsJl1+eMPgZomZJnLCchI2vunbfryE4cuirxQ5ZjhTEIeiAOoSWpNwNKGREOrcI1ftp4
	fehPlP11M5PY1VED3FW45hkLMOBSyRvmn46M6Sd/fo7PCwgaG7aIB/vymKG5qepSXminLT
	D9jsUaVJkDGTfa/o/cnHfU5KitK37uhuCluJYtsaxthpdTWLkOGFAi13PxjFF3/hPMc5yY
	LsnfjiksKTXYxAdsYvo1VapL7ER4UQIFBv+l+hH82yzs/735fYbKPVkKMGxhVw==
ARC-Authentication-Results: i=1;
	rspamd-598fd7dc44-ckpjg;
	auth=pass smtp.auth=instrampxe0y3a smtp.mailfrom=calestyo@scientia.org
X-Sender-Id: instrampxe0y3a|x-authuser|calestyo@scientia.org
X-MC-Relay: Good
X-MC-Copy: stored-urls
X-MailChannels-SenderId: instrampxe0y3a|x-authuser|calestyo@scientia.org
X-MailChannels-Auth-Id: instrampxe0y3a
X-Army-Well-Made: 5b018d211740a4d6_1758852708630_1729694255
X-MC-Loop-Signature: 1758852708630:3962721324
X-MC-Ingress-Time: 1758852708630
Received: from cpanel-007-fra.hostingww.com (cpanel-007-fra.hostingww.com
 [3.69.87.180])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.110.207.248 (trex/7.1.3);
	Fri, 26 Sep 2025 02:11:48 +0000
Received: from [79.127.207.161] (port=48076 helo=heisenberg.scientia.org)
	by cpanel-007-fra.hostingww.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <calestyo@scientia.org>)
	id 1v1xw4-0000000CeCe-025z;
	Fri, 26 Sep 2025 02:11:46 +0000
Received: by heisenberg.scientia.org (Postfix, from userid 1000)
	id 88D1655FB510; Fri, 26 Sep 2025 04:11:44 +0200 (CEST)
From: Christoph Anton Mitterer <mail@christoph.anton.mitterer.name>
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 1/7] doc: clarify evaluation of chains
Date: Fri, 26 Sep 2025 03:52:43 +0200
Message-ID: <20250926021136.757769-2-mail@christoph.anton.mitterer.name>
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

In particular:
- Mention that grouping of chains in tables is irrelevant to the evaluation
  order.
- Clarify that priorities only define the ordering of chains per hook.
- Improved potentially ambiguous wording “lower priority values have precedence
  over higher ones”, which could be mistaken that rules from lower priority
  chains might “win” over such from higher ones (which is however only the case
  if they drop/reject packets).
  The new wording simply describes in which are evalauted first, which
  implicitly refers the question which verdict “wins” to the section where
  verdicts are described, but also should work when lower priority chains mangle
  packages (in which case they might actually be considered as having
  “precedence”).

Link: https://lore.kernel.org/netfilter-devel/3c7ddca7029fa04baa2402d895f3a594a6480a3a.camel@scientia.org/T/#t
Signed-off-by: Christoph Anton Mitterer <mail@christoph.anton.mitterer.name>
---
 doc/nft.txt | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/doc/nft.txt b/doc/nft.txt
index 87129819..c7d8500d 100644
--- a/doc/nft.txt
+++ b/doc/nft.txt
@@ -453,8 +453,10 @@ interface specified in the *device* parameter.
 
 The *priority* parameter accepts a signed integer value or a standard priority
 name which specifies the order in which chains with the same *hook* value are
-traversed. The ordering is ascending, i.e. lower priority values have precedence
-over higher ones.
+traversed (regardless of the table to which they belong). The ordering is
+ascending, i.e. per hook, chains with lower priority values are evaluated before
+those with higher ones and the ordering of such with the same priority value
+being undefined.
 
 With *nat* type chains, there's a lower excluding limit of -200 for *priority*
 values, because conntrack hooks at this priority and NAT requires it.
-- 
2.51.0

