Received: from chocolate.yew.relay.mailchannels.net (chocolate.yew.relay.mailchannels.net [23.83.220.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 356492AE68
	for <netfilter-devel@vger.kernel.org>; Fri, 26 Sep 2025 02:21:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.220.35
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758853276; cv=pass; b=MY54CbU6TMTQxiAlSHkGetQlNdvpN+wUk/WY9/tQoCMMIeSOt8EBFk6Qodc0crLKUiHNogLyDRDNLYci/vuj0jqL3ugKH+G2rUzvGSIYJFEwv3bs+dMgVQjnFhjnKn3/2KSH1dBRVBrWuz1F7UrQ1sZMliOa3Uw2j1RsjcGCfYM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758853276; c=relaxed/simple;
	bh=Mto1fHGMX42LYjdDsMLXCCbHFdscxpK+nnFXR+zLFm8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=f/nmRIG3AzYxngbQ1eYOuYYkPkIkXbd782WBsBi+tiEHE4PfWs4QJIf1lwLId7F19MnIczDDmoH8jFxY9yoZ2oBO7MukT/kqrgQqroMMzgiNsCyob5Tbx0Dn+PymoVcpiWFXg/cN1IXNZtG1J17ychSsxEUr2jBziDzTrQrtNZg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=christoph.anton.mitterer.name; spf=pass smtp.mailfrom=scientia.org; arc=pass smtp.client-ip=23.83.220.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=christoph.anton.mitterer.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=scientia.org
X-Sender-Id: instrampxe0y3a|x-authuser|calestyo@scientia.org
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 729EE1E15FE;
	Fri, 26 Sep 2025 02:11:49 +0000 (UTC)
Received: from cpanel-007-fra.hostingww.com (trex-blue-0.trex.outbound.svc.cluster.local [100.110.207.248])
	(Authenticated sender: instrampxe0y3a)
	by relay.mailchannels.net (Postfix) with ESMTPA id A662F1E0F15;
	Fri, 26 Sep 2025 02:11:48 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1758852709; a=rsa-sha256;
	cv=none;
	b=XLy7EKhTjleR5Gwewit9AKFI1I/ZD5GHAAjkqLQoUlSHjXtyFBwgpLD0CSLJTJHrMuX85K
	LVevBiQYUE1SzjoHKb2PlJ01vdkV0idZyBDt24TEP3S22Aig4/xJcBs3zMBrq3DMMDlwOs
	lnAoIiPmb4FOjpVc76yhsXiAOUoLFt3Jgkph2QJk0JKkoVgR+nsey4r9pC1kpchj/TkOe5
	7H+KP8XEOk0EJl8f1Lv1LL/MbFgX7yQ6hR9dpalcnAYLHr14uOLCfAYgesjWBocJ5F3AAM
	A+EGI6bJW/1AulHWqAug2FkbyXay727p92g5CVGZfp7Qso1HWvSjrCHD2JpX1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1758852709;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bc8B2oMrbYqMOGPUQ3paqsrfLVoSn9imm+Sgki7qB6c=;
	b=V/ksrxHqHBGoApO8xxRxgiIqFawegSMoDT4UOY7JZzOS/Gky5XNAFpygXwMIrJ2SGrLg7P
	nI0iz5UCxc1UN9rml9uARJtPXictMk6itNH5lBogsX08RXLqa2OECZNEeOfjpC9plSkx24
	7RK3e0Aq47kkA+XbjFot521CdRJPRIYz3Rx4OKYuEDC0dCD76QAmWY/IrNmkK5JJKH/K4z
	6fMR6WijMNCgFT9OCAqTiOGATUiPcH/iFJjhIlcr3BzkSBX5UVoLGpxWhSDGctk6J19M7g
	Auqm2D96LXUZbn1KZ+gEuTnxrCwpKF+Erhu2p2dsEduo8tKaTxVkXophUYPrBw==
ARC-Authentication-Results: i=1;
	rspamd-598fd7dc44-k6n7b;
	auth=pass smtp.auth=instrampxe0y3a smtp.mailfrom=calestyo@scientia.org
X-Sender-Id: instrampxe0y3a|x-authuser|calestyo@scientia.org
X-MC-Relay: Good
X-MC-Copy: stored-urls
X-MailChannels-SenderId: instrampxe0y3a|x-authuser|calestyo@scientia.org
X-MailChannels-Auth-Id: instrampxe0y3a
X-Belong-Cure: 2043dcb1783eff36_1758852709356_2458263699
X-MC-Loop-Signature: 1758852709355:680209965
X-MC-Ingress-Time: 1758852709355
Received: from cpanel-007-fra.hostingww.com (cpanel-007-fra.hostingww.com
 [3.69.87.180])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.110.207.248 (trex/7.1.3);
	Fri, 26 Sep 2025 02:11:49 +0000
Received: from [79.127.207.161] (port=45300 helo=heisenberg.scientia.org)
	by cpanel-007-fra.hostingww.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <calestyo@scientia.org>)
	id 1v1xw5-0000000CeDC-0xQq;
	Fri, 26 Sep 2025 02:11:47 +0000
Received: by heisenberg.scientia.org (Postfix, from userid 1000)
	id A0B6E55FB51A; Fri, 26 Sep 2025 04:11:44 +0200 (CEST)
From: Christoph Anton Mitterer <mail@christoph.anton.mitterer.name>
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 6/7] =?UTF-8?q?doc:=20describe=20include=E2=80=99s=20colla?= =?UTF-8?q?tion=20order=20to=20be=20that=20of=20the=20C=20locale?=
Date: Fri, 26 Sep 2025 03:52:48 +0200
Message-ID: <20250926021136.757769-7-mail@christoph.anton.mitterer.name>
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

Currently, `nft` doesn’t call `setlocale(3)` and thus `glob(3)` uses the `C`
locale.

Document this as it’s possibly relevant to the ordering of included rules.

This also makes the collation order “official” so any future localisation would
need to adhere to that.

Signed-off-by: Christoph Anton Mitterer <mail@christoph.anton.mitterer.name>
---
 doc/nft.txt | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/doc/nft.txt b/doc/nft.txt
index 4bbb6b56..899c38d6 100644
--- a/doc/nft.txt
+++ b/doc/nft.txt
@@ -165,8 +165,8 @@ Include statements support the usual shell wildcard symbols (*,?,[]). Having no
 matches for an include statement is not an error, if wildcard symbols are used
 in the include statement. This allows having potentially empty include
 directories for statements like **include "/etc/firewall/rules/*"**. The wildcard
-matches are loaded in alphabetical order. Files beginning with dot (.) are not
-matched by include statements.
+matches are loaded in the collation order of the C locale. Files beginning with
+dot (.) are not matched by include statements.
 
 SYMBOLIC VARIABLES
 ~~~~~~~~~~~~~~~~~~
-- 
2.51.0

