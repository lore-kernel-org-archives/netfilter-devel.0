Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 440C23A641F
	for <netfilter-devel@vger.kernel.org>; Sun, 16 Aug 2026 17:07:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786900026; cv=none; b=lQaFaoIixrL/GVVDtg2fWXO+CLHu9j1YoVZkh4HQbHRkVVUHFbR4yoYv+88OUNJlsR9cw9WzymFhR5rEeLuKh7ddydXLS0UURLnmZzXKqPXboAQAsBWhYbcWkH9Zr1Q5y+Abfzzt06Z+wJJiW4bDzBRsG7FixUmzpUZGuwkKHHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786900026; c=relaxed/simple;
	bh=gxV4kQ+OCvgh/Dml0PD7+RUVFmfyn0qzpnWoEaFYUHc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fV0flHlMCP5xOG1JXjyvBgo76DWK0ZRwKpPLxib51hHdJzrZLUYQpnr1XT4U6uZmu+nxXSF2aObzIGjLXUWbLmbvRtUT9x31LiOUU/XhUPbhJPenfbQlTcng+5qTw6vfvthRzZ0ZNp058FW1nMqAculV7DAAby35iL+xkeyWW+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PrBiQKJA; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PrBiQKJA"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-49800c6a846so30543065e9.3
        for <netfilter-devel@vger.kernel.org>; Sun, 16 Aug 2026 10:07:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786900023; x=1787504823; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ADy21TiCO8lIm8cjutcu3wh44q8LK9FtOZhFKac1cq8=;
        b=PrBiQKJAusXaH5q6tA+c4lXbXKI2onxlRcGg7V6WM+LLG4eaD5BcLStlREPVBghGaR
         avuO2drhkRlP+gFINM64qNeaRALQ6YXBaxfdQILb0V9AHMLRkPZt3zCe+IhEeBNb/atC
         wuQ5HO1SboTXLpVNewSPQCyXLdSzeWdzgbZy/gMzMQlc+xV7wBpYqlmzfosvmuTVLexI
         FjALWs8yRC/NvScwN6tLH86Ty0GS68hkD6hZPbCk+Ws/REKD18uWRnibBxdWVxVlUOuZ
         YgeJsEViQ14VWIhxh5rXrtg1TZqRPDYd2qQBaGnV6V38yuvYjA3gIDLdzeOKi+qdVtfn
         e0ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786900023; x=1787504823;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ADy21TiCO8lIm8cjutcu3wh44q8LK9FtOZhFKac1cq8=;
        b=rS9TK3fOB2OsNj+Fp4aCR9+a00364eNT1TxBSdRTMEx8Rs8v0eUf/dsQ8sRlZ5j1WM
         JRrf+i4sqqckAyfVp8Jp8Dv89Juwtt1+3MQVNlAVdAo3gd/QvQgZCfp5osry+0HD1rev
         t1YmjeiPCuX7yImysv+Xp7Lr7r4En2cwbuOmLCqlMQ/EW+dZ/MMB8DEPLmXzVFO2WIKJ
         +wyfremczzJuP1m0z3g2Pa9sY0dQNj5LdqRqRe2j0SLdaKQ8UTauqvAyAA/DcdI0NumK
         oKzi33of8MEQNH9PMTA1J92QBOgD1DKGwMOFQuoun2psutITlhqyi0wCQmFVFfVsTEOQ
         9AcQ==
X-Forwarded-Encrypted: i=1; AHgh+Rr4AMcegvUN/pIuEk1SpzV/mn6QrWQsxWTK03/Bh5ziZaGSRfEZh7X6V0PHDnevPkc7eDXKK8ZXs5e3dBaXvZ8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz1Xtaj1xLF9nSfepsYlBBZiefFF/KICve2wjqpxDrPr2rFuqF5
	5xNkAsg7dUrq2Eh/k4mq6EdrYg3L37iYbw/zQvZl2RCkL+2d6l0ccdXA
