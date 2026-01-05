Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 899E83314A9;
	Mon,  5 Jan 2026 08:26:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767601615; cv=none; b=KX/3rv6KZNFx1+lxpsO6zMl6969W/zHxi18FqS7zNWvQ8UjkFX65/y5fbe39KgetF2xIV/sQr3Xy8u7Y/HOyhylzqTLUwbaOJ0wYt+M0zSnv2A+GPLzkjUXpR3xkGS7EJVISf7TPumlFGR+Ey1rXzZncjcaDn+5pxSkOh/xqYtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767601615; c=relaxed/simple;
	bh=NLm5MuB4qw8Iur6kOFL/Cq64vy6/cvlOgwEDQ2/NMys=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=kCMy0T/z60PMI0RcWu+QHmpaAxHkDCwYa8Puh5V7qlYjfE2CWdcojGk8iBJQZmW3McV7WalVNGXwIYhAuOJqB/XuQs7D0sh0HKfrluP6xwcp1Uls3ctlqjnfCwmgwc/D7EaI8IY0IDpuqpyQHy6SzSg2rbGlCn8zbH6H7l+yF2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=FPpY+BjV; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=j3+jTxXA; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="FPpY+BjV";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="j3+jTxXA"
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1767601611;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=c0EjK/xZ508m8ZLhWyIV/BZR47eYN0XRtYc1n0RBlPg=;
	b=FPpY+BjVT5rgr+ojj/rGN+mfWwhSbU8T15zYUjpx0ofVwZWyJUa/ky3mrfKicUfIwSFsKd
	hpy7zeR4CMsxUA47wvcUEO0QL7jDE20CxVUi6V5SC2DRvtOhsif3oSJ8xQ3Bej8uMXkDgn
	aJMpNHb+FaUE1jOzZlhPfSZ7Vxg3FVMIYu4uThB9jsvVPh+1qm+Nf+baEPrMcGkQZstf+3
	hpRW6Z/YQKjSn3ED/v6CAtpua3yLccoyPID3zWJ1J52SV54dcsK/xGLg3C7SnDNKlHdR9K
	E8sU6sswY5kSlLMklMrGFM14SMmDyuFD58OqtHWLE88QeOI/038w1AB6k8ivCQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1767601611;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=c0EjK/xZ508m8ZLhWyIV/BZR47eYN0XRtYc1n0RBlPg=;
	b=j3+jTxXAHUyk7yYpJZgVxAIOwxvNmwZ8JmtCIAj20prJq5ze77V80UBUNJnVGevoMY0UZN
	FRfG/oYjaEkvxoCA==
Date: Mon, 05 Jan 2026 09:26:48 +0100
Subject: [PATCH RFC net-next 2/3] ethtool: uapi: Use UAPI definition of
 INT_MAX
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260105-uapi-limits-v1-2-023bc7a13037@linutronix.de>
References: <20260105-uapi-limits-v1-0-023bc7a13037@linutronix.de>
In-Reply-To: <20260105-uapi-limits-v1-0-023bc7a13037@linutronix.de>
To: "David S. Miller" <davem@davemloft.net>, 
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
 Andrew Lunn <andrew@lunn.ch>, Pablo Neira Ayuso <pablo@netfilter.org>, 
 Jozsef Kadlecsik <kadlec@netfilter.org>, Florian Westphal <fw@strlen.de>, 
 Phil Sutter <phil@nwl.cc>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org, 
 netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, 
 coreteam@netfilter.org, 
 =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
X-Developer-Signature: v=1; a=ed25519-sha256; t=1767601610; l=1195;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=NLm5MuB4qw8Iur6kOFL/Cq64vy6/cvlOgwEDQ2/NMys=;
 b=VyitLZaUJpnI0WhdJ2xm/BdP0eQwYT8My04ZcTTQm+6ijga8HfaT+A6GmCwClF21AOGu9Ee2P
 DBdCmoBBEdUB/9r/h9+wdwRlX95qRx0zPIFcnQZ9pUNAl+4xQBpJcZa
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=

Using <limits.h> to gain access to INT_MAX introduces a dependency on a
libc, which UAPI headers should not do.

Use the equivalent UAPI constant.

Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
---
 include/uapi/linux/ethtool.h | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
index eb7ff2602fbb..9500236a9d2e 100644
--- a/include/uapi/linux/ethtool.h
+++ b/include/uapi/linux/ethtool.h
@@ -15,13 +15,10 @@
 #define _UAPI_LINUX_ETHTOOL_H
 
 #include <linux/const.h>
+#include <linux/limits.h>
 #include <linux/types.h>
 #include <linux/if_ether.h>
 
-#ifndef __KERNEL__
-#include <limits.h> /* for INT_MAX */
-#endif
-
 /* All structures exposed to userland should be defined such that they
  * have the same layout for 32-bit and 64-bit userland.
  */
@@ -2200,7 +2197,7 @@ enum ethtool_link_mode_bit_indices {
 
 static inline int ethtool_validate_speed(__u32 speed)
 {
-	return speed <= INT_MAX || speed == (__u32)SPEED_UNKNOWN;
+	return speed <= __KERNEL_INT_MAX || speed == (__u32)SPEED_UNKNOWN;
 }
 
 /* Duplex, half or full. */

-- 
2.52.0

