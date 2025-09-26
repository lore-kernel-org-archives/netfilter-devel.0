Received: from dormouse.yew.relay.mailchannels.net (dormouse.yew.relay.mailchannels.net [23.83.220.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 692671534EC
	for <netfilter-devel@vger.kernel.org>; Fri, 26 Sep 2025 02:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.220.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758852718; cv=pass; b=JQqeDxE0P++c1SwLVr1dOJtPv+jCyxe+W6MGZKG67VXWc78iJFBPJ4j5d3OIPurv96Y7gb0NQrKXuyI8oYBIIh/yru6VJaIUtG/sn2yQFa1h6zD75AsnzEXd6ZMVXTAaOyXhs/AM0o5a9WQv4oZDYLS23cYiG4GXLBsqaw1Z19c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758852718; c=relaxed/simple;
	bh=m6q5zVLE5rDOZ/nvPhTwHqjMTxyyr09x0NMQ3xY5W/w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EXQ6kJd6YkLQh+8URh9j3vNGxdAhtOC2jT+MU6+I4XW2Dw107GLAZgORErxBoZa+LKbIBZqYhc8PrUiqVlDpigWJ4hTCS5MuDjokdXYH3E2p99gtWe8XUgUIT2xjZVS+9luG/14Vj9q7BTx60Zo+soqfJ1zJPOWKfehJuI2+HyI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=christoph.anton.mitterer.name; spf=pass smtp.mailfrom=scientia.org; arc=pass smtp.client-ip=23.83.220.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=christoph.anton.mitterer.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=scientia.org
X-Sender-Id: instrampxe0y3a|x-authuser|calestyo@scientia.org
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 7D7C73A1499;
	Fri, 26 Sep 2025 02:11:48 +0000 (UTC)
Received: from cpanel-007-fra.hostingww.com (trex-blue-5.trex.outbound.svc.cluster.local [100.108.153.55])
	(Authenticated sender: instrampxe0y3a)
	by relay.mailchannels.net (Postfix) with ESMTPA id AA3D03A13FB;
	Fri, 26 Sep 2025 02:11:47 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1758852708; a=rsa-sha256;
	cv=none;
	b=fDArtZfNvDXOssQCGYRSouUM09zVO2JoKyOimHgU/YTl5oKZ/a1FFHXSFq1EsgO/wLY5sm
	kyrxLkc1mnFUoO8HDagiLaGusybGlnvm7cx5iPTVJWJQhHBNNGyv1+NhTRY/9RuQzlmDle
	QMKU1DSocNRD33PhHNXexA7ydnRDAFzt82iDZgRo0SnFqslIkuamB4teyEWJv2eiN8YWX4
	pkqEqKnOzHa+QKK3xsAfrhIDFQu2XUm8BYtd1Yu6J/RuCya84oNBKI5Klc0rJmvFgUmR4B
	OHxE7zYaGYvWTQkJUUMVizwibnPCJgFnGxv7VbI6ZmydowiGfgXf87GG2dvJRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1758852708;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FDHg07w3cvLvgXvSVC9mgakdxieJrNR+5jIqmp6mDlY=;
	b=gz90p93n0hUeGPHQUOer/SorbAMunicKt1gJG3yCgjeR1i8/VpyE0G7JIVJmRqd+ZKFw14
	N07sLPYuU/r997oJW0B1OR5Mt3w4hMRzp12vcVAS4zLksp0NvjEjwpZ0cjSLNOSw9PG31M
	xW51dXH+8OxiefpvDQEmdKO6TcMAMegw44Km/gYsXXcTx4BCith1DOopLVltudl/cHbrS3
	uJlmzeubCkFOzY58ejJIvngH/xr6H/N4zJRfvZEbv5rEmZkhUi2B+AoTa1YHrQTOKhUzg6
	wtXR94ePEzLBWieARwhIXNdsHAnfPF7vdQZOg52wD7q4J9r9LeKF6dRxMGAo6g==
ARC-Authentication-Results: i=1;
	rspamd-598fd7dc44-ckpjg;
	auth=pass smtp.auth=instrampxe0y3a smtp.mailfrom=calestyo@scientia.org
X-Sender-Id: instrampxe0y3a|x-authuser|calestyo@scientia.org
X-MC-Relay: Good
X-MC-Copy: stored-urls
X-MailChannels-SenderId: instrampxe0y3a|x-authuser|calestyo@scientia.org
X-MailChannels-Auth-Id: instrampxe0y3a
X-Sponge-Towering: 3127fdd06532a852_1758852708378_4217409511
X-MC-Loop-Signature: 1758852708378:375207601
X-MC-Ingress-Time: 1758852708378
Received: from cpanel-007-fra.hostingww.com (cpanel-007-fra.hostingww.com
 [3.69.87.180])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.108.153.55 (trex/7.1.3);
	Fri, 26 Sep 2025 02:11:48 +0000
Received: from [79.127.207.161] (port=18239 helo=heisenberg.scientia.org)
	by cpanel-007-fra.hostingww.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <calestyo@scientia.org>)
	id 1v1xw3-0000000CeCh-3lkG;
	Fri, 26 Sep 2025 02:11:46 +0000
Received: by heisenberg.scientia.org (Postfix, from userid 1000)
	id 974E755FB516; Fri, 26 Sep 2025 04:11:44 +0200 (CEST)
From: Christoph Anton Mitterer <mail@christoph.anton.mitterer.name>
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 4/7] doc: add overall description of the ruleset evaluation
Date: Fri, 26 Sep 2025 03:52:46 +0200
Message-ID: <20250926021136.757769-5-mail@christoph.anton.mitterer.name>
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

