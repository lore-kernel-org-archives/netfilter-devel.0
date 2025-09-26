Received: from crimson.pear.relay.mailchannels.net (crimson.pear.relay.mailchannels.net [23.83.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FB4538DE1
	for <netfilter-devel@vger.kernel.org>; Fri, 26 Sep 2025 02:21:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.216.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758853283; cv=pass; b=ZhpTnxW1AcYKDaRHqr6ts0pZBHdbr/oe9O0XYmf5ImH/EVMqyWr1ete9Q0y5o4MAj+9q8Hlao5bf84RnwvxTQ3gZNcU8/vYjjjXZx/kaji84PPfcppqW1F3cGa0LA279PTX1WDSg5e0oYsWZAkfJzQflX2ld+lSx7G8jcNftjjE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758853283; c=relaxed/simple;
	bh=Zc9vYvTzJWbBQCQeuO+/Fw3Po4hEQ1EWYnA8ODHDR4k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=X0xslNem9jQdjuP/Tksxwyexrye0cqnbbFkCCKAgEA6BlaHnTXwPku1W7Hn4ZF+i7M60ahdW5LGNk9xGgNhRwROZAn4iqMSEOqRiWMZdVM7Obx9HcpdOYQ0iw8FCsaUHdNoABtyU7htCwJeJwAWeQZUDc7ghe9bggWZgX+oi7xw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=christoph.anton.mitterer.name; spf=pass smtp.mailfrom=scientia.org; arc=pass smtp.client-ip=23.83.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=christoph.anton.mitterer.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=scientia.org
X-Sender-Id: instrampxe0y3a|x-authuser|calestyo@scientia.org
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id A2D9B941504;
	Fri, 26 Sep 2025 02:11:48 +0000 (UTC)
Received: from cpanel-007-fra.hostingww.com (100-108-145-58.trex-nlb.outbound.svc.cluster.local [100.108.145.58])
	(Authenticated sender: instrampxe0y3a)
	by relay.mailchannels.net (Postfix) with ESMTPA id D581A9410DD;
	Fri, 26 Sep 2025 02:11:47 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1758852708; a=rsa-sha256;
	cv=none;
	b=SW82Uje2SE4PxW/JIDpG5hoS0x0xJj+IyK/EeGU5vMYV2Zm+8mH0u8yEM5s0KSABoFE/SE
	3kalq8+1Hpp1Vp9+3jrJvY9yDfHClJd7uyQFoyXPb2bPJgpOhTvpfp+TjoR+CXsBbXNcPG
	/3Ep2hGeVbkFn8PKgg0wYvOojoK3l47pcHzjwVL1G0ZjvEzvAoy9oAssVx+IBuv4/i9ABS
	2CzEPpQ+VvsQfBRipJqiOurpJ3Sic6R6XoFJxjnI6158hCFkJ15+Ia2yRDr6e7dg6Rokev
	CmDOtgRzaq35smcnMP6yaLKYYItN4mYq/rMco8RTLIzKpAz9/iTVsyF8C09wKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1758852708;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oHsHE9KCU3uS5+wyh4vHa9XjAmcrCTTtlrvQ9CkuXxI=;
	b=szSB9uBuTQY9vCmiYZrmoZS57XS6TThtvXMmd7EC7IJXL8CpQOIxdUlrLiuctDGbAmaRqe
	4ts+tNLL/BeLYkvIOV/oKLGHmPhavUtBvVE9Fed0HHmnr0C2jF4Kx4ecVWbhBHeNKNQeXV
	nmdglZx9Axf/3U9h+MxSb/pwgUuw8KlHgeSyXhfZkH6sj7tWd852SuWW25cxSX4GvnWBg/
	UfJbrOnOH5TYjvthH9zv5ciBFZRWtuBcbqAKSwzlmN9M2MW0xELcKlvcypTWI+fAj6LCfZ
	V+3udiJAbdzCU9zyajlCj3t57mZpXZJ9rsLTFNWx8Y2zjIBF/2qjmkivHDpBdw==
ARC-Authentication-Results: i=1;
	rspamd-598fd7dc44-ptfnp;
	auth=pass smtp.auth=instrampxe0y3a smtp.mailfrom=calestyo@scientia.org
X-Sender-Id: instrampxe0y3a|x-authuser|calestyo@scientia.org
X-MC-Relay: Good
X-MC-Copy: stored-urls
X-MailChannels-SenderId: instrampxe0y3a|x-authuser|calestyo@scientia.org
X-MailChannels-Auth-Id: instrampxe0y3a
X-Obese-Chief: 3fa66b8173b3aac9_1758852708541_1330035266
X-MC-Loop-Signature: 1758852708541:32184936
X-MC-Ingress-Time: 1758852708540
Received: from cpanel-007-fra.hostingww.com (cpanel-007-fra.hostingww.com
 [3.69.87.180])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.108.145.58 (trex/7.1.3);
	Fri, 26 Sep 2025 02:11:48 +0000
Received: from [79.127.207.161] (port=42470 helo=heisenberg.scientia.org)
	by cpanel-007-fra.hostingww.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <calestyo@scientia.org>)
	id 1v1xw3-0000000CeCf-46TL;
	Fri, 26 Sep 2025 02:11:46 +0000
Received: by heisenberg.scientia.org (Postfix, from userid 1000)
	id 8E40D55FB512; Fri, 26 Sep 2025 04:11:44 +0200 (CEST)
From: Christoph Anton Mitterer <mail@christoph.anton.mitterer.name>
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 2/7] doc: fix/improve documentation of verdicts
Date: Fri, 26 Sep 2025 03:52:44 +0200
Message-ID: <20250926021136.757769-3-mail@christoph.anton.mitterer.name>
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

