Received: from duck.apple.relay.mailchannels.net (duck.apple.relay.mailchannels.net [23.83.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18B8D233704
	for <netfilter-devel@vger.kernel.org>; Fri, 26 Sep 2025 04:36:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.208.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758861376; cv=pass; b=EqJsdkqzUbEzuNemR55FkXm3BhtGZ2HJtmUJmp8eajPS4CDgyp+ehEXGxjshpy3hVxYrcU7MuvjdADesKU2zE3Mxp288GPAHTYAfYB9jOdzA3fSg+vVw7SORLx8p/EK3mP9EZUqqU87K0IkAzBiHEWG2hhT6J+kva7muuws53tg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758861376; c=relaxed/simple;
	bh=gJDFatKi1rl/8kAbvjBZYBBzGxckG+K3oUB1nvEXOBE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MDfBG0nSf2dUHCAHa15B9KQRpcxFbAME3QMWCwQZHcLeiMbIqqgohVUA1RZyWCBP5FM6PrJF42+BMq+cL0HaLtJRHrHL1bPWrZcp0GpNPRng7SMk+BVMfxoYxTMqFQkuhNJQxk8Taq8wE9ocY4+44HMLKppJSUuwliSqCJH3w0A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=christoph.anton.mitterer.name; spf=pass smtp.mailfrom=scientia.org; arc=pass smtp.client-ip=23.83.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=christoph.anton.mitterer.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=scientia.org
X-Sender-Id: instrampxe0y3a|x-authuser|calestyo@scientia.org
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id B86A71E1689;
	Fri, 26 Sep 2025 02:11:49 +0000 (UTC)
Received: from cpanel-007-fra.hostingww.com (100-108-153-55.trex-nlb.outbound.svc.cluster.local [100.108.153.55])
	(Authenticated sender: instrampxe0y3a)
	by relay.mailchannels.net (Postfix) with ESMTPA id EC9951E1695;
	Fri, 26 Sep 2025 02:11:48 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1758852709; a=rsa-sha256;
	cv=none;
	b=HbQldYRExu0KK0gYr91WIQTk4lM0+5ilid3eCZ9d+Ln3DCtHWj2KYZ335bFFgI9jp6HOB8
	OPRXABrfuSZWNCh/blsIeH9Mu+j+YdonqPG0s7GNAvZ62VAFLkPKAZ0dQSMn4XyDp8hzRW
	O9JJNAVQ8m1EbRGK9U7kXg9qL4FHz69DcLa3H/SobptBKt3GM7nLqLJqVF8IxxKxc2Bp5f
	3CCJFIuQ7zQiG6ja0doI5+d9Xn04GjiwuT5TxOJGEgTs3dAKtLm/SHB7t6AutnXud4qiNL
	ZYkcLdedflYeXcTxs/tIFmcRTF5wDJ94FSxZdIV0zGXvzTRfoxj3Msh8yTn9xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1758852709;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xA3b3OMvdMsD2MUNdh/MJIZjluKAd0Zuskj1DxsIfp8=;
	b=9/MUMHL4W69CIXnJbxfDhVTEtpNYflEfEadv/i9Sdj0yYpANMB39y3tRXR9rXNU3dX3lMu
	hm+ZUJUIf+z07qz+7Rj/ExRMwbss5RucAniDo4YIqLmcDDHstjEPPwRKt26ooZu8LjXdLv
	e1zRf7PHnpX0qSJODc1FM4DUdTrsN8iP2qmOY7r2AQSXQQ8C+m0fEMimgs033zpl7uuP05
	cz/cEKY2yC0uRxKU/T3BeakRlQf/s+AXephhemezfidW1rmSWEjwjQLZD1tjXW4c0YQ6rQ
	x16km+ducUSPU9VvaVakrYuE8iqIoJrlv1LI/ce8hVQ6SSYVCD2HDjm7wM83Qw==
ARC-Authentication-Results: i=1;
	rspamd-598fd7dc44-v4hsc;
	auth=pass smtp.auth=instrampxe0y3a smtp.mailfrom=calestyo@scientia.org
X-Sender-Id: instrampxe0y3a|x-authuser|calestyo@scientia.org
X-MC-Relay: Good
X-MC-Copy: stored-urls
X-MailChannels-SenderId: instrampxe0y3a|x-authuser|calestyo@scientia.org
X-MailChannels-Auth-Id: instrampxe0y3a
X-Vacuous-Towering: 7d5914ea78d46e20_1758852709638_1599912739
X-MC-Loop-Signature: 1758852709638:1319565011
X-MC-Ingress-Time: 1758852709638
Received: from cpanel-007-fra.hostingww.com (cpanel-007-fra.hostingww.com
 [3.69.87.180])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.108.153.55 (trex/7.1.3);
	Fri, 26 Sep 2025 02:11:49 +0000
Received: from [79.127.207.161] (port=47622 helo=heisenberg.scientia.org)
	by cpanel-007-fra.hostingww.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <calestyo@scientia.org>)
	id 1v1xw5-0000000CeDM-215z;
	Fri, 26 Sep 2025 02:11:47 +0000
Received: by heisenberg.scientia.org (Postfix, from userid 1000)
	id A4FEE55FB51D; Fri, 26 Sep 2025 04:11:44 +0200 (CEST)
From: Christoph Anton Mitterer <mail@christoph.anton.mitterer.name>
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 7/7] doc: describe how values match sets
Date: Fri, 26 Sep 2025 03:52:49 +0200
Message-ID: <20250926021136.757769-8-mail@christoph.anton.mitterer.name>
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
Content-Transfer-Encoding: 8bit
X-AuthUser: calestyo@scientia.org

Signed-off-by: Christoph Anton Mitterer <mail@christoph.anton.mitterer.name>
---
 doc/nft.txt | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/doc/nft.txt b/doc/nft.txt
index 899c38d6..7e75381d 100644
--- a/doc/nft.txt
+++ b/doc/nft.txt
@@ -741,6 +741,16 @@ Example: When the set contains range *1.2.3.1-1.2.3.4*, then adding element *1.2
 effect.  Adding *1.2.3.5* changes the existing range to cover *1.2.3.1-1.2.3.5*.
 Without this flag, *1.2.3.2* can not be added and *1.2.3.5* is inserted as a new entry.
 
+Equality of a value with a set is given if the value matches exactly one value
+in the set.
+It shall be noted that for bitmask values this means, that
+*'expression' 'bit'[,'bit']...* (which yields true if *any* of the bits are set)
+is not the same as *'expression' {'bit'[,'bit']...}* (which yields true if
+exactly one of the bits are set).
+It may however be (effectively) the same, in cases like
+`ct state established,related` and `ct state {established,related}`, where these
+states are mutually exclusive.
+
 MAPS
 -----
 [verse]
-- 
2.51.0

