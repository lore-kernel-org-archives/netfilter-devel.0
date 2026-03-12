Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com [209.85.128.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 243463CAE86
	for <netfilter-devel@vger.kernel.org>; Thu, 12 Mar 2026 14:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773327310; cv=none; b=JhjlZfbDoCnvWe56dJ9NhmDooJ58HXaAddFrYXD6k64dlMQYjLXW5NQmSaFXtiWYu++3typwRV++OM7f1KM65UFhvpTEe31pV7kDnJ8jG8pBv3iKHR9JtUvjzISwdSbRcPOJW04unznM7vsVmDe3RNcOaQ5q+dJzVVE3DKbwwR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773327310; c=relaxed/simple;
	bh=ld1tz6d0ud8amU5nrnPSeoqEPfwOLinrJ8r1dI3Bwus=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=ipVaLULm67YcNJtvAAmKVGB38+mAyMU6VmohPVDr7p/7yGsK4RBUkaDLSbXl5yvOXEe9rOCEj15eSnnmC42fM+CQ/RCgCOaBwmka30sJj+ZAOC5hLKzDZkWfNF+ingshsAoObSbMSaSyNID/uj+yAmj/HaAKcIGy4lg/IeKVzk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BN8wN/Yc; arc=none smtp.client-ip=209.85.128.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BN8wN/Yc"
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-79885f4a8ffso10258937b3.3
        for <netfilter-devel@vger.kernel.org>; Thu, 12 Mar 2026 07:55:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773327307; x=1773932107; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=GUIaSW5bqI4A1hDxcJYGsoBl2KrEWrfpkCuCu8ViV/g=;
        b=BN8wN/YcvV9JoKoaB5+Dgm4SaqWd7jXXfo+ZwXALyh5EKvtGjU6tfEyYgOcYHkg4S4
         mTTWinRqBIzKWE5+o6OFgkXgrhfnoW/467CoOfp4YXkoTIysLXZGw+6WcNpK+/o9cWYh
         ZGAykt7WMtHgeUTMcML8jx4uLP3GT8rpNSE1t+IM+MYLD0Cct9k8SUfcqJDEel5/tmYL
         aeelkpvG+wL/At9Fu4dPq+zle8pMUcqo6B5JM6eVfGu/R1CqCuD2VBbdwjfo4YCNuj85
         ENtKeDDrkAUZyw8Oddm0a5Ya0MJ7rtdj2YTNXPAbRJvpz3RuGYByooSE6Azuxry7cDJr
         Utfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773327307; x=1773932107;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GUIaSW5bqI4A1hDxcJYGsoBl2KrEWrfpkCuCu8ViV/g=;
        b=s4zxdOCfDToQcAPt7mPYA80AHAPTssKJ1y2/FtZzbk27kqlN4JNHILWLmI8Az6KvFK
         uaESg2TH4A2glGqtk8qU4ztOXM9OTKzq4A46JRCivXYjPqxWv4EaapoXrEg/svQiK8e5
         H1PqTxMi93Fbi5/z5E6wTITW7aIneAmx8FyGuQpT3ClpxImvg11D+MlzAT7Zj1tZ9Gif
         QZKXavhI5VTfd9X1YxDflFuUap/n9TP7ZfGqGmzEwLgvkOhnWnm3U5LZfyU4d/9OK0Af
         F8l0kXgkpTAvLhfZApuCugkZujtDyu1VQMltu/06TsISmt+p6APXaA5yPQojpuYd3r6m
         7hAg==
X-Gm-Message-State: AOJu0YyGrmVOTWhMfJrCYBesnzE3G0XV5ixSDI5mceDD6NtRTsmVPtVt
	HF02VyS2D9QcAGILyK3jQBpAMYA7RXDQvxEqmH5R+nR1IBksv+c7oMvg
X-Gm-Gg: ATEYQzycQdkPWpkGpkYlQMiGx66c1chuMNeij7F3UjKWIECJbWTcn4MvUnND/rerGtt
	nHP3lhv8wqj2Zu8hK1hSD42i7kKXOybMcZX2R0lAIop55wu0gIPdPJCI/gim77KsrYwp1JAZqDD
	Bg3wX81NkCD+rLcAtlfX8JGjUFNGUvhPRFrByZ98Ku8SsVNRmX+BzBs6WBWhakE0H3SW55GBP02
	O/kzDvDdt+YFrzZu6mHL3uC91gW++ChO4+5w5cg4yOK4S8kTeGdm3Ej3CeHtEhNNdj6fgESUHZJ
	EvjvxCo+v+Yy72QauQZXz71eEUrQihfbkTmRQGvoG8U0sU8Lc6mrSJXEfihDaef6er5LgmuGN02
	Nhl49FspcnaQQaSNxTwPRO852ZCmQ2nNIJJKtPjkxkcqGFGzfE1Z1P3yDx5DQWpixadH/VCDBBT
	kDYKvQDHNvDPFf9IWhBdoOFgNT+iEcREc3AuQKuhmaLMpq
X-Received: by 2002:a05:690c:9d:b0:796:4486:b7d4 with SMTP id 00721157ae682-79917ef022emr66389467b3.28.1773327306869;
        Thu, 12 Mar 2026 07:55:06 -0700 (PDT)
Received: from 192-222-50-213.ll.local ([192.222.50.213])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-79917f3bc39sm30625947b3.51.2026.03.12.07.55.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2026 07:55:06 -0700 (PDT)
From: Jenny Guanni Qu <qguanni@gmail.com>
To: pablo@netfilter.org,
	kadlec@netfilter.org
Cc: netfilter-devel@vger.kernel.org,
	fw@strlen.de,
	klaudia@vidocsecurity.com,
	dawid@vidocsecurity.com,
	Jenny Guanni Qu <qguanni@gmail.com>
Subject: [PATCH] netfilter: nf_conntrack_sip: fix OOB read in SIP URI port parsing
Date: Thu, 12 Mar 2026 14:55:06 +0000
Message-Id: <20260312145506.2192682-1-qguanni@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

In epaddr_len() and ct_sip_parse_header_uri(), after sip_parse_addr()
parses an IP address, the pointer (dptr or c) may point at or past
limit. The subsequent check for a ':' port separator dereferences the
pointer without a bounds check, causing a 1-byte out-of-bounds read.

Add bounds checks before the dereference in both locations.

Fixes: 05e3ced297fe ("[NETFILTER]: nf_conntrack_sip: introduce SIP-URI parsing helper")
Reported-by: Klaudia Kloc <klaudia@vidocsecurity.com>
Reported-by: Dawid Moczadło <dawid@vidocsecurity.com>
Tested-by: Jenny Guanni Qu <qguanni@gmail.com>
Signed-off-by: Jenny Guanni Qu <qguanni@gmail.com>
---
 net/netfilter/nf_conntrack_sip.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index d0eac27f6ba0..a232054d7919 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -194,7 +194,7 @@ static int epaddr_len(const struct nf_conn *ct, const char *dptr,
 	}
 
 	/* Port number */
-	if (*dptr == ':') {
+	if (dptr < limit && *dptr == ':') {
 		dptr++;
 		dptr += digits_len(ct, dptr, limit, shift);
 	}
@@ -520,7 +520,7 @@ int ct_sip_parse_header_uri(const struct nf_conn *ct, const char *dptr,
 
 	if (!sip_parse_addr(ct, dptr + *matchoff, &c, addr, limit, true))
 		return -1;
-	if (*c == ':') {
+	if (c < limit && *c == ':') {
 		c++;
 		p = simple_strtoul(c, (char **)&c, 10);
 		if (p < 1024 || p > 65535)
-- 
2.34.1