X-Gm-Gg: AR+sD106aj7A37YVGACnLItfVQmChAqgI57awvO8uqvKDm6Y1marGIaPUk/fS6j8jO6
	th3Kvih5kOLRiqS35mXxyJZ6y/F0hdsAPxF5ZQ0F24BWjW3Ulo1Jgyl23ei/YTWlGqdrZ0oHkkd
	g3Xh1ooEGw5THvNmP7y5ZnRHMSBBcW9LJ5i6SEnz5wUOJeOyLt7bv1As6oOki3UfSyryU36tss/
	752FeLjES95Of9gr+rEC1cX+TpwWMcmQ3W8fl6KtpvVS3M2rFxjf8rK8XH+L9juW8GsqrwAoRVt
	h9ovCHgSz4GMqh585Gepba+x4CEBA1tP+AIrcbfkuXl1CFrQeJ7Sh7Z2zcL9HEhqC+TvC+utX0u
	n1N2PoAii0hGje733wOVWLW9dEqGtXYwfJoOjjE+mezNc4P65+x7CTTBBvgzzE04HjHnNPhESjw
	m0YAQqDGEkrgQXGsNRG+lAlYuPLnpZTawJUQA+DZn7IOZKoZqyfYcyVKHPvAjKHMLi70/5NRN51
	k8CDPiQDInVnJ+dsbceV2hOsftImb1GVTGiv61219JBo16dtv8+QWYacnGWloTR67gk8A2T1v8R
	YJ68QWofuQHv+M3YPTpj5ZEVY9tinQWVbFmHtyk=
X-Received: by 2002:a05:600c:6289:b0:499:84fe:ca8c with SMTP id 5b1f17b1804b1-499879332e1mr265118815e9.5.1786900023344;
        Sun, 16 Aug 2026 10:07:03 -0700 (PDT)
Received: from localhost.localdomain (p54a14b85.dip0.t-ipconnect.de. [84.161.75.133])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4999618acafsm55671335e9.14.2026.08.16.10.07.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Aug 2026 10:07:03 -0700 (PDT)
From: Bernard Ladenthin <bernard.ladenthin@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
	pablo@netfilter.org,
	fw@strlen.de,
	netfilter-devel@vger.kernel.org,
	kunit-dev@googlegroups.com,
	davem@davemloft.net,
	Bernard Ladenthin <bernard.ladenthin@gmail.com>
Subject: [PATCH 4/4] lib/ts_fsm: document that a match must consume the remaining data
Date: Sun, 16 Aug 2026 19:05:40 +0200
Message-ID: <20260816170541.3384-5-bernard.ladenthin@gmail.com>
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

fsm_find() reports a match only once the token chain has matched and the
data is exhausted:

	for (tok_idx = 0; tok_idx < fsm->ntokens; tok_idx++) { ... }

	if (end_of_data())
		goto found_match;
no_match:
	return UINT_MAX;

A chain of three specific tokens therefore matches the text "abc" but not
"abcd". [TS_FSM_HEAD_IGNORE, a, b] does not find "ab" in "xxabyy".
Searching for a pattern in the middle of the data needs TS_FSM_HEAD_IGNORE
at the front and a TS_FSM_ANY token at the end. The latter short-circuits
through "if (next == NULL) goto found_match".

The file header explains the head anchoring but says nothing about the
tail, which makes the interface easy to misuse. Describe it.

This documents the behaviour as it stands. If the end-of-data requirement
is not intended, the fix belongs in fsm_find() and this patch should be
dropped in favour of that.

Signed-off-by: Bernard Ladenthin <bernard.ladenthin@gmail.com>
---
This is my first kernel submission. Corrections on anything I got wrong in
the process are welcome.

 lib/ts_fsm.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/lib/ts_fsm.c b/lib/ts_fsm.c
index 053615f4fcd7..ceec6295505c 100644
--- a/lib/ts_fsm.c
+++ b/lib/ts_fsm.c
@@ -18,6 +18,13 @@
  *   is enabled by default and can be disabled by inserting
  *   TS_FSM_HEAD_IGNORE as the first token in the chain.
  *
+ *   A match is only reported once the data has been consumed as well: the
+ *   token chain has to account for every remaining octet, not just for the
+ *   pattern itself. A chain of three specific tokens therefore matches the
+ *   text "abc" but not "abcd". To look for a pattern somewhere in the
+ *   middle of the data, prepend a token with TS_FSM_HEAD_IGNORE and append
+ *   one with TS_FSM_ANY, the latter matching whatever follows.
+ *
  *   The runtime performance of the algorithm should be around O(n),
  *   however while in strict mode the average runtime can be better.
  */
-- 
2.49.0.windows.1

