Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 786D031ED70;
	Tue, 13 Jan 2026 07:44:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768290272; cv=none; b=ZPGiJCTR2cQYJeLVlsjIfV5J5NUN35o81peNOexJ3334QiXVAECSlfVGQMsR6HuNqtVZl4Qyf6aFtTJGPr0S/c5o5MIz8msulvDFHgAuOS23x7Sbj2f3BpZ8sCUBAwZ+jmaqFPPzQr3RpvN4qH1ShKBXIdnAUCquYgHzDyOvyZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768290272; c=relaxed/simple;
	bh=iANGX4Q6qxYVZYRU4b03ddO8t8QVAF0+rAdnajHaGbw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=cmU8DNhJfss7c83Kpi/EYoHhZrUFgozoqGoU6ORie8ntqbv9FW+ZhrPeonlMBjPLtAY6XYm3AJ1RuIIHY3iBAEVhzgb/BNnws28jHjCBobyqSaTWqaRdO1gWop+jLVnoKUfltBWpPHfrAyx3dcJeIajOMXpbJdg+VOmhowKVaUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=R6IOYhGm; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=spBIs+81; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="R6IOYhGm";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="spBIs+81"
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1768290264;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MWlu9Xbv+hyXYq41qjpldmiCRJPs3xJjYejVCpWHTEo=;
	b=R6IOYhGmf4ezmbVBSysqxJhT6qASkoNfCcM9S14nMcs3tg+unmIFbJ56Vzr6Ucm1glKYoM
	ZIwNfTQFkFSs4D//vWUHb1lsHukpmzLYMJXKhCSFAsjfq3zdh01R6+21+d4A7kSKZYGz5i
	j4AoTnFU8pJIJys7CxNzJeKA7VuoDOKK2QEzp6HWmpXL6XOAOG7JU4zZkyTd37JY4pXiLq
	JtiKQPZ3T+XM+ZTLb6PeMnqih+x07eDUjgUr9fHAJYegxZQOtoz8i99nHWLv6qcvxkXWi1
	8ypRM4UWmubbx89faAoh41PxFLGFG6+hXRhZAxwyE/CxF+i05yw70bXoxkQL8Q==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1768290264;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MWlu9Xbv+hyXYq41qjpldmiCRJPs3xJjYejVCpWHTEo=;
	b=spBIs+81E2CgSWm37WQ/fCFk39/8lchOG8YhFLDdiwXf6BHdoHDelDvpKE7EOXZ0XItjzp
	RgAJ41nHKalHEUBA==
Date: Tue, 13 Jan 2026 08:44:18 +0100
Subject: [PATCH v2 2/3] ethtool: uapi: Use UAPI definition of INT_MAX
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260113-uapi-limits-v2-2-93c20f4b2c1a@linutronix.de>
References: <20260113-uapi-limits-v2-0-93c20f4b2c1a@linutronix.de>
In-Reply-To: <20260113-uapi-limits-v2-0-93c20f4b2c1a@linutronix.de>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1768290260; l=1199;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=iANGX4Q6qxYVZYRU4b03ddO8t8QVAF0+rAdnajHaGbw=;
 b=zkhqxKjVk6PtpV5RIZGdqM5hrdB4PS5fKBYmSgcbha2Ru2pXGRUwVrQJnhbVk15ZeBrmrKYbz
 DpE/h/ut1JzAAEk248OwzdJfTwv1Xb08X2x8YVYq8ZSGVsuvxUZeQc4
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
index eb7ff2602fbb..70a0ef08f6f5 100644
--- a/include/uapi/linux/ethtool.h
+++ b/include/uapi/linux/ethtool.h
@@ -15,13 +15,10 @@
 #define _UAPI_LINUX_ETHTOOL_H
 
 #include <linux/const.h>
+#include <linux/typelimits.h>
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

