Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90F271C242D
	for <netfilter-devel@vger.kernel.org>; Fri, 18 Oct 2024 16:25:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729268727; cv=none; b=qVPoNnHiYSycqBKy5cX9cV0I88fKataNZb+4CeI4dEWQK8hSOrzULVoTgN/RDRfDITZg+5LE6W65Qj1Wq57/XJz6klBtgY/vCkes+FpkpbIB8adAUrXnDsl/3p2Z9rOS7gqVkN10LKaQHpxYFOefSFlnAWS4cjfQvAlIAGhgt1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729268727; c=relaxed/simple;
	bh=Qm8FJuHRRwls/WqAeoFpruf5JFERUa8R5bqjrs0EgM8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=i1ugxBfdauU8QW7eMbBJR3FVgwKg2++/DLOvUYqJvSS1p6S5Kyz4PTav+EmjTsSYMwx6jjuYeBZxuuCrzcgZT0K4GW0x1tC1F7wTngoiX1lqCLk5BeSSQcBOQNkDe9HPI0tQxefyBtR0n+45VwcDbtQrPVTNsJGRcw/ojggqBeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloudflare.com; spf=pass smtp.mailfrom=cloudflare.com; dkim=pass (2048-bit key) header.d=cloudflare.com header.i=@cloudflare.com header.b=RjVsYvhM; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloudflare.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cloudflare.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cloudflare.com header.i=@cloudflare.com header.b="RjVsYvhM"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4315e62afe0so16986025e9.1
        for <netfilter-devel@vger.kernel.org>; Fri, 18 Oct 2024 09:25:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google09082023; t=1729268724; x=1729873524; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ch5DeSK41qqOXt5fRprznhl/8uUUV8RtaTKJ1Y7/r7I=;
        b=RjVsYvhM3Mc6wlYizbegi02tKxbPVH4ARBoMpGYGbVcZ1PlKTvAi2NItrmqbIMoHRx
         6SkYNKF4XlL1UjxyZdBzoOC+ncnsXvti806U2Qy0yO2DDvRa4qMpobeBvcyautEay/AC
         r1uMxur7+sjjXazk+pHhaPuFW/iQmCc588iLHCJbpuuvYlfRZo1X6I4Jt/nFH2w2C6Qj
         aFxIwhlvVoQxWEh9tb3YlOhLvS13KKb6qnvxnGFsa5ELOHwvrMrQzlVGcbcVJfXTt3y/
         mSWpgsCQjWOL+3SZtcf4l3I3s6TUUCCuIV9xPAbOUkg5CgdIedd5twRP8WEaNPTkM4pZ
         ZTCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729268724; x=1729873524;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ch5DeSK41qqOXt5fRprznhl/8uUUV8RtaTKJ1Y7/r7I=;
        b=aSpwQbK2fiHAVvpMeco+rA/GP6r1iGz2AcfHFdmZt9kl8+jv9Bsd3LkYxlFpYz1Bxo
         z80GJ02T6Axm/5Z4TuDIRJ8lBi9HeIHYKzrOxSfhv4HObvV6jIEn+pqVX0poPVyW3FLe
         y08iPG7fbcq49SLMmdJm13+s06yS4LU6c2UGFTwgjitIpASfTix4wMRTxBp94vYwqLVX
         7Wuh/F7HJ5jmlhjw1p3ZmljSgG7tnN2zlva9WbqWN0ofaWMw028aY+i89k8Q5dQ0nt6l
         3qKjdx9GfGr8JbYKxes9Lkjmu33TjJrZidFM0bgg6h88zysQ8g7uyzGYcujDr4o9np46
         ZM4w==
X-Forwarded-Encrypted: i=1; AJvYcCXa3UITDKrmh1DDZM/rHtgYb/Z/9WdRdgSPU/5Odf586i+LcEebk5vnAw5HmKGbIq2a989U9fkjFIXM5qAJTbQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzxjww+n0nkMVbcKytpWycSiOdopxnd7lSxKzpE0eT46EXYuVn+
	XWZcSVJYhrNSsmI7SpKK3Rd3jQavhMaeQm6ca+orK+EwCHR5WLxhaf51nMWqBG0UxQDbFTay2X6
	rmxW9CGuUDMA=
X-Google-Smtp-Source: AGHT+IG55NayxS0oQBlxGjkszsHyKw5MDiOhDqS4zbVLWOMuBB2ZIxTPFLk3EVur+Ss+hgvqAJlzvw==
X-Received: by 2002:a05:600c:3553:b0:426:647b:1bfc with SMTP id 5b1f17b1804b1-431616a0b1emr25002345e9.30.1729268723752;
        Fri, 18 Oct 2024 09:25:23 -0700 (PDT)
Received: from localhost.localdomain ([104.28.214.4])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-431606c64b8sm31178715e9.38.2024.10.18.09.25.21
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 18 Oct 2024 09:25:23 -0700 (PDT)
From: Ignat Korchagin <ignat@cloudflare.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	davem@davemloft.net,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: kernel-team@cloudflare.com,
	Ignat Korchagin <ignat@cloudflare.com>,
	stable@vger.kernel.org
Subject: [PATCH net] netfilter: xtables: fix a bad copypaste in xt_nflog module
Date: Fri, 18 Oct 2024 17:25:17 +0100
Message-Id: <20241018162517.39154-1-ignat@cloudflare.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For the nflog_tg_reg struct under the CONFIG_IP6_NF_IPTABLES switch
family should probably be NFPROTO_IPV6

Fixes: 0bfcb7b71e73 ("netfilter: xtables: avoid NFPROTO_UNSPEC where needed")
Cc: stable@vger.kernel.org
Signed-off-by: Ignat Korchagin <ignat@cloudflare.com>
---
 net/netfilter/xt_NFLOG.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/xt_NFLOG.c b/net/netfilter/xt_NFLOG.c
index d80abd6ccaf8..6dcf4bc7e30b 100644
--- a/net/netfilter/xt_NFLOG.c
+++ b/net/netfilter/xt_NFLOG.c
@@ -79,7 +79,7 @@ static struct xt_target nflog_tg_reg[] __read_mostly = {
 	{
 		.name       = "NFLOG",
 		.revision   = 0,
-		.family     = NFPROTO_IPV4,
+		.family     = NFPROTO_IPV6,
 		.checkentry = nflog_tg_check,
 		.destroy    = nflog_tg_destroy,
 		.target     = nflog_tg,
-- 
2.39.5

