Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCA6628F514
	for <netfilter-devel@vger.kernel.org>; Mon, 30 Jun 2025 15:44:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751298275; cv=none; b=bkS7gTWLUnWFJFkdclK1HjCtGGdJyKYtoaGJzNrFueDwQVvTtDEvQu02azFpHUDGY6IZBkKvtjJ8GkuV7rNT+vrytxepO1cxZhLwfI8wVcW9LycsVpqYYLCHtTe93K/gXyCEueOtzcga8aVSE0/UZLbkxWq9uvIOYaLZNUK6YT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751298275; c=relaxed/simple;
	bh=DZhaEH+q0RQQ/u3SieGkRlUmtDFs8X5fHejKH4igatw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q65pl9sacHt/HfU2BB+JcAUTfclsMlgm4zJ2W+4dCar/x/IyDFD4WVlB77VBpTXm6chW7Ydwvu+EtMWOFLDrgwpoS7Sgyou1WUaJEO8Bwr5AQz9ssW9h4b6SAzrb521UKoNehXjQ4C1wiB4hVgUYUCYbKPWxWdymj0CpFDCy598=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=oIuwf06p; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=9i7HISef; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="oIuwf06p";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="9i7HISef"
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1751298271;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DZhaEH+q0RQQ/u3SieGkRlUmtDFs8X5fHejKH4igatw=;
	b=oIuwf06pjhpqXr6OaUGaOZpuyTcCqIjErVhwve26TaiBV09flDF4ixYwdqXCUdR+v/mDZY
	y8FxWtip1ILxeMVWTrzeaPZ0sfiqKvLwwfkyz+bjXxuG1Rivo9AHtl7beD/vKR++t/UOUo
	4kXcx5J0HjBqz1osUjSvRGyr9BIhxfiKYFjh1Isn/lftYwCHR/tmiwLcfz2xjw0YjrhCf9
	OTMf8qICBLpJXA3XkFAK4nks9wXVgI/j9cHgJMicUtz8uDjzfpMxlCtTVsND474Ha1KGq6
	SsjPATd7J7I3zL9QUG5pB2SB8kXeoA3nWMhmvQq2Sb815I7T1wbUp8IkWHzY9Q==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1751298271;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DZhaEH+q0RQQ/u3SieGkRlUmtDFs8X5fHejKH4igatw=;
	b=9i7HISefaQ6SAGzjcSqsJH7BCYpF1tLrnIbDvHff3xtIhhCpIkBCPypgRCjBuq925+QKgw
	Hjw115TacBFFvZCA==
To: netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	linux-rt-devel@lists.linux.dev
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH v5 3/3] selftests: netfilter: Enable CONFIG_INET_SCTP_DIAG
Date: Mon, 30 Jun 2025 17:44:25 +0200
Message-ID: <20250630154425.3830665-4-bigeasy@linutronix.de>
In-Reply-To: <20250630154425.3830665-1-bigeasy@linutronix.de>
References: <20250630154425.3830665-1-bigeasy@linutronix.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

The config snippet specifies CONFIG_SCTP_DIAG. This was never an option.

Replace CONFIG_SCTP_DIAG with the intended CONFIG_INET_SCTP_DIAG.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 tools/testing/selftests/net/netfilter/config | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/netfilter/config b/tools/testing/s=
elftests/net/netfilter/config
index c981d2a38ed68..79d5b33966ba1 100644
--- a/tools/testing/selftests/net/netfilter/config
+++ b/tools/testing/selftests/net/netfilter/config
@@ -97,4 +97,4 @@ CONFIG_XFRM_STATISTICS=3Dy
 CONFIG_NET_PKTGEN=3Dm
 CONFIG_TUN=3Dm
 CONFIG_INET_DIAG=3Dm
-CONFIG_SCTP_DIAG=3Dm
+CONFIG_INET_SCTP_DIAG=3Dm
--=20
2.50.0