Signed-off-by: Christoph Anton Mitterer <mail@christoph.anton.mitterer.name>
---
 doc/nft.txt | 79 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 79 insertions(+)

diff --git a/doc/nft.txt b/doc/nft.txt
index f52b7fef..4bbb6b56 100644
--- a/doc/nft.txt
+++ b/doc/nft.txt
@@ -560,6 +560,85 @@ table inet filter {
 nft delete rule inet filter input handle 5
 -------------------------
 
+OVERALL EVALUATION OF THE RULESET
+---------------------------------
+This is a summary of how the ruleset is evaluated.
+
+* Even if a packet is accepted by the ruleset (and thus by netfilter), it may
+  still get discarded by other means, for example Linux generally ignores
+  various ICMP types and are sysctl options lik
+  `net.ipv{4,6}.conf.*.forwarding` or `net.ipv4.conf.*.rp_filter`.
+* With respect to the evaluation tables don’t matter at all and are not known by
+  netfilter.
+  They’re merely used to structure the ruleset.
+* Packets traverse the network stack and at various hooks they’re evaluated by
+  any base chains attached to these hooks.
+* Base chains may call regular chains and regular chains may call other regular
+  chains (via *jump* or *goto* verdicts), in which case evaluation continues in
+  the called chain.
+  Base chains themsevlves cannot be called and only chains of the same table can
+  be called.
+* For each hook, the attached chains are evaluated in order of their priorities
+  (with chains with lower priority values being evaluated before those with
+  higher values and the order of chains with the same value being undefined).
+* An *accept* verdict (including an implict one via the base chain’s policy,
+  even if caused in certain cases by a *return* verdict) ends the evaluation of
+  the current base chain and any regular chains called from that.
+  It accepts the packet only with respect to the current base chain, which does
+  not mean that the packet is ultimately accepted.
+  Any other base chain (or regular chain called by such) with a higher priority
+  of the same hook as well as any other base chain (or regular chain called by
+  such) of any later hook may still utlimately *deny*/*reject* the packet with
+  an according verdict (with consequences as described below for
+  *deny*/*reject*).
+  Thus and merely from netfilter’s point of view, a packet is only accepted if
+  none of the chains (regardless of their tables) that are attached to any of
+  the respectively relevant hooks issues a *deny*/*reject* verdict (be it
+  explicitly or implicitly by policy) and if there’s at least on *accept*
+  verdict (be it explicitly or implicitly by policy).
+  In that, the ordering	of the various base chains per hook via their priorities
+  matters (with respect to the packets utlimate fate) only in so far, if any of
+  then would modify the packet or its meta data and that has an influence on the
+  verdicts – if not, the ordering shouldn’t matter (except for performance).
+* A *drop*/*reject* verdict (including an implict one via the base chain’s
+  policy even if caused in certain cases by a *return* verdict) immediately ends
+  the evaluation of the whole ruleset and ultimately drops/rejects the packet.
+  Unlike with an *accept* verdict, no further chains of any hook and regardless
+  of their table get evaluated and it’s therefore not possible to have an
+  *drop*/*reject* verdict overturned.
+  Thus, if any base chain uses drop as it’s policy, the same base chain or any
+  regular chain directly or indirectly called by it must accept a packet or it
+  is ensured to be ultimately dropped by it.
+* A *jump* verdict causes evaluation to continue at the first rule of the
+  regular chain it calls. Called chains must be of the same table and cannot be
+  base chains.
+  If no other verdict is issued in the called chain and if all rules of that
+  have been evaluated, evaluation will continue with the next rule after the
+  calling rule of the calling chain.
+  That is, reaching the end of the called chain causes a “jump back to the
+  calling chain” respectively an implicit *return* verdict.
+  Other verdicts are processed as described above and below.
+* A *goto* verdict causes evaluation to continue at the first rule of the
+  regular chain it calls. Called chains must be of the same table and cannot be
+  base chains.
+  If no other verdict is issued in the called chain and if all rules of that
+  have been evaluated, evaluation of the current base chain and the regular
+  chains called by it end with an implicit verdict of the base chain’s policy.
+  That is, unlike with *jump*, reaching the end of the called chain does not
+  cause a “jump back to the calling chain”.
+  Other verdicts are processed as described above and below.
+* A *return* verdict’s processing depend upon in which chain it is issued.
+  In a regular chain that was called via *jump* it ends evaluation of that chain
+  and return to the calling chain as described above.
+  In a regular chain that was called via *goto* or in a base chain, the *return*
+  verdict is equivalent to the base chain’s policy.
+* All verdicts described above (that is: *accept*, *drop*, *reject*, *jump*,
+  *goto* and *return*) also end the evaluation of any later statements in their
+  respective rules (or even cause an error when loadin such rules) with the
+  exception of the `comment` statement.
+  That is, for example in `… counter accept` the `counter` statement is
+  processed, but in `… accept counter` it is not.
+
 SETS
 ----
 nftables offers two kinds of set concepts. Anonymous sets are sets that have no
-- 
2.51.0

