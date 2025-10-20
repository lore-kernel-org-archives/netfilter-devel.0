Received: from tiger.tulip.relay.mailchannels.net (tiger.tulip.relay.mailchannels.net [23.83.218.248])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79DAF2673AA
	for <netfilter-devel@vger.kernel.org>; Mon, 20 Oct 2025 23:51:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.218.248
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761004305; cv=pass; b=X1MowqBYyS9AmxNqg9F5n5bS5XIq//cHTzgsgvUbU02lyw6rndUHYU25sY4IKfG5TT++R4ZKTReWwohEfl9aVja5mmYw9L7SJ0weVo2K6smVGIkD3Iq9c9XQYdG4qWCfmZFemqcGjCwYk3j1bjsI9ela/ASZDTOJiQztpJHgUbc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761004305; c=relaxed/simple;
	bh=9C907wm2nrItVHIartIvjsDIS++/eBTrYcFFa/Kyf8o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nBIqXKbim9teWecc2GAmEFf5+849X2lP2yda6lr/uNASR2uO8ZAvdZCLWMuDzc4OLMiMU/avPntcmtOEjFFBSWDKkwR2mik1di5i+KnL6+5B+o+3f6TMMlYJV89+jLqXChSUY/cnjJwqvXAGRdtcZm7up+3Qk9/yJwhs7Z61bwA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=christoph.anton.mitterer.name; spf=pass smtp.mailfrom=scientia.org; arc=pass smtp.client-ip=23.83.218.248
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=christoph.anton.mitterer.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=scientia.org
X-Sender-Id: instrampxe0y3a|x-authuser|calestyo@scientia.org
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id A8BA0722EE6;
	Mon, 20 Oct 2025 23:51:37 +0000 (UTC)
Received: from cpanel-007-fra.hostingww.com (100-116-100-247.trex-nlb.outbound.svc.cluster.local [100.116.100.247])
	(Authenticated sender: instrampxe0y3a)
	by relay.mailchannels.net (Postfix) with ESMTPA id E0E26721D9F;
	Mon, 20 Oct 2025 23:51:36 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1761004297; a=rsa-sha256;
	cv=none;
	b=skRtaxpYBTr61/fLGKclgB//+CvsJrIIqF4gcyinL78jFTJEyXbwREJ7Hj8sXU41zbg3IS
	EeDN0/qE2b4WcQAoWmhs1MXs/kraYr4UMW2SAvUObScCix3/EPxhm3qqyZ0S+QmLPj7RW0
	g9zWYTxE0LLgnK2X38Ud/uFf+wo1nmmR6/mlOOv/J/P9OKozatKZRc4LmvNhR1eP7GXdC3
	pwI5vK0YX/hIxQIE4igDZFzo5npHazr0XePwB9GHZSTf2jMbvDshsS565tsVYLrjRnOkfT
	CSjM7w6Q4lFPq766pmOcfWaE4l/0pgOzDonF7c0TT1cYkI0OC8H20h2KF9aCeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1761004297;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=47Fr9xpW/RHq4viGv70OC3E/CGupJpbkGV0cpy/d1So=;
	b=RbdvbpFpqaMhs3cXRSYous7eDZhxbcH4Up1qY22Kn20r4mGDDe9N2blIMhyQlSuQiASgaj
	wCpTzDZXnJcqfw9e/xHyPfc001VkqTLn1F+SqwT/19nI83N5cW7Vzl2YzBmoLLHn8hTqW0
	mX0n/moDOurt73l7SaJSmZ5Onb95oks4MmqXmnuLqGfJCOrEmHbG2hduAk8Fx7WMWrd4Jg
	uj8rlVL445V2z2ekX+F5eMHgM29AqyVOhtnvCPVpBliOoAe3njV0v2YRW8W6LeO4zpz+yT
	+qnAtkbsZfEY4ngM7fEQeqsI1i+kIDK7GQoMN+JTRRaCPbign2oWecE+MPg+TQ==
ARC-Authentication-Results: i=1;
	rspamd-869c579f6-9qz7h;
	auth=pass smtp.auth=instrampxe0y3a smtp.mailfrom=calestyo@scientia.org
X-Sender-Id: instrampxe0y3a|x-authuser|calestyo@scientia.org
X-MC-Relay: Neutral
X-MC-Copy: stored-urls
X-MailChannels-SenderId: instrampxe0y3a|x-authuser|calestyo@scientia.org
X-MailChannels-Auth-Id: instrampxe0y3a
X-Hysterical-Continue: 71fb2d255fb7b827_1761004297587_2288899657
X-MC-Loop-Signature: 1761004297587:3372985595
X-MC-Ingress-Time: 1761004297586
Received: from cpanel-007-fra.hostingww.com (cpanel-007-fra.hostingww.com
 [3.69.87.180])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.116.100.247 (trex/7.1.3);
	Mon, 20 Oct 2025 23:51:37 +0000
Received: from [79.127.207.162] (port=27545 helo=heisenberg.scientia.org)
	by cpanel-007-fra.hostingww.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <calestyo@scientia.org>)
	id 1vAzf5-00000009cpM-3l44;
	Mon, 20 Oct 2025 23:51:35 +0000
Received: by heisenberg.scientia.org (Postfix, from userid 1000)
	id 6ECE35A29C2B; Tue, 21 Oct 2025 01:51:32 +0200 (CEST)
From: Christoph Anton Mitterer <mail@christoph.anton.mitterer.name>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de,
	pablo@netfilter.org
Subject: [PATCH v4 5/5] doc: minor improvements the `reject` statement
Date: Tue, 21 Oct 2025 01:49:05 +0200
Message-ID: <20251020235130.361377-6-mail@christoph.anton.mitterer.name>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251020235130.361377-1-mail@christoph.anton.mitterer.name>
References: <6bb455009ebd3a2fe17581dfa74addc9186f33ea.camel@scientia.org>
 <20251020235130.361377-1-mail@christoph.anton.mitterer.name>
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
 doc/statements.txt | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/doc/statements.txt b/doc/statements.txt
index e1d8552c..fa2a1cc6 100644
--- a/doc/statements.txt
+++ b/doc/statements.txt
@@ -222,10 +222,11 @@ ____
                  *tcp reset*
 ____
 
-A reject statement is used to send back an error packet in response to the
-matched packet otherwise it is equivalent to drop so it is a terminating
-statement, ending rule traversal. This statement is only valid in base chains
-using the *prerouting*, *input*,
+A reject statement tries to send back an error packet in response to the matched
+packet and then interally issues a *drop* verdict.
+It’s thus a terminating statement with all consequences of the latter (see
+<<OVERALL EVALUATION OF THE RULESET>> respectively <<VERDICT STATEMENTS>>).
+This statement is only valid in base chains using the *prerouting*, *input*,
 *forward* or *output* hooks, and user-defined chains which are only called from
 those chains.
 
-- 
2.51.0

