Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68C80238C08
	for <netfilter-devel@vger.kernel.org>; Mon,  4 Aug 2025 10:35:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754303724; cv=none; b=H9UpJQdzjuHx9yifsJECS+ELqp6EsyJJiSr7Nj1H7eBh9YooVHW3DrQcwppZa0MZnfYE5khViBBFsA2bj4QlqVmaKK3FRvJjN6WBGjpRXHt7WyIGptodw4x/V1bWhi3O+vyH+rEKMULIPILpXEoPk016AAxiFCrIqa1Foiiax9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754303724; c=relaxed/simple;
	bh=pe954wgmmEumejGnwBHivOYRG/9KnkTNzBgkDVd/euQ=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=mServtWS++pcYo463rN5kysNHDw1j0ZhM28LIuGSvhcpxVP04zFe8W/ucIGfZqIcC5oZrOrdMiiQvDVOErs0qR/zx50/I8QD/K71zpWHj7xJSfvgvCgvPY0KkU4QUKsuzI3Cj1yQze24bE1g/O3g57RQTdBmh/7MohCqZArBa+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=g4hWao9q; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="g4hWao9q"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-3b788feab29so2225032f8f.2
        for <netfilter-devel@vger.kernel.org>; Mon, 04 Aug 2025 03:35:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1754303721; x=1754908521; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SVsZnKEppNL82Tx2ebT8ir6qzuWebnepuASOH0OHUpg=;
        b=g4hWao9qdifWhoIOEf49FFbDYg9Hx2tkcT5zZx3GFLRDx7nPAKten8/SESE+WOJZCQ
         ld3cDcnpRANfnMExQMwu7ORGa0AUkWAYZd78C92Bhb5iLrVU7J0Mkel+UVisiiROfxdf
         4kgDVHzmNA6yxYMNrFKuxFTu7V84iHm47bhJwOkkwGTuAPs2cDtB703aHOalWhVmnZRi
         ENQw6ofUzLhuw9aT4hglaiftC5G2RmyRqviLOSnQ971iK0z4Pry8QQ5YTYuEPwyryGJ6
         0xsVrBQCHpSmFE27+wS24yjSxSNSapRNp7F7otLJf65jvQWxR0sycLFzNuHrEpEOXzaa
         HdGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754303721; x=1754908521;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SVsZnKEppNL82Tx2ebT8ir6qzuWebnepuASOH0OHUpg=;
        b=kreNwqbc0ZEbV7BY0211RaTu4MxsvqzOAkLxY39KFkB58/a9xsOmjRCAktz6zFXGHh
         Sspkb2Ttnism6Bw7423T8pqGXK4mG+FLZ97/it37lzokGnmU4xOlfRwaOzlg+1AfDr2t
         mqsyJ3vEE8qVEeqpz07Mem0X/TVrHEwRSl8P8E+e/iX0pKqF9rhTbXHb/Y+3VZofbsSE
         +uRjq4GZCP4Lcit9+CiiorERpZ3nzdMv8DcGYCNojfE6GtmgsamCT9VzbknyKRah8ZU1
         04k1FdDkZw+dYmeiNbW128DL+u00sWFpexD1TNZV+CCgJg3hrLk+xVg2eLfR5b09Tq1l
         FCtg==
X-Forwarded-Encrypted: i=1; AJvYcCWi/wtcCLdZ3h3LQJVHSpoh2RBTn76KCEKOxjDEmU+MocTNaGqpcE2kygjfGlEw2f3HCGMXUrU5I6qDyfvqZuo=@vger.kernel.org
X-Gm-Message-State: AOJu0YzKuim3BeQN4BJYjEqM6vBR/cEu/dBEA8KYnGMhbktR0pCPbd0e
	xTqGLjp8RSOobPLnVJJPPM1jyC5lp1LxsKFnLfVuTtHxBpNWRv0ReMn+USd/2pd/Olg=
X-Gm-Gg: ASbGncuN4Ug8GN3vNqiawEZVyXsM2BoaDcAe7ifw9PLxHvGFMSZZm45wKKp8RTagINY
	IHTpMKnxuACA3wxo91ckrrs0UuxeBbNhrx3cOQvLPcjbcf6zH2ww+GGhoZqVTvLLlGsE9yrE4Uu
	eMc0JggWRIQnpDqqT3JZ/ILwLOwwonfxdWq/FiP401imop+A2ULEOBci/A+QFHzsAdoF0M0BikU
	y0XGkrcv+ET/3Qt2eQdXFT1MBRr1TMRrL8WDQQ9LCS/QS0LCBf1V/VAULWb4WwWIM0R2jzjeAuF
	ISJZn5S7IrXTuToG3tTXRXMhaO/X2Bh1eRBKj9HSKxykkXzVTK707XT0S2qsnyXxZ2gZtVSuvHu
	sLEQpx9zFiuFnJeyegPn1Sb/Ue6M=
X-Google-Smtp-Source: AGHT+IFxnCtzMP77QQqIeHFAiFOez521/A3SRrlULlSKZYQx0zCUMF1RLl0DCGN4eVqJHy2LDD7DZw==
X-Received: by 2002:a05:6000:26c5:b0:3b7:8473:30a5 with SMTP id ffacd0b85a97d-3b8d9468519mr5415292f8f.8.1754303720554;
        Mon, 04 Aug 2025 03:35:20 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3b79c45346asm15189488f8f.39.2025.08.04.03.35.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Aug 2025 03:35:20 -0700 (PDT)
Date: Mon, 4 Aug 2025 13:35:15 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Lance Yang <lance.yang@linux.dev>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Jozsef Kadlecsik <kadlec@netfilter.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: [PATCH net-next] netfilter: clean up returns in
 nf_conntrack_log_invalid_sysctl()
Message-ID: <aJCM48RFXO6hjgGm@stanley.mountain>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding

Smatch complains that these look like error paths with missing error
codes, especially the one where we return if nf_log_is_registered() is
true:

    net/netfilter/nf_conntrack_standalone.c:575 nf_conntrack_log_invalid_sysctl()
    warn: missing error code? 'ret'

In fact, all these return zero deliberately.  Change them to return a
literal instead which helps readability as well as silencing the warning.

Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
---
 net/netfilter/nf_conntrack_standalone.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 9b8b10a85233..1f14ef0436c6 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -567,16 +567,16 @@ nf_conntrack_log_invalid_sysctl(const struct ctl_table *table, int write,
 		return ret;
 
 	if (*(u8 *)table->data == 0)
-		return ret;
+		return 0;
 
 	/* Load nf_log_syslog only if no logger is currently registered */
 	for (i = 0; i < NFPROTO_NUMPROTO; i++) {
 		if (nf_log_is_registered(i))
-			return ret;
+			return 0;
 	}
 	request_module("%s", "nf_log_syslog");
 
-	return ret;
+	return 0;
 }
 
 static struct ctl_table_header *nf_ct_netfilter_header;
-- 
2.47.2

