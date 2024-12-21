Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17F747DA6D
	for <netfilter-devel@vger.kernel.org>; Sat, 21 Dec 2024 03:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734750841; cv=none; b=V5PZcksQJqxhd3b/U3IFUeLhYuwyzJIUQ4oc6P6Blk2q9mwZ+1Te9rmOi5xp2zligWEvFoA5Q3VDszmRMqBJbHjGPOLBt4TsNTMTLdXItl71aH1PtoTJxikYzZ+FQItDkiQmacmOmyI3gqxun8OLgx5zJz+bCu5zm9RH+dqwp7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734750841; c=relaxed/simple;
	bh=rWJWinFudd9i0hejDiXqEG1dHkSS62RB3cYB4coWZT4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=r4Rnjg7BENfNmpO5VsqdKdkheStJI6IMtcPwCea31qM+Zd0p8yxuLIPqB4QRcS2UIVtI/2hywMuZyiHN+Jxq8zMrqO3HVm2O8dPLFLV7w7/qNxrTjyOMKpXvH7Vd7j0MPYFxoxubldElXl/7iy7ElfzjyMa2mbYUXc1YWC17mAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=U3qrWnCm; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="U3qrWnCm"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-21619108a6bso22014295ad.3
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Dec 2024 19:13:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1734750839; x=1735355639; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mgd6nOJpMQGRniqUrvlxk3+sVV7Z2KJZ3GssnyV1eeY=;
        b=U3qrWnCmE9EFzaJqEWWrsg14/TK/9fM6dTjTDb4inwGOcIFsBsqTk39SbvccIcT6V2
         RrkBYLyKoLU7MQqRROH3LJpPW3J8nMolWnZ6Dkn4YpN86SIEIf8EKS7uWT90SC0PE5+t
         Wfi1B2PmoyNVA5JqjPWpMBj2Wlv1ERtn21S2RJ+aXOA61mX1ohrQpRrk6KcNvbzu6iUZ
         LI0RufhyRkXq00IhLSFF/idtEXtLnc9OMG6mk3Zyst8ilugvO0cNNfMi3VIsPqUmy0aa
         4m1Ppwx3a1fECDtxYWxjv92ai4ukzArwbWjGRIR6+/clctO0cPeQlNGEg+voh9QHhRIQ
         sYbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734750839; x=1735355639;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=mgd6nOJpMQGRniqUrvlxk3+sVV7Z2KJZ3GssnyV1eeY=;
        b=vVTE9kn5uXdwkmLbdXIqfYBIkFK8U6KV+pYq0RVmQro8W60H9Ze5VNsYl44zC86SdX
         0N6tp3BFE+kli6zValLPcq9ZZ3vp9aTC9d5f2PPiVKOt9vvF5XVkSVKmgNpQgTpZf6sb
         yL2005PGC87orvackx5UEGPU2ZooY0h80Ce0OVuL14r1XK5zFJmWeCh/qC0So9tNNs2f
         zPI9y8dwBdZ7/XwITaXCuijY+h26I5aJ+YfB+1j2vNnPWVuqutwsqaaDW0vrBmqT76XG
         g4NnjgwIzHQHzPNmzwo0E/LvnN1GdVYkm4VjgZiqpg3JHdvxlf5jXdrrXpb25dDzwBUD
         2CjQ==
X-Gm-Message-State: AOJu0Yxc9ZspwcJ4fZ/GJhBvPcF8/XBuCubH6hNYhbeJ9O4Rw4vs9Zr7
	v66kDe1ePC/ifRizWgmhYrBigBO5b2K/XhUWMDi8eBAe+UpLYi5C
