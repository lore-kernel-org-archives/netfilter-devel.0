Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795093396;
	b=MbzEEzAlpltB1HO87atp5i0yx858vClRr1WwOrV/rBTqYI8LGK3rj6Zvh0UpajD31WN3
	 q9lHC2ivDpppGCqgenYgZzKCJ+VG43256rmY9YyFiCBovDjgjyNcYYrMB+IaStH+y/0vo
	 pxqruNjmVIB29rfPg4wlCFx1P2Dtu4JjQuV+TAzykMrKl6U/T1imA6eHkubqxnYlRDaod
	 KS+C2n0FwRG8iDkVZvfY7yEdn9ZrBqKzgdc+fM9aKG+D1X5MnjoDogJKGZvTnroSPnTdb
	 7/7fiFBvj3+kymOrZGGxJ2ijEYuc5xRiqltqZToqmMjWUnLnz/6tGfT9425SStO8k3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795093396;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=cfRUMlNr4cUJsaI9sAqEt7KNEKgXmbic+JOrHniKj3w=;
	b=xsfDP66X4FJh0r4B5f0i1iQAbZZXf46wmH30swRYBON8lWosvBtLAQOmmsKCxyoy24VC
	 VHmqXwEe63hernPy/gXAbF8jfIGTowPdslXwdFEn6hUsGMsCSCoL0dZmLjZRUgQLGLWZn
	 mE5j6P5a2ibPZQr44raZ1pZWcHxXZRNYcg5V7kDMOQs3y58kEQqZE7da2G6TKm+eD2ako
	 bwxEoTiiSSB4XTH6jWzcJODoy2wmt1hgRttLDMsxmGo306cD1BldDAKXsX6NclENnYU7T
	 YXw+GhX6CCvdzGd1NBW+z5HVKQWcGcKHFIzcaHDWbStF6wJ/GU4KGsjhLN7yTV3XeXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ZfAgKLuh;
	arc=none smtp.remote-ip=209.85.128.48
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75CFC606A320
	for <netfilter-devel@vger.kernel.org>; Thu, 19 Nov 2026 13:03:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 75CFC606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ZfAgKLuh
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4bb6057b333so10857655e9.3
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Nov 2026 05:03:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795093395; x=1795698195; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=cfRUMlNr4cUJsaI9sAqEt7KNEKgXmbic+JOrHniKj3w=;
        b=ZfAgKLuh5j8XqSe43N/sobzgDr/LF85qEee7xxpxKeD6+mdy/KG4/AMNfmUkQFFSFI
         ItiR11iRrRMhZKNQfM+p2qsGSJnLYomeZ/FM/Go1GOdN6vM+5qoyfNNTqDSSr++f2mTS
         18d/fzyi6IMoqUTseOAhmYNwgFAN5qLwL3ulFC1GoQV1GMIInViqmr4BWSI/ReG4WGu9
         iFATsZ+cik/cHgBWAPMtw2n2JG7dOtJLj1vuzybfUFC0sflQY1YyH7rGqNxmp+hzTsRC
         ortMNk3dZbouK5YeGi72FzjlrFf0EP9DAFZbu6hvAYhUeFy7dvDmgvsmva0Eg31wdh3O
         dCUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795093395; x=1795698195;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cfRUMlNr4cUJsaI9sAqEt7KNEKgXmbic+JOrHniKj3w=;
        b=o3uj3buYgz8c2hV285Q6cpq594TXY2LSNcUI/rzCIfGUmf5slRPgAzfRnBIdh2K4A4
         2BbyKKOO7aIkLaI5ZBVTAGlNONcfuTRTw8/adQGz6F7cMXYBx6z4sMnGqzktDMChyUXy
         13/6E+0upVT6EHAtq2gYnH7EX0eknj1n1mE9LEn6hhz7OqjS9/wJcl3dGfR8+aKlPnKF
         YbtQpFxt+qbpmzDvVGHK5eYkQfNgCSCsjBJMhWPN0Lgv5o48HHmJJBBq2G5VrY5zIdnW
         V3fVnqJjzDiZPSvA3X+VU4eTc2d1KsUFg+HrfVdFlzARTTm75Q+JyQL9kvrJSK0S9nM8
         8ykw==
