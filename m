Received: from azazel.net (taras.nevrast.org [35.176.194.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 833F61D79BE
	for <netfilter-devel@vger.kernel.org>; Sun,  9 Mar 2025 16:41:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.176.194.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741538521; cv=none; b=QVGawHB/K/R+YMC2I1Oxtppk1EBAoTFkHWMekwf5Y5/zPdPi1h3b/aOnTD5Ia8oIWyXWaHqwMSZX/ZQpdH4d3HNWHO/ciKYVbbg61E/A33y2qweOgHnyWvWTx8eY/HffVs6jYoXrUmUI+/67shaWCY0b/rsdWTIJKHrWRv1O3MQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741538521; c=relaxed/simple;
	bh=KsZaWIvfZ+yEb+GVV/DlCcGLoCcbt5lnUrux4wrybxE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XWZg+wHSzkhY2cp/t+HAXic9y4IEnwiNsWO37CZD2wrwO4gvjAxHCD3D5svyebSiV94Ljttwmzg4oJ6+EF7C+hWJswMzLy3e/ekHO9EMMrb0l9v+PP/TUPZR6WU+itpMeCULPtuexO5D3hquqwwUmFf8Xj1vFCeAz47s5uolCNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net; spf=pass smtp.mailfrom=azazel.net; dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b=m87bEW0a; arc=none smtp.client-ip=35.176.194.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=azazel.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="m87bEW0a"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
	s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Yj6J9oV82prlyEnwTH5ytIdoBjzWn2LYWAdpX91aLZw=; b=m87bEW0aotfaswb6LVcTxUeNsV
	rdAL93pD5TxsvHlam/YLBdFEWWy9bQ9BXEv9EALUdHQ+JGJ2fYZZ5Xn8eisnLQwLK7vWQdtlOq2VS
	8BEdtRjNa6Tst+H/liJ6IEmpSOeanCbcV2TtlAkjPr8hRKv1DaJfHj+aqRTDM3vVOowlgSnoKBQZF
	DtPUkJFXLn8C/KSvD56c2sKJM4QMyWQYQMJK3fWwrUuWLiJv3ddou10Y3w2w9aIFSeSFbmotxy1Tl
	LHS/4aC0hCv2h9DfGNBzR6hX8sXtX2LCHFHZwiYYoJqfF5mQ2t2rVaVG/4nsXMma5FQX82ySPYBV0
	n/HKbUrw==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
	by taras.nevrast.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <jeremy@azazel.net>)
	id 1trJip-00GJEH-1W;
	Sun, 09 Mar 2025 16:41:51 +0000
From: Jeremy Sowden <jeremy@azazel.net>
To: Jan Engelhardt <jengelh@inai.de>
Cc: Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH xtables-addons 2/2] build: clean `.*.oo.d` cpp dependency files
Date: Sun,  9 Mar 2025 16:41:28 +0000
Message-ID: <20250309164131.1890225-3-jeremy@azazel.net>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250309164131.1890225-1-jeremy@azazel.net>
References: <20250309164131.1890225-1-jeremy@azazel.net>
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

The `%.oo` recipe in Makefile.iptrules.in creates corresponding `.%.oo.d`
dependency files which are not cleaned up.  Add them to the files that are
removed by the `clean` target.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 Makefile.iptrules.in | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile.iptrules.in b/Makefile.iptrules.in
index 7e5816451736..016f0bec5f7c 100644
--- a/Makefile.iptrules.in
+++ b/Makefile.iptrules.in
@@ -47,7 +47,7 @@ install: ${targets}
 
 clean:
 	@for i in ${subdirs_list}; do ${MAKE} -C $$i $@ || exit $$?; done;
-	rm -f *.oo *.so;
+	rm -f *.oo .*.oo.d *.so;
 
 lib%.so: lib%.oo
 	${AM_V_CCLD}${CCLD} ${AM_LDFLAGS} -shared ${LDFLAGS} -o $@ $< ${libxtables_LIBS} ${LDLIBS};
-- 
2.47.2

