Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56D643A48E4;
	Sun, 14 Jun 2026 11:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781437589; cv=none; b=sUbT3coleudCCWv/FxxHiOMQIAicpsESMOrXfriIbX4p0jCziLuZ+ZjbCGu76TpH7vP/USKi8zpcxsIeX2FtNJ4IXrQPL12nAo65606qaKH6W+S4BtHd1JqwaB5GyTaF3JTaS9tFagtul50Ij0/Elbon8otl1VSHybd0Aw+HDoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781437589; c=relaxed/simple;
	bh=cFYkkIgoJqwbIIMxTaevYPWwMFtn5O2yjPjfmvV+TKw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ReaUMDIO0s4GvokG3I/4y//8tiowpNgwYtNPtHmfRDqLvvacokCNvWyszGWNCtUbl29NZKSU5cD9EyKcm6YZ9w74UBlUJktfQYngHUkCIuarXIL94vPjBfSS7ufnnbTBiu9dv8hwKXS5Cola9lnR2Lcl4oGuB8x8zTVDAAva3rU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=iPXoX+Ie; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="iPXoX+Ie"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 0C236600B5;
	Sun, 14 Jun 2026 13:46:24 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1781437584;
	bh=nrnghwlJkodSq0H8h//KV2iRzHbcibombOjaGBrtfPY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iPXoX+IebfD5dd3b6jgU/AGftumrKaNAwTU7/0LOHu/qVSHoKlzj4aCo4xx9RQ7sQ
	 ozipdcARVpU8T3ti1InwFlKRE3XvssyCLqPKNxgS37A47/C8nybzb3EGl7gN2RDiHG
	 mfa824Ofcnj1FPyhYauPhC/ReEq2plF/4fxl3uAciBrtfXfJjSGC4xLuAGme0M640U
	 euqysiBWqxLcjEPice8rvr7KRbTh00ntcxqW97wlvabk5dplfUY5Ni+2rk++p9sWgE
	 0wguOgNxTPRaxdmZly/Cb7Yk2zBbxXgvhK2bS0j2vdP2s95CT51PjQseqfrh7M9ePs
	 caIyeku4ZEMcw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next 10/11] ipvs: fix doc syntax for conn_max sysctl
Date: Sun, 14 Jun 2026 13:46:04 +0200
Message-ID: <20260614114605.474783-11-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260614114605.474783-1-pablo@netfilter.org>
References: <20260614114605.474783-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Julian Anastasov <ja@ssi.bg>

Fix the docutils error reported by kernel test robot
for the new conn_max sysctl:

Documentation/networking/ipvs-sysctl.rst:76: WARNING: Block quote ends
without a blank line; unexpected unindent. [docutils]
Documentation/networking/ipvs-sysctl.rst:76: ERROR: Unexpected section
title or transition.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202606071851.Dc1H7hOO-lkp@intel.com/
Fixes: 4a15044a2b06 ("ipvs: add conn_max sysctl to limit connections")
Signed-off-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 Documentation/networking/ipvs-sysctl.rst | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/Documentation/networking/ipvs-sysctl.rst b/Documentation/networking/ipvs-sysctl.rst
index b6bac2612420..fe36f4fcd3a0 100644
--- a/Documentation/networking/ipvs-sysctl.rst
+++ b/Documentation/networking/ipvs-sysctl.rst
@@ -72,20 +72,29 @@ conn_max - INTEGER
 	Netfilter connection tracking) the connections can be
 	limited also by nf_conntrack_max.
 
-				soft limit	hard limit
-	=====================================================
-	init_net:
+	Limits for init_net:
+
+	======================= =============== =============
+	\			soft limit	hard limit
+	======================= =============== =============
 	create netns		platform	platform
 	priv admin		0 .. platform	0 .. platform
-	=====================================================
-	new netns:
+	======================= =============== =============
+
+	Limits for new netns:
+
+	======================= =============== =============
+	\			soft limit	hard limit
+	======================= =============== =============
 	create netns		init_net:soft	init_net:soft
 	priv admin		0 .. platform	0 .. platform
 	unpriv admin		0 .. hard	N/A
+	======================= =============== =============
 
 	Limits per platform:
-	1,073,741,824 (2^30 for 64-bit)
-	   16,777,216 (2^24 for 32-bit)
+
+	- 1,073,741,824 (2^30 for 64-bit)
+	- 16,777,216 (2^24 for 32-bit)
 
 	Possible values: 0 .. platform limit
 
-- 
2.47.3

