Received: from azazel.net (taras.nevrast.org [35.176.194.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09C7223183E
	for <netfilter-devel@vger.kernel.org>; Thu, 29 May 2025 20:48:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.176.194.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748551708; cv=none; b=C1cnBVIf9kuJOHpBdetPn1eiYP1T02kSdP9BctzVWYagA2MzC1YgAdtOBpwBt+2wJJRe8WJC014R1c/7WppzTVaAfkNS7xNjG7dk0j/0qHbzIoVHBE4uZwUeRCLEsRs223vS5PgRyFWuFf0s62zizOz3/+HUjFfrGlo8533LYog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748551708; c=relaxed/simple;
	bh=YoYxJBlS/wMjUQ+Vz4+M6Sbc5hcvpVxilTwLAD8/IXY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=m9Hz8ToKuW785xX6TYPmUc7/equq6tLVj05ESJqs90AZmzg5q8CC+1eIXEtlQhTEMUYYnqpL9VJeJFNvlx0DV7QMYQZpieqhaPW9ZDdCctYIeXSrZBQBpqSmnIWCCxjBP/vSz0UAMjUii7T4mrNBltDqrU0o4Opu1KPddalpzKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net; spf=pass smtp.mailfrom=azazel.net; dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b=ePesVO7e; arc=none smtp.client-ip=35.176.194.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=azazel.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="ePesVO7e"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
	s=20220717; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=M5csb5ulfdK9HLR1CokjY6LTmZ3ScmMmljA7iXbdFDw=; b=ePesVO7e/QH1DVfZf8zQos9gay
	WCiPJe2e8DH6h+Qn9Nz5G/jbW9PyZKp9XcpiRNwA/lOTZVhRZ3BEHIDfv5iGON/rkdxVylecT1Rgg
	cIoIz0MHYGC1K3rubdpL6jyLPO3lIVae/Ioc+y1/lvEunI6zls93AoOrogBg/oHLMGJRWYu3HYjzT
	KfCdjOE92dl2VomBmlsK+9GvUEDReoP7fqM/Ql6fqsmlfSm9UxXv7GFXMSJf4MABl1Kk8VHqP4AGm
	KS3Bm0KzguRqM6sLw9MkQg43Xs27ORiPSm5YV13FfYgc7wrz9IhTxxedB/3NeikKtjKjWQifzsrWi
	gmrOIuEw==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
	by taras.nevrast.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <jeremy@azazel.net>)
	id 1uKkAr-003E8C-21;
	Thu, 29 May 2025 21:48:25 +0100
From: Jeremy Sowden <jeremy@azazel.net>
To: Jan Engelhardt <jengelh@inai.de>
Cc: Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH xtables-addons v2 0/3] Some fixes for v6.15
Date: Thu, 29 May 2025 21:48:01 +0100
Message-ID: <20250529204804.2417289-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false

Replace a couple of deprecated things that were removed in v6.15 and bump the
maximum supported version.

Changes since v1

  * Patch 2: add a bit more to the commit description, and change the version
    before which a `timer_delete` macro is defined.

Jeremy Sowden (3):
  build: replace obsolete `EXTRA_CFLAGS`
  xt_pknock: replace obsolete `del_timer`
  build: bump max. supported version to 6.15

 configure.ac                  | 2 +-
 extensions/ACCOUNT/Kbuild     | 2 +-
 extensions/pknock/Kbuild      | 2 +-
 extensions/pknock/xt_pknock.c | 8 ++++++--
 4 files changed, 9 insertions(+), 5 deletions(-)

-- 
2.47.2

