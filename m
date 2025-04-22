Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C21742C259F;
	Tue, 22 Apr 2025 20:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745353443; cv=none; b=n4Q27iy0DsJWiNj7gNGqGVH/D6/qiauksib+I9/ajd80FjYZ4MeQkxnmtAceu43NHyoviPDpcN9h3hcumPRb8RXb0Z12Y+o7nSscb4PE+7pTBn5e+dj4YQjb1vIqII4lkrrCRiZtRbGfk1AnY3rjnI5EDRl1JV0JwmEIKmWkRQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745353443; c=relaxed/simple;
	bh=Obpy6Gk9BM7Cii4f8ARMhEnscTfegUK0L4kYnsY1s94=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=M6DYw2/wGdtNaV/9HBlGAUQ6hKyTckJ6uKUyZFaEggfhJhI09C+2c0SInOpFbfr1k734wJesMRhoSyZAJSxJZFaLcL1vBqxGI3pBwOMlJYYlQRC0qCWvyyvXPY4GGCa4mIwU6DwcB3/oFiy4palOb10SjVJxGdT0NSR5F28dWGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=h7uLQ+rP; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=jZRFWaX0; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="h7uLQ+rP";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="jZRFWaX0"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 4996C609B4; Tue, 22 Apr 2025 22:24:00 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1745353440;
	bh=/EEmQF7EDJiKm8KlBu3EyGVNLb/l73f/WI9g4RoKC6g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h7uLQ+rPry2pwDNOy7GChhgcx4C+quoPmlzUlzykyKwDoUPNJ9mVuagCqjoGH5C+P
	 Lw91dlb3HGCwcxyA3SIj5Wj+7giQt2JEOwbhO0T4LM5a33cTGjuZuMzNtlBEnnYeG1
	 dFjsiMFhfWUjfgYGeKL/dcU2T7j0avHLv9zo+cNvBpd6wNmH6MHmDPZKYCQUL5yU7P
	 NZJ3uvmI+MtzgJhUdKd3RvblurUFBII6Q/BIb4U0yWMIZhe2vb23Ed9HiQsfPwts8/
	 EOEW7bXslS6WK/kzhQRrFPc2naLYB5tOQThDTXKJ41lEceXYCNVqUL2jASwZrhZOCa
	 mvwfupZkb9Cbw==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id BD02A609B9;
	Tue, 22 Apr 2025 22:23:52 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1745353433;
	bh=/EEmQF7EDJiKm8KlBu3EyGVNLb/l73f/WI9g4RoKC6g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jZRFWaX0FEjRaqTj/U3Mrdr9vZ8RZqIyitRRE1XkokVBI5V0bt5UEwN8Kt8adJBpN
	 rG01EsupGwhR8TOlXEV8Br1nc87G90cAU11QIRj2lYuums6byg7tfLv0yxdSxGgMo8
	 SotBQuchxv3IKCweN0YPVcjxwJEgUa5Ol2N6GaUZzZp2Od1eY3ANdzqpjB9nIAzIW9
	 3LEshP0BjszZ4rwUr5B0GDLdglF8IEXaeq2L/a2k6z9CX8BVLxUQUzWgc6X2Ih1GVA
	 Lw4VrWVLfwqvbCP24CprV9kLuAand6qPZQnIdL/LhSdOOQPTAA6pr6p4n7Ibn0pZ05
	 9lTXjdOy9ZcRQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next 6/7] docs: tproxy: fix formatting for nft code block
Date: Tue, 22 Apr 2025 22:23:26 +0200
Message-Id: <20250422202327.271536-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250422202327.271536-1-pablo@netfilter.org>
References: <20250422202327.271536-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Chen Linxuan <chenlinxuan@uniontech.com>

The nft command snippet for redirecting traffic isn't formatted
in a literal code block like the rest of snippets.
Fix the formatting inconsistency.

Signed-off-by: Chen Linxuan <chenlinxuan@uniontech.com>
Reviewed-by: Bagas Sanjaya <bagasdotme@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 Documentation/networking/tproxy.rst | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/networking/tproxy.rst b/Documentation/networking/tproxy.rst
index 7f7c1ff6f159..75e4990cc3db 100644
--- a/Documentation/networking/tproxy.rst
+++ b/Documentation/networking/tproxy.rst
@@ -69,9 +69,9 @@ add rules like this to the iptables ruleset above::
     # iptables -t mangle -A PREROUTING -p tcp --dport 80 -j TPROXY \
       --tproxy-mark 0x1/0x1 --on-port 50080
 
-Or the following rule to nft:
+Or the following rule to nft::
 
-# nft add rule filter divert tcp dport 80 tproxy to :50080 meta mark set 1 accept
+    # nft add rule filter divert tcp dport 80 tproxy to :50080 meta mark set 1 accept
 
 Note that for this to work you'll have to modify the proxy to enable (SOL_IP,
 IP_TRANSPARENT) for the listening socket.
-- 
2.30.2

