Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 922752EF9A5;
	Fri, 25 Jul 2025 17:04:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753463049; cv=none; b=kDTl4ycK3IxUfTFPS1w0/9NvCsTNFjnDa70MDnjvvskBk6vRZDPGscE6vifU9VzzD2WS5E1PmF83IaBXJ9ZMMW7HvUWZcQWeUrs3S9ySp8aTQHQ8XtnTlmLnMEb3qDQjRVo7TsxW7OmRJMZVjVZXoKJnGb5T/cM4ROoEQUhIb5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753463049; c=relaxed/simple;
	bh=k21YROWrH7MTpoXWZaD6DvMb69pePrxWRn8XOGPf3ho=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=o3RQ3+w6yKb9ir1draDdVlifIahy8XjXQWVPzX9PDdzDcpO5RE5HJ5e6W4LsUgSnZoz4l+2ipp5sLYpV02L+yPPaTf3AvTuHyZLtmFX1QbGUL9ihL1QKn9RZ2s0G+vgJugVipnm8gKgrEGIkLeNb9AOt0qxv0OcGTII12/P8qRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=JRW2jdAL; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Uzqzrdmu; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="JRW2jdAL";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Uzqzrdmu"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 1BF6B60276; Fri, 25 Jul 2025 19:04:06 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1753463046;
	bh=sVOkrfW2p5rJ989ovXwuBFsfFZepB5AC7zzBMFtSgW8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JRW2jdAL0frCN/hSFfEm8NKcV30J4QGLPgWYTsgZNxvRWGq8kxG4GAufxGk3hzRw+
	 BeL+nV4+PA8Hf78AXUHb2nlffjzdQWaATcksTfsoK+1QGiLaKvWxUZNYEMtCm3+rOl
	 8qFjFLbLYji24pxJp5ctwYijzOfMvq6WES83zC6riIKlWf96M6F+P7af1ePCIPKK1e
	 w1Ot0odcSqOXWnGAF5AQRuTX0MGgL3jbKKxD9bpl05EVNaEwQVSPfpPstGCB3aq7TT
	 5eH1rsdwrrDoDBFt/30yhcBF0a1+GbQGelxchv7tVBCVxjCxOhXijF51wyXjqMUZGe
	 TlZW4OPa23snA==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 260EC6026E;
	Fri, 25 Jul 2025 19:04:01 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1753463042;
	bh=sVOkrfW2p5rJ989ovXwuBFsfFZepB5AC7zzBMFtSgW8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UzqzrdmuJY3HWyZC/h+OdvLYZrhYCQdwWgaTjDLhsz/qj0jAwfIdzO6wwF+QZcRLD
	 Ecnc8lLOWkINlPQeZQgV1rPMrImgVhpLFRzit/Vs/AqPNciqaaP1oRJTYVY5jdEwLf
	 IKplSaIA4KBXGj10HDJBBdkgW18TQgc1rItTtLGCN4v1Q6J6rEh6fTgX4FTzI0AgaU
	 YUusauOAJa6+0nlVg/oyKWzkvdFTQFfEbasjkcqe09tKJCyZORQ9z4a0xQik6+/Thk
	 U3ts2hMdX2cOQAXzQE5gYiOjfLAR1+EnvecuuJmGSHQNQZBmO3i+rPFj9j6jjj0Oi0
	 80I2sA0HPgnOQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next 08/19] selftests: netfilter: Enable CONFIG_INET_SCTP_DIAG
Date: Fri, 25 Jul 2025 19:03:29 +0200
Message-Id: <20250725170340.21327-9-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250725170340.21327-1-pablo@netfilter.org>
References: <20250725170340.21327-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

The config snippet specifies CONFIG_SCTP_DIAG. This was never an option.

Replace CONFIG_SCTP_DIAG with the intended CONFIG_INET_SCTP_DIAG.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tools/testing/selftests/net/netfilter/config | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/netfilter/config b/tools/testing/selftests/net/netfilter/config
index c981d2a38ed6..79d5b33966ba 100644
--- a/tools/testing/selftests/net/netfilter/config
+++ b/tools/testing/selftests/net/netfilter/config
@@ -97,4 +97,4 @@ CONFIG_XFRM_STATISTICS=y
 CONFIG_NET_PKTGEN=m
 CONFIG_TUN=m
 CONFIG_INET_DIAG=m
-CONFIG_SCTP_DIAG=m
+CONFIG_INET_SCTP_DIAG=m
-- 
2.30.2

