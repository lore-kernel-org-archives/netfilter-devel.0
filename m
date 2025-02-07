Received: from azazel.net (taras.nevrast.org [35.176.194.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D818671747
	for <netfilter-devel@vger.kernel.org>; Fri,  7 Feb 2025 20:47:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.176.194.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738961276; cv=none; b=EXHnJpjXK2hxRMtN+rvGbJ34xkMkWExRNcvzb9KG+18o9WE9zU3r2w5p9S0j50WExuWrQWQ0ZsPP7V1iPvzhPk2gt8deHyz1gOPbZ2u/Bmc+N8d/9IC4GoZZcYbPYzRbwGUaYkRSbdVKKEHo9+R/XBDST76EBPihJcictLJpMDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738961276; c=relaxed/simple;
	bh=5r22IgObWIFpj3bo7pMoM0z52Arpxc94ylO+uoVraHU=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=ArFC3mEJqlbOJdryz82aQdhKXoYl9VzRBAFz9kcH4NaFGEdtpOe1YjUlS3C3tYcLejS0dNWB60kpoNxeoBFNmD3WkWPHnunCtQ4sTDMHTHnQdOUJY1eXRpy4vOpFnWZARszbxUYjpvnSnETBWLr7pFvANHcWNwxT4WURRHCctFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net; spf=pass smtp.mailfrom=azazel.net; dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b=HNpfwKjf; arc=none smtp.client-ip=35.176.194.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=azazel.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="HNpfwKjf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
	s=20220717; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=QyE3ZWl/UyMNbjYFoKe+hoPaD8mbYb2k9LVdUnnZLi4=; b=HNpfwKjfnuVET2asdKBUBnnmmb
	VlkMR67yX2WO6Cj7qB+njJl+V2ZpEK8U3ohHNLld0aed9QJpnk2ywovS9OQIA3zTQT2oo6ArOaUmQ
	EkOuTi+kJaBVWDdDiShM/V2sWMWsPk4TGy3jSKGKmeOvfdGcYCoBIIC6MwgfcrDkvHCgK5EtyXp0p
	bL4k08tRH7N0febadeveGJkTGecEVZsjNSbH0NckMbsdIk38JDYFmTObgHC+CZvWOPf5jwfjbrgVt
	ild6dywTavkTjPzuYh1RKEnUsRS8mg48gPsBw3aRl0YTFmY3XF/nsnqziYoKMBDENSooJ5WGj4rCR
	aWc08lMA==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
	by taras.nevrast.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <jeremy@azazel.net>)
	id 1tgUeB-00BgIB-0W
	for netfilter-devel@vger.kernel.org;
	Fri, 07 Feb 2025 20:08:19 +0000
From: Jeremy Sowden <jeremy@azazel.net>
To: Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH ipset 1/2] Correct typo in man-page
Date: Fri,  7 Feb 2025 20:08:12 +0000
Message-ID: <20250207200813.9657-1-jeremy@azazel.net>
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

"This values is ..." should be "This value is ...".

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 src/ipset.8 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/ipset.8 b/src/ipset.8
index 04febdadcde0..b897059f3da2 100644
--- a/src/ipset.8
+++ b/src/ipset.8
@@ -925,7 +925,7 @@ The \fBhash:ip,mark\fR set type uses a hash to store IP address and packet mark
 Optional \fBcreate\fR options:
 .TP
 \fBmarkmask\fR \fIvalue\fR
-Allows you to set bits you are interested in the packet mark. This values is then used to perform bitwise AND operation for every mark added.
+Allows you to set bits you are interested in the packet mark. This value is then used to perform bitwise AND operation for every mark added.
 markmask can be any value between 1 and 4294967295, by default all 32 bits are set.
 .PP
 The
-- 
2.47.2

