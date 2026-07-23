Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B09F53C98AF
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Jul 2026 18:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784832394; cv=none; b=Qeo0ABVqFL8HthyNBSv/EVZWxrHXn6czO11Nevx9fnfqw1UmbtakZTGk6LVKE3GRW4191XA0FVIjZhA35+f7JgVbP3295qA9ijm2b/w9CS5i/0kC/8DKo+KsmAVFSBu92iUULQ5fG14u2BoKJvvrfIBJDYMJY8Ox5pSK5zX5lKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784832394; c=relaxed/simple;
	bh=zNsz4g/9jlKYeSwyAkgTCr/mWLvx1XT3kgMf7ziCe00=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ntnu7MxMZhPMIpliRWAFACp9XVHO2xYYTStJvM0SyqJJdCZ79d+7iqVuWwyqBWKjN3ZwR9nhENwOcLi66kx0aicb4wCK2HuyyJiHUbwspYy0DHQ/mxMaM9o4fZ7/RZRkHcSyVzFvv+6+XhH/ytAyXGs55T93Rv8nfgy0kho9a3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=K0l4Ru16; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K0l4Ru16"
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-38dc69c74b8so944385a91.0
        for <netfilter-devel@vger.kernel.org>; Thu, 23 Jul 2026 11:46:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784832387; x=1785437187; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gvjX2o7DFFzayFyUFs0i0LzhZ1PMgAv+++MqFVj9d/o=;
        b=K0l4Ru163rF4tHzGTfr2Y6xJ94fETN8xR+E/v70yXifc5TWJyT/ns7xFE3HlW7IyTD
         rqFWUZNU2xbwXbJJ1kiA1M1KqTloup2DbD3GBhCY0oOULOs0I4n/Vdg4mIcymMlkPNom
         05jLtTGTKRJ0Pzk8hjXMOONkFpkz+VY4UwFIjGT84rQtiBIBCB+9x/pivh1eGHGZRW44
         +GdoCQnS9tVrL/aSqdMx4D8wp0LB2bkofN2fZ2xbC+men9lMu3Hcn45yk9f+i+mhD2zK
         NgGr698RE1H7S/wYh3nCthw1DAH2T2tBGG1mmirAZJ+Omth19hkwtQUlOjVlojge2ypQ
         56+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784832387; x=1785437187;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=gvjX2o7DFFzayFyUFs0i0LzhZ1PMgAv+++MqFVj9d/o=;
        b=mHvrDHz2j/UbneyenUTaiGAFUHzUHpPt7+oRMhEdbFspMQkKlGN+iWzP/MEd/aunyy
         wZuSt1IcWnDpHsHsKxbeXtfWia3tMna0TeywDnEFlJvyK75n4vZxMKUWGQIxiz+uU48r
         0ZG2c2WfxWeIPD4ZvD3Ql13XfzBqI2BcH4g5PruShK9Zc6X04bDEKo4rN31WkjnObm/g
         BAeSo+sCyElaRvXhEOmFOp6+Fzr/oQ9n2Hkf4y4skWJlFPGUeKNkJFBjdx5+ujsYN5vH
         d1rVitrluVrMzZPYP8RB8HZ8HlWwnWNFiDhfaEGJG1/g2D8r+GvWhfqc/1HQOnUvwhBE
         A6Jw==
X-Forwarded-Encrypted: i=1; AHgh+RrrqS4t/c9gZcn0VrmmzqCy5lWRr7ts4Vo/TaKyHl6ymlZV77oNwa2iMK4w7bbfC5qbWwA2WzTTknoTi+vZLj4=@vger.kernel.org
X-Gm-Message-State: AOJu0YziKudJWQc/Sa2PlhaPd9u4Jpn0W24AlLxCZgyZPdFqY7jpiZEY
	rJPv/c0P0y5oye8DH0QrvdfpLxUKn57kvDmuOS1HtjyUnFRUpAsF9ASr
X-Gm-Gg: AR+sD10PiVgPM0wlZSMaAkp1saUdA+Oid/vA62suBODJRiG3BbiG66P1BKWsgZncI7Y
	pwJeGkjWQ+az7UPr2lT1EbFk1Z/waPPSwekettEmbpAvBJ9Kdmyjz1Do9Ba28+RIV0nG9oXfv6R
	G4EDRrj5yYOmDXIyFcjOHtPrE98x6oFheDYULuQmIGUUP2WbME/k+nihhv5JMwOZqgt8spHStXN
	6OCRqVIHMXzLewEgSLUVsQDPxJWWSotQ/4Cy3qRGA2qIfIqJI1vSZT90F4VDNtcVkACp5xvWgFY
	XIxNQ46tnIH98teYHoF3ZlcxVQKumI2gNaqLa9jdgsozexfAVzWIVGs+Xm+t3qEjvoBIlCwSFa3
	FBLOvVZx8syiiVTgBaLqZRu0zqF72sWKvmO/PoGYLRkJfv4e4frMzLi7Ev78FkXsCCCYUg7T56D
	W+NC/6bYE=
X-Received: by 2002:a17:90b:3ccf:b0:37f:fda5:8d9a with SMTP id 98e67ed59e1d1-38ec6a5115dmr4284232a91.25.1784832387385;
        Thu, 23 Jul 2026 11:46:27 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38f03af8a45sm308155a91.10.2026.07.23.11.46.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 11:46:26 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: Julia.Lawall@inria.fr,
	Simon Horman <horms@verge.net.au>,
	Julian Anastasov <ja@ssi.bg>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Cc: cocci@inria.fr,
	coreteam@netfilter.org,
	linux-kernel@vger.kernel.org,
	lvs-devel@vger.kernel.org,
	netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	Phil Sutter <phil@nwl.cc>,
	Simon Horman <horms@kernel.org>
Subject: [PATCH 11/36] ipvs: remove conditional return with no effect
Date: Fri, 24 Jul 2026 03:45:13 +0900
Message-ID: <20260723184538.3888637-12-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260723184538.3888637-1-ekffu200098@gmail.com>
References: <20260723184538.3888637-1-ekffu200098@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Both branches of the check return the same value, so the check has
no effect. Remove it and return the value directly.

This is the result of running the Coccinelle script from
scripts/coccinelle/misc/cond_return_no_effect.cocci.

Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
---
 net/netfilter/ipvs/ip_vs_sync.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_sync.c b/net/netfilter/ipvs/ip_vs_sync.c
index 93038abbf5e0..bd4f7e906cf7 100644
--- a/net/netfilter/ipvs/ip_vs_sync.c
+++ b/net/netfilter/ipvs/ip_vs_sync.c
@@ -1603,15 +1603,10 @@ ip_vs_receive(struct socket *sock, char *buffer, const size_t buflen)
 {
 	struct msghdr		msg = {NULL,};
 	struct kvec		iov = {buffer, buflen};
-	int			len;
 
 	/* Receive a packet */
 	iov_iter_kvec(&msg.msg_iter, ITER_DEST, &iov, 1, buflen);
-	len = sock_recvmsg(sock, &msg, MSG_DONTWAIT);
-	if (len < 0)
-		return len;
-
-	return len;
+	return sock_recvmsg(sock, &msg, MSG_DONTWAIT);
 }
 
 /* Wakeup the master thread for sending */
-- 
2.43.0

