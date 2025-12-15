Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3CBA27FB3A
	for <netfilter-devel@vger.kernel.org>; Mon, 15 Dec 2025 15:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765812799; cv=none; b=kPBa7u4wc1NuiEKKX38QPihGbvNt4jnN+pUqHpMaArmaHn4k4nLAKPa8lbT5OvVrVbM53A3e+P8HDHS3t1GKRHy3lMjmiUGwhRnALQyPZ3et82yXuw+Q8DcQLo0CQx2lDjPdMC3VLXncdL3KenSqwufguZ9axdrmv7Ip/njskCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765812799; c=relaxed/simple;
	bh=WmWvQHLY73kq6pyu0tqKKzeIaeIlwBviwDjoR+oDJmg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CMqbzs60aD5M64y76TEbM/DZ9d8fNHGVjlpoRMMspU4QkgWwtnaa1fK3bV0/+9f2d2R+rdec05XQ8I0iwZbI1Kmvu+EqAY7HQndS+1n7vkcL8pv/zZm+zZO3oulmf2x2RV2aCFNWkIkmV2KjpGlPB+irU68lVW8zZDM6Wa3htmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kSM/ZAy9; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kSM/ZAy9"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-477632d9326so22471655e9.1
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Dec 2025 07:33:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765812794; x=1766417594; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=shGL9qFpkDmIajBigNqT+nCnomY+2wBP3NtQMg+px3M=;
        b=kSM/ZAy9A/ibb/vYxkZYagoRF9ZMiff93LFSyEpNV6Io6o47xro300HFC3HSKrzA8e
         rg6CUwlaetlOnHfab2oAhHD1/BiLyApEIyAVD/VuFdOUvcPRwxkiLYIe/6LeFpYLiIqN
         +dKPOUAT6RXXRRLgSneQQkTE/vXdJBt+0cfeXXKHY91fkUhlObGHHapwyQfMGyvw8Fps
         JghF+yd7RH+F0SFJbPBPFG8/FRCskPXXMYKmmxT5QmI3BmNnItgb8eooKjx/51QU2msh
         uBFORfpYSld0a1V9P/eVcrX04ZSychNdwtYRoeOk67cpKLE2Arbanu9K669oPaCsq4Ab
         Gxww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765812794; x=1766417594;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=shGL9qFpkDmIajBigNqT+nCnomY+2wBP3NtQMg+px3M=;
        b=FdlQ50Yi4kGAFGRCNYcuU82m6SdherQzqL2ARJ9n7KfDXMnYpxNK6/LTBZel6RMDzg
         ArDDicWb9gYXdUxacrcjPk+iDun331oPTcc2I/2RkqojiXAcelad+VXS6Wx3wMZ5ybsk
         xr/Ta2SNxsD4j/qP5Cs+f9LpSLv6GmMMhdnXG371l/8PCHuvUCO3RSFi9HgO7VWh2EJh
         ZcGX6IfaHNoRAzsavaiQY5wNeTH9UYFcw4yEtIvDivK4ZGeyNMo8BMxTxq1Napd4u9UB
         W9pWS2yd9uWwFZ9/YaWMkmdWtV0idu/dugGNOs3ssLuMya/+zpGHoOlO6ooWjYHKcbHy
         nj/Q==
X-Forwarded-Encrypted: i=1; AJvYcCX39DF0GRmvR1uCgqYb4CEcPOkmj7+eaKQUR4g8lKQ+Lv/TTRtaiSyxE7tL83x4uBzbMTjrq3sDAfrBDBym5Hk=@vger.kernel.org
X-Gm-Message-State: AOJu0YxCVeFjnxJTqrcsuOVD/p5WSP6Pu7yc7aOqEadd6b0UTNKsdB/0
	4WfXJnHe6pwaexudBTCAlNhtKr3hCw0xxpX12atkScA19GOBZ4dzg0+o
