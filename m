Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794824133;
	b=fPoDu1sMAAsB+cKIwr/NnwdC+sEtlwcxv/KMYjrAAxj1/HLv4TOwKveBqsJQlMLrSs+u
	 Q5m3N5Pj45DgQojJvBdVQFjGPzWKtnF9Ot+A9Yeh330zDDBL6ybOVq3f6d2Aui/8ZVU44
	 Dh+gOC19O5VZ+UJCIhT9IQexz/NgcJ/B8jaWGAZ7qtAfzqm1LiBQLN+D2W8vEisGak9tW
	 UWTRqZGmhikGx12ynpGQn7fLFm2dXTmFYgyS10YI5Nv7nOCTrRds1rYLx2LAcRbDTDh+D
	 w32+l11EOMEH1TcLGthpxw6L3fmbRzRr9CVDe5XUBe2i4+n7BEPzAod62wv4bGNvbXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794824133;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=MmFHwFEuMpLfLRAKJJjBjIdikYWgskAg6Z40N1h66qk=;
	b=vUEwQ3xAK6qLpWCEje15MdmXQH8jnZx9PyBE7aOWqIte43loDCKCvkmcGixaKO3iC2Dr
	 fAGRc4EqOiadWc3zn7pHMgj+wb/+hS8TzIx0tihKL2DSWoE/EE1wDpaiC2duw37/LcwDL
	 Fj9Nu6ENkgVRslCjblMGNcX2ln91eXOF9U/qhpThJHNCjnfnq+bLMiufRY0Y2TGpTIx6B
	 Kfbe7Nrq4kKcF+11e4xEWRGqnRPJYUbBegwb3AIyWFpzxk18aycxHvcFn7O358a8PW4xo
	 9pOgumVDiYTvcowX/ooag8tS+2YM7VxngwKhYtHTb2LvBhME7FJz6ACP+vkCdQysYXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=HgAYqc9G;
	arc=none smtp.remote-ip=209.85.208.52
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5062B606A32C
	for <netfilter-devel@vger.kernel.org>; Mon, 16 Nov 2026 10:15:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5062B606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=HgAYqc9G
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-6b6f42095bcso4542304a12.3
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Nov 2026 02:15:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794824132; x=1795428932; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=MmFHwFEuMpLfLRAKJJjBjIdikYWgskAg6Z40N1h66qk=;
        b=HgAYqc9G+r96o0aqLB0eD65XAGTpvqpGGt1tW8Ub7O/zlwjAXz1TJx3hFYyjVwyZ09
         ECxETVeCo06ckRHSN36lx41RzEpKa2tvpIimz2927tVhlZPmryHZF2EL7RoebI89/kfv
         fY4XMfG987AjFYznToDjdOG6cRZtFHqytosoCqFNm7pkBmCTuUTMhzaCvCKvZhw8BgSW
         nb2VijaUGgqbOlOrDlLogUZwZVHbdXT/2BY7o76L+vWqspXux2lQVg0LxzJbjnvzXpeQ
         b6+N6W7V2SaeT/vujdVrAi0PrvF14wgBNST8KCkL2miE0tnLXS+SXFukDhhwmIqG8Ry7
         0bqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794824132; x=1795428932;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=MmFHwFEuMpLfLRAKJJjBjIdikYWgskAg6Z40N1h66qk=;
        b=QQfUQMfz/S/yW71kCALkgqpOFyYy+xKT+EabTsJR8Y2tp/irDyl6egX4tNAy4f+AYS
         qCeac9tsB8BHeRK6hyRo/xDFYpywJKbnP2RFaruYUoLUFRfgU17Ce/mP+D79ipWzsvYC
         OSQ9lhv90xIcUB8hBLsyOqwVWjhxsxWR188EWNhbLqN4BNY5nZgUzKX+WgBIiUb4N766
         +eg0yjWv75KvkS3ekJjAsgcrxaLlmlc8/fJOopS9AZ0M93iyVt3jtRRjajzXgVrnaGc1
         03dLO+Rk/em8wuHvA/x1RuAy2Vrfd+0rVFl1hl7D8rb4H0J7SLijM66hV0NUaE+DA2+D
         2zxw==
X-Forwarded-Encrypted: i=1; AL+hErErILhG/6rhm/LpUHh0VXzpcqTIIRcqt0Xz5/O4K8NZ0FvU/23Cz6E3qzr3Np+Q9k7CkRp2+FZjNNVq0THYtqY=@vger.kernel.org
X-Gm-Message-State: APuU4Z861Mo1abnTjWIVjCYfY10UDhBBn68ZiFFiOj9grCgfthxNA4Zt
	J2YaZzwidY8yWeg6LvjmuyKuJx+2fQCoKi66hsoLsS0pY0Rsma6QpPEHiJRyzzZndE+V/s6P
