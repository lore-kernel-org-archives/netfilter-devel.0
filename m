Received: from beige.elm.relay.mailchannels.net (beige.elm.relay.mailchannels.net [23.83.212.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 195042628D
	for <netfilter-devel@vger.kernel.org>; Fri, 24 Oct 2025 01:40:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.212.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761270026; cv=pass; b=HKPu99eEkzW+Ib1Dmxeko0hiNXlvnwq9YDluK8qk+SvkctcLQbW+/PUSQpENXkpm/ueMXzgcwRTA/Oz8yKb11x6fszktqzLwALpoaZiNWV7MaJeCynmEdGZI24vxYaO8n6q87H9cLdNK4S57lwMXl6h/Lu+Z98MI7MzZP+JU71g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761270026; c=relaxed/simple;
	bh=wT2C0wrYcYNRbXk3j9i72Pjh2kueBn7bpZk66m+WShs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Veagu5wzXtmlip4d1dpW8r8fc/ughT4L4eBt4WsCwAbQxzyyKJfgy+mFLebjw2LJpggaLNqwmk2W8gzhGuxEGVXzVeaOWGXAqDA9UE8NcV/KRo/W7n5wWZMb959kcHxdrH7ZGgpfFQ9DdqD+L5xiaa2Z+YsQHTUK4oYaUm+b+0g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=christoph.anton.mitterer.name; spf=pass smtp.mailfrom=scientia.org; arc=pass smtp.client-ip=23.83.212.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=christoph.anton.mitterer.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=scientia.org
X-Sender-Id: instrampxe0y3a|x-authuser|calestyo@scientia.org
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 41362942015;
	Fri, 24 Oct 2025 01:40:17 +0000 (UTC)
Received: from cpanel-007-fra.hostingww.com (100-117-181-104.trex-nlb.outbound.svc.cluster.local [100.117.181.104])
	(Authenticated sender: instrampxe0y3a)
	by relay.mailchannels.net (Postfix) with ESMTPA id 66EFB941BA5;
	Fri, 24 Oct 2025 01:40:16 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1761270017; a=rsa-sha256;
	cv=none;
	b=7h04eWWtor6uvsVbnl8YFZGCWwtEuKi2VuUea7+qth5nPEwyj5dfvhcTiFDVju4awg+/ey
	6AieOok4qR1XCnuqxZQn/cD+oBFck5eL8OpTBbLECyGF+wZ74gSZVHznPcw0sHtE5ukQeD
	hU/HlrV+JLrVZNDiHibvLUQb8AP0DxmEIQzQ/37yNq61E6rHdTW9vL1huJpdKB5C8yKPxX
	EugQMGdldDaIh9Ie1vXY6BZ8aINAlgOO3U/i5raGlxiYvfiyZQ0cNqR2GCKFiDE5S78PHU
	HLHSPEyBWNgzp6RxNNkRW69UG9ArlWdwxYDjTtSWeB7J1C+a+g3ziePLIbwv0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1761270017;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=w0E9lHD9VPt5jqHi4clPmUd7V1QPaPOSJniqD+TK4aI=;
	b=QYnqoLscOCMw5QTdiptnxWksou7lgG0z4GFYe5pEiagsaAVTiRHuheu6KWeCzTxX1VA/z5
	u8yGszjjha5yqKrPwWBXqRpzqEDQuG9uW8+QF1+6qTG6QbbN4ljHFCoBIzc8OE6kvLT6MR
	0BBhAMCsNtper8X/1T07ZXoBqWe6pPQmxtDorgBnuf4fFp8VAVbHl/00AVG2je6iSjMxQR
	WGwe3kS6HQenuSaI0AtPaxQoDsIqfmzpjwlacW3OxOEtdwNa+jSL4XQYPj5B0jOsjfoPGK
	q++ULv9VjE08rQYvFovnooyiejqMwd2unyXUZJ5aChawsnB/xKhJmc/cO4rY0w==
ARC-Authentication-Results: i=1;
	rspamd-9799b5d46-2tpxf;
	auth=pass smtp.auth=instrampxe0y3a smtp.mailfrom=calestyo@scientia.org
X-Sender-Id: instrampxe0y3a|x-authuser|calestyo@scientia.org
X-MC-Relay: Neutral
X-MC-Copy: stored-urls
X-MailChannels-SenderId: instrampxe0y3a|x-authuser|calestyo@scientia.org
X-MailChannels-Auth-Id: instrampxe0y3a
X-Callous-Bitter: 73ac2021143595cb_1761270017109_217793444
X-MC-Loop-Signature: 1761270017109:4078719102
X-MC-Ingress-Time: 1761270017109
Received: from cpanel-007-fra.hostingww.com (cpanel-007-fra.hostingww.com
 [3.69.87.180])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.117.181.104 (trex/7.1.3);
	Fri, 24 Oct 2025 01:40:17 +0000
Received: from [212.104.214.84] (port=45816 helo=heisenberg.scientia.org)
	by cpanel-007-fra.hostingww.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <calestyo@scientia.org>)
	id 1vC6mu-0000000FiJ8-3Lmo;
	Fri, 24 Oct 2025 01:40:14 +0000
Received: by heisenberg.scientia.org (Postfix, from userid 1000)
	id 382D15AA52F8; Fri, 24 Oct 2025 03:40:13 +0200 (CEST)
From: Christoph Anton Mitterer <mail@christoph.anton.mitterer.name>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org,
	fw@strlen.de
Subject: [PATCH v5 4/4] doc: minor improvements the `reject` statement
Date: Fri, 24 Oct 2025 03:36:48 +0200
Message-ID: <20251024014010.994513-5-mail@christoph.anton.mitterer.name>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251024014010.994513-1-mail@christoph.anton.mitterer.name>
References: <20251024014010.994513-1-mail@christoph.anton.mitterer.name>
Reply-To: <6bb455009ebd3a2fe17581dfa74addc9186f33ea.camel@scientia.org>
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
 doc/nft.txt        |  1 +
 doc/statements.txt | 10 ++++++----
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/doc/nft.txt b/doc/nft.txt
index 4a90f020..006086e6 100644
--- a/doc/nft.txt
+++ b/doc/nft.txt
@@ -572,6 +572,7 @@ table inet filter {
 nft delete rule inet filter input handle 5
 -------------------------
 
+[[OVERALL_EVALUATION_OF_THE_RULESET]]
 OVERALL EVALUATION OF THE RULESET
 ---------------------------------
 This is a summary of how the ruleset is evaluated.
diff --git a/doc/statements.txt b/doc/statements.txt
index e1d8552c..1b05b4b6 100644
--- a/doc/statements.txt
+++ b/doc/statements.txt
@@ -1,3 +1,4 @@
+[[VERDICT_STATEMENTS]]
 VERDICT STATEMENTS
 ~~~~~~~~~~~~~~~~~~
 The verdict statements alter control flow in the ruleset and issue policy
@@ -222,10 +223,11 @@ ____
                  *tcp reset*
 ____
 
-A reject statement is used to send back an error packet in response to the
-matched packet otherwise it is equivalent to drop so it is a terminating
-statement, ending rule traversal. This statement is only valid in base chains
-using the *prerouting*, *input*,
+A reject statement tries to send back an error packet in response to the matched
+packet and then interally issues a *drop* verdict.
+It’s thus a terminating statement with all consequences of the latter (see
+<<OVERALL_EVALUATION_OF_THE_RULESET>> respectively <<VERDICT_STATEMENTS>>).
+This statement is only valid in base chains using the *prerouting*, *input*,
 *forward* or *output* hooks, and user-defined chains which are only called from
 those chains.
 
-- 
2.51.0

