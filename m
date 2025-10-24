Received: from cyan.ash.relay.mailchannels.net (cyan.ash.relay.mailchannels.net [23.83.222.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08C9E1DB127
	for <netfilter-devel@vger.kernel.org>; Fri, 24 Oct 2025 02:43:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.222.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761273807; cv=pass; b=KlziDyFvc9WYY+8npVhAFbcKt+4cce2AZCS4xT3IAIWYeYXoaeVXDbqDKx0V6aV0rx68p85bPNZ1XOBegESzqiIa5n91u6Nl7O0JvFJTkhpdKjY+oQoRc/3Sdte9lhg/bT5ed1eLgPTJPG/nSNV3co5BlrqnpyWdvqBQxnGZuWA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761273807; c=relaxed/simple;
	bh=1TY6XpxAUkmQXwOXWsGeYVeHve3r79OpJuPWl1coxdI=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ekvGODjX5bD0d9YdQjUWmhW4wMLfLJTsbdm2ZJqq2tcSzejykNtTbR4PVxPMkUQVEkZpffJ2SiUUggY8buMCkMFRRZtP3s2Ljz2/pcYbAZZXxZpX6M34wT/yy+KXhkYKbmRvcLaQ6uXtM+rba1QLKjG8FPa/y06/m0YpFsJNYfM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=christoph.anton.mitterer.name; spf=pass smtp.mailfrom=scientia.org; arc=pass smtp.client-ip=23.83.222.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=christoph.anton.mitterer.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=scientia.org
X-Sender-Id: instrampxe0y3a|x-authuser|calestyo@scientia.org
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 63607261F1D;
	Fri, 24 Oct 2025 02:35:20 +0000 (UTC)
Received: from cpanel-007-fra.hostingww.com (trex-green-1.trex.outbound.svc.cluster.local [100.121.87.108])
	(Authenticated sender: instrampxe0y3a)
	by relay.mailchannels.net (Postfix) with ESMTPA id D7A7726154E
	for <netfilter-devel@vger.kernel.org>; Fri, 24 Oct 2025 02:35:19 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1761273320; a=rsa-sha256;
	cv=none;
	b=hzgEp5rXu73ltOQEhw6bB9eChzpLEj0NTqQIZHZf9O+M/lz4sq9JYeaeIEAyLqnDGpBRrY
	5WAUo1RQK4kI4MA5r8QF/DjE/mPjmcXuEw4S6aNISXElmk4w8UFWnr65RvdojBHeaY6WVn
	uX7+O0zFb7b43bYfCVDlZMEM0AJykNd1kXK2tTtKedeSGhOw8rQDj/xtzj5qlDV/ildwCr
	+I9wcMCcIwjUBiNb1JklgQaeSdz7Th87y8gEmrQ7JnFLfNPAFtpOXmZV0P9IYeOW39kgvE
	a67e/Z7/QA8DLN7j/3pqvw8GD9+Imt0qz9aWyEzgL2DbFHcAx3SH0qBRFsou/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1761273320;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=swyzJpDmIHB1kNPHTrcfZ7MxhXfs5nXHu9WM+vXjaDU=;
	b=SPRv8a97smtSycsN4BFL7l0IpX2yEhl7cZx1fBEX1uod80YsfawurT3Zo2jJXQNhj70YA5
	n2NSP/Do6e0KluwyUPBvdy511YSeipdFxnrq8yUqM+exOkM/1L29JuRRB2s0RDBJIrc+Bh
	wrT2n1jGq70SsR3zhl7jZ1caKWsreVwsIjPwruJvWc0zJQ0WKpBm6XujOQDcA+ibliwqli
	FZ0r8Qte8Q7LWZD87r6j3Zr0Bhur+dZCT0V/bE5ZfeaTIMGRs0UkWcanxMCqKQ3wqcZtNv
	tszoW5GdM0E9qQNjdxLNqkrR2EAzbv6VMbtjR6quqrChT1xP5JJIprPcZ8ppYQ==
ARC-Authentication-Results: i=1;
	rspamd-674f557ffc-d5fx4;
	auth=pass smtp.auth=instrampxe0y3a smtp.mailfrom=calestyo@scientia.org
X-Sender-Id: instrampxe0y3a|x-authuser|calestyo@scientia.org
X-MC-Relay: Neutral
X-MC-Copy: stored-urls
X-MailChannels-SenderId: instrampxe0y3a|x-authuser|calestyo@scientia.org
X-MailChannels-Auth-Id: instrampxe0y3a
X-Keen-Troubled: 497f707b7ea19da9_1761273320260_4015688009
X-MC-Loop-Signature: 1761273320260:619963641
X-MC-Ingress-Time: 1761273320260
Received: from cpanel-007-fra.hostingww.com (cpanel-007-fra.hostingww.com
 [3.69.87.180])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.121.87.108 (trex/7.1.3);
	Fri, 24 Oct 2025 02:35:20 +0000
Received: from [212.104.214.84] (port=24709 helo=heisenberg.scientia.org)
	by cpanel-007-fra.hostingww.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <calestyo@scientia.org>)
	id 1vC7eC-0000000FtVv-0qm2
	for netfilter-devel@vger.kernel.org;
	Fri, 24 Oct 2025 02:35:18 +0000
Received: by heisenberg.scientia.org (Postfix, from userid 1000)
	id EE7305AA5BFC; Fri, 24 Oct 2025 04:35:16 +0200 (CEST)
From: Christoph Anton Mitterer <mail@christoph.anton.mitterer.name>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH 3/9] tools: include further `Documentation=` URIs
Date: Fri, 24 Oct 2025 04:08:18 +0200
Message-ID: <20251024023513.1000918-4-mail@christoph.anton.mitterer.name>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251024023513.1000918-1-mail@christoph.anton.mitterer.name>
References: <20251024023513.1000918-1-mail@christoph.anton.mitterer.name>
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
 tools/nftables.service.in | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/nftables.service.in b/tools/nftables.service.in
index edc7c831..ca2ef684 100644
--- a/tools/nftables.service.in
+++ b/tools/nftables.service.in
@@ -1,6 +1,6 @@
 [Unit]
 Description=nftables static rule set
-Documentation=man:nftables.service(8)
+Documentation=man:nftables.service(8) man:nft(8) https://wiki.nftables.org
 Wants=network-pre.target
 Before=network-pre.target shutdown.target
 Conflicts=shutdown.target
-- 
2.51.0

