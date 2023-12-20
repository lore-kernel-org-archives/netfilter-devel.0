Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0E7C482D1
	for <netfilter-devel@vger.kernel.org>; Wed, 20 Dec 2023 16:06:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="qJEGZRQl"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=pQJvivl6QI0GqVl/N2ISlqpFTlQu/iM9o0fUbY9bHrE=; b=qJEGZRQlIiSoQ4ih3vJxkAuDmA
	LWVCgVJCUkLnqOdGWcKHPQYHZ1lHH/lyan2OPMYbcPtaWgjUs/QR7URuSl6AF/uIRxQFh0p5JWKyZ
	6YeWOQM+8JFXTluv8twwtRyNarwTsDPckrznnE4JmBieS/45NqefBKlIE7C4f0c2eMuZmV6bZzS9p
	nY/ZHAc7OaG0E+KOZUqOfHd3gG6ZTBNb+iKPCPlbT20XMLwXMjC3I4LZr2r8gq8vPAladmEjn0axn
	T+wHmOeKfDOT7XKIqnG91mohqnlElDQBtp1r8hAiAqQUhUOwakuG2HES4fELwnSmK/gYlN4UghkP0
	yjsSArGA==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.94.2)
	(envelope-from <phil@nwl.cc>)
	id 1rFz5n-0004Kv-8I
	for netfilter-devel@vger.kernel.org; Wed, 20 Dec 2023 17:06:43 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 01/23] libxtables: xtoptions: Prevent XTOPT_PUT with XTTYPE_HOSTMASK
Date: Wed, 20 Dec 2023 17:06:14 +0100
Message-ID: <20231220160636.11778-2-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231220160636.11778-1-phil@nwl.cc>
References: <20231220160636.11778-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Do as the comment in xtopt_parse_hostmask() claims and omit
XTTYPE_HOSTMASK from xtopt_psize array so xtables_option_metavalidate()
will catch the incompatibility.

Fixes: 66266abd17adc ("libxtables: XTTYPE_HOSTMASK support")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/xtables.h      | 1 -
 libxtables/xtoptions.c | 1 -
 2 files changed, 2 deletions(-)

diff --git a/include/xtables.h b/include/xtables.h
index b3c45c981b1c7..db7c492a9556e 100644
--- a/include/xtables.h
+++ b/include/xtables.h
@@ -61,7 +61,6 @@ struct in_addr;
  * %XTTYPE_SYSLOGLEVEL:	syslog level by name or number
  * %XTTYPE_HOST:	one host or address (ptr: union nf_inet_addr)
  * %XTTYPE_HOSTMASK:	one host or address, with an optional prefix length
- * 			(ptr: union nf_inet_addr; only host portion is stored)
  * %XTTYPE_PROTOCOL:	protocol number/name from /etc/protocols (ptr: uint8_t)
  * %XTTYPE_PORT:	16-bit port name or number (supports %XTOPT_NBO)
  * %XTTYPE_PORTRC:	colon-separated port range (names acceptable),
diff --git a/libxtables/xtoptions.c b/libxtables/xtoptions.c
index 5964a9bfb57fe..9694639188006 100644
--- a/libxtables/xtoptions.c
+++ b/libxtables/xtoptions.c
@@ -57,7 +57,6 @@ static const size_t xtopt_psize[] = {
 	[XTTYPE_STRING]      = -1,
 	[XTTYPE_SYSLOGLEVEL] = sizeof(uint8_t),
 	[XTTYPE_HOST]        = sizeof(union nf_inet_addr),
-	[XTTYPE_HOSTMASK]    = sizeof(union nf_inet_addr),
 	[XTTYPE_PROTOCOL]    = sizeof(uint8_t),
 	[XTTYPE_PORT]        = sizeof(uint16_t),
 	[XTTYPE_PORTRC]      = sizeof(uint16_t[2]),
-- 
2.43.0

