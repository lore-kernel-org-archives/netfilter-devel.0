Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B78925E476
	for <netfilter-devel@vger.kernel.org>; Tue, 25 Mar 2025 16:58:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742921933; cv=none; b=IfrtGJipfYi0RfzCwPx0ThjkjpAcaWgMvr9qK0ss/pneu4AR27dw3XV+IT89PPhMPTwaaP/1XJm01YVeJJ2rQSPJ+/wD+SVb0Hkk7YqlcOauWpoZNYlV/KjVq++Q2pIaMi3paYK4sKjlmEILNyc7AfxSsZ8nslpGOVnvP7W99BE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742921933; c=relaxed/simple;
	bh=MPf8A7MXindDNC/5vBCWCpI+ncXRDv/qD66R7jrbu9o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m9zOheKGXhbJw3XaAONqUPViB93X4z42wFiPU7lJWlvJ06kc0v0RA7jxB6Ma87zNEUjZN87YuFuDshk0g9oZ39wcmlzi47zSWC2BtwRSWAzJdC+Dk8K0+s93pF9a/VkSNWl8poWNCe5TnruJQuJDckQqeG3yTThSNBAlGhy2qkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=G+7ToF5f; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=Qyei/5X0; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="G+7ToF5f";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="Qyei/5X0"
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1742921923;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YYcUNrMs/2txkdCFGEytJoLkDONX67EI9lG9CRSJ5Ms=;
	b=G+7ToF5f9SKhciG38Lv17CG+AtLz2LIuHL3YHVXvnweROVI3if6iAEL3UDhp0KBDRIP65c
	m36rwqf6EGWVLcTyG37prVKAoYVsql9xC7PM2YJ6UkmnC0lZHDMKYnuHxeD1WaFY5Jds+W
	qblj87wAD31ldOR3KOhVwsHLqqsKUEBsR3kntT+V6j5QlOKLrHINMKACtfZLsMdJVLHeB7
	46lfwyWiQuAeXo+xoCDSw/GmYp3izWIdxIML5Q8iRQ6chbPldVLhkClA07Gu/+CC/pAfDS
	l6OtKvIrnDNqJgC7BERK/KmIoSScq8mcsvjqM48ddwrxB3/+DLUwaQ+n1n1Uow==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1742921923;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YYcUNrMs/2txkdCFGEytJoLkDONX67EI9lG9CRSJ5Ms=;
	b=Qyei/5X07hHehoFpdph5nlicYPpEkpcqXjRiizWkf8HNsKBhUZjqnA7zvBu1hjpoBNIXCx
	a1oc6EFOGkEGU6Dw==
To: netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	linux-rt-devel@lists.linux.dev
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [net-next v3 2/3] netfilter: Let IP6_NF_IPTABLES_LEGACY select IP6_NF_IPTABLES.
Date: Tue, 25 Mar 2025 17:58:31 +0100
Message-ID: <20250325165832.3110004-3-bigeasy@linutronix.de>
In-Reply-To: <20250325165832.3110004-1-bigeasy@linutronix.de>
References: <20250325165832.3110004-1-bigeasy@linutronix.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Let IP6_NF_IPTABLES_LEGACY select IP6_NF_IPTABLES to avoid builds with
IP6_NF_IPTABLES_LEGACY enabled but IP6_NF_IPTABLES disabled.

Suggested-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 net/ipv6/netfilter/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv6/netfilter/Kconfig b/net/ipv6/netfilter/Kconfig
index 490200b7c2094..9ab8ef510dcfa 100644
--- a/net/ipv6/netfilter/Kconfig
+++ b/net/ipv6/netfilter/Kconfig
@@ -11,6 +11,7 @@ config IP6_NF_IPTABLES_LEGACY
 	tristate "Legacy IP6 tables support"
 	depends on INET && IPV6
 	select NETFILTER_XTABLES
+	select IP6_NF_IPTABLES
 	default n
 	help
 	  ip6tables is a legacy packet classifier.
--=20
2.49.0

