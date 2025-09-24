Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9210E1B423C
	for <netfilter-devel@vger.kernel.org>; Wed, 24 Sep 2025 22:21:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758752496; cv=none; b=AQX/qNAzWJEihZI2rLPxj5/rUbs5CYD4lyRZLVCBPB7we4qgr53eqUarTrY75HHEBbPgh8qg+nAOjl6UvI4MnIqAQcARGOEMPxmgnts4ob5oPhoYT3dHikU8AZslMzYYIRFhsttcwVFdheDjfB+PL85t6LF3MhXKGbFL3zi4e6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758752496; c=relaxed/simple;
	bh=D6gwSRshnvE5UwvngQ/b/ph0TYJNCwWI9Nk0O394YJg=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=Q+syq59zY36hDqcqFu8k8huupxavq7MhqUc2hL0Sq304MObBbyPaqRwuHfw6e1FID2pbzGX1tNRguL0ETy27wxo8FQIA9eoBsoVMeScrKkZ9cm92YnvAOVRne91Oh4V3jQFlFkFr+Fs9Z/b44pGi+s9AysjCJukbkU4uX+AzYrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=rz5eeFDr; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=rz5eeFDr; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="rz5eeFDr";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="rz5eeFDr"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id BA99260264; Thu, 25 Sep 2025 00:21:23 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1758752483;
	bh=v9fRVGLZA+Yxe7HekI/YeOitPlpBdorjYSwTMfBr51A=;
	h=From:To:Subject:Date:From;
	b=rz5eeFDrdL3cgwJktmW48r4JuW/yJtFi/emYns/afgxBZmogaGrxwYBeubyW8497W
	 t/YSK/Iu8yRzyRnRsP3Y5/uihk66NIKutZ5tbZQ5T+liR4EdU/8TfBYs1G/pWTKfvN
	 LH/TZLdyp9G/vac5+fNUTLnYe2TzhAY5QrztXYU0Hig79VNtFQwQJnIIk6H0SopsxZ
	 PLhZYZdmSHEDK6nrKi3tRt2Fw4GFpe4aU5+RNtkLBd9U1kYfOXkw0KYHJTz15Sm9Sq
	 qcynet0ys2/puZVETdn4vww6sHLBd8T2zfB53E2Vs7JcdGy+sOo7loctdCKHcx3Mk6
	 nMJOESH0ACJgA==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 50DBF60262
	for <netfilter-devel@vger.kernel.org>; Thu, 25 Sep 2025 00:21:23 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1758752483;
	bh=v9fRVGLZA+Yxe7HekI/YeOitPlpBdorjYSwTMfBr51A=;
	h=From:To:Subject:Date:From;
	b=rz5eeFDrdL3cgwJktmW48r4JuW/yJtFi/emYns/afgxBZmogaGrxwYBeubyW8497W
	 t/YSK/Iu8yRzyRnRsP3Y5/uihk66NIKutZ5tbZQ5T+liR4EdU/8TfBYs1G/pWTKfvN
	 LH/TZLdyp9G/vac5+fNUTLnYe2TzhAY5QrztXYU0Hig79VNtFQwQJnIIk6H0SopsxZ
	 PLhZYZdmSHEDK6nrKi3tRt2Fw4GFpe4aU5+RNtkLBd9U1kYfOXkw0KYHJTz15Sm9Sq
	 qcynet0ys2/puZVETdn4vww6sHLBd8T2zfB53E2Vs7JcdGy+sOo7loctdCKHcx3Mk6
	 nMJOESH0ACJgA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft] libnftables: do not re-add default include directory in include search
Date: Thu, 25 Sep 2025 00:21:19 +0200
Message-Id: <20250924222119.191657-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Otherwise globbing might duplicate included files because
include_path_glob() is called twice.

Fixes: 7eb950a8e8fa ("libnftables: include canonical path to avoid duplicates")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/libnftables.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/src/libnftables.c b/src/libnftables.c
index c8293f77677f..9f6a1bc33539 100644
--- a/src/libnftables.c
+++ b/src/libnftables.c
@@ -176,6 +176,9 @@ static bool nft_ctx_find_include_path(struct nft_ctx *ctx, const char *path)
 			return true;
 	}
 
+	if (!strcmp(path, DEFAULT_INCLUDE_PATH))
+		return true;
+
 	return false;
 }
 
-- 
2.30.2

