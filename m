Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A68181922E6;
	Thu, 29 Aug 2024 15:48:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724946483; cv=none; b=ItZyQx5onZi5gC5La8gEk3sEJM4xh7AFJyWeGRReEaVPLME8RrpbbIWeg2QWxhOXQhwAKg3y/+1ivWVoXY7JshF9EyuRLtMFd2xtAD3jnhv8iTG+gBUdYxuO0m2DhIJV7ykwMVLhXZiO2Bp/vPcCuSqstkV/e/SkGe3zFKc8Ck0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724946483; c=relaxed/simple;
	bh=nzRGf/HrfmWsavqKa7l/dTAqrBmmjpFAp0Jlj+w/RBw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=niZbRRamUmwmjIpAp8mVBe2OsfMyHy6emrx34WZnIwTAHqu8QzZMX5F4V0FT0MhBzl65pTmgaN8QzMqBB4m7Lw13Lm2V1T2xOMXP3ZFZ1xSlKMhkb+bNMnz0o/x1RI4pXbzDgLyUGjVxz25yLeZIO+KYCtDr/9LrxCK/qvEBbnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DlYanXxg; arc=none smtp.client-ip=209.85.167.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DlYanXxg"
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-53345dcd377so1038298e87.2;
        Thu, 29 Aug 2024 08:48:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724946479; x=1725551279; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ILHxn7lRblRkiK0Gc7r8TIv6Xv3i9rztGnbYfkb6Dug=;
        b=DlYanXxgR7Sm02146l9KbyR5K8SiJSOFoMO1j6RNilEs7QsUykgRtx/nEHDz1FmWD0
         1KIdcbX/t5Rw/pSRE41lrBYUQskv9UdH1tj9thsE0HHIW0cGgcE073gTaUhSQOG98fqy
         xteoa61lwZL/5ipgx0g7Ns5xsXRgF5LoThqyKlC7/4RyXv4xyeW/+50vs08XcWpCb6l9
         7u7hDnykjb9gf/H0iHm8tePnHAO15QOEbwIobWRqQm4NefkZhPUfZRMiguK448g0xMb/
         7sZrUIm85nUIxaF/hdKwZ4PTfF/Zb/bzRKI4QpdjajTQew3qocCY72ZPOvMXkNjYjvpA
         onCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724946479; x=1725551279;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ILHxn7lRblRkiK0Gc7r8TIv6Xv3i9rztGnbYfkb6Dug=;
        b=ME28Hg0WgYd0FlnaT+iDFgCjZ8kDQ9v8sA5RFADQ5trG79wGFUdaHNcdkeg/hJkaDA
         xwDJvie/Lgi0sTZIEFjBeAtEvOx7oU5sHGBACM+LwRR1Eqh3N4EloWUhchk9VzxhHUGc
         MOR9+SN/iKDcPrqu5j1BdwXNACSfku80sxD6YtcPAt6bDpDcdUT+Bak5PHwrtKPBvef1
         2ChWit/FQjL6Uub3E+1A6Nj6r1bJ3DpbbxIwk399PwUINngemHGdZ5yQAdtC3lFif5J7
         RkAsTtPWt3pj35OnjCqMVNdI+C7P5sgCzSzJyeqotdcQ+RoaI2/NLBon5RZOeH1B+xQ4
         X9Ug==
X-Forwarded-Encrypted: i=1; AJvYcCWv+RMTdX+5Yeo8TWuasvBalJ+a811Rhe8z3e7QQ0Jfjy3X0mjTnGeF7HFOLmYoehvh/zglecWh1tKMJNk=@vger.kernel.org, AJvYcCXWrxq73omEhjaNEJ3i4OjBLZEhwTWL0wfziu8AmrPVeZftGwd5YtpDdzM/MixFKyzCjcI3dJA2@vger.kernel.org
X-Gm-Message-State: AOJu0YyaPXrE8eR1zFby1c5QL/cyDW0RUq2pLbduWcTdugfZJh6xn3Fl
	Ukxkohu8Lcxe9puJI9Oc4V9Yf//1xOx6BrsLWksy8YtQSCsnZlHoNRlj7g==
X-Google-Smtp-Source: AGHT+IGqi3tSnb4woeE4WPzxGfww2qKwIoAtHvtcT5uNNapseAZNZ4VcqKsxu3Rdp46UFcHwraNPfQ==
X-Received: by 2002:a05:6512:2807:b0:52e:be84:225c with SMTP id 2adb3069b0e04-5353e5758a9mr2127153e87.33.1724946478517;
        Thu, 29 Aug 2024 08:47:58 -0700 (PDT)
Received: from localhost.localdomain ([46.248.82.114])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a898900f29csm93489466b.64.2024.08.29.08.47.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Aug 2024 08:47:58 -0700 (PDT)
From: Uros Bizjak <ubizjak@gmail.com>
To: netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Uros Bizjak <ubizjak@gmail.com>
Subject: [PATCH v2 1/2] err.h: Add ERR_PTR_PCPU(), PTR_ERR_PCPU() and IS_ERR_PCPU() macros
Date: Thu, 29 Aug 2024 17:29:31 +0200
Message-ID: <20240829154739.16691-2-ubizjak@gmail.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240829154739.16691-1-ubizjak@gmail.com>
References: <20240829154739.16691-1-ubizjak@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add ERR_PTR_PCPU(), PTR_ERR_PCPU() and IS_ERR_PCPU() macros that
operate on pointers in the percpu address space.

These macros remove the need for (__force void *) function
argument casts (to avoid sparse -Wcast-from-as warnings).

The patch will also avoid future build errors due to pointer address
space mismatch with enabled strict percpu address space checks.

Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
---
 include/linux/err.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/include/linux/err.h b/include/linux/err.h
index b5d9bb2a2349..a4dacd745fcf 100644
--- a/include/linux/err.h
+++ b/include/linux/err.h
@@ -41,6 +41,9 @@ static inline void * __must_check ERR_PTR(long error)
 	return (void *) error;
 }
 
+/* Return the pointer in the percpu address space. */
+#define ERR_PTR_PCPU(error) ((void __percpu *)(unsigned long)ERR_PTR(error))
+
 /**
  * PTR_ERR - Extract the error code from an error pointer.
  * @ptr: An error pointer.
@@ -51,6 +54,9 @@ static inline long __must_check PTR_ERR(__force const void *ptr)
 	return (long) ptr;
 }
 
+/* Read an error pointer from the percpu address space. */
+#define PTR_ERR_PCPU(ptr) (PTR_ERR((const void *)(__force const unsigned long)(ptr)))
+
 /**
  * IS_ERR - Detect an error pointer.
  * @ptr: The pointer to check.
@@ -61,6 +67,9 @@ static inline bool __must_check IS_ERR(__force const void *ptr)
 	return IS_ERR_VALUE((unsigned long)ptr);
 }
 
+/* Read an error pointer from the percpu address space. */
+#define IS_ERR_PCPU(ptr) (IS_ERR((const void *)(__force const unsigned long)(ptr)))
+
 /**
  * IS_ERR_OR_NULL - Detect an error pointer or a null pointer.
  * @ptr: The pointer to check.
-- 
2.42.0

