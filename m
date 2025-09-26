Received: from indigo.cherry.relay.mailchannels.net (indigo.cherry.relay.mailchannels.net [23.83.223.91])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA7642459F8
	for <netfilter-devel@vger.kernel.org>; Fri, 26 Sep 2025 02:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.223.91
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758852717; cv=pass; b=uHbgjV077NzY6yu/joyBeWDKAGOAPYQXOTa5P6Ln6DhksujIJbliuLhcnqwbaioSBm6WsKtpOZm954y5aVLC0wLt2kbeCPZKQsMUpKGHz7aQlvWqcCOrcUteZIAt29JbP9ZizPhgSwbJPkmrOzLgrA/Qynk0YgniNNzdUpHQLRw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758852717; c=relaxed/simple;
	bh=ejLBRZ9RrMm4MQ2wKYHf4Fdr8GDqBjBUr/q9X2CmEqU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Oldl+38sBG5LAUjxG2H+9q7fztg8a9Jb7Imz9agp9ltOBya6/U/Hv82ZdHZG4QmRafeXUATh6XA8uPvGJLlh88cgshg8BznTSon7YqOq95wiY8mB7njVkSZVdY5aY9kqxBX+GHNNsmnNcktSRudU+mU4lInHNYgAvny3y3Vo/O4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=christoph.anton.mitterer.name; spf=pass smtp.mailfrom=scientia.org; arc=pass smtp.client-ip=23.83.223.91
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=christoph.anton.mitterer.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=scientia.org
X-Sender-Id: instrampxe0y3a|x-authuser|calestyo@scientia.org
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 7A3BA94154B;
	Fri, 26 Sep 2025 02:11:49 +0000 (UTC)
Received: from cpanel-007-fra.hostingww.com (100-108-145-58.trex-nlb.outbound.svc.cluster.local [100.108.145.58])
	(Authenticated sender: instrampxe0y3a)
	by relay.mailchannels.net (Postfix) with ESMTPA id A61CB941515;
	Fri, 26 Sep 2025 02:11:48 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1758852709; a=rsa-sha256;
	cv=none;
	b=dndIpRclfK//J81CrzB8fYr3UGGDuesicJgltIXD2A4CAcaoB5F0Wv2clhrJaUVF+HNTds
	ET5o8dxfXycimNrrLSgjK2InTCpSIqpDlCBf5oqx0nNk5ctDoSvBpx56MApS//67q197g4
	QlnRsoiDiJMWxP/kn0Wk6sHg3ok8kvEBGwTF51agIaAuGkSy9sC2rCBMQAzi9EGoeBL/xP
	sZCLAI7LSyUZ0yhI5YDQMMDNNHuD9wn1tsuuRNvC1e7xFHCLvOnyLGesBjbmcJ6pVAvPnI
	ULNg2zNXpuDhp/rBcLX+qq6tt1E5KrscxfFcVRdQ2Mmhnw4XLXMJofvrs2ASmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1758852709;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DxfFu6Weu/LSeOPV+QtLH3BfwnBjHgtyFjZvcOWvnQY=;
	b=qbAw3R7uhO6/LSfQDomUeI+CXF5/vDM9Wyr+B0v/9zqbwumOKH/C0uBgn0wIb1GZ7Buwp3
	WrATXPFSP8fH5iyfmH3HLETafXuIs3kHjYdKDQJfqCUdlmhAWswJtVi+3MK3nIkXejONJ7
	9bHjr5CHXKEFU4g1ycf0DtgL0V0gfLS5oKlB2ivvInPcZSTVr021op0yHd36UnBOV/BywQ
	X/uLxzjmk6phJW6OVQ1TsangaPNhNQYghxkOO9ousEYoMawoMRom9fUtUYmmiEVCBBxXVR
	wuKL6WhAFVkh52zpfq5IPhLvQCoaMH1TC5KPRgFmNoK3eNt48wg44XR2aCiNzQ==
ARC-Authentication-Results: i=1;
	rspamd-598fd7dc44-cxztd;
	auth=pass smtp.auth=instrampxe0y3a smtp.mailfrom=calestyo@scientia.org
X-Sender-Id: instrampxe0y3a|x-authuser|calestyo@scientia.org
X-MC-Relay: Good
X-MC-Copy: stored-urls
X-MailChannels-SenderId: instrampxe0y3a|x-authuser|calestyo@scientia.org
X-MailChannels-Auth-Id: instrampxe0y3a
X-Belong-Imminent: 42b420d45b5945af_1758852709387_2460448850
X-MC-Loop-Signature: 1758852709387:710713486
X-MC-Ingress-Time: 1758852709386
Received: from cpanel-007-fra.hostingww.com (cpanel-007-fra.hostingww.com
 [3.69.87.180])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.108.145.58 (trex/7.1.3);
	Fri, 26 Sep 2025 02:11:49 +0000
Received: from [79.127.207.161] (port=17753 helo=heisenberg.scientia.org)
	by cpanel-007-fra.hostingww.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <calestyo@scientia.org>)
	id 1v1xw5-0000000CeDB-0zSg;
	Fri, 26 Sep 2025 02:11:47 +0000
Received: by heisenberg.scientia.org (Postfix, from userid 1000)
	id 9BA8B55FB518; Fri, 26 Sep 2025 04:11:44 +0200 (CEST)
From: Christoph Anton Mitterer <mail@christoph.anton.mitterer.name>
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5/7] doc: add some more documentation on bitmasks
Date: Fri, 26 Sep 2025 03:52:47 +0200
Message-ID: <20250926021136.757769-6-mail@christoph.anton.mitterer.name>
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
 doc/data-types.txt | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/doc/data-types.txt b/doc/data-types.txt
index 18af266a..47a0d25a 100644
--- a/doc/data-types.txt
+++ b/doc/data-types.txt
@@ -26,6 +26,22 @@ integer
 
 The bitmask type (*bitmask*) is used for bitmasks.
 
+In expressions the bits of a bitmask may be specified as *'bit'[,'bit']...* with
+'bit' being the value of the bit or a pre-defined symbolic constant, if any (for
+example *ct state*’s bit 0x1 has the symbolic constant `new`).
+
+Equality of a value with such bitmask is given, if the value has any of the
+bitmask’s bits set (and optionally others).
+
+The syntax *'expression' 'value' / 'mask'* is identical to
+*'expression' and 'mask' == 'value'*.
+For example `tcp flags syn,ack / syn,ack,fin,rst` is the same as
+`tcp flags and (syn|ack|fin|rst) == syn|ack`.
+
+It should further be noted that *'expression' 'bit'[,'bit']...* is not the same
+as *'expression' {'bit'[,'bit']...}*.
+
+
 STRING TYPE
 ~~~~~~~~~~~~
 [options="header"]
-- 
2.51.0

