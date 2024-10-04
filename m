Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41E40175AD
	for <netfilter-devel@vger.kernel.org>; Fri,  4 Oct 2024 04:06:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728014806; cv=none; b=gc7fftkZKtYE6yvbQ+CZbYnvAD9fMig0oqcnA9xhf0MdK2pDpPYB61y8UpWGC4FStA+CVmd8wLyoJtjSX2yyouPVvZxQR41aC6XZ3Ne0h6zJozwQmvmpibz3IHcQymhxE1JGDBZ+SZ0PQ0RHyTcEU2F2WbR/IaCXA+YhKpXFuGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728014806; c=relaxed/simple;
	bh=SkFUGu3RJgNDAgWWtzwpSX5jwjj/+lICGgY0vj31aq4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ZunQHWT2uepTw4/MxA1h9bE3BG6DM3tlnsyskd9q+bk5qG9QuiR6yiuGSOaju4Kyxv4tSoOhw/ZHSHvs2W6xsQkPPCccc6mAC5SW3LsmTtlHhNXd3qQ72Q1OOVAy3Xm0u6ZVASrvdmJuxpJKzBf6w/zPWfcXAQtcTQhvkY8124Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NUPi5TH2; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NUPi5TH2"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-20b84bfbdfcso18889365ad.0
        for <netfilter-devel@vger.kernel.org>; Thu, 03 Oct 2024 21:06:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728014805; x=1728619605; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=hQBl82AtYAODTlpLpocCCyvYuMbdLpJ8P3Deen4XcSw=;
        b=NUPi5TH2z+2uLvYRDQTtxAge8SnSReFcwz6J2B93JeqIFBHUnneOOVqG0xKwcc0Alr
         +5irmWiZ7j+jnYRATrFIv3vb1Qy4pV96DZTYLAr8kgQB2gpBbMMF4YLiRhwoGZZJIqkA
         qdzJKxw5marKmALqr6GvFNAuPKocQX3z3xK6AKzSL4T5AUAnl40twud+TVeiX927Qt9O
         O3wlCBwVJvwoy1IECmqVYNoYTcRNXHOh7lzYzI/nFvmew5prSsfcEQNxIy9R7OlBo8Pk
         IkVJOyOvOUhLmo9KaI89JuDGSFyOm0VYmUF6hjg0VGScN0rkrcY7zz33ggqbxu3Wcyhc
         IHNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728014805; x=1728619605;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hQBl82AtYAODTlpLpocCCyvYuMbdLpJ8P3Deen4XcSw=;
        b=ApaOZlS816H3imhIyDsOKvGOSrzKYcqkBxlw5BLX04lA9eP+Lw+Z8dZLqLwjo4s6Cr
         CV4za8nUQpr30+ChIXr9D/VoRhZC8UIWJhInYd/YTnBkAd3//54exH28HBxT7jcQYaMZ
         9gkdkFQkC09e1R6tQ/M5R5Ste70ElZeASC8FkK2NnkTdq6XSxzBruHCfM4ozWikmdLxi
         03EDv9qBl0OVaOldSlaI/sKUuznCNXngiH2n/iptjYEOj/t78ISicecN9n5DmWB54D0u
         3Og7b3z5o33KgC2JFxKmovDq2A21QtZDwlY8XdhVvQFUJ/J7uWtWhe5qAj5FTfdMeluo
         iDyg==
X-Gm-Message-State: AOJu0YzkHF8GDo3QJ08ntFzQ1aapZZU5udfPqNivNAoibu5uiNctiPs8
	Nrlovca2NVe52nlAxMC4vbhyoFcU+4WZ/fIRsHjyCICRho3f7w5gRD1sng==
X-Google-Smtp-Source: AGHT+IGXKIhFUC21ykR4WkidhwXujvB0E1tgLMA/pIQBLvHd9Qv2ZnyvuuL1lu9EuZr+zHrl1seLhA==
X-Received: by 2002:a17:903:41cb:b0:20b:a8ad:9b0c with SMTP id d9443c01a7336-20bff37b136mr21564035ad.3.1728014804590;
        Thu, 03 Oct 2024 21:06:44 -0700 (PDT)
Received: from slk15.local.net (n175-33-111-144.meb22.vic.optusnet.com.au. [175.33.111.144])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20bef707115sm16027105ad.267.2024.10.03.21.06.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Oct 2024 21:06:44 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From: Duncan Roe <duncan_roe@optusnet.com.au>
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue] build: add missing backslash to build_man.sh
Date: Fri,  4 Oct 2024 14:06:39 +1000
Message-Id: <20241004040639.14989-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.35.8
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Search for exact match of ".RI" had a '\' to escape '.' from the regexp
parser but was missing another '\' to escape the 1st '\' from shell.
Had not yet caused a problem but might as well do things correctly.

Fixes: 6d17e6daa175
Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 doxygen/build_man.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/doxygen/build_man.sh b/doxygen/build_man.sh
index c0124e2..8f1852a 100755
--- a/doxygen/build_man.sh
+++ b/doxygen/build_man.sh
@@ -43,7 +43,7 @@ rename_real_pages(){
   do
     j=$(ed -s $i <<////
 /Functions/+1;.#
-/^\.RI/;.#
+/^\\.RI/;.#
 .,.s/^.*\\\\fB//
 .,.s/\\\\.*//
 .,.w /dev/stdout
-- 
2.39.4

