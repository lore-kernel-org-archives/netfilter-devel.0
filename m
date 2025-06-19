Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8DDC221F2E;
	Thu, 19 Jun 2025 15:10:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750345844; cv=none; b=pnl1iaJGmgfx4pQ1RbI6ZY51Ul/sGKbhR0ToSaT/UwWw8R3Z4KkEEGM1hVg0vFQbU/SIziYWLp0RneSz9exmqL9MIAQBlE+/zJRKydLANhp5jtGKF9LQ4Q6IwkVDEJIq+hfeLywYse3rO2y3tvffElV4D4NkG+ed8F1qGB23Dzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750345844; c=relaxed/simple;
	bh=B74LrRGlLhzrhEeUh2OsbsLoPumLrvMHAq2rt+UQCKk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ecoL0c7DMf2QXcVMlf20+YVM86we2CvSB5y+dAkhrqb1Yn5kFOBO7Flwx0eVWwuCHkti/k/l/bKEq/d3FD1AUfOO19q6FZvNr5R7hqx77B1SBCys7vBVtoGSEW7vbL21jG0IpDkmQ3JLKtyKPDWP8nYfmgBL4vFwQ1/CRgLgJpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Qxg9sxe0; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Qxg9sxe0"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-453066fad06so5376675e9.2;
        Thu, 19 Jun 2025 08:10:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750345841; x=1750950641; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=/hSHqs5fcKnaUgEXTAM5nAdgObO19reWq7vJCpIQ8s0=;
        b=Qxg9sxe0oA/pzDaGkot5IIJOuttVfcvoEAT/2ZH6ugI25h5ebg8W2r6BIszHc7Vot2
         StRWTSmg8239NsDPhTkkCGp//EQkfE4TwutwGnFmRgiZomteurprFQPTyXULferaJLqM
         0DRpcxFPeIFzgzpmuukZw2+sXADjyKBahODWRVkL4HKrP9moQKi6xRm1BwjKZMKX+ZOD
         hqjwOXKd6veElsV65B5ybyyGqFsZqYoVLzyzKtKJXr8DIhq7TGqWnvXvLgQ8hn9X1Dhq
         oHduP7sSUvoEqlAl2/xKzb/5SjhGpnO/+k5ESk69OZpYlT80PWwN3l24H0aysqzJa/29
         4ZfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750345841; x=1750950641;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/hSHqs5fcKnaUgEXTAM5nAdgObO19reWq7vJCpIQ8s0=;
        b=o808rRaXGlg/aUC9XmguZ4d+qWiCQTdG3hWq/AffNE9JgEDhapj3sh2qjAify7JzkJ
         faxHGOl07a+UoUE5Y6Z9Vo/vA0Y/993zPVLCaFxETQkUYlH70lNFbvzeU8LrZmKxo+b6
         ygDNA6JRlYmOd7Wowrg0FaSg3shyzWaek0sPIdNXBJhAQmA8X3Hc4I0oeKILBHWTnxYD
         oXF6n2XTHV8N2ShM3zsHA7O0rurJ+TlpN9YHS5tPVV8QMQ25RDsB3zKvuMZ263npy5dO
         BnsSPj5dh5EbA+oi5wobjlhRfZTVorANGtKtzII12TrVAgK2lXOdlGAvXqiklPCj0m0G
         bhrw==
X-Forwarded-Encrypted: i=1; AJvYcCVngL4xqCrOVg6W/a7vFGp9zwkbZBP82zqcSPulG9bMgBMByAuKH1K/Mtol1o1DTakWf+snPhGi/R4xYvw=@vger.kernel.org, AJvYcCWkTp9Enoi7Du9nmEC9RPji56UAcn2DdbB0YAnfNlpNsxJFpKnTwIskHBBfgX0c8UOGJCRhEkAANt7vNporFajl@vger.kernel.org, AJvYcCXj7Z+ECQ9AAGRO42lC6kOQugbA0voOoczHLF3aI2aV4yKxJPp0/HIGnagDD5gEJZlGt//oWH+5@vger.kernel.org
X-Gm-Message-State: AOJu0YxG3IotPoVU2mvtfsCGM9u3lOfvklbLSMDwIFMWQ91ysWX8dCQW
	x4Npev3U62iKYp0RF7X0V1PoOPrm6lmqdCV7usWZJy14TCb9saBEKao5
X-Gm-Gg: ASbGnct5wu9P7lQ0NG6TnLcVZnPu936lCcaOabjwk98jJPdKXIUXjwSAIF/IZPcw1Ug
	UhDu8WFRXCLCPsXoyYT5HYeTXdNdX1YuAbciQjirzminW2oz89g1O7OwNgo4N63hWFQFjjkg4pV
	CyM4ExXvookxAM64aG9zrjUQl0EffjObdHp5k7aXrZ/FXngtY5yKc5ZZd1W7KEkUtYIWIfLCLUg
	/W8i/+jqQhYsQMxNFTRTye5E8erSFVbzhtYpcLMDvZAA2lAYthOkKA3QEP37vtXiNUeQOew4G58
	QedGudXa4MyloIVDu4WPKANBg9b9zVYJv6fVB/mtGYG65xU12miPUZW3vWFVaIGMEiafP56hgUd
	i9RqXDgQ=
X-Google-Smtp-Source: AGHT+IGdagjf/6LCFK66aYCxpNQN0eFH+HGfQHm2cU/tlv4vEAzRmdtpCaQ0XggqybQ/nKuvrjTGBg==
X-Received: by 2002:a5d:64c6:0:b0:3a3:7bad:29cb with SMTP id ffacd0b85a97d-3a572e5637dmr18567695f8f.52.1750345840897;
        Thu, 19 Jun 2025 08:10:40 -0700 (PDT)
Received: from localhost.localdomain ([2a02:3038:2e0:482b:12dd:18a3:32be:7855])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45360b1ffacsm16979065e9.36.2025.06.19.08.10.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Jun 2025 08:10:40 -0700 (PDT)
From: RubenKelevra <rubenkelevra@gmail.com>
To: Jozsef Kadlecsik <kadlec@netfilter.org>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	RubenKelevra <rubenkelevra@gmail.com>
Subject: [PATCH] netfilter: ipset: fix typo in hash size macro
Date: Thu, 19 Jun 2025 17:10:29 +0200
Message-ID: <20250619151029.97870-1-rubenkelevra@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Rename IPSET_MIMINAL_HASHSIZE → IPSET_MINIMAL_HASHSIZE in
ip_set_hash_gen.h, matching the header typo-fix. Keep a backward-
compat alias in the header for out-of-tree users.

Signed-off-by: RubenKelevra <rubenkelevra@gmail.com>
---
 include/linux/netfilter/ipset/ip_set_hash.h | 4 +++-
 net/netfilter/ipset/ip_set_hash_gen.h       | 4 ++--
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/include/linux/netfilter/ipset/ip_set_hash.h b/include/linux/netfilter/ipset/ip_set_hash.h
index 838abab672af1..4f7ce4eff5815 100644
--- a/include/linux/netfilter/ipset/ip_set_hash.h
+++ b/include/linux/netfilter/ipset/ip_set_hash.h
@@ -6,7 +6,9 @@
 
 
 #define IPSET_DEFAULT_HASHSIZE		1024
-#define IPSET_MIMINAL_HASHSIZE		64
+#define IPSET_MINIMAL_HASHSIZE		64
+/* Legacy alias for the old typo – keep until v6.1 LTS (EOL: 2027-12-31) */
+#define IPSET_MIMINAL_HASHSIZE		IPSET_MINIMAL_HASHSIZE
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

