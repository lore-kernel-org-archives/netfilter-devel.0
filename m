Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A25A28EC
	for <netfilter-devel@vger.kernel.org>; Sun,  6 Oct 2024 16:36:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728232620; cv=none; b=N3w8sBHKm8rK7m5tMuSZtq1r8nuf9JYD3vQkzo0h+jbH34uqhygksBJBWez8feGC94voOXuhvIFssyTsrwlmeWTAuxWe/khWVRuiJFEB0XHC1ek1akIXDbUmUfQqVpWBaYl423cgzy5ZDGBo2EEfddS1oWj9wnBp8VcztlKc1BM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728232620; c=relaxed/simple;
	bh=7aIJceFZoCbWppGkbD1g85RdznYyiV0RP83KyCETycw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nn25PxLZwP+HxfpmhN4KRGoDUOruRm4j8L6KPKgK/8dWS4naDirhDKsYhY48hxgVz5mXBi6bMKSqnEbyZ7YTEh2cnUiqLo1c+ENk9A6+iv1HmEY+z1ixizORQwwxF502hmx1Bx/MkfB+8lydPYftXSsgrMFUmYZWAyf+h0Bw9KE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=rjp.ie; spf=pass smtp.mailfrom=rjp.ie; dkim=pass (1024-bit key) header.d=rjp.ie header.i=@rjp.ie header.b=rmCk3RmL; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=rjp.ie
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rjp.ie
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=rjp.ie header.i=@rjp.ie header.b="rmCk3RmL"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rjp.ie; s=key1;
	t=1728232613;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=BoUXcAMgqM3pZ7FPTKhdgEtKgsGu2WEJX0fOIVAjpvA=;
	b=rmCk3RmL4QFpgpNekQvZKeIbFf1hy5M1PDicwIEUPw1VK3E9RcVKPXwSCYPJDQUVqhvbLR
	T5hTALBlQkMueoeWjLe6ksjtCAWx7vHSsBDBsd+tEvKxmh/1qyylmq4Y4iyFMTANBXXjVZ
	ds3TwRk8nB4gJo9M35UYc1/IB4KCc0Y=
From: Ronan Pigott <ronan@rjp.ie>
To: netfilter-devel@vger.kernel.org
Cc: Ronan Pigott <ronan@rjp.ie>
Subject: [PATCH] doc: don't suggest to disable GSO
Date: Sun,  6 Oct 2024 09:36:03 -0700
Message-ID: <20241006163621.22929-1-ronan@rjp.ie>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

The kernel can form aggregate packets whether or not GSO is enabled.
Disabling GSO is not a useful suggestion in this case.

Fixes: 05628cdd677d (doc: describe behaviour of {ip,ip6} length)
---
 doc/payload-expression.txt | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/doc/payload-expression.txt b/doc/payload-expression.txt
index 7bc24a8a6502..18ad0215baaa 100644
--- a/doc/payload-expression.txt
+++ b/doc/payload-expression.txt
@@ -134,13 +134,12 @@ Destination address |
 ipv4_addr
 |======================
 
-Careful with matching on *ip length*: If GRO/GSO is enabled, then the Linux
-kernel might aggregate several packets into one big packet that is larger than
-MTU. Moreover, if GRO/GSO maximum size is larger than 65535 (see man ip-link(8),
-specifically gro_ipv6_max_size and gso_ipv6_max_size), then *ip length* might
-be 0 for such jumbo packets. *meta length* allows you to match on the packet
-length including the IP header size.  If you want to perform heuristics on the
-*ip length* field, then disable GRO/GSO.
+Careful with matching on *ip length*: The Linux kernel might aggregate several
+packets into one big packet that is larger than MTU. Moreover, if GRO/GSO
+maximum size is larger than 65535 (see man ip-link(8), specifically
+gro_ipv6_max_size and gso_ipv6_max_size), then *ip length* might be 0 for such
+jumbo packets. *meta length* allows you to match on the packet length including
+the IP header size.
 
 ICMP HEADER EXPRESSION
 ~~~~~~~~~~~~~~~~~~~~~~
-- 
2.46.2

