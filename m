Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C66FA2475E3
	for <netfilter-devel@vger.kernel.org>; Sun, 16 Aug 2026 17:06:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786900013; cv=none; b=J1+cucnZsRJWt7gu45SC+PP02515/I3milvEuBfBQwqh7BaUjXBhS0qDXfGKmw6cXaoYcSPlpA3FmbWzYAanuK2lF0TlYUbrA1Br4DR1Hr1vn8MfuMGugth7cDgzB0qBx3Y/bZ1KGP3gvSrcZzv0K2kPKdWNE1/AH8OQEDPckfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786900013; c=relaxed/simple;
	bh=jXdBmOJ0ziF4vZ8k3JfSRKjfviukl/lYqgcx3OeIMlw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sg10TajNGEiAZSc11gUMIJ6RWmGL8OD/5muOmKztKAZ7NE0rrRvUT4DTMdah8t/se0usY5yvc0xSUnpA1s1NQmQVKw970d4x6gGLDH1U2wju/jyNYcDSYxx0MYWkrgIOn1PAAgudciu4op73/iiFUQhtqGKqT0Ql+K/ZuSt0ek8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=I/0S5dqA; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="I/0S5dqA"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-49800c6a846so30541635e9.3
        for <netfilter-devel@vger.kernel.org>; Sun, 16 Aug 2026 10:06:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786900010; x=1787504810; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=U1Ixo7fgt6nx2xcmQkKup8mBmE03cs139sFvFDg9BSQ=;
        b=I/0S5dqAWIgVhNlPc/+CUf19zqcBoJ96R911lWn1uONFv0rSMrEl4Kr/K8oUOm1ASE
         DPNLO4+tMk3+tSMU85tvmWydlKrFtXr9mGEdNCHNecI02vOnZ+W+Ha0GxKhJrcQeCwwQ
         ekm7GkNvXKid5iX8M9soIMEzpOaum+cvls7ghBn77D5MB+lVq9iq15IM80i9XPx0mXql
         3I/QbeE8jCf35r2gy6pwiPfwLSv+Rt0ZwCpcGCB4tCo1+kvcQbd3+u/ZwkD8Csy/uei0
         nUXFphNCEbVVQkSTNAxvFu8mx+rrzCAii/iV0YrAMdx0IwLbk9tnCvnDdNJBYbnErK15
         Lf8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786900010; x=1787504810;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=U1Ixo7fgt6nx2xcmQkKup8mBmE03cs139sFvFDg9BSQ=;
        b=CxJ0ApPM2sr76f5ot1Dupgo3sCChweap/QxEssMZ83AQufma3XOrlRh/34VcqovVfE
         eRYh8txfQghfbnXi0h0ChoZjd85CM3wERr+DIjyWVIUx5p3cEZkGz/2r/HlnclE5FBQ3
         Mjf5SRokH6v1CJfuHw14QghXha06lNNC4VGpmCbg1yHpM26kljbgTPsXeeDrHBXPZmef
         8hAttNklN/LcyTRUkzf4D3TJsw/Fd5L7Otw/CJqv8abGRT9375Mr5duuQgJV8xpNTGW5
         XF5iH6U8qNDcHiYyiSyv3iD93V4tEG2xK2k1vTKhJx6vgvlXY1zzJipJ042l/fo5ecMA
         HpVA==
X-Forwarded-Encrypted: i=1; AHgh+RpWlFKiLE+8DF6b4p3VvjCuic98ppZikRE64PmzVftP4gWPuSXVWBj5jw3bwv8ObXR3I16kbOFNljB8FXxsrKQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyw6RVUu6Nkv4k/4n9Y9jdXG4/UwF46Uy2ZXUe4Ft65mh50fFIF
	+eIb3zZw0BVArOZoqBI3uH/AHV5CDcYEGiUTDpcG19Zz0dhs84K7y4QV
