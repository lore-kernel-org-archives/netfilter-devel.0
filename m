Received: from azazel.net (taras.nevrast.org [35.176.194.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09C0822A811
	for <netfilter-devel@vger.kernel.org>; Thu, 29 May 2025 20:48:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.176.194.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748551709; cv=none; b=KsqOPJnlOpaf/Qdmf6r/apJ1YWHh3JGL0vaQjQioreIGp3W5litqOyGTzn7IB/FTcOe7vOq3eBumekjfqT6MxB456jtQnr6YhdJT9H3TJ7PPpdF+ht1XQvSkEZ4wt96MkXcP90BmK8PiMdwk07eSYzA/ShbwgFZ7fKQMGYn/EVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748551709; c=relaxed/simple;
	bh=SoLgYvEZyQUpw3BVaoiXVxPU7avBJg9p+rAEC45Bi3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZVEIebj31LqzwuhPcrsFVwpaQO0s8XRkcoM+wUNXTfcgujsHPEEOr2+d4LWyWQLDliKjP/jeQAcU7F6URdY+mKou7rdOX511vvu701y0HtvtxqQ8KXr4zUeIqd6KB2y7O3YEAfgRWcBUY/bL9m+hX2K+5Ym5mdnX9j7Fc77kCz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net; spf=pass smtp.mailfrom=azazel.net; dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b=Gmb1T1YG; arc=none smtp.client-ip=35.176.194.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=azazel.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="Gmb1T1YG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
	s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=dMbYQQd+iFO89L9UgTcUc4hA5Fioz/4IHxUEf6QnOJ4=; b=Gmb1T1YGQRJjuYJPp8UkvqHVao
	0pozTq3odmX0sRYB2dG9moH0yAKZvkqvpXO86TFTYQ/rQB4XUevxCt/FEcJAYYavFoJI5wm8YF4bu
	EXXV3Qr5QFmuZgui7dcLyCsHOTUPGwOpG6RchmVY8zEU/4LDctirazmipl0EnWe4XB0NMdX8yvfBq
	FuOYJMXD2SBB7HS6PxS5WhsmCNSTqyY9NBMThR+kIuveLmqfjQuyVnrg3xY618lVMSkYO9HXhSUC2
	ptiIr4JuAzTcVvfe8ouiv6OWsOeIxPiuDfNAItyiaDFN8B7dOQm3HwIpucmHc1ge03S9W2l/T8UOq
	pfiJPMag==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
	by taras.nevrast.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <jeremy@azazel.net>)
	id 1uKkAr-003E8C-29;
	Thu, 29 May 2025 21:48:25 +0100
From: Jeremy Sowden <jeremy@azazel.net>
To: Jan Engelhardt <jengelh@inai.de>
Cc: Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH xtables-addons v2 1/3] build: replace obsolete `EXTRA_CFLAGS`
Date: Thu, 29 May 2025 21:48:02 +0100
Message-ID: <20250529204804.2417289-2-jeremy@azazel.net>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250529204804.2417289-1-jeremy@azazel.net>
References: <20250529204804.2417289-1-jeremy@azazel.net>
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

`EXTRA_CFLAGS` was superseded by `ccflags-y`, introduced in 2007, and it has
been removed in v6.15.  Replace it.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 extensions/ACCOUNT/Kbuild | 2 +-
 extensions/pknock/Kbuild  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/extensions/ACCOUNT/Kbuild b/extensions/ACCOUNT/Kbuild
index e71e80bb649f..fa3349ab3e54 100644
--- a/extensions/ACCOUNT/Kbuild
+++ b/extensions/ACCOUNT/Kbuild
@@ -1,5 +1,5 @@
 # -*- Makefile -*-
 
-EXTRA_CFLAGS = -I${src}/..
+ccflags-y += -I${src}/..
 
 obj-m += xt_ACCOUNT.o
diff --git a/extensions/pknock/Kbuild b/extensions/pknock/Kbuild
index 6318ca52a78e..d39eaca4a73a 100644
--- a/extensions/pknock/Kbuild
+++ b/extensions/pknock/Kbuild
@@ -1,5 +1,5 @@
 # -*- Makefile -*-
 
-EXTRA_CFLAGS = -I${src}/..
+ccflags-y += -I${src}/..
 
 obj-m += xt_pknock.o
-- 
2.47.2

