Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60ADF35200F
	for <netfilter-devel@vger.kernel.org>; Fri,  3 Jul 2026 05:05:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783055117; cv=none; b=Kx8k2oCx8hgqivaNMHRG7MJqrsocCPUQrhLocrI93HkVakA7kndy0lkGSgJC+NUSiwnm7w2cuIl7C53YVEQdiJFHoKczIiNrnd5H9yYTBOeoGL5i6BxBxCSOAu6TBB0UrmDXRu3lPxlYcChV+HRIr4LLixIm1Sqtm92PDOV9k8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783055117; c=relaxed/simple;
	bh=c2zTxkD/tj/AfES00U6BVfsn9sxXSUptDTE8lQNz1mY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KwvSarZzxpwXBtRU4awz6/mhgpiGFlpIT0R+RCPWrc4BIrz80YLSUT/EYq31ROm1hY7TG/SlHJ0NSxLBgClPtFbPt4InEl9SdCBA/FTognMUknP5mpC7aCZDgr8J6oABmHHGT+twVnUOcYxIaIlt7LVV3KRCkF/bvfALiMEFAw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SzrKu9Gc; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SzrKu9Gc"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2c9e89fded0so1143235ad.2
        for <netfilter-devel@vger.kernel.org>; Thu, 02 Jul 2026 22:05:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783055105; x=1783659905; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FJa7tOBZi85FkdnP5sSxIgLuhJpndtu0UGPKVjt9qKQ=;
        b=SzrKu9GcWITbFy6ZIQqZSynBWNfLZRDJPZHUJcaG4MNyokN0lzOHS5LdhXX3Nk4uBC
         LOMY8yxTXyqw1nGtIN8b+MpSkEjJWl3BIr7l1W1dENTX86qWaDPeqdDb+8Idsc/bggkk
         CqoTaOHEMikio03E+HCvlWwLUHZa1ZSPuptf+rbp4rEDOzsCAqqhgnWYPAaCyFcD9235
         O3D+iICovasR/jqa3OqlHcul+N0dktG7+fiw6IEbZIP8JVLw7LHk1pdlBhL6R+aBM75k
         mkyASqav4uPxkm+rSMw9stYo56ZNq9fh12/4D3lfB6MgP2KibC4r67Te4XV6KzkxPZQ3
         BogA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783055105; x=1783659905;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=FJa7tOBZi85FkdnP5sSxIgLuhJpndtu0UGPKVjt9qKQ=;
        b=JMJoPXqMpOMG5lugILsyXNW0lv+1k6JGaQ9YGBaCiL/24BgUKg8nQxmWJwG7XB/Epc
         e+hrRaNJfkftRWKZDefdoEiw1pog6+xea3boYyuLECWAk5ncUSmrzmO1YXwPg0y/wDPA
         rkt1Q8H5F6QWKSzqL2YMHEXtaQCwtR+bX5yFrBI4WlWqMR8bL+cg9Soa9VDAA2h6M40t
         q/AJ9uENPX6aI4mwu7JmHx71K8arTKTvx4b95Cyb+VKbcLEm8YXoYoad1CkVc0sTDFhn
         3SikRRMadHQx0MJScr3KmANmu0xmeR1siQ+wNuUZd3zpyfkwAHrpQaNdVdoxhbbtgHND
         Li6g==
X-Gm-Message-State: AOJu0YyNMABUwOjF/NvyU3yt04cPDrTLdyiwdalZoDHLSCL4iZh7dR6T
	/clfyIt8+s6NCWb97fKXNmI1mugJ6ht2RCKRJe4DlxlmAameOxwR2tzghyo0xvMZ
