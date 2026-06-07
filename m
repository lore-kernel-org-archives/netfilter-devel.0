Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C12C2EA749;
	Sun,  7 Jun 2026 09:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780825806; cv=none; b=IfvZ86wuKOFdO2qd9byaI/hR3nUngeVXU5hPwJAnwjIV5pEdnnBBQIBlt/BO3+I8PJnT5W5w2bmnco/LQcYGT5TzFkvYK0hzijqQEPeMzRiKgLS/W+ByRFfcwD99wRE+Yzg8f0jvonM/+FtmJeXBf46FIqPMEjzPKsO1NTWmbNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780825806; c=relaxed/simple;
	bh=7BmVU4tkNybgTi7CezIgNFD+tIc9a04Bw3NSwlWmOEs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sw2cR+JJIurE0MwsJu6RZOHSG0W+RZaAOla6r8qNsmxsFC+nChwcQ6NPQ6joqV5Zjj5njwSviQyCuBlXSY/dJdv0ICGTd0b9yKv7qiQKW3CK9t9nXm1zfygEw1NAt76Km0fwRyBeXL9dEjPGoQn4jEUiu/LK66SxXlrGT/KsPxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=uYduBuZF; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="uYduBuZF"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 1CB326019C;
	Sun,  7 Jun 2026 11:50:03 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1780825803;
	bh=lH/8Y4s/HAN0AI55N4GmKCh8A5UwLJBN8qLlXk0B/E4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uYduBuZFWVAg0XIH/Cyhh7GOUgoMKji9CxSN0U3p0kfmpwDYTuvX3GCftNk8VoMae
	 Cb8yD0lJJxIt+S/X3Vu8FuOn9vGPCKZ1ONjGWqXehZk/ZvrIgAYiBlLA+jFlOSEqYR
	 iApE4ZKi764EZOa1z115q8pYMTCJLKrJgOpzoxGfx9hDfOGfz+PMDXOOn9UHnM/9aJ
	 khozBBGbA7l9dxeK+az3ZhsuOB6KUoVo7xNN+Adc1slZufU6Blg5IHOvdO9WAaE5Yy
	 cOpS2bnw3jM1vriw9V3UObmVVc81RdchcXuvBKHvE4wiEd7nVbrRF1jiBvQcAW7FO1
	 PqJD88ipXfBFw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next 02/15] netfilter: nfnetlink_osf: fix mss parsing on big-endian architectures
Date: Sun,  7 Jun 2026 11:49:41 +0200
Message-ID: <20260607094954.48892-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260607094954.48892-1-pablo@netfilter.org>
References: <20260607094954.48892-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Fernando Fernandez Mancera <fmancera@suse.de>

The MSS calculation in nf_osf_match_one() manually shifts bytes to
construct a 16-bit value before passing it to ntohs().

This works on little-endian hosts but it does not work on big-endian as
the bytes are being always shifted and set in the same way for all
architectures.

Use get_unaligned_be16() to fix this on big-endian systems. It also
simplifies the code.

Fixes: 11eeef41d5f6 ("netfilter: passive OS fingerprint xtables match")
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nfnetlink_osf.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/net/netfilter/nfnetlink_osf.c b/net/netfilter/nfnetlink_osf.c
index acb753ec5697..92002079f8ea 100644
--- a/net/netfilter/nfnetlink_osf.c
+++ b/net/netfilter/nfnetlink_osf.c
@@ -95,11 +95,7 @@ static bool nf_osf_match_one(const struct sk_buff *skb,
 
 			switch (*optp) {
 			case OSFOPT_MSS:
-				mss = optp[3];
-				mss <<= 8;
-				mss |= optp[2];
-
-				mss = ntohs((__force __be16)mss);
+				mss = get_unaligned_be16(&optp[2]);
 				break;
 			case OSFOPT_TS:
 				break;
-- 
2.47.3

