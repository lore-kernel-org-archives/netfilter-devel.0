Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A27B185935
	for <netfilter-devel@vger.kernel.org>; Wed, 19 Mar 2025 14:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394581; cv=none; b=ALDkHSP64FAMmCpgNGlGge+Tp0nVhCKzI17KDjdLEQtvFsZfEfIqUegKhE+qaR2Osc2/paX38srU0BP+G6PpYtGtuWVcx06tkfUwGwcZqeAZ7cXFVl0uICYYIsxAlkyIX9A86lrEaJgwL0w/EYPfXYhN8nTqMooKnSzhWT3ouOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394581; c=relaxed/simple;
	bh=gazmo6NwF/sHCV7Zbw1D+efjBofgzxwfiw/f5M2BubI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=oX6x7wwYCoIP/+hLFKr1blVg/nELadzOLuqXY2MdBZy2ard1j8d0gNXdQTE3tZo12xzHmD+8ZGOR4PqqjkzFciLpdHl3ssVF+H8aFuELsU/QU+L7Dwhj8zmGo+47r9qA1oPK8LgvhXQA5tAuMGbJPNEE4+yOqi0/vYqYr7JGyUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=N0Ed9HQy; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N0Ed9HQy"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-22359001f1aso24519535ad.3
        for <netfilter-devel@vger.kernel.org>; Wed, 19 Mar 2025 07:29:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742394579; x=1742999379; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=WpAt6wpiwp3ezTeZ92ooU3snfEEf5gKMTE98IChsc4w=;
        b=N0Ed9HQyBc5ucAN04JRC3Fo2ROR0uZQDK32ERFNnuIoMKGRewwkefDQh457yVGJRRb
         zgMZwR9xU1S/7MZ0vjap6cFXh2dAd3swyGYyVFqy3a0qhHEXCQyZE5aV06bBvagNsLiL
         1IIGxYL65BXFcRMwA5pMg+QeRi7I6iWqIp0R+COn4LCsl79ypsxVWbQM7CT/jKUsz7hA
         fIUffsBjWOgJ8fpN08KgCwBo5nTnpsaXzHZfkXc5BlbHHJsa380AQ+peO4k+gPuPgCtU
         Wz7yhMbtvBKk2/wiOSIy9ZMXFIdk7tj457Ojiw13ixNkGQ6sDV40h23qjTjH7iyR0fH2
         LKUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742394579; x=1742999379;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WpAt6wpiwp3ezTeZ92ooU3snfEEf5gKMTE98IChsc4w=;
        b=buh6qmiJgQwo1eFJeoP1ks9CYYAMFhxgQYNPd3vwVJMg1olkY7R1ruHcbRGUki0bmV
         vBsdCb3a5V1DaZBcaELH13v7JRaj9nDmELi9V69B7k5bIQJ/Fc3Q+Za2XqZPsAx6zNNq
         QhsgX02Vg2wtdeHphy8/1osPv1Zgan1ZLuzfaVZm/Wa031njPPaC699saBYqpRXq/bNC
         wWllWDhS8KOTbPxbZPAbh0iZN0rExJiBfB2vZmAieIIzmTXC4qViKFAKkY88pKCgjk/Y
         vye/fFXrED+7WfbSjJ74Kqae/a8Nq0rtZbO+iOWY3h3BH5DIgthlB6alHs49EzgNEkW9
         yIyQ==
X-Gm-Message-State: AOJu0YwkSNFhzky+TyG1FC6WV6NEp3kGn57zj2pRGdpu9RPLV3hh38cX
	pznIEOuCVNbBdy7whljl57CIZyCgdlAR2E/9AkKaBH14fYOyPSHoCDHiAA==
X-Gm-Gg: ASbGncswaFYcpAG2mu2fPQg7SeecdZeG47mMc9d15AhxCEWVBfr22llYdZkUjJqqH+c
	qjfogzxf07JfAFJaYbA7RyXFdzRTrAOpSBW4J8Mhg/I2V4iMZB5awGaJ4e5RIO7G6dWHWgKYW4Q
	jegInVMIw8BkbnqPVvF53fzVyTA9GFK00KPiE6hwCVfugq2PjVi5i9r9O2/stR6j2aCh7y6Hfd5
	tBXe6SnKOkhJpiiZpDfaPwn/Trej61zJRTKCyZEZqQb2pvTqYn4NOVYHk6f7rwPT6rPOtOjCNXp
	bD75r5TrjspJmdgtxOq7elkp86DypKmN
X-Google-Smtp-Source: AGHT+IFbdMFPH+T6FxrkHC6cup4qf6yIesCqQG3HoPVAYhLaPvT4m9zXQewle4v/baVn30b9JI8RGw==
X-Received: by 2002:a17:903:94d:b0:224:584:6f04 with SMTP id d9443c01a7336-22649932705mr37063515ad.18.1742394578616;
        Wed, 19 Mar 2025 07:29:38 -0700 (PDT)
Received: from fire.. ([220.181.41.17])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-225c688da8csm114906225ad.48.2025.03.19.07.29.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Mar 2025 07:29:38 -0700 (PDT)
From: Zhongqiu Duan <dzq.aishenghu0@gmail.com>
To: netfilter-devel@vger.kernel.org
Cc: Zhongqiu Duan <dzq.aishenghu0@gmail.com>
Subject: [PATCH libnftnl] expr: ct: print key name of id field
Date: Wed, 19 Mar 2025 14:29:27 +0000
Message-ID: <20250319142927.124941-1-dzq.aishenghu0@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fixes: 005369151ed5 ("include: updated nf_tables.h")
Signed-off-by: Zhongqiu Duan <dzq.aishenghu0@gmail.com>
---
 src/expr/ct.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/expr/ct.c b/src/expr/ct.c
index 1c46dd97ba6c..8f8c2a6e7371 100644
--- a/src/expr/ct.c
+++ b/src/expr/ct.c
@@ -171,7 +171,7 @@ static const char *ctkey2str_array[NFT_CT_MAX + 1] = {
 
 static const char *ctkey2str(uint32_t ctkey)
 {
-	if (ctkey >= NFT_CT_MAX)
+	if (ctkey > NFT_CT_MAX)
 		return "unknown";
 
 	return ctkey2str_array[ctkey];
-- 
2.43.0