X-Gm-Gg: AY/fxX6K0EL0sqcXMsrJMNnFXdHqSQlkaaDwmV+oH04tUcajaszQie7h5eKRtMhboHc
	8Y14TnaesbjEtTJi4DfDqXWkSkp/gpZv1b/S6xlLSyC7UfBTzvxRnXBcacx3UZwcMKWCkTwo4kg
	zzUfqpEyuhWhlOdEoeWYUQwkfo8tLq3CvxaW4JXEp+fH5tpTNJmGsmodBRbjqVTLoRUwWk1nLdl
	bm1yN/eVuittBc0d4qh/7PgVNBzKUReHIlgfVE+bCXTf5U1DIgGVKowblRJbWZ7pa2nERGnb3GJ
	yNttSZIRzodHeKU4CJsObUJTi/d7q2kkM3mAUjPLbCS0lD0TiV+qybBiuab0vp4MDmMgLi5XISy
	NwtCYycG4GqivtIz1A+61nGYa3h+OomVt5ke7lAmjjtOJSO068huuivm5DdOncDmr1ZufshJcRw
	QTohjtixufmx6ANMhpzj0F2a14CzozB2U3c2FjADjnNXqHE59KRi5uVFM8wLTIvw0=
X-Google-Smtp-Source: AGHT+IHKWs48xUNePoBMrBpBe8hDtPaLfvOFnL9ImcikdGgFf5GE4aphSLQpZ1+Kfb40qsOChnhBGA==
X-Received: by 2002:a05:600c:4e90:b0:477:557b:691d with SMTP id 5b1f17b1804b1-47a942cd40dmr90250005e9.25.1765812793917;
        Mon, 15 Dec 2025 07:33:13 -0800 (PST)
Received: from t14.labs.westermo.se (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47a8f4ef38bsm203433985e9.0.2025.12.15.07.33.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Dec 2025 07:33:13 -0800 (PST)
From: Anders Grahn <anders.grahn@gmail.com>
X-Google-Original-From: Anders Grahn <anders.grahn@westermo.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Anders Grahn <anders.grahn@westermo.com>,
	linux-kernel@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org
Subject: [PATCH v2] netfilter: nft_counter: Fix reset of counters on 32bit archs
Date: Mon, 15 Dec 2025 16:32:52 +0100
Message-ID: <20251215153253.957951-1-anders.grahn@westermo.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

nft_counter_reset() calls u64_stats_add() with a negative value to reset
the counter. This will work on 64bit archs, hence the negative value
added will wrap as a 64bit value which then can wrap the stat counter as
well.

On 32bit archs, the added negative value will wrap as a 32bit value and
_not_ wrapping the stat counter properly. In most cases, this would just
lead to a very large 32bit value being added to the stat counter.

Fix by introducing u64_stats_sub().

Fixes: 4a1d3acd6ea8 ("netfilter: nft_counter: Use u64_stats_t for statistic.")
Signed-off-by: Anders Grahn <anders.grahn@westermo.com>
---
 include/linux/u64_stats_sync.h | 10 ++++++++++
 net/netfilter/nft_counter.c    |  4 ++--
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/include/linux/u64_stats_sync.h b/include/linux/u64_stats_sync.h
index 457879938fc1..3366090a86bd 100644
--- a/include/linux/u64_stats_sync.h
+++ b/include/linux/u64_stats_sync.h
@@ -89,6 +89,11 @@ static inline void u64_stats_add(u64_stats_t *p, unsigned long val)
 	local64_add(val, &p->v);
 }
 
+static inline void u64_stats_sub(u64_stats_t *p, s64 val)
+{
+	local64_sub(val, &p->v);
+}
+
 static inline void u64_stats_inc(u64_stats_t *p)
 {
 	local64_inc(&p->v);
@@ -130,6 +135,11 @@ static inline void u64_stats_add(u64_stats_t *p, unsigned long val)
 	p->v += val;
 }
 
+static inline void u64_stats_sub(u64_stats_t *p, s64 val)
+{
+	p->v -= val;
+}
+
 static inline void u64_stats_inc(u64_stats_t *p)
 {
 	p->v++;
diff --git a/net/netfilter/nft_counter.c b/net/netfilter/nft_counter.c
index cc7325329496..0d70325280cc 100644
--- a/net/netfilter/nft_counter.c
+++ b/net/netfilter/nft_counter.c
@@ -117,8 +117,8 @@ static void nft_counter_reset(struct nft_counter_percpu_priv *priv,
 	nft_sync = this_cpu_ptr(&nft_counter_sync);
 
 	u64_stats_update_begin(nft_sync);
-	u64_stats_add(&this_cpu->packets, -total->packets);
-	u64_stats_add(&this_cpu->bytes, -total->bytes);
+	u64_stats_sub(&this_cpu->packets, total->packets);
+	u64_stats_sub(&this_cpu->bytes, total->bytes);
 	u64_stats_update_end(nft_sync);
 
 	local_bh_enable();
-- 
2.43.0