X-Gm-Gg: AR+sD119JmXJhKV1Uf6duTxo8z+UhaL/EzlMdIO5yaNeKcudPDmiM/EnA0LLYwqGCIk
	xuqckxUnjYzvCKvtOAjnVbd7cx8mPbX0jqrPUUqtrLV6Bvr5N8FEsnqux4ZCpRMATxJnANK4DME
	2mqyLKKl98biMJC/tQFh0iIGPDaSmgpP1flThWZQlpP+Rz+OXqsss1J+IrylbQIBEgsJFx4OHVH
	pASUSWDycT0iMPESiwsNYZ8ggaHeMmQoXL+O8bQfJ4Wf1Wst9Ppbk0KH4SFfko0BjFDFWAsxyRK
	+RbZsj2fXPq36A1kpAr3aBKbsiXpqpBJ0LWEirM+JyBify6q7K8vVtQ+cvSKXM6wUJPnHYLtX+4
	1ncyvHTg220STLVJnVkHflWmVNxM5IO90zz/3p4Ox7qz1RSxhvq4x99Q5SPu7WAkYg7KQW0tcbd
	i9KYXqdNI25iVuw5Nhupm9S/Nl0WrWCUTn87C2+v1IY5rEHOPjyTIG6viYhFZ6O6IHHUDv2SoG4
	Nmqd5VGcbeKkgO+066jGYxBISfIFpPPrbD1tNw7+WPRg5kkD+E+VzFMFlOcGy8Yo6i/idbrM98N
	W2QeXOY6v+EmIHpqwsC6zgNa8BbQlWrodrfohmcNwGsenmrmAA==
X-Received: by 2002:a05:600c:3545:b0:499:79b9:e220 with SMTP id 5b1f17b1804b1-49987958779mr270559505e9.10.1786900010082;
        Sun, 16 Aug 2026 10:06:50 -0700 (PDT)
Received: from localhost.localdomain (p54a14b85.dip0.t-ipconnect.de. [84.161.75.133])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4999618acafsm55671335e9.14.2026.08.16.10.06.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Aug 2026 10:06:49 -0700 (PDT)
From: Bernard Ladenthin <bernard.ladenthin@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
	pablo@netfilter.org,
	fw@strlen.de,
	netfilter-devel@vger.kernel.org,
	kunit-dev@googlegroups.com,
	davem@davemloft.net,
	Bernard Ladenthin <bernard.ladenthin@gmail.com>
Subject: [PATCH 1/4] lib/ts_bm: advance state->offset past the reported match
Date: Sun, 16 Aug 2026 19:05:37 +0200
Message-ID: <20260816170541.3384-2-bernard.ladenthin@gmail.com>
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

bm_find() reads state->offset to decide where to resume, but never writes
it back. textsearch_find() zeroes state->offset before the first call.
textsearch_next() then relies on the algorithm having moved it past the
match it just reported. With the "bm" algorithm every textsearch_next()
call restarts from the same place and re-reports the first match. A caller
looping until UINT_MAX never terminates.

Searching "xxABxxABxx" for "AB" reports offset 2 on every call. The match
at offset 6 is never reached. kmp_find() and fsm_find() both update
state->offset already. This is an inconsistency between implementations of
one interface, not a documented limitation of Boyer-Moore.

Set state->offset to the end of the match and derive the return value from
it, mirroring kmp_find().

No in-tree code called textsearch_next() before this series. The KUnit
tests added in the following patch are the first. The function is exported
though, and lib/textsearch.c documents it as the way to fetch subsequent
occurrences "regardless of the linearity of the data". Which algorithm a
caller selected should not decide whether that works. xt_string lets
userspace pick the algorithm, so "bm" is a live choice.

skb_find_text() also mentions textsearch_next() in its kernel-doc. That
comment has been stale since commit 059a2440fd3c ("net: Remove state
argument from skb_find_text()") moved ts_state into the function's own
scope. It is not evidence of a working caller.

Fixes: 8082e4ed0a61 ("[LIB]: Boyer-Moore extension for textsearch infrastructure strike #2")
Signed-off-by: Bernard Ladenthin <bernard.ladenthin@gmail.com>
---
This is my first kernel submission. Corrections on anything I got wrong in
the process are welcome.

 lib/ts_bm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/lib/ts_bm.c b/lib/ts_bm.c
index 676105e84005..eacc49e64c56 100644
--- a/lib/ts_bm.c
+++ b/lib/ts_bm.c
@@ -98,7 +98,8 @@ static unsigned int bm_find(struct ts_config *conf, struct ts_state *state)
 			if (i == bm->patlen) {
 				/* London calling... */
 				DEBUGP("found!\n");
-				return consumed + (shift-(bm->patlen-1));
+				state->offset = consumed + shift + 1;
+				return state->offset - bm->patlen;
 			}
 
 			bs = bm->bad_shift[text[shift-i]];
-- 
2.49.0.windows.1

