Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6FC114A83
	for <netfilter-devel@vger.kernel.org>; Fri, 15 Mar 2024 07:34:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710488073; cv=none; b=FornP5OKQMC76depOLCqm8JwZEfFLHODn8riK5Mzhv9IAIo+ddrySrSwIpCQbywXfEQsq5PdDYXsuNvf2VOjtDPTYbhCfVIsx4IYz3mH1C+dX8rWtYjlI1wMYqx9K3/ocTjodQOnZU9LClPtwjzrEdVG0d0sU4ZAIt6zQF7DA94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710488073; c=relaxed/simple;
	bh=S7hdtkOiihlX7rJmQz/37PTSxMEhaR6/ER98tbX9hRQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=eu7imvdqtDuiADBdGEsJMw9I5mpj3n1VohtzL/z2I52rfOMjBuGPj5zUZ1/YYCBjwJ1gskLPvFBdaL30QZjbH101Kkoi3b2J9+rKSi99CFtKPlNa7Pxp31GZxPdvk3+eunM7d54CmEI0Nm+ubZArSLx3otNtNo3s732V267tkmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OFu157N1; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OFu157N1"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-1def142ae7bso2358915ad.3
        for <netfilter-devel@vger.kernel.org>; Fri, 15 Mar 2024 00:34:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710488071; x=1711092871; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P53jFMcygtlKyHdBbGENQYOWN5iY8TvmiBXRCzCThmM=;
        b=OFu157N1FDroj8k2CIEiOOD+i6KoNAgJrN86KajAos3imm4RKhowf+hIOPcy21t0U7
         N6PbyrD15z/0U0asHhpVJVeZuVorT0tDk+mWdhooHTcrOUncHNONq8NSKSiIClxiqAnL
         AsL04rI6d2pSJeQYBxX5HDgxv+ZenpCqktF/YSdIbXIs6AE52NqOpbM9rjJRfvHSm0iT
         MmiFw70SJE5CQkPNnudsbgVxdbJMpIz/hKwzG75bhCJj4dFr560UwmjML7aQkeEqDoD+
         MKOc0m76Lm5bNeCsGwMlWpLsdHVQldtwCTJiuyE4Czyjbzpa+MRfBmN2vq1xs8gxNrOo
         WUqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710488071; x=1711092871;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=P53jFMcygtlKyHdBbGENQYOWN5iY8TvmiBXRCzCThmM=;
        b=bi85+Vs0YpHtkvTp5YJ9uq5epgKIt052A8shxRJIbu2aaBktT50f3AhusRRCzPtjF/
         EVTyn1QpNIPa/ZP6NOgtoFKIu/nUmo5OGc+p1mVrhy/d4dM+2z7ErTOmBmbzKERPIX6o
         bWKEjaUBJrYxoaWWi448mAxa1ZVl9ztcoV43+oZ0xXjftQ82Bv4skiNRILBp/xUb8PWE
         vcxi2ueG8ekP8dLzdSiIp+xPEVQHJi7OpVlwOgWCYorVm+Ny0AjGJlgykf9Qj2HBjSit
         eq36UTBYm7NqrntodmT3KHNCCuSof6DXyuSI7Yg6ODUriYQnFbQDrSp6zznR2ufJkxvQ
         jcpw==
X-Gm-Message-State: AOJu0Yyfw0zJMTnWU9XqZHEsn4lrj01TbIeBvrTqLkrcFdloXx7jmXte
	p9cz2DOkct1Svy2HkCNXMnrywYZ08MxDq/A7q9KOMo6zWta6LghMnOg1wJlH
X-Google-Smtp-Source: AGHT+IEuxQ7Fg5VZXWghS2SHb+0JQjRhzAHF16YoP/PWLMOKMxWyArVRZKSMe450JAiWxNy8KUDIoA==
X-Received: by 2002:a17:902:ef8f:b0:1dd:c288:899f with SMTP id iz15-20020a170902ef8f00b001ddc288899fmr4037265plb.18.1710488071283;
        Fri, 15 Mar 2024 00:34:31 -0700 (PDT)
Received: from slk15.local.net (n58-108-84-186.meb1.vic.optusnet.com.au. [58.108.84.186])
        by smtp.gmail.com with ESMTPSA id k18-20020a170902c41200b001dd75d4c78csm3049142plk.221.2024.03.15.00.34.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Mar 2024 00:34:31 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From: Duncan Roe <duncan_roe@optusnet.com.au>
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue 22/32] include: Remove the last remaining use of a libnfnetlink header
Date: Fri, 15 Mar 2024 18:33:37 +1100
Message-Id: <20240315073347.22628-23-duncan_roe@optusnet.com.au>
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

Update (deprecated) include/libnetfilter_queue/linux_nfnetlink_queue.h
to use /usr/include/linux/nfnetlink.h
instead of libnfnetlink/linux_nfnetlink.h
As an aside, everything compiles fine with this line removed
(i.e library, utils and examples all compile),
so maybe we can do without it.

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 include/libnetfilter_queue/linux_nfnetlink_queue.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/libnetfilter_queue/linux_nfnetlink_queue.h b/include/libnetfilter_queue/linux_nfnetlink_queue.h
index 6844270..82d8ece 100644
--- a/include/libnetfilter_queue/linux_nfnetlink_queue.h
+++ b/include/libnetfilter_queue/linux_nfnetlink_queue.h
@@ -8,7 +8,8 @@
 #endif
 
 #include <linux/types.h>
-#include <libnfnetlink/linux_nfnetlink.h>
+/* Use the real header since libnfnetlink is going away. */
+#include <linux/nfnetlink.h>
 
 enum nfqnl_msg_types {
 	NFQNL_MSG_PACKET,		/* packet from kernel to userspace */
-- 
2.35.8

