Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7875834AB06;
	Tue, 13 Jan 2026 07:44:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768290272; cv=none; b=EH2nRHzuKLwY2XOIOO9n4ow5AMbU0tj8FLI+ytz7qVbN9tfHDVGz5veLmIGb5LqrDbJUdVtydG+GfL9ul9HqSvaNWPo55cKSEs5lMotdBiG/muJq7k0Zud6+BEGz4oeJusZoTklKXStUT9i3cGBGwDRBS+yDgxfGkj8RZE7uXAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768290272; c=relaxed/simple;
	bh=dDGinnEv/hwDI6n919dQ+WdzmoAGg5PXMDNfoTENOgA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Dq531DcFjrvKN/bmaa0w8HBAVI7UFImsSqSsqKROvec5zl2x8UqJ54nNa2POjIf9Dsi52EWwXPobfnrWi6vdK8bRQAitfuD+VPonB+i5MocGZO9CR8lALWzsDOfxsgLcY2FDIv7lgeGsWIkn0wUdHG84TkmoE2tg+kySyNSaXgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=0jmRUgCL; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=fIAbCzPZ; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="0jmRUgCL";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="fIAbCzPZ"
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1768290263;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+B+tiiOSgm0hNIzNpQ9/RnXH1HzC16eEaSpprAwZNQY=;
	b=0jmRUgCL/Z8hAJAS/msA7fjSJnr1ZTfs/4ox8FL0ueksJYgLZkIIRcEtCfTv8V8AlfBXS6
	IMggIF6hCDbGBqy36XH1Sxh8EfvRzZQlqGfXL+E5RIIfncYG3peA3YGT5k5sDzZsPtMHIG
	WRTtOwUbHisM7/0CDgT0eMJLS7HnfMEB+5BpJO7F2329q5O4BrFgl+xldAUJZhJWV96+un
	L6iWlzyW/g4tBxtS7cHcC0OLI7Ow1IoOnYt3OFJ9qQEYQ4a2A1ybh0ky2I2cuDkWipPQcI
	Edn8quYSeCr3kiYROOST6NFuoWankO+ZUWluToSewLI2pMUnlL/SFJ5OfCVqSg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1768290263;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+B+tiiOSgm0hNIzNpQ9/RnXH1HzC16eEaSpprAwZNQY=;
	b=fIAbCzPZrFMK9p30OH+aZEKjqTrRAFXRd4StLlKiZvKcVjsW1nl3y6rGBKr5Wwi66A6ZuY
	36BztfytdJqCCTCw==
Date: Tue, 13 Jan 2026 08:44:17 +0100
Subject: [PATCH v2 1/3] uapi: add INT_MAX and INT_MIN constants
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260113-uapi-limits-v2-1-93c20f4b2c1a@linutronix.de>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1768290260; l=1051;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=dDGinnEv/hwDI6n919dQ+WdzmoAGg5PXMDNfoTENOgA=;
 b=maD6p1KKzhdv5+qN58UP+OWyZLDZ5D7EM8Qo1aGkS9UxCSDQgj8UBPivyDsy3cFnEpZFZfGaM
 6r3m1/t/ElHBiUf9RsVgyrhuUZ3lf8T+RUR9BDwRp5JJGTTfFhLP2WZ
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=

Some UAPI headers use INT_MAX and INT_MIN. Currently they include
<limits.h> for their definitions, which introduces a problematic
dependency on libc.

Add custom, namespaced definitions of INT_MAX and INT_MIN using the
same values as the regular kernel code.
These definitions are not added to uapi/linux/limits.h, as that header
will conflict with libc definitions on some platforms.

Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
---
 include/uapi/linux/typelimits.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/include/uapi/linux/typelimits.h b/include/uapi/linux/typelimits.h
new file mode 100644
index 000000000000..8166c639b518
--- /dev/null
+++ b/include/uapi/linux/typelimits.h
@@ -0,0 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+#ifndef _UAPI_LINUX_TYPELIMITS_H
+#define _UAPI_LINUX_TYPELIMITS_H
+
+#define __KERNEL_INT_MAX ((int)(~0U >> 1))
+#define __KERNEL_INT_MIN (-__KERNEL_INT_MAX - 1)
+
+#endif /* _UAPI_LINUX_TYPELIMITS_H */

-- 
2.52.0

