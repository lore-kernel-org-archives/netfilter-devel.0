Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 312E714286
	for <netfilter-devel@vger.kernel.org>; Fri, 15 Mar 2024 07:34:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710488076; cv=none; b=KTtXPlAxkOF/d3RG23N6yTJxDetSGmOVZdD9IgkTc8tCP0GDgB2qxsp/8OkS/U4OhhhHJpyCZfX1pZ3zBe4k+9RD/okiuoY7ZvXZzdDQMELTJO9WPWbS8yjoYiyaBP5UNYVzJQdPNgDWfxamZL651Qk9HmJv/VATkk04jBHGUCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710488076; c=relaxed/simple;
	bh=pyg2RZ7jeseZdVbvFZXDwNvrB+Gyg8hS5EKRU55Irik=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rnU+f5+KAhXLRlnMjUGdpCAn6z4WcfJs54GjZaJPMiVae9puSIjVLrVVv57eS4P2AwBJT2T0m4/O6pOGTirSXyn4NXGgOjRLHBFec/gXqRJ2rAtBYQ/JLxO0TDQrvkxiLZeoSPBvWhEc1vAeire1kyeUytDQbhj/BeVCeGRTHpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ifsGzcvl; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ifsGzcvl"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-1def3340682so1388145ad.1
        for <netfilter-devel@vger.kernel.org>; Fri, 15 Mar 2024 00:34:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710488074; x=1711092874; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8BhOdi0J4smtM5I+aj5htucVrgfeyAqqXrnITo61CzQ=;
        b=ifsGzcvleB+S93oWHxN3x/6XcifMPeGw5ZtsaE2/r7wli1y6TmXkRaZveB3LhUWn42
         hoNbqysCcuHJ7zEogzQphmNDVJ6ogjcs7YKp/GJU8lcg4FlnobPEG0XSkAQH1YFRh6m4
         d2vE11pQFE8+gdhBedkdPtdh0MrJsSwHQ5EnEytg5TKM97Wdgttmjc15glHbSzPWnppO
         5vzmIQj57ju2XJ3jC34ueOUscUZdkQwsivX5TmhbZ/o7GVsZkef3iBB6aUqLYRUtTfS7
         Vf4ZwKlV/y7GiiVT6bXLm+OVzMiXOZ5bsQ3mnfz45x+18kvM6J0PjZbGdjQ6OVKmkfnc
         mQqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710488074; x=1711092874;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=8BhOdi0J4smtM5I+aj5htucVrgfeyAqqXrnITo61CzQ=;
        b=S/hjR1Ol7aYlgMhcLcvPSrFU8F2R52TFDJGff5uuj/zc5U8KP2NzqZZuqr/z7KIlPw
         ur4rxf7e9bUGV+X9VoWkG2q4a4Qz97l/5u/IGIPvKssd8+bS+Wxcn6WuZlciU0/063+h
         7QD0uPickUwZiKkDj/wVQnzKXLo335t3ZurZhdDt94DM7sOshT/pHbrDyyEooS735Jic
         qEIamNd6g0u+VFxisCFOPUgNm09mfMsl4xRR5z9ZSHZm1phMASxgUDvdp49MCX468jnX
         M7JN6gtFKqnT6+Oz4FOEk5c9zvyRrgwgY/14/mvn1KyO+r8yK4PuG7ny2RZsJO2kRVoC
         PK/w==
X-Gm-Message-State: AOJu0YwSXS0s+fGyl9H7vv1zpy6+HmM2Wizr9sxUFuE92xKrHzdzwSht
	HeHPMjidTqtICcWuC/Bj8YiRdRKn8BqJgwiqwqFlxujzCkqWPeTnXnk0VhBf
X-Google-Smtp-Source: AGHT+IF8yjNkeaWsKQRKqH2aIXsIE265mkKNlahUV1i/RcbchsF21NyF3mEyUsVQY/H+wvSa7fPsVA==
X-Received: by 2002:a17:903:2342:b0:1db:35b5:7e37 with SMTP id c2-20020a170903234200b001db35b57e37mr4928958plh.50.1710488074654;
        Fri, 15 Mar 2024 00:34:34 -0700 (PDT)
Received: from slk15.local.net (n58-108-84-186.meb1.vic.optusnet.com.au. [58.108.84.186])
        by smtp.gmail.com with ESMTPSA id k18-20020a170902c41200b001dd75d4c78csm3049142plk.221.2024.03.15.00.34.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Mar 2024 00:34:34 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From: Duncan Roe <duncan_roe@optusnet.com.au>
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue 24/32] doc: SYNOPSIS of linux_list.h nominates libnetfilter_queue/libnetfilter_queue.h
Date: Fri, 15 Mar 2024 18:33:39 +1100
Message-Id: <20240315073347.22628-25-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.35.8
In-Reply-To: <ZcyaQvJ1SvnYgakf@calendula>
References: <ZcyaQvJ1SvnYgakf@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch enables user apps to compile w/out needing an extra #include

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 include/libnetfilter_queue/linux_list.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/libnetfilter_queue/linux_list.h b/include/libnetfilter_queue/linux_list.h
index 6e67b9a..76d24ea 100644
--- a/include/libnetfilter_queue/linux_list.h
+++ b/include/libnetfilter_queue/linux_list.h
@@ -36,7 +36,7 @@
 .SH SYNOPSIS
 .nf
 \fB
-#include <libnetfilter_queue/linux_list.h>
+#include <libnetfilter_queue/libnetfilter_queue.h>
 \endmanonly
  * @{
  */
-- 
2.35.8

