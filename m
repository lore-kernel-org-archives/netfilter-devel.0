Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9262E33123D;
	Mon,  5 Jan 2026 08:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767601614; cv=none; b=OXarkkMaE2KX28r+npPdv+FbmQmA7i4bpRgQtHaVhyEkuoLh12/fDErMDiE0lxf6lzbF/OWFOK8Bf5xoaBTC4tDQi7VVZDI7Jd8SvjYiSEV2yKanzazjU7f+Q2oywsoxXMHOqcwkJg1mHRh41ZFXe4wHjxOUXQ3LlhAlSizBnlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767601614; c=relaxed/simple;
	bh=PlSAHLIcPqEr0WSD9F/zyyFIGslt4XFL2PegPLaRmw4=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=b94/+SSnpuoFji+2lk761jN8XDHWTuSMCmzonxok2nOdxFbCYWKESiaNemi9qoy1RytctKIAHvsOSBZWYv/bzUFEdvPH+FNnuINSoRdoyOyL5CmOJDyVSsarkqc5oK14d8Ozyj7mSqjOJcdRsH2oeg5KGun5Z7c5dauK8rPG/so=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=xIETlA3j; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=D5HIgG6F; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="xIETlA3j";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="D5HIgG6F"
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1767601610;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=MZ8esC/5910O5pzfA0ceSYS5IgjotIwLmMG2zA9Ur3k=;
	b=xIETlA3jQGYDshg3ErxHFBiTLp6oYnCuJZfGza8BClNYy8AVD/kH4KHmRjBCYO/kEj1vmK
	ESLOFCUcgvipO8g0UdY+CSMgW7Uh9vMj3kiqwVI9OONVbtzY1UoROfPULzYuxh8oP/W8Tb
	yoJDe8pR/KOTRQWPRfflVtStCY5KtfA6Cw2DhRgBSoRWrTMBZ2jOElhHz2AbTF8+3yLK39
	dO37yO4wDvEVUywECUQ0IEZWV9cZHp3IhxBzIVO76p8Sv7+od3JqWqvX2VOCvIUDv6tqA5
	l8hoxEt721nAQZGzpCt8uZKMsAl7TXo56N3ysp1ra3JufV0xGwbF4yWsjGLL0A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1767601610;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=MZ8esC/5910O5pzfA0ceSYS5IgjotIwLmMG2zA9Ur3k=;
	b=D5HIgG6Ff2QERGyxoy5cDoFCDZj4lbQBjaQqi+G20IgtMv+Sa0fvdXklcTzGqSbH27mMVm
	DY9IFpfp/2OkCBBw==
Subject: [PATCH RFC net-next 0/3] uapi: Use UAPI definitions of INT_MAX and
 INT_MIN
Date: Mon, 05 Jan 2026 09:26:46 +0100
Message-Id: <20260105-uapi-limits-v1-0-023bc7a13037@linutronix.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-B4-Tracking: v=1; b=H4sIAMZ1W2kC/x2MwQpAQBQAf0Xv7BXLqnVVPsBVDloPr1jaXVLy7
 5bjTM3c4MgyOSijGyyd7HgzAdI4Aj33ZiLkITCIRMhUCIVHvzMuvLJ3KAudS62yQmkFodgtjXz
 9txaauvqcIY+GLg/d87xGkpaVbgAAAA==
X-Change-ID: 20251229-uapi-limits-56c45c9369c9
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1767601610; l=936;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=PlSAHLIcPqEr0WSD9F/zyyFIGslt4XFL2PegPLaRmw4=;
 b=i+eKk6Ljv1e9zzV7oMX7y7EdJ0RKmOzKqNNlOG3ig20oos1onvLlwWebdVYibX5UVYC400clo
 NFvzmG+Ra4pANXLy7U9XTlAUVnd6SdSIT2YRmP1SpZZUzo9H7DFIMmR
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=

Using <limits.h> to gain access to INT_MAX and INT_MIN introduces a
dependency on a libc, which UAPI headers should not do.

Introduce and use equivalent UAPI constants.

Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
---
Thomas Weißschuh (3):
      uapi: add INT_MAX and INT_MIN constants
      ethtool: uapi: Use UAPI definition of INT_MAX
      netfilter: uapi: Use UAPI definition of INT_MAX and INT_MIN

 include/uapi/linux/ethtool.h          | 7 ++-----
 include/uapi/linux/limits.h           | 3 +++
 include/uapi/linux/netfilter_bridge.h | 9 +++------
 include/uapi/linux/netfilter_ipv4.h   | 9 ++++-----
 include/uapi/linux/netfilter_ipv6.h   | 7 +++----
 5 files changed, 15 insertions(+), 20 deletions(-)
---
base-commit: dbf8fe85a16a33d6b6bd01f2bc606fc017771465
change-id: 20251229-uapi-limits-56c45c9369c9

Best regards,
-- 
Thomas Weißschuh <thomas.weissschuh@linutronix.de>