- Include that `reject` behaves like `drop` with respect to ending the
  evaluations of rules (causing later statements to be not executed) and the
  whole ruleset (preventing any further evaluation of any other base chains with
  higher priorities at the same hook or any at later hooks.
- Clarify that a terminating statement also prevents the execution of later
  statements in the same rule and give an example about that.
- Correct that `accept` won’t terminate ruleset (which is generally used for the
  whole set of all chains, rules, etc.) but only that of the current base chain
  respectively any regular ones called from that.
  Indicate that `accept` only accepts the packet from the current base chain’s
  point of view.
  Clarify that not only chains of a later hook could still drop the packet, but
  also ones from the same hook if they have a higher priority.
- With respect to `return`/`jump`/`goto`, remove the “call stack” which seems
  rather an implementation detail and simply mention that the calling position
  is remembered.
  Also don’t use the wording “last chain”, which seems ambiguous. If the called
  chain itself called another chain and evaluation just returned from that, that
  might be misunderstood as the (chronologically) “last” one. “Calling chain”
  should be clear.
  Also don’t use the wording “new chain” (the chain isn’t strictly speaking
  “new”) and some places where merely “chain” was used, with `'CHAIN'` as the
  symbol for the called chain.
- For `return`, more clearly differentiate between the types of chains and added
  the missing description of `return` in a regular chain called via `goto`.
- For `jump`/`goto`, clarify, that their called chains return when a `return`
  verdict is issued *in them* not just when any `return` verdict (for example in
  another sub-chain) is issued.
- For `goto`, I intentionally listed the cases when evaluation does not return
  to the calling case - because I guess it might actually do so, namely when the
  called chain itself explicitly jumps or go(to)es back.
- Various other minor improvements/clarifications to wording.

Link: https://lore.kernel.org/netfilter-devel/3c7ddca7029fa04baa2402d895f3a594a6480a3a.camel@scientia.org/T/#t
Signed-off-by: Christoph Anton Mitterer <mail@christoph.anton.mitterer.name>
---
 doc/statements.txt | 61 ++++++++++++++++++++++++++++++----------------
 1 file changed, 40 insertions(+), 21 deletions(-)

diff --git a/doc/statements.txt b/doc/statements.txt
index 6226713b..b085b3ab 100644
--- a/doc/statements.txt
+++ b/doc/statements.txt
@@ -10,34 +10,53 @@ ____
 'CHAIN' := 'chain_name' | *{* 'statement' ... *}*
 ____
 
-*accept* and *drop* are absolute verdicts -- they terminate ruleset evaluation immediately.
+*accept* and *drop*/*reject* are absolute verdicts, which immediately terminate
+the evaluation of the current rule, i.e. even any later statements of the
+current rule won’t get executed.
+
+.*counter* will get executed:
+------------------------------
+… counter accept
+------------------------------
+
+.*counter* won’t get executed:
+------------------------------
+… accept counter
+------------------------------
+
+Further:
 
 [horizontal]
-*accept*:: Terminate ruleset evaluation and accept the packet.
-The packet can still be dropped later by another hook, for instance accept
-in the forward hook still allows one to drop the packet later in the postrouting hook,
-or another forward base chain that has a higher priority number and is evaluated
-afterwards in the processing pipeline.
-*drop*:: Terminate ruleset evaluation and drop the packet.
-The drop occurs instantly, no further chains or hooks are evaluated.
-It is not possible to accept the packet in a later chain again, as those
-are not evaluated anymore for the packet.
+*accept*:: Terminate the evaluation of the current base chain (and any regular
+chains called from it) and accept the packet from their point of view.
+The packet may however still be dropped/rejected by another chain with a higher
+priority of the same hook or by any chain of a later hook.
+For example an accept in the forward hook still allows one to drop the packet
+later in the postrouting hook, or another forward base chain that has a higher
+priority number and is evaluated afterwards in the processing pipeline.
+*drop*/*reject*:: Terminate ruleset evaluation and drop/reject the packet. This
+occurs instantly, no further chains of any hooks are evaluated and it is thus
+not possible to again accept the packet in a later chain, as those are not
+evaluated anymore for the packet.
 *queue*:: Terminate ruleset evaluation and queue the packet to userspace.
 Userspace must provide a drop or accept verdict.  In case of accept, processing
 resumes with the next base chain hook, not the rule following the queue verdict.
 *continue*:: Continue ruleset evaluation with the next rule. This
  is the default behaviour in case a rule issues no verdict.
-*return*:: Return from the current chain and continue evaluation at the
- next rule in the last chain. If issued in a base chain, it is equivalent to the
- base chain policy.
-*jump* 'CHAIN':: Continue evaluation at the first rule in 'CHAIN'. The current
- position in the ruleset is pushed to a call stack and evaluation will continue
- there when the new chain is entirely evaluated or a *return* verdict is issued.
- In case an absolute verdict is issued by a rule in the chain, ruleset evaluation
- terminates immediately and the specific action is taken.
-*goto* 'CHAIN':: Similar to *jump*, but the current position is not pushed to the
- call stack, meaning that after the new chain evaluation will continue at the last
- chain instead of the one containing the goto statement.
+*return*:: In a regular chain that was called via *jump*, end evaluation of that
+ chain and return to the calling chain, continuing evaluation there at the rule
+ after the calling rule.
+ In a regular chain that was called via *goto* or in a base chain, the *return*
+ verdict is equivalent to the base chain’s policy.
+*jump* 'CHAIN':: Continue evaluation at the first rule of 'CHAIN'. The position
+ in the current chain is remembered and evaluation will continue there with the
+ next rule when 'CHAIN' is entirely evaluated or a *return* verdict is issued in
+ 'CHAIN' itself.
+ In case an absolute verdict is issued by a rule in 'CHAIN', evaluation
+ terminates as described above.
+*goto* 'CHAIN':: Similar to *jump*, but the position in the current chain is not
+ remembered and evaluation will neihter return at the current chain when 'CHAIN'
+ is entirely evaluated nor when a *return* verdict is issued in 'CHAIN' itself.
 
 An alternative to specifying the name of an existing, regular chain in 'CHAIN'
 is to specify an anonymous chain ad-hoc. Like with anonymous sets, it can't be
-- 
2.51.0

