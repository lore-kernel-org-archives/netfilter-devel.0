Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E7AC3CC9F2
	for <netfilter-devel@vger.kernel.org>; Fri, 13 Mar 2026 20:13:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773432829; cv=none; b=pgFLi+lUFUlKwQUTnT3Ss5qxzVOhpT9qmwAWA/jOplJk4CKH9lkyhry7F0rzWAK4IWvuMXBkl9Q3WCT+yrudTgEj8a8aAr1JF0nCSxw9l3TIEXNvcSfaXzqokVjlMNagd3UoEhRwWT8vKrDkVwDjaqz5jufflqo1wnNH0o+gzN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773432829; c=relaxed/simple;
	bh=I281tWugee+et9EQGCIEYI6WwRIDABseU9N1y+8tlao=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=fUYRq6u5rASB8qWQVZ6UIVLjrR/k05JurqkLclE/L2IGSU+/ZhQ7DLwFFJ9/wl1eLw7ZMoSd0nTW9XGdCAJgX9q9L4gc5CZtQUcZ64ZtXKv1WA1AnNUgsYwzo9SjRR4I+wvYibo8q7MhIGXmsKfhMqXnYXTz/fLermatOZBDrlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=W2rJGxxZ; arc=none smtp.client-ip=209.85.219.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W2rJGxxZ"
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-899fb030812so35794806d6.2
        for <netfilter-devel@vger.kernel.org>; Fri, 13 Mar 2026 13:13:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773432827; x=1774037627; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=/frZHKD2ro7xqrcvZseEqBamuQh4m16RGkZd0eaQ9jo=;
        b=W2rJGxxZQYrUwSrVab+W3G3ys/pgryTv2neLMWe2deFeLtpws2Yyhvd1fr6D3XQ+Bi
         kAnVw+g39J4oHIr8BZX0OPEH4Oka29WrW2ywOGfv/aKoYYkqd3ML92n6rkFaDbgxm9CD
         b88+tosCz7MiGpZc6oxE11psWiUMq/QLiaUkY+ct/1JsbNxC9//yRkDeGrWkMtR65Kto
         4Vvu3YMC/L6O4E3h0iQDTKGzswcKxMBobOFvxEJ263u9drqukNmJyf/cVvCg7H6G9Lew
         dj9nCeWqE+nDkCXYbQYiNQwbLAe1Ajnux5QvoXG2OOjFqIMpNcC9mtYqIJxYcD8HQJCg
         WxjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773432827; x=1774037627;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/frZHKD2ro7xqrcvZseEqBamuQh4m16RGkZd0eaQ9jo=;
        b=gd8ux7laOlmAnCrztYWPTzIxNIbZyMQrH+J8xVvS1fAx9SKmnZ7NkRhR5m8rTzFokc
         A5/d8SLrUxf2hVQyb8+FTd4CnmJsviDEZf90oAHdsHdP9RnAyiXq6Jl707serHCTKFdg
         ua6ZtmBOK2eUxq1ZTAu5vJgyBt51bWYknlZ9QNY0F7Eb+ixFOhsxjDidAWoLiQuNUYSr
         3oAo5LDMV/ME3bmlDdMj2IU5F7xneeOlPllo94s7awc8ExJAunpyaWaYdOUNMmMPHzS0
         CK5DLHE5RTnjMZH/fZ+0f2OBMRyuG8u97txm09kewjQn4TVkbJAygeDhSfa4d6A2WceX
         VqaA==
X-Gm-Message-State: AOJu0YymdP7EnoVn5KRZ6IcQnuBknYfpBTusT2Kzd0JcPOQSLy76RW2T
	tsCRXNIJxg1pxDQFyTIw6JNeVWQI2FK5BaezpFbNnlV3zAs4EOFfocBB
