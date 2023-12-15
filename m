Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D2B94B159
	for <netfilter-devel@vger.kernel.org>; Fri, 15 Dec 2023 21:53:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="RHJ2y6Zy"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Ijmt2Y6TFVURZGDO6kOwXH0uS0JYliOTLLn7/qKdFFY=; b=RHJ2y6ZyfAnnOreVk7vwgi3ve5
	79jTMwq1ENvqTMa5oIe+MCy0WufS+VcL7krx5dku8j5Z03lhWAimbI8NI1dr8puJLDYfzlmXe3ETa
	KFizg0vcc+y8qSo9FPLAZn20CUQ53y2maZIq8Ep4Yks6vbE2PUoLsTtu9k9C+up66fKQ+pNhfm0LJ
	sSDaQeafbVZ4XqUUm9CLGFCAmYb4bQ25IvUiPR6cf3qi4VqdsZg+ru33UJMJT2baZlWCUIfkOGJZb
	F2Q5TFIeuSgvT+1x30CgMgPVezzdZtGYu+Qd01GojaR3Va8uT8j2pKo6+9DlE2wU1yMPLqYCEw1B6
	Z1BOEziQ==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.94.2)
	(envelope-from <phil@nwl.cc>)
	id 1rEG83-0001Zf-9U; Fri, 15 Dec 2023 22:53:55 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>
Subject: [libnftnl PATCH 4/6] include: Sync nf_log.h with kernel headers
Date: Fri, 15 Dec 2023 22:53:48 +0100
Message-ID: <20231215215350.17691-5-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231215215350.17691-1-phil@nwl.cc>
References: <20231215215350.17691-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Next patch needs NF_LOG_PREFIXLEN define.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/linux/netfilter/nf_log.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/linux/netfilter/nf_log.h b/include/linux/netfilter/nf_log.h
index 8be21e02387db..2ae00932d3d25 100644
--- a/include/linux/netfilter/nf_log.h
+++ b/include/linux/netfilter/nf_log.h
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
 #ifndef _NETFILTER_NF_LOG_H
 #define _NETFILTER_NF_LOG_H
 
@@ -9,4 +10,6 @@
 #define NF_LOG_MACDECODE	0x20	/* Decode MAC header */
 #define NF_LOG_MASK		0x2f
 
+#define NF_LOG_PREFIXLEN	128
+
 #endif /* _NETFILTER_NF_LOG_H */
-- 
2.43.0

