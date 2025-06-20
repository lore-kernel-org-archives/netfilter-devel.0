Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A50E1E2607;
	Fri, 20 Jun 2025 09:21:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750411268; cv=none; b=Sxwzxu6h2ySG4os8rM56MU8hNSzIt0htTId0XEEdoe3bIWGaEWJlUO+uXUc6yXaBVxUrJZ1JU214lokgivF0SyN7NI49dU0aoxfa2poIiZVRkvVM3A4zZuGJ8NcChTh/kFhY0Z3zoO0qSduGp5rvO7rnMy2m8R6Zq5jBniVum60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750411268; c=relaxed/simple;
	bh=SJHQLC1eKMZEuzpk6u6D1TsLqXdJUkG3iE+wUgLFr6A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YtI2oEQaSV7NHLKVRgsqBo7aNJQU0+Q/2FKlvBHI9P/ANA4U5wm1gXYvX0545GR9rZ0VDU0HuxCzQJ77oH2NIRZEx+eDxsizvl72cDldUIcrkBTLj2ihu6GrAvJD0Zrl8HBd+/4qXP0CnbDPAmDY1AXEONdk6a3aBQlu14xtwf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZZXKuors; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZZXKuors"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-45348bff79fso18483805e9.2;
        Fri, 20 Jun 2025 02:21:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750411265; x=1751016065; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9cgL5PeqdGLu0lhfa4303QYfoHbGcsA6Evash3JXswM=;
        b=ZZXKuorsSNQqzCYmOpvMbNJ8gbrKtHuEAvvi19mDTRf1ectUPr2F0r7fpGzb/oKVAc
         bTv55kravICIk/GANoaNZAR5wCIBw6rkF6ehb7T33V9oIFXTeOEYxlgk2xQVS788NnTC
         b09+ib5hwvhxoWZO+4UTQN86Nazf4U20Y/qRw3c1bI7AaKEmopdRMiHzbnv3dbjEyaXt
         NIiAW3rAg1V/tPdJuaIsLZRYpxHvLI+wpFE0k1DYuZ11ge3/7rhdasZTyjfOb0o29tA/
         uMJETddUrrOAgc18t8mkA+E16k+A9y19oQDLZH434D51s0myIW/GIbfJ7etU0RhsqdR+
         ohMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750411265; x=1751016065;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9cgL5PeqdGLu0lhfa4303QYfoHbGcsA6Evash3JXswM=;
        b=F3Q41qlrW/JlKs3Q02KLC47hmwMv1kb82F2ZA1O5uHGccCU1g5WdFkR1IEGhJZH+nO
         21MwM/c1CYRtUh2U6EscWzsuC7USR+0/io7rX37vjSMAEiwNFA7h2jbEVBxHmj/+ogOH
         EM5QxbQS8kBMaodX5/tFUdP9QXON8ALAPdvf9AVvVR7STq0S77hRbgBhUX/w+rOMc/hF
         ZqbO690B7IDTFQtnKM953Qh5hq6l/Vhg0lGcNeOL5ZiGJeA5oL3VXxeRq9GsDcV6Zwjx
         LUhQbQQA7wlkAZtJmZfTEzGdEGu760eYg5FyZb0uXI9lDhu1BCgJf6JyXecCigcjoxgr
         6SAw==
X-Forwarded-Encrypted: i=1; AJvYcCUCAxA6MXGRBTb7AvljBSwvYEykkIB0Wh2WUOkX3Eo3x9WypzL1fU7MjjKVrbUYGwUe/+NeFX+oa17R9Sa6es8c@vger.kernel.org, AJvYcCXFTxRLdH+7hpPM4jMP6rnQv5xyYYZPEE+l2YnqkcaAl/R+PBtN5Ihv40ULMSCt6/wqzw4n1E7N8PfLWNs=@vger.kernel.org, AJvYcCXoaXK8hr/N3NK9WlPhlgq2FPEpII7jERLzEElewlgWOozAimaX7meW/gIt84GWmxORoKx8kEZw@vger.kernel.org
X-Gm-Message-State: AOJu0YwD9j52tCwt8xWa5usl/G4kaO1s5Hk1mLbWbXFt29XwZW2SklF1
	btHaN8IrDwOfnt9su/O9PbYOUe1HqfOqiIaJYp9jAT4QBy5mUwjPQKK1
