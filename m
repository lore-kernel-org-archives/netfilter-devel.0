Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCAF934CF5
	for <netfilter-devel@vger.kernel.org>; Fri,  4 Jul 2025 11:40:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751629212; cv=none; b=Xxsdad4jwKQyqfSZ0y2X5yTj1rk+Obav+vptPtl/ez6iimfAE4OpSyxWNm/wQ0rOq1347759nGaT7xfg6fqNfttBlxDZO2h7bak3ZkzyMfobJSusr0vQpuSTazpooUhFO6neP6HoiXZ5pinq9Yiaihq161lOsaFx82fCxp+OVis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751629212; c=relaxed/simple;
	bh=nTAdGiGIJ+k3vM+5W2XTCyrIdIznchn0yapifjezst4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IHy6PNn2UxeNAD/AlJzhn8WuyYFktyVlghORhaEknzxId5q37onjHq8ca1+ap0rCUwzSd3pRIK+1qI38A4pCGdPSKMIZRegscaAO5P+r22WnMT51pZe66vJZ6NCNgI8l+6eZS0xyWEjon3afOtZtqkRARG/T3rkA/H05odcjn4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lRyWdedm; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lRyWdedm"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-236377f00a1so8677215ad.3
        for <netfilter-devel@vger.kernel.org>; Fri, 04 Jul 2025 04:40:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751629210; x=1752234010; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GJwXMnog4MWdto1iUiwEEVgyzCAhmN0zYjW0WjtaPjo=;
        b=lRyWdedmRkhh/wiwmq5/so5N4+fmK4bZiIYPgLv+2cumF1gkHXjofE3tYI4xsLwzlw
         w6MNERziV4HarsGOeuBFLBkOg0idl70b1LNgzgJ6E2QG0jmL5UZgmD7KbFqbYfNT2WIb
         mrFJS1dI3UtJ200Q8RdJm4gXM9cMbJLVvNc7CJA/sLHd/1pN3IAt/a35m+8B7I2gYyiY
         /2wrj1aMrTV7JIUmEIW+xrFrOnE5rGRwvKCV2U6TAEV0geglhx9vKjK4vGicjYbVtT3P
         zjzt4IO/xZCFyD1ndy2TJgJcBOtWDMPVZGsvBgCdk8pBAg2did8UgVd5yhL2LskFgO/U
         sngw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751629210; x=1752234010;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GJwXMnog4MWdto1iUiwEEVgyzCAhmN0zYjW0WjtaPjo=;
        b=scfZ4WQoxYijLaea8PVNk4WO53zCjqJSBom6b7UOsnsjm+XqAZuCm/0l5eIA8gX7K2
         gq/FLHpon2jB+2r7BzqYXHWfPtd2gmnWyUMcoh9q8pdOsbXY5AClO8ukfucvi6suS3D0
         TuqvTSk5oAsECb74CTqVRvAojlE4NkxU5oQEpOqXOaOF/1k4iyeUf5wvkwoqhCdcS0R2
         J9WoOq8R1XOzYWyx9ttDWypjG1cdoNTkCRYIZxKmes4j3rv2ROjhI6swXEpgbr+JFson
         Ehem5kdgfunbImtYroxuX7XmVMSGvUvU4HPsIpBYCIdbpM8zUV2ey3va1AFwvqXlMtVp
         XH+w==
X-Forwarded-Encrypted: i=1; AJvYcCVVkB6QRxwaO2LJvQRK//yu9lrAqvQqfWUB/s6kOGkxbztDrECLwbecU3D+Q7LOfQYP88UK6TdhmohUkiayGEI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxkL3/O6TjwxOBTNMq84YRqqH0JEoCqphplDOshBo69QJ46dURS
	xSU183kNYD92y4iqoqGTEfspnR1lHt6V16J9GURxAFUGED9YTVD7t2wb
X-Gm-Gg: ASbGnctC5CJoMbA4gMU8jBs1ir4Mf3fQe0ZN8+lCxtygLy/rHEzzgi8Q8BphyXdGWFs
	hy85alZjj52OUlHVLk3UNNOEodjcUtn9WTcM/KG9dEnZW7VXoZq38JvdodzH0TCFuV9Jd+dWC9N
	njJxyBW86HukjuMM9NwRrLUxRYbB1hzdBtzWxBRN3TvRS9XlxQewT+qaQRKvehqBF0iGyfzQq8n
	V+lPSvAv7AW5UxcuhxqdpLd2Rijl9H0OEn6fABgqfXAWWcDWlCfdW2Zbm2GLmLYB1yvf3TFydJ6
	KT7TCKVd3jWjF3EjNvHlGhhuBFYOAen95M/kxxqfgm793UUIDJ+70iPCyqCM9m7Rmg==
X-Google-Smtp-Source: AGHT+IHEZ2AJv0uXjJr2JRinDQoQeCHzYKkAgv3AwLRznGV4vxNfSy2QmajcmrmxcEaSqGRGhc8AOw==
X-Received: by 2002:a17:903:2306:b0:234:d7b2:2aa9 with SMTP id d9443c01a7336-23c860fa925mr47904925ad.29.1751629210104;
        Fri, 04 Jul 2025 04:40:10 -0700 (PDT)
Received: from localhost.localdomain ([103.114.158.1])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23c8455e74fsm19585365ad.99.2025.07.04.04.40.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Jul 2025 04:40:09 -0700 (PDT)
From: Zhongqiu Duan <dzq.aishenghu0@gmail.com>
To: coreteam@netfilter.org,
	netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Simon Horman <horms@kernel.org>,
	Fernando Fernandez Mancera <ffmancera@riseup.net>,
	Zhongqiu Duan <dzq.aishenghu0@gmail.com>
Subject: [PATCH nft 3/3] src: only print the mss and wscale of synproxy if they are present
Date: Fri,  4 Jul 2025 11:39:47 +0000
Message-ID: <20250704113947.676-4-dzq.aishenghu0@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250704113947.676-1-dzq.aishenghu0@gmail.com>
References: <20250704113947.676-1-dzq.aishenghu0@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The listing of the synproxy statement will print a zero value
for unpresented fields.

e.g., the rule add by `nft add rule inet t c synproxy wscale 8 sack-perm`
will print as 'synproxy mss 0 wscale 8 sack-perm'.

Signed-off-by: Zhongqiu Duan <dzq.aishenghu0@gmail.com>
---
 src/statement.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/statement.c b/src/statement.c
index 695b57a6cc65..ced002f63115 100644
--- a/src/statement.c
+++ b/src/statement.c
@@ -1058,7 +1058,7 @@ static void synproxy_stmt_print(const struct stmt *stmt,
 	const char *ts_str = synproxy_timestamp_to_str(flags);
 	const char *sack_str = synproxy_sack_to_str(flags);
 
-	if (flags & (NF_SYNPROXY_OPT_MSS | NF_SYNPROXY_OPT_WSCALE))
+	if ((flags & NF_SYNPROXY_OPT_MSS) && (flags & NF_SYNPROXY_OPT_WSCALE))
 		nft_print(octx, "synproxy mss %u wscale %u%s%s",
 			  stmt->synproxy.mss, stmt->synproxy.wscale,
 			  ts_str, sack_str);
-- 
2.43.0

