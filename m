Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.171
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792733183;
	b=u0+pw6VvrGwVlLB2V/hLH+IvyI8Jw2OhY++7u+4RV41ySuSKKeXOCSC23m3f4g8ovFSk
	 yXmtz8MpMNOUo0p0QstFYWZjKhKLtQLpo/pnkL0GZwJgMh9ymrbPK0n31J0n3wAb1zvv2
	 pg6uesav1DGc1dzZ2ehCzzRaY1yUfMcqaxnrM0QICOnmlQJZjowKyUOSKBSEKoCfA2jza
	 g8bqNwiLS3HgnQ3+vofz3kVXbFou/0Po28GBr/eyD9ixjQ5DgU8ELUJwq57R8LCdAgZVl
	 36F5QF5JGpEGsK4Z5QWwi5OoO4Q48xsGKUF7v5ZxhZ+K8+OnJvDBi0e/La666V1188Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792733183;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=pZB4THbsnV6kIGtfvTG9sDlt1qcRS7qvS8+h0JwzfVI=;
	b=2JFH3vF+gvgE6u4Ka7FFpCgl7fZe0MQQiqU+CgHnLHvDw5LvYWFuTDqcxPsxdrl2WAr9
	 et06n2jzt2gZY5tVA3gMWEBxXOUEduN5gM7tuH+Md4qI2HjtteihjgsS87pXKUf9Bim9Z
	 LFwTMKiERsKbwxLWJolCcNVEoERCgOI+/PvYxqKNHhXxyfeR17KnF3xo3OJTS7CbJC+Nr
	 LT3PukNT878aXikCOPbyLHdbG4et9XEa1QkpSjmQM1LE4bQxrGJl43RKVVh4/mb09guHv
	 U42diONbRZ3oFszUXZ1EDO/EumDuehW9IwTx0bdhqCaPrMFDs7XLrFyAzkk0zAmTpeA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nebusec.ai;
	spf=pass smtp.mailfrom=nebusec.ai;
	dkim=pass header.d=nebusec.ai header.i=@nebusec.ai header.a=rsa-sha256 header.s=google header.b="ebKHI/77";
	arc=none smtp.remote-ip=209.85.160.171
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E279606A320
	for <netfilter-devel@vger.kernel.org>; Fri, 23 Oct 2026 05:26:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3E279606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=nebusec.ai header.i=@nebusec.ai header.a=rsa-sha256 header.s=google header.b=ebKHI/77
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-535f9de49fcso2844031cf.0
        for <netfilter-devel@vger.kernel.org>; Thu, 22 Oct 2026 22:26:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nebusec.ai; s=google; t=1792733182; x=1793337982; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pZB4THbsnV6kIGtfvTG9sDlt1qcRS7qvS8+h0JwzfVI=;
        b=ebKHI/77G5ND3jK28rSVdqqKBR2owpbpl+9tilZ1fvgVMllKu2RkRYqeV1+GpoAD9n
         4YXkcNGhUxZgzP1EWzKgvX8EOWn/WJ1OeFIQIKTD9PYofTZ1YtOSV6u28O9rTQqZci/G
         rKTPZ5DBJMSu8X0UPmRzOr+eTXVG6PaZdW1Ma50v96MwZ+it4dEwJ4S+Df499rTQgnSx
         al37JUp7qJX/Cwa87HndVQ0DNaqtiogujdX7Ro8BTVWNirzwHMlND/qWKOeywI2T7PNB
         OoSK2CFSp9V6bqPzpKpM/Yq0k/rsujbFZ8gQ/pFVsJP71dCd3zznGfd7GevSfZmLiO3G
         KrXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792733182; x=1793337982;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=pZB4THbsnV6kIGtfvTG9sDlt1qcRS7qvS8+h0JwzfVI=;
        b=On1fkP6pyx1t2cqY2U14qb6vC1QYFVyIVmwZwBdUrXw3rrDhKlWPTYr9gUYPD5kA1C
         ljHcpQ6fZyG9P99pBlwe1NJPieVIcHZvzqGjho+xicW0CTep3+hWrchvGG0bRbRX/c3c
         RsdA72prLrpXirLlEQiSEgkqtn/VVnPicCq5XxkO4sZsXy4vcaW2hDsX8bfBBhsYFgNo
         LPCJLeD55ZOuHSnbM+e2g2W5Q3mjqd+BLgbjS5i86qQ9bM+9gRl8OTkyEBShUuKspj+C
         TO2UWuy0VTcpPslAxWlNFK/0m46X39Q24+na4OCsSXVKOe4LOMdDvtggkFJnwxyvEoSq
         tMCg==
