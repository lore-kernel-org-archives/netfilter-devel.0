Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29FB113FE0
	for <netfilter-devel@vger.kernel.org>; Fri, 15 Mar 2024 07:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710488071; cv=none; b=Qv1cb1AbS08IjStcXHLOGZUUKMmZoBXOjwkl8AjethCDnp4ojU1xE2P8Xc3rit1WXH9pjI6mageF0W2Rp3aYnR/T0RTn5TFMoGm23Ip1WF2agvpkckky+/0QoBa5eRqpGwMcwt0irwyYdgZDQZkqQzMVPTwyZ0GlmR2FZikMayQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710488071; c=relaxed/simple;
	bh=UNAQ8mCeiFOIjtLJbtzkHikpbKEMqfTV+ntjDQQnyZM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=PuEAdEf+s0zBoC3vUUERKx6GN1/mqMR51C2vhNtdP3MHg4pvksoWNWTQf2NKoe6CF99KQTjzy8ZaLH2Q0/2MmHW5Aw55I57pySsAt3JtndCS75EnbX04uMCfvoZAqBEWvlY8BEeSgOU/yu+H/0ch1+xG7mjl4RI/kNbvdYzE2k4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=akHfzLzy; arc=none smtp.client-ip=209.85.215.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="akHfzLzy"
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-5d8b519e438so1507910a12.1
        for <netfilter-devel@vger.kernel.org>; Fri, 15 Mar 2024 00:34:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710488069; x=1711092869; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YGXutRUKy2QecR14hSHTA+9mk2bNhcpbq1HgJy1szwg=;
        b=akHfzLzyz4pq0mED4oIWL7W6wWnWWgLnC+Cga7XFObkfcVP51d4S05eVQE2wjyjsn7
         ZoY4GAsos/YzNb/9UdiJi5/DgB0q+2xvXyLObkDHwoLMSLR8a0/tKV+7+bWpZw+xJKPY
         mfE/pn6hjua6xftWaTTWorsIPqb60Qd7ocAg1uNLouq4XT5jlv3DsXxbN/vMYMenCGVs
         sPljIyUL9brlmzXWJeRHx1BVmrJgmjCpeLuS9itrrBpGSKkD689OHNpQaJCAIJhyUEKN
         ynQXesSi1GyXJndzVz3dSgdJH+jFs1Foc+hOt5/gyCqD2BJR62mqzH9Z4Y9w/07XpRlN
         x7Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710488069; x=1711092869;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YGXutRUKy2QecR14hSHTA+9mk2bNhcpbq1HgJy1szwg=;
        b=sY485UNgnKX5hShkBn0Zr/ToWC2TnM+t/PRHiiUR00Hp+a5xWwUGs62dwY7CS8nnbJ
         SuAwms8BHDsgywpB1+/nWr9OtQKYOUB+M2EyjhqRDDtSMcO2oUCYVV5Sg8xMkDPin84p
         FiNjgtLsspI0BYZ2i9b+qMgqb0QfbHMXJ9cDPvhvGpWr89sAusk8PIDL7F9VZrAi8RDy
         6YvZJ3avUX/dHXS4bzSlsLDlmdTpKNrtAqlcfadzNyFKrkQaPU9tdOtqdGyJKVU1g9BL
         kyr1JHsQ1Lkpe2Zx1j86OLyTJvA0s3Yf7yq1Gev6WtdnTfF2/6Mbqrdj9Fo0aSX9eAHk
         h6+g==
X-Gm-Message-State: AOJu0YyY8Q9kwx6USHn/yupn7n+D90+7K2OUFf+PTOdStJM7k9xGY6f9
	NO+h14hj05TuN+OoFGzYvpn2JBJGhnlREOeMWByvDi2jdTRM2lUNxhR9jtJf
X-Google-Smtp-Source: AGHT+IFsr5ViIj19ie8fWN3p4iS9Ox3waXSrXK3dzoXvi7EKOnFDRqFSimuOSuB2VBfReLLN8cBtag==
X-Received: by 2002:a05:6a20:2585:b0:1a3:504d:c064 with SMTP id k5-20020a056a20258500b001a3504dc064mr436002pzd.55.1710488069562;
        Fri, 15 Mar 2024 00:34:29 -0700 (PDT)
Received: from slk15.local.net (n58-108-84-186.meb1.vic.optusnet.com.au. [58.108.84.186])
        by smtp.gmail.com with ESMTPSA id k18-20020a170902c41200b001dd75d4c78csm3049142plk.221.2024.03.15.00.34.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Mar 2024 00:34:29 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From: Duncan Roe <duncan_roe@optusnet.com.au>
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue 21/32] build: Remove libnfnetlink from the build
Date: Fri, 15 Mar 2024 18:33:36 +1100
Message-Id: <20240315073347.22628-22-duncan_roe@optusnet.com.au>
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

libnfnetlink was a "private library" - always loaded whether user apps
used it or not. Remove it now it is no longer needed.

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 Make_global.am           | 2 +-
 configure.ac             | 1 -
 libnetfilter_queue.pc.in | 2 --
 src/Makefile.am          | 2 +-
 4 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/Make_global.am b/Make_global.am
index 91da5da..4d8a58e 100644
--- a/Make_global.am
+++ b/Make_global.am
@@ -1,2 +1,2 @@
-AM_CPPFLAGS = -I${top_srcdir}/include ${LIBNFNETLINK_CFLAGS} ${LIBMNL_CFLAGS}
+AM_CPPFLAGS = -I${top_srcdir}/include ${LIBMNL_CFLAGS}
 AM_CFLAGS = -Wall ${GCC_FVISIBILITY_HIDDEN}
diff --git a/configure.ac b/configure.ac
index 7359fba..ba7b15f 100644
--- a/configure.ac
+++ b/configure.ac
@@ -42,7 +42,6 @@ case "$host" in
 esac
 
 dnl Dependencies
-PKG_CHECK_MODULES([LIBNFNETLINK], [libnfnetlink >= 0.0.41])
 PKG_CHECK_MODULES([LIBMNL], [libmnl >= 1.0.3])
 
 AS_IF([test "$enable_man_pages" = no -a "$enable_html_doc" = no],
diff --git a/libnetfilter_queue.pc.in b/libnetfilter_queue.pc.in
index 9c6c2c4..1927a8a 100644
--- a/libnetfilter_queue.pc.in
+++ b/libnetfilter_queue.pc.in
@@ -9,8 +9,6 @@ Name: libnetfilter_queue
 Description: netfilter userspace packet queueing library
 URL: http://netfilter.org/projects/libnetfilter_queue/
 Version: @VERSION@
-Requires: libnfnetlink
 Conflicts:
 Libs: -L${libdir} -lnetfilter_queue
-Libs.private: @LIBNFNETLINK_LIBS@
 Cflags: -I${includedir}
diff --git a/src/Makefile.am b/src/Makefile.am
index a6813e8..e5e1d66 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -39,4 +39,4 @@ libnetfilter_queue_la_SOURCES = libnetfilter_queue.c	\
 				extra/pktbuff.c		\
 				extra/udp.c
 
-libnetfilter_queue_la_LIBADD  = ${LIBNFNETLINK_LIBS} ${LIBMNL_LIBS}
+libnetfilter_queue_la_LIBADD  = ${LIBMNL_LIBS}
-- 
2.35.8

