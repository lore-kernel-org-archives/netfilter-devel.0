Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E5BE14F61
	for <netfilter-devel@vger.kernel.org>; Fri, 15 Mar 2024 07:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710488081; cv=none; b=QT4SUrmmmyTUVb7O2XQbHy3r71vMjmWosDMVLeqT4BIfasCcOkPgLYNPelhGq0mCH079sTpRS6SHduIoKCaBoKjzjAJx1p7rBrCLKgaox0iDvrtXqTfKFNIANdYEBAZjfFGDQRSlCFy3+pPvJG9i8t0zDa2rsVpr/SUDrcOUeeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710488081; c=relaxed/simple;
	bh=JXHBbCUZ+AoZP8C5I0tcR8CwfTwdSwdxD5aYLAUzD8c=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=VNV6qyEq0cnWdlbelDK49WjNYWxnFLbuP28kKY3tDNyegR9UUZf+mA1NkSfWcnG5Gnc+6RNrYstxXbgbU90kE76etNzNFvp8Yx/c3t6mIgNdGGMKchWt7Lyj8NHvhOaOVcD4TeCKvibno6bgZiAWYUo/JR6+0ZC1WToMR3ffe6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PsC2si8c; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PsC2si8c"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-1dd9568fc51so16146875ad.2
        for <netfilter-devel@vger.kernel.org>; Fri, 15 Mar 2024 00:34:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710488080; x=1711092880; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7mHDlg509KDotU9DY50+pnpa/oUeQ8zb706NWMFAFFg=;
        b=PsC2si8cWenwoOU/u2BBSQIiUXF1bu8KpueLxXZez6w/g2h1ogdmbhRNuCfl7TIs0e
         bzoyKrXO18PKSrIZVV0bf4iBwrymKD6FsrxZzziBgpIiPgxzqY3Ubw/8cvVIIVb+nFK4
         9IAUlPL73h95jgaYCI4s38ZKY9FTVQqKIkSwddQfTKdSf9k98rE0IXBzl/qW+wiAN7Fn
         VuO++Wt5zpxw9RpmqQ96IxMN1JjyhL5LdEDmP2WL203hU2WreATkNB9RdZl5tlczLefv
         eeYfdDUtJSFWjUQrvMjW7JAds8byriWAoLuRMUxWLudXALoFdNqseY9DSY2K+686CNZy
         Aw4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710488080; x=1711092880;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7mHDlg509KDotU9DY50+pnpa/oUeQ8zb706NWMFAFFg=;
        b=ZKXxPnN+/vWp9E1kghEvqjzcRUyAqYB4mFyEIFCLM5qS69/sZff8h2eE/DoJ9riw1f
         9j/MP8bZqbCPwv40KS8avx+NeB39Gn8mLWOvPhgeoI54WzomnCszPozxStbjzCqtTwZR
         JJ8ednZRSznUtMJDFVIuzppf1pgg3kRyvpbivlFUhjrBA1bpXEkYC96oVORbxP9dSGF3
         mCEHiCcZKf54K7f5+vy+M4yPdf47r+ggcooXMhZ7Y9uTdITWAFo/FVSKOH8ybr3zemeO
         L02a2y01akU6lBX7Qd0kfmF8+p/dV3eAYEZxLfug2ZFDRkYZ9yH34NHq1mBCibOM3qeQ
         17jg==
X-Gm-Message-State: AOJu0YyKVLRfvH5zR7v6OLsCNB3fkJgZ+tvtH89SadgKNZTJjOkvvVXE
	WP8zVw/krsSg3vprrUCBVGCGkOCZUNrzIdQzxolGo3QCMgdrRvdctwhgMnhQ
X-Google-Smtp-Source: AGHT+IGBPiz04UzM72wRIhBTytzivDQwosT/RsR+vHBOx1Kgfk7WNSFgKGEwyv7Sa3q0ea/fdqc0lg==
X-Received: by 2002:a17:902:e84d:b0:1dc:fcc4:b3a5 with SMTP id t13-20020a170902e84d00b001dcfcc4b3a5mr4598352plg.35.1710488079755;
        Fri, 15 Mar 2024 00:34:39 -0700 (PDT)
Received: from slk15.local.net (n58-108-84-186.meb1.vic.optusnet.com.au. [58.108.84.186])
        by smtp.gmail.com with ESMTPSA id k18-20020a170902c41200b001dd75d4c78csm3049142plk.221.2024.03.15.00.34.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Mar 2024 00:34:39 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From: Duncan Roe <duncan_roe@optusnet.com.au>
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue 27/32] doc: Resolve most issues with man page generated from linux_list.h
Date: Fri, 15 Mar 2024 18:33:42 +1100
Message-Id: <20240315073347.22628-28-duncan_roe@optusnet.com.au>
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

build_man.sh has extra logic to extract documented macros into the "Name"
line.
doxygen.cfg.in excludes the list_head structure.

doxygen 1.10.0 has a bug which appends ".PP" to macro "Value:" headings.
This is fixed in the latest snapshot and should be in the next release.

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 doxygen/build_man.sh   | 10 ++++++++++
 doxygen/doxygen.cfg.in |  1 +
 2 files changed, 11 insertions(+)

diff --git a/doxygen/build_man.sh b/doxygen/build_man.sh
index 0590009..b3d1989 100755
--- a/doxygen/build_man.sh
+++ b/doxygen/build_man.sh
@@ -261,6 +261,16 @@ fix_name_line(){
     [ -z "$all_funcs" ] && all_funcs=$func ||\
       all_funcs="$all_funcs, $func"
   done
+
+  # macros (if any) come after functions
+  while :
+  do mygrep '^\.SS "#' $fileC
+    [ $linnum -ne 0 ] || break
+    tail -n+$(($linnum + 1)) $fileC >$fileB
+    cp $fileB $fileC
+    func=$(cat $fileG | cut -f3 -d' ' | cut -f1 -d\()
+    [ -z "$all_funcs" ] && all_funcs=$func || all_funcs="$all_funcs, $func"
+  done
   # For now, assume name is at line 5
   head -n4 $target >$fileA
   desc=$(head -n5 $target | tail -n1 | cut -f3- -d" ")
diff --git a/doxygen/doxygen.cfg.in b/doxygen/doxygen.cfg.in
index 601d4ab..ad83581 100644
--- a/doxygen/doxygen.cfg.in
+++ b/doxygen/doxygen.cfg.in
@@ -17,6 +17,7 @@ EXCLUDE_SYMBOLS        = EXPORT_SYMBOL \
                          nfnl_subsys_handle \
                          mnl_socket \
                          ifindex_node \
+                         list_head \
                          nlif_handle \
                          nfnl_callback2 \
                          tcp_flag_word
-- 
2.35.8

