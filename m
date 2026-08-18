Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 221DD472540
	for <netfilter-devel@vger.kernel.org>; Tue, 18 Aug 2026 12:27:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787056079; cv=none; b=PFbDIZDXnTODueZXv6zo5qsQblxpt010hG9vfdrEO5Q7WdbHiJjhIQmpiRBeP96zjPbYCW0vIF2FF3ZZlSBGgWAtfV1fCv3UWGPpt+ANuC0He7Re3kmY+GmlbPZPezFGH5XL0pO97Mt8Vdl4QOkUpNfPKGJQZf6YyLZVK931S5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787056079; c=relaxed/simple;
	bh=XPB3UBbGesrqLgOIVR7UNZKsdqEel0CIIfBSs4NdGLc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=evTGps7HZUeRZWnheU9TMFQfXUHbLSmyFjkzYHAjd4+YWsVBHo94jhFhqdECdxgIomiIE+OhjIU0vL7OzXLvQ92oxEAW6gaQwaYuG7ntrtc3Ih/ErTWHdv9te2wO4JyfSPy1/akoSTJ/voT9J0JJD15YjKGwjsesZEelUQJLGls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=SLW7ntXS; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="SLW7ntXS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1787056073;
	bh=Ik5MsqOImy9JRqwhdda46UzV1pW6xH1XJBq9uSEb3uQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SLW7ntXSfaWETVaDLZqW6kKTVRPKMYcNRseq5yci/MxQNvUeTbuqe+gS+1lnNjj4B
	 8adNQD0fl6Vn7redTIc7eQvlZZzdWsIdU0YVms8ARJXn8Ool8is8164H/SPPMcOOQM
	 vqTqOv5+rFB1xe1k4DTQiW4HC+A+lM5e2+4HFtuhsYblOrRQopWtytlbB4EzgRsRHX
	 06H/Bm5PVc02fd99OHMbG9kxrcIjqKW4vqyAYnH/ez3EQckYxVMlAlHlOEDJKRImTE
	 QCqlpmbEuqAs0RL4DdYL4MFEwu7UmyORAjsK1YOajZpGwIqRYVcyRrrP0/2zMIao1V
	 00woJKtnv9qUg==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 45E586005E;
	Tue, 18 Aug 2026 14:27:53 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de,
	fmancera@suse.de
Subject: [PATCH nf-next 2/4] netfilter: xt_CT: check for nul-terminated timeout and helper name
Date: Tue, 18 Aug 2026 14:27:39 +0200
Message-ID: <20260818122741.1329660-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260818122741.1329660-1-pablo@netfilter.org>
References: <20260818122741.1329660-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Otherwise, ignore malformed helper/timeout string that userspace
provides.

Fixes: 84f3bb9ae9db ("netfilter: xtables: add CT target")
Fixes: 24de58f46516 ("netfilter: xt_CT: allow to attach timeout policy + glue code")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/xt_CT.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/xt_CT.c b/net/netfilter/xt_CT.c
index e78660dfdf4b..91326014ade1 100644
--- a/net/netfilter/xt_CT.c
+++ b/net/netfilter/xt_CT.c
@@ -195,7 +195,8 @@ static int xt_ct_tg_check(const struct xt_tgchk_param *par,
 		goto err3;
 	}
 
-	if (info->helper[0]) {
+	if (info->helper[0] &&
+	    strnlen(info->helper, sizeof(info->helper)) < sizeof(info->helper)) {
 		if (strnlen(info->helper, sizeof(info->helper)) == sizeof(info->helper)) {
 			ret = -ENAMETOOLONG;
 			goto err3;
@@ -206,7 +207,8 @@ static int xt_ct_tg_check(const struct xt_tgchk_param *par,
 			goto err3;
 	}
 
-	if (info->timeout[0]) {
+	if (info->timeout[0] &&
+	    strnlen(info->timeout, sizeof(info->timeout)) < sizeof(info->timeout)) {
 		if (strnlen(info->timeout, sizeof(info->timeout)) == sizeof(info->timeout)) {
 			ret = -ENAMETOOLONG;
 			goto err4;
-- 
2.47.3

