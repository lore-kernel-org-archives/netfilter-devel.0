Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9DD1200B82;
	Wed, 13 Nov 2024 13:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731502944; cv=none; b=Oip9FlSNH5nViRZPF8bg5JsmFXB55GrBVodApeCYywV2YntJjtlPFuRBL7UgKr58S03uudIpqWoOoXNZ6dfQ64RwqdvQ9J9qmliYyER/Thtg5/J7sXf+8BSbUUgGFhrwgZckIlmgAEPvgY90QMBTj7pwywHGwkZGuCaIS4TcEzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731502944; c=relaxed/simple;
	bh=HE2f+Wis+LO+3GqCujUAT+1t51bvMsaOleQBQosi4fw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=I/W06TrkCS4OHQwq57DzbkVU8d5n3l4RURrKmkMR/dPEfJkS1kHi3swDxMuqbwdhxYwau9VRKuUErMF+NWRhVidWGsXhKzPbv8ALr8dPmXhMblWvPxT60JSvhhob8fSQg58MAwTBl30DwLYsOP79XYRKyYyBJ+SNwGKVg3qPdok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gGkyaGIv; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gGkyaGIv"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-20cb7139d9dso64963105ad.1;
        Wed, 13 Nov 2024 05:02:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731502942; x=1732107742; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=AbzJ+kU15cqJAnxZBlXR2yEKRSm3bncn2jZQ5PrWfNM=;
        b=gGkyaGIv+vG7t2uHZXInGMSs4cs19hDkhC85BNk1+RCsuZSbuwfqGYyE1jiiqa49Vd
         //U0J/nGEY0yzfW/sj4Tnm+Gd1xZRKgaXCYKYmZU6U62I01jD9PVcrj7Nmxoy5MCtfZf
         ijH8ZhdZuiVIeKpghovCbFMTjpoMZ+mBDv48Sob63UloVniUe28XJmb4vFVVdnwkleSP
         4KkT9Y+PSvXahJbOb+yvSs30IOgoZnQh26AUDXnRIQINcbz/XFOK4OXH5FLpz/ePuXK/
         nIWd2BTE3DbTzGq+hr8QNhEtYl7W851uYxYF+X43um5PWZCWqmgHcs2Jhx+eVVWI4g9p
         9fmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731502942; x=1732107742;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AbzJ+kU15cqJAnxZBlXR2yEKRSm3bncn2jZQ5PrWfNM=;
        b=KxbHwoTrQPl9gZIG039tUl6X3zQZsv5mJXeQia8iUwjqdvTwBJQlsXrexkypFvuz7B
         IUTiGktGywk2xH0/l8FsxpCyeNXz48VD6LOw18vVfheEZ65TxM1kGxhPFLI0ZcMcSIhx
         w8mSfRTUczik9Lzhev8IfuAWVxrgSKhDnQ7PmfrJttKHjhtCu39b/JfepVHRFTSVY07E
         gxW2K634K3axLRjGE1zoE2ioRui+/vzrBGQ/INwpwXFrCerQpweQGeAqSnLQwGWU/AAy
         r3k3syH6ejGMcvrTEV+JL2u83l7bDSfn4lhYNxjmV1PUsm0dK2g7Fa2xWLnvuTKnS3XK
         uNmA==
X-Forwarded-Encrypted: i=1; AJvYcCVQVjhF5JAjNNGR5IwTNEyM1TSZk+XZyIeHTgNjIeDv79OizOSpERzjtUfQ8fjJa5uQ8rRTpIiV@vger.kernel.org, AJvYcCVitUYeZM54Lp9vl0Iul2D4nOqtCXsBvmMLOufttlAy8rWnqYhtMcUJymT+XV82hkud+wsATnY+@vger.kernel.org, AJvYcCVn1gNyAQzU82GA/lvhlVS0FJWkdBhSiGujEfFq3EpC2sqg0gEynw5zqZ+D22xKF5G2KwuphudufTkBlrtwEOW5@vger.kernel.org, AJvYcCXLeDQ8lbiBqt0Mh9ytYdzy4K+IiaQ4SIeCaohdYqR0mFgNMFW75BwWAnoEt4mMqcrecYU60glArxcITRw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxe5sXwdgEbkSGUdsY+bFlp0YeekeCYBuzIUw1VMlFq2IB2wTtI
	dF4GR2keSy0WJMYRo66i90GrutWxqW8cHD/NBRc17c5H+PZJG0eQ
