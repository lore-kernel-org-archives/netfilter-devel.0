Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB4454C73
	for <netfilter-devel@vger.kernel.org>; Fri,  1 Mar 2024 17:07:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709312859; cv=none; b=sCziQa0MgOslDiPW7D80dGYyYDJbcbT66nW569/AKaM3f7BHzWDhW3Sb61wzsm979SGaFoY/Dlyh86L2LhAooK7Xzi4F6umSNOLNCHiAXNzgpwswKhVtPs76Ywj5XwbH+OYLRdyVNEyR5kBgzD3IFqQaE9/mjgWCLqRSTGKHqGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709312859; c=relaxed/simple;
	bh=qxycGf9cV+Fevieb640Yb4IK9R1rNs4Nwz9aFSUf54Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lcArljzGQMyMeg763QdrPKksymta8nHB8zyaAUHtJAmjDRqymr+rzkcX48GfdszwMQyqeShB/mG1N9jEyu/deosCOoDmv2MubGN0P51IyyWK2/HM0g3M3a4zYOaVBRoXS5gwXh4u4n7T44CHUyxqNpCaSQzn+MUpcmzLTPMgNME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ci6NcWJf; arc=none smtp.client-ip=209.85.219.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ci6NcWJf"
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-68f748cdc8bso9186276d6.1
        for <netfilter-devel@vger.kernel.org>; Fri, 01 Mar 2024 09:07:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709312856; x=1709917656; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b2n++Gyc4lpvFWWf25Ciddk83tP1mkE19bu0c+xErAE=;
        b=ci6NcWJf912wXE4YayCkyRzRtxRD0iD4ScqOBNwKHuthKyFZ0iXRt9toiW9ONUFWle
         uJrEXy+C+5SqKu8AcLd4EIAPKnifKrYHP2afPaMB8oK9iRqCNE6xrjdNEfawVQpa1YEk
         zVokJhw1WTuq343mG8UkjJ6oHBozMDiA2RktuT4sika7Rot4Q0gfMsqEgsfmGouKGD2R
         HOcUJd18Za6iWlaoXG8/+w+tKU458/XSLHlc8+ycJufKZhR2okTg6YMJv6mFXd60OFBX
         MuqA2xAcdM+1ARxpZFERxjIq0Faa+Cjhr2Qr0Ne6QM/2mDesub2xTTUdLxFQo7SgJYUj
         /TbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709312856; x=1709917656;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=b2n++Gyc4lpvFWWf25Ciddk83tP1mkE19bu0c+xErAE=;
        b=MeILcQs+ricTHWCv+t/3h62Lft5BOSkhCNk9RIcmiVUD6R48YXyVodZwbkG5y/sSyN
         WsQrxBGKeGFC8xjWSr1rUubqctbb9ZUVia2CoueXdYKX63MJOyhOJbFt9Hdt2kTVj1x0
         okhBRcaz9x/ydv6oAvEqawqm/I94nBOqmPHCC0OnwTTppZDdU7F5dlqD8NibN5hQzzID
         9p+A8wWK6vHiIG9SXi54JAoBah9mIkFVDBHXo4wkfFpSeP3sTcf1Xiyrzpxs2la6lrc8
         mapsYnDqlW9nF2vYHzhQJxbpzFLOlb+pOnY4/W79kVlNqsWV+iG8fWhIGnl2HSPbevbJ
         7+uw==
X-Gm-Message-State: AOJu0Yxr7SnDaI67B76g2AjQngw84Ed748uTKCIHyI7NPwILg/YUYs9y
	fB1OicH79dy1O3iq+DsQze/5rPFVyiMxqksrW9xSYE2zUIJyQvumHsMh+JDn
X-Google-Smtp-Source: AGHT+IFIOfLp0X4ql7Zz+0PBKb0bT/YCiOen6SzUQ7FwAhoszR4igNTeSsA5rNDIlMm08JVl4/0VYg==
X-Received: by 2002:a0c:e086:0:b0:690:5589:8348 with SMTP id l6-20020a0ce086000000b0069055898348mr2247939qvk.26.1709312856349;
        Fri, 01 Mar 2024 09:07:36 -0800 (PST)
Received: from fedora.phub.net.cable.rogers.com ([2607:fea8:79d7:c400::557b])
        by smtp.gmail.com with ESMTPSA id nz10-20020a0562143a8a00b006903af52cbfsm2067261qvb.40.2024.03.01.09.07.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Mar 2024 09:07:35 -0800 (PST)
From: Donald Yandt <donald.yandt@gmail.com>
To: netfilter-devel@vger.kernel.org
Cc: Donald Yandt <donald.yandt@gmail.com>
Subject: [PATCH conntrack-tools 1/3] conntrackd: prevent memory loss if reallocation fails
Date: Fri,  1 Mar 2024 12:07:29 -0500
Message-ID: <20240301170731.21657-2-donald.yandt@gmail.com>
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
 src/vector.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/src/vector.c b/src/vector.c
index c81e7ce..7f9bc3c 100644
--- a/src/vector.c
+++ b/src/vector.c
@@ -62,11 +62,12 @@ int vector_add(struct vector *v, void *data)
 {
 	if (v->cur_elems >= v->max_elems) {
 		v->max_elems += DEFAULT_VECTOR_GROWTH;
-		v->data = realloc(v->data, v->max_elems * v->size);
-		if (v->data == NULL) {
+		void *ptr = realloc(v->data, v->max_elems * v->size);
+		if (ptr == NULL) {
 			v->max_elems -= DEFAULT_VECTOR_GROWTH;
 			return -1;
 		}
+		v->data = ptr;
 	}
 	memcpy(v->data + (v->size * v->cur_elems), data, v->size);
 	v->cur_elems++;
-- 
2.44.0

