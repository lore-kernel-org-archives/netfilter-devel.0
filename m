Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB3F63783B9
	for <netfilter-devel@vger.kernel.org>; Fri,  6 Mar 2026 08:08:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772784539; cv=none; b=dQQpgQ506zUZJIKM+yf7325JBWUiHCSbTM6PDulHktGjfTUvqpC7p4sOX0qoEXAMQAlU1lTnCJAPer1OY8RRgP8JIxf8kzk+I0Lm4EPqEPxiEbrx+2oGN98C5d8oDaTetuJmxQbJKEuZ5e5KIeuWaXnJQSwiDSBikdhaS4u3Rms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772784539; c=relaxed/simple;
	bh=Rmr6kNUNQCImUh+k1o6b1AcPD3bK+XZdJo80XaYNyh0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Yk5jxGYCqQ/YFO8b/gOq8OUXmq1VWcBxrzuDjnNsNOFahZx+bqqqO4Vnr4cR7/qfcXwbA3z5OTDYRqcp4ICD7DhI8F5QGmtK/dAIiy8GORti2+k+nUIpoMMkkmzjXL8zaPs0lqzrjLvASmlwUx9YuRH3FMWpwOyE1n96u4ouxIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nUqOU6Vn; arc=none smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nUqOU6Vn"
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-506aa685d62so50711551cf.0
        for <netfilter-devel@vger.kernel.org>; Fri, 06 Mar 2026 00:08:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772784535; x=1773389335; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=37/loNqQbpY6DkRTHc7PLDcjXzE+46x7j37wSTiN8V0=;
        b=nUqOU6VnzRLW4HQqebUaMJ1TnX4YUVVOIpXr5ykjIQBanqdMxro+7liLOoVofcqGXR
         Ifq7NpTl38841+HnME56QzHrMpZUzcoKUfOckYuOlxb8sAtAhYIqqyO4IbsS+tCDQkFN
         dsObs8lVMcFvlSmjkJ3vLFlxF3kAiK6gCru4IKu0+vx5fAxk6Nvq3CmNVA7VZa+VIddl
         5iBCOVqLNf17ceGysEvw6uKJTLtN/gZkF6ENpBi+vEWEio6qNiFnWvE6WoPXinFLi0Hr
         n+GONKFGKl89jfZnXcaJwa6YPv56PZv3wolbk6FLrH9+cpnT4kzBCbJjJnCw6Y6EgRfE
         8P3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772784535; x=1773389335;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=37/loNqQbpY6DkRTHc7PLDcjXzE+46x7j37wSTiN8V0=;
        b=TxOuxY6ZHnYMFoSRj6/ywJz5EB9gHnJX5nO/PC8ENbxQdj6itq8pkIVftzTyquetG4
         e/X041eRaoXhNMXeFPWEYZVgLf+CMZktWLhy+2eghqWQ5bVq0ae5w/bI1+SAVxfQiCUg
         uD5KdUTkFugi+R5AB5E35cBQbhzFNqhah5XjY+wiVZ1/Tp0IVpIrR1SnJ36NMpPuFtCK
         3+NhWQap0UCzwNACwDRQ9vhEDJAjSSis1AHbcFa55ThBxhs0wbxpNOGgluRbQ4B8yldg
         Xnmg9y3pvCRClrS0mwScVMLrl2lPKYBtfJHYGUdb0OvSeF8JHEpmx0dcfTlIMz1DOoNp
         uduw==
X-Gm-Message-State: AOJu0YwV1Q8qdzI4ZFbI+ILNPrKM0Mqr/WcbHTOltCJiToSk4gj/1i50
	bTPY02IROtwziCaCXRiT79NtAnBRzFeK2OUgaGqLqJS1ujUF/ZlnqgpURho0YK5z
