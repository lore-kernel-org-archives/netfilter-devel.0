Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA55114016
	for <netfilter-devel@vger.kernel.org>; Fri, 15 Mar 2024 07:34:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710488085; cv=none; b=Kf9xlBnNmAFe6cnW9EK9mwa7yZEkMHp10HXH7jwp+UZOt9/cRIxnqlZQPONQV9MezFcPKF9fWUgGbQmFCEGkel3vBy09oXK5JHhtET7kubYZZlfAOr4KPO3OYd7iZ+qlJ/9hp7qKdLdDtBbm4++2xDlzMDNsvUURbQcE+U9rZb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710488085; c=relaxed/simple;
	bh=FMIA9PO8sFTz1Lkwzhwb64RzgaOjgbTQC0Vyd5T8Foo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=IRmX3eIsCDnsSlOAuv/w7I9Cd8DtdrHiX1LGZJnLcFBKBMyVKCosRttB5SITopJu+DKp5ZGNkfKEqxU63Q/Z6I+/cotdN4pBD79CYovhjiYJBoOaA7XyxelU/wnB66rad5vYpfoU+dLJAW2gn/f15+5KjzrltW+vGLGE/pfwUJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=X88HdVQj; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="X88HdVQj"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-1d944e8f367so13885795ad.0
        for <netfilter-devel@vger.kernel.org>; Fri, 15 Mar 2024 00:34:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710488083; x=1711092883; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lR0bANtSE7BQd6I72tiAtvxv3ABDzWcBU7w9Z+Bh01I=;
        b=X88HdVQjTmQbysG0UiSnf34twDRBy3kquX+rDXXvbPy55MgfA8R2fygTE+K/ofYzfJ
         WrlIkPFxmBdSdB6dFW03r/KJDKl2luf3h8fDBj1xA8IK/GUEx5eaShJAjxBs3W4bjuCq
         IGBJL6exL63i0wandbLwBVkjFlLtRzRVkU5sETb7DvV1c1sR6jfsJF3ksUkqe+SizzvM
         EOZ7qTKBB5wO9Hcss3IsDNlanieGkDN0v53trk5r+xR9a66oxDY9HON5FhxXlzVFuxSK
         dEzDUlDwfi3zhr2k+jeFprL338T5+0f1NjZwdFxEdxpled9K4DhWQ7kqSlKfbzAgKnBK
         B9Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710488083; x=1711092883;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lR0bANtSE7BQd6I72tiAtvxv3ABDzWcBU7w9Z+Bh01I=;
        b=Us65UrXEhS+lzloWuHTv0kh6z6fsUPn1o/kFFzcfmrJz0ecKjlhW3nbydc6lfT4SgN
         tkn86Y4eWBDGoKW0++i/CfR7bope0jhf0VMTYo4KVt23YowYd9iGYsLGSYt8Ju8g6F5H
         QGfiD9ftIqHQ/9d9UWQdrdzLSfUMXNn42XmKrvvnyBXAA/GdBV/9YhI+wv8m3cU6Jtdk
         wd46d+CRwWLdxOIAPFch+ozbAhJNB+sM7XxUpPu+D/yxhpZm5lWPZIfSoNJQaM7iUw5k
         VIyxYTjmEaZGS4hH/IzCQQ2jHtj1CC0ZyN5Yc2EN1fD+Bzb1ZRHw0H4onIfae3VkfgNy
         CaLg==
X-Gm-Message-State: AOJu0YzkbusyEuPi3RkA53dzNjtvZdogaAJceZPSl0vCcHdS45LzRWXx
	ud45aR3egImA6x+8OTE8C8C3Arl9rKu9WU4d7tf1vtH4jBwcQ60EEDuiu5ve
X-Google-Smtp-Source: AGHT+IFw+J7TU8X4y3Zkvg2wA2mwdNJvprZSt6BaJdR23NdGLeaxsgQjlw258RX6eZPe5p9p4Hu3tg==
X-Received: by 2002:a17:902:ccc1:b0:1de:e473:55f5 with SMTP id z1-20020a170902ccc100b001dee47355f5mr3838489ple.58.1710488083256;
        Fri, 15 Mar 2024 00:34:43 -0700 (PDT)
Received: from slk15.local.net (n58-108-84-186.meb1.vic.optusnet.com.au. [58.108.84.186])
        by smtp.gmail.com with ESMTPSA id k18-20020a170902c41200b001dd75d4c78csm3049142plk.221.2024.03.15.00.34.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Mar 2024 00:34:43 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From: Duncan Roe <duncan_roe@optusnet.com.au>
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue 29/32] doc: Cater for doxygen variants w.r.t. #define stmts
Date: Fri, 15 Mar 2024 18:33:44 +1100
Message-Id: <20240315073347.22628-30-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.35.8
In-Reply-To: <ZcyaQvJ1SvnYgakf@calendula>
References: <ZcyaQvJ1SvnYgakf@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

More changes to doxygen/build_man.sh.

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 doxygen/build_man.sh | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/doxygen/build_man.sh b/doxygen/build_man.sh
index 5c1a019..d3bd748 100755
--- a/doxygen/build_man.sh
+++ b/doxygen/build_man.sh
@@ -7,6 +7,7 @@
 # Args: none or 2 being man7 page name & relative path of source with \mainpage
 
 declare -A renamed_page
+no_macroRI=maybe
 
 main(){
   set -e
@@ -250,10 +251,18 @@ fix_name_line(){
   mygrep "^\\.SH \"Function Documentation" $target
   head -n$linnum $target >$fileC
 
+  # Different versions of doxygen present macros and functions differently.
+  # Some versions have .RI lines for macros then functions.
+  # Some versions have .SS lines for macros instead of .RI.
+  # All versions (so far) have .SS lines for macros after all .RI lines.
+  # Look for #define in .RI lines and look for .SS lines if none found
+  # to cater for either scenario.
+
   while :
   do mygrep2 ^\\.RI $fileC
     [ $linnum -ne 0 ] || break
     # Discard this entry
+    ! grep -E -q '#define' $fileG || no_macroRI=
     tail -n+$(($linnum + 1)) $fileC >$fileB
     cp $fileB $fileC
 
@@ -262,9 +271,9 @@ fix_name_line(){
       all_funcs="$all_funcs, $func"
   done
 
-  # macros (if any) come after functions
+  [ -z "$no_macroRI" ] ||
   while :
-  do mygrep2 '^\.SS "#' $fileC
+  do mygrep2 '^\.SS "#define' $fileC
     [ $linnum -ne 0 ] || break
     tail -n+$(($linnum + 1)) $fileC >$fileB
     cp $fileB $fileC
-- 
2.35.8

