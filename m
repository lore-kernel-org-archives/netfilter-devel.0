Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57B52271450;
	Mon, 18 Aug 2025 15:40:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755531638; cv=none; b=Rzj42LTD4oHoojIhynSp6g3/sHOHkvl1MCxkP3GuJcQpEMbVLd1sNHh8SrnIT+HHGCmqAhOkMwE1ZM9zIQx3QMOhHks0FqxdKe9SR4NGwl/DefT1b57NZgVSukJbXSXouIQjTg65VmTCrWO7pCZXW239deCs/RIaIYF7sWNWStM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755531638; c=relaxed/simple;
	bh=I1peXe3qUgkdzuAIkR3hXhA4fkcFMtLuLZeroJqdEKg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SYiUKMne89aUqu6EwkOxfKHMywENgxNzSX0EthwgXvI7pYA8Mw8WMqJGF2ZPVPG4JE1vm0u1wRlHa5z7plMvJpR2S56T054YHKgI+5twSibheT9K0FOT4lpWMU0iert/vYqJvaOrbxC71/7bysNxUfYyILwM8e4Fi+1wjpYYWqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fomichev.me; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fomichev.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-24458195495so26646585ad.2;
        Mon, 18 Aug 2025 08:40:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755531635; x=1756136435;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NChDRszGwZKbjvVPRDVNu5XZAg/1N+wVz9IydPSYRlA=;
        b=nZxi7d+Ma9t2z0EkGn2+HtO1fI03Y1wR/0+11DTaTAUJ60062PYeXnAHH7juKa1lAp
         gIqNaXa4CzKrkxIGsLWdKtJXkAf64++HgA9oun1iAZgB9ZpPtlhgPTJJh6XX2AP0w+Zq
         PXOwUFIlYVW8NY+q1/OFx5sUussIjf7aHa1HrPb6vTmNUrgoDc+n8jX0NAuhS2eLAhDi
         JTuXGVRyEs70b17kxgOd2BI4MHTq1XeUrI9Jg6ZFt3srLzYRG3UJ4lKT3VVz+BNc1aXa
         VwIZH8tNkHU/zHMIisS04Pw3o+5EXxzQUeFJVGzHntasjnovSZNX9qfZ4eARpEJcpg3w
         BEtg==
X-Forwarded-Encrypted: i=1; AJvYcCUil2I+2zWUoFkyVAPQSHF8fD5030tA0qt2TCcoc3b2msnPjB7hkAOIcK2u/Qwi41CDI0uQ7TSIQ1AozII=@vger.kernel.org, AJvYcCUmHPjkWli/mgD9tKkVoyP4D3kqrr2CA3yI0LBx8uUiSLq3vePzzWxBCzv/yH7JEQqlMp83C37BTQo5Rcp3+d2s@vger.kernel.org
X-Gm-Message-State: AOJu0Yz48bkEaG84ozRK9rGgFdVjchIEBds6wtWjHI5lY/mA/QLKGTSb
	F452fWY5zEfgdy9NB2bZsrrp4lGVrxxLHKcj7ejO6JfdAKSE3wWQmPGgdEB/
X-Gm-Gg: ASbGnctoqQYQHI72NKJILANLLbiOcqB2iuSUVQw26WJ40Om2OiP5Fc3359A1igVe3ND
	8rLY1PLNMurFL2HOjV3khITBDccvlaNpwBKk8wP8nwpr0tgnxgfmhVGn8xGFXmcl/XUMulYQrm8
	aPyh9EIg+cH7ZaMMrU2zwGu5by1AvRjlAI2UPdyXc1T/QQHtKJ5nS+L9F8qtYqGXmniRVjDYHBm
	Ci3dZqUMGcMYU5w5u7DosVFdx81GvWP1fq5YdtXRHIpRMAcorb/OCk8lu76kUGpbTTeA+pp7gwr
	EO30b26Du0e/ILu6qx9rNNsrGvRoTvGRV63HTgMK4yuI9sycHSP+6tPGcdDVOy+PbIWfSM+pkaO
	3uldMStdXuJUBfPd+XHbOx1jZV68f3/pp8f8yATX1nfGOCrl0DHkOCYhg6onoBDa5FR/ISw==
X-Google-Smtp-Source: AGHT+IEESYdvHRoTRRGZrgyh2K1XOh5rovsTZVhdWVRfTeUiYce7Ghr02VcC+TxaQGwyNNdk27cEjw==
X-Received: by 2002:a17:902:e848:b0:240:86b2:aecf with SMTP id d9443c01a7336-24478e11024mr143045015ad.12.1755531635368;
        Mon, 18 Aug 2025 08:40:35 -0700 (PDT)
Received: from localhost (c-73-158-218-242.hsd1.ca.comcast.net. [73.158.218.242])
        by smtp.gmail.com with UTF8SMTPSA id d9443c01a7336-2446caa3e5bsm84101975ad.33.2025.08.18.08.40.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Aug 2025 08:40:35 -0700 (PDT)
From: Stanislav Fomichev <sdf@fomichev.me>
To: netdev@vger.kernel.org
Cc: davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	ayush.sawal@chelsio.com,
	andrew+netdev@lunn.ch,
	gregkh@linuxfoundation.org,
	horms@kernel.org,
	dsahern@kernel.org,
	pablo@netfilter.org,
	kadlec@netfilter.org,
	fw@strlen.de,
	steffen.klassert@secunet.com,
	sdf@fomichev.me,
	mhal@rbox.co,
	abhishektamboli9@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-staging@lists.linux.dev,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	herbert@gondor.apana.org.au
Subject: [PATCH net-next v2 2/7] xfrm: Switch to skb_dstref_steal to clear dst_entry
Date: Mon, 18 Aug 2025 08:40:27 -0700
Message-ID: <20250818154032.3173645-3-sdf@fomichev.me>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818154032.3173645-1-sdf@fomichev.me>
References: <20250818154032.3173645-1-sdf@fomichev.me>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Going forward skb_dst_set will assert that skb dst_entry
is empty during skb_dst_set. skb_dstref_steal is added to reset
existing entry without doing refcnt. Switch to skb_dstref_steal
in __xfrm_route_forward and add a comment on why it's safe
to skip skb_dstref_restore.

Signed-off-by: Stanislav Fomichev <sdf@fomichev.me>
---
 net/xfrm/xfrm_policy.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index c5035a9bc3bb..7111184eef59 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -3881,12 +3881,18 @@ int __xfrm_route_forward(struct sk_buff *skb, unsigned short family)
 	}
 
 	skb_dst_force(skb);
-	if (!skb_dst(skb)) {
+	dst = skb_dst(skb);
+	if (!dst) {
 		XFRM_INC_STATS(net, LINUX_MIB_XFRMFWDHDRERROR);
 		return 0;
 	}
 
-	dst = xfrm_lookup(net, skb_dst(skb), &fl, NULL, XFRM_LOOKUP_QUEUE);
+	/* ignore return value from skb_dstref_steal, xfrm_lookup takes
+	 * care of dropping the refcnt if needed.
+	 */
+	skb_dstref_steal(skb);
+
+	dst = xfrm_lookup(net, dst, &fl, NULL, XFRM_LOOKUP_QUEUE);
 	if (IS_ERR(dst)) {
 		res = 0;
 		dst = NULL;
-- 
2.50.1

