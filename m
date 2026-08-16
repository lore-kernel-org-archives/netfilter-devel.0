Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 305C93A8753
	for <netfilter-devel@vger.kernel.org>; Sun, 16 Aug 2026 17:07:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786900024; cv=none; b=UqtPOHnWP24aJGKcyT5bK5uuWeIBl0R7aCt3qIe60/gmHq7LnOShF5mZhC1n4A7J5a346iLz0LsMZRB6WSyhouGDbO1SUO8zePI9h+V79C2ZMRjgq8rufRgsj3VW3WGLzgHF796OjYkgsIx6wPddUYG9A67qukYKAML//513IeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786900024; c=relaxed/simple;
	bh=UjKZbgfnH1XMHC6xC5BUOWE08XCJYVIJ9QrIeEmUvZI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O/yPWBIyjmyhaTySdL1ncWPOl+yv65JTmEuagPdP7re+apiBP+YU0UbGJACnjyunLMuSZe0VIU7/nB7wcJfrqbA/E87RgJbYUR/XV6sFXyGnBk62Kk6xTNJWdoEuT0Kixir+oujUcuLNPE5ZuTwNwnXjlB+Trkz2H7KXf63dUOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=om0R+S7v; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="om0R+S7v"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-493b966dd74so17021405e9.3
        for <netfilter-devel@vger.kernel.org>; Sun, 16 Aug 2026 10:07:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786900021; x=1787504821; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HVcyBope6DGMi/80lpE9C+i3r+YlYpBjseKIjfNL3rQ=;
        b=om0R+S7v5h63SVYRNsYOkpVe9ssIC8V3cXmzJx9kngHNEJzXQ0O8Uk26corHOJBoMO
         yUCS7YQn8ngL1UtQC0LcpObHmJbZQWXtYCaDJUtAi+/fU6VQKhfwGr7rS+cdLCY2Dbb+
         lyQjGAvUwet1e6/+395kQcuDmqQV7NwyvtPopMS//l5ze7mqkmNXu+R0dDjCGR1qxwmd
         ia8LSPxwgKiuV3Otctvq/6ZQ/6mtq00skbEnUZrnzxkBYfZ7UZj+wBHrHtYiKMeOTSPO
         USIIMVUcVWzCZ/PgonoS3I4LGn3bSQZYmWAgqcF0L1iIGkwCZRiyL8+tlH7re2DAiF02
         WytA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786900021; x=1787504821;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=HVcyBope6DGMi/80lpE9C+i3r+YlYpBjseKIjfNL3rQ=;
        b=XbapRK73Y4vi1PCFR/IB0JgCnegqTyvXzs3O9jLWQz4yFLay0NyRbJPmHWO+S09+LY
         ILb9onjnvbmTX+L0rIjfSLuvmySL190deZnGZTyd/Gw3F8ogN/360iZDgqHriTmjciQO
         GszdDKdwYDPMpD7BQ6+hcL0oerih4iNfP85TJRCmH2yLi6lKhrZMp3ifZQhNItAAumqv
         6aTJdcYNhw1ZltvxU6eullov4ibqRcrrb8K423PlQrfjVzC9qMEHRr+sD8XbwFfBs9v6
         KPjgeBtdirVsZS9jHYFmXaG4Js88sgiXbIJlix4gvp6zksVwAT952RcLfIqbj4cApVen
         0Hvg==
X-Forwarded-Encrypted: i=1; AHgh+RoQg6YeMK1HyfiIhUb6ZV3fhNI6VCIX752MiZdgn3ZRXd1rSkevpdKXWppy3B/igWj6YsoCcrTg+xADEKBQvx4=@vger.kernel.org
X-Gm-Message-State: AOJu0YyfMb5F1oi8kwtE4Hpk51zQfzi8ceufuBfJT+tEsmyA2Oqoohis
	nN4MEbqOZWZPSi3/ZdP8+E4HYG9mYLnFlSjYVjQgAy/ktrhAb6ElHsZz
