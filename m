Received: from azazel.net (taras.nevrast.org [35.176.194.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB9A9219A8E
	for <netfilter-devel@vger.kernel.org>; Thu, 29 May 2025 20:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.176.194.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748550744; cv=none; b=txMHN05WkIKw0miOMl/UKe1vDsfcifKGB1CNDKdAR4JwVI2VaHCStbrUwARgRk5HD5CaozNo8AIrxNhLCGYGxpDmNhMigc7yrRIq+tJpE9q3BNdlqNDm4aA64TFChcvDph76EAQ+7laaxy7wIgHnCJFMs3/+3pQth9OwYaeQsG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748550744; c=relaxed/simple;
	bh=SoLgYvEZyQUpw3BVaoiXVxPU7avBJg9p+rAEC45Bi3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EoEyYTFAWI5f9F41LX1XxT6EM0vwl5atx69yTr3mEmrtLsERybuwAEC6fjflyfStwpmbr/FOPCJmIzFP1nmdAPWtyQsukywkORm5AIlZB1I4CDTzMj2Zg6l6pR8ZA5Y17h86fetBtmTQipILkf0tWfWC8o7s02TYeqw1wOHibC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net; spf=pass smtp.mailfrom=azazel.net; dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b=YfkkMSq2; arc=none smtp.client-ip=35.176.194.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=azazel.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="YfkkMSq2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
	s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=dMbYQQd+iFO89L9UgTcUc4hA5Fioz/4IHxUEf6QnOJ4=; b=YfkkMSq2ZxQGrRYjGI/XJTjUKa
	dOU42hNImgOWpQKa6+tueigxCAYGxMCYnhdAhE8yrrBRzUpMJ2l14SpDn34eaAinpiujG/c4NP+pV
	uAPadgbFVueAftN4kZfUM5V58ZzGeIep1q+XJNnZRCugJyNy1RdCRbL1sqLRQy90m3oFFNKR6vjb8
	oSVmZRaOCAcn2kgaua3iW/XClNJlQ/sNEyk0QJNzHGYcoTExCri5X5y5u2vEM11f/6zq7SojVkPD1
	sZhogt5fboiRyihElzViiQ24ZUHMI/aYutl/CPCRDAcw/NHUqoV8A+SqUV99VUTIxz9Q4zNI9aiya
	PmHEIgcg==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
	by taras.nevrast.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <jeremy@azazel.net>)
	id 1uKjvA-003Dw5-13;
	Thu, 29 May 2025 21:32:12 +0100
From: Jeremy Sowden <jeremy@azazel.net>
To: Jan Engelhardt <jengelh@inai.de>
Cc: Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH xtables-addons 1/3] build: replace obsolete `EXTRA_CFLAGS`
Date: Thu, 29 May 2025 21:31:44 +0100
Message-ID: <20250529203146.2415429-2-jeremy@azazel.net>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250529203146.2415429-1-jeremy@azazel.net>
References: <20250529203146.2415429-1-jeremy@azazel.net>
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

