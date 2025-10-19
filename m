Received: from cockroach.ash.relay.mailchannels.net (cockroach.ash.relay.mailchannels.net [23.83.222.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E03D17A2F6
	for <netfilter-devel@vger.kernel.org>; Sun, 19 Oct 2025 01:40:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.222.37
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760838016; cv=pass; b=jNTYPeXJbkoRzy79eUJzAunrD7r4EFFcVEp3sPnPbye/QtQMqD4AAbvfyl3OX/r6D/9+IjemVM2JUqxYSd1p6ZJMH6cdTH828o2l4TI40+jyO/z1tugG8vjBwf6MujGTAto5d7D4KWywoc1tDDGz4dtiDSKcHw3stvu/0LcpYCY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760838016; c=relaxed/simple;
	bh=dY6Pum6YQ7cW5pLtAeuDa3AgXaJ/CAk8nhXbkVBZNEs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WxU/PBgsK76A7dIjKXVccZz6bU1fylV6MQzo5zYuLyRR3ZgAcR0Js0BRnv3p2lD82vOZJOKkt2n59OFllRKbAbYefbV4cgDs0V9+G/idUuI7ANLbKjoWNISi1aX2rEqHzc+aGqdD1bt8bbB1MjtQ+Zj0414DxlHOUNz1l/nm69A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=christoph.anton.mitterer.name; spf=pass smtp.mailfrom=scientia.org; arc=pass smtp.client-ip=23.83.222.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=christoph.anton.mitterer.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=scientia.org
X-Sender-Id: instrampxe0y3a|x-authuser|calestyo@scientia.org
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id C4AA6101AED;
	Sun, 19 Oct 2025 01:40:06 +0000 (UTC)
Received: from cpanel-007-fra.hostingww.com (100-121-87-108.trex-nlb.outbound.svc.cluster.local [100.121.87.108])
	(Authenticated sender: instrampxe0y3a)
	by relay.mailchannels.net (Postfix) with ESMTPA id 0AD4E101B60;
	Sun, 19 Oct 2025 01:40:05 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1760838006; a=rsa-sha256;
	cv=none;
	b=2ERBoRPOkO7RG+UlyWrGKwD++RVOM2jZjXbIr8ayf+Roqi4/4QP53DsUi5DiAZjFYnr0Es
	0fpqMCZc/Mt2Eo3oYXnCk7bUaN5n++O/YKyC1Zn6T2ChmIBVt9FZMr3+P1KJEsSvx8jUQq
	ZtBm8a7vt70wgf3XkRmCz9G4MQtEI0H50UXX7RYby7eiVhLrOsjJaPITrZChSrEa1DpJqG
	gtfznf62yoNuDotorSDc7lyiiKNihCITaxspi2FyOX51zJrEzy7kdMvvyMbIlpfwTczvWX
	gXwoGW0hUvSzUBQNbJMleTcobMLMEF0wDGJzlTgLOrdS6tHd7x6Ci088d6hklw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1760838006;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Zfneuvewl/4V1ssG/oZ160K9/C1Vxq8W42BCQQMHNWw=;
	b=MYOyuf1OAWeVU0YU0823YQRLrx7BfqMIzP54Vuxzx08VMY1Vlmb2MYaBcHnk7canzCwGYq
	7ySzUYBsqHNoawBZwN2OJ6hz2t6Fm0zaRc0fF6pGDUyLnomgVmj/XedwKN5xcF9dI5yFx+
	VHtCb402wINswu3RKBteelP8cW6JlLeGOIXVPED2zxkPqSOTHVw9Tuk8Z6nU+xow1TCvfA
	U1/3hMw6RLi6pZh4zBqWsZk6qmGrJDJfxcb50wm/vNK40kAKmXvxQxBY+rN8VHqPfv4Nec
	JZmrsy+149aURJegHloOQVR2wKtLPKWZGY5jQbh1t7q7TSvFNHIi84OCWfOgRA==
ARC-Authentication-Results: i=1;
	rspamd-6c854d7645-7ffz2;
	auth=pass smtp.auth=instrampxe0y3a smtp.mailfrom=calestyo@scientia.org
X-Sender-Id: instrampxe0y3a|x-authuser|calestyo@scientia.org
X-MC-Relay: Neutral
X-MC-Copy: stored-urls
X-MailChannels-SenderId: instrampxe0y3a|x-authuser|calestyo@scientia.org
X-MailChannels-Auth-Id: instrampxe0y3a
X-Cold-Tank: 158addb62616c5dd_1760838006711_3317759172
X-MC-Loop-Signature: 1760838006711:3203193113
X-MC-Ingress-Time: 1760838006711
Received: from cpanel-007-fra.hostingww.com (cpanel-007-fra.hostingww.com
 [3.69.87.180])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.121.87.108 (trex/7.1.3);
	Sun, 19 Oct 2025 01:40:06 +0000
Received: from [212.104.214.84] (port=52910 helo=heisenberg.scientia.org)
	by cpanel-007-fra.hostingww.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <calestyo@scientia.org>)
	id 1vAIP0-0000000DT4t-2OXW;
	Sun, 19 Oct 2025 01:40:04 +0000
Received: by heisenberg.scientia.org (Postfix, from userid 1000)
	id 8C39F59EEDEB; Sun, 19 Oct 2025 03:40:02 +0200 (CEST)
From: Christoph Anton Mitterer <mail@christoph.anton.mitterer.name>
To: netfilter-devel@vger.kernel.org
Cc: Florian Westphal <fw@strlen.de>,
	pablo@netfilter.org
Subject: [PATCH v3 3/6] doc: add overall description of the ruleset evaluation
Date: Sun, 19 Oct 2025 03:38:10 +0200
Message-ID: <20251019014000.49891-4-mail@christoph.anton.mitterer.name>
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

Signed-off-by: Christoph Anton Mitterer <mail@christoph.anton.mitterer.name>
---
 doc/nft.txt | 102 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 102 insertions(+)

diff --git a/doc/nft.txt b/doc/nft.txt
index 49fffe2f..363c67ba 100644
--- a/doc/nft.txt
+++ b/doc/nft.txt
@@ -572,6 +572,108 @@ table inet filter {
 nft delete rule inet filter input handle 5
 -------------------------
 
+OVERALL EVALUATION OF THE RULESET
+---------------------------------
+This is a summary of how the ruleset is evaluated.
+
+* Even if a packet is accepted by the ruleset (and thus by netfilter), it may
+  still get discarded by other means, for example Linux generally ignores
+  various ICMP types and there are sysctl options like
+  `net.ipv{4,6}.conf.*.forwarding` or `net.ipv4.conf.*.rp_filter`.
+* Tables are merely a concept of nftables to structure the ruleset and not known
+  to netfilter itself.
+  They are thus irrelevant with respect to netfilter’s evaluation of the
+  ruleset.
+* Packets traverse the network stack and at various hooks (see
+  <<ADDRESS_FAMILIES>> above for lists of hooks per address family) they’re
+  evaluated by any base chains attached to these hooks.
+* Base chains may call regular chains and regular chains may call other regular
+  chains (via *jump* and *goto* verdicts), in which case evaluation continues in
+  the called chain.
+  Base chains themsevlves cannot be called and only chains of the same table can
+  be called.
+* For each hook, the attached chains are evaluated in order of their priorities.
+  Chains with lower priority values are evaluated before those with higher ones.
+  The order of chains with the same priority value is undefined.
+* An *accept* verdict (including an implict one via the base chain’s policy)
+  ends the evaluation of the current base chain (and any regular chains called
+  from that).
+  It accepts the packet only with respect to the current base chain. Any other
+  base chain (or regular chain called by such) with a higher priority of the
+  same hook as well as any other base chain (or regular chain called by such) of
+  any later hook may however still ultimately *drop* (which might also be done
+  via verdict-like statements that imply *drop*, like *reject*) the packet with
+  an according verdict (with consequences as described below for *drop*).
+  Thus and merely from netfilter’s point of view, a packet is only ultimately
+  accepted if none of the chains (regardless of their tables) that are attached
+  to any of the respectively relevant hooks issues a *drop* verdict (be it
+  explicitly or implicitly by policy or via a verdict-like statement that
+  implies *drop*, for example *reject*), which already means that there has to
+  be at least one *accept* verdict (be it explicitly or implicitly by policy).
+  All this applies analogously to verdict-like statements that imply *accept*,
+  for example the NAT statements.
+* A *drop* verdict (including an implict one via the base chain’s policy)
+  immediately ends the evaluation of the whole ruleset and ultimately drops the
+  packet.
+  Unlike with an *accept* verdict, no further chains of any hook and regardless
+  of their table get evaluated and it’s therefore not possible to have an *drop*
+  verdict overruled.
+  Thus, if any base chain uses drop as its policy, the same base chain (or any
+  regular chain directly or indirectly called by it) must accept a packet or it
+  is ensured to be ultimately dropped by it.
+  All this applies analogously to verdict-like statements that imply *drop*,
+  for example *reject*.
+* Given the semantics of *accept*/*drop* and only with respect to the utlimate
+  decision of whether a packet is accepted or dropped, the ordering of the
+  various base chains per hook via their priorities matters only in so far, as
+  any of them modifies the packet or its meta data and that has an influence on
+  the verdicts issued by the chains – other than that, the ordering shouldn’t
+  matter (except for performance and other side effects).
+  It also means that short-circuiting the ultimate decision is only possible via
+  *drop* verdicts (respectively verdict-like statements that imply *drop*, for
+  example *reject*).
+* A *jump* verdict causes the current position to be stored in the call stack of
+  chains and evaluation to continue at the beginning of the called regular
+  chain.
+  Called chains must be from the same table and cannot be base chains.
+  When the end of the called chain is reached, an implicit *return* verdict is
+  issued.
+  Other verdicts (respectively verdict-like statements) are processed as
+  described above and below.
+* A *goto* verdict is equal to *jump* except that the current position is not
+  stored in the call stack of chains.
+* A *return* verdict ends the evaluation of the current chain, pops the most
+  recently added position from the call stack of chains and causes evaluation to
+  continue after that position.
+  When there’s no position to pop (which is the case when the current chain is
+  either the base chain or a regular chain that was reached solely via *goto*
+  verdicts) it ends the evaluation of the current base chain (and any regular
+  chains called from it) using the base chain’s policy as implicit verdict.
+* Examples for *jump*/*goto*/*return*:
+  * 'base' {*jump*}→ 'regular-1' {*jump*}→ 'regular-2'
+    At the end of 'regular-2' or when a *return* is issued in that, evaluation
+    continues after the *jump* position in 'regular-1'.
+    At the end of 'regular-1' or when a *return* is issued in that, evaluation
+    continues after the *jump* position in 'base'.
+  * 'base' {*jump*}→ 'regular-1' {*goto*}→ 'regular-2'
+    At the end of 'regular-2' or when a *return* is issued in that, evaluation
+    continues after the *jump* position in 'base'.
+  * 'base' {*jump*}→ 'regular-1' {*jump*}→ 'regular-2' {*goto*}→ 'regular-3'
+    At the end of 'regular-3' or when a *return* is issued in that, evaluation
+    continues after the *jump* position in 'regular-1'.
+    At the end of 'regular-1' or when a *return* is issued in that, evaluation
+    continues after the *jump* position in 'base'.
+  * 'base' {*jump*}→ 'regular-1' {*goto*}→ 'regular-2' {*goto*}→ 'regular-3'
+    At the end of 'regular-3' or when a *return* is issued in that, evaluation
+    continues after the *jump* position in 'base'.
+* Verdicts (that is: *accept*, *drop*, *jump*, *goto*, *return*, *continue* and
+  *queue*) as well as statements that imply a verdict (like *reject* or the NAT
+  statements) also end the evaluation of any later statements in their
+  respective rules (respectively cause an error when loading such rules).
+  For example in `… counter accept` the `counter` statement is processed, but in
+  `… accept counter` it is not.
+  This does not apply to the `comment` statement, which is always evaluated.
+
 SETS
 ----
 nftables offers two kinds of set concepts. Anonymous sets are sets that have no
-- 
2.51.0

