Received: from mail-vs2-f12.google.com (mail-vs2-f12.google.com [74.125.227.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A11163AD510
	for <netfilter-devel@vger.kernel.org>; Tue, 15 Sep 2026 22:41:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789512095; cv=none; b=d2X2Sm7OZUNF242+10+Sa34OIgKlEgVSgl2qO3lBxqgNRxBhNBPbyIcv603Kit6da279jUqSkmVgf7cPWemwUK5QtRDIzt7hvtmcOQZ8rLP7/3G5XS5heQNzcv/k7gKlvLAagCQUjG87XCdcY585lRd/m6ruApXkaknXVFKYCxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789512095; c=relaxed/simple;
	bh=Kyh4J3uXxKY1C5bNjX3MqrZtSsK7sPC1wg2NbNBCIwQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kfbQvgvvJn/kFPAiOi2m1hEF9uCSRPW1+sqC1yFlIXal2oV778X/8SlIBHc01/XsU9EZ7uMFtXJuf/JeRaEKkHKhybbgQFbPL9ZU+RQzPp+Hsa22hw9W2eFv/uRFN23zP92W7ehhLV2i5ovw3psT2VvlziN/sStRdk+vRLA02qY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NdSdKhdS; arc=none smtp.client-ip=74.125.227.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NdSdKhdS"
Received: by mail-vs2-f12.google.com with SMTP id 71dfb90a1353d-5c67e4d9197so203332e0c.0
        for <netfilter-devel@vger.kernel.org>; Tue, 15 Sep 2026 15:41:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789512092; x=1790116892; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=StfeLdJl3NyRKAxmr0Q5/80WQQS9SqqL1W9LYvixQ08=;
        b=NdSdKhdScUzYzMswHvXVNikOpAnUaU7uhcaPZrFQjTnmgD6yb6CurcXqH8r3xJdS2D
         e1JRz2FMqQpbKVk6ushXLvSWMjhW4ir1N1R4j/YqnxoC+lW1Ts/CC79dUD75ObZOezBw
         UXQtXtBOOz54fEYuOVaqaIhHMQcerH3Og3uDeVdgzm+0hXbLH40lyapDKBUPaEQgyIlE
         SMHJzNsDVBhgkYTkbg7znDMEqYx+R/p8RW1S00ABUJ6KAWDeOGSzUM8UwFys919GNC4Z
         iN58Fn45wOapDfRETWbabiAaTXH/xiNkcMx64h8WQR+wklgunAJVQvJHCE9/xDvCVN9n
         hqfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789512092; x=1790116892;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=StfeLdJl3NyRKAxmr0Q5/80WQQS9SqqL1W9LYvixQ08=;
        b=y1w8in6S/G55XlXScryM+xjQON/mAWp/GHpbY8mKHAEq9cVSFkr2Hqh0iyVBelfhg4
         wCfRlGjmTHH3gIvk6nXtL58OhQYYIuR5ZxVR5RYKZIZL0rSRu5M99CZ48Volg7VkplnW
         zKrOYURaypEakZIUllN6MdzNfZ4zqdkb3EvwcV73o2u6SqscZuCdLUxqwjBREZSYrgSP
         wxuoEPgB9GjUVvP9a9TMRARXjBb2KIox3Fmiew7mqDEvakxIfplVaZe6q5uj10ob5Wld
         LTBxzap9tb1rAzAilpGUnIoM/L5Ju6BqViN3F4KuTQag3naDHWqkC/GRfcHrkbCFr08z
         FFMQ==
X-Forwarded-Encrypted: i=1; AKwUvBzHY7wqvvJ9ilOMRKdUzYrLl3Zg+nCHnWMKEf1KxlT5RliSkfNLucoICfIE0brqOc1lBbc1QiX8dQmzdqxgl9w=@vger.kernel.org
X-Gm-Message-State: AFuF++loMWKQt9r38b2B+dH6WzLzEyhpIZ82HUZ5hnVOl3tCvMdbRLsE
	cuixBPE4tmsXaqsSttoUEOkYOHyshdxwjexIgO4OE1M73zhtWsLzaRog
X-Gm-Gg: AYBFou36N3Q2gxDSOLDX8d6d3w7+HRD71JZW1JoLGNk++Yoa2PXpCn8sJ2bGW7K2oTo
	UdidSXJxpN+GwI7bt8IbmNkxVain23O0XPW4BGzPjp8f56kdLsGvAR/ZSl4j5nRuT0wbYskEic3
	hRKzF4K9NHJvIyfFd3n5EIuLwBc9sacJygtydtbD2uxSLfYJVljnNZvqBorgCKpiUC+1t+a0k+3
	jttHn2TJGgaboucb/0E5hf/uuVfQ9RXNbgmwNCBHq/dVlKPRr79DFVYQySULd766L96XR94Z/0o
	Oh/Rb8m1VEc0KSBPM4xgj2ErCkDwpsbbgci0WsPYhAKWZ6Zmyj5+ZjZaYmMEoGyC9VPVWG2psBs
	vcNvymhtJO8OCR6tT/hIsFgTR2sqqsJ4pQ4A35sSLLRAVQJiwyuk/UkIexuO1b1oPgNLS5/BOzf
	xcod+lWxkoFIO5RUQ0YeHdZO6NWrBnPatSRZPYKj/vVmA9UhuyzLsevYpaoaw+/bM=
X-Received: by 2002:a05:6122:288f:b0:5c6:6189:c756 with SMTP id 71dfb90a1353d-5c99ab6f120mr226744e0c.2.1789512092282;
        Tue, 15 Sep 2026 15:41:32 -0700 (PDT)
Received: from adriano ([190.215.95.120])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5c9988e5f27sm974975e0c.1.2026.09.15.15.41.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2026 15:41:32 -0700 (PDT)
From: Adriano Cordova <adrianox@gmail.com>
To: Simon Horman <horms@verge.net.au>,
	Julian Anastasov <ja@ssi.bg>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	netdev@vger.kernel.org,
	lvs-devel@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	Adriano Cordova <adrianox@gmail.com>
Subject: [PATCH v2 1/4] ipvs: add flags for per-service secure TCP state table
Date: Tue, 15 Sep 2026 19:41:01 -0300
Message-ID: <20260915224104.639985-2-adrianox@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260915224104.639985-1-adrianox@gmail.com>
References: <20260915224104.639985-1-adrianox@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add IP_VS_SVC_F_SECURE_TCP to mark a virtual service for the
DoS-hardened TCP connection state table, and
IP_VS_CONN_F_SECURE_TCP to carry that capability on a connection
so the TCP state machine can select the hardened table for it.

The service flag is 0x0100: bits 0x0008/0x0010/0x0020 are the
scheduler bits, so leave 0x0040/0x0080 free for schedulers.

Signed-off-by: Adriano Cordova <adrianox@gmail.com>
---
Changes in v2:
- Let IP_VS_SVC_F_SECURE_TCP be 0x0100, leaving 0x0040/0x0080 free for
  scheduler flags.
- Let IP_VS_CONN_F_SECURE_TCP be (1 << 17) and drop it from
  IP_VS_CONN_F_BACKUP_MASK.

 include/uapi/linux/ip_vs.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/uapi/linux/ip_vs.h b/include/uapi/linux/ip_vs.h
index 2c37c6ac7525..ade170109ff4 100644
--- a/include/uapi/linux/ip_vs.h
+++ b/include/uapi/linux/ip_vs.h
@@ -27,6 +27,7 @@
 
 #define IP_VS_SVC_F_SCHED_SH_FALLBACK	IP_VS_SVC_F_SCHED1 /* SH fallback */
 #define IP_VS_SVC_F_SCHED_SH_PORT	IP_VS_SVC_F_SCHED2 /* SH use port */
+#define IP_VS_SVC_F_SECURE_TCP	0x0100		/* use the hardened TCP table */
 
 /*
  *      IPVS sync daemon states
@@ -105,6 +106,7 @@
 
 /* Flags that are not sent to backup server start from bit 16 */
 #define IP_VS_CONN_F_NFCT	(1 << 16)	/* use netfilter conntrack */
+#define IP_VS_CONN_F_SECURE_TCP	(1 << 17)	/* use the hardened TCP table */
 
 /* Connection flags from destination that can be changed by user space */
 #define IP_VS_CONN_F_DEST_MASK (IP_VS_CONN_F_FWD_MASK | \
-- 
2.51.0

