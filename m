Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 840D622F0F;
	Fri,  8 Mar 2024 09:29:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709890167; cv=none; b=Dc4yHsZRTQ8NHZF0jcRIgpJ5MCqlpr7rUOk39aTMKqia+z9zLtlRSqmmpQG22ntDPUpOd0apNVS8rJEGYoVLK8KECeYHtMh00fiuG9juGjAGN5yfhVQpWHbPmmSs7ktSayVBhsOygrFnyc17gLNftHmZinqoNKSkWQpShqGG3Dg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709890167; c=relaxed/simple;
	bh=uWIbQbhTo1k5Hm2P3NjS7IiGjLT923Fdb/LEytpCR3M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Tgf86/KDjrLPij2NRRIUrbtrFk3MrWaer7123vo5BrSKZWEbdvNrSNZGO9UAzLW4PmKd/aAbxqQ8zncVpL3YLa5RqQ5MDqVJ6pEsOuCYPRJuJPO1Gs8DPODse17tD/dfHuu6DfcVO/YBB50eZfMYiZwnEzAEyr4KoKe0sqe0ucU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bQUTsZxL; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bQUTsZxL"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-1dcc7f4717fso5275735ad.0;
        Fri, 08 Mar 2024 01:29:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709890166; x=1710494966; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6auhInn5rzDEYzHLqWOU0+st73Pngssi19sn4m6uy20=;
        b=bQUTsZxLv1IjWQlqXwfCTg5RbWxcaE4096NteU8OaHD5dL5oPLlyToKZluf/aOaieQ
         LOrJIWmD26O2NCVefFQlvw1Biyu8Pbov1l+YjS8/wneStkQUxoPjUKccGPem9jChaSim
         0pfTcHMfjejzRlPhAAxHayRRDNhyTFk4aCX3YXQDa3T4EFVD4zq9ATA5ghM4i7UIui1i
         OqjKGd218jxPnmetZd6EBz1UYnIIAU1d2D0tAunejNrFFTBt5ma+FSFcTtCYhczP6jxM
         4Kv+5JitDs7o+gvHCyq4Jmp+in4suXoudyfJKkq53CjCIhlEabrAw19P+QLBcGp7kUNn
         S+Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709890166; x=1710494966;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6auhInn5rzDEYzHLqWOU0+st73Pngssi19sn4m6uy20=;
        b=FPLpGx95ikzN0FTMxwnnYMe22gxe+IhBRR7FnevKWDeqD7HRchaeMhaQ5yObpx1PUk
         RcC7g1gbfp66b6QWiwvDZqsM0BqIrTmTEq/1RKQ7PeJd5xRQC3HhdAmKaDE0RgUWfn7N
         X7FuWxS0s6qGyROmZXaaAnIDoH4fDG/wLgGaQ8oQGCs4bd9dQZS7Kd5qXV0Xm85ASceo
         1l18/9RB9dibXKahVwM1qBsqI1o3bHCMTxTatOsjTYs5kB+dBWjmBnmkVy5z6rCo4GCs
         /l9c9aRR06hEUL27QSm5dLs32wzWCsxxl9fZFqUa49AEpnSevUE6sETCyxe2i2afz/ta
         s/7g==
X-Forwarded-Encrypted: i=1; AJvYcCXeuo3+hpNg/144cEw6olXrXHrHLlY09fVdqwUzb13qKSFEagry/wjICBD1nfC2Ja5trK3Fe70xmdmb6fl8v+iBewozm0J9
X-Gm-Message-State: AOJu0YyiQZGfGUaYlpTPasSUEv+Se6ZmXBlhIoCHqSMJNVBNmH/iCWnb
	D7/sWkcUac8G7NMjz7AUsGp5cWdcAzpDWILcQxU1uYYjNWhynFf4l1qsQeQxrf4=
X-Google-Smtp-Source: AGHT+IHJIaIOu5sO+biKSPvmRu3amhiOpHP8UMiEpYU2UEJp9NcmA/NWwNHdV5H2+IXJ2RVi2kAHoQ==
X-Received: by 2002:a17:902:ce09:b0:1dd:6e47:862e with SMTP id k9-20020a170902ce0900b001dd6e47862emr378048plg.63.1709890165894;
        Fri, 08 Mar 2024 01:29:25 -0800 (PST)
Received: from KERNELXING-MB0.tencent.com ([43.132.141.24])
        by smtp.gmail.com with ESMTPSA id q6-20020a170902a3c600b001dd6290283fsm1547332plb.248.2024.03.08.01.29.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Mar 2024 01:29:25 -0800 (PST)
From: Jason Xing <kerneljasonxing@gmail.com>
To: edumazet@google.com,
	pablo@netfilter.org,
	kadlec@netfilter.org,
	fw@strlen.de,
	kuba@kernel.org,
	pabeni@redhat.com,
	davem@davemloft.net
Cc: netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	kerneljasonxing@gmail.com,
	Jason Xing <kernelxing@tencent.com>
Subject: [PATCH net-next] netfilter: conntrack: using NF_DROP in test statement in nf_conntrack_in()
Date: Fri,  8 Mar 2024 17:29:15 +0800
Message-Id: <20240308092915.9751-2-kerneljasonxing@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20240308092915.9751-1-kerneljasonxing@gmail.com>
References: <20240308092915.9751-1-kerneljasonxing@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jason Xing <kernelxing@tencent.com>

At the beginning in 2009 one patch [1] introduced collecting drop
counter in nf_conntrack_in() by returning -NF_DROP. Later, another
patch [2] changed the return value of tcp_packet() which now is
renamed to nf_conntrack_tcp_packet() from -NF_DROP to NF_DROP.

Well, as NF_DROP is equal to 0, inverting NF_DROP makes no sense
as patch [2] did many years ago.

[1]
commit 7d1e04598e5e ("netfilter: nf_conntrack: account packets drop by tcp_packet()")
[2]
commit ec8d540969da ("netfilter: conntrack: fix dropping packet after l4proto->packet()")

Signed-off-by: Jason Xing <kernelxing@tencent.com>
---
 net/netfilter/nf_conntrack_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index c63868666bd9..6102dc09cdd3 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -2024,7 +2024,7 @@ nf_conntrack_in(struct sk_buff *skb, const struct nf_hook_state *state)
 			goto repeat;
 
 		NF_CT_STAT_INC_ATOMIC(state->net, invalid);
-		if (ret == -NF_DROP)
+		if (ret == NF_DROP)
 			NF_CT_STAT_INC_ATOMIC(state->net, drop);
 
 		ret = -ret;
-- 
2.37.3

