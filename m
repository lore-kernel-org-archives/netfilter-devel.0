Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0B137FBB1
	for <netfilter-devel@vger.kernel.org>; Tue, 23 Jan 2024 16:49:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706028585; cv=none; b=eYkckZkqGSFOZfWuZQIb3A0NdY7YG/bivaE7cU19FEMvkR+QdFs2m0Ls2csiyiylHGjGiYZIWMr4Z28q+OjVMLamCfv3jqF/PO0dTm5U2xZ6Q8vB70GAoMfoUOVF4LcznJqeQArA5Yc4VQgXFDEnSW9Z+7TrinOKWQPGSy/GCpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706028585; c=relaxed/simple;
	bh=jPNVlhi3pE+gTEIwTJCDJkTlxQliU6zDB+vxytuCKtg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UrYGMKg/xSi4IDPUngMQx+MRZEx+nDx8vPkU9cpWbPRjFNa6tjCzzNMzu5FXEGc2k2+k2dq76TYYcgpLVuyZzHFYWw6Birao96KK9Ywa9B2DFuJJnkIbOZ0D0tYof82RWA2Iqgaaqe8cxtR4fqLJOg0WMAn3p4DQEgmr55jwh+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rSJy0-0001uP-Q6; Tue, 23 Jan 2024 17:49:40 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH iptables] extensions: libebt_stp: fix range checking
Date: Tue, 23 Jan 2024 17:49:33 +0100
Message-ID: <20240123164936.14403-1-fw@strlen.de>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This has to either consider ->nvals > 1 or check the values
post-no-range-fixup:

./iptables-test.py  extensions/libebt_stp.t
extensions/libebt_stp.t: ERROR: line 12 (cannot load: ebtables -A INPUT --stp-root-cost 1)

(it tests 0 < 1 and fails, but test should be 1 < 1).

Fixes: dc6efcfeac38 ("extensions: libebt_stp: Use guided option parser")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 extensions/libebt_stp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/extensions/libebt_stp.c b/extensions/libebt_stp.c
index 81054b26c1f0..371fa04c870f 100644
--- a/extensions/libebt_stp.c
+++ b/extensions/libebt_stp.c
@@ -142,7 +142,7 @@ static void brstp_parse(struct xt_option_call *cb)
 #define RANGE_ASSIGN(name, fname, val) {				    \
 		stpinfo->config.fname##l = val[0];			    \
 		stpinfo->config.fname##u = cb->nvals > 1 ? val[1] : val[0]; \
-		if (val[1] < val[0])					    \
+		if (stpinfo->config.fname##u < stpinfo->config.fname##l)    \
 			xtables_error(PARAMETER_PROBLEM,		    \
 				      "Bad --stp-" name " range");	    \
 }
-- 
2.43.0

