Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794913586;
	b=SNZXRUhVCxHl2NzNwZqrzJeC8oQDt69ozpGz1XeEhhXfBnI06dDhM2/PHcwpkNZvR0NO
	 NH/KH666beu6Jia6MsjWddwxBvawh54eSqlNs/F0C0UoupZv7g8/+CnHGgf5s3DbEXstt
	 Hzv7Qws+Jqar88sp9fRFuG/nWajHKFflvr/dcppfq4db3y4ZjQ1QYsvOycRFXy3N0EwQw
	 s2O82wdZvSJDSh8OksX5J4LYJ8XXBxmrxXHdn+7fYsAZaZaUZ5EDeJsI3X2XEnPbJ2MxI
	 NjAkRT7ewEGiGJyDpHlX+6gNIESM7Tl6mjQyTzG0eCBcMk2EBDGkfh9Q+cdyoEpKuOw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794913586;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=EvItfJHxd8c5dTklJAZwYq0woDsuW876EaS8CC1xRLY=;
	b=EjbRb2uDd4eNup9HnuuY84Dad1mQSksmDUp0exIaTAw3oNdeJbgZapW/gqGx+s5sh6MC
	 xv9aJExouorfkriTUIjYCA0126mr8jMGGt4QhXH0lyW1I9AGNiC864+zQwlKtbbCliecA
	 7YUuSkDhx6ODzPCb0CXWDEiSqGEMnhXlslL26vvz3g6iclOQDawYERIc6Tvs0au5u7UI8
	 WQFnSzgvu7kmCCMGzHa+d1JedFVVsJIekbnXg6H9nVZeps+VQjegnQd+AdrAcB8SswRtg
	 pKKRCrT9AK7FAe35Pw6X9JlNW+GJlNL23ejIwcDn6iz0RoGgeggY7NdAFcsUwyCjFIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=GTtYMygC;
	arc=none smtp.remote-ip=209.85.216.52
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D2FC606A31C
	for <netfilter-devel@vger.kernel.org>; Tue, 17 Nov 2026 11:06:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8D2FC606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=GTtYMygC
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-3adac5b29ebso3584994a91.2
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Nov 2026 03:06:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794913586; x=1795518386; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=EvItfJHxd8c5dTklJAZwYq0woDsuW876EaS8CC1xRLY=;
        b=GTtYMygCZEplb7cOyOjnmErSi+ti+NxCiu9NyR92mBZE0QqYvw9Ed1AMazj8lLlccp
         J1FnTTSvbyQKvJZoTpzmxUQGUpNwFQcCYmkRh4MmP/YwrHwpwjghLxV0HcmzgvbUmdkb
         Uf98ItmaElvdNp+vMIgBvXUfE7+CgJbtE0yz7fmi9jk2wvBT4lELEsP6Mlt8+b7Nn7VC
         P55wLonSgHUoY0c1LX2lziWtwtIcNlGcP3ZVDURQZZYioAQhdvsYFgEWPMKPhzz7k/Rs
         /eYCuK90hpuxuMZFqszcNR1To/cx3OOSjSnCqkrCwR66jCSxISd1nJXHiUUalY3ZGAa1
         ZzTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794913586; x=1795518386;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=EvItfJHxd8c5dTklJAZwYq0woDsuW876EaS8CC1xRLY=;
        b=erNTaAXWIQ1xcrf7g/v+Bisk4cJebFY5w52hVmKNzP5Xi8rjeksIwNGQXinshUeOas
         VOkT0dEH9P9TYLFcLL55JlY2E7gy/WSMpnKcvrAEnOHNQfBZ7B/+16SQWb7ZjRzuzo2H
         K4xSKIUDASKSUdB3+FCuAIAa0O99WZ61hv6fmU45zznmMHL9tJGHpdDKsh3EsSwpEFR5
         50AtNKA1CrI2huYB/grXkQgNBrUOjMiLZ5PxcZ38wZB6gdzWRLWNeMMspQzkfHlh9Y32
         J0/1j2Qs4V9voXDyOs2OMl2US8kvnp8ri3HzCAwguzhgAUd47j+DdzXRMmIvaJ05S61h
         mFYQ==
X-Forwarded-Encrypted: i=1; AL+hErGVgP2hQXaOjPlmxXBCMQ1bIOYSqRu0jyl1UY7I3uBn8+h8804th8MZeZhN7rzq1K2eGDF7SCiwL9NWUjsynFc=@vger.kernel.org
X-Gm-Message-State: APuU4Z8qOso3RLDZhMVWs/RZjC5dLEinXSZM81im3dIslIULwkJhFOt7
	hEQv6j9Zo/wvdmnTaqTj6HpmhAAjFrAfIaCTOPpeU7usqHKDMoxEVKLi