X-Gm-Gg: ASbGnctR0vUkY/iXXDj9zXOAHIGbJsCSEdA9R/15f9g+TL0EPRTmaiFROdkw2N4Ngpt
	zLkVZK5rqyqF9ahytfe3VIfkCYyxcfHyQMazGkMTmGduOo7oR3SAloRTnsjlC7aWITbonHfNSgy
	3S3e/0l85QV5bCvZTJdMVPJ+L+G0vpbpo2FCCEO6dRshoaTeWmz78Wh3oaTZgCt7uvkH0P9vhvC
	lFY17SkOMVBUgMitnsGK5aFG/3Wg1wThJs83fw5wLN+BIEQSptJ/Q43z2GW+MDKbk/5/KljcuHy
	yq21QdSNb29I61crALAY1mBKRWB3L3NrLSXK63N9JHZdMtdKFnVjE9I87brOo0pkerabRGyAAzt
	now5RnP0=
X-Google-Smtp-Source: AGHT+IG43zWGtn9uFfkv4FevdfYfDhQ+fjbZ2m39/GB8AGJj7THZEDuxdos2Ezv1hYXLiqGA9o3oUQ==
X-Received: by 2002:a05:600c:b86:b0:441:b076:fce8 with SMTP id 5b1f17b1804b1-453659c0bb9mr20372295e9.14.1750411264449;
        Fri, 20 Jun 2025 02:21:04 -0700 (PDT)
Received: from localhost.localdomain ([2a02:3031:2e0:6513:b62f:12bd:a2f9:30a4])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4535ead2a27sm51858675e9.31.2025.06.20.02.21.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Jun 2025 02:21:04 -0700 (PDT)
From: RubenKelevra <rubenkelevra@gmail.com>
To: Jozsef Kadlecsik <kadlec@netfilter.org>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	RubenKelevra <rubenkelevra@gmail.com>
Subject: [PATCH] netfilter: ipset: fix typo in hash size macro
Date: Fri, 20 Jun 2025 11:20:53 +0200
Message-ID: <20250620092053.180550-1-rubenkelevra@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250619151029.97870-1-rubenkelevra@gmail.com>
References: <20250619151029.97870-1-rubenkelevra@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Rename IPSET_MIMINAL_HASHSIZE → IPSET_MINIMAL_HASHSIZE in
ip_set_hash_gen.h, matching the header typo-fix.

Signed-off-by: RubenKelevra <rubenkelevra@gmail.com>
---
 include/linux/netfilter/ipset/ip_set_hash.h | 2 +-
 net/netfilter/ipset/ip_set_hash_gen.h       | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/netfilter/ipset/ip_set_hash.h b/include/linux/netfilter/ipset/ip_set_hash.h
index 838abab672af1..56e883661f857 100644
--- a/include/linux/netfilter/ipset/ip_set_hash.h
+++ b/include/linux/netfilter/ipset/ip_set_hash.h
@@ -6,7 +6,7 @@
 
 
 #define IPSET_DEFAULT_HASHSIZE		1024
-#define IPSET_MIMINAL_HASHSIZE		64
+#define IPSET_MINIMAL_HASHSIZE		64
 #define IPSET_DEFAULT_MAXELEM		65536
 #define IPSET_DEFAULT_PROBES		4
 #define IPSET_DEFAULT_RESIZE		100
diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index 5251524b96afa..785d109645fed 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -1543,8 +1543,8 @@ IPSET_TOKEN(HTYPE, _create)(struct net *net, struct ip_set *set,
 
 	if (tb[IPSET_ATTR_HASHSIZE]) {
 		hashsize = ip_set_get_h32(tb[IPSET_ATTR_HASHSIZE]);
-		if (hashsize < IPSET_MIMINAL_HASHSIZE)
-			hashsize = IPSET_MIMINAL_HASHSIZE;
+		if (hashsize < IPSET_MINIMAL_HASHSIZE)
+			hashsize = IPSET_MINIMAL_HASHSIZE;
 	}
 
 	if (tb[IPSET_ATTR_MAXELEM])
-- 
2.49.0

