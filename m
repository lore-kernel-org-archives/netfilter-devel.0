Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 226A414A9D
	for <netfilter-devel@vger.kernel.org>; Fri, 15 Mar 2024 07:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710488083; cv=none; b=mUdj1SY35LctZa0COU43nxposM04Doaxa1/kdQ26meVicuw1k5aARdrH3x8pESrrKzqwM5v03OaDFh9bodarN6t3lANgE4xISMPlzrfHK/S8/SUdLGYio6ABfuPORn+PyBeKXowye54eWSB8/EswRrtTHo70VTSlJ5ZI/325kv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710488083; c=relaxed/simple;
	bh=ZzppsJdlw43YNa+4e0bq79XMoeHC+RInrcL6Qx1yb/g=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Yb3/jfC65HRUA/vQVJbgxZuQOpmMRSEfBYwq3BzH84CaazuNvLAgORSvWdyycLPeBluWnvmauwUNaNWqfYfh7sD4kuRJmt1hs8jxhjirPG+FN+yXIQ6dkvkXcCIbf9IjwFCJ/LPgVeqE1oWHS8X6EIL5IWeTIGO50mxJleEQVQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WCEylvir; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WCEylvir"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-1dddad37712so16706045ad.3
        for <netfilter-devel@vger.kernel.org>; Fri, 15 Mar 2024 00:34:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710488081; x=1711092881; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kc2qOiTSMgfonc5p5qEQqqcSuuKBT0Z8T/iyp6xLPkk=;
        b=WCEylvirXcbCNFYwiPhkob9mqoyH4GUmR9U2kg0ckuhRiFDrhpfCR5TMhBWbR72hHo
         UBTBl7xD5Ay7EcYZRHB/F/ibc/vSjwT+WhWiqxqrSbTESZA0K8zptVZkZXmec2XrXD6J
         70Xjs61EKiulaxXRsXlMXnlLKLgUy8VEhD7H9vwbWjTDfKhzo/feOu19SAFRJg/WO6pB
         RqwtMIJciwOjwVa06HxZuuYnkgjerLICgue6kOS1KJYmkXLtRXI67q3IBruJ52QIn9kV
         7f3ggfjdjWuG3RStXwEpX8G2/4Wb0czNbUgjcwJurtuU3Xl5F8r/MaSHGiGtQyHW//o3
         phVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710488081; x=1711092881;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=kc2qOiTSMgfonc5p5qEQqqcSuuKBT0Z8T/iyp6xLPkk=;
        b=O6pzL/BX/X7TtgBYeeUjK10JJzXih2WuUzBXUkxKRZp7sghUjG+1uykA9u8M9gQwqZ
         HZv/TO3kX3XrReCNWHtiRlBLHgMfRaZn87L2vJ10sLAoGT9qvLzKsyZNpfUmyyRHMoPv
         cQLuynNAZUBe/nhGk0pQCstbQocqsS0W/9TEFemhlKLKyaX0QgjkcoeAD7eXMFuXL7Ad
         UyDyEUuKCW/7Roelvh0lsEZIf8Paxo6ez+ZbPzjWpwXq40HqfCDptmH8D9ZAgolZte6B
         xeJtXqeRPDxxpYz3ZYueG1RtC3zCdGTW55Rkqz2U6sef4P97d84CN8RY2bX8ZdEQgPpk
         XKEQ==
X-Gm-Message-State: AOJu0Ywa9EF+d5u1FxstrEczb4JDeKwFk4OgDHEAIEwla7IzxatHbyVW
	H6ACBFkXEUVY4ZFJG4JY7pVNEGPQroR/04Vo+jkBZqJWIkXZVYjOweJS+G2r
X-Google-Smtp-Source: AGHT+IFCXj77nfn+E6sQr+VGx8HAWIPbChG/WZQpuP/J1sagg2/UQYsSEaZv0WlFxjH0RIOEaRhdgQ==
X-Received: by 2002:a17:902:e812:b0:1dd:7829:6a0a with SMTP id u18-20020a170902e81200b001dd78296a0amr4697160plg.2.1710488081596;
        Fri, 15 Mar 2024 00:34:41 -0700 (PDT)
Received: from slk15.local.net (n58-108-84-186.meb1.vic.optusnet.com.au. [58.108.84.186])
        by smtp.gmail.com with ESMTPSA id k18-20020a170902c41200b001dd75d4c78csm3049142plk.221.2024.03.15.00.34.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Mar 2024 00:34:41 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From: Duncan Roe <duncan_roe@optusnet.com.au>
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue 28/32] build: Get real & user times back to what they were
Date: Fri, 15 Mar 2024 18:33:43 +1100
Message-Id: <20240315073347.22628-29-duncan_roe@optusnet.com.au>
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

In build_man.sh, mygrep becomes mygrep2 and
all functions except fix_name_line use a new simpler mygrep.

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 doxygen/build_man.sh | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/doxygen/build_man.sh b/doxygen/build_man.sh
index b3d1989..5c1a019 100755
--- a/doxygen/build_man.sh
+++ b/doxygen/build_man.sh
@@ -251,7 +251,7 @@ fix_name_line(){
   head -n$linnum $target >$fileC
 
   while :
-  do mygrep ^\\.RI $fileC
+  do mygrep2 ^\\.RI $fileC
     [ $linnum -ne 0 ] || break
     # Discard this entry
     tail -n+$(($linnum + 1)) $fileC >$fileB
@@ -264,7 +264,7 @@ fix_name_line(){
 
   # macros (if any) come after functions
   while :
-  do mygrep '^\.SS "#' $fileC
+  do mygrep2 '^\.SS "#' $fileC
     [ $linnum -ne 0 ] || break
     tail -n+$(($linnum + 1)) $fileC >$fileB
     cp $fileB $fileC
@@ -314,6 +314,13 @@ delete_lines(){
 }
 
 mygrep(){
+  linnum=$(grep -En "$1" $2 2>/dev/null | head -n1 | cut -f1 -d:)
+  [ $linnum ] || linnum=0
+}
+
+# mygrep2 copies found line to $fileG. Only fix_name_line() needs this.
+# Using mygrep everywhere else gives a measurable CPU saving.
+mygrep2(){
   linnum=$(grep -En "$1" $2 2>/dev/null | head -n1 | tee $fileG | cut -f1 -d:)
   [ $linnum ] || linnum=0
 }
-- 
2.35.8

