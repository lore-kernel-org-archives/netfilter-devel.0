Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD39E19CC0D
	for <netfilter-devel@vger.kernel.org>; Sat, 12 Oct 2024 23:09:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728774586; cv=none; b=kcKGDDduWka8gKyd057Z+82uO2eQ0C8NNdOzhIO0MSEmmYCis7CD17C8g/O3x0wwFpMhnLgs5PjexxBFjHvAcqVoOdiHrJjOHNbFvo9PTlg7i3XEs4ds/YT4CdDgGvz4sHGIIVffFJycoE6zeZyaRhBO+7PaNU1b56wDi3tIuUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728774586; c=relaxed/simple;
	bh=VSeh+0I3/uWYuPZ4VgK9pWvjcgfWjhwgyxtSF+Anm00=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=OgeIbXI3pQ1U50dYEHD/PliDHDZNr+rrgBk7y/7KTvVMk+Cd54ui44h7T5OfCbnCYL8ib3H8Ic9dM1F2ke+cN/STvThx1eyvJEY/ScqOn8+qxuhnZqDd6UwQaq4VC+0vxyYJbxbscCLyO/HS+bmJiZd534mSJd9PDSdeIfMo2N4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=al2WSQIG; arc=none smtp.client-ip=209.85.215.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="al2WSQIG"
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-7d4f85766f0so2426741a12.2
        for <netfilter-devel@vger.kernel.org>; Sat, 12 Oct 2024 16:09:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728774584; x=1729379384; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QYBSHXrCIY0jb4GK7o9ta9PaRYW/4Y6KgplyD2PflqE=;
        b=al2WSQIGE9ln4KOBhPu+Ahc4qZslEYZ/HQbUHOS2VPwwlD6NcdnkOYr03o9kNI7afF
         U0CUvzmZ2LDc7nbwZg/KTzwNl6rA0TwljkDOQ/Pm37rT0wWtW/7NgHX/ZPWGT3z85qWY
         CxN82c7ngUrnCwxbhdFYXu/dTVxQlfYWzn4YxLxNMHA3Lfyd/8sFJcuAanBTu/AlRmny
         RVBqM0QHW7jAv9wD6BJdVst7XuXnQnh4zWyHYQyNvfuiUrt8a3Qi+smondp3D2RenxNx
         bm2B5BBOwxaK02gzFPG6gfq+vvjGqwmu7+fZ23MDEirePPeJxG3Xab2xtPSgX6Ha5KWo
         mjcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728774584; x=1729379384;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QYBSHXrCIY0jb4GK7o9ta9PaRYW/4Y6KgplyD2PflqE=;
        b=C7DTmXw84mjOoSvrmzfYiF/OFqIcE0MhulR/p7oc8bmeqDhWCs1lUX8tFuzEaj1/ZE
         +oF9awsz3NGH3IsleKk6rryd7xt1NaM8cjGOdzgTboYu1qLFNH4AjjcOHrLygNXm17Rb
         Sa2qXMp8vyJEFQrxnr0aeV/TOWkLQNzExmiFxtBbNhdAOKei5VMbjLrwCQ/QG/mqxIjB
         yyy8JHseU40weu6ZFp2OHJvyogJ0BfwRvWoM7V0cF0+vNTvbSxIykwN9FDs2W398x3zm
         GIvH5Cp81H5A1HyHkxwfJOeuDFTdP7qPwRhO6lOOZ4TAJqOmGqtxZNDrpZFUaqKtnpIo
         1OGw==
X-Gm-Message-State: AOJu0YzD79Waes4TDtU3bPYQPP/8SKJra4LW8Ev7zaNLOJ6KTQiJsoKW
	DOlWRASurNZe88X5vBi64/jQIs4IvvzTci1lsQSQwrdhHQP+fHtc
X-Google-Smtp-Source: AGHT+IEivvYHpE4wVVMB9P0Wrdu2V/nnzc0h0+FYZWs1OLkObZ5F5LuhF3htLMFXPe73HgVfpBZuMQ==
X-Received: by 2002:a05:6a21:2d8f:b0:1d8:a13d:d6c0 with SMTP id adf61e73a8af0-1d8bcefc67fmr9176282637.3.1728774583708;
        Sat, 12 Oct 2024 16:09:43 -0700 (PDT)
Received: from slk15.local.net (n175-33-111-144.meb22.vic.optusnet.com.au. [175.33.111.144])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71e2aab5bf9sm4854195b3a.145.2024.10.12.16.09.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Oct 2024 16:09:43 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From: Duncan Roe <duncan_roe@optusnet.com.au>
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue v3 09/15] src: Convert nfq_fd() to use libmnl
Date: Sun, 13 Oct 2024 10:09:11 +1100
Message-Id: <20241012230917.11467-10-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.35.8
In-Reply-To: <20241012230917.11467-1-duncan_roe@optusnet.com.au>
References: <20241012230917.11467-1-duncan_roe@optusnet.com.au>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

struct nfq_handle has a struct mnl_socket * now, use that.

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 v3: rebased

 v2: rebase to account for updated patches

 src/libnetfilter_queue.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/libnetfilter_queue.c b/src/libnetfilter_queue.c
index f26b65f..8a11f41 100644
--- a/src/libnetfilter_queue.c
+++ b/src/libnetfilter_queue.c
@@ -377,7 +377,7 @@ struct nfnl_handle *nfq_nfnlh(struct nfq_handle *h)
 EXPORT_SYMBOL
 int nfq_fd(struct nfq_handle *h)
 {
-	return nfnl_fd(nfq_nfnlh(h));
+	return mnl_socket_get_fd(h->nl);
 }
 /**
  * @}
-- 
2.35.8