X-Gm-Gg: AZFdTZfPCEoD2C6WhtP8KBA4DWFVIHmg+wFT/FpOC9bUeNr4fQfNhYi/m+7CRpfz/xB
	OOkJsdkuoMWacx7mmV3pqrhJSUQsrAkmMijpwJmRSWtA9xx+i6RGTUy8yXdaD3iLvh3wor8OBh/
	d4+8dXwoYyx/FBq1Peg0UO+wJ9SMyDNb6sjrbMjEvzLEHqzIxqoGT677X+6V9KjMOOuKV350Bob
	PwLu1//obyrKLWidjNA6S0D/Lr7JGa3hkYB0bo80gMAZTM8HMqaOIAAkT9btDx12WBUPwsiWU6y
	XGccSNH+heFBBlR0zOCR3z9uwLNmWvIRsXYSshd7gSrecTXfbv/gS9fyWlM0mnvrCj3//ZJBkRo
	Xzh/VBjbb88BhVhNlL+tHBS9UEwZbkEYS1Ew6dR0SgAfkndD4ukpMTwyhuG7dbnty96vx00XIl6
	B4pKFJjMNaH3IV39MEq+UM6y4WjGPowiQ6ioOe/LFgdPWUNpkGv0RT9+esrSBnfKlSbAcoaue+9
	QFcajWtEumkyMY+mf4m3C+kZ4aIznltKdg1fsHS0YSPT7bpiwiJP//cFrYe8Xiqlq94Ie4zCn0u
	AgegZVU/yP/0ig3LOhIa/bCis8K5EXzTnk53DXy4Zym3zUeNWtRXUKJdYzq2bqi2yTSxbZx/TB6
	JRP0O/nl/AdzyiA==
X-Received: by 2002:a17:90b:5347:b0:39e:6a80:b799 with SMTP id 98e67ed59e1d1-3b1b0a3ba60mr15136679a91.41.1794913585863;
        Tue, 17 Nov 2026 03:06:25 -0800 (PST)
Received: from JUNVYYANG-MC1.tencent.com ([43.132.141.20])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b1b1e9ef15sm11674475a91.0.2026.11.17.03.06.22
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 17 Nov 2026 03:06:25 -0800 (PST)
From: Jun Yang <juny24602@gmail.com>
To: pablo@netfilter.org,
	fw@strlen.de
Cc: phil@nwl.cc,
	davem@davemloft.net,
	edumazet@kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	kadlec@netfilter.org,
	echaudro@redhat.com,
	aconole@redhat.com,
	david.lee@trailofbits.com,
	manizada@pm.me,
	yifanwucs@gmail.com,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	junvyyang@tencent.com,
	corvus@tencent.com,
	stable@kernel.org
Subject: [PATCH net] netfilter: ipset: skip inline gc during hash resize
Date: Tue, 17 Nov 2026 19:06:11 +0800
Message-ID: <20261117110619.46590-1-juny24602@gmail.com>
X-Mailer: git-send-email 2.54.0
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jun Yang <junvyyang@tencent.com>

When the xtables SET target adds an element to a full hash region,
mtype_add() runs garbage collection on that region. If mtype_resize()
has already copied a live element, both tables point to the same
comment. If the element then expires, inline GC can free the comment
in the old table. Destroying the set frees it again in the new table.

Take h->gc.lock and check t->resizing before running inline GC, as
the periodic GC worker does. Resize sets the flag under the same lock
before it starts copying elements.

Fixes: cffcf57bf03c ("netfilter: ipset: exclude gc when resize is in progress")
Cc: stable@kernel.org
Reported-by: TencentOS Corvus AI <corvus@tencent.com>
Signed-off-by: Jun Yang <junvyyang@tencent.com>
---
A KASAN reproducer for this issue is available if requested.

 net/netfilter/ipset/ip_set_hash_gen.h | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index 80ca523f304bb..70f768ba7b443 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -1009,8 +1009,12 @@ mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 	maxelem = t->maxelem;
 	if (elements >= maxelem) {
 		u32 e;
-		if (SET_WITH_TIMEOUT(set))
-			mtype_gc_do(set, h, t, r);
+		if (SET_WITH_TIMEOUT(set)) {
+			spin_lock_bh(&h->gc.lock);
+			if (!t->resizing)
+				mtype_gc_do(set, h, t, r);
+			spin_unlock_bh(&h->gc.lock);
+		}
 		maxelem = h->maxelem;
 		elements = 0;
 		for (e = 0; e < ahash_numof_locks(t->htable_bits); e++)
-- 
2.54.0 (Apple Git-157)

