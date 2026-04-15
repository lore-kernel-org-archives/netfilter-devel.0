Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55ABC3D9DBC
	for <netfilter-devel@vger.kernel.org>; Wed, 15 Apr 2026 15:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776268654; cv=none; b=AMd+uAdZ7iLqMLM3ZJWTqGox4iVGbBLuyq0UuiOUN+OMWLPsnx4xZQ9cpLs9RWpzKp3iIJ8VAmQ4L09rrnWhkUJh/Yt0Gt+MBn53w0ydEOiPEmvWGtkPQswLyVyG1X7++x2YFs5yIO7ZtgQaD7j9gAzLyh0FZ/K26uyCsIioHrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776268654; c=relaxed/simple;
	bh=Y+5t2LUujsBeGQ2602CmouD/PmlA7btFSTn98swxgqE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IJ3PcL7vBt539KU48fjCYLjO3dFvxdPx31eZktIvgPf63wsq1y3QELYnJh31Y0LKdWnsAA0nG9ii0RSXDCn/Lb28rS6gl6l0MuArC/l15nP+CBhJCqlAmlClfdkF6ruo5ONLFo0Q7vjfcS81XP4zLv19TmtCsPZCxeK2ES9g6uk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ekKll8Y/; arc=none smtp.client-ip=209.85.167.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ekKll8Y/"
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-5a2c9c5ff87so7126760e87.0
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Apr 2026 08:57:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776268650; x=1776873450; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=8Oz7Hg5VPkcfsV8MYTcL9qKZLX0S8mgkehyBtj32+kM=;
        b=ekKll8Y/WJKqTkcElt3euQFBxpBb29SivKFtC/djBi/WbUMOnanQpAbCo/q7VI3zYE
         +HjkL6SAlnX9rRejGQueJSl6R5Nm/zXJiQAT6+P68ImQYgm3OnlziikN0pjZo3+oFoNo
         +54C0qGLkREHVgsgl/hj1wd5cZnX9iJSkzA0H80PnKlnBEsoPaf6maUMcVHSi6sfbs/g
         yiwXNu5SIpN/bo6Dft7XTBBAXW4lU02GQWDLq2NpYxlc3m/NuS0DiLOCn42/GY7I0gbN
         2wkm4qQMOM6nVUzHFdjr8xaH0jrn6z9rRBbnP4B4dCssDlgWJ+/elIIF/wjMnchESuMJ
         Ag6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776268650; x=1776873450;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8Oz7Hg5VPkcfsV8MYTcL9qKZLX0S8mgkehyBtj32+kM=;
        b=HfyQdgjnjqqUZgSIzIXfWw1wq3faE9/2xNftdcqTT+Lk1PQP6yoNPodj9ivsdougza
         l9XXB75paVrky5LCZKoUCmjGw5dr2p4+iFzQZTmjzQWsUWD+QHiEugd+qpSnB2uBt2XJ
         0dO6s9cnMJ0SuAf3+6VJjQIyep2+V2FVoGugAsc1xFZEs380+l5RQ7XNvh/Zc4sr8hqr
         dxU41Sce8hKG4T2n4UDOFL+6RrtojFiS/6iuM+KwZEeN7ncqjOi+XbxYbjKhudMpkIkw
         o3gKKhC8P6u3VeJ+cpgArIR6GSP8NRpq5QtCgas1Z4szgXBsYG1cVlnWIiuAnrtS+2qW
         FiyQ==
X-Gm-Message-State: AOJu0YwT6IGpzkl96BZaFKLMbUbXYuxrL7lrbERP/gCTxzKvSJKr33/o
	gE3bGCrLRq8LPd5VZklzqwplIjwOtjK/MrbrYxq4cLCWXSwrQ+p0iMDhZUwCdQgrzPA5NQ==
X-Gm-Gg: AeBDievl0xyF9WV1XpFhVliOmzLL/sHNFUpdgYfG9RFlOLLgTwy1Eo4kXuniUQkc4j8
	2b6LhnUQ2kU6+xfhgy7tSzQ7a7qthp4CuHTgU6fTb8SJe9tIRO/Wa0GeHZzkOSYsfXVWr4OWmEZ
	2TiWBIgNklQT6Gkcjb0xUClOMXKCYTYNUXT/UeOrLmc54zf+GFdz1mcwp55yweRbn0s6Z45WtLM
	XE04hmnsfNlUIzZ7IA/GFOrF6Ggi7lm8ST5wxQXZAty7cxg0OEc/+Z4otf4eIyeLae/7v3nlqff
	PRj2SmlqlqOy+hAgvitAtBPOJN58Y6DQfqzz3OCM26WEZwt0Cwet79RLcpNdw1k23EOQKfMjlLr
	GFt5et9YUG095mQIkztDcP0AGZec09gT65NkNtwCZHk/gRxRhlSGLPEXTnUAxgV2m0jTU2Ga5jl
	eTHFzcszO9cOQ4JHG/qUPogqJVx2wTM89ssZygLurSsBtz+nFN52Vw1ve8ieO0JOhdCQ==
