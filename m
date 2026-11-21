Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795240480;
	b=3Q54IYPjXiyGovNmO2yD0O+v9uq5tqKZA30Q6f1hTqwHMgKnk/giR3Hg8q+Qf/3trQtF
	 abOcn10p56PUUfsUgoM0tO80j8yAAwyF17g1Bk+opYURbfPGy4Q7wrtIdxvh53AksBXi0
	 1jrOfVHWN18JCJ1uJ66RiKWwfz3ECuPSG/1kWQ13awrFTgA6ot++A8iaq0lQOvSFvXWzy
	 9l9w4FFIjwupZ9s4kzWB1jbTJu3Di6fd84v+IW1wYnCfKeFYyT+eKDOQ4/hzpZBSA33A/
	 Byzqb1oUbtRh6U6y5HZYZLV9+cBTKjVFISUycBqyhjfmKQfZ12RvOLwXBo7cGK3oWZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795240480;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=y3L7s+9Kef8vhzl7KlHTA5miZqAmaDgSLO7NodAAeiU=;
	b=3rgGHT39anZ/FM7xWSfcwmou5HvF6+vt39EOfXUSODXOw0oigUD9qe8kiwoqu2YRo9ki
	 pxWH0yoNKiaqTQUgSvAyzVulXNL37ZZXNk4HhV1+2LiQibWR3XnZ4umprMNBgXEemdoiH
	 ybFAt7vx+syJ4SvWq2ha4PaZ2ZwsUEMghwZveRpyLz8HnVZYdldvk2f3CIB0pxnW1zOVS
	 JGcxarBGdgb2CnYfOmplAZxuMXUbqh1dUGEzhEo3vpltLnLsBX7s1+hG/RU7inZ/K8Zoi
	 cAGrgWEWga68J+9SqxS3FTGpHMBgzUfJ47o/V3wwthbfiNvT5xpNM0WsdC9YreBHyfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=ikotaslabs.com;
	spf=pass smtp.mailfrom=ikotaslabs.com;
	dkim=pass header.d=ikotaslabs.com header.i=@ikotaslabs.com header.a=rsa-sha256 header.s=google header.b=nGvvbLED;
	arc=none smtp.remote-ip=74.125.82.46
