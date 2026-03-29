Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0955A37F75A
	for <netfilter-devel@vger.kernel.org>; Sun, 29 Mar 2026 16:52:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774803149; cv=none; b=u5FUppBFAW0iR6tNRThFttkUbwjVhx9QEJjOiVu8800d2MNP7hHAfDT/iVHoe8BQrT2WM1aBRY7j9IPXiYHgpLBTAyIsg433cvvVp3SFg/3ZCjdupFOC+dzrmhI0Jxor4AMEkTNujdKa2qkyCN8vuBzHZqS8le7TjSedOKvY/nI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774803149; c=relaxed/simple;
	bh=b2bwpUQRoHCr+Bn8QVQtUP36sssXWqkwyRequ+KE2dU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=luYOKPTTqNZ8i3A+eqRpXBujZ82aaz9Ui6CWaxlt4CFVxzGNZfiG7CHz8pG8PXWanJClhZ8GKkCQyvkiXvNMuNzsxOoI+F6gYq9xz4Q8D9tKmrmJ5ThM5fBTLCIeWAjYlVdnuE+TfuCnSpGVokbZOXDHS4vPh+BpgUxgtVwaFEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AmMljpc0; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AmMljpc0"
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-35d971fbcddso517492a91.1
        for <netfilter-devel@vger.kernel.org>; Sun, 29 Mar 2026 09:52:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774803147; x=1775407947; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=1/dtluh18hHrnfgX94Rzw61kxdR4s6K+3hZ7ZcF6n8c=;
        b=AmMljpc0Dv4XFB84YTntmrQkUY5mzH0/ux74qKHgKpvqvUVIj/aA028gnMWUNC4eIK
         e912tcIrIW4a1aWnVuNAoXN/ne6C1IWz7ooy5kGsy7VddvVWX3vXsulsTyJLI14p++PT
         euLypg215+g8Y2Ea+VnwLfndmQBpWSt3ASPrq/qDcqQODK7wvTvedO4bbcp7EbRsv79q
         nZWZbAfKpruXf+41bILJSKvqTqlJfU13J/2FyAZ32xok5iehEoNrHVynBNbxUPdjgBB0
         TcmB3m5uNaFm05Kx0aIoPgir/DilTemFHyJLZ807N63wH1XzHgu/qq9fdsC5FPv616Ga
         XCkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774803147; x=1775407947;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1/dtluh18hHrnfgX94Rzw61kxdR4s6K+3hZ7ZcF6n8c=;
        b=bPdw0fdVyIi1PxdWtkIsUhvD8QSrAZZQn+AqKeOSaAMxi02dnzy/cIBbrAJrU+dM+X
         36v/EZ92k5o2lE2SLsqN5vkmUREeKH3NbmUK+4KYKufAlgdCxIRrsZ2CzCzzX0ZI/FRV
         TkCSZ87YMuOjFVa/SbCJmKiW3lecBStjVPRti6rRk0QdOFrFUwIXwIl+rkg/mnN35kI8
         0HxJo//+9GtSOSLFcpeu0Nj6xRXuBVEactPGcv9qJnOV9EScBgdueIN3MI8jbzUA+G6r
         lcZTNcYBDcbIeg0vDuJXvniNsBjsKcfNGx8/VYg/zC6hI8TJdYCVPeoxjlJZJiEZ7BM0
         JW0A==
X-Forwarded-Encrypted: i=1; AJvYcCWz4pAuyCRY2VTkt8GYEPdu3r/6j8PBHZyq21gkegdktl2C+vmq6/36fzeBpjb1hWeY70U4wXWMHCtJ8fYVGfs=@vger.kernel.org
X-Gm-Message-State: AOJu0YxXZ5B6VHvTAqR6xd17jVYRLzfAX2sAdImah5pNWX8j42P5bTTV
	4EtXGDJZupRFI3BfQbiHHD+j82QjT9IcWjybepHLv1ut0MjIePgXmc2r
X-Gm-Gg: ATEYQzzCF5VyRitU1sl41nW7MgtfxNKBcG6QeclWFMmFDEozZ8r54jPUBsCCKWJLx7j
	3vKWbSXG8P3puAqYZ7BHdIDwBFn6dQDY/2U6CQF30iwTfni4brai2H1e+ZMBsv3Iwwes6TxPhIh
	amCPDagaYX0hEpyIuuq4+GVAJMznkGKomuKUqpkO2ePA1TPHYuavH5Z7NSPiP5bLhzBC6bcfDjG
	dS+q/4mrbV6vy+ukm4rhPdMgTD7UwkGgSuo6T5tpOqDmvwcGw3dwLlbAiOmJK4+ksnp8Lu3w2mb
	3+28mYf/WQWZYqp2Mi9lfPtp4cQB5AOUvDxxQ1WnsodkRPqNtiLxTWK/D1r6ghl0+2iVztQQrR4
	HQjZ0bbtPhHx1AoZNbNJ1+cQ0THJSN5hsy/o1NIPdtqcypg2NuUtMMXtfreGKWFu2n5Zv77940t
	Yyia9QfRo1eTMHhK2gQ1drmH4NKFjb+QBi9N4=
X-Received: by 2002:a17:90a:1108:b0:35d:9276:eba7 with SMTP id 98e67ed59e1d1-35d9276f7b1mr3183202a91.7.1774803147220;
        Sun, 29 Mar 2026 09:52:27 -0700 (PDT)
Received: from localhost.localdomain ([47.236.127.140])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35c22b9fc96sm9854141a91.7.2026.03.29.09.52.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Mar 2026 09:52:25 -0700 (PDT)
From: Qi Tang <tpluszz77@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Cc: Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	Qi Tang <tpluszz77@gmail.com>
Subject: [PATCH] netfilter: ctnetlink: zero expect NAT fields when CTA_EXPECT_NAT absent
Date: Mon, 30 Mar 2026 00:52:17 +0800
Message-ID: <20260329165217.241038-1-tpluszz77@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ctnetlink_alloc_expect() allocates expectations from a non-zeroing
slab cache via nf_ct_expect_alloc().  When CTA_EXPECT_NAT is not
present in the netlink message, saved_addr and saved_proto are
never initialized.  Stale data from a previous slab occupant can
then be dumped to userspace by ctnetlink_exp_dump_expect(), which
checks these fields to decide whether to emit CTA_EXPECT_NAT.

The safe sibling nf_ct_expect_init(), used by the packet path,
explicitly zeroes these fields.

Zero saved_addr and saved_proto in the else branch so that
expectations created without NAT metadata cannot leak kernel heap
contents to userspace.

Confirmed by priming the expect slab with NAT-bearing expectations,
freeing them, creating a new expectation without CTA_EXPECT_NAT,
and observing that the ctnetlink dump emits a spurious
CTA_EXPECT_NAT containing stale data from the prior allocation.

Fixes: 076a0ca02644 ("netfilter: ctnetlink: add NAT support for expectations")
Signed-off-by: Qi Tang <tpluszz77@gmail.com>
---
 net/netfilter/nf_conntrack_netlink.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index c57c665363e0..c152079f5ac7 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -3593,6 +3593,10 @@ ctnetlink_alloc_expect(const struct nlattr * const cda[], struct nf_conn *ct,
 						 exp, nf_ct_l3num(ct));
 		if (err < 0)
 			goto err_out;
+	} else {
+		memset(&exp->saved_addr, 0, sizeof(exp->saved_addr));
+		memset(&exp->saved_proto, 0, sizeof(exp->saved_proto));
+		exp->dir = 0;
 	}
 	return exp;
 err_out:
-- 
2.43.0

