Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A271213AD3E;
	Tue, 28 May 2024 10:38:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716892684; cv=none; b=YF8Ns+rFOCZdIFBTSFRAlTRZ7UyTkQQIPC04nrLHUi3sXanO6mJ+1/Zlqs/RHn/sx5Kj163FdYygi51yhTuotSEm+tXr7L9iL+EM+VgoQrrFL0z9ubMmeBQjYwgE3nKCv0RtAFMBjJC/+/4u2iBGLDJZNcSZS5ezOfJkEi9S6mQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716892684; c=relaxed/simple;
	bh=njMzUdklFAgR1CDylaANJn2ylbIfnSH2z+YX6LG6nDw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=a8Gww7GMJcpj6wA3e2Z97QpF64lopi+CMboT/TOQEOFFgkZ5BeKzgxRqEzJDtZTLGgowrahGnyrHoNcTK5aoF40AoqECq8ZAvNFTrFG1D6QBrNyggQcsqdhsgGmfCjtnNbB3LAOFWCbXS37/R8uj/8lBBij9cr6MWeA/p8ky+IM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fEeh+qcA; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fEeh+qcA"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4211b3c21d6so5097285e9.2;
        Tue, 28 May 2024 03:38:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716892681; x=1717497481; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ql27cNbGhklYG0AOxTSVuwH0LBMbqLIuM9XupnBo33Y=;
        b=fEeh+qcAl+Cxmq1y1vYjbuLSlVD3tsa/LlOAs3JGaQG8VJhhqUCP8qbjuKXHaaKeLh
         c//ILEknxRcFNf1LIgSFMY3tSKq0iRZUst3SLyY7cEOMHhrCAJv48H7QUUtofZmXhpqv
         +M/e9f2ILimmnNNzmBUntgCTFFUNzFMeGHaiJ20MX4HKtR1USVerBRh9OjS7Bq4iPqst
         etvo2M611+LohGZvE+hnSQDhMURCHDD5Z3sY0AMESIYJJs5nE9405XjAWdFVcE0cdHrM
         tZ6wZDVQGQ/RKK808ncya4xu9IIzZACyCu7SkX6wO5+XDBhW6MPaGs0AvEzSGqb9SrPS
         jgDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716892681; x=1717497481;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ql27cNbGhklYG0AOxTSVuwH0LBMbqLIuM9XupnBo33Y=;
        b=pYLiPp/Az8vvlh4Yyj9Q2f+CbRrkhAcRCfVfqJk8BglC9sGM22+hbGzK0GQ3OKydO1
         AwhZ1mU1fgqtVFh0TvGkZ2boQdFSACqC1e6erjUUpecda3Fgpzz+5AKVzpTajX/Jo9EV
         ehrJtI+9VwOb+I9IqZLwUOR7/KgzhA9FEp8Pw7APnAyDqBx+7JpTCa8VKePPOTK2J8E7
         1iuWzCAzIeEdY84QIEEdunBUK8rW0m0fifW5O4ShZTwQzzVwQAG7GHNlPlGP43aHW9gs
         lguzXVnRbp5mtsDmO1cjvmjBCPSfLHtWzc1M/UysdgYSo71OMnir3cyAjaWMQboovBkZ
         iQ+w==
X-Forwarded-Encrypted: i=1; AJvYcCVfkHYFe5HlpCdR0r3y0cimQhmTIOKLl+QkW8/IRB3D5BUbYR/B0fEvt/UgK+sdHISeePKC5QI7vEcYWYrquO2C/kNk/lPXHMCKoBUwb1bO
X-Gm-Message-State: AOJu0YxNrOkfkUWHPVteHjLwI9CHnvsOq7FjnasIiJASiMWAXJq9aUO6
	9N473Ox+crq2osBqRTafptV0JP4zH7x0FTeEbLd6nGqda6dqQBH7CO9vx/je
