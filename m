Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DF4A266EFC
	for <netfilter-devel@vger.kernel.org>; Thu, 30 Oct 2025 14:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761836262; cv=none; b=JIz/1R4b+P8rDuQkKJBGwDj5hG7Z6NcrSBdJ+Gkn6Xbv2xNIJT7X7IV8gzWdtQdGj0Qmg0+BciwpAqrPyENQHt8QOo5VCA/obEMqeWJXEPWkNHyFJFXoL43jSuZa+h6jWwYJTjMDYCMfKVcllThxWzKH7qiB58AdZ3Yn2sz8DZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761836262; c=relaxed/simple;
	bh=VPc6nAw9xUkngbpuHwVt3f64S9sYthW6LR4iISLpD20=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U+WFRSUZzwBWkPUhzmuJJqW20fUZQASOtMfcUkV24XbP6y/i1agvBtFsxhpZtnR6kZEEMdIeUcjtdi7mqtb/+Gls4ZG8GTXuqVe1K1J5e50Qt/lWl8qg7/qhvvDpRKnl3NtVe3LBRkm0yxsDZo6l0XbLkSy8e1+BfippBntDK6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vyos.io; spf=pass smtp.mailfrom=vyos.io; dkim=pass (2048-bit key) header.d=vyos.io header.i=@vyos.io header.b=K9AxOdaH; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vyos.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vyos.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vyos.io header.i=@vyos.io header.b="K9AxOdaH"
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-b3b27b50090so194966966b.0
        for <netfilter-devel@vger.kernel.org>; Thu, 30 Oct 2025 07:57:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vyos.io; s=google; t=1761836258; x=1762441058; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NteojDHYsqPG7103VQyx6cbbplc0COxdkEL/emOdyLE=;
        b=K9AxOdaHU6dvAw6HU/UuzSrErHq/S5M8lrIustt4smsUQs1iNE92pRCvARBvBmWHtJ
         Of9VcmLnj6LcWptF/+n4DDCIK87SV27T8Ov+xsbZCj7xB19M/ngNomwRysfezJeosWRR
         p2Xtx74Kp7izT3y8DP8QfLqcvOeJnwTHT54E/y2fWIqS90m/lU3SW+S3BbBfghmqmTN8
         0qnvJagKKr6Yu2cc81nmB23NRcoSA4lufziy07+renvoYKws44FMioGoxBKcHBEFvnrE
         NX1Z3QHaKWNXiBb7OpP2wWBNthaWnC/weQwrbPckAp6vwST7k8RKm9gNsBfMm++0dNKZ
         hxDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761836258; x=1762441058;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NteojDHYsqPG7103VQyx6cbbplc0COxdkEL/emOdyLE=;
        b=P4NS7TsM6rEg8pq0krEltRXLVLQN0KsuqijQ5kRFOja9wDg9KaC2k0GW170ppKPykq
         h2X6NiQb/+q+YHaKeVDsGYKAC70/ch0f/Fn4d9g3KhufnVcQTr3G6Mm8atLVsAg+Aeq+
         uGA5ZuSQIsR+1G+eY4TE/F7MhGsmIuOPWHH/gS9RK7f1vaa+5/JvImSemZ3vbFHw8zdO
         GsH8rmFEl/rdONzZfrMw0i23nG8OVcM5RkobHEojAiIH6Fbf4UjxUQZhZpo7xIGAhTnF
         UIOgx8bJmfmFqOxKZwXcqUWwMPXBw3X5TstYSZ7laWl4/uoCXlr7QQs4Z5XuGLoQEjON
         vsOQ==
X-Gm-Message-State: AOJu0YwbVAbHVj/i+6yL4o1hm1RQ4xFPYkCHwacJtW+NLl50Napf3ZK2
	IEA2hRqrHkfn45pxm3O6ptApDQib8AzGe3qe70Z3xYi7+LutrOWJg3ewpz2imVrN0rOme5voIsI
	OgLe2
