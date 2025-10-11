Received: from common.ash.relay.mailchannels.net (common.ash.relay.mailchannels.net [23.83.222.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F982249E5
	for <netfilter-devel@vger.kernel.org>; Sat, 11 Oct 2025 00:36:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.222.38
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760142987; cv=pass; b=rfXKimDKvzQLwkdCz6cGp21+uVRdYgYWSPIzfi8Gb0Jnc3znOQ+ezF4hUvK5kY/sxhxMxqE/dVmc8wFGGMjTIlNLLiO4t/ncuHIAwqbox35E2pPOBK+nc8DWZ0nsNm7sPJgNxaQ4n5KpqRumaiuyq7ENUQnOXSIf5qZtCqH7FSI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760142987; c=relaxed/simple;
	bh=5baur5sxoZPH6vK0NiHu7SAhcvj083RDKjTHTiT+zQQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jXG5Nu0byAMC7nwCO5/JffioCVyzMqtotxxdLJNejn3crahTCWiR4qw7yaqBNzrnfQ4MXMCU42l5le5pFadSnt0XbOcf8zreBFOpH7Nr2UGpLcnk/a8C0D8rFzaqiWwhAVLKgA0U3eBUkD+N38/zTPGwPSWfWm4EsvLno36h6so=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=christoph.anton.mitterer.name; spf=pass smtp.mailfrom=scientia.org; arc=pass smtp.client-ip=23.83.222.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=christoph.anton.mitterer.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=scientia.org
X-Sender-Id: instrampxe0y3a|x-authuser|calestyo@scientia.org
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 0F3EC101B18;
	Sat, 11 Oct 2025 00:29:38 +0000 (UTC)
Received: from cpanel-007-fra.hostingww.com (trex-green-0.trex.outbound.svc.cluster.local [100.117.100.69])
	(Authenticated sender: instrampxe0y3a)
	by relay.mailchannels.net (Postfix) with ESMTPA id 43CA710194E;
	Sat, 11 Oct 2025 00:29:37 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1760142577; a=rsa-sha256;
	cv=none;
	b=ul0O42nG1kfiFG+7MdUMfe/CDzBEiJIHBdFe9m2VoKaNTk0IrGHCp4rCdfZqel928/8tpN
	UMBlVgju6BGEQIwBdOPSPG+3hjk5JZTdEljPm1JAeNhcj6Zx56lx31PSiK/01u99dT0rnt
	dvsuQg8EQjmxGNjjx3ywOprt5wL1rKgXLGcR2RF42n2En3EhkgyZjWMmcjtbvDq6FuAYBg
	grM467LYHSPC1+/GRWDrxmClObl7X32Vh73NK2WEBMsJArhw4eyeuYXaJ/J7dzV1pcuMEr
	AxFwGxHu5ngpYTVRqqK7f2XYgaO65Z3xVthfRbsby2OKgeS3aZHYDrA3g00nsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1760142577;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ztXjMMzEj+V9LySkLWCcKRXGoF1aQMI6hMgrJwQzUoc=;
	b=D2h4oPFmUkzlEfnpjZMMXaNA4VxW2M3Qf4PFu2fluLUl2ydB5ycvdDQwpZhpf9aqPlevoK
	fpnsUMou+WBbP/6w5c6Bx2NNQU1De7MeFpQPR7tHTJUPB1njiS73NOmrcjsu7/B7Sfdbp/
	+RrIXkDIEsvQxv743WLbb7qK2TdW775gzTtREW2nxP+vyhb+gdbPD+OtyteNs/D/NJkao8
	mhVZdBPowv/b52vJQk/41FxeMYTanCuabeWEnobyMS/WqSq/Fvk9lYdP2C+Sc5c+TeG98v
	HFKwoV4pv81x87As5v8xK0cnPoMzGWxU00Yl+ej1vu0qzzim9Q1UvT1c9PtxRA==
ARC-Authentication-Results: i=1;
	rspamd-668c7f7ff9-vrr96;
	auth=pass smtp.auth=instrampxe0y3a smtp.mailfrom=calestyo@scientia.org
X-Sender-Id: instrampxe0y3a|x-authuser|calestyo@scientia.org
X-MC-Relay: Neutral
X-MC-Copy: stored-urls
X-MailChannels-SenderId: instrampxe0y3a|x-authuser|calestyo@scientia.org
X-MailChannels-Auth-Id: instrampxe0y3a
X-Scare-Callous: 437917f87ddef293_1760142577953_1562483143
X-MC-Loop-Signature: 1760142577953:2485160175
X-MC-Ingress-Time: 1760142577953
Received: from cpanel-007-fra.hostingww.com (cpanel-007-fra.hostingww.com
 [3.69.87.180])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.117.100.69 (trex/7.1.3);
	Sat, 11 Oct 2025 00:29:37 +0000
Received: from [212.104.214.84] (port=31047 helo=heisenberg.scientia.org)
	by cpanel-007-fra.hostingww.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <calestyo@scientia.org>)
	id 1v7NUP-00000009bvS-2yrA;
	Sat, 11 Oct 2025 00:29:35 +0000
Received: by heisenberg.scientia.org (Postfix, from userid 1000)
	id A662558D12D2; Sat, 11 Oct 2025 02:29:32 +0200 (CEST)
From: Christoph Anton Mitterer <mail@christoph.anton.mitterer.name>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de,
	pablo@netfilter.org
Subject: [PATCH v2 7/7] doc: describe how values match sets
Date: Sat, 11 Oct 2025 02:24:03 +0200
Message-ID: <20251011002928.262644-8-mail@christoph.anton.mitterer.name>
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
Content-Transfer-Encoding: 8bit
X-AuthUser: calestyo@scientia.org

Signed-off-by: Christoph Anton Mitterer <mail@christoph.anton.mitterer.name>
---
 doc/data-types.txt |  1 +
 doc/nft.txt        | 10 ++++++++++
 2 files changed, 11 insertions(+)

diff --git a/doc/data-types.txt b/doc/data-types.txt
index 47a0d25a..dad7e31b 100644
--- a/doc/data-types.txt
+++ b/doc/data-types.txt
@@ -40,6 +40,7 @@ For example `tcp flags syn,ack / syn,ack,fin,rst` is the same as
 
 It should further be noted that *'expression' 'bit'[,'bit']...* is not the same
 as *'expression' {'bit'[,'bit']...}*.
+See <<SETS>> above.
 
 
 STRING TYPE
diff --git a/doc/nft.txt b/doc/nft.txt
index 3fef1882..4d1daf5c 100644
--- a/doc/nft.txt
+++ b/doc/nft.txt
@@ -764,6 +764,16 @@ Example: When the set contains range *1.2.3.1-1.2.3.4*, then adding element *1.2
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

