Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1519F296BC9
	for <netfilter-devel@vger.kernel.org>; Tue, 28 Oct 2025 14:54:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761663292; cv=none; b=QlqXQ7AGINtKQB47mDH6KyJ1wBMske8i6Kte0mJgKcfFBgs1UId9vqLuCYwz1xnTYK3EN13XAvcnd96FSv1eJBUT3tzNha66bDnmb/eYErJUh838+CVkmk0letYBqAn1qp+TkHUIjb8QiC4wDK5ibCPaSBpjg1XKfodVunyx76c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761663292; c=relaxed/simple;
	bh=QQDR7vL06jwieZ8joi8V7yljkPVVly+6ijYTCsPe9Hg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pZQTzs/5DCffJIqmBdWgc+afw9qjg8PS9qSj59M5SmVh3GRPdIb3KLHnqsEUIodOdEsE2TpHWjRkvtvBCyy9ntd12W09qvJfAtxNkk88hNKXQZHctsF9OL0RT9WKxLZOLGBzpLNECSPFYVp98dRXgpvDYInoHUUUSvGk+V6ul58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 3879A61AF5; Tue, 28 Oct 2025 15:54:47 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: mail@christoph.anton.mitterer.name,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH nft v6 1/3] doc: add overall description of the ruleset evaluation
Date: Tue, 28 Oct 2025 15:54:27 +0100
Message-ID: <20251028145436.29415-2-fw@strlen.de>
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

Signed-off-by: Christoph Anton Mitterer <mail@christoph.anton.mitterer.name>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 doc/nft.txt | 91 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 91 insertions(+)

diff --git a/doc/nft.txt b/doc/nft.txt
index b4c889afb353..d30481677c4d 100644
--- a/doc/nft.txt
+++ b/doc/nft.txt
@@ -572,6 +572,97 @@ table inet filter {
 nft delete rule inet filter input handle 5
 -------------------------
 
+OVERALL EVALUATION OF THE RULESET
+---------------------------------
+This is a summary of how the ruleset is evaluated.
+
+* Even if a packet is accepted by the ruleset it may
+  still get discarded by other means, for example Linux generally ignores
+  various ICMP types and there are sysctl options like
+  `net.ipv{4,6}.conf.*.forwarding` or `net.ipv4.conf.*.rp_filter`.
+* Tables are merely a concept of nftables to structure the ruleset.
+  They are not relevant to the evaluation of the ruleset.
+* Packets traverse the network stack and at various hooks (see
+  <<ADDRESS_FAMILIES>> above for lists of hooks per address family) they’re
+  evaluated by any base chains attached to these hooks.
+* Base chains may call regular chains (via *jump* and *goto*).
+  Evaluation continues in the called chain.  Regular chains can call
+  other regular chains.
+  Chains residing in a different table cannot be called.
+* For each hook, the attached base chains are evaluated in order of their
+  priorities.
+  Chains with lower priority values are evaluated before those with higher ones.
+  The order of chains with the same priority value is undefined.
+* An *accept* verdict (including an implict one via the base chain’s policy)
+  ends the evaluation of the current base chain.
+  It is not relevant if the *accept* verdict is issued in the base chain itself
+  or a regular chain called from the base chain.
+  The packet advances to the next base chain.
+  Thus a packet is ultimately accepted if and only if no (matching) rule or base
+  chain policy issues a *drop* verdict.
+  All this applies to verdict-like statements that imply *accept*,
+  for example the NAT statements.
+* A *drop* verdict (including an implict one via the base chain’s policy)
+  immediately ends the evaluation of the whole ruleset.
+  No further chains of any hook are consulted.
+  It is therefore not possible to have a *drop*
+  verdict changed to an *accept* in a later chain.
+  Thus, if any base chain uses drop as its policy, the same base chain (or a
+  regular chain directly or indirectly called by it) must accept a packet or
+  all traffic will be blocked.
+  This also applies to other terminal statements that imply *drop*,
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
+* Verdicts (that is: *accept*, *drop*, *jump*, *goto*, *return* and *continue*)
+  as well as statements that imply a verdict (like *reject* or the NAT
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