X-Gm-Message-State: APuU4Z/xzilT0tSA5M1fSyw0mTvK+Nc4wmFNZgzw5piDhwyFKIC+OS+X
	fIKdvLwp5NH2Ph76Ckp3dCroP0Zde+WERm0jl9UCbAwJAvCsjFoPEt1bjHzugA==
X-Gm-Gg: AYBFou2ziMu5Rv4jM/9q8gGBE46ZFdH8xRgKwsG4+oBzGvGf+n+x7LV0Y4/zTNVwACd
	VMsxLgrnWQdKHpW7keYsdKAXvCUN97p5ZJQ3MfaxUf0kXbSO/nQYBRPezn5EN8DjSxpqr5pvhzw
	BlXn95FaKBjD7r0IVs5az6BFjkxZS4GpktMXo0LuRZEqSGhn46gkQzy7cQkGtVZo+Oxto9sIyb/
	P26dHZp6YxAJYOA/kPUhg/CKsKXNJlf2m49Vkyea3aXO3yi+/Uj2LOTtNoAe+sQ0nMnGxJ9Pzca
	98VXEtEpulAmNNOCeIuY/vRuXgOOqaQAwfoAAP+nQoXHSmNitEsAbUr1m3GTNVRQh4MOdVY4H9/
	ALYxKfFXa386qQJatPI4zrB5L8PUBGPD1k6C6hEpsj2xNe4nXdk/9c0IrPKxH8JfSbalRHo/ShT
	dI8hbDSS6RXAI0L1AVIO1zCFqQ97/m8/7Gb9aX6ubRBEgvZe/RsKPfY4/7gn7ooz7AaJn7K+jPm
	7j1Su8F8B/WRj+s8zmmNUU2c91RbSE+xpuaURsEbUO6PYv2l+m0GTZdNE+LxkQX3EJr8TnO/Tp/
	uXbrroOfFNqItsWfd27Wgf+SeMl35mrkQYNEJLi5xccagnV4sXN93SQmohmyx7GRx4jzv7540bL
	zDnph4Jw8nb1Q68rsVJCr5MX6CA==
X-Received: by 2002:a05:600c:6708:b0:4a3:59c9:a744 with SMTP id 5b1f17b1804b1-4bb7d9fd2f6mr112706975e9.7.1795093394634;
        Thu, 19 Nov 2026 05:03:14 -0800 (PST)
Received: from omen.example.com ([102.0.6.50])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb8538b2c5sm34758265e9.5.2026.11.19.05.03.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2026 05:03:14 -0800 (PST)
From: Harun Wagura Ndichu <harunndishu7@gmail.com>
To: netfilter-devel@vger.kernel.org
Cc: Harun Wagura Ndichu <harunndishu7@gmail.com>
Subject: [PATCH libnftnl] expr: include stdio.h for FILE
Date: Thu, 19 Nov 2026 16:03:06 +0300
Message-ID: <20261119130306.73637-1-harunndishu7@gmail.com>
X-Mailer: git-send-email 2.56.1
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

libnftnl/expr.h declares nftnl_expr_fprintf(FILE *, ...) but does not
include <stdio.h>, so a program that includes it first fails to build:

  error: unknown type name 'FILE'

Include it as rule.h and table.h already do.

Signed-off-by: Harun Wagura Ndichu <harunndishu7@gmail.com>
---
 include/libnftnl/expr.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/libnftnl/expr.h b/include/libnftnl/expr.h
index 41e9f30..2272838 100644
--- a/include/libnftnl/expr.h
+++ b/include/libnftnl/expr.h
@@ -1,6 +1,7 @@
 #ifndef _LIBNFTNL_EXPR_H_
 #define _LIBNFTNL_EXPR_H_
 
+#include <stdio.h>
 #include <stdint.h>
 #include <stdbool.h>
 #include <sys/types.h>
-- 
2.56.1