X-Google-Smtp-Source: AGHT+IGdFzP/aFDRjwd4saC/SLz9J8R5Gbj+ehtBZMSOW2SF3ig7tLXDoRjI5T94fEhIBVNHUlScgg==
X-Received: by 2002:a17:902:e747:b0:20c:769b:f042 with SMTP id d9443c01a7336-21183d6717dmr282119785ad.31.1731502942041;
        Wed, 13 Nov 2024 05:02:22 -0800 (PST)
Received: from kernelexploit-virtual-machine.localdomain ([121.185.186.233])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21177dc8c29sm109692955ad.25.2024.11.13.05.02.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Nov 2024 05:02:21 -0800 (PST)
From: Jeongjun Park <aha310510@gmail.com>
To: pablo@netfilter.org,
	kadlec@netfilter.org
Cc: davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	kaber@trash.net,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	syzbot+58c872f7790a4d2ac951@syzkaller.appspotmail.com,
	Jeongjun Park <aha310510@gmail.com>
Subject: [PATCH net v2] netfilter: ipset: add missing range check in bitmap_ip_uadt
Date: Wed, 13 Nov 2024 22:02:09 +0900
Message-Id: <20241113130209.22376-1-aha310510@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When tb[IPSET_ATTR_IP_TO] is not present but tb[IPSET_ATTR_CIDR] exists,
the values of ip and ip_to are slightly swapped. Therefore, the range check
for ip should be done later, but this part is missing and it seems that the
vulnerability occurs.

So we should add missing range checks and remove unnecessary range checks.

Cc: <stable@vger.kernel.org>
Reported-by: syzbot+58c872f7790a4d2ac951@syzkaller.appspotmail.com
Fixes: 72205fc68bd1 ("netfilter: ipset: bitmap:ip set type support")
Signed-off-by: Jeongjun Park <aha310510@gmail.com>
---
 net/netfilter/ipset/ip_set_bitmap_ip.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_bitmap_ip.c b/net/netfilter/ipset/ip_set_bitmap_ip.c
index e4fa00abde6a..5988b9bb9029 100644
--- a/net/netfilter/ipset/ip_set_bitmap_ip.c
+++ b/net/netfilter/ipset/ip_set_bitmap_ip.c
@@ -163,11 +163,8 @@ bitmap_ip_uadt(struct ip_set *set, struct nlattr *tb[],
 		ret = ip_set_get_hostipaddr4(tb[IPSET_ATTR_IP_TO], &ip_to);
 		if (ret)
 			return ret;
-		if (ip > ip_to) {
+		if (ip > ip_to)
 			swap(ip, ip_to);
-			if (ip < map->first_ip)
-				return -IPSET_ERR_BITMAP_RANGE;
-		}
 	} else if (tb[IPSET_ATTR_CIDR]) {
 		u8 cidr = nla_get_u8(tb[IPSET_ATTR_CIDR]);
 
@@ -178,7 +175,7 @@ bitmap_ip_uadt(struct ip_set *set, struct nlattr *tb[],
 		ip_to = ip;
 	}
 
-	if (ip_to > map->last_ip)
+	if (ip < map->first_ip || ip_to > map->last_ip)
 		return -IPSET_ERR_BITMAP_RANGE;
 
 	for (; !before(ip_to, ip); ip += map->hosts) {
--