X-Gm-Gg: AYBFou0hHuNQklBl483WxPVx17NV6zEzKPPJa/I4KuOSBMobrMQBZSOXQS8V6TM5arq
	ROaZGDnNRgSgfuhxzoco/kXnSPBMocoAi8I8bczRFrF8hSLv1Ui0JPb7iXbgTZ/Mz7AeydSJPpy
	/67lMvXUgdt/cavikaxprM3R7YZbXS5uue15E5QJez2ZMsKbsJHUQtGLlE7APR5EvF5tckAltcR
	JiFbVoCVq0c4t7ETwWMbxdZ9hTlxi2JkQoIBKRWfjBdBco0um40I1Fp2TVCHteN60ZQGZuWsLYq
	ldb+hCu/Zd2bid6di8pS0TE/WOdTD+RZhMoQgHaZ/G5712MruCarulNRBoEsyLrYqUR6vYRhMle
	1esvgmm9/z8RZotoelnI+sr8UqlgVZYebv9dJXBOZhNesFVTF/v6ydS+G2QQPZy61tSsvnGUlhW
	Sm5pqpY9f/s7eb5asL0qN45Tf2UT0vvA/gVDD6OwabnigpXTZ8OwLlpBvYej5rW1U7V3ltFEreY
	kkBzKb7PeHT9p2Ctuu+um4xjWJ2N6YGm8SJYckeZ4yBVx3nobjA02sOZEG58+ayyQDy1l4NYdfM
	8RQIYlPqwPxKsMENfelAbDEZh2wtDG/kx+TlhcvaWg+iiIWZ49Q+cRSDBKWW
X-Received: by 2002:a05:6402:210e:b0:6b6:8ed8:765a with SMTP id 4fb4d7f45d1cf-6b7c0d06184mr7571102a12.38.1794824131325;
        Mon, 16 Nov 2026 02:15:31 -0800 (PST)
Received: from theodors-laptop.. ([5.255.118.7])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b7c24e7714sm4235699a12.28.2026.11.16.02.15.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 02:15:30 -0800 (PST)
From: Theodor Arsenij Larionov Trichkine <theodorlarionov@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Julian Anastasov <ja@ssi.bg>,
	Simon Horman <horms@verge.net.au>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	lvs-devel@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org,
	coreteam@netfilter.org,
	Theodor Arsenij Larionov Trichkine <theodorlarionov@gmail.com>
Subject: [PATCH nf v3] ipvs: ftp: do not link expectations to unconfirmed conntracks
Date: Mon, 16 Nov 2026 13:15:06 +0300
Message-Id: <20261116101506.98853-1-theodorlarionov@gmail.com>
X-Mailer: git-send-email 2.34.1
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

ip_vs_ftp_out() can link an expectation to an unconfirmed conntrack. A
later extension add on the same packet, such as seqadj in
ip_vs_update_conntrack() or NAT, then reallocates ct->ext and leaves the
expectation pointing into the freed area:

  BUG: KASAN: slab-use-after-free in nf_ct_unlink_expect_report+0x490/0x4c0
  Write of size 8 at addr ffff888004dd4e48 by task syz.2.17/649

Link the expectation only to a confirmed conntrack.

Fixes: b25adce16064 ("ipvs: correct usage/allocation of seqadj ext in ipvs")
Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: stable@vger.kernel.org
Signed-off-by: Theodor Arsenij Larionov Trichkine <theodorlarionov@gmail.com>
---
v3: skip unconfirmed conntracks, as suggested by Pablo; v2 did not
cover NAT.
v2: https://lore.kernel.org/netdev/20261113011447.2357709-8-pablo@netfilter.org/

 net/netfilter/ipvs/ip_vs_ftp.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_ftp.c b/net/netfilter/ipvs/ip_vs_ftp.c
index 44de99f4d187..cb0cdc35a7c1 100644
--- a/net/netfilter/ipvs/ip_vs_ftp.c
+++ b/net/netfilter/ipvs/ip_vs_ftp.c
@@ -398,8 +398,10 @@ static int ip_vs_ftp_out(struct ip_vs_app *app, struct ip_vs_conn *cp,
 						   end - start,
 						   buf, buf_len);
 		if (mangled) {
-			ip_vs_nfct_expect_related(skb, ct, n_cp,
-						  ipvsh->protocol, 0, 0);
+			if (nf_ct_is_confirmed(ct))
+				ip_vs_nfct_expect_related(skb, ct, n_cp,
+							  ipvsh->protocol,
+							  0, 0);
 			if (skb->ip_summed == CHECKSUM_COMPLETE)
 				skb->ip_summed = CHECKSUM_UNNECESSARY;
 			/* csum is updated */
-- 
2.34.1

