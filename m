Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54BB91D54B
	for <netfilter-devel@vger.kernel.org>; Wed, 12 Jun 2024 13:04:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718197474; cv=none; b=SaDWsX3/Q51JdfI4CFCCNVwJgQ/SpNp8Suu7LLieLg0B9wa4wdZxAMlajMKBCLdaJ00ZRrbHVOXvQ42RcNFiyA+uYGGdWXut+PHynQi2yNpuxZmaxURiydV21Lm/h/s9y0G8AW+INmjutB3jwXF/XSBkpsbGGoB6goukN5P7sO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718197474; c=relaxed/simple;
	bh=Xcm9/4XeicLEDVf1PQzlRcGa6o/RYegKVo6SYKvK/Tw=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=kqexCCUoyRLr4qHVjH0vcUwAgKo39pDH2l+3ZRkGoQ0GKloeKTQol/y6O6Bj5llzyp4SWRBaNPSH45OoA2aph6GLFGqEhDbWsX760KExFWLn9ZLgflCTS6ZjqY+51tAd6ErQ2Hsx6bNdvc6X8uYduJRt/ei+L09Z/HS+R/IZi/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=qnId3n9P; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="qnId3n9P"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=h0zXv3KL+OPyYpEeBOXWrausG0dfC03gG+idmvti+ko=; b=qnId3n9P0jjhxe2pww/j3Od7lJ
	7q7XklxL4KwxkCGBphm+Ch7IiG3e7Lt8AtnekUZeGb7u2S0Y4/IcMMXiwRVlwNyEKAOM0+EtaBdZh
	RhJKMCPQJWthrQtdHwoCJ08U90mxIO37BaXuY0vcpkaLvnRr8AEup6matX2+sQHvMt7046AUTS5CB
	Lu6aljonVWlZN0n5mgbkGzJE9fmwSD5a/7ezeP3PI75U2PqwZRmMfZzSQxbHVBXxXgBu0/n9yw3oz
	0mCcEVwOQjhG/uAsjRi5Ks4hVVHiZ7aPzSwDwog7BV6mlDPgAqvoOKaAnLi5LTRYmxcZZCy4xZT5A
	mZQ95dFg==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1sHNHl-000000006cT-2F2E
	for netfilter-devel@vger.kernel.org;
	Wed, 12 Jun 2024 14:41:05 +0200
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: [iptables PATCH] man: extensions: recent: Clarify default value of ip_list_hash_size
Date: Wed, 12 Jun 2024 14:41:07 +0200
Message-ID: <20240612124109.19837-1-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The default value of 0 is a bit confusing.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libxt_recent.man | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/extensions/libxt_recent.man b/extensions/libxt_recent.man
index 419be2579594d..82537fab9846f 100644
--- a/extensions/libxt_recent.man
+++ b/extensions/libxt_recent.man
@@ -97,7 +97,9 @@ Number of addresses remembered per table.
 Number of packets per address remembered.
 .TP
 \fBip_list_hash_size\fP=\fI0\fP
-Hash table size. 0 means to calculate it based on ip_list_tot, default: 512.
+Hash table size. 0 means to calculate it based on ip_list_tot by rounding it up
+to the next power of two (with \fBip_list_tot\fP defaulting to \fI100\fP,
+\fBip_list_hash_size\fP will calculate to \fI128\fP by default).
 .TP
 \fBip_list_perms\fP=\fI0644\fP
 Permissions for /proc/net/xt_recent/* files.
-- 
2.43.0