X-Gm-Gg: AR+sD12LTMSij85RTqLqZO4IRg0qopxFN/JrfbTyVCnk6SJCD01z4r6lNEHEljQhXpv
	yggis/omEXNqzm9DJ79+PPaY43Yetwyd+4uV1R9FyoOn3SKr8o4vSBwwmHF2fRonacq5UmZKhRl
	P9Ibm9okvSsg3SMLBLQbWY73yhn+FRN9t0xJPm+id90qlGk2TXP7rSlU9a+BiPaDg5KH0rNwb2Q
	vuAAN8BYey1hePPnYblhiFGQCdiqqOtAHOY4nVnuILB8XfXIsLBqleDxu9TQQTkOwF873YP78gi
	cLvpIzO17VnUoi0hrF2EtI3Bl3YltVO95p4JHaAEomhbEl0GqjhZKWP3FbACtHCSrf84T6kKy30
	Pry9dPAMgNE48078mxMH5crVqq9D21BWFCIpCkMwLrEIkT6FwhD8AiCcJ0WciuWemCOI6Jkfkbj
	y+yn01Eul/B/4n6gXakfTgMSUcdMSvwuWCKLHFGMwOAyQvqE83kFsHAnpXZfqOgipmt6amdIfhM
	xOcchobC09gc94j1SZnKiEtUXm/MhvoYkyzeZzu008kHQe0uUmh+xvkDzgXrJ9yfKZgheMJlElk
	9xiweTY+VVoYGnFR7QSGVoert02kZF8957MAqiM=
X-Received: by 2002:a05:600c:3485:b0:499:8758:8cb4 with SMTP id 5b1f17b1804b1-49987935eecmr314132475e9.5.1786900020748;
        Sun, 16 Aug 2026 10:07:00 -0700 (PDT)
Received: from localhost.localdomain (p54a14b85.dip0.t-ipconnect.de. [84.161.75.133])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4999618acafsm55671335e9.14.2026.08.16.10.07.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Aug 2026 10:07:00 -0700 (PDT)
From: Bernard Ladenthin <bernard.ladenthin@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
	pablo@netfilter.org,
	fw@strlen.de,
	netfilter-devel@vger.kernel.org,
	kunit-dev@googlegroups.com,
	davem@davemloft.net,
	Bernard Ladenthin <bernard.ladenthin@gmail.com>
Subject: [PATCH 3/4] textsearch: align ts_state.cb like skb->cb
Date: Sun, 16 Aug 2026 19:05:39 +0200
Message-ID: <20260816170541.3384-4-bernard.ladenthin@gmail.com>
X-Mailer: git-send-email 2.49.0.windows.1
In-Reply-To: <20260816170541.3384-1-bernard.ladenthin@gmail.com>
References: <20260816170541.3384-1-bernard.ladenthin@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

struct ts_state carries a 48-byte control buffer that callers cast to
their own state structure. lib/textsearch.c casts it to struct
ts_linear_state. net/core/skbuff.c casts it to struct skb_seq_state via
TS_SKB_CB(). Both contain pointers and so need 8-byte alignment on 64-bit.

cb sits at offset 4, right after the unsigned int offset field, and struct
ts_state itself has only 4-byte alignment. Any allocation aligned to 8 or
more therefore places cb on a 4-mod-8 address. kmalloc() guarantees at
least ARCH_KMALLOC_MINALIGN, which is 8 or larger, so a heap-allocated
ts_state has a misaligned cb every time. For a stack-allocated one it
depends on where the compiler happens to put it.

No in-tree caller is affected today. The only struct ts_state is a stack
local in skb_find_text(). The cast is undefined behaviour regardless, and
on architectures without efficient unaligned access it is a trap for
whoever allocates one of these on the heap.

struct sk_buff already marks its cb[48] __aligned(8) for exactly this
reason. Do the same here.

Signed-off-by: Bernard Ladenthin <bernard.ladenthin@gmail.com>
---
This is my first kernel submission. Corrections on anything I got wrong in
the process are welcome.

 include/linux/textsearch.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/textsearch.h b/include/linux/textsearch.h
index 4933777404d6..e117f9c9de59 100644
--- a/include/linux/textsearch.h
+++ b/include/linux/textsearch.h
@@ -23,7 +23,7 @@ struct ts_config;
 struct ts_state
 {
 	unsigned int		offset;
-	char			cb[48];
+	char			cb[48] __aligned(8);
 };
 
 /**
-- 
2.49.0.windows.1

