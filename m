Received: from rusty.tulip.relay.mailchannels.net (rusty.tulip.relay.mailchannels.net [23.83.218.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58414221DB6
	for <netfilter-devel@vger.kernel.org>; Fri, 24 Oct 2025 02:35:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.218.252
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761273329; cv=pass; b=oZCUKw/Bq6eY34fh37wa+zFoGfl625geR+0bB8WLhOOLSno+0oKuwP9FstsfgYACyc/ko4jSV3ElBMdGYQD+1S69kl2tQmzgWVgnTClqwCmDVjgsOJAR+F1hLBDjiniQJbYBWyNIg5gXknatxg4GcLKQoqHIJzTxygm/Vy5iY8c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761273329; c=relaxed/simple;
	bh=bgM+AD+J6GXwPPFFwIfkp7S0yWnmhhQAlrqdZPGxxgQ=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kVAF+DlcdGBENxkl2Sd03/ELyce3DDDNcJhMXMe+OyZzxEIPHezF8jyZfGjmHWdu/NDyqcc0B5piGD4nYZA/QPB7c/dfKTtYoeSCcuLDJtvOLrfeal5cv2nsKaTXygsXZH97k8BaEKkNXd0fnBlAi777n7XlWE8+zQ9eEe6Ou+0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=christoph.anton.mitterer.name; spf=pass smtp.mailfrom=scientia.org; arc=pass smtp.client-ip=23.83.218.252
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=christoph.anton.mitterer.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=scientia.org
X-Sender-Id: instrampxe0y3a|x-authuser|calestyo@scientia.org
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 36077404CE;
	Fri, 24 Oct 2025 02:35:21 +0000 (UTC)
Received: from cpanel-007-fra.hostingww.com (trex-green-2.trex.outbound.svc.cluster.local [100.121.87.189])
	(Authenticated sender: instrampxe0y3a)
	by relay.mailchannels.net (Postfix) with ESMTPA id B07D8416F2
	for <netfilter-devel@vger.kernel.org>; Fri, 24 Oct 2025 02:35:20 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1761273321; a=rsa-sha256;
	cv=none;
	b=VuHefrbCV/EIKFKqH6YgGs/eauA4/t+izp+d00FSkRiOb6kIlbvXBFeYQrO9asxD2DwILH
	FSWpNVb2WFGqKDpCui68LZlB8bCpOKwq1COJ7YZvnJWL0bdLbLk9FogSUh5+DuR1CUilLO
	Vu39KWdJie+0XVlx7xzYMX34MhPN7bpfnTDCTLB1EVdZtfypkPl7N/sXRFBbfyNKB5YJue
	wim89GtXYYwTtpdyuE2ghTSODJvUZQOOwabxjp8b7fR1ZXwwi3MGmgtGuXr2AJBGwHcH+e
	5U7L37ehThX+uBv8N2ZSBc2DNEwsJAl9MYpkvvcD7pK9IQMaiL3T1/Wi0oeUMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1761273321;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=q/V0h5G6R3pGnt/riwGtnTWhiPKI2Wy3ttpCxq9UGzE=;
	b=X5Et0hggI0Bw0P7jTkQbXZCefSk0ExHErP3LG7trpZo5X6iVYV3xA+x+4PX2B3OhrLGWFp
	Hp6xuFBzyfl1nBHRVzR+WvxYvPaHlT/GlW76K9F5U4vvGJ1TTZ2QMOPq/TET/r2FZMI4He
	C87j/txHQzHfMOwvl81GffZ+UaA21+AjFlnLCMH8fz9MT/dSydPvEIaFqWpb0a6ET+51UQ
	yyYuSSd2nLUmU587u5HaUN6GFodo9EgSvjaLC3TIwzouIRhogcyufw1gGDDD9YMCQk5SN3
	2zvIlcXvkaqgrWhnrMgCivn8m0R4I0G8DKYA3bxGm62zaxIl1jn2MbLTh5kPEA==
ARC-Authentication-Results: i=1;
	rspamd-674f557ffc-d5fx4;
	auth=pass smtp.auth=instrampxe0y3a smtp.mailfrom=calestyo@scientia.org
X-Sender-Id: instrampxe0y3a|x-authuser|calestyo@scientia.org
X-MC-Relay: Neutral
X-MC-Copy: stored-urls
X-MailChannels-SenderId: instrampxe0y3a|x-authuser|calestyo@scientia.org
X-MailChannels-Auth-Id: instrampxe0y3a
X-Language-Chief: 73798ce8478adff0_1761273321095_3547932889
X-MC-Loop-Signature: 1761273321095:2155020449
X-MC-Ingress-Time: 1761273321095
Received: from cpanel-007-fra.hostingww.com (cpanel-007-fra.hostingww.com
 [3.69.87.180])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.121.87.189 (trex/7.1.3);
	Fri, 24 Oct 2025 02:35:21 +0000
Received: from [212.104.214.84] (port=61611 helo=heisenberg.scientia.org)
	by cpanel-007-fra.hostingww.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <calestyo@scientia.org>)
	id 1vC7eD-0000000FtWU-1k4F
	for netfilter-devel@vger.kernel.org;
	Fri, 24 Oct 2025 02:35:19 +0000
Received: by heisenberg.scientia.org (Postfix, from userid 1000)
	id 0B6015AA5C04; Fri, 24 Oct 2025 04:35:17 +0200 (CEST)
From: Christoph Anton Mitterer <mail@christoph.anton.mitterer.name>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH 7/9] =?UTF-8?q?tools:=20don=E2=80=99t=20stop=20`nftables.s?= =?UTF-8?q?ervice`=20(and=20flush=20the=20ruleset)=20when=20isolating=20an?= =?UTF-8?q?other=20unit?=
Date: Fri, 24 Oct 2025 04:08:22 +0200
Message-ID: <20251024023513.1000918-8-mail@christoph.anton.mitterer.name>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251024023513.1000918-1-mail@christoph.anton.mitterer.name>
References: <20251024023513.1000918-1-mail@christoph.anton.mitterer.name>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-AuthUser: calestyo@scientia.org

The nftables ruleset shouldn’t be unexpectedly flushed, which might however
happen when `nftables.service` is stopped as a consequence of isolating another
unit.

Signed-off-by: Christoph Anton Mitterer <mail@christoph.anton.mitterer.name>
---
 tools/nftables.service.in | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/nftables.service.in b/tools/nftables.service.in
index ea428ee7..5f367a24 100644
--- a/tools/nftables.service.in
+++ b/tools/nftables.service.in
@@ -8,6 +8,8 @@ Before=network-pre.target
 After=sysinit.target
 DefaultDependencies=no
 
+IgnoreOnIsolate=yes
+
 ConditionPathExists=@pkgsysconfdir@/rules/main.nft
 
 
-- 
2.51.0

