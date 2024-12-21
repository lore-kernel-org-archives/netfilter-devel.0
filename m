Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F210686337
	for <netfilter-devel@vger.kernel.org>; Sat, 21 Dec 2024 03:13:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734750840; cv=none; b=ev0LC/NAfepn7DSxURsYgm5hSz9tpgYbIRZrhgfFH8WTpHpHoscSRU5S68+6ndHOjB4PNi0Rrq9NCXKAFqx8CazFGbaHdzVLpa7x8NdrXnGXAN1I5z/UgbY4ew6vyC3rOovvJqf/OMi10+pfon7eRZxl4bAbiH52nTkIBGyu7o8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734750840; c=relaxed/simple;
	bh=beMmzsvlY88Vmdqad56PjZkOZKO01bKM3bIMNpW7ujE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=XOyC6TIV3ZgVxyf1bbCyfRRf2RTn8hb/AlskJERA2pe/tx6IdymEjo1H4BSb7SjgFsIL8zr1Cvx1ArX1YXZ/Lx1VAol+gmzuNf2ocdWmhEhEk8qLuY/J666wQNHeihIxxUKauF11/waf/eEWUdrlTpE466L/Fs5BvSiIqGYBdnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hrd1P5a8; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hrd1P5a8"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-218c80a97caso22335155ad.0
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Dec 2024 19:13:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1734750838; x=1735355638; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=ezMg6Yf3PUkb59tCV+/dfXyq3O3xlWWSiKUXd/Qn/Go=;
        b=hrd1P5a8qq5DqsartSRICRTH6SM7qMu8GIQx6OQGUtjp3LkZIyfhYPghTm7bYNs+F/
         It1Iwdv5ltJdV73laUc8qfTWSQXh/8Hdm9upkrw+FSCFw1aiteAiIaIRvZB0dvW0b5W+
         EUSUBkfgg0opaFDeOzjQHDSALQduAjUGfst/YI6zySjMQdle9ldF+LCQ/+cs+NIBdMl6
         IXzZIo+4cR6P05hkOuYcsFg7Es4pteft7OcSwrj/8yzbkjr/HxMC1Sm+h1VF5a8tYn1C
         Ms4FDwFiN6I+QG63TXAy/IKs08EYBYmu4YaKCPJ9iDOnYq4ASChtH+dID1hS8W4E4Wtk
         WHEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734750838; x=1735355638;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ezMg6Yf3PUkb59tCV+/dfXyq3O3xlWWSiKUXd/Qn/Go=;
        b=BX9LUOXEXmi8NvSWg2NzaygoVpXrsB1rcSyZ4j8CNKJjAw54tYyNW+5QJHmnmB2OXi
         qADxN/fj0ic+PEsXoxQ9zvrcIJ//77xFUIvuYD0cRYqtLwlCVVEkIzwxCOje2S/z7tfD
         xLuQ3HQeDrbKjKgrGSpPOyIgG2C2GfHCtXbWOpvt1beYY1GEvNiVZsfnyibQhai1XHiH
         CRiFAOILBYM4393EDuBsvcqoqL4BPB+sEeaJeC2z/jHGvy6KpFMAAPNK7Csws8AFk8H1
         PtVoCoFXD4z8Ierzon9PYvbBcxAB1bxgvHHq5yvBU5Vxv7NkdYG2yXWoqz30M2u9r53P
         Afgw==
X-Gm-Message-State: AOJu0Yws7Si/2AdQRYowDbIRQdLBHxiwmoe6ozt9uJixa4HYaA3yEH6l
	QVSeFb3UU6cPANl3XPaQ47zSj02/V3KXlYncGthr2IzGAR55VC7njYV7YA==
X-Gm-Gg: ASbGncsEwvluaaCQ3ivzZZT+1EnMOXFaFKSaO+aYnwI8FUmqu2+erTRQWiW+b5HvdcJ
	ENN8rKli3TXJA/dxnhmIqNAwpg5sRnL3dOujwECr5SD2pAzDwWHQtagYPHIEmaS59ptWWtr7dJG
	UaiIPBecagzw3hanUNUu2BbZfsgeUwZYXmxYlyk3iT/IrfxNM26kbykiNPUqUGCVxaubJC7PuK+
	vVnskIZL0iwjhsJtOHHJx7EFvF1yA8DoqZ0Gn/+ue5hkxe18Lt74PdhuRLc/T7caiUyMPwcARmK
	Px7Zq8rMLaRnSqmEeQjZZdNbnlY9lkE71G1e6vPdnA==
X-Google-Smtp-Source: AGHT+IE969kK6FrkeLpNMRv+k3LJq1JRYaoR6pjNfZQQDY43VjBavGjcbSVyVnmzcrLohHi/rS6+ow==
X-Received: by 2002:a17:902:e551:b0:216:7ee9:2212 with SMTP id d9443c01a7336-219e6e9fd66mr72104915ad.23.1734750836613;
        Fri, 20 Dec 2024 19:13:56 -0800 (PST)
Received: from slk15.local.net (n175-33-111-144.meb22.vic.optusnet.com.au. [175.33.111.144])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-219dc964e92sm35909545ad.18.2024.12.20.19.13.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Dec 2024 19:13:54 -0800 (PST)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From: Duncan Roe <duncan_roe@optusnet.com.au>
To: pablo@netfilter.org,
	dunc@dimstar.local.net
Cc: netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue 1/2] build: doc: Only fix rendering of verbatim '\n"' when needed
Date: Sat, 21 Dec 2024 14:13:48 +1100
Message-Id: <20241221031349.18922-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.35.8
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

commit 9f52afa60839 ("build: doc: Fix rendering of verbatim '\n"' in man
pages") worked around a doxygen bug which was fixed at doxygen 1.9.
Applying the workaround to output from a fixed doxygen version reintroduced
the bug.
Update build_man.sh to record doxygen version and only apply workaround
if that version is broken.

Fixes: 9f52afa60839 ("build: doc: Fix rendering of verbatim '\n"' in man pages")
Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 doxygen/build_man.sh | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/doxygen/build_man.sh b/doxygen/build_man.sh
index 95c7569..a6531cb 100755
--- a/doxygen/build_man.sh
+++ b/doxygen/build_man.sh
@@ -68,6 +68,13 @@ post_process(){
   #
   #keep_me=nfq_icmp_get_hdr.3
   #do_diagnostics
+
+  # Decide if we need to fix rendering of verbatim "\n"
+  i=$(doxygen --version)
+  doxymajor=$(echo $i|cut -f1 -d.)
+  doxyminor=$(echo $i|cut -f2 -d.)
+  [ $doxymajor -eq 1 -a $doxyminor -lt 9 ] &&
+    fix_newlines=true || fix_newlines=false
   #
   # Work through the "real" man pages
   for target in $(ls -S | head -n$page_count)
@@ -84,7 +91,7 @@ post_process(){
       [ $# -ne 2 ] || insert_see_also $@
 
       # Fix rendering of verbatim "\n" (in code snippets)
-      sed -i 's/\\n/\\\\n/' $target
+      $fix_newlines && sed -i 's/\\n/\\\\n/' $target
     }&
 
   done
-- 
2.46.2

