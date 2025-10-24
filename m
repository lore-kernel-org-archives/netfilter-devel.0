Received: from purple.birch.relay.mailchannels.net (purple.birch.relay.mailchannels.net [23.83.209.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 363FE19ABDE
	for <netfilter-devel@vger.kernel.org>; Fri, 24 Oct 2025 01:40:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.209.150
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761270026; cv=pass; b=RQjcP9VFzjK53ybYFLAE9g7SU/pkoS1voBn2CzjwSpkqRh+btPjAZQ60dBUr6Lxm/gOkVHNls3/+iJWIx9wc1hC3GwONzqBwKpkU9F0qnWPv/QOz+lSyCF+3ZKbrn7IrroLBkAaXZEg6ZRUI8XtwwMUcJBFpz4CfimoeChA80tU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761270026; c=relaxed/simple;
	bh=lILjckrVFOTEFTXS5DqaDvyjuY9WmyqoN7z1RgmpUJw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=an1jVrlsOrfnPsMFc+1pZcX2XWOATVyFmflZCczA5csICYt5QsnwTZ/Bxs9jZdFitTTMh3XWMyqluGO+M56D6ThsqfJsCH20WocAz4VdPKtYA9i4d4RynfH5Xa6P0dI/zKgMSY2zmcvuFt2pc06+bU0ipaj99O4eU740skZXKhM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=christoph.anton.mitterer.name; spf=pass smtp.mailfrom=scientia.org; arc=pass smtp.client-ip=23.83.209.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=christoph.anton.mitterer.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=scientia.org
X-Sender-Id: instrampxe0y3a|x-authuser|calestyo@scientia.org
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id A344F6A17D2;
	Fri, 24 Oct 2025 01:40:17 +0000 (UTC)
Received: from cpanel-007-fra.hostingww.com (trex-green-0.trex.outbound.svc.cluster.local [100.116.233.191])
	(Authenticated sender: instrampxe0y3a)
	by relay.mailchannels.net (Postfix) with ESMTPA id 9DCCA6A1D12;
	Fri, 24 Oct 2025 01:40:16 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1761270017; a=rsa-sha256;
	cv=none;
	b=4NU1jzGrzUvJUBlPYxx++1bxLpH9/W9oZX9mn3foFWMXi450mqWQUoBiyLaiNlGOSnAmXZ
	JwX3e2bGC0TmpiEe1Yxt7muS1DQ3bz2oojNGhGEtljmXFZ663JfGxnOwsPnpDDbxRJTVSz
	LnOG1wEoO+BwzTxQTuSxDEBvlxhDLVlIRXFVR/BPGg1W7f9CmxjwprQawCoFXIEnBw6DDH
	cOKvppi3Ua1lkv/LJhdHG8V9r6WiF2S6iDdC+YkicwvwOeuGlnLdvm6StAhkK3fVR+wVk7
	qvwPkPcuu64vPNzJFECb0FwY6006sSJl+lrjrOKfZCv1fYo/BkE0G2xAIXFHag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1761270017;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5kgiq0Yur0otGWmA+iIKwGPdgQBexfoMwqD5YPh1QPY=;
	b=EIh0GuEBxm8S3kQetuszdFiHZTwBWNUYLTCtDP1MjaOV0oMFeOyo1NMKlpVY69jCd8QGA6
	cxU+O0kqKH0LlgxoMlNFaFNVCw4XxrTCpF0ENDpFysbJ2WFZUkkme+T5YKb4zbwooiE8M0
	s0iZ0dQgrdK6WFwC8HInsA2BHzGU1aqFvy5fyqnYxwzly7OzaPKn88PpxafDlttahcY5Za
	IHxcsxWSrdMHP8mfvSNJczE/ItTeGoNNDsC28NMfX30GHDhDsq2QcJ4fGuH95O/PHzN+uu
	4+hSXggKpNeWscr+pv3mZaAE1tErLvlY1WJLtUK0+QZCzlmLNxI2lKytTawy9g==
ARC-Authentication-Results: i=1;
	rspamd-9799b5d46-2tpxf;
	auth=pass smtp.auth=instrampxe0y3a smtp.mailfrom=calestyo@scientia.org
X-Sender-Id: instrampxe0y3a|x-authuser|calestyo@scientia.org
X-MC-Relay: Neutral
X-MC-Copy: stored-urls
X-MailChannels-SenderId: instrampxe0y3a|x-authuser|calestyo@scientia.org
X-MailChannels-Auth-Id: instrampxe0y3a
X-Dime-Dime: 21101fcf40d3ec99_1761270017472_2756650461
X-MC-Loop-Signature: 1761270017472:1548194809
X-MC-Ingress-Time: 1761270017471
Received: from cpanel-007-fra.hostingww.com (cpanel-007-fra.hostingww.com
 [3.69.87.180])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.116.233.191 (trex/7.1.3);
	Fri, 24 Oct 2025 01:40:17 +0000
Received: from [212.104.214.84] (port=11133 helo=heisenberg.scientia.org)
	by cpanel-007-fra.hostingww.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <calestyo@scientia.org>)
	id 1vC6mu-0000000FiJ5-36tW;
	Fri, 24 Oct 2025 01:40:15 +0000
Received: by heisenberg.scientia.org (Postfix, from userid 1000)
	id 2A2D15AA52F2; Fri, 24 Oct 2025 03:40:13 +0200 (CEST)
From: Christoph Anton Mitterer <mail@christoph.anton.mitterer.name>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org,
	fw@strlen.de
Subject: [PATCH v5 1/4] doc: fix/improve documentation of verdicts
Date: Fri, 24 Oct 2025 03:36:45 +0200
Message-ID: <20251024014010.994513-2-mail@christoph.anton.mitterer.name>
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
 doc/statements.txt | 86 +++++++++++++++++++++++++++++++---------------
 1 file changed, 59 insertions(+), 27 deletions(-)

diff --git a/doc/statements.txt b/doc/statements.txt
index e275ee39..e1d8552c 100644
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
-*queue*:: Terminate ruleset evaluation and queue the packet to userspace.
-Userspace must provide a drop or accept verdict.  In case of accept, processing
-resumes with the next base chain hook, not the rule following the queue verdict.
+*accept*:: Terminate the evaluation of the current chain as well as any chains
+ in the call stack and accept the packet with respect to the base chain of
+ these.
+ Evaluation continues in the next base chain (of higher or possibly equal
+ priority from the same hook or of any priority from a later hook), if any.
+ This means the packet can still be dropped in any next base chain as well as
+ any regular chain (directly or indirectly) called from it.
+ For example, an *accept* in a chain of the *forward* hook still allows one to
+ *drop* (or *reject*, etc.) the packet in another *forward* hook base chain (and
+ any regular chains called from it) that has a higher priority number as well as
+ later in a chain of the *postrouting* hook.
+*drop*:: Immediately drop the packet and terminate ruleset evaluation.
+ This means no further evaluation of any chains and it’s thus – unlike with
+ *accept* – not possible to again change the ultimate fate of the packet in any
+ later chain.
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
 *continue*:: Continue evaluation with the next rule. This
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
+*queue*:: Terminate ruleset evaluation and queue the packet to userspace.
+ Userspace must provide a drop or accept verdict.  In case of accept, processing
+ resumes with the next base chain hook, not the rule following the queue
+ verdict.
 
 An alternative to specifying the name of an existing, regular chain in 'CHAIN'
 is to specify an anonymous chain ad-hoc. Like with anonymous sets, it can't be
 referenced from another rule and will be removed along with the rule containing
 it.
 
+All the above applies analogously to statements that imply a verdict:
+*redirect*, *dnat*, *snat* and *masquerade* internally issue an *accept*
+verdict at the end of their respective actions.
+*reject* and *synproxy* internally issue a *drop* verdict at the end of their
+respective actions.
+These statements thus behave like their implied verdicts, but with side effects.
+
 .Using verdict statements
 -------------------
 # process packets from eth0 and the internal network in from_lan
-- 
2.51.0

