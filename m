Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FF0532A3E1
	for <netfilter-devel@vger.kernel.org>; Tue, 28 Oct 2025 14:54:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761663294; cv=none; b=jR0H9UpfseUMEgmsriknKeu5E+If5wPTO6IGsEMSCIhcjZyo5/Wrwx/Lw5W6wJLHnjem83YY06feEDm3Jud8GbgL9KTQfMtMdIYC8eHPwBpyB3U23FxyJiYo47H0LQpwuuWReddhJy330noxqr/LL5D6SPHB/cZONnlsYwDVjoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761663294; c=relaxed/simple;
	bh=4hdBWXJjXrZpWGSXItwQWrJCs0Zrh8BaYUSfPZGBiqA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uq0qrlEIInHb+m0098teMehu6PlQ9N2b3h2eq2PucueuiQ0GOokjLVDGCGJg1GQ0dy9KgaHC3lH4S4CG/qKFl6n7c/hk+gzFfo8Zc88wgY7CHHX4IYpEeJDiHfpqLY8gzGZexQa8E/hMsi4TX0TkTQY05ozrJ1afIfMdLUlNHTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 92DB461B21; Tue, 28 Oct 2025 15:54:51 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: mail@christoph.anton.mitterer.name,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH nft v6 2/3] doc: fix/improve documentation of verdicts
Date: Tue, 28 Oct 2025 15:54:28 +0100
Message-ID: <20251028145436.29415-3-fw@strlen.de>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251028145436.29415-1-fw@strlen.de>
References: <20251028145436.29415-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Christoph Anton Mitterer <mail@christoph.anton.mitterer.name>

- Clarify that a terminating statement also prevents the execution of later
  statements in the same rule and give an example about that.
- Correct that `accept` won’t terminate the evaluation of the ruleset (which is
  generally used for the whole set of all chains, rules, etc.) but only that of
  the current base chain (and any regular chains called from that).
  Indicate that `accept` only accepts the packet from the current base chain’s
  point of view.
  Clarify that not only chains of a later hook could still drop the packet, but
  also ones from the same hook if they have a higher priority.
- Various other minor improvements/clarifications to wording.

Link: https://lore.kernel.org/netfilter-devel/3c7ddca7029fa04baa2402d895f3a594a6480a3a.camel@scientia.org/T/#t
Signed-off-by: Christoph Anton Mitterer <mail@christoph.anton.mitterer.name>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 doc/nft.txt        |  1 +
 doc/statements.txt | 24 ++++++++++++++----------
 2 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/doc/nft.txt b/doc/nft.txt
index d30481677c4d..4615c3ead8be 100644
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
index 6f438c047b86..5d197aeb0cee 100644
--- a/doc/statements.txt
+++ b/doc/statements.txt
@@ -10,18 +10,22 @@ ____
 'CHAIN' := 'chain_name' | *{* 'statement' ... *}*
 ____
 
-*accept* and *drop* are absolute verdicts -- they terminate ruleset evaluation immediately.
+*accept* and *drop* are absolute verdicts -- they terminate chain evaluation,
+as if the packet would have reached the end of the base chain with the equivalent
+policy decision set.  See <<OVERALL_EVALUATION_OF_THE_RULESET>> for more details.
 
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
+*accept*:: Terminate evaluation early.
+ Evaluation continues in the next base chain of higher or possibly equal
+ priority from the same hook or in the first base chain of a later hook, if any.
+ This means the packet can still be dropped in another base chain as well as
+ any chain called from it.
+ For example, an *accept* verdict in a chain of the *forward* hook still allows one to
+ *drop* the packet in another *forward* hook base chain (or a user-defined chain called from it)
+ that has a higher priority number or in a chain attached to the *postrouting* hook.
+*drop*:: Immediately drop the packet and terminate ruleset evaluation.
+ No further evaluation takes place.  It is not possible to override a *drop*
+ verdict.
 *jump* 'CHAIN':: Store the current position in the call stack of chains and
  continue evaluation at the first rule of 'CHAIN'.
  When the end of 'CHAIN' is reached, an implicit *return* verdict is issued.
-- 
2.51.0