X-Google-Smtp-Source: AGHT+IHT92tkGMi5yl96vQYpYgHd0WKtZOzkStR3uqcb5pT0b0wH/0QCv5SHBuGdygRBdgAXPd/loA==
X-Received: by 2002:a05:600c:1c04:b0:41c:2313:da92 with SMTP id 5b1f17b1804b1-421089ebd32mr86880945e9.4.1716892680429;
        Tue, 28 May 2024 03:38:00 -0700 (PDT)
Received: from imac.fritz.box ([2a02:8010:60a0:0:68e9:662a:6a81:de0a])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3579354abd1sm7984751f8f.59.2024.05.28.03.37.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 May 2024 03:37:59 -0700 (PDT)
From: Donald Hunter <donald.hunter@gmail.com>
To: netdev@vger.kernel.org,
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	netfilter-devel@vger.kernel.org
Cc: donald.hunter@redhat.com,
	Donald Hunter <donald.hunter@gmail.com>
Subject: [PATCH net-next v1] netfilter: nfnetlink: convert kfree_skb to consume_skb
Date: Tue, 28 May 2024 11:37:54 +0100
Message-ID: <20240528103754.98985-1-donald.hunter@gmail.com>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use consume_skb in the batch code path to avoid generating spurious
NOT_SPECIFIED skb drop reasons.

Signed-off-by: Donald Hunter <donald.hunter@gmail.com>
---
 net/netfilter/nfnetlink.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
index 4abf660c7baf..c164abcc326b 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -402,27 +402,27 @@ static void nfnetlink_rcv_batch(struct sk_buff *skb, struct nlmsghdr *nlh,
 		{
 			nfnl_unlock(subsys_id);
 			netlink_ack(oskb, nlh, -EOPNOTSUPP, NULL);
-			return kfree_skb(skb);
+			return consume_skb(skb);
 		}
 	}
 
 	if (!ss->valid_genid || !ss->commit || !ss->abort) {
 		nfnl_unlock(subsys_id);
 		netlink_ack(oskb, nlh, -EOPNOTSUPP, NULL);
-		return kfree_skb(skb);
+		return consume_skb(skb);
 	}
 
 	if (!try_module_get(ss->owner)) {
 		nfnl_unlock(subsys_id);
 		netlink_ack(oskb, nlh, -EOPNOTSUPP, NULL);
-		return kfree_skb(skb);
+		return consume_skb(skb);
 	}
 
 	if (!ss->valid_genid(net, genid)) {
 		module_put(ss->owner);
 		nfnl_unlock(subsys_id);
 		netlink_ack(oskb, nlh, -ERESTART, NULL);
-		return kfree_skb(skb);
+		return consume_skb(skb);
 	}
 
 	nfnl_unlock(subsys_id);
@@ -565,7 +565,7 @@ static void nfnetlink_rcv_batch(struct sk_buff *skb, struct nlmsghdr *nlh,
 	if (status & NFNL_BATCH_REPLAY) {
 		ss->abort(net, oskb, NFNL_ABORT_AUTOLOAD);
 		nfnl_err_reset(&err_list);
-		kfree_skb(skb);
+		consume_skb(skb);
 		module_put(ss->owner);
 		goto replay;
 	} else if (status == NFNL_BATCH_DONE) {
@@ -590,7 +590,7 @@ static void nfnetlink_rcv_batch(struct sk_buff *skb, struct nlmsghdr *nlh,
 		err = ss->abort(net, oskb, abort_action);
 		if (err == -EAGAIN) {
 			nfnl_err_reset(&err_list);
-			kfree_skb(skb);
+			consume_skb(skb);
 			module_put(ss->owner);
 			status |= NFNL_BATCH_FAILURE;
 			goto replay_abort;
@@ -598,7 +598,7 @@ static void nfnetlink_rcv_batch(struct sk_buff *skb, struct nlmsghdr *nlh,
 	}
 
 	nfnl_err_deliver(&err_list, oskb);
-	kfree_skb(skb);
+	consume_skb(skb);
 	module_put(ss->owner);
 }
 
-- 
2.44.0

