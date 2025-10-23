Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0837428D8ED
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Oct 2025 16:14:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761236081; cv=none; b=fjVMDvpnoim5ekjBvslamNB6YlxnowsYx+X/V/D2VWUqq51gzU40tInTnSMSxv0i/7ng/G1f9zebeiAnB/f8MgcWjJtgrnl/w6P+ZvY+ontZwxFTuFDB2dAZxID/WIx6ubWCpiTt2E6gMqqL3JlP8xA9PP3V2HuIJN0Ta6TmMcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761236081; c=relaxed/simple;
	bh=+FNFtp+Wa6AaCoxQSZguGjxlckP6Q8OLVRug7bepIFA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IxhLrkdC1e4TSb7qylkw5WALK4f0iOeLIB890w1K/Jsn6NxcVuqBXL8UXAaMdBYu4mrnF7aAYGeDqG3zdPbJjJJe1b0YnjPZOSag/R4eoAg+guldRfZt4BxpK1NhVVo/Wecp7zAaZLpPhJy7XfxZgOsN37iLnyzy20omKzdajA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=i0aAwnHC; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="i0aAwnHC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=VJk2orBueLyYCTJXgD8OUZEy2KK58TQ4qlTXScTSbeA=; b=i0aAwnHCoBt0NfStsBcpEcKzM6
	VuW0D7a/CQigx9WV8ndjMm098foTXsP68LjHQ6yFyK6Aoydfp1HPqxUcZQVEnhihU0t8tjyv8UMFJ
	zZiWs4Pvz/OxAnVNPwrDx/vHPsY/3ojYHUloJF8gDrHedfyEuUQ9wJP7RFprf87Nmt9oWjB/6qsWz
	++S8KBy8fEJXqVSPOQA9uiJ661P1ameb8MLchkig26l3uCHPEdp48+eL0kTf7PiKZV4uwEp5I6dS1
	GKOPILPLGetiEyKO9QmnGOIgYylTUs4+/DMVpVjDxhNDPqEGI7CM8grLu/k+SvoUC7gtbqYOwZVg2
	5QzcNI1w==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1vBxxV-0000000005p-45zY;
	Thu, 23 Oct 2025 18:14:38 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH 27/28] utils: Cover for missing newline after BUG() messages
Date: Thu, 23 Oct 2025 18:14:16 +0200
Message-ID: <20251023161417.13228-28-phil@nwl.cc>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251023161417.13228-1-phil@nwl.cc>
References: <20251023161417.13228-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Relieve callers from having to suffix their messages with a newline
escape sequence, have the macro append it to the format string instead.

This is mostly a fix for (the many) calls to BUG() without a newline
suffix but causes an extra new line in (equally many) others. Fixing
them is subject to followup patch.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/utils.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/utils.h b/include/utils.h
index 0db0cf20e493c..f47e7eb8d8093 100644
--- a/include/utils.h
+++ b/include/utils.h
@@ -45,7 +45,7 @@
 #define __must_check		__attribute__((warn_unused_result))
 #define __noreturn		__attribute__((__noreturn__))
 
-#define BUG(fmt, arg...)	({ fprintf(stderr, "BUG: " fmt, ##arg); assert(0); abort(); })
+#define BUG(fmt, arg...)	({ fprintf(stderr, "BUG: " fmt "\n", ##arg); assert(0); abort(); })
 
 #define BUILD_BUG_ON(condition)	((void)sizeof(char[1 - 2*!!(condition)]))
 #define BUILD_BUG_ON_ZERO(e)	(sizeof(char[1 - 2 * !!(e)]) - 1)
-- 
2.51.0

