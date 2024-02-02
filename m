Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C41A923C5
	for <netfilter-devel@vger.kernel.org>; Fri,  2 Feb 2024 13:53:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706881998; cv=none; b=DYdSMSrRaUHaEde8u83noHJvhdXyZv++qJcnqCGjObAMQIGe83hCI4fgfILAboZNFvXfekCrzNRwSP5/6mewSwdSYnw0tAh0pC6VB7ZR2yeEld9kKoTa656CIyP1LhXElBN3TZ+NvRj+7l671Y6vIW2MxZKdKLdqNq7i692h0fI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706881998; c=relaxed/simple;
	bh=0JlAXB8X4JpPVcMuQCROpKHXLO+TNzrjSPv3NKqZlhM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K84QOSMD6JmANOAnV4G/LdoJT4Av7l8KDk72oc1G1ig3kgcV174cgRFV4dedhxTI5rSF1zaFcRZOP+BShZusxOXy2zZaP2vLbUxDFGfi81+mWy0nulsngHp3ZipuJiq2tSqkA4n8LyLJ60sNl+QF9reXbsALuJ29BY3Zbz+/3vs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=o5z8Dchd; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="o5z8Dchd"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=8XaP0LiTppFyTAI3jlue/xLeY+9qXgjKw3/yPjbbveI=; b=o5z8DchdJRFVLDiIu8UGNn+91R
	g1sSX5LsamlDhhafS43hKbPe73qwOfEY/2ih5gWgb6qhVMYs2aQwKXQnro3XbAZB6GEk2Uxx+KfVN
	iii7m6YRbjYAUyBowSS0uPKsHcoztrowffjF2o8AbRUdn2gsj7UtkTGCy/g67mFfAd2bYY6W+fEHF
	gg6UCxMgkxdlVVTHMy20MhHuV0FPFCGfB1hPM1taibe2ln5YGVdWqRgSiz6ABYYeX7WNnnfni/Mk8
	HEDCOXfNxNmKHlrc2r86zl0LLYfRF7NG3ccOlXM7VRezzQN05a47o4UVkawXkKtVSz5SoenO9zbmq
	GAp9pPkA==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97)
	(envelope-from <phil@nwl.cc>)
	id 1rVtye-000000003BE-1MQU;
	Fri, 02 Feb 2024 14:53:08 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Cc: Florian Westphal <fw@strlen.de>
Subject: [iptables PATCH 09/12] extensions: ipcomp: Save inverted full ranges
Date: Fri,  2 Feb 2024 14:53:04 +0100
Message-ID: <20240202135307.25331-10-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240202135307.25331-1-phil@nwl.cc>
References: <20240202135307.25331-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fixes: 0bb8765cc28cf ("iptables: Add IPv4/6 IPcomp match support")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libxt_ipcomp.c | 7 ++++---
 extensions/libxt_ipcomp.t | 2 +-
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/extensions/libxt_ipcomp.c b/extensions/libxt_ipcomp.c
index 4171c4a1c4eb7..961c17e584933 100644
--- a/extensions/libxt_ipcomp.c
+++ b/extensions/libxt_ipcomp.c
@@ -76,11 +76,12 @@ static void comp_print(const void *ip, const struct xt_entry_match *match,
 static void comp_save(const void *ip, const struct xt_entry_match *match)
 {
 	const struct xt_ipcomp *compinfo = (struct xt_ipcomp *)match->data;
+	bool inv_spi = compinfo->invflags & XT_IPCOMP_INV_SPI;
 
 	if (!(compinfo->spis[0] == 0
-	    && compinfo->spis[1] == 0xFFFFFFFF)) {
-		printf("%s --ipcompspi ",
-			(compinfo->invflags & XT_IPCOMP_INV_SPI) ? " !" : "");
+	    && compinfo->spis[1] == UINT32_MAX
+	    && !inv_spi)) {
+		printf("%s --ipcompspi ", inv_spi ? " !" : "");
 		if (compinfo->spis[0]
 		    != compinfo->spis[1])
 			printf("%u:%u",
diff --git a/extensions/libxt_ipcomp.t b/extensions/libxt_ipcomp.t
index 375f885a708d9..e25695c6912be 100644
--- a/extensions/libxt_ipcomp.t
+++ b/extensions/libxt_ipcomp.t
@@ -2,7 +2,7 @@
 -p ipcomp -m ipcomp --ipcompspi 18 -j DROP;=;OK
 -p ipcomp -m ipcomp ! --ipcompspi 18 -j ACCEPT;=;OK
 -p ipcomp -m ipcomp --ipcompspi :;-p ipcomp -m ipcomp;OK
--p ipcomp -m ipcomp ! --ipcompspi :;-p ipcomp -m ipcomp;OK
+-p ipcomp -m ipcomp ! --ipcompspi :;-p ipcomp -m ipcomp ! --ipcompspi 0:4294967295;OK
 -p ipcomp -m ipcomp --ipcompspi :4;-p ipcomp -m ipcomp --ipcompspi 0:4;OK
 -p ipcomp -m ipcomp --ipcompspi 4:;-p ipcomp -m ipcomp --ipcompspi 4:4294967295;OK
 -p ipcomp -m ipcomp --ipcompspi 3:4;=;OK
-- 
2.43.0