X-Gm-Gg: ASbGnctUnm7CTSeH0AhoFP9trXHzwbK+zQD18nJXsIt2sH5Skcfn2ow8Ho/vgcQ7neh
	e2VYKecqCRnBRZqGO5pVhvRP3tkdACUZvgq2Zr+0ChfYZuMMRBRrfVo8r5FDIrGayJIRHuhhsCz
	1v9w/5VSymL5iy/h7Il5ReL8KCpB8Wr78NQTnBnQmj7hLD3V4buoAPxJXkdH+tZA6JzDjTpR3HJ
	LyfpCUOyfN4Gjm5lZxpOUL1cXskCRskT7xRQ8zMwMx+T0yfV1i0qSUWqhPrNeuJy1C0G6P2l4Yc
	e1JSiaWFuE1ur0voc2y6Kn2eVtktWgsaHX6TlwuZ6nfBzXtBBi6OKfSn/WCN5Ow90UYbKJpswCE
	DRnDo+wOuLvp/tQlbwjFbqLplADFm4XG4y/uES5yqSwUF7wkF5T/rDqwH3Xc7HGd9LdFCzVD0Ix
	81ZACNmPpR0kD0YNfSE+bYbrba
X-Google-Smtp-Source: AGHT+IH6l20iyhfUUi8sk6kdXHd5fcTzpikodqAxsq6ejWwWD4HYMxIgKHByAalhaLLEg91kh9v/2g==
X-Received: by 2002:a17:907:7fa0:b0:b3d:9261:ff1b with SMTP id a640c23a62f3a-b7053b63973mr302589966b.5.1761836258126;
        Thu, 30 Oct 2025 07:57:38 -0700 (PDT)
Received: from VyOS.. (213-225-2-6.nat.highway.a1.net. [213.225.2.6])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b6d853c549fsm1790483966b.37.2025.10.30.07.57.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Oct 2025 07:57:37 -0700 (PDT)
From: Andrii Melnychenko <a.melnychenko@vyos.io>
To: netfilter-devel@vger.kernel.org,
	fw@strlen.de
Subject: [PATCH v3 2/2] tests: shell: Added SNAT/DNAT only cases for nat_ftp
Date: Thu, 30 Oct 2025 15:57:31 +0100
Message-ID: <20251030145731.2234648-3-a.melnychenko@vyos.io>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251030145731.2234648-1-a.melnychenko@vyos.io>
References: <20251030145731.2234648-1-a.melnychenko@vyos.io>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Added cases for SNAT or DNAT only for active and passive modes.

Signed-off-by: Andrii Melnychenko <a.melnychenko@vyos.io>
---
 tests/shell/testcases/packetpath/nat_ftp | 32 ++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/tests/shell/testcases/packetpath/nat_ftp b/tests/shell/testcases/packetpath/nat_ftp
index 93330225..bc44ed86 100755
--- a/tests/shell/testcases/packetpath/nat_ftp
+++ b/tests/shell/testcases/packetpath/nat_ftp
@@ -144,6 +144,18 @@ reload_ruleset()
 	load_snat
 }
 
+reload_ruleset_dnat_only()
+{
+	reload_ruleset_base
+	load_dnat
+}
+
+reload_ruleset_snat_only()
+{
+	reload_ruleset_base
+	load_snat
+}
+
 dd if=/dev/urandom of="$INFILE" bs=4096 count=1 2>/dev/null
 chmod 755 $INFILE
 assert_pass "Prepare the file for FTP transmission"
@@ -190,9 +202,29 @@ reload_ruleset
 test_case "Passive mode" "[${ip_rc}]:2121" ${ip_rs}
 
 
+# test passive mode DNAT only
+reload_ruleset_dnat_only
+test_case "Passive mode DNAT only" "[${ip_rc}]:2121" ${ip_cr}
+
+
+# test passive mode SNAT only
+reload_ruleset_snat_only
+test_case "Passive mode SNAT only" "[${ip_sr}]:21" ${ip_rs}
+
+
 # test active mode
 reload_ruleset
 test_case "Active mode" "[${ip_rc}]:2121" ${ip_rs} "-P -"
 
+
+# test active mode DNAT only
+reload_ruleset_dnat_only
+test_case "Active mode DNAT only" "[${ip_rc}]:2121" ${ip_cr} "-P -"
+
+
+# test active mode SNAT only
+reload_ruleset_snat_only
+test_case "Active mode SNAT only" "[${ip_sr}]:21" ${ip_rs} "-P -"
+
 # trap calls cleanup
 exit 0
-- 
2.43.0

