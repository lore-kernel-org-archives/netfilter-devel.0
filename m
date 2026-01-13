Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B951E2EDD58;
	Tue, 13 Jan 2026 07:44:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768290272; cv=none; b=YO2WZjTJFSSyy/nzyrB0L20c3dMxHwLfStc3sIX+x/01kgml7Of8xntEGpI4oViERsrAwUbg7mBr5S71YbqxuGsKKfasFyeVmGcBPi28Fk4nK32YpeFSNfc1GIu/V+H7MTwfpaVGyNYWSLc8yVzK9ipMjVRwkYQdOevcdgbN6Og=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768290272; c=relaxed/simple;
	bh=DXWaBVbdjEWE1IyIqhzZ2dOoLEM7O6me/InOVvTKOxc=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=t72E8+1Gdvi8lyfmkkSQAAoCP+sXpDNLLuMk2ZgM7iU+8pJsFORhwAY0GvAB6hOmpA09+whB/88A08HzTTkD/zXpnYmSeYdg4EJcp1nk5TDJ6xzHF4Pt9QZc2PuoH0AcF01x6qAS5mHFi7lmwwYeacV3AwimuCz3vLRc1ePYWFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=r6U0/+pa; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=cE08Hi90; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="r6U0/+pa";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="cE08Hi90"
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1768290262;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=SFawNSuHNydwNCwxZe5OLXeU10e6H8J4jG7cxGHVXrQ=;
	b=r6U0/+pa0F/yLezwn5/En9erLmC3oSlovPPpp8KvTBHPp+HqfzDtuD4Uy2y0Hwp8KtNhC+
	qyjas07ek5TzGEMqXUGhPFxGPf6z/0DaXvmGE10TPKym3P+15VLNi6F/vcD6x6FZhOZe+K
	BrfoZ6PSCZvdvJV6UEUw8ZypGp7/csMyHQpJNair0aZkHtnOiyTJ0qvydd/rX6EMoE0mHW
	FP0p9ACxwyMqVWbxE6KbE2IPfoxvcXeeforCJllKTKqj21U5J9ioPOvyO6niUa+Fc8HSH+
	IeBk1OTTX+Zz2MEbxFLjgKZrzCKN4tLGLHbK+lgC9qUF2y84XiMHumRXwB0UNg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1768290262;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=SFawNSuHNydwNCwxZe5OLXeU10e6H8J4jG7cxGHVXrQ=;
	b=cE08Hi90SD9HkPtY+I3x01d8WtwHaobgpqohhLy9nryv82g98M1KjmFVGFvi/fyNn8whRE
	7PucC0ZyTsdNFjBw==
Subject: [PATCH v2 0/3] uapi: Use UAPI definitions of INT_MAX and INT_MIN
Date: Tue, 13 Jan 2026 08:44:16 +0100
Message-Id: <20260113-uapi-limits-v2-0-93c20f4b2c1a@linutronix.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-B4-Tracking: v=1; b=H4sIAND3ZWkC/1XMSw6DIBSF4a2YOy4Nj4KhI/fROKBI600sGkBiY
 9h70VmH/0nOt0N0AV2Ee7NDcBkjzr4GvzRgR+PfjuBQGzjlknGuyWoWJBN+MEUilb1Jq4XSVkN
 9LMG9cDu1R197xJjm8D3xzI71cBRlVP45mRFKKBdP2xomqGi7Cf2awuxxuw4O+lLKD4kHrg2qA
 AAA
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1768290260; l=1133;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=DXWaBVbdjEWE1IyIqhzZ2dOoLEM7O6me/InOVvTKOxc=;
 b=cHAPH+f2Jw/xofJujyo+AixKrXcr+0qlmt3bYZhyx35wrWZMtjbFgq9b14Tis6HD7ZmD3NQBo
 CO97MFYxShUDNoAVKB30VNbll36DdKiUEWyYacW30X7Y2REiXRIs3YS
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=

Using <limits.h> to gain access to INT_MAX and INT_MIN introduces a
dependency on a libc, which UAPI headers should not do.

Introduce and use equivalent UAPI constants.

Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
---
Changes in v2:
- Use uapi/linux/typelimits.h over uapi/linux/limits.h
- Drop RFC status
- Link to v1: https://lore.kernel.org/r/20260105-uapi-limits-v1-0-023bc7a13037@linutronix.de

---
Thomas Weißschuh (3):
      uapi: add INT_MAX and INT_MIN constants
      ethtool: uapi: Use UAPI definition of INT_MAX
      netfilter: uapi: Use UAPI definition of INT_MAX and INT_MIN

 include/uapi/linux/ethtool.h          | 7 ++-----
 include/uapi/linux/netfilter_bridge.h | 9 +++------
 include/uapi/linux/netfilter_ipv4.h   | 9 ++++-----
 include/uapi/linux/netfilter_ipv6.h   | 7 +++----
 include/uapi/linux/typelimits.h       | 8 ++++++++
 5 files changed, 20 insertions(+), 20 deletions(-)
---
base-commit: 16ce6e6fa946ca6fd1e4fce6926b52b6263d98a8
change-id: 20251229-uapi-limits-56c45c9369c9

Best regards,
-- 
Thomas Weißschuh <thomas.weissschuh@linutronix.de>