X-Gm-Message-State: AFq9FYJv6oIfvsXttxUi7bPNz/AvoxrWEIDcFyrozvQWgV5p8NMLAg0i
	+9MtcpOMkEQjyAyb7ZELkMQIyqiddaiKjSyycLnGt5Bh4zzsdVGtC26K5agH2QPqno5KEl4kjJ7
	u+JlrugvoEjQ=
X-Gm-Gg: AYBFou3uKZzCH4NkJo0aw6P6l89GdHcCPuVdR/ePVg6KfTZJbaiqPjAIIGwJvm4O+Ge
	Ufam8jsDRjbaBAPTD3d8xT7fHWlM22rxq2RtLtA/gwEqJLgZ+/qz5Uhncg8r7MU/ixT5sSVpf0F
	PQgIidi6b0Js7Hvo451StrbKjyfrSA0TSa4/MQIfupkXjGoGERAwZqgoYfJXoznCPwevykJhSri
	kT8LPHor9PA9v5SI3Kgb8wlpbMbk5ytE/Yd2aMo5ixUmwuqyB4f2VNGENu31iXUeONiGiq3Pt/z
	IoskQtj0FwSME52GZDLxVNXdAdPMvkehvXk+kr5LjRR9XpCMWBbR/RdeoOqXat3lrdEuMzero0G
	5wdBO4gXsn6ICeV0vbJ+lNCzwKNyZ7Tk0x9VShyjKNlA5OTnNRWRaWPZsfdUEDMSmF6LScWEKmM
	IYu/YIJ8Y9MOlQpmVEbkx5k4lz1sCZIECkb9941WFtM6cbYA4zHCccGhU3PZ8kNBoDtWOakk8K0
	H8vk+IYasJFV/aCOSaHVWc9hUEpz8z5WEdNutoPBVks84Hvk3s4t9ld7yWR2GUofr9bP/NwY9hN
	Dq60RUoDGqszpOy+
X-Received: by 2002:a05:622a:344:b0:532:9b14:96c5 with SMTP id d75a77b69052e-536c26d6904mr13467591cf.60.1792733182073;
        Thu, 22 Oct 2026 22:26:22 -0700 (PDT)
Received: from Roxy.sysu.edu.cn ([203.175.14.54])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-536c17f4b5csm9255441cf.14.2026.10.22.22.26.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 22:26:21 -0700 (PDT)
From: Zhiling Zou <zhilinz@nebusec.ai>
To: netfilter-devel@vger.kernel.org,
	bridge@lists.linux.dev
Cc: pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	razor@blackwall.org,
	idosch@nvidia.com,
	vega@nebusec.ai,
	zhilinz@nebusec.ai
Subject: [PATCH nf 1/1] netfilter: ebtables: validate compat nentries
Date: Fri, 23 Oct 2026 13:26:08 +0800
Message-ID: <280a41badb424f8dc5fa22d03d6abf82025d539e.1792733039.git.zhilinz@nebusec.ai>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1792733039.git.zhilinz@nebusec.ai>
References: <cover.1792733039.git.zhilinz@nebusec.ai>
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

compat_do_replace() allocates per-CPU counters from the compat header's
nentries before it parses the entries blob. A malformed request can claim
millions of rules while supplying only a single empty chain, causing a
large vmalloc() before the request is rejected by later validation.

Each rule occupies at least sizeof(struct ebt_entry) bytes in the input
blob. Reject a rule count that cannot fit in entries_size before the
compat path allocates counters.

Fixes: 81e675c227ec ("netfilter: ebtables: add CONFIG_COMPAT support")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Assisted-by: LLM
Signed-off-by: Zhiling Zou <zhilinz@nebusec.ai>
---
 net/bridge/netfilter/ebtables.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index 0bf541936f601..e24b2c0698892 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -2269,6 +2269,8 @@ static int compat_copy_ebt_replace_from_user(struct ebt_replace *repl,
 
 	if (tmp.entries_size == 0)
 		return -EINVAL;
+	if (tmp.nentries > tmp.entries_size / sizeof(struct ebt_entry))
+		return -EINVAL;
 
 	if (tmp.nentries >= MAX_EBT_ENTRIES)
 		return -ENOMEM;
-- 
2.55.0

