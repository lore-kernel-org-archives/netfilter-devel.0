Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F796538B
	for <netfilter-devel@vger.kernel.org>; Fri,  1 Mar 2024 17:07:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709312860; cv=none; b=dTPLlkrYtkdE38vbve48oD7ZmQ09NJBpS9u/e8E9fs21YJhykVOksHxX62PeE6OdVU+oWp9n2J2X2KWYcGsa0ziEoIn8w8jVBHZAZRHm3p5HPypKaI/InB+71f58dYEZJtJl57OZDgw2G7O511SUZ0xzBlwUhOzUnVLla+o4WIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709312860; c=relaxed/simple;
	bh=Y6jvGeptn7yxcuCYkI2LAgFPC6SskbXTNBGdothdVu8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ncfLbJT//rjEuMJdlG3oAJLI7d5YAg0uQCqD90TGtyysKHAqI5fls9qs2GMQjj9yvko7Rs3nm87mSc4+5+1ShOM29IgFxIbDjLTCA5e+NGyynf6O3WmUkjGuxITpafoADWBcX4MplL5xUYFpvC8Ma5NqszVUJIaYO3Sh441w5XI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KZ3iEOG9; arc=none smtp.client-ip=209.85.219.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KZ3iEOG9"
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-68f901192afso9972006d6.1
        for <netfilter-devel@vger.kernel.org>; Fri, 01 Mar 2024 09:07:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709312857; x=1709917657; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r7FDDAQs7CyhL99MhjUm4iQ4lgVkaSlCRfPuDt5e4a4=;
        b=KZ3iEOG9Ta0+AbjgzhhlrGA/wHJtzHivBw15VV1bOg5Qb3PBVX6W2Dx499cMi7xa3O
         F3RSs3Xj6uJV0VCeaGfY11Kv4XzjZn/d9dZCNfpDPIcIjcvCghHZ2mk5MrFf8T55Nm1Z
         fnjjqS1AuZlDh5hohIZUjpw94jPqtvN4E8rd2R+Vckbg2PnNp3kRP+CJjsfD3kadgHiL
         KW9hBqbpa5ZK8nbrX22VycVdDNQ2r3W49JtnPvTUIQPFTi021NioEIuqUgAgANub/ATP
         fwXRrbMv4yyccmcpOGPeXcj9T+ix2XENjrW1q0xryApdR3imSR6eEzPLb6YW5Qg9fb2c
         zbiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709312857; x=1709917657;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=r7FDDAQs7CyhL99MhjUm4iQ4lgVkaSlCRfPuDt5e4a4=;
        b=hx5kwj8sruwE7v/O0yZlX/R86+7btWYagBVQrEQSZ1vc8h/NR27nPrLP2GaTTuBd5i
         JmcQ8PV9I3l3jDfS0xA5TzfwFwBJxn05uVd3ocwaELGctXa7tjV07uYoO3MitvGKWYw9
         mKYvObd1JUagGaiqxLbAVFRh+H4bkCqsyp6rUTlNuaKf0AlPHaYx1jIlWyda34u72tUq
         p8DEDH6VARz2Z0buGt7k76ppqK0ZqsPbetErs9BQ0h1B1KnHOiPA6yCtBvc6f2kRSj3r
         mmR/OnBaPmOXFlfU0RKd0eaRX46dWQN9usCBN94mZuof0QFqcGPmoHnII8oA6vRPMcRR
         Lzrg==
X-Gm-Message-State: AOJu0YzXr9bKYFBxZGU3EHaB1UzWuZnTsfbaPhbwALXsWmKnHvjwlQN9
	78P3dVjnvrkPhwja9hK1xD1pDttLRyTQ2/r3mfx9+0DswJGy6YlPg5j3ZGgl
X-Google-Smtp-Source: AGHT+IEomoH6SMUSFec5q/Z9Ack5Epg8D/shrkGca3e1Ju1i7nFn3pkgTQsB9IEaOY/fBy+jWCDjDw==
X-Received: by 2002:a05:6214:16d:b0:690:4deb:3aa5 with SMTP id y13-20020a056214016d00b006904deb3aa5mr2314122qvs.42.1709312857199;
        Fri, 01 Mar 2024 09:07:37 -0800 (PST)
Received: from fedora.phub.net.cable.rogers.com ([2607:fea8:79d7:c400::557b])
        by smtp.gmail.com with ESMTPSA id nz10-20020a0562143a8a00b006903af52cbfsm2067261qvb.40.2024.03.01.09.07.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Mar 2024 09:07:36 -0800 (PST)
From: Donald Yandt <donald.yandt@gmail.com>
To: netfilter-devel@vger.kernel.org
Cc: Donald Yandt <donald.yandt@gmail.com>
Subject: [PATCH conntrack-tools 2/3] conntrackd: use size_t for element indices
Date: Fri,  1 Mar 2024 12:07:30 -0500
Message-ID: <20240301170731.21657-3-donald.yandt@gmail.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240301170731.21657-1-donald.yandt@gmail.com>
References: <20240301170731.21657-1-donald.yandt@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Donald Yandt <donald.yandt@gmail.com>
---
 src/vector.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/src/vector.c b/src/vector.c
index 7f9bc3c..ac1f5d9 100644
--- a/src/vector.c
+++ b/src/vector.c
@@ -23,9 +23,7 @@
 
 struct vector {
 	char *data;
-	unsigned int cur_elems;
-	unsigned int max_elems;
-	size_t size;
+	size_t cur_elems, max_elems, size;
 };
 
 #define DEFAULT_VECTOR_MEMBERS	8
-- 
2.44.0

