Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BECA81B27D
	for <netfilter-devel@vger.kernel.org>; Mon,  9 Sep 2024 02:05:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725847502; cv=none; b=q13G0bkfPQNlHwsErdR4kqITrO+rRGnPkaE4mngb6mvDAofOXaZUnDsIWTNyHd7SRsmNwP3MMkhUxawksS/fELO7AUfRc79CMCHjihyJldF4iZN5Zerg/CTMbupY2HZzN1L4lfaahacYEMVtVA4VZGc8H5WmfCOyVO3F/xkRyyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725847502; c=relaxed/simple;
	bh=TN3/6D7pgAE7KvGZ4/yu7nzUsvlwvXxHf07yJ40981Y=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=XdEPqjLKiC+iBHYvBs+czmDzw130v38XKj1PJNaMOfUgp3LNl34LLeZKUYrh6l5O1lqRYAbuDCBO0pevW3+G1ueO1qEMML1ypzNUnC8HBRBd/IxxHWR0TD+Z0PmOvWwp7YLQtkixC1JoBI3D2sx4VF1YbV17iU7rc4TI+a2VyMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ck15R8J9; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ck15R8J9"
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-718d6ad6050so1905903b3a.0
        for <netfilter-devel@vger.kernel.org>; Sun, 08 Sep 2024 19:05:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725847500; x=1726452300; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=bkgIO8IWaPIgKI31NDJ5oBjLDgR8jvlGUnTKtpCrR6c=;
        b=ck15R8J93u70r3OBJ8T9HdwBvszN8cOc3k9Vo9nu6V+H2JZ15EZgtg/cpktVaHWVF8
         FSHAReHVogR7GeE8m3BdCdVtjMcMROI4zSdYJuwX0y5go/0o9W6QdEXyUAKPq4wGkS6u
         sTG2to5YjLIiY+lUIhW1BbI61ZOiRzW0Yes1O24xKxT6cjnyUBWT6/oeos6rwsD1rWxx
         0QyVRbcYolgY1dKv+5yFdQ82n96Tt9lvV2nql7jer3kovCyup3W05Kc0iepj79ujTgUf
         w7YjigW+ffjysl/7QTYyLmW/WYA6u8ELNpszi9u8JMHfyJF/3y2UzH/Lju0kcrVBoB7s
         XlrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725847500; x=1726452300;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bkgIO8IWaPIgKI31NDJ5oBjLDgR8jvlGUnTKtpCrR6c=;
        b=Su87xmlnd/XHN/n11IadeQ428f+ErbOqwjSglbISbQtTloIPsbpJxvgwDuS5jGdT5a
         BDn2gtPBo5jYWkwpGvalLiLueJWIdKfdERRkIKT8rd/gxxN6GeUOwi0iXuRMc7iSl+Tf
         x8kTkrY1vK+EJMmnn8mS696nr1z/Q8ZB2qXBV0RqOdAoyms78e0eXBzwdfAKLT6EyKy+
         gzNBO0JE0oea0bPn6d1OY74hp+Ojb8eDoIKP2gOdfkWbO1CUeI8eeQpBUe3T2wQqv4/Y
         zgpO9m2up8RgM2Qp/B0luw3uxFGIhITxw9PPdpjyacAHj+irHbhlhP1sypzZjGLgTwFw
         Hcuw==
X-Gm-Message-State: AOJu0YyPs318u4UendSPqGvTsMMxuFmsPEQ62G3pKPZEWeoHSp8dmdtK
	8zHeq9xxmpnnM2FXfWeT/xJHcn8oDtfXXvpFiCABrAWFpT0ml1hUxws98w==
X-Google-Smtp-Source: AGHT+IFvmeUA1OqpM/6CoKInCDFu6Fpbpm1d5jAOhJCB3LP3JKNTuwN1M8cVyZD2XAHzMlECGexg+Q==
X-Received: by 2002:a05:6a20:d806:b0:1cf:249c:72e6 with SMTP id adf61e73a8af0-1cf249c74bdmr11040497637.9.1725847499869;
        Sun, 08 Sep 2024 19:04:59 -0700 (PDT)
Received: from slk15.local.net (n175-33-111-144.meb22.vic.optusnet.com.au. [175.33.111.144])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20710e33477sm24669045ad.96.2024.09.08.19.04.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Sep 2024 19:04:59 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From: Duncan Roe <duncan_roe@optusnet.com.au>
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org
Subject: [PATCH libmnl] doc: Address warnings emitted by doxygen 1.12.0
Date: Mon,  9 Sep 2024 12:04:54 +1000
Message-Id: <20240909020454.20675-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.35.8
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Remove now-obsolete DOT_TRANSPARENT.
Add `nstats` to EXCLUDE_SYMBOLS (struct defined in example nfct-daemon.c).
While being about it, remove EXPORT_SYMBOL from EXCLUDE_SYMBOLS:
only INPUT_FILTER can suppress EXPORT_SYMBOL.

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 doxygen/doxygen.cfg.in | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/doxygen/doxygen.cfg.in b/doxygen/doxygen.cfg.in
index 24089ac..1c73f51 100644
--- a/doxygen/doxygen.cfg.in
+++ b/doxygen/doxygen.cfg.in
@@ -9,7 +9,7 @@ OPTIMIZE_OUTPUT_FOR_C  = YES
 INPUT                  = @top_srcdir@
 FILE_PATTERNS          = */src/*.c
 RECURSIVE              = YES
-EXCLUDE_SYMBOLS        = EXPORT_SYMBOL mnl_nlmsg_batch mnl_socket
+EXCLUDE_SYMBOLS        = mnl_nlmsg_batch mnl_socket nstats
 EXAMPLE_PATTERNS       =
 INPUT_FILTER           = "sed 's/EXPORT_SYMBOL//g'"
 SOURCE_BROWSER         = YES
@@ -20,4 +20,3 @@ LATEX_CMD_NAME         = latex
 GENERATE_MAN           = YES
 MAN_LINKS              = YES
 HAVE_DOT               = @HAVE_DOT@
-DOT_TRANSPARENT        = YES
-- 
2.39.4