X-Gm-Gg: ATEYQzyqyC2ZQtNXis32nj/ywknnYeIwf2mZtvrB6IEFodaGqBaUAHESZFbZI+caE2H
	yZCySBnr7s/hN8C7mnvBY8lMs9uirk9h4tuGOQd1ky2/zAlUMLh3YPhfI3w1VyU/9te1zPFa4Xd
	Mk5mWj4xpmhGSM4ZI9E3JWNHrXUQhmhHh3p02WUo8tCiLdvRlRrUn+vP2kctF+Hujt5BvJM8r1l
	OSuban40R3UiYhIfI905EJ0unYKHH2mOM8TWHMPB19KQJinbCtNWuQBnSKhbomeHyqQ9qJ16wHO
	k2J7bIme7+K5rQslHFlA63GmO0LrOhT0LmVy/VyAYY6QUBq13Ia3NyPFcQhSWYIfhGA6LfRfSHU
	135u0spiQMyPVsOcgBIl0OVVoiup47iwKoh5NEjvnrCa2JBoHqD9GIWGOzoG7BtcT0+Qyri3yOm
	7hVpP7yDeIY7igVrXgyACtt3uZfvCnrh6RgsihlwKWHGxC
X-Received: by 2002:ac8:7e91:0:b0:4ed:b83f:78a3 with SMTP id d75a77b69052e-508f4955aa9mr13638121cf.47.1772784535365;
        Fri, 06 Mar 2026 00:08:55 -0800 (PST)
Received: from 192-222-50-213.tail19a0b.ts.net ([192.222.50.213])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-508f66b620dsm4312891cf.23.2026.03.06.00.08.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Mar 2026 00:08:55 -0800 (PST)
From: Jenny Guanni Qu <qguanni@gmail.com>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org,
	kadlec@netfilter.org,
	fw@strlen.de,
	w@1wt.eu,
	Jenny Guanni Qu <qguanni@gmail.com>
Subject: [PATCH] netfilter: nft_set_pipapo: fix stack out-of-bounds read in pipapo_drop()
Date: Fri,  6 Mar 2026 08:08:54 +0000
Message-Id: <20260306080854.908476-1-qguanni@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

pipapo_drop() passes rulemap[i + 1].n to pipapo_unmap() as the
to_offset argument on every iteration, including the last one where
i == m->field_count - 1. This reads one element past the end of the
stack-allocated rulemap array (declared as rulemap[NFT_PIPAPO_MAX_FIELDS]
with NFT_PIPAPO_MAX_FIELDS == 16).

Although pipapo_unmap() returns early when is_last is true without
using the to_offset value, the argument is evaluated at the call site
before the function body executes, making this a genuine out-of-bounds
stack read confirmed by KASAN:

  BUG: KASAN: stack-out-of-bounds in pipapo_drop+0x50c/0x57c [nf_tables]
  Read of size 4 at addr ffff8000810e71a4

  This frame has 1 object:
   [32, 160) 'rulemap'

  The buggy address is at offset 164 -- exactly 4 bytes past the end
  of the rulemap array.

Pass 0 instead of rulemap[i + 1].n on the last iteration to avoid
the out-of-bounds read.

Fixes: 3c4287f62044 ("nf_tables: Add set type for arbitrary concatenation of ranges")
Signed-off-by: Jenny Guanni Qu <qguanni@gmail.com>
---
 net/netfilter/nft_set_pipapo.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index 7ef4b44471d3..9fb83fc05848 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -1659,7 +1659,8 @@ static void pipapo_drop(struct nft_pipapo_match *m,
 		}
 
 		pipapo_unmap(f->mt, f->rules, rulemap[i].to, rulemap[i].n,
-			     rulemap[i + 1].n, i == m->field_count - 1);
+			     i == m->field_count - 1 ? 0 : rulemap[i + 1].n,
+			     i == m->field_count - 1);
 		if (pipapo_resize(f, f->rules, f->rules - rulemap[i].n)) {
 			/* We can ignore this, a failure to shrink tables down
 			 * doesn't make tables invalid.
-- 
2.34.1

