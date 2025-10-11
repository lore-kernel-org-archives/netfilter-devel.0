Received: from skyblue.cherry.relay.mailchannels.net (skyblue.cherry.relay.mailchannels.net [23.83.223.167])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3E4034BA54
	for <netfilter-devel@vger.kernel.org>; Sat, 11 Oct 2025 00:46:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.223.167
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760143608; cv=pass; b=AM54VMYA9FTCIohDFy9+caYO3JdFgw+GMIa6oWNb+zS+nIAOz5VVUB0CIBQCCefhGBK+ua1mpSdCgxGhNe7jrUdkFwqKi287u+ocGNTzhHQvz7F0TIMY+SxUhuIB96GQW6Mq4oT9jWnWkNvu1A1GZYhFm8SAaS4LB7NqH/IJPGw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760143608; c=relaxed/simple;
	bh=rd4LXJTY3Qp7KTyiwIi4+e4Ulq5P20JkLeJod+IWYR0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HbhZhWMG5F/qey/eFuVRbgrsmiDc5HeEMYkIpbf+Scsb0hhT4Dc2X+xEHITohrFXhpliyFQbIE0tdFQfVBmOZzmtvrYaxYqjG8ByXDdmr3JJiJ5kRnHqb76lqV6qacCr+g4KaI6dk9pFGnPMsfGuOm8/hKrM8Z1wA+wtEBLDUU0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=christoph.anton.mitterer.name; spf=pass smtp.mailfrom=scientia.org; arc=pass smtp.client-ip=23.83.223.167
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=christoph.anton.mitterer.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=scientia.org
X-Sender-Id: instrampxe0y3a|x-authuser|calestyo@scientia.org
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 032B93617F2;
	Sat, 11 Oct 2025 00:29:37 +0000 (UTC)
Received: from cpanel-007-fra.hostingww.com (100-117-100-204.trex-nlb.outbound.svc.cluster.local [100.117.100.204])
	(Authenticated sender: instrampxe0y3a)
	by relay.mailchannels.net (Postfix) with ESMTPA id 3A2B436102D;
	Sat, 11 Oct 2025 00:29:36 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1760142576; a=rsa-sha256;
	cv=none;
	b=NVPRaLSbPVRU1umRyZ/iF7qdtEqNeCqun3i1cBU/GQUeT/cZ8sucvLwdq/bc9xaH2dQyNS
	XLqhfH4EyaOvvmQWS5R8SQyhyCWKlNS1CkcgFUnJ/d/qjGekK17NNRpTKS0OZ8+JhH3/k3
	LaW5/OIavJwVQpvZE3yxu/ALab3CL3iUtKb4UPBLTLobmN8XLgBKbiD/yqHKYd58/kuMhy
	nU20lccRAwcWvPk2+fUJhK3QyBz7IC3q8DeRkC/laCGmQb8UVInYfKsyjJY2pB84agBm7h
	CqKehdzy+5hnsvmieCIwwlAkLftMcdKc2akwMlk4ZvBFuZ9oVy/ncC4V+2prUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1760142576;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6vd3uMgl4cCzjlYFlzJDgMS8vZVTy8neyCMLhyWacp8=;
	b=wXXH5MflPmhYbw3qd7f5bmj5VBFu3CDlHngc23mQXuR4lx3KN2ZHA4DoAbzYwO4ILkDHpp
	O0vmoUOKWyM+hHcDG3fii+nWSJMcUw2cRg4KG2NTepb7Fr3fvFoDt+YbZo9OoLJCRD+6ex
	DRt23ICiuD22W9nohAh5h84L4jufxNs5gv48MTWhps4j2NhXKnxoVkXyH76cM0GbVs+FTQ
	XKoihicEUhzxhZOIxfvbz0cjbBm1GPMlhcc7Q6CrsWRprQNVSyu4mTQdtXxVmCKyWOJBbd
	LQxqn+G6g9tJ9lqsSHrZJGsJzXmQUkeqO1Ws2xDf+zeRRgZiTKeVhgqcO5ILGQ==
ARC-Authentication-Results: i=1;
	rspamd-668c7f7ff9-vrr96;
	auth=pass smtp.auth=instrampxe0y3a smtp.mailfrom=calestyo@scientia.org
X-Sender-Id: instrampxe0y3a|x-authuser|calestyo@scientia.org
X-MC-Relay: Neutral
X-MC-Copy: stored-urls
X-MailChannels-SenderId: instrampxe0y3a|x-authuser|calestyo@scientia.org
X-MailChannels-Auth-Id: instrampxe0y3a
X-Eyes-Soft: 0970604f0faf1c25_1760142576914_4134271430
X-MC-Loop-Signature: 1760142576914:2874122836
X-MC-Ingress-Time: 1760142576914
Received: from cpanel-007-fra.hostingww.com (cpanel-007-fra.hostingww.com
 [3.69.87.180])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.117.100.204 (trex/7.1.3);
	Sat, 11 Oct 2025 00:29:36 +0000
Received: from [212.104.214.84] (port=47652 helo=heisenberg.scientia.org)
	by cpanel-007-fra.hostingww.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <calestyo@scientia.org>)
	id 1v7NUO-00000009buv-15tc;
	Sat, 11 Oct 2025 00:29:34 +0000
Received: by heisenberg.scientia.org (Postfix, from userid 1000)
	id 97D9C58D12CC; Sat, 11 Oct 2025 02:29:32 +0200 (CEST)
From: Christoph Anton Mitterer <mail@christoph.anton.mitterer.name>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de,
	pablo@netfilter.org
Subject: [PATCH v2 4/7] doc: add overall description of the ruleset evaluation
Date: Sat, 11 Oct 2025 02:24:00 +0200
Message-ID: <20251011002928.262644-5-mail@christoph.anton.mitterer.name>
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

Signed-off-by: Christoph Anton Mitterer <mail@christoph.anton.mitterer.name>
---
 doc/nft.txt | 102 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 102 insertions(+)

diff --git a/doc/nft.txt b/doc/nft.txt
index a32fb10c..20c63f98 100644
--- a/doc/nft.txt
+++ b/doc/nft.txt
@@ -560,6 +560,108 @@ table inet filter {
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

