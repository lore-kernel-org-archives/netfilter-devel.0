Received: from cross.elm.relay.mailchannels.net (cross.elm.relay.mailchannels.net [23.83.212.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52AFD246762
	for <netfilter-devel@vger.kernel.org>; Mon, 20 Oct 2025 23:51:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.212.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761004305; cv=pass; b=dqhGluW/oox1THZX1lEbS13FvLQwQ41lIIB7Gkux/iYwjbB+kGkOuaoNxu8i+Lfyd/zaJUKCMGFmbMv8rTxYo9DaHKVJmnwds0UOjFFh6lfwZvlu+tB05UbmqlV9I5TYXqbfx5MDeGfkOmXA/NvZ0zo8XmaDNnl883L4w7hMylc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761004305; c=relaxed/simple;
	bh=FUmhVntgeWVdZHLGy+WRQFys+seQhZ5BpAQLQGRy8jw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gJqiFNK2zVnJwy8dilTbr+FbDAzgUphjeqH1x3uigB3ubpx/jTcmbs+l+hxfm/Vtzi0V2o029RveNqxmly/bPU+Gir9arPAzHIXZWyllKLNfgvbCtLy6znCqHrmX5z+ZWwiBfHPqwvxqKlt3emwUpMWbViCybTKcJKclG8PpRGc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=christoph.anton.mitterer.name; spf=pass smtp.mailfrom=scientia.org; arc=pass smtp.client-ip=23.83.212.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=christoph.anton.mitterer.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=scientia.org
X-Sender-Id: instrampxe0y3a|x-authuser|calestyo@scientia.org
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 818A36A1725;
	Mon, 20 Oct 2025 23:51:36 +0000 (UTC)
Received: from cpanel-007-fra.hostingww.com (trex-green-6.trex.outbound.svc.cluster.local [100.116.230.204])
	(Authenticated sender: instrampxe0y3a)
	by relay.mailchannels.net (Postfix) with ESMTPA id B37626A2C17;
	Mon, 20 Oct 2025 23:51:35 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1761004296; a=rsa-sha256;
	cv=none;
	b=+J58NSUbGA8UIi93QomVROED7gH+19YMhUD12utoz/Z2ABxLDFQAbGcanAw7NPwbEu6Lga
	1bi2/PssLPZdKOmkmbhMMav8A2nSYi/p6qqF1yUs0IPcGvahv2FBCAzGdJsv0NsZ82gWID
	i4j1vTmPIW0NZ/ZV9V6uyavuwV93SJjru1FNEJeESqzs/nnu1pfe3s6w5MWT55BddIEQ6j
	rousbSeume3W6EWjGEnMpsXBtw/8FeQAToEoTo5itagcgPEIofNXDERxOBSVpBD/iOz74q
	+89nJPfArjg7lQ1u0UqyQ5kQbHgGBVTHyz6D4voZ392mI9uJw9IYOHTv/Xvfig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1761004296;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SdQahrE6PSjU4X5i3HBI2zBWXznldMQBPjXJ32vE3Gc=;
	b=h75WPDav8RAqIK4MRVd1JjOSx4+vY6TKc0dxoyR2qn8EXKcTxzW28TDIbY1H4aA1rHCTuV
	JmF76wHX78tpj/StMpd6NdpnvbtTMl0VHiFHRcX9+WlMCpsomdRxcFaQUEui9iBl83sOsR
	L6op2P28eZfVB98ErqvZrSIPh1WI+J7FH+FRbdhvXTq0y81whZDB7XX/gCSiAMo/rbVaLS
	yEzyOMsPmCRGX9LZIj/HUbdsP2epfJKADyj3cpbv09695ZfreM9nZDt3FNuYy0790xHxe2
	1/RjgB8rxZNPrQvaLrzm7YhriEyn5gsghsyZYBmcMnsBBAdPDDXGcfX0+KyuMA==
ARC-Authentication-Results: i=1;
	rspamd-869c579f6-rdvn2;
	auth=pass smtp.auth=instrampxe0y3a smtp.mailfrom=calestyo@scientia.org
X-Sender-Id: instrampxe0y3a|x-authuser|calestyo@scientia.org
X-MC-Relay: Neutral
X-MC-Copy: stored-urls
X-MailChannels-SenderId: instrampxe0y3a|x-authuser|calestyo@scientia.org
X-MailChannels-Auth-Id: instrampxe0y3a
X-Print-Thread: 2606b7843c7b29f1_1761004296408_2971459718
X-MC-Loop-Signature: 1761004296408:3237478334
X-MC-Ingress-Time: 1761004296408
Received: from cpanel-007-fra.hostingww.com (cpanel-007-fra.hostingww.com
 [3.69.87.180])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.116.230.204 (trex/7.1.3);
	Mon, 20 Oct 2025 23:51:36 +0000
Received: from [79.127.207.162] (port=20777 helo=heisenberg.scientia.org)
	by cpanel-007-fra.hostingww.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <calestyo@scientia.org>)
	id 1vAzf4-00000009coj-1NsJ;
	Mon, 20 Oct 2025 23:51:34 +0000
Received: by heisenberg.scientia.org (Postfix, from userid 1000)
	id 617105A29C25; Tue, 21 Oct 2025 01:51:32 +0200 (CEST)
From: Christoph Anton Mitterer <mail@christoph.anton.mitterer.name>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de,
	pablo@netfilter.org
Subject: [PATCH v4 2/5] doc: add overall description of the ruleset evaluation
Date: Tue, 21 Oct 2025 01:49:02 +0200
Message-ID: <20251020235130.361377-3-mail@christoph.anton.mitterer.name>
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
 doc/nft.txt | 101 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 101 insertions(+)

diff --git a/doc/nft.txt b/doc/nft.txt
index 2ca601b1..4cd3fa8e 100644
--- a/doc/nft.txt
+++ b/doc/nft.txt
@@ -572,6 +572,107 @@ table inet filter {
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
+  accepted if none of the chains of the relevant hooks issues a *drop* verdict
+  (be it explicitly or implicitly by policy or via a verdict-like statement that
+  implies *drop*, for example *reject*), which already means that there has to
+  be at least one *accept* verdict (be it explicitly or implicitly by policy).
+  All this applies analogously to verdict-like statements that imply *accept*,
+  for example the NAT statements.
+* A *drop* verdict (including an implict one via the base chain’s policy)
+  immediately ends the evaluation of the whole ruleset and ultimately drops the
+  packet.
+  Unlike with an *accept* verdict, no further chains of any hook and regardless
+  of their table get evaluated and it’s therefore not possible to have a *drop*
+  verdict changed to an *accept* in a later chain.
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

