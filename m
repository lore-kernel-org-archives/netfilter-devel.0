Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792879925;
	b=NNHZhBBrV5TKqgqR7xCFUiOZDwRdpL6SKWHqCjrSYF4O8BRbTkXIJHVDJ0G7aCzm0Eqf
	 zkXR3ZpIWu5B1tp5owZU+fl5WePZ+hthYuWU00Fz+KIWOVweZGbWVqXW7fpXFaUvK0Yvg
	 bJIri9qLv3hkIffiIE5Nw9Mk2wFe6RXLTTP/mQaDLkiOUg33ovN+ELNbTt27u3n6oS4+s
	 c7dg0Op+5K+R98uUUlZVGdIOgXhYYyL56Qxf8r4T8MMfAhXN4TcuAcUAE/h4t6n31LFb7
	 eDaZN8CwqWwSScueXHBuH3Md7Q8edAkjIm9y/fmBN7/wieI9KpWUnluDN0onIyqFBog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792879925;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=SQndqOKhsFfIKOISSNh+xDt0cI5Z1P7cUyeb3mATAOU=;
	b=KSqJf/eixgkcqzXdaSqDQKO+FhJyNk0Srdd2yLufSOwjnsoNqatkLI6nvTjzR9V8bo7d
	 9UBcDZcsZDHbN39w9++NiWME7S/GtnhkBJKJZkL6ae/+fQiytkk8DBH+BTKFI8VpfZXBW
	 gi+pZXgjZPPibl4A9lieeO3b+2cjAQCr6jvxcGDa3Lp/ZcweYouF3XxTz3GrLfPyM5Xj2
	 W2gQ4sRd1LN+TyaWhHssVjI0Q7YIVj/SdbBvwJYFNBb66ddZa+Hi28lWyOx7zKnlexiZP
	 HeJ8FQHc/mL8vykBm+CRyvnY8wyZZxgCsh1AI/v28LL3tgNapp/YcvNiM6JC8hZXaag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=AxLEdh8f;
	arc=none smtp.remote-ip=209.85.128.52
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF241606A32E
	for <netfilter-devel@vger.kernel.org>; Sat, 24 Oct 2026 22:12:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AF241606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=AxLEdh8f
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4a20bde60a0so14699315e9.3
        for <netfilter-devel@vger.kernel.org>; Sat, 24 Oct 2026 15:12:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792879923; x=1793484723; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=SQndqOKhsFfIKOISSNh+xDt0cI5Z1P7cUyeb3mATAOU=;
        b=AxLEdh8ffDOhb9ZrAOULe8cikugy5ihhXq5kTe2ygD2xc0/xQ7m8pMpofXswFb2Sjm
         UQoVga+dOOGOba7AR3ti2GOhNS+bOmqJLArRj975OqEwmv9jxBMuE4aNOsaw2RxahN5S
         GUtbo8EvuwtXeRbcBjMa3UOwE27/gqtWFVRU8pRngrDp7uM/dCy6y30AGrgwSJsr4dby
         iWkymt1/qGThTKS7gsl8cHXzP0oQzmNK1JchEL4cY7J7Dz/FiUW22BtCyceGWOmqgpjI
         7ebCN2i7F9zJYTxsxEI6dVzk8TneiPvrfTpfqv1wvt/vFQqH5SLgY3z8kjZs05lFjqUS
         tIHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792879923; x=1793484723;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SQndqOKhsFfIKOISSNh+xDt0cI5Z1P7cUyeb3mATAOU=;
        b=lhQYh6QUzBAyW0PnRXXK+v9pxfO8ZbWv7asD6B2ku+c5axi/F5sk/s5GusltASYclv
         RqgIAf8Qpwu7CqzAmQIIzNBqw30GCPZO+PFRVYGr1nuU4mQNyBxykVrgoB1PilQ4LTRt
         1CWO167X7B1409fNh09kOvaPRE+p6MwpiDrIOOWvN8dBP3/UpQVhaG8C+toYs8au21oi
         fBj/df9cnoarSStkQ598J01f7DXCTzkfze7NzLp7qLZ1X+NCC+G26IAZEPxQ+4h13BwP
         Sz0ccGh2ZJj/Ca2Dhyk0DApzH7EgLZqmxbDdLVqyCWcLpPc9EbrZ0SQkCoX//LkDCUeb
         b21w==
X-Forwarded-Encrypted: i=1; AKwUvBzBBa1e1hNKYVpLzjSCC6DcfhOqzhxdN2CsMR36ScdHXK3jPqIClOK107KpTYvpVfa0bZvre4Y+TCxiA64l2H8=@vger.kernel.org
X-Gm-Message-State: AFq9FYJduyruZiZgVY60VL9aiSqtv0lpRSDURz7+4hlVXx1STD+y7+Tg
	OXybTy51yhUdphA/HTN6mK8M6UC0NZtHzcS/rjohw+u+HovISKJ2X8CH
