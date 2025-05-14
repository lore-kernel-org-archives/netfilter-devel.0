Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1EF43EA98;
	Wed, 14 May 2025 05:15:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747199729; cv=none; b=WeN3gB+abKkBGw+VgEK6fxALbNeH259bbMQwSgL+t23WywMrAHaQRVInX6CsCJHprmDEHeux1IOWu8XgS12gGBjHPOKgAQt3zIL8n6wpKHPNeVqSdnOhsK2Fb521qjmyRv56fkxrfM/5I8CS+Rb+5nWvR0gUXEOvA2MU88uab/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747199729; c=relaxed/simple;
	bh=eFw1BfYnPC6LmkfRtAtYqLZ6BKk+kEAe1jllLDkqNpY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=WLyVcHBEu0mJLsUHv4o/fWEm9C8P9HHb33Y9YGUocs5egXB0aReG1V1wzBcvVrhqqxhCH4Lf0eBJh/YG/Cslll9Fm6we83YH+qYv6oYAQ1SOtjFCKtgu57xoaoPhnNDl854WoVIMf23U3n+xI0FMr4gTYz38leMz0Q9X5T5MvEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SGmkeJ4F; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SGmkeJ4F"
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-30a93117e1bso8341448a91.1;
        Tue, 13 May 2025 22:15:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747199727; x=1747804527; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=CbgHUhLTFdpIfxXqLYxPxEoyz3s4oC9scCc+c5WkiQw=;
        b=SGmkeJ4F/PivhWTLugJRWxh8VlvhdzFLkGjEHo+9f6f8vJ2holp35MHKQLn4mvBkZw
         tr7cEq6oSExYOajmSLZq5XHrFT20mdUWaJ7Dngz+8vVHGeWpxrUtyrEtgI+3T/48pd5R
         n/D5kVETv8xir4Ejw8GnRdGg7cHF+Rxz0lMiD5q7RzWkfbX94y1sqVzGVDXTXjXbmAvy
         tFCU84jEe8NXjDntSk6r9eQwt90t8WD316rLTqc5jtds+AfAbolR19Yf6Mk8I5EBWPsr
         A5XSO+tHzPcuLW8DcLOh91K4T/y3NDDNfRsfRepdSPMG0yJAtPhESNm95AzwRYEosHDE
         EXKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747199727; x=1747804527;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CbgHUhLTFdpIfxXqLYxPxEoyz3s4oC9scCc+c5WkiQw=;
        b=FSXR/RyUZA3PTUPnYWD55zzP02afXuCndykJQqGMUzIfqO3QI+33dhsDu5ixECBruI
         tMtnPUMoW/lAiktobZU+3YnuS71L1Qifogp+BVo/s72OpU1MxvuQoEQekvR28w7Y8+g4
         vz8mGfwhryluROb36wToqfntzgyJUeKiKM5ywht6/HQIwYhXf62dl5gwHd+/G6UyUW/w
         YHmB9FrawY9ECSixHaPcwnWJrSsSvsA/TqhikGDMyyII2sOXrbzcKkQT5HjF7M+Y1scj
         G6jhflBpurTQ/zChcKVVupnlsnHM4G4y3LJegs7YI0DlJxkPy/1nMKLNvsf33gpOkcey
         +SDg==
X-Forwarded-Encrypted: i=1; AJvYcCVJS39S4+tZVxd7PfU9JDppSkceSBw63q05riIsmUKtZH5KxFui5hGqL7B7BKSv99PmdSNiG+Wg7JX6Ed17iE83@vger.kernel.org, AJvYcCXMuvGN/q9pF6Kqv8DWrHLnDEu1QkQ94QT1YOjqec/H6FT42w4U6JTws6iLvnvHpFm/tFU15dcMfhFGwek=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzpq1RGL1o9kikngFZBHLdatMZlVzQz2ns7NfD96odfJZ/4y0nC
	GElW6D1eVhhG/j1XJcqF/7dW0Y0w8A66sBjywrsWrW86QX1jG9L1