X-Gm-Gg: ASbGncvR92+31HQIwcSRjzaS9EXBFUtXDaqurWnOysGqS2k9/nZ2UaMt9hE9onmvgQa
	GBUb8AeM9jZSrm46P2DwFF/KzxmkXROaP/hh9fHB1oh9uBejksPEl1HZThDmzM8zJ+EqpFGjZb0
	UU+sT5e7vWvDTeeUP8QdNxZF5EiK66JIJ9DLCstxPbRBNS71S2ByWOqhsdoOWxcShVz3Pi9QKmH
	mudpR2GmKtU7MBohlzlQhRvgIo+8ONR7xEOubhBwnWYn+qCVkG0IW/ulTlG2JiMiUqN4tseeL5a
	4Q3eySdoTIqqmj8EJa4I2CqprMqgK+jurJ/IdkejtA==
X-Google-Smtp-Source: AGHT+IEVzHkiuAAee4t849dWqdoiMFCnV3opbZl3WZYb13Jj14MsUQQgEWhJfq+uE1+5G2uNyCyPxQ==
X-Received: by 2002:a17:902:f7d1:b0:216:5b64:90f6 with SMTP id d9443c01a7336-219e6f0e6b7mr59196475ad.45.1734750839435;
        Fri, 20 Dec 2024 19:13:59 -0800 (PST)
Received: from slk15.local.net (n175-33-111-144.meb22.vic.optusnet.com.au. [175.33.111.144])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-219dc964e92sm35909545ad.18.2024.12.20.19.13.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Dec 2024 19:13:58 -0800 (PST)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From: Duncan Roe <duncan_roe@optusnet.com.au>
To: pablo@netfilter.org,
	dunc@dimstar.local.net
Cc: netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue 2/2] build: doc: Fix `fprintf` in man pages from using single quotes
Date: Sat, 21 Dec 2024 14:13:49 +1100
Message-Id: <20241221031349.18922-2-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.35.8
In-Reply-To: <20241221031349.18922-1-duncan_roe@optusnet.com.au>
References: <20241221031349.18922-1-duncan_roe@optusnet.com.au>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For example, `man nfq_open` shows
  fprintf(stderr, 'error during nfq_open()\n');
where the single-quotes should be double-quotes (and are in the HTML).
This doxygen bug appeared in doxygen 1.9.2.
It is fixed in doxygen 1.13.0 (not yet released).

Fixes: 088c883bd1ca ("build: doc: Update build_man.sh for doxygen 1.9.2")
Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 doxygen/build_man.sh | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/doxygen/build_man.sh b/doxygen/build_man.sh
index a6531cb..8fda7ee 100755
--- a/doxygen/build_man.sh
+++ b/doxygen/build_man.sh
@@ -69,13 +69,19 @@ post_process(){
   #keep_me=nfq_icmp_get_hdr.3
   #do_diagnostics
 
-  # Decide if we need to fix rendering of verbatim "\n"
+  # Record doxygen version
   i=$(doxygen --version)
   doxymajor=$(echo $i|cut -f1 -d.)
   doxyminor=$(echo $i|cut -f2 -d.)
+
+  # Decide if we need to fix rendering of verbatim "\n"
   [ $doxymajor -eq 1 -a $doxyminor -lt 9 ] &&
     fix_newlines=true || fix_newlines=false
-  #
+
+  # Decide if we need to fix double-to-single-quote conversion
+  [ $doxymajor -eq 1 -a $doxyminor -ge 9 -a $doxyminor < 13 ] &&
+    fix_quotes = true || fix_quotes=false
+
   # Work through the "real" man pages
   for target in $(ls -S | head -n$page_count)
   do grep -Eq "^\\.SH \"Function Documentation" $target || continue
@@ -90,6 +96,13 @@ post_process(){
       fix_double_blanks
       [ $# -ne 2 ] || insert_see_also $@
 
+      # Work around doxygen bugs (doxygen version-specific)
+
+      # Best effort: \" becomes \'
+      #              Only do lines with some kind of printf,
+      #              since other single quotes might be OK as-is.
+      $fix_quotes && sed -i '/printf/s/'\''/"/g' $target
+
       # Fix rendering of verbatim "\n" (in code snippets)
       $fix_newlines && sed -i 's/\\n/\\\\n/' $target
     }&
-- 
2.46.2

