Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F207C31AA94;
	Mon,  5 Jan 2026 08:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767601614; cv=none; b=prQaW4eKOzrtYW/6u4YHRWw/OVRS18nH0yq7i86Ai3RgmrIVOpvEH5VK2LAQ4LqR/sfpGaug3xlkp32YbJyUaM14KhNr+tJzXc60By/Mo7pYv5R8XbDORr7ex5msbX2GeEo1v4+KIcr5wGte2zjEHwQFRors54cbZtX+b+2P8+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767601614; c=relaxed/simple;
	bh=M7HLAe90Qbpokyf331eCA/pwNjXKx5PAI1cBuE0OKMo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=XqrcpvgD6l6i8BDL6DUf90pnaBEf4ePfnV8drSEZ2DlG16JJJwz2BVhgDaOhOliYwayyJkw7aYWkJjtxsblgVFpa9Sp8OBZ4hKZpqsmnkBdWruO81d/bXRwCNYi7foGOXi14/HQv7YvddH35eymTlvyg1iqmORDHN4W4R5dK8kQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=csmM31Hg; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=dHgEO3EX; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="csmM31Hg";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="dHgEO3EX"
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1767601611;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Qu0zNe88YkmXZJuzgQmdYipAfyHlqpY82/blAbrTdJw=;
	b=csmM31HgRjc7e1Dy3oZQZgG56/0VcznmFXx5mhkpa3fFOvRg0FCpFFdIdlnUKgPZ3p6QX7
	1pegkHLTiR6lnKjEfs+E3g8rebTRBRj6gpiKeZ2f1FjCclTcTx9+iYTI5MRCc/Zw6oT8Lb
	tcMFKEKT6z5lHKsgeqDcJSshzIZP/SWJwk733+iTWwK20bpfCDsyBqA2Gznlh9+7yCinnG
	eLeCN3KrMTtaxNf6cMFNZQH4MfYRugGaccWy2eqx0uXKI6pK/E8UcRjiChigV2231VA22+
	J0ijF+Qd/8djNbxEZuiS8mIKaeIJ+gUA2RT16jk1JdXwOnf3cgVPsghmKWqBqA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1767601611;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Qu0zNe88YkmXZJuzgQmdYipAfyHlqpY82/blAbrTdJw=;
	b=dHgEO3EXrumQJUiFTfDdVodejds4b8Fju3B65xkLkQqmyAqB5E+qQVGaPANI6B5ioiqCpS
	eZ2x36/mbrkq+NAA==
Date: Mon, 05 Jan 2026 09:26:47 +0100
Subject: [PATCH RFC net-next 1/3] uapi: add INT_MAX and INT_MIN constants
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260105-uapi-limits-v1-1-023bc7a13037@linutronix.de>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1767601610; l=771;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=M7HLAe90Qbpokyf331eCA/pwNjXKx5PAI1cBuE0OKMo=;
 b=gHuSQxVq1/QXx8MzJtYqhw6AG/Xq+ukXL9eye9MGMePXbavcREoV+EY1WkqJzmZsOZkaQt9ga
 ESS0GELn94cBmAUQXHW4ryMNvcjtaSylXjk8msrPEsKAas5WoawVflv
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=

Some UAPI headers use INT_MAX and INT_MIN. Currently they include
<limits.h> for their definitions, which introduces a problematic
dependency on libc.

Add custom, namespaced definitions of INT_MAX and INT_MIN using the
same values as the regular kernel code.

Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
---
 include/uapi/linux/limits.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/uapi/linux/limits.h b/include/uapi/linux/limits.h
index 6bcbe3068761..35ffa2667309 100644
--- a/include/uapi/linux/limits.h
+++ b/include/uapi/linux/limits.h
@@ -18,4 +18,7 @@
 
 #define RTSIG_MAX	  32
 
+#define __KERNEL_INT_MAX ((int)(~0U >> 1))
+#define __KERNEL_INT_MIN (-__KERNEL_INT_MAX - 1)
+
 #endif

-- 
2.52.0

