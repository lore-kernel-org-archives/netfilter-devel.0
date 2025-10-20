Received: from panther.cherry.relay.mailchannels.net (panther.cherry.relay.mailchannels.net [23.83.223.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A29183D76
	for <netfilter-devel@vger.kernel.org>; Tue, 21 Oct 2025 00:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.223.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761004831; cv=pass; b=MqWlitbdyitjQmdMHD/UXqyhmUax7LkOjOABIw7UZJMTuOx3xsWKm2EmnEbrMJOaFowSNTDjn94PqIOWIMyuurfVr3AhpMRi/mg2/9qgtJXYxdrX6xR5t278oI9NMM2bYVnxIvyasajTEL0DAWHcyDIXsCn2m92Ou0g3QyO19+I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761004831; c=relaxed/simple;
	bh=y1W7vSNxEEl/YpQMvvXyrA/ddPO1hSyBINjVa81CN1Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m7604+OCfpO4DYAftqDYtXRG1hFIV9+F0JGWV/JwqffmCzqDKRDcpz8kXvQrxW/Afkn2RZLA8rtzJ3hb3a4uJ2NJUYIbH1kjxxyQaIzcbRvtj2nHopvXNMCmxOgVeLtfRoOv5pXbJwOZNK8O4wKPhYxMn+bs+8imthMXVs7Ghrk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=christoph.anton.mitterer.name; spf=pass smtp.mailfrom=scientia.org; arc=pass smtp.client-ip=23.83.223.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=christoph.anton.mitterer.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=scientia.org
X-Sender-Id: instrampxe0y3a|x-authuser|calestyo@scientia.org
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 488AF6C1B27;
	Mon, 20 Oct 2025 23:51:36 +0000 (UTC)
Received: from cpanel-007-fra.hostingww.com (100-118-36-217.trex-nlb.outbound.svc.cluster.local [100.118.36.217])
	(Authenticated sender: instrampxe0y3a)
	by relay.mailchannels.net (Postfix) with ESMTPA id 6DE7B6C1FBF;
	Mon, 20 Oct 2025 23:51:35 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1761004296; a=rsa-sha256;
	cv=none;
	b=n54W7iIWEnZSkSMHQp7SR7wL9nwWPSQYzS+kYFgj2JtX5DHdD8RqwXe3VGlBWQ/ysoTiYz
	CRM/v3naIGyH+kylLulXV73qvaqc+LPZuUq+ZdA3/XmyaF19/AfgSZnMbmk20tWTvX5bmU
	u6YrYq4gFalfiPpcDWHTktMx6jIaIE50D5Vc9Qw43pcoZoK/3mYNyinhZlTqDfsVAJ9/9o
	SrLnO6W/Q1g7cV9ihhXtRy93TYkCtsVzM5dMJ6CiysnX3bLZ+kisKQsRHPtIMEP7q0t5/C
	6M3xfysF24gzdu6eAseWFrOi6WY2uVMvOI2ZutCTdQ84wiIxFduVmncyQjPMSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1761004296;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=y1W7vSNxEEl/YpQMvvXyrA/ddPO1hSyBINjVa81CN1Y=;
	b=10JZ93MWEa7RwKw89mrxMxULoJW70FZ74QIbcYQV3IkB/kEi0BsxFSih9TPNrSJVNYi0hS
	eVRy17wWdsUca1J/wLAoAlkrDWwnOcRscFPIy7dlFBfYPrLPZyfoXZZlzNtmD24DIc4rjs
	9EdOY4Ca9rYzNqf2lFxq4Fv6FqEGf1Y8NvQrXTjWTp8XLAuAt1eE2lWr/MV69Iy1ohj3Su
	OUr0waPa/IpWtCgKNCLvcmis9LzxpP9hjk4qiESGRbWvzpw3yccgeuaZ45Mv3Dak6svdld
	f5Wzhd/ub259eGCqcz91nG9vztTg2Rycqc88J6AVNbfYI8TOxqRRlB9qr5ueKg==
ARC-Authentication-Results: i=1;
	rspamd-869c579f6-lrm9q;
	auth=pass smtp.auth=instrampxe0y3a smtp.mailfrom=calestyo@scientia.org
X-Sender-Id: instrampxe0y3a|x-authuser|calestyo@scientia.org
X-MC-Relay: Neutral
X-MailChannels-SenderId: instrampxe0y3a|x-authuser|calestyo@scientia.org
X-MailChannels-Auth-Id: instrampxe0y3a
X-Little-Company: 3daad2d349dfa241_1761004296116_1275916077
X-MC-Loop-Signature: 1761004296116:2943681202
X-MC-Ingress-Time: 1761004296115
Received: from cpanel-007-fra.hostingww.com (cpanel-007-fra.hostingww.com
 [3.69.87.180])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.118.36.217 (trex/7.1.3);
	Mon, 20 Oct 2025 23:51:36 +0000
Received: from [79.127.207.162] (port=1263 helo=heisenberg.scientia.org)
	by cpanel-007-fra.hostingww.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <calestyo@scientia.org>)
	id 1vAzf4-00000009coh-1FWH;
	Mon, 20 Oct 2025 23:51:33 +0000
Received: by heisenberg.scientia.org (Postfix, from userid 1000)
	id 56E3F5A29C21; Tue, 21 Oct 2025 01:51:32 +0200 (CEST)
From: Christoph Anton Mitterer <mail@christoph.anton.mitterer.name>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de,
	pablo@netfilter.org
Subject: [PATCH v4 0/5] doc: miscellaneous improvements
Date: Tue, 21 Oct 2025 01:49:00 +0200
Message-ID: <20251020235130.361377-1-mail@christoph.anton.mitterer.name>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <6bb455009ebd3a2fe17581dfa74addc9186f33ea.camel@scientia.org>
References: <6bb455009ebd3a2fe17581dfa74addc9186f33ea.camel@scientia.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-AuthUser: calestyo@scientia.org

Hey.

v4 as per discussion on the list.

I guess #2 (and perhaps even #1) may still not make you completely happy,
thogh.

Thanks,
Chris.