Received: from mail-dl1-f46.google.com (mail-dl1-f46.google.com [74.125.82.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFB5F606A693
	for <netfilter-devel@vger.kernel.org>; Sat, 21 Nov 2026 05:54:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AFB5F606A693
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ikotaslabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ikotaslabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ikotaslabs.com header.i=@ikotaslabs.com header.a=rsa-sha256 header.s=google header.b=nGvvbLED
Received: by mail-dl1-f46.google.com with SMTP id a92af1059eb24-1a2761c69fbso3344599c88.0
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Nov 2026 21:54:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ikotaslabs.com; s=google; t=1795240479; x=1795845279; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=y3L7s+9Kef8vhzl7KlHTA5miZqAmaDgSLO7NodAAeiU=;
        b=nGvvbLEDpLxKZfCvafnZyVfu1lET+saDboniqmxWFmFuSPG/3KQlMwck1rc/lqyogt
         MGMTjp/L5Bxi3y46otXpYzvcmCuRqYWbzbD1nosNIw6cCwtOYYvNlh6GIv4ZzZrHzzBa
         /7vigDn/SlHXLqtb/ZmHrFm+XF/CmvojfZravFR++MbcAYiN8fxzRmmF1AWbmoGDaI9B
         WMDaK9kxVjJ1fxy4YZkkdSkId1gpJeAXfL15b8prXbWT8+WoDBV5rEH9gVmMpTopXCjb
         nHW2YNAytCWoCf9pHuIEuOPVij/ufy8EW5Nr9HO1gT93P2szUYvap6YcSa7hYyQima1B
         0FkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795240479; x=1795845279;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=y3L7s+9Kef8vhzl7KlHTA5miZqAmaDgSLO7NodAAeiU=;
        b=uyo2gQelb0StXiNAowFunDvhR+CekXKVL9eg9tFKKzkEd5fW7i9IflR64jVtaW19ay
         qKvJR1X7K7Y/wNlUNaXPpYurneTDUrvSlPBPY7Qg++blEy9ePG1DWoz3MJ3CJqPGCMir
         aRRxkeQetFKqOlxkJyW7ia3Ru4DClSanZ7cPppRi1wdKHkXMLBF+m2WooCIIGJ2JEGBY
         8xvJcab8LSlX/gAEmxlMlVknWCeFJyjNYI9GvJzusi9xdTPuST+aaPw521WLTb0VhkiZ
         iIV43Y7uX73KiCyX/mhxjcMdViFBFxJWipQfOquD9Btsj5OE4udpaWFhjEzxCt5sl3Hq
         LmUA==
X-Forwarded-Encrypted: i=1; AL+hErFk+aMkWnvOjxdKM7a6PTuAatOzFyMb3j9cNYyRPpFM9/zq9H0QeUoj2h33SnFuebNzQ+9xOAH+tLN8I0HkkiI=@vger.kernel.org
X-Gm-Message-State: APuU4Z9pOwOOK57Mza+Ege6T31eucsiEkW4Uh3bb8wvBgZ8b+OTE4qEj
	ud4RM9jguBF/FXp2YPLdXd89/h8AlLEaCTFUXjfBMnwqJjfvzWmgLp7wA1y88rSXP3Mm
X-Gm-Gg: AZFdTZfcyXmp4nAifOpsZ61R3NAgQvbRW45qSfCkvOOr5saxPR61myQEeBdkvXNzY9D
	2lP8ZQzbSoaqe7r+7IZVUPQ8YjC1rCL9N6bDTDmAPVfIg5iBM631838w88G/u34GYZac9nVM8F9
	zziW1kND5kwo0QOQhP1sXYy7UCNc+JWQXFadnEYAXI4LMnQMOosrc2NUWakN7j3bXMP+TDiE8v6
	lk5a1WS0Ge3LzLXwa8wimmmjMiTo6JNcIMDre9SNjnahsIXb7mmapbihX0GeShjuxJT/AkdhA4E
	+U1ZPr9fgpsQJ2Xa8PF98JrgTueknzMvbUTIiXawmw+vG4PHu4I3Atr9WWBMVusU3+tHBeu7yKc
	IaLMUR7E2S9qMWNaglmxOurdsWB3+k59qjFWcBRp486AWI0AArcO/uZR6naNqspv6Uz7ApEwg+e
	n3aIqUtKxvg3Mt8uacNVCWWCvEfkPDVoKYP7ccNF+a5ZVyKiIhksJ0LhsDwWVz84tFS3CG9OD5K
	ktakvsxJXehGh/r+fgeCjEFTuC6eTI9Htp/CJGGgI/YPCG3pUZR+MeTahgPmG2aMMlBjwZCkXf5
	lj6MI0R5u+RiGtOg9J76HMD7Y/NIvPx1O+5L/YxPe7IEq8M9G9ZZjpp+6Xju6y0fD5/tFRMNIeE
	ZeXZiV394oZw210WGGoi4C27FybrWh2lx8LfG/yqtygYjxfWBy0L5VnFjK/rx2k4zT4C7j1c+v9
	U+qh4BeiY=
X-Received: by 2002:a05:701b:2313:b0:151:d6e5:596b with SMTP id a92af1059eb24-1b5568b31admr4899867c88.9.1795240478832;
        Fri, 20 Nov 2026 21:54:38 -0800 (PST)
Received: from gx81.tail3ecf1.ts.net ([240b:11:99c0:1c00:9e6b:ff:fe84:e26e])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b556847fdasm13191646c88.13.2026.11.20.21.54.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 21:54:38 -0800 (PST)
From: Ryosuke Iwahashi <ryosuke@ikotaslabs.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Cc: Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org
Subject: [PATCH v2 nf] netfilter: nft_exthdr: stop the TCP option walk at EOL
Date: Sat, 21 Nov 2026 14:54:28 +0900
Message-ID: <20261121055253.1801718-1-ryosuke@ikotaslabs.com>
X-Mailer: git-send-email 2.56.0
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

RFC 9293 section 3.1 requires zero padding after the TCP End of Option
List (EOL). The nftables expressions that read, set or strip TCP options
keep searching this padding for the target option.

Stop the search for other option kinds at the first EOL. Keep the
existing behavior for explicit EOL matches.

Fixes: 935b7f643018 ("netfilter: nft_exthdr: add TCP option matching")
Signed-off-by: Ryosuke Iwahashi <ryosuke@ikotaslabs.com>
---
v2: Resend without line wrapping.

 net/netfilter/nft_exthdr.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nft_exthdr.c b/net/netfilter/nft_exthdr.c
index 861bab93f435..ce5494cfd4e8 100644
--- a/net/netfilter/nft_exthdr.c
+++ b/net/netfilter/nft_exthdr.c
@@ -204,8 +204,11 @@ static void nft_exthdr_tcp_eval(const struct nft_expr *expr,
 	for (i = sizeof(*tcph); i < tcphdr_len - 1; i += optl) {
 		optl = optlen(opt, i);
 
-		if (priv->type != opt[i])
+		if (priv->type != opt[i]) {
+			if (opt[i] == TCPOPT_EOL)
+				break;
 			continue;
+		}
 
 		if (i + optl > tcphdr_len || priv->len + priv->offset > optl)
 			goto err;
@@ -264,8 +267,11 @@ static void nft_exthdr_tcp_set_eval(const struct nft_expr *expr,
 
 		optl = optlen(opt, i);
 
-		if (priv->type != opt[i])
+		if (priv->type != opt[i]) {
+			if (opt[i] == TCPOPT_EOL)
+				break;
 			continue;
+		}
 
 		if (i + optl > tcphdr_len || priv->len + priv->offset > optl)
 			goto err;
@@ -347,8 +353,11 @@ static void nft_exthdr_tcp_strip_eval(const struct nft_expr *expr,
 		unsigned int j;
 
 		optl = optlen(opt, i);
-		if (priv->type != opt[i])
+		if (priv->type != opt[i]) {
+			if (opt[i] == TCPOPT_EOL)
+				break;
 			continue;
+		}
 
 		if (i + optl > tcphdr_len)
 			goto drop;
