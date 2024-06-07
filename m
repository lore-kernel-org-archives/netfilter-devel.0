Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1DCA155738
	for <netfilter-devel@vger.kernel.org>; Fri,  7 Jun 2024 21:41:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717796480; cv=none; b=jSOjrOXLXyoD/Rxn9U9Cm9B9JJoL8yORE1zPExoIdaAUbSweXQjmk2SolSzIIZMNqUZjT+5aYR1D2xxQPFJLP+a5D8EXWvjrLaR+TxStIHNcwSWSIwrOn9wZat+IAp3KGaF8nN422l17hGsMaYMmK2ZQqR6WUE4QDqXlDn9WSLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717796480; c=relaxed/simple;
	bh=+zDHm0gqEYnNElTfpQqNXDS5sE+4HW2XfxQCpQQCbSE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=pyQHtQf02d7HCLiK9d7994oV2xRtwK1dOu5UMmT4AwVERee3vBEfBKeAIUVWkY2NRQ142MbLwCQrYICtx8cslcmOkObl1mNrg+j33WYymt1Zv837JVwbUGnKP/fiBKyw2LmZ5QZ6lgMwDAhlXlvTL4HFWCXc2Mx0BFMUGsRAHU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=Z9DKg3SF; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Z9DKg3SF"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-1f47f07acd3so24557215ad.0
        for <netfilter-devel@vger.kernel.org>; Fri, 07 Jun 2024 14:41:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1717796478; x=1718401278; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M6hr5Pgg5LYV8IvTkAUUqijfPi8ple/giWX7dtweBwU=;
        b=Z9DKg3SFZv5D/L1UQYIGoZFTmyjArQ+DavEzSWG/A77KkhIYYrzIKCXeChJFXL3HrI
         q0ocBiSI0p7j7VheYjrOKzdy91QRGaZSsGsZF+6Pa05N38HKd1k0NA6l+2MyX5ehLhhh
         uxYxtc/y64gC8zpMQUhC7YDDSQhWokBTiKfsA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717796478; x=1718401278;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=M6hr5Pgg5LYV8IvTkAUUqijfPi8ple/giWX7dtweBwU=;
        b=EQwFuySRLeZIUM+ioPX3bHP1pn2+YOS3vWCsUUvrcAa6W9yRwhh+1AgwscRAnpQ4bp
         7TTnwYvlnLbtaLIyjI4FdnjLq5qOtX4HATD8Idl+ubNZqq/q5ThO0keeZYVYTg6RbFKN
         yrKkIqSNCryYLAKdNti81FYqMQvTCmMGv9gpKa1R7EWN+v04H5rf84Ks5SPkMyO92mvL
         mbgbkdvVpIJsVdn/W7AhbCbT90dslyDiAqPN3+idqT9E5B497rtpqWvaMYmm7vSgTqFh
         w51xXyab16W57+LeB4H7gnfWO/9wDtzv43TmcWop14rsju0/KtdY7TZtxTXuY4IvVvP5
         l+kw==
X-Forwarded-Encrypted: i=1; AJvYcCWEYQyHepPd6OUjojJJoz0C/VXb60yllkroivl4YMzASiR183v6L8oMRJjxbikEnwLccGcLF6wjerXidMJ1344/2aB0N13c+7+br0p9N1aH
X-Gm-Message-State: AOJu0YxnFi3FOFFoYj9Ej7FIefa39u2S9XFvpgAABhmJzzw4tdBUH7rn
	yHEtZUh8kUUxifhA0VouCTTtU6kji5sSnt/9TDCZOT/1eR9QWPJXIVjnUYyALA==
X-Google-Smtp-Source: AGHT+IGiZCcvwDTTBj7Ig57bQR4C0/0ASjRxvCbyRtjYCP4HgXPQ023nqZONfn0Hr6ef/ygn+LzbUg==
X-Received: by 2002:a17:902:c94f:b0:1f6:8a19:4562 with SMTP id d9443c01a7336-1f6dfc426d6mr27231345ad.24.1717796478156;
        Fri, 07 Jun 2024 14:41:18 -0700 (PDT)
Received: from ubuntu-vm.dhcp.broadcom.net ([192.19.161.250])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f6bd7e189fsm38946805ad.215.2024.06.07.14.41.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Jun 2024 14:41:17 -0700 (PDT)
From: Kuntal Nayak <kuntal.nayak@broadcom.com>
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
	vasavi.sirnapalli@broadcom.com,
	Ziyang Xuan <william.xuanziyang@huawei.com>,
	Kuntal Nayak <kuntal.nayak@broadcom.com>
Subject: [PATCH 2/2 v5.10] netfilter: nf_tables: Fix potential data-race in __nft_obj_type_get()
Date: Fri,  7 Jun 2024 14:37:35 -0700
Message-Id: <20240607213735.46127-2-kuntal.nayak@broadcom.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240607213735.46127-1-kuntal.nayak@broadcom.com>
References: <20240607213735.46127-1-kuntal.nayak@broadcom.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Ziyang Xuan <william.xuanziyang@huawei.com>

[ upstream commit d78d867dcea69c328db30df665be5be7d0148484 ]

nft_unregister_obj() can concurrent with __nft_obj_type_get(),
and there is not any protection when iterate over nf_tables_objects
list in __nft_obj_type_get(). Therefore, there is potential data-race
of nf_tables_objects list entry.

Use list_for_each_entry_rcu() to iterate over nf_tables_objects
list in __nft_obj_type_get(), and use rcu_read_lock() in the caller
nft_obj_type_get() to protect the entire type query process.

Fixes: e50092404c1b ("netfilter: nf_tables: add stateful objects")
Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Kuntal Nayak <kuntal.nayak@broadcom.com>
---
 net/netfilter/nf_tables_api.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index de56f25dc..f3cb5c920 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6238,7 +6238,7 @@ static const struct nft_object_type *__nft_obj_type_get(u32 objtype, u8 family)
 {
 	const struct nft_object_type *type;
 
-	list_for_each_entry(type, &nf_tables_objects, list) {
+	list_for_each_entry_rcu(type, &nf_tables_objects, list) {
 		if (type->family != NFPROTO_UNSPEC &&
 		    type->family != family)
 			continue;
@@ -6254,9 +6254,13 @@ nft_obj_type_get(struct net *net, u32 objtype, u8 family)
 {
 	const struct nft_object_type *type;
 
+	rcu_read_lock();
 	type = __nft_obj_type_get(objtype, family);
-	if (type != NULL && try_module_get(type->owner))
+	if (type != NULL && try_module_get(type->owner)) {
+		rcu_read_unlock();
 		return type;
+	}
+	rcu_read_unlock();
 
 	lockdep_nfnl_nft_mutex_not_held();
 #ifdef CONFIG_MODULES
-- 
2.39.3

