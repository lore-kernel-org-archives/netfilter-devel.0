Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D74C4437
	for <netfilter-devel@vger.kernel.org>; Sat, 14 Sep 2024 05:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726293590; cv=none; b=Iqv4dy30NqLW7GUID17wcV0mBYtiD9JFM51PbYthVgG9GtE2qlokegpInSeuWRvW3rmdmvv+IBWWCTX2TS0BwHXH0ozD/HUjyEwqLynH/e0vTZxB46egfm16cTc1NQ5eY4TE44He740F/gWZquU2NCLRCmNAWKa5XRYKEgpB8Sg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726293590; c=relaxed/simple;
	bh=JQkzeYYLYIDWM0RjPbi5Z8xAR+gZGM0+bNMq2Z4Ch2g=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=nQbPdf+qb+bF8dGdLKDDpbGvXOslih8ur2EYO7p9kuNTUNZEa7oCp6SxigeaSllRy0V+rzlsgFKBRRxY3ZUKKh1FMWzCRSIGCkUExubj3bTQQohTI72pVzOpxknZ86hQgLFXaHLRYbrrKQULWEs4JMTF1emSXWb4uTWfgMcXAl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QJRoTtzj; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QJRoTtzj"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2068acc8a4fso15230115ad.1
        for <netfilter-devel@vger.kernel.org>; Fri, 13 Sep 2024 22:59:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1726293587; x=1726898387; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=MFCX2YJlgnHdMHmbHxPvSOMTnH15uDdw0IDEVMhrF+s=;
        b=QJRoTtzjq5OyFTtk6/UzsYQwsCLaaiMomBDxDD07Js6hqy0+SvDUs2eRL0NOIdIzNP
         r/88wSr0WJw/3D9xM1FKVS2Ma0Q7u/SF/myJzBLE7InZf7NGMmbGsDt7+EztAiwISWOv
         oksX2R6npw/k6zUoy+TJIKYdsOTZbKWeIyiQmCKRXlO6oy//EInZ1JXY/qVlycnulBQx
         MsLgE00UXpAQYr3NSwLP5xBJVrcuA3lW4Bxv+jGdXzEWYHDyvtI/DMvGWzYBBqvAr7Gc
         vxO/LxiHaQNl+jQe3FbjNwiNaMou03aPlnN8usFlztFHQL/Y0bmF+PRJJb2PL2q+jkcC
         af2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726293587; x=1726898387;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MFCX2YJlgnHdMHmbHxPvSOMTnH15uDdw0IDEVMhrF+s=;
        b=wTFZQVr0ousxQbGDm2tQ/+YRzj0FbJnczKx4OhaQKWRQgsYdxC3onairLSF8QTfWpC
         1BKZSxNunI8McZklK4/YK060l7t/MmKJWelAUtswctM0FkO/XlMGlW9g4DfIZorOUyDU
         QmZfS2YCzavHVKRH5cIClICs/QfKrQNfS0W6kpLx6VHz5deKEYgswObeiXIdAsliOBxH
         1VNxi/R37vnd7RbHMPNr1fSVcvyA0mfr5KH92YEZlxbjGtkhUz/NMDnx/fGxdnVLf1K4
         zMkcQm6kPwepxshjx90EsrlmvtI1Bh0v2M7jhcJMZjVJuAYyKyx3376osS3Wyc/dxL4L
         Vq1w==
X-Gm-Message-State: AOJu0YwtIp8oqHNtfhNzqPYwHyY/FizHwf9d3ZOKVAXsO752/bTzleRm
	zm5zEJXDd1mMBKRsl9dOcuV00SLJdArdNuLYHnZ/ws5JbWjdZRK/764HvA==
X-Google-Smtp-Source: AGHT+IGszdcAtSTmv0nmqFQkM5MlpFqR6eHAB5ebWgtPgMJTd18M5QhTINxd8lQzvx20rnjJK9sUqw==
X-Received: by 2002:a17:903:2302:b0:205:8cde:34c3 with SMTP id d9443c01a7336-20782c078c9mr76999425ad.54.1726293587149;
        Fri, 13 Sep 2024 22:59:47 -0700 (PDT)
Received: from slk15.local.net (n175-33-111-144.meb22.vic.optusnet.com.au. [175.33.111.144])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-207946f721dsm4348495ad.188.2024.09.13.22.59.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Sep 2024 22:59:46 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From: Duncan Roe <duncan_roe@optusnet.com.au>
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue] doc: Install libnetfilter_queue.7 man page
Date: Sat, 14 Sep 2024 15:59:41 +1000
Message-Id: <20240914055941.25624-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.35.8
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

doxygen/Makefile.am now installs libnetfilter_queue.7 in the man tree.

Fixes: b35f537bd69b ("make the HTML main page available as `man 7 libnetfilter_queue`")
Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 doxygen/Makefile.am | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/doxygen/Makefile.am b/doxygen/Makefile.am
index 68be963..d3f8593 100644
--- a/doxygen/Makefile.am
+++ b/doxygen/Makefile.am
@@ -27,9 +27,11 @@ clean-local:
 	rm -rf man html
 install-data-local:
 if BUILD_MAN
-	mkdir -p $(DESTDIR)$(mandir)/man3
+	mkdir -p $(DESTDIR)$(mandir)/man3 $(DESTDIR)$(mandir)/man7
 	cp --no-dereference --preserve=links,mode,timestamps man/man3/*.3\
 	  $(DESTDIR)$(mandir)/man3/
+	cp --no-dereference --preserve=links,mode,timestamps man/man7/*.7\
+	  $(DESTDIR)$(mandir)/man7/
 endif
 if BUILD_HTML
 	mkdir  -p $(DESTDIR)$(htmldir)
-- 
2.39.4