X-Gm-Gg: ATEYQzwkHlwujOfMLydusDgxcYyDG7rZCFEV2d19KtGLOfgB8Xjlp7ncZzyYHEuItht
	hyIuUZlggYz2y2TB8/Yi99lB5vxU3fAIr9MbcHSRu1/8bo4x8iSeUf7gemgrTlzydMGXjoPOKvq
	80GKm9F1XNz7pzscTDDEf5Y8K/foxSZh2qafCBbAi1kApEituuJ2iszouiIqV4aAH615bD+nXwm
	t1eZN/8fUOVDyKFd9QQ6eTeREdLjcBZul/KT13gZ1ODJ3jAXqex66rjKz+b4WhW/U6SDpEWHiU5
	9Z0EmA2XLYvg4vY3tWCI2GP/lHzpG3TLm5PXeO5IHZWqPGgNO5jtewR3zw1+eMCkNSvCudj2H3K
	r+sUC9g8vrRsoH9ipAkc8tIV20YL3ibvONuA9IU4xM+vVvzyZSf4Zbh1rqDRODkt7S5z3j957kw
	PgP3h0ko0bsBTqkNeGrmp/vayM8xZPN7VjQvgoS6PHiSZ2
X-Received: by 2002:a05:6214:23ce:b0:89a:171e:2f3c with SMTP id 6a1803df08f44-89a81f7304dmr68901186d6.31.1773432826967;
        Fri, 13 Mar 2026 13:13:46 -0700 (PDT)
Received: from 192-222-50-213.ll.local ([192.222.50.213])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-89a7995b712sm39485846d6.31.2026.03.13.13.13.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Mar 2026 13:13:46 -0700 (PDT)
From: Jenny Guanni Qu <qguanni@gmail.com>
To: pablo@netfilter.org,
	kadlec@netfilter.org
Cc: netfilter-devel@vger.kernel.org,
	fw@strlen.de,
	Jenny Guanni Qu <qguanni@gmail.com>
Subject: [PATCH] netfilter: nf_nat_sip: validate exp->dir in nf_nat_sip_expected()
Date: Fri, 13 Mar 2026 20:13:46 +0000
Message-Id: <20260313201346.562476-1-qguanni@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

nf_nat_sip_expected() uses exp->dir to index into the 2-element
tuplehash[] array without bounds checking. If exp->dir has an
out-of-range value, this causes a slab-out-of-bounds read.

KASAN reports:

  BUG: KASAN: slab-out-of-bounds in nf_nat_sip_expected+0x804/0x938
  Read of size 8 at addr ffff0000d113e3b8
  The buggy address is located 72 bytes to the right of
   allocated 240-byte region

Add a bounds check to ensure exp->dir is less than IP_CT_DIR_MAX.

Fixes: 9a6648210687 ("netfilter: nf_nat: support IPv6 in SIP NAT helper")
Reported-by: Jenny Guanni Qu <qguanni@gmail.com>
Tested-by: Jenny Guanni Qu <qguanni@gmail.com>
Signed-off-by: Jenny Guanni Qu <qguanni@gmail.com>
---
 net/netfilter/nf_nat_sip.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/nf_nat_sip.c b/net/netfilter/nf_nat_sip.c
index cf4aeb299bde..48b1b2d70a1e 100644
--- a/net/netfilter/nf_nat_sip.c
+++ b/net/netfilter/nf_nat_sip.c
@@ -326,6 +326,9 @@ static void nf_nat_sip_expected(struct nf_conn *ct,
 	/* This must be a fresh one. */
 	BUG_ON(ct->status & IPS_NAT_DONE_MASK);
 
+	if (exp->dir >= IP_CT_DIR_MAX)
+		return;
+
 	/* For DST manip, map port here to where it's expected. */
 	range.flags = (NF_NAT_RANGE_MAP_IPS | NF_NAT_RANGE_PROTO_SPECIFIED);
 	range.min_proto = range.max_proto = exp->saved_proto;
-- 
2.34.1

