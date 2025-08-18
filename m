Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56F1031A078;
	Mon, 18 Aug 2025 15:40:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755531640; cv=none; b=VIVy65uikbTxJieBH6rsDbyPREoDya6lRGPZ52MiK6wDwmn/2y/yNCIWL3XAsXOBCJ7Ir1j9XzZKyyKx6IEM9W8WtIIOcy9tgmZZAZKbUEr6ElWhZFTf7NzFbcHKEeGC65QFwt7zt4vQYj3CnhoepgV5sUQvp9ZsmWYpNboIoVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755531640; c=relaxed/simple;
	bh=sAFz2z1/ZRQC2qROcdiohLJaaH2BTTS3LygeiT3tr9o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DzANe/x0k9tJsz8LZ472dZuU1CWmDLH4z8FDnhpIE+rDyHxuD364jsvdQddVdwgR2H+74GDsdnCF60kVTigT3puElW87BJ/bBctSKqhwc7hL1KHU13ceQBCnmblD4g7DIFf1VzYV9TOXyJSyswWvBgsgv044g6pZjJoSvoNdn+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fomichev.me; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fomichev.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-76e2ea887f6so3188784b3a.2;
        Mon, 18 Aug 2025 08:40:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755531638; x=1756136438;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=400SjVSUfc5lqYKS9qNytHX8Gj0bax7ac3ijCvpYgEA=;
        b=UfZ0pVoTk/vh4cXZju7E7Uge31f8uPdrtuWoZ8rhKFxF0iBROLRbyOrh7jfmJrYThY
         LT/liX2WpX6U2bGTI0Pa5HV2x/MlD9ts/5F6CbQdUyWXkPW0JjjBXYHdqzqiyL8WvF5f
         mx7aYA5U8URNOScaGoCr45yB1Ego+K8Qg4WTZW44Cx/CW++9Lr1GI+QeXek8o6idW8UJ
         r7m59f64CIVOxF4tEOfZNYglk6mJwqZYNeTgXVmgknJBc394rhOlNYGbhHTNsklLrrFz
         QF9t9xtLXQJbpq3o+YDZI0ui2CUnfR1oITirpJd/3uOsTCOJErX7gx+oguEHCpYv/5Ot
         S/Eg==
X-Forwarded-Encrypted: i=1; AJvYcCVdk70CJaLso4iGJixjTFAQ0eCyGn133SNIEvrhokW3Yp0nV1OCgBwTlvHe6WpICFHipA7ARjrDuaLhDkFGR926@vger.kernel.org, AJvYcCXs57evboertzm0SAUJXool+YhE/fUwhij+zNadHSRKY9U3csYj9rjiu52BzCGcjrNIH0VKwy07svKKXcw=@vger.kernel.org
X-Gm-Message-State: AOJu0YyIQulTkW1d6Nc9e05Jo8CftC/4qOqcyM7Es2901m8mt7UM3K5R
	xtysmC4jlEBvYaqIJWQaA+tKo2ojzu/VlWerMUWjghCGy0FV7fjwZ76rGwUf
X-Gm-Gg: ASbGncsZaScBnzmvshnaK4TaADkF3EOc6x/LQZDmpmCeq0+m67Mz8Sy3XdXS2BwOvEO
	7GpNkLKcfaGc6gXKu04YMcfiHdZIAdtzV/PsNS2LQ6YjiHRtRJK2nFiYhDpYzbpt7qBlrU0o1YX
	xvb7uqSbcQ9xF4KDErnONnJ9rEGT3C2923j04P6bPwot+EmwbmKum/SZ2p4LkWrNthZU7s5JW7a
	nw0W9bInDQHdj6WIxwqqLQa/hy7eb64XFQvk4fqlYIlTEjgRNgZaHxiXOPICXlA0N1ymI4KubBN
	kFgNO8pnXOwAJPStv6Gn9A0bpzquolko+jFDHXhH/ZU3Nlgw1fsjmSmdd3PL/ihRo+LKxCfb3vz
	N14ozP2GdFPHAkT3UTiNocVBfWphGzIDYfAfC19JhsYADuvtEcI36m4eEinY=
X-Google-Smtp-Source: AGHT+IECWwhvmllltH2cL2i4wyPzxSnCX2N0lJL9cMNY5uoidiXvTkAY62nN1JppFj6A7yEoIZc6+g==
X-Received: by 2002:a05:6a00:1701:b0:76b:f01c:ff08 with SMTP id d2e1a72fcca58-76e446a7638mr15752658b3a.2.1755531638161;
        Mon, 18 Aug 2025 08:40:38 -0700 (PDT)
Received: from localhost (c-73-158-218-242.hsd1.ca.comcast.net. [73.158.218.242])
        by smtp.gmail.com with UTF8SMTPSA id d2e1a72fcca58-76e7d10fdb1sm5731b3a.27.2025.08.18.08.40.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Aug 2025 08:40:37 -0700 (PDT)
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
Subject: [PATCH net-next v2 5/7] staging: octeon: Convert to skb_dst_drop
Date: Mon, 18 Aug 2025 08:40:30 -0700
Message-ID: <20250818154032.3173645-6-sdf@fomichev.me>
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

Instead of doing dst_release and skb_dst_set, do skb_dst_drop which
should do the right thing.

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Stanislav Fomichev <sdf@fomichev.me>
---
 drivers/staging/octeon/ethernet-tx.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/octeon/ethernet-tx.c b/drivers/staging/octeon/ethernet-tx.c
index 261f8dbdc382..0ba240e634a1 100644
--- a/drivers/staging/octeon/ethernet-tx.c
+++ b/drivers/staging/octeon/ethernet-tx.c
@@ -346,8 +346,7 @@ netdev_tx_t cvm_oct_xmit(struct sk_buff *skb, struct net_device *dev)
 	 * The skbuff will be reused without ever being freed. We must
 	 * cleanup a bunch of core things.
 	 */
-	dst_release(skb_dst(skb));
-	skb_dst_set(skb, NULL);
+	skb_dst_drop(skb);
 	skb_ext_reset(skb);
 	nf_reset_ct(skb);
 	skb_reset_redirect(skb);
-- 
2.50.1

