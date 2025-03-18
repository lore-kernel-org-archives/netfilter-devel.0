Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7AC61E8334
	for <netfilter-devel@vger.kernel.org>; Tue, 18 Mar 2025 16:02:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742313742; cv=none; b=SFCvql02KsRXCB5qUUS3P4f/9KOOj8BgjcFSHKLRqzjRvhltOH4f2OC2q1Ep35Zvzitt+LzUN+waWKv4003tUawHeFXjY+DeGgWLZ0OhrKPeISxZLXaiA6t1cV4+pmtajLOZUN9hZidj5+B8g00FP8LP64Bvb4BgCy58jXW6sr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742313742; c=relaxed/simple;
	bh=tadajSycUMfksYJtgJo0MDrQHVcb4QaBhCKobufIRVU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JpUt1kD5XHuggOSZQvlUQqHOmuPdRIxTCdJ2N1LDtPnTIq5Exdbyin42MFNbDjPwoFFPQHcW2hGF13arCxRHwsWuMxD1VsjTK1dEgL6J6t/C7HmmgW7BS6V6IqQwjzA4RDq838qpFeBCpCH9GoudwkSwVK9AwAbSLn/uSYmCUvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Yf3L7amS; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Yf3L7amS"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2240b4de12bso16170665ad.2
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Mar 2025 09:02:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742313739; x=1742918539; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=b1fNT6PQgaHhE+VbTZLbOS6dTEYQTDUvFJ5kD8i//Tg=;
        b=Yf3L7amSc1QvoYWCcuQrAM/ZiHnUQ/r/0ZqHhuZWCVJAyx1C+Sur+G2yG6OE55MY9k
         6WiKJjQiV6kOzaUMXeBjnYkpkdBkdXyLsZkcscXPzk8fxcF6awrHwr49whQkeJcUsBWl
         1/6UNaRJRDmwlXqBUxVCoypOo819Tya0Qw+Yyb7NFJ4tYkQwsmBuEFTWPtB3qNqoXono
         P+4/IqrXuCjskC5Z+5L8X5Sp3jIsFYiBT57y11DU81smWXLd4+NJJxfouw3qUxFiliaJ
         2LcU6TyzeUnLjD/wGDAVZnAdfdJ5YRGi2msubq+oEglLcIbCNoa7KqLhje6fcahhsYXh
         RRhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742313739; x=1742918539;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=b1fNT6PQgaHhE+VbTZLbOS6dTEYQTDUvFJ5kD8i//Tg=;
        b=a3jDd73NHgSuOXKAlY3T3BHgHLcZrLY3XpuUETdGD5HZdc/O0Aew1kQj6mEl6oNrTD
         AhYuFEQDlEFBWusG5jA6Kd2UWYQ6JvxBxc/+1ugc+PyAh2GTMjIXvVMTXhH6TnM0oUk4
         LLN4e/4ENnpQWgEU+krYCLpLuFfJzI0OpEiMTnGBtn6/9XD7Yq7y1ZuJWMqYavUNz1dd
         TzYvUnaXtoKIzl8wiID19Pv8/+BULZJvWpvWU1rjcwJE8TaKfO+Fbk5Oibd0neU4Yx5G
         5aSyozEP7qd9ivxsUGxFOPdZLnLEMP/TYgLtLfxh6ncTfaHK0tnZWh4Rrh962SIy38iS
         qKrw==
X-Gm-Message-State: AOJu0YzLqOhjUwYptgvOnXy2dSRgT16ZZXeLyjH4FwXMJ91/anHMXwBN
	krPL+lB6AxIOhqzSKtyG/0kzkKZF7BZsmigA5jdImMm0Ca3BYF9IFFSHhA==
X-Gm-Gg: ASbGncuXRQMSSk/ObuHMfQglXeolZwFpJmPxYKBOYfxcJyIt7NBAv/RzF3Dlh2KoX52
	L5rBux7PlT0Eb1EH+UTsHVZv02CyjF6YMc848iuZH1zt2VV/85LAXLTydVttesojoe7X0gK45WH
	HxZomcW4Dmk83FqmeBf2q+rAjmpkZkj5NoyCna3sRNcRPO5++hjMyuMQ+3td5/xKMJqhkzVqSgP
	Z6aSj35VKIDL9YrOvUN6ZmA5tuO/gXA18RwKGLYKdEyhQmEPx7jPQZOyltTU3W91xTojrak2VRI
	26+fMFF4U/xZmmjacx7gcZQR4m60KKs+
X-Google-Smtp-Source: AGHT+IEV39rBcktoZSmqtMdQM2AwscEWW3/y5Z62dcIlIE7xYh/l2NGkeTJOdYk3A8ALEAtokOvRdQ==
X-Received: by 2002:a17:902:d50b:b0:223:5379:5e4e with SMTP id d9443c01a7336-225e0a62e97mr244375685ad.10.1742313739341;
        Tue, 18 Mar 2025 09:02:19 -0700 (PDT)
Received: from fire.. ([220.181.41.17])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-225c6bbfb4fsm96416845ad.208.2025.03.18.09.02.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Mar 2025 09:02:18 -0700 (PDT)
From: Zhongqiu Duan <dzq.aishenghu0@gmail.com>
To: netfilter-devel@vger.kernel.org
Cc: Zhongqiu Duan <dzq.aishenghu0@gmail.com>
Subject: [PATCH libnftnl] expr: fix new header name printing of payload expr
Date: Tue, 18 Mar 2025 16:02:04 +0000
Message-ID: <20250318160204.49576-1-dzq.aishenghu0@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The debug printing of the payload expr shows the tunnel header name as
unknown. Since after the first version we added two new payload bases
inner and tunnel, I prefer to make this change to meet possible future
extensions rather than setting NFT_PAYLOAD_TUN_HEADER as the new bound.

Reproduce:

nft --debug netlink add rule inet t c meta l4proto udp vxlan vni 0x123456

Before patch:
  ...
  [ inner type 1 hdrsize 8 flags f [ payload load 3b @ unknown header + 4 => reg 1 ] ]
  ...

After patch:
  ...
  [ inner type 1 hdrsize 8 flags f [ payload load 3b @ tunnel header + 4 => reg 1 ] ]
  ...

Fixes: da49c1241474 ("src: expr: use the function base2str in payload")
Fixes: 3f3909afd76d ("expr: add inner support")
Signed-off-by: Zhongqiu Duan <dzq.aishenghu0@gmail.com>
---
 src/expr/payload.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/expr/payload.c b/src/expr/payload.c
index c3ac0c345aec..992c353423ef 100644
--- a/src/expr/payload.c
+++ b/src/expr/payload.c
@@ -207,7 +207,7 @@ static const char *base2str_array[NFT_PAYLOAD_TUN_HEADER + 1] = {
 
 static const char *base2str(enum nft_payload_bases base)
 {
-	if (base > NFT_PAYLOAD_INNER_HEADER)
+	if (base >= array_size(base2str_array) || !base2str_array[base])
 		return "unknown";
 
 	return base2str_array[base];
-- 
2.43.0

