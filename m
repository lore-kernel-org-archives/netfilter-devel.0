Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3934140E38
	for <netfilter-devel@vger.kernel.org>; Mon,  6 May 2024 23:17:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715037446; cv=none; b=dPvCIhI8V+wHdXp1YZxlrijdrSGGM057WiRyTW21q4rgBz18qqhVAGyTHH8P2NkoXk0tqFp1409poAqt0Xz9GvM6baCoCckoFZ08dc9cdp+OLAOLJUzJRuPAx2VOXanWxQQiUODkWrNxfCZ+m3J8hPIjaFxIiopnI2ezEjhbAm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715037446; c=relaxed/simple;
	bh=afYeomoeVUi5AzTHoHPuHBX7AndqR3knC0YXvy6yHRo=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=o3gUEa5N1Zh9hlb/c0paaz6uFCGPUkvb+8aWgW3gHV6W/NeIrlhjssf/Fn+OylaeBmyBYCvL5JUlciIO7DUR3PpYguwMupmPIZDyzMUt6LJqfok4i3/0RGqn+uEzLbYZVqWacsEx6vNVw1XAxvHbXOumXQEgwC5Y/lX8ybrI40A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KVLKRjtI; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KVLKRjtI"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-1e9ffd3f96eso18268665ad.3
        for <netfilter-devel@vger.kernel.org>; Mon, 06 May 2024 16:17:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715037444; x=1715642244; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=AqVJaq0nOm+dPPBayn6/vBke4dNnqxMaLsI5mUI7WkM=;
        b=KVLKRjtIAvzpjz3nBWy6ELkQHN5W8hX5ZPa/CF5/M2zWha41ALZkxV81MNzTE/M6Yx
         th8XH4VckT0W76hjxsapVHdlzVm1rtWxeij1giX61gLyKpgM2Tqg3RtX7TPQbCYZGR0v
         jLkAtm+ea+bTBGsOj86lQUdKiqM6Hm8pcfGEpF3MX+Paxq9OhXm+xxdJoJOpn5dOt5SB
         NaBko2uRDZEQGdS0D0iEZywHq9j0b87frIxNP5/tBg9Yzv/yiGgHzOWMtFNkYkLlnZ1n
         ZijzsgChP9t00rtjLNCG3RrrOhI8Fu74wYqHi6iYE0adBWiACLx7zcWvYPeiF1epdRDc
         pn/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715037444; x=1715642244;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:sender:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AqVJaq0nOm+dPPBayn6/vBke4dNnqxMaLsI5mUI7WkM=;
        b=K5b4ZhV45t1+bOfXvR74WuK2s/mNCAoK/bEoDUJ5B80m5JMi961klCgYJctoRwMiys
         wsq7AVxrla01dKy8QEINKdpV+HnOV8MW7vqrESvWDclStx4d4WcsKRw1IaD01fAn+8o+
         v7JQuWuifEv+tubOFtmlkGddT9Z+y4y6j1nfFV3aFBzaqsdFK4TXLkVl0KyhW73U11rD
         81g9+4VnuWcR6acU5YghnwqODE8BMNnlN4kr9TCXv2unAaGS8ifDGQZ/ET3ZJBdmCtLW
         cmWIxKBMoAfT/jij771S+uC/H1yACg/ed7JIjTmNgALeVR1Tl2sZls29l3FPBMiYowQf
         D9WA==
X-Gm-Message-State: AOJu0YxLIOs+Px9UPNNGlGmQa2Gb1YUVlup0jvxOrTFFFS2YR6lBCnG8
	YRcMFg/re3Al9UX4UMnudPC/6xea8z+1k33+9j2li+GvAUy2B5G6cHwuUg==
X-Google-Smtp-Source: AGHT+IG4ibmMlBQRfupmyx6s/zFfPpUbY72hen+2AhALvqrfnt7z7qPOTSDZ8f8j5DbJ8Db4JJECeA==
X-Received: by 2002:a17:903:264f:b0:1eb:bc78:1ef5 with SMTP id je15-20020a170903264f00b001ebbc781ef5mr8975805plb.17.1715037443618;
        Mon, 06 May 2024 16:17:23 -0700 (PDT)
Received: from slk15.local.net ([49.190.141.216])
        by smtp.gmail.com with ESMTPSA id ix2-20020a170902f80200b001dde004b31bsm8819799plb.166.2024.05.06.16.17.22
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 May 2024 16:17:23 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From: Duncan Roe <duncan_roe@optusnet.com.au>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue] Stop a memory leak in nfq_close
Date: Tue,  7 May 2024 09:17:19 +1000
Message-Id: <20240506231719.9589-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.35.8
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

0c5e5fb introduced struct nfqnl_q_handle *qh_list which can point to
dynamically acquired memory. Without this patch, that memory is not freed.

Fixes: 0c5e5fb15205 ("sync with all 'upstream' changes in libnfnetlink_log")
Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 src/libnetfilter_queue.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/src/libnetfilter_queue.c b/src/libnetfilter_queue.c
index bf67a19..f152efb 100644
--- a/src/libnetfilter_queue.c
+++ b/src/libnetfilter_queue.c
@@ -481,7 +481,13 @@ EXPORT_SYMBOL
 int nfq_close(struct nfq_handle *h)
 {
 	int ret;
+	struct nfq_q_handle *qh;
 
+	while (h->qh_list) {
+		qh = h->qh_list;
+		h->qh_list = qh->next;
+		free(qh);
+	}
 	ret = nfnl_close(h->nfnlh);
 	if (ret == 0)
 		free(h);
-- 
2.35.8

