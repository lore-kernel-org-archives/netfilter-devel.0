Received: from mail-pl1-f226.google.com (mail-pl1-f226.google.com [209.85.214.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A5182882A1
	for <netfilter-devel@vger.kernel.org>; Thu,  5 Feb 2026 07:46:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770277603; cv=none; b=ErZJ1MHoT5ahzMdvXeQkTNQC29GioWG9fMq6GL5aX3ZcTjCl2e9Qn+nwB4EH0fVojH1OmONMYL6MOwkpcOdBFqMkHLLuR1qZWIM6U/es/QxRsHXwfZk4oMtZanJuJo6u48f3eZvyU+llFI4E1Xx0nXYMf0J66fBxDd6uDk+9Tgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770277603; c=relaxed/simple;
	bh=BZAm3zfS+K8re01D7iQcVFbiBjsf6a3DLCN+hVqBjSU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ojTC+Rvf6Q9B0WtfbmdRlfgfICvVG5y4TV1docYdvuFiO5acHGJuxjr6uE/YSWxvucqFQC7v8zU+xMoq2r4xIkVb3yqyatASxgo4rMCT+gQe/lrjsRhdj3KT3qutj0o0tmcSo+sYi4mGM/+FidbCrYqapiEqj1br0S6M9ZjXh0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=g6VclQ92; arc=none smtp.client-ip=209.85.214.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="g6VclQ92"
Received: by mail-pl1-f226.google.com with SMTP id d9443c01a7336-2a9487967a6so189165ad.3
        for <netfilter-devel@vger.kernel.org>; Wed, 04 Feb 2026 23:46:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770277602; x=1770882402;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pSevupTzEHu0sF+WJcXaAghgvNkaKInyzTJ6cRAu8bA=;
        b=lDSXifTR1pONtPR1R5NoWaF54ZLdKXMEe6svNa9C+ZUF1bDHQbItt5KS00p50LbY+V
         o+sUmNryJF5UQkVvuDNckKT1D1zmeqGU/d5MMrIxNrFKj3Cw+on3LXIfk6bgvaHThDz4
         Dn7xFGcPv6nO2toArYoyssx68pkIuJt9N1fDjW141nU7GhLM/twFh2q5SH1J1xqlQKKG
         dJeZbuFNL2Ct0D/SL7gd4urQQrhL0wTNqVMPKutK8xyilwMK967VOXCPBQbhP797inUg
         hAGqnFSRB+aLXE9hNZi8N66jWUtFgQnUvgyb92eRRL5s33cMoRiK+BQQZ2zlbHWFOstE
         e0GQ==
X-Forwarded-Encrypted: i=1; AJvYcCX5Yd6ZstXA+2HK6hjV7Ld2qwrJnlpktwZN8AO4qlF4o/SxUtNsGSI36MMmQGTtcXYsaQOMyQPuOu2EZL+KScE=@vger.kernel.org
X-Gm-Message-State: AOJu0YztjXGNfXMpAOntAT1/INZyCQMhW/dvJ6wm5HHCZzNr2gIxLZ2v
	6obR95LvNU3t4oWWwlqH13/174d1xr31UFMcXzUjZPPkb5uyj9FU9TMrPvV4RLvKhZyOjPYPP17
	hwKtPnl3EvZCVZvLglHO6xb1hzxruEcQDr9ql1tb4nhamdMBfjyhj1aFNkqmS+H8PDa+L8yyY8U
	ZZuiONYA1cZKBcBkTdm1OPlH+LHeK11AyH9Il5AqWeFUmhoNvmlRimWRZbgDU0xOTnolINQjRaI
	cCSw4jytXJXU3voZKXPbLBzLJleYh0CTLuPDSfi
X-Gm-Gg: AZuq6aIH7zeLV1vioDXdMQ6pBMG89QqYCLwtGoKtUcyMHIldueiNLxPJqWV0/Qbef3p
	tEg/21nvEkakye4PDwkKrLGpGzYwwkKZLiLbjl58NvvFgJ22yF687zED0lbwTNr1yhd4YxGEBTC
	A9ycoqRIKksFgivLC+Xd5fQSSXRk3mJbP5pHlTyKFptbDK1jatWvXQhSBjfdX9V+D9i/X6EmA+d
	K4OPaABvaliZ0fjLtYz9FyqkAvD3fMHubXmOY7SCMsn6y3rZ+Mb/oRdKNRmEGHBUIw5e0b9y/35
	RvIJKeJcbVkS3IkrT7FDpK0fDdLIyVRLCKyKyRoGh7ZSbN0jd4TDNEYPv+GOS9X0Rg9RIbLNhcV
	EAAGuRGTZSzmS+IM2Mzos+knGU1p+ZBloGO10K4TWRRVKlEc/KefyV2Pd1uAbIHjufvh6bDKAak
	7Xjb5gOUy3txCHjrFIrQZgiA9c/IQkGBiyL1TBkrSOg32wmkcqkKzpaNBonTE=
X-Received: by 2002:a17:90b:5867:b0:343:653d:318 with SMTP id 98e67ed59e1d1-35486f73314mr4112939a91.0.1770277602533;
        Wed, 04 Feb 2026 23:46:42 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-0.dlp.protect.broadcom.com. [144.49.247.0])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3549c0c47a4sm218882a91.6.2026.02.04.23.46.42
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 Feb 2026 23:46:42 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-dy1-f199.google.com with SMTP id 5a478bee46e88-2b70a6e1e28so17888eec.2
        for <netfilter-devel@vger.kernel.org>; Wed, 04 Feb 2026 23:46:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1770277601; x=1770882401; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=pSevupTzEHu0sF+WJcXaAghgvNkaKInyzTJ6cRAu8bA=;
        b=g6VclQ920khstvNzbqEsq35iaC7EMJ3prUBNYO69sVFticXEKV3Pf2da901GF5qFjB
         kLeb/fwjwsfc/oqpm4s2XWGXkD9mZ8aA9sGqFy02VvSMdGr9d+mLXr9oQlz8XegsGYZC
         wm6G6tVXOjZmUGzDbnEARPOjnF4CDLO70RVQU=
X-Forwarded-Encrypted: i=1; AJvYcCW8tt9Ubswzww7AVy7501ASMwTcVKfXYYTkm3kH8CTcC+EYJxjfkUKHXofy33SsFlZxN7cyRQCLcMkqUf8OOhU=@vger.kernel.org
X-Received: by 2002:a05:7300:c29:b0:2b7:b88d:b75d with SMTP id 5a478bee46e88-2b832743f4dmr1306043eec.0.1770277600548;
        Wed, 04 Feb 2026 23:46:40 -0800 (PST)
X-Received: by 2002:a05:7300:c29:b0:2b7:b88d:b75d with SMTP id 5a478bee46e88-2b832743f4dmr1306025eec.0.1770277599982;
        Wed, 04 Feb 2026 23:46:39 -0800 (PST)
Received: from keerthanak-ph5-dev.. ([192.19.161.250])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-126f503ecf4sm3840166c88.15.2026.02.04.23.46.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Feb 2026 23:46:39 -0800 (PST)
From: Keerthana K <keerthana.kalyanasundaram@broadcom.com>
To: stable@vger.kernel.org,
	gregkh@linuxfoundation.org
Cc: pablo@netfilter.org,
	kadlec@netfilter.org,
	fw@strlen.de,
	davem@davemloft.net,
	kuba@kernel.org,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	ajay.kaher@broadcom.com,
	alexey.makhalov@broadcom.com,
	vamsi-krishna.brahmajosyula@broadcom.com,
	yin.ding@broadcom.com,
	tapas.kundu@broadcom.com,
	Stefano Brivio <sbrivio@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	Keerthana K <keerthana.kalyanasundaram@broadcom.com>
Subject: [PATCH v5.10-v6.6 ] netfilter: nft_set_pipapo: clamp maximum map bucket size to INT_MAX
Date: Thu,  5 Feb 2026 07:42:29 +0000
Message-ID: <20260205074229.2091135-1-keerthana.kalyanasundaram@broadcom.com>
X-Mailer: git-send-email 2.43.7
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit b85e3367a5716ed3662a4fe266525190d2af76df ]

