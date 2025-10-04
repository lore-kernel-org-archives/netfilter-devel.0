Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCE8825C6FF
	for <netfilter-devel@vger.kernel.org>; Sat,  4 Oct 2025 09:29:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759570155; cv=none; b=GsPnIt4Yp+swLnKRquyE14ZvpufvrXGsXbCIK4uK4BJtp/1+I0N4Wq2uNHUWuMpQkTTju5w8lxQJB6QzuauyXtK34D2ClJBOx9W/aGhCo7o4eu1J5ZxeEEV2qtCXkVb8TsGknDElsP19gTbRmDwJxol7jsE/xTJMq7AJCJcwAOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759570155; c=relaxed/simple;
	bh=l+uy5cjIGNHFZp7ojgiPg4JBAN4d7AGEYOsVjprbRj0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Rcf5KoGHirKRxHIDFQef99zqHjCOUF9LCYv0/eTEaXwjiP92ioogBY3GgxVKWToBFRdfvMdHm9kKh3fKH/xElYIJfYF3EvFc9oKN0/2TBikkrgeK5f8Wv4wDJsHzV6Aze+nqIOD9slSMdJyfuYnQvqPf2gpk+ebpTBvlGFlyF4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=e82Mtath; arc=none smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e82Mtath"
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-57da66e0dc9so3121793e87.0
        for <netfilter-devel@vger.kernel.org>; Sat, 04 Oct 2025 02:29:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759570148; x=1760174948; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aDZy7gyltA5nvziKiaq8v1uoCiju+qaCyeScIQp8JQk=;
        b=e82Mtath322fAHlZjgmTrsFPFxlpjLBzCPxEB20yB6EYB0b843DKU36KxYUjCBn5Bj
         BbAxVGuXPlImSFB/gTBPEqo9xn0sgBnott0Hs5mgP7ug+ROeEcazL8Q0+NNH9yp+qb8M
         Wc47OVwzJBwd6dMkWna/XcLfPzDSSPYGqzJ2frnnOjVv/YhU7FLU/zOSdaU9Ktg4IV/0
         5WsVGWfeKptjnXjZH/KajIogFrzOkCrI+fBPIrb6/V+buqS4TjdkBKCBbJWvYSaI5/Cl
         Sek92GiePd8hsWlEeCCSMao8wJd8JqjgFK46tK39E/VVtOzI6lfuSRjLWP/QFAU6tupQ
         3QlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759570148; x=1760174948;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aDZy7gyltA5nvziKiaq8v1uoCiju+qaCyeScIQp8JQk=;
        b=Y/6GyEXTTkgGFuv8+t8N9iBaD3qZG+U6X2ZsCpZsSQJZ0onMvEsdCYfTCIYCAj2Vko
         10rLdQbzXsbbrmBab2UnsS74Iml+iMGFzBR4kC2qP4eTCAxLLqdWh4ATGg69D5qN6dtl
         Mr43n0vncwVckTa/SXy5lnRgbkiSoJ92hWdBWRJEru2wc/h3p5+YLTFXphjNrLeoR/a/
         pHNbuP7zFO7gYNR5hN+cGDjmfmZwvXBIr5sJc0xZb/h60B/9JW2+9PM2X3DrhucMcXt3
         8j0isiQYsWyGf3gLVVcwjeP3xhIAV5CXAlqvi3cS4SATkjhyYMmNcqqGgfvWCZ8F+zk2
         MpXg==
X-Gm-Message-State: AOJu0Yyjr7N4WL3Xae2h3WGA9aoUam77RsKuSd7SeJUyWCPcgaXOLX1+
	2eKCSGCv2WDMoCX9SbCjwbCEBjjL5Kz21t241mjTcjZaebafjsb0d2akKAkYLgiA8YGG5w==
X-Gm-Gg: ASbGncuVczbk2+1/w0ygQWl/g997hXfy54ceLPty+WOYI+KaNPoMFXIBnlIXPyFosv0
	WtjhAg97nk5WxUvjqb1UsfzlVsXS0NuUi+azhS7N7jCuBrlQwME6Renb5nFvUkJRxXbHgGVSi29
	AV+hrMSWQFGHGBHyw92SACa+bx+FqfW+AkA8UGKBmwOzKmTW63Vswy9EP9qKyTX78CKUphig7sc
	V1ATfh8Dgqzosk9+VlBP0KlryfRapcSiPWcSYBDzzrOuImujTP1eoSFgjwDHvxBDzAlIvVw2ebp
	4kuTrLbuZc7Be0Lb5XR+ymjwtm4Foe63O1FmyuUhKhzTD8Xz2u2wezL6aIGwXvA/Nbf+EZt0LXZ
	6bQqAmGxbZ7KybOoB1Q0UhxZmZ09dWokd/ueMjrafB/NN6JfnIWguvj+nWuJAL9/jgBT7wclWE4
	1FeNucIOEx7rKnTna7PQuPx2j/SRph
X-Google-Smtp-Source: AGHT+IFUBtiub5LvozUjGH1F+d4NBSTHgCXkDapqGcChdJopVl0SbWH5mUnyognY+6TkY4AWssNBng==
X-Received: by 2002:a05:6512:e8d:b0:562:cd0f:bddc with SMTP id 2adb3069b0e04-58cb9f09e1emr1571470e87.20.1759570148397;
        Sat, 04 Oct 2025 02:29:08 -0700 (PDT)
Received: from pop-os.. ([2a02:2121:347:bd74:5730:2ad2:716a:41f])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-58b0112463bsm2692261e87.2.2025.10.04.02.29.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Oct 2025 02:29:07 -0700 (PDT)
From: Nikolaos Gkarlis <nickgarlis@gmail.com>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org,
	fw@strlen.de,
	fmancera@suse.de,
	Nikolaos Gkarlis <nickgarlis@gmail.com>
Subject: [PATCH v2 1/2] netfilter: nfnetlink: always ACK batch end if requested
Date: Sat,  4 Oct 2025 11:26:54 +0200
Message-Id: <20251004092655.237888-2-nickgarlis@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251004092655.237888-1-nickgarlis@gmail.com>
References: <0adc0cbc-bf68-4b6a-a91a-6ec06af46c2e@suse.de>
 <20251004092655.237888-1-nickgarlis@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Before ACKs were introduced for batch begin and batch end messages,
userspace expected to receive the same number of ACKs as it sent,
unless a fatal error occurred.

To preserve this deterministic behavior, send an ACK for batch end
messages even when an error happens in the middle of the batch,
similar to how ACKs are handled for command messages.

Fixes: bf2ac490d28c ("netfilter: nfnetlink: Handle ACK flags for batch
messages")
Signed-off-by: Nikolaos Gkarlis <nickgarlis@gmail.com>
---
 net/netfilter/nfnetlink.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
index 811d02b4c4f7..33acc1b94a0e 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -600,6 +600,11 @@ static void nfnetlink_rcv_batch(struct sk_buff *skb, struct nlmsghdr *nlh,
 			status |= NFNL_BATCH_FAILURE;
 			goto replay_abort;
 		}
+
+		if (nlh->nlmsg_flags & NLM_F_ACK && status & NFNL_BATCH_DONE) {
+			memset(&extack, 0, sizeof(extack));
+			nfnl_err_add(&err_list, nlh, 0, &extack);
+		}
 	}
 
 	nfnl_err_deliver(&err_list, oskb);
-- 
2.34.1

