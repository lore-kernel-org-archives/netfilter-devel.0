Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DAC56F073
	for <netfilter-devel@vger.kernel.org>; Wed,  4 Jun 2025 17:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749059800; cv=none; b=br4xH6BEyXGfxCHKfQgxjZsFKxNuvAyO0ZZRRWoq+bUfdbuflm2M67Vg4yXpHzlQ9A5/B+AQbG7j9S5gKx8zkYlFakZz/P7Cqn2TK+EWg++FnNZz5RN4dWvgE/hE1EJf7uI8f2KLNHPWNfBGD2zqiDMIY8B6t0nn03JYC0GBM+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749059800; c=relaxed/simple;
	bh=gF6m/cKFBlaG/QCnlD9grzkRSTBV88kzWbQKHDtxF9I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NVt+4+ewQTwYqHvcR7WjPKFglFWYZ8Vf+3EqoKu72PZHbItHpnKnYGGnVx2vSbPa/I2qlZpNgOBFzRBV1OH8pWjfQVqBX5PWLE3RncbjdDMkLkWReLOVGC3QAnA6P+a7c6JjnviOwnAO3czA3sCo5pyuPTGRrvkuiXREtmteXzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=Z4oscy4T; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="Z4oscy4T"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=wAL8Nd7lmbSqpNoN5Cr8oOynvPbw7fd6HhAAVXwBrDs=; b=Z4oscy4TrUjpJ1iFMGi8MpYxBU
	pjM2r4tHAny1kEsVMI1fa+/2BPo1iY8jc2QowMSdKXfc8ke9cvwUc3s9n203bZXggFcfm+oHsEqFu
	DbHZu+tAkKt1j09g5KV+ox3aHdBtxdjQq3tSpNHbK+UQMTxxWk1xOkmlC2i7aoHbMIRoDXMIVKHZa
	DH5Rm3Xc0GVYQ3cWzd4gyOhxsF7lLWxG6t9tZtAy9a/0MYDo7RgH12XpeSt4uaX/9VXwutt7HZnP8
	GhpRMHHzcln/27FLLPbDvYhbR3BTf9MZPy2wFTFLGQ9bIAbfLuQTGY2O7WDEXIpukpVs9knGNxZSZ
	JA+19S0w==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uMsLq-000000006oZ-0JB4;
	Wed, 04 Jun 2025 19:56:34 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Folsk Pratima <folsk0pratima@cock.li>
Subject: [nft PATCH] doc: Basic documentation of anonymous chains
Date: Wed,  4 Jun 2025 19:56:28 +0200
Message-ID: <20250604175628.19062-1-phil@nwl.cc>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Joint work with Folsk Pratima.

Signed-off-by: Folsk Pratima <folsk0pratima@cock.li>
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 doc/nft.txt        |  3 ++-
 doc/statements.txt | 19 ++++++++++++++++---
 2 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/doc/nft.txt b/doc/nft.txt
index c1bb49970a223..1be2fbac05c1d 100644
--- a/doc/nft.txt
+++ b/doc/nft.txt
@@ -397,7 +397,8 @@ CHAINS
 Chains are containers for rules. They exist in two kinds, base chains and
 regular chains. A base chain is an entry point for packets from the networking
 stack, a regular chain may be used as jump target and is used for better rule
-organization.
+organization. Regular chains can be anonymous, see *VERDICT STATEMENT* examples
+for details.
 
 [horizontal]
 *add*:: Add a new chain in the specified table. When a hook and priority value
diff --git a/doc/statements.txt b/doc/statements.txt
index 79a01384660f6..f9460dd7fa77f 100644
--- a/doc/statements.txt
+++ b/doc/statements.txt
@@ -3,8 +3,12 @@ VERDICT STATEMENT
 The verdict statement alters control flow in the ruleset and issues policy decisions for packets.
 
 [verse]
+____
 {*accept* | *drop* | *queue* | *continue* | *return*}
-{*jump* | *goto*} 'chain'
+{*jump* | *goto*} 'CHAIN'
+
+'CHAIN' := 'chain_name' | *{* 'statement' ... *}*
+____
 
 *accept* and *drop* are absolute verdicts -- they terminate ruleset evaluation immediately.
 
@@ -26,15 +30,20 @@ resumes with the next base chain hook, not the rule following the queue verdict.
 *return*:: Return from the current chain and continue evaluation at the
  next rule in the last chain. If issued in a base chain, it is equivalent to the
  base chain policy.
-*jump* 'chain':: Continue evaluation at the first rule in 'chain'. The current
+*jump* 'CHAIN':: Continue evaluation at the first rule in 'CHAIN'. The current
  position in the ruleset is pushed to a call stack and evaluation will continue
  there when the new chain is entirely evaluated or a *return* verdict is issued.
  In case an absolute verdict is issued by a rule in the chain, ruleset evaluation
  terminates immediately and the specific action is taken.
-*goto* 'chain':: Similar to *jump*, but the current position is not pushed to the
+*goto* 'CHAIN':: Similar to *jump*, but the current position is not pushed to the
  call stack, meaning that after the new chain evaluation will continue at the last
  chain instead of the one containing the goto statement.
 
+An alternative to specifying the name of an existing, regular chain in 'CHAIN'
+is to specify an anonymous chain ad-hoc. Like with anonymous sets, it can't be
+referenced from another rule and will be removed along with the rule containing
+it.
+
 .Using verdict statements
 -------------------
 # process packets from eth0 and the internal network in from_lan
@@ -42,6 +51,10 @@ resumes with the next base chain hook, not the rule following the queue verdict.
 
 filter input iif eth0 ip saddr 192.168.0.0/24 jump from_lan
 filter input iif eth0 drop
+
+# jump and goto statements support anonymous chain creation
+filter input iif eth0 jump { ip saddr 192.168.0.0/24 drop ; udp dport domain drop; }
+
 -------------------
 
 PAYLOAD STATEMENT
-- 
2.49.0