X-Received: by 2002:a05:6512:3e28:b0:5a2:ad98:3685 with SMTP id 2adb3069b0e04-5a3efd90bbfmr6708769e87.35.1776268650160;
        Wed, 15 Apr 2026 08:57:30 -0700 (PDT)
Received: from CNLFI0022 (91-156-17-56.elisa-laajakaista.fi. [91.156.17.56])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5a40a2728d4sm558091e87.15.2026.04.15.08.57.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Apr 2026 08:57:29 -0700 (PDT)
From: Tommi Rantala <tt.rantala@gmail.com>
To: netfilter-devel@vger.kernel.org
Cc: Tommi Rantala <tommi.rantala@cujo.com>
Subject: [PATCH iptables] extensions: libipt_REJECT: Drop ancient kernel compat hack
Date: Wed, 15 Apr 2026 18:57:20 +0300
Message-ID: <20260415155720.313166-1-tt.rantala@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Tommi Rantala <tommi.rantala@cujo.com>

The IPT_ICMP_ADMIN_PROHIBITED fallback define and associated
compatibility notes were relevant for 2.4 kernels. The INCOMPATIBILITIES
file referencing these was already dropped in commit 92ce78d04677
("Drop INCOMPATIBILITIES file"), so clean up the remaining leftovers in
the REJECT extension source and man page.

Signed-off-by: Tommi Rantala <tommi.rantala@cujo.com>
---
 extensions/libipt_REJECT.c   | 14 +-------------
 extensions/libipt_REJECT.man |  4 +---
 2 files changed, 2 insertions(+), 16 deletions(-)

diff --git a/extensions/libipt_REJECT.c b/extensions/libipt_REJECT.c
index 743dfffc..8bfe0fd7 100644
--- a/extensions/libipt_REJECT.c
+++ b/extensions/libipt_REJECT.c
@@ -6,16 +6,6 @@
 #include <string.h>
 #include <xtables.h>
 #include <linux/netfilter_ipv4/ipt_REJECT.h>
-#include <linux/version.h>
-
-/* If we are compiling against a kernel that does not support
- * IPT_ICMP_ADMIN_PROHIBITED, we are emulating it.
- * The result will be a plain DROP of the packet instead of
- * reject. -- Maciej Soltysiak <solt@dns.toxicfilms.tv>
- */
-#ifndef IPT_ICMP_ADMIN_PROHIBITED
-#define IPT_ICMP_ADMIN_PROHIBITED	IPT_TCP_RESET + 1
-#endif
 
 struct reject_names {
 	const char *name;
@@ -73,7 +63,7 @@ static const struct reject_names reject_table[] = {
 	},
 	[IPT_ICMP_ADMIN_PROHIBITED] = {
 		"icmp-admin-prohibited", "admin-prohib",
-		"ICMP administratively prohibited (*)",
+		"ICMP administratively prohibited",
 		"admin-prohibited",
 	},
 };
@@ -102,8 +92,6 @@ static void REJECT_help(void)
 "                                a reply packet according to type:\n");
 
 	print_reject_types();
-
-	printf("(*) See man page or read the INCOMPATIBILITES file for compatibility issues.\n");
 }
 
 static const struct xt_option_entry REJECT_opts[] = {
diff --git a/extensions/libipt_REJECT.man b/extensions/libipt_REJECT.man
index a7196cdc..ea4d92e6 100644
--- a/extensions/libipt_REJECT.man
+++ b/extensions/libipt_REJECT.man
@@ -19,7 +19,7 @@ The type given can be
 \fBicmp\-proto\-unreachable\fP,
 \fBicmp\-net\-prohibited\fP,
 \fBicmp\-host\-prohibited\fP, or
-\fBicmp\-admin\-prohibited\fP (*),
+\fBicmp\-admin\-prohibited\fP,
 which return the appropriate ICMP error message (\fBicmp\-port\-unreachable\fP is
 the default).  The option
 \fBtcp\-reset\fP
@@ -28,8 +28,6 @@ TCP RST packet to be sent back.  This is mainly useful for blocking
 .I ident
 (113/tcp) probes which frequently occur when sending mail to broken mail
 hosts (which won't accept your mail otherwise).
-.IP
-(*) Using icmp\-admin\-prohibited with kernels that do not support it will result in a plain DROP instead of REJECT
 .PP
 \fIWarning:\fP You should not indiscriminately apply the REJECT target to
 packets whose connection state is classified as INVALID; instead, you should
-- 
2.53.0