X-Gm-Gg: AYBFou0W2bapmdgz76RVxUAYM4292jOhEQ8HK+2Ruqd3UaRMfwSECpqR+yIfoaKME0u
	P84QaUdNoN3ckQPoSZcyKKuZfnlLo1khH7bsn57yiMTAOEPBq2bNfq7/df+0TQ7qjV5iuqxRWCK
	koaHJX9Yu8l/9aDSaW1XCN359Aj8Jql30W5YWned5+wLA0D0uD3oX2x6xHd+HINPjEHVuxrZMrj
	6wqJbWjNJmuK47P4UeXKxmiXvgljEN5eQ+MyIuFpLqvFL4/gn1IKvB0sr6CLjVQYJ998/2NXhsv
	Ippmkdj+3kbiYe1kD6tbJOQm/XHl0AXp/2B94nMpPexEdYHcs61GwMyjOG4JAhNcOIuvQ0Qzij/
	CecYvF8J2Cdn/dAznZJ5GXy+ypjeWFPubbNCI6zYTpuYcowVbi6EBrNFvuYC87vd8dDUJtSJu5w
	K1MlE/Ti09mvJsc0HQ9w8RRZtnbtyaeCRgpdPj8IVtsPsZdrEQRzNvsoDQRGLLGkmbwVOHsCfe7
	wfrvaqjFyymy+ztmDwqBlqbWltEWT+qemssStBdqCpGT0avETgaUd2uU5cG36TUl260orbmHwe4
	Qn6Z4NazyeaF3vNRI+vBdTUbnisy27MgyyQk/xH8GJQ5geDQcWiTjcmd1oU81ijCeSgoBcGgQJP
	Q/4L5B3pkbOC1xkmckQJz3gK1bnzHM9BDAc7q3o7hfDiiDv8STOcElhSEAP9AURk4GaZUV8FsJx
	ZhW3tTsA3C1nFBjGIHhGOS
X-Received: by 2002:a05:600c:83c7:b0:4a2:c9b:9b98 with SMTP id 5b1f17b1804b1-4a35ac95f44mr46278555e9.17.1792879922972;
        Sat, 24 Oct 2026 15:12:02 -0700 (PDT)
Received: from saif-MS-7E77.lan ([102.29.255.244])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a35a55e99fsm80531705e9.4.2026.10.24.15.12.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Oct 2026 15:12:02 -0700 (PDT)
From: SaifAllah benMassaoud <saifmassaoudi18@gmail.com>
To: pablo@netfilter.org
Cc: fw@strlen.de,
	fmancera@suse.de,
	netfilter-devel@vger.kernel.org,
	SaifAllah benMassaoud <saifmassaoudi18@gmail.com>
Subject: [PATCH nf-next v3] netfilter: nft_limit: reject configs whose per-packet cost can overflow
Date: Sat, 24 Oct 2026 23:09:28 +0100
Message-ID: <20261024220928.1751040-1-saifmassaoudi18@gmail.com>
X-Mailer: git-send-email 2.53.0
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

Byte-rate limits using long time units (e.g. bytes/week) can overflow
priv->nsecs * skb->len in the packet-path cost calculation, silently
defeating the configured rate limit.

Reject such configurations at rule-add time instead, using the GRO
maximum packet size as a conservative bound on skb length for the
multiplication check.

Fixes: d2168e849ebf ("netfilter: nft_limit: add per-byte limiting")
Signed-off-by: SaifAllah benMassaoud <saifmassaoudi18@gmail.com>
---
 net/netfilter/nft_limit.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/netfilter/nft_limit.c b/net/netfilter/nft_limit.c
index 167d99b1447f..07dc5c55b0a0 100644
--- a/net/netfilter/nft_limit.c
+++ b/net/netfilter/nft_limit.c
@@ -13,6 +13,7 @@
 #include <linux/netfilter.h>
 #include <linux/netfilter/nf_tables.h>
 #include <net/netfilter/nf_tables.h>
+#include <linux/netdevice.h>
 
 struct nft_limit {
 	spinlock_t	lock;
@@ -73,6 +74,9 @@ static int nft_limit_init(struct nft_limit_priv *priv,
 	if (check_mul_overflow(unit, NSEC_PER_SEC, &priv->nsecs))
 		return -EOVERFLOW;
 
+	if (!pkts && priv->nsecs > U64_MAX / GRO_MAX_SIZE)
+		return -EOVERFLOW;
+
 	if (tb[NFTA_LIMIT_BURST])
 		priv->burst = ntohl(nla_get_be32(tb[NFTA_LIMIT_BURST]));
 

base-commit: 734bef548a96e8774d6eef5dfa2026c6edc4e80b
-- 
2.53.0

