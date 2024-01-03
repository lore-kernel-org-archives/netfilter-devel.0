Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34E89200AD
	for <netfilter-devel@vger.kernel.org>; Wed,  3 Jan 2024 23:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FizICBUu"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-1d3e8a51e6bso81042015ad.3
        for <netfilter-devel@vger.kernel.org>; Wed, 03 Jan 2024 15:37:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1704325057; x=1704929857; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=oSSAVjsvP9sdSPjOdkYdcVz4+nhD3PRIaO32yOtU9Ys=;
        b=FizICBUudkubm/mBFQTWPxH1Jv7lukxp1tiQpmdbaKIXFfJRyx51Ne97Gvo/Z9HzSF
         oIYS0psrDPl4JOql/nfwlmxrUwLXiN1U4EnUe5tNaDlshejL+yvnOtkQkE3LafGEv4G5
         oBbS8HnUJtIAwlScen+XXOIW+2QceFAx2YhcKzmfqQ8VV9eIcMzhk79MLfDbQvBp4GIS
         XuzZf2lNnODL6oA+7uw08pPFPfVr3hKCnAmmefOSCeuLbsLWZiAvUqN1S8GBGO7Gmp1x
         z3GFYPg5U+aJxTv7c37YwcEW1/LJHpM3qQd+E3DMBRJSVrHf3+X6MUjENHbgBMWgA7TJ
         HZwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704325057; x=1704929857;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oSSAVjsvP9sdSPjOdkYdcVz4+nhD3PRIaO32yOtU9Ys=;
        b=Dst/InvC2yU1jD+b1SVzA7KTczLXpu8GjSehC4StN7OaJTua5MpNkYFFLLi1ElqLhM
         qq130C99h8/kmW4vMQh3daJ3CwI0pZ/+cSfaAvYWzjJnd5kAjjiHNYrY8QwwzlwfV7dV
         bEQQ47x2Yzk6w0Yk5hGcYBSYBxcsaZQ+e8N76NPSJqEXsInc33NPS3tW/qdUeCYbjZXs
         8FEVsmnMNJmrdlF84pGwAlhPt+xvaQ/mesQBrOY7m5KbgSD4Odivxly/+2GaJ3sZBmQs
         pcSmsMEZEJpPlrR87V2o85RtqD5tPL9i2dSPptR4Ec2r/6s2MtErGPf0BbV1N4HBetrQ
         b3Xw==
X-Gm-Message-State: AOJu0YyKleNwCDsjum4bMgLme87gjyWiYBLMW9dTKrFl8PxH40H8RzXZ
	Vph7MoBBkpkIvjQg6QkmTSJC36wW5w8=
X-Google-Smtp-Source: AGHT+IHQugd+FcJzwClUrtmP9yMpRLBWsZYHl8G86zJi7pvXkznf1CCUosxR4Dv0Ft8fSO6k7ToKmw==
X-Received: by 2002:a17:902:e892:b0:1d3:fe01:17ec with SMTP id w18-20020a170902e89200b001d3fe0117ecmr27876163plg.18.1704325057346;
        Wed, 03 Jan 2024 15:37:37 -0800 (PST)
Received: from slk15.local.net (n58-108-90-185.meb1.vic.optusnet.com.au. [58.108.90.185])
        by smtp.gmail.com with ESMTPSA id iw6-20020a170903044600b001d0c151d325sm24261777plb.209.2024.01.03.15.37.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jan 2024 15:37:36 -0800 (PST)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From: Duncan Roe <duncan_roe@optusnet.com.au>
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue] include: pktbuff.h needs stdbool.h
Date: Thu,  4 Jan 2024 10:37:32 +1100
Message-Id: <20240103233732.31299-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.35.8
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Without #include <stdbool.h>, compilation will fail if pktbuff.h is
included early enough.

Fixes: ffa83b5968b5 ("add mangle functions for IPv4/TCP and IPv4/UDP")
Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 include/libnetfilter_queue/pktbuff.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/libnetfilter_queue/pktbuff.h b/include/libnetfilter_queue/pktbuff.h
index a4cc2a1..d3588c7 100644
--- a/include/libnetfilter_queue/pktbuff.h
+++ b/include/libnetfilter_queue/pktbuff.h
@@ -1,6 +1,8 @@
 #ifndef _PKTBUFF_H_
 #define _PKTBUFF_H_
 
+#include <stdbool.h>
+
 struct pkt_buff;
 
 struct pkt_buff *pktb_alloc(int family, void *data, size_t len, size_t extra);
-- 
2.35.8

