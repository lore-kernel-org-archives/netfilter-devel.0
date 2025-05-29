Received: from azazel.net (taras.nevrast.org [35.176.194.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09BA21386DA
	for <netfilter-devel@vger.kernel.org>; Thu, 29 May 2025 20:48:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.176.194.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748551709; cv=none; b=OFNNA1FIe9WIBZUyn0I0kKG41X0gqAIs1v7WNx2v+U9RGQIcHeSTu6aUThpWUAfw54q/Kx5s1lFgDF7bCLGeZqgUwhlppV1G+IZWX9jM9dw/n2NPGcNGm61Pbf+ISY2NNsw21/fXcwsLpOp/Wpli4FKSkItrUesEKwZk7fBpLN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748551709; c=relaxed/simple;
	bh=gmZBcy2ESMXjfTKO3w/829tMbNA07qf37FqmqiJx5BI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=utW+prmfjdRYTL59U4idELWMH3qZME+NxVZOKR2ESj7IsYJlpNdDdzzk6rfIQ0iiND0vcSjiTkhirz54KgVcLNXnC0RRvzw409egQJlZ2zprU3aqlZ9q0sCFhPNmt/ckeLSEqva76aRZscYJCvk3tcc0zdid8GEJeltC5joEIhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net; spf=pass smtp.mailfrom=azazel.net; dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b=ClwYpOTb; arc=none smtp.client-ip=35.176.194.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=azazel.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="ClwYpOTb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
	s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=YcjwPyXHx2WWhfDQmawOqWa1cn6LRWu4XlptNY25hM8=; b=ClwYpOTbqgZvfz+P+bv4L79GWl
	HDVMOUE27Xlm+R+cqJZALqB5y19B5d/2NkcCiypDIme3MMLI7YqraTCnxzKZ6XgCl8VN01mqRgEtl
	2WYE+ZZV8Lolf53Z03Yd7eAY7vopAn7zLGedXhUI0NUDwY5AtnbFyzb+rmXKS79Rpx1ULLhlLQhiG
	B2l51zgDNNvaYbltH43WhhFXiES4Rm30oEgPo343wHfT0+XfPa2CaLFIPolRUBz0gdwqNb6Nu7WUl
	VFvJA8v9n/MFVNxQQcl4ijuopuCxwr/GebSMdKXh3SipW+vULdlMn2ItZO6E+7E83hnOwAZ+q6StZ
	VVdnbyKw==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
	by taras.nevrast.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <jeremy@azazel.net>)
	id 1uKkAr-003E8C-2N;
	Thu, 29 May 2025 21:48:25 +0100
From: Jeremy Sowden <jeremy@azazel.net>
To: Jan Engelhardt <jengelh@inai.de>
Cc: Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH xtables-addons v2 3/3] build: bump max. supported version to 6.15
Date: Thu, 29 May 2025 21:48:04 +0100
Message-ID: <20250529204804.2417289-4-jeremy@azazel.net>
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

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 configure.ac | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/configure.ac b/configure.ac
index 7acbf61dd3a5..9dd484455dcc 100644
--- a/configure.ac
+++ b/configure.ac
@@ -63,7 +63,7 @@ AS_IF([test -n "$kbuilddir"], [
 		luck=0
 		unsup=0
 		AS_IF([test "$kmajor" -gt 6], [luck=1])
-		AS_IF([test "$kmajor" -eq 6 && test "$kminor" -gt 12], [luck=1])
+		AS_IF([test "$kmajor" -eq 6 && test "$kminor" -gt 15], [luck=1])
 		AS_IF([test "$kmajor" -eq 5 && test "$kminor" -lt 4], [unsup=1])
 		AS_IF([test "$kmajor" -lt 5], [unsup=1])
 		AS_IF([test "$luck" = 1], [
-- 
2.47.2

