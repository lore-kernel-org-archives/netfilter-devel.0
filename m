Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8DD718657
	for <netfilter-devel@vger.kernel.org>; Sat,  2 Mar 2024 16:08:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709395689; cv=none; b=p6dSkrm2d1NTpR5HvPhzxGBuk+YDgJCBTnK2QRAaEG7z6lfFskofabRXuCt4R67lqwSm5CoaXTCZRauGuyle04u/9WsaB80IcUz6ZGFi8mZxk9csesiCYZzy8KekrjqFfo78+UIDMgOfo172JOTGq8iAEIGVrBm+KUbb0JXegtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709395689; c=relaxed/simple;
	bh=nYCHWCPCn/OphHGIRxH01eJIpG6+9P6I1/QlBYarjSs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jmKniaE85GL+HJAXtPHKApPZqawL4Us9E71KRK2c1FJl6tuQcTQHqyNTUgGY6uh/7yBzReI5Q0Z4Zel4OdT0GuJBK0YhItZFMUxRKa8aiqpH1ZfWRFE4++AaOCkwtnQjrHARisgV1RkikCdVmtY+II7c2i91kEFEOUjoe+P0xWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ORBHmcnq; arc=none smtp.client-ip=209.85.222.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ORBHmcnq"
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-787b5c68253so159249285a.2
        for <netfilter-devel@vger.kernel.org>; Sat, 02 Mar 2024 08:08:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709395686; x=1710000486; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NRCh8cjg9oSwKuQ4+qpZhpQGI8pANi6cQHz8HfOUDgI=;
        b=ORBHmcnqkxJL7bRFg6oFm/nMW/ixGV2x1lqTMHjqc2z4DBTmN1vOnbxiR5k8R7AsA0
         WkiN91t9uxu07P/tXnN0k12ofUhmA1h6aOlr0eg7N5i/FpTQSiNeWAtXw9qziwpOKiEF
         bcig3sfeA9nIC9GiNCsitdHCo0jPK1fZ4/zqt7BvLM4379M3p/5zItxc7iPAJBOWD4kz
         LL1VjfSNrD1bRZRYEUtnHWdYHSEidDEXQZvJoUbLnCOwhMVM3qDoDU0DpHUfnL6L+Gmk
         /OobKseJTT3j5G4s9OZQOn9rP9KGwcU0RpZ4XdyDryIh1nk6S1OOwLS3vASUMOmRDmB7
         mCZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709395686; x=1710000486;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NRCh8cjg9oSwKuQ4+qpZhpQGI8pANi6cQHz8HfOUDgI=;
        b=qKY227Nn9bl5w36s+GDryXhef8zHpITGMJqxUpPu16yqV6sAiW9cOTRU/UfKmSgUjZ
         YoliAlIkr5HsQVL13Fm7r7s2oBfWzcxcaxyzVkO98i9bvNECOFYv4XCs8qRW1ptMlajm
         3atCflccND53oEgB7g/Jb92PdmXeC+lm/Uwumd8HLe3CSz2PzzZEg9vv6m+tq6oO8Z8i
         KHDvFoF7fNBynswON4Z8049Bkr2sX9YJOCt21gh+dlktyu0/vDI0lPb38BkgpbdkxCIo
         DLHOq4fXatKZt3R0cy1FyRzMOgTUpHTUqpLExr03cFngCDyb6ANeAATU38QdwJsheHb3
         zK8w==
X-Gm-Message-State: AOJu0Yzd0d/TQ1M6NVMO+c7GQwFtvwp1OjQFpRGBc5h0NrTunN5zysKV
	2XTvucDbyGEuQBSWoqlCShB+s/UpZ/9ZQOPa5GMIPGGC655kMHI8X+Qb4M6J
X-Google-Smtp-Source: AGHT+IET5VTRFmmIYn0m9XRhmd8T6NDodZ8XM+4rAm8pQtEzQXtOWrjOtCjoAEEHQgbd3TLVKXUobw==
X-Received: by 2002:a05:620a:1673:b0:788:1887:7621 with SMTP id d19-20020a05620a167300b0078818877621mr2509824qko.76.1709395686515;
        Sat, 02 Mar 2024 08:08:06 -0800 (PST)
Received: from fedora.phub.net.cable.rogers.com ([2607:fea8:79d7:c400::557b])
        by smtp.gmail.com with ESMTPSA id k1-20020a05620a0b8100b00787c7c0a078sm2666118qkh.121.2024.03.02.08.08.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Mar 2024 08:08:06 -0800 (PST)
From: Donald Yandt <donald.yandt@gmail.com>
To: netfilter-devel@vger.kernel.org
Cc: Donald Yandt <donald.yandt@gmail.com>
Subject: [PATCH conntrack-tools v2 1/3] conntrackd: prevent memory loss if reallocation fails
Date: Sat,  2 Mar 2024 11:08:00 -0500
Message-ID: <20240302160802.7309-2-donald.yandt@gmail.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240302160802.7309-1-donald.yandt@gmail.com>
References: <20240302160802.7309-1-donald.yandt@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Donald Yandt <donald.yandt@gmail.com>
---
 src/vector.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/src/vector.c b/src/vector.c
index c81e7ce..0af8db7 100644
--- a/src/vector.c
+++ b/src/vector.c
@@ -60,13 +60,16 @@ void vector_destroy(struct vector *v)
 
 int vector_add(struct vector *v, void *data)
 {
+	void *ptr;
+
 	if (v->cur_elems >= v->max_elems) {
 		v->max_elems += DEFAULT_VECTOR_GROWTH;
-		v->data = realloc(v->data, v->max_elems * v->size);
-		if (v->data == NULL) {
+		ptr = realloc(v->data, v->max_elems * v->size);
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

