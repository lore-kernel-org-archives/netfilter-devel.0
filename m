Received: from rusty.tulip.relay.mailchannels.net (rusty.tulip.relay.mailchannels.net [23.83.218.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2344DF72
	for <netfilter-devel@vger.kernel.org>; Sat, 11 Oct 2025 00:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.218.252
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760142588; cv=pass; b=HS8ddHdyjzUq61af4nQ/PnC8nkeufa3UccD83UTeUi2u0BPx3SsmQYbuux6Mn4ngilZbQIposLg3/J7BqqtZLrtVAxe5D2Aiif6YGHQ7PPuU+o7lRfKYeYzlyWDzWwl0AeMGqbfhZDA/kq8MhgAmXFNs5Do1n2BisJ9RE9ODvvg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760142588; c=relaxed/simple;
	bh=O32GVj3tDxhaiSxXujNb798Lwd+7XdalKkpxhRt21PI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JMe6iyJiI51A3QrpluhHRRryZFNdt8Tak08C+60LjfrMNZiHaQSWH4WtZZ/G+7CbajpR2eUQqvFnO+Bl08RfSMa0E5AkWjMWh/SHriNDcreA3WokO0b0zRik/rm1cM5JQOyHPadfprDc6chx1krjFp96IeXJzxhi2uvFK6mumnY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=christoph.anton.mitterer.name; spf=pass smtp.mailfrom=scientia.org; arc=pass smtp.client-ip=23.83.218.252
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=christoph.anton.mitterer.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=scientia.org
X-Sender-Id: instrampxe0y3a|x-authuser|calestyo@scientia.org
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id E84C9101C91;
	Sat, 11 Oct 2025 00:29:40 +0000 (UTC)
Received: from cpanel-007-fra.hostingww.com (trex-green-3.trex.outbound.svc.cluster.local [100.117.100.205])
	(Authenticated sender: instrampxe0y3a)
	by relay.mailchannels.net (Postfix) with ESMTPA id 13B42100F79;
	Sat, 11 Oct 2025 00:29:35 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1760142576; a=rsa-sha256;
	cv=none;
	b=J/BMJqm+qXrwOd+2WdY5GLup2/d+Gim5FQfOe/uUfnp7ad+SyqmHFmwIL/QZzSca6djrLx
	dntvXtMWg8Ayr2U8I58E9mvxkLQNbYmIZ2MK8lmAPzIHQlfZ6TgydPdCUzJ1HvKx16bQ2g
	M0s+dZmmGuBqWY/ynMI4hNrsxUwOBZyuPlGSCYI27ocLR7vO98aSmKCtTqMrUA6qSPpCwM
	MU6N95AhJc8dSdySA86ffSXuYOWx8XDWBLc/ndsLP7uoWyMyJDVfKywSTPUIMMOSI1/+tg
	1MxFFTVkRsTCn49KYqqK1pKGNd4cPVQ27VCHACn8dX36NFrKAl0iNg5zJa+ltQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1760142576;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MjdQpoLegvg8cbtvVvoFGKuSDqTDDBq1NSLir/FoPVw=;
	b=JxFx2ecg9riQoThZjN+s8/3TtLRYfZBxblltok4MPIOy57PUz3fPzv1bfmyzf/d5PzE9uC
	zT1RPm44rvTfmdUGDo4KqaOaQYxmBt57Gu9nQfJJZCVt6Vz6qDjw5/JiSQ9IFv3eWetDr7
	yoYEC+5AkGnUNFubfyhmlyRMFXQqwPBKziD3j82rL8Gjrcd5c09uaEsTeDjNnYNoc4vHt/
	OzaWgA6VGz8GN7ZdoksRAoCtpwTeowbyX+xx2ah7sNEOk80pdo9l13fXfAIenqcOXCoyR+
	Aqa6JcSTKN394rkZ+XA/gTs8XisO2r1hIB3mWngysYbpdlS3GS9FEzUN/AbHqg==
ARC-Authentication-Results: i=1;
	rspamd-668c7f7ff9-dj9kz;
	auth=pass smtp.auth=instrampxe0y3a smtp.mailfrom=calestyo@scientia.org
X-Sender-Id: instrampxe0y3a|x-authuser|calestyo@scientia.org
X-MC-Relay: Neutral
X-MC-Copy: stored-urls
X-MailChannels-SenderId: instrampxe0y3a|x-authuser|calestyo@scientia.org
X-MailChannels-Auth-Id: instrampxe0y3a
X-Decisive-Cold: 44992b980f6ff731_1760142580848_3578015451
X-MC-Loop-Signature: 1760142580848:3091309250
X-MC-Ingress-Time: 1760142580847
Received: from cpanel-007-fra.hostingww.com (cpanel-007-fra.hostingww.com
 [3.69.87.180])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.117.100.205 (trex/7.1.3);
	Sat, 11 Oct 2025 00:29:40 +0000
Received: from [212.104.214.84] (port=50315 helo=heisenberg.scientia.org)
	by cpanel-007-fra.hostingww.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <calestyo@scientia.org>)
	id 1v7NUO-00000009but-0oqp;
	Sat, 11 Oct 2025 00:29:34 +0000
Received: by heisenberg.scientia.org (Postfix, from userid 1000)
	id 8E5E858D12C8; Sat, 11 Oct 2025 02:29:32 +0200 (CEST)
From: Christoph Anton Mitterer <mail@christoph.anton.mitterer.name>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de,
	pablo@netfilter.org
Subject: [PATCH v2 2/7] doc: fix/improve documentation of verdicts
Date: Sat, 11 Oct 2025 02:23:58 +0200
Message-ID: <20251011002928.262644-3-mail@christoph.anton.mitterer.name>
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

- Clarify that a terminating statement also prevents the execution of later
  statements in the same rule and give an example about that.
- Correct that `accept` won’t terminate the evaluation of the ruleset (which is
  generally used for the whole set of all chains, rules, etc.) but only that of
  the current base chain (and any regular chains called from that).
  Indicate that `accept` only accepts the packet from the current base chain’s
  point of view.
  Clarify that not only chains of a later hook could still drop the packet, but
  also ones from the same hook if they have a higher priority.
- Overhaul the description of `jump`/`goto`/`return`.
  `jump` only explains what the statement causes from the point of view of the
  new chain (that is: not, how the returning works), which includes that an
  implicit `return` is issued at the end of the chain.
  `goto` is explained in reference to `jump`.
  `return` describes abstractly how the return position is determined and what
  happens if there’s no position to return to (but not for example where an
  implicit `return` is issued).
- Various other minor improvements/clarifications to wording.
- List and explain verdict-like statements like `reject` which internally imply
  `accept` or `drop`.
  Further explain that with respect to evaluation these behave like their
  respectively implied verdicts.

Link: https://lore.kernel.org/netfilter-devel/3c7ddca7029fa04baa2402d895f3a594a6480a3a.camel@scientia.org/T/#t
Signed-off-by: Christoph Anton Mitterer <mail@christoph.anton.mitterer.name>
---
 doc/statements.txt | 84 ++++++++++++++++++++++++++++++++--------------
 1 file changed, 58 insertions(+), 26 deletions(-)

diff --git a/doc/statements.txt b/doc/statements.txt
index 6226713b..f812dec8 100644
--- a/doc/statements.txt
+++ b/doc/statements.txt
@@ -1,6 +1,7 @@
-VERDICT STATEMENT
-~~~~~~~~~~~~~~~~~
-The verdict statement alters control flow in the ruleset and issues policy decisions for packets.
+VERDICT STATEMENTS
+~~~~~~~~~~~~~~~~~~
+The verdict statements alter control flow in the ruleset and issue policy
+decisions for packets.
 
 [verse]
 ____
@@ -10,40 +11,71 @@ ____
 'CHAIN' := 'chain_name' | *{* 'statement' ... *}*
 ____
 
-*accept* and *drop* are absolute verdicts -- they terminate ruleset evaluation immediately.
+*accept* and *drop* are absolute verdicts, which immediately terminate the
+evaluation of the current rule, i.e. even any later statements of the current
+rule won’t get executed.
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
+The packet may however still be dropped by either another chain with a higher
+priority of the same hook or any chain of a later hook.
+For example, an *accept* in a chain of the *forward* hook still allows one to
+*drop* (or *reject*, etc.) the packet in another *forward* hook base chain (and
+any regular chains called from it) that has a higher priority number as well as
+later in a chain of the *postrouting* hook.
+*drop*:: Terminate ruleset evaluation and drop the packet. This occurs
+instantly, no further chains of any hooks are evaluated and it is thus not
+possible to again accept the packet in a higher priority or later chain, as
+those are not evaluated anymore for the packet.
+*jump* 'CHAIN':: Store the current position in the call stack of chains and
+ continue evaluation at the first rule of 'CHAIN'.
+ When the end of 'CHAIN' is reached, an implicit *return* verdict is issued.
+ When an absolute verdict is issued (respectively implied by a verdict-like
+ statement) in 'CHAIN', evaluation terminates as described above.
+*goto* 'CHAIN':: Equal to *jump* except that the current position is not stored
+ in the call stack of chains.
+*return*:: End evaluation of the current chain, pop the most recently added
+ position from the call stack of chains and continue evaluation after that
+ position.
+ When there’s no position to pop (which is the case when the current chain is
+ either the base chain or a regular chain that was reached solely via *goto*
+ verdicts) end evaluation of the current base chain (and any regular chains
+ called from it) using the base chain’s policy as implicit verdict.
+*continue*:: Continue ruleset evaluation with the next rule. This
+ is the default behaviour in case a rule issues no verdict.
 *queue*:: Terminate ruleset evaluation and queue the packet to userspace.
 Userspace must provide a drop or accept verdict.  In case of accept, processing
 resumes with the next base chain hook, not the rule following the queue verdict.
-*continue*:: Continue ruleset evaluation with the next rule. This
- is the default behaviour in case a rule issues no verdict.
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
 
 An alternative to specifying the name of an existing, regular chain in 'CHAIN'
 is to specify an anonymous chain ad-hoc. Like with anonymous sets, it can't be
 referenced from another rule and will be removed along with the rule containing
 it.
 
+All the above applies analogously to statements that imply a verdict:
+*redirect*, *dnat*, *snat* and *masquerade* internally issue eventually an
+*accept* verdict.
+*reject* and *synproxy* internally issue eventually a *drop* verdict.
+These statements thus behave like their implied verdicts, but with side effects.
+
+For example, a *reject* also immediately terminates the evaluation of the
+current rule, overrules any *accept* from any other chains and can itself not be
+overruled, while the various NAT statements may be overruled by other *drop*
+verdicts respectively statements that imply this.
+
 .Using verdict statements
 -------------------
 # process packets from eth0 and the internal network in from_lan
-- 
2.51.0