Otherwise, it is possible to hit WARN_ON_ONCE in __kvmalloc_node_noprof()
when resizing hashtable because __GFP_NOWARN is unset.

Similar to:

  b541ba7d1f5a ("netfilter: conntrack: clamp maximum hashtable size to INT_MAX")

Reviewed-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
[ Keerthana: Handle freeing new_lt ]
Signed-off-by: Keerthana K <keerthana.kalyanasundaram@broadcom.com>
---
 net/netfilter/nft_set_pipapo.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index 6813ff660b72..484ca8cf2e80 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -665,6 +665,11 @@ static int pipapo_resize(struct nft_pipapo_field *f, int old_rules, int rules)
 	}
 
 mt:
+	if (rules > (INT_MAX / sizeof(*new_mt))) {
+		kvfree(new_lt);
+		return -ENOMEM;
+	}
+
 	new_mt = kvmalloc(rules * sizeof(*new_mt), GFP_KERNEL);
 	if (!new_mt) {
 		kvfree(new_lt);
@@ -1358,6 +1361,9 @@ static struct nft_pipapo_match *pipapo_clone(struct nft_pipapo_match *old)
 		       src->bsize * sizeof(*dst->lt) *
 		       src->groups * NFT_PIPAPO_BUCKETS(src->bb));
 
+		if (src->rules > (INT_MAX / sizeof(*src->mt)))
+			goto out_mt;
+
 		dst->mt = kvmalloc(src->rules * sizeof(*src->mt), GFP_KERNEL);
 		if (!dst->mt)
 			goto out_mt;
-- 
2.43.7