X-Gm-Gg: AfdE7ck9FWki4BfbJyRUWbSYm6TZCikc+W/7ZRbxDHlrKnhozGcC4PPYsvLlSUosVTH
	QwRC5O9gC0HwpQ2XwjuBGY7M0GDFLfQOdhh7gkQM5IYIztxQ4E2S3ru+OiZVFylUcKDm+0n+7Dd
	Fp9O2E8cL9VdQo3zj1JK2QbIqKNjJUULmC5fVi8FfMq+N4HP0qtaOoynZDGlNst2UD0f+DIIrkA
	Z4rv7je8niPyiuqPI2YBugyCzTlBtSQ2c41/p5gegH2+sR3RHSXtLqFnf4Gbg0TgHfOZbn2FOna
	CGIde7XkAlld6ORltYahUMQLMIlHcBySAvnp2+GDxCuDyes9O36hOk1QQOx3I7ZNpQY7VMXlid5
	zIcd8u42+KGhKW03Mg0MWPh0iAhmQbvTWGI8XdK54X3IoE4nTXVXA55RcCzcQ1OttacE9tE61Mc
	Vi7HELx9LQdOe3ItRc2mKHA9mFR2NY
X-Received: by 2002:a17:902:fc50:b0:2ca:e090:e37a with SMTP id d9443c01a7336-2cae090e98dmr2302745ad.47.1783055104430;
        Thu, 02 Jul 2026 22:05:04 -0700 (PDT)
Received: from enjou-Legion-Y7000P-2019 ([165.232.167.5])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cad789e7ebsm3279545ad.81.2026.07.02.22.04.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jul 2026 22:05:04 -0700 (PDT)
From: Ren Wei <enjou1224z@gmail.com>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	horms@kernel.org,
	jack.ma@alliedtelesis.co.nz,
	yuantan098@gmail.com,
	zcliangcn@gmail.com,
	dstsmallbird@foxmail.com,
	bronzed_45_vested@icloud.com,
	enjou1224z@gmail.com
Subject: [PATCH nf 1/1] netfilter: xt_connmark: reject invalid shift parameters
Date: Fri,  3 Jul 2026 13:04:46 +0800
Message-ID: <e06220ea18c49ec3d6bea1b42fe05b4ff152bd37.1782853619.git.bronzed_45_vested@icloud.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1782853619.git.bronzed_45_vested@icloud.com>
References: <cover.1782853619.git.bronzed_45_vested@icloud.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Wyatt Feng <bronzed_45_vested@icloud.com>

Revision 2 of the CONNMARK target accepts user-controlled shift
parameters and applies them to 32-bit mark values in
connmark_tg_shift().

A shift_bits value of 32 or more triggers an undefined-shift bug when
the rule is evaluated. Invalid shift_dir values are also accepted and
silently fall back to the left-shift path.

Reject invalid revision-2 shift parameters in connmark_tg_check() so
malformed rules fail at installation time, before they can reach the
packet path.

Fixes: 472a73e00757 ("netfilter: xt_conntrack: Support bit-shifting for CONNMARK & MARK targets.")
Cc: stable@vger.kernel.org
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Zhengchuan Liang <zcliangcn@gmail.com>
Reported-by: Xin Liu <dstsmallbird@foxmail.com>
Assisted-by: Codex:GPT-5.4
Signed-off-by: Wyatt Feng <bronzed_45_vested@icloud.com>
Reviewed-by: Ren Wei <enjou1224z@gmail.com>
---
 net/netfilter/xt_connmark.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/netfilter/xt_connmark.c b/net/netfilter/xt_connmark.c
index 4277084de2e7..b7fdc3e9d423 100644
--- a/net/netfilter/xt_connmark.c
+++ b/net/netfilter/xt_connmark.c
@@ -103,8 +103,14 @@ connmark_tg_v2(struct sk_buff *skb, const struct xt_action_param *par)
 
 static int connmark_tg_check(const struct xt_tgchk_param *par)
 {
+	const struct xt_connmark_tginfo2 *info = par->targinfo;
 	int ret;
 
+	if (par->target->revision == 2) {
+		if (info->shift_dir > D_SHIFT_RIGHT || info->shift_bits >= 32)
+			return -EINVAL;
+	}
+
 	ret = nf_ct_netns_get(par->net, par->family);
 	if (ret < 0)
 		pr_info_ratelimited("cannot load conntrack support for proto=%u\n",
-- 
2.47.3
