Received: from seashell.cherry.relay.mailchannels.net (seashell.cherry.relay.mailchannels.net [23.83.223.162])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D90514B06C
	for <netfilter-devel@vger.kernel.org>; Fri, 24 Oct 2025 02:35:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.223.162
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761273328; cv=pass; b=I+laDuICQQuXcB83g8YjRJbgeYI9MU3eMJJ5ltO3BiQqG3BV1vHfsvatI0bV7D2O8Tj9kJsGIi+FI8KiHP3rP2wYdHbK/d1ajOX7ery/Im5HhY4JlvklP852MscLL+Moki1YFMgTInU1fROsbLTJheXXh6Iq4odLCGr2mSfKNvY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761273328; c=relaxed/simple;
	bh=BbgscwZMCFrFhNLK1Lv0O4I/gFwc5SoU/52o1ZeF+U0=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nH3gDHtW/5sMggOH7TomcydrVo+T6A2nEnJbY2DC1EclUxFNQ25Hf5j0jTHGW0e5Uy8GSvDU3tWYxb2S5Eoi+FGpJLUpVjn5Dy7BlK0sfCfpWI6bJj/ItkiPdCpLDdgX+toRVa8/j0SrzTJdEV8adETasC1NAJvdijdVHDMWKyY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=christoph.anton.mitterer.name; spf=pass smtp.mailfrom=scientia.org; arc=pass smtp.client-ip=23.83.223.162
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=christoph.anton.mitterer.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=scientia.org
X-Sender-Id: instrampxe0y3a|x-authuser|calestyo@scientia.org
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 6421F421017;
	Fri, 24 Oct 2025 02:35:20 +0000 (UTC)
Received: from cpanel-007-fra.hostingww.com (trex-green-1.trex.outbound.svc.cluster.local [100.121.87.108])
	(Authenticated sender: instrampxe0y3a)
	by relay.mailchannels.net (Postfix) with ESMTPA id E01014218BC
	for <netfilter-devel@vger.kernel.org>; Fri, 24 Oct 2025 02:35:19 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1761273320; a=rsa-sha256;
	cv=none;
	b=UI9zLBQMNqDCYUQP6eT5zNpU2UwLEYWQ4CXquWggIUQO5syuMFc0plgH4I2pqE0TwBBxZQ
	vJILoyaSuQDm0i9WQkNJ6Cxp+3T5QLzc4HFe7zCxxdZq4OfrZsXXOW60zMHNqEU4Sa2+9T
	+z2GAziN9C3lLwW5sam3skDRVVmeEnqhscXs3NjfzMtOoj0qJDGSDhDGdxTyI+b1LZpir9
	vMXCxtNk36cO/vaXAJWOMFuSx96zzXScKC+4Uujn3YiJFg2jGXrd9jHobVZ+Dj3EporwNS
	HqKIiGfP/EZvC+6+f5TELW12syC5svzUr9bZnE20L6YHiSRaQQmB1XNTFf89xA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1761273320;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lfT4qYGUimSVxhI+Bz/vST6+ScmjtGYhYv3exhIQl9Y=;
	b=MjxDI0+MJ9d276GYoDZUPjlta8ux3RckydKX2GrmsBgr0x3fcmEZ9J9V9FqVmxKfgvD69g
	1OF2Cyte8OYvu3VvXOyxBRoUsgYx1jh0AxfQEQFSiiniTfR6NGuVsw/Qz0TlL6IfQnArlC
	0brMdhgaAyMsB7jzFmASDc655OSZ4pprtrU55kPf3zoQJsNcSBflVimK+qDbSB4iP0SUrV
	Cx351YjDv3wbPzzohSd/qxk9b0wHOJQK0LrbvqvY06F5DbRcTzxlcvajBBUsW/4ufY62kQ
	Esa3BccxbKCe+y7HekkZ30Sxfi5aMAPpbzn5wK405EJYLd4eFiQXIahbjBissw==
ARC-Authentication-Results: i=1;
	rspamd-674f557ffc-d5fx4;
	auth=pass smtp.auth=instrampxe0y3a smtp.mailfrom=calestyo@scientia.org
X-Sender-Id: instrampxe0y3a|x-authuser|calestyo@scientia.org
X-MC-Relay: Neutral
X-MC-Copy: stored-urls
X-MailChannels-SenderId: instrampxe0y3a|x-authuser|calestyo@scientia.org
X-MailChannels-Auth-Id: instrampxe0y3a
X-Hook-Coil: 7662b1f822eb173b_1761273320295_2273186403
X-MC-Loop-Signature: 1761273320295:2219958387
X-MC-Ingress-Time: 1761273320295
Received: from cpanel-007-fra.hostingww.com (cpanel-007-fra.hostingww.com
 [3.69.87.180])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.121.87.108 (trex/7.1.3);
	Fri, 24 Oct 2025 02:35:20 +0000
Received: from [212.104.214.84] (port=49141 helo=heisenberg.scientia.org)
	by cpanel-007-fra.hostingww.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <calestyo@scientia.org>)
	id 1vC7eC-0000000FtVt-0qmB
	for netfilter-devel@vger.kernel.org;
	Fri, 24 Oct 2025 02:35:18 +0000
Received: by heisenberg.scientia.org (Postfix, from userid 1000)
	id E345B5AA5BF8; Fri, 24 Oct 2025 04:35:16 +0200 (CEST)
From: Christoph Anton Mitterer <mail@christoph.anton.mitterer.name>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH 1/9] =?UTF-8?q?tools:=20don=E2=80=99t=20set=20options=20wh?= =?UTF-8?q?ose=20values=20match=20their=20defaults?=
Date: Fri, 24 Oct 2025 04:08:16 +0200
Message-ID: <20251024023513.1000918-2-mail@christoph.anton.mitterer.name>
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

Signed-off-by: Christoph Anton Mitterer <mail@christoph.anton.mitterer.name>
---
 tools/nftables.service.in | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tools/nftables.service.in b/tools/nftables.service.in
index 2ac7e6fd..e694f2f7 100644
--- a/tools/nftables.service.in
+++ b/tools/nftables.service.in
@@ -10,7 +10,6 @@ ConditionPathExists=@pkgsysconfdir@/rules/main.nft
 [Service]
 Type=oneshot
 RemainAfterExit=yes
-StandardInput=null
 ProtectSystem=full
 ProtectHome=true
 ExecStart=@sbindir@/nft 'flush ruleset; include "@pkgsysconfdir@/rules/main.nft"'
-- 
2.51.0