X-Gm-Gg: ASbGncvnAyQa3orZgTcBUOGB83PkreNuwtW/1ufEG9JEGLzCOmywsVoQOZaebFE73FT
	xlx/FhShuOVC/W1Qr6TSIttNFVk061LVUPV3ebjYuKve9uHGKIA6HmA4Gw2PUuwCJwar4WUsYjT
	N1VesvtPwiXWg8Tf6iuDX4u8QHvgAATaoLC7OSyiy54Cq86ujXIzSututuTaFAPdjn3uGC5ULk5
	p14A5BpOs65xVWDwqW7s5utBGljlft05pYU3N4jjvX3Fcxbq4KRKSR2sfFiUL3RGY9IHPqEHxU2
	t/XlarCDxzkQB8rvCRe9HsuBgI7s8LM2p5G1IwMeycCI080ZUaQ117vrWrnm
X-Google-Smtp-Source: AGHT+IGvqXzMfcnyqNrj7p7wdnvTyszTPNPdWx0CWx39jKf1J8JTm3+PQhCMuWqtdtAl4jV5nLIrKw==
X-Received: by 2002:a17:903:b0e:b0:224:ff0:4360 with SMTP id d9443c01a7336-2319816828amr32312535ad.53.1747199727007;
        Tue, 13 May 2025 22:15:27 -0700 (PDT)
Received: from EBJ9932692.tcent.cn ([124.156.216.125])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22fc8271af7sm89967845ad.151.2025.05.13.22.15.23
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 13 May 2025 22:15:26 -0700 (PDT)
From: Lance Yang <ioworker0@gmail.com>
X-Google-Original-From: Lance Yang <lance.yang@linux.dev>
To: pablo@netfilter.org,
	kadlec@netfilter.org
Cc: davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	coreteam@netfilter.org,
	linux-kernel@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	Zi Li <zili@linux.dev>,
	Lance Yang <lance.yang@linux.dev>
Subject: [PATCH 1/1] netfilter: load nf_log_syslog on enabling nf_conntrack_log_invalid
Date: Wed, 14 May 2025 13:15:07 +0800
Message-ID: <20250514051507.87494-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Lance Yang <lance.yang@linux.dev>

When nf_log_syslog is not loaded, nf_conntrack_log_invalid fails to log
invalid packets, leaving users unaware of actual invalid traffic. Improve
this by loading nf_log_syslog, similar to how 'iptables -I FORWARD 1 -m
conntrack --ctstate INVALID -j LOG' triggers it.

Signed-off-by: Zi Li <zili@linux.dev>
Signed-off-by: Lance Yang <lance.yang@linux.dev>
---
 net/netfilter/nf_conntrack_standalone.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 2f666751c7e7..b4acff01088f 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -543,6 +543,24 @@ nf_conntrack_hash_sysctl(const struct ctl_table *table, int write,
 	return ret;
 }
 
+static int
+nf_conntrack_log_invalid_sysctl(const struct ctl_table *table, int write,
+				void *buffer, size_t *lenp, loff_t *ppos)
+{
+	int ret;
+
+	ret = proc_dou8vec_minmax(table, write, buffer, lenp, ppos);
+	if (ret < 0 || !write)
+		return ret;
+
+	if (*(u8 *)table->data == 0)
+		return ret;
+
+	request_module("%s", "nf_log_syslog");
+
+	return ret;
+}
+
 static struct ctl_table_header *nf_ct_netfilter_header;
 
 enum nf_ct_sysctl_index {
@@ -649,7 +667,7 @@ static struct ctl_table nf_ct_sysctl_table[] = {
 		.data		= &init_net.ct.sysctl_log_invalid,
 		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dou8vec_minmax,
+		.proc_handler	= nf_conntrack_log_invalid_sysctl,
 	},
 	[NF_SYSCTL_CT_EXPECT_MAX] = {
 		.procname	= "nf_conntrack_expect_max",
-- 
2.49.0

