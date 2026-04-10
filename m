Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2421D3A7859
	for <netfilter-devel@vger.kernel.org>; Fri, 10 Apr 2026 13:58:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775829489; cv=none; b=XUv/DO/EFke72oq7vtKeI1y7kR0oDuxCizzfkfz82S4NpJN8ztFCv5CBIKndS6xU7qDFuD1bgI0YQLe1jn9Wqmef+cvOdIUtep/i9OiXHrAb+kU6fl8Xm72tColHuBtAocmeeYAJVtXBtRpD5R/+YM4P4aCkytFqYzr7yBA3eyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775829489; c=relaxed/simple;
	bh=nw0sjGaCdrAVNDX9xZtQ9srexVTpwmtbQktOyQasq94=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=OOEYuT9LJCOd/ad5KsiqcTVUqFiHtdoOTw+Rjt+F5IOHHQalyaGLqsoJVg8U5KPBtgnDbFqL9+DKyMD2i7s99zCrUOj3MD5Wroz9xEdBhW4hb2ZDmYd1ETdC3Ag50p+PtaznNgB+xS53tjeZ0fx5YyKcBGJMzH7GLPJcUV7L54M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=T9DiJryb; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="T9DiJryb"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-488af96f6b2so27190195e9.0
        for <netfilter-devel@vger.kernel.org>; Fri, 10 Apr 2026 06:58:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775829486; x=1776434286; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=mQfS+t05KHEJMgI3OsZEfkjQUbMQvFG5UKSa2caXMdU=;
        b=T9DiJrybJcCdrzkIEPy/lUN8qg5woQyYZ9zgkQQYlbY4J7MVRcsDd4a/wc8F7YqZtX
         jvDs2kjyW4KNiKDtP0YSybAVeM36RPo449IfEUwjKPHNj/n07h0uDYMRMZDSYHvdLbtq
         13yW8Egu0EyGrfaqCZyGaKvMiZ/gRF13UeuAJ7AIa1WktZznAt/DNZbL0Z5jagQsXY/K
         ZCaHX7aHZVVZCL8MDmvM6EWfEj04ozSTzlv3VB0YJgZGD3ez1Tup1LdrsmvWggc6ypPk
         ImkZAYlMM/Ls1RzspPE8oyemYZ1sYlyYnypWPtePZQOl93IGzGunfzY7wJYsmqNDPh6W
         mYvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775829486; x=1776434286;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mQfS+t05KHEJMgI3OsZEfkjQUbMQvFG5UKSa2caXMdU=;
        b=MK/QeH8WaswEycMg7iGaAJnlgqOFBpUHs/IhrH5l++IDXqUmCm4qBcDrvvw4GYYP8k
         F8mZek+ZFB8f8HEDAAzzDtXh5kb11G6nBRmzzjXZI2hIGhEp+x6dG8eKk0SQImoPqq+t
         1hjAv17TzqKMQLuYxsyqryJWJz8hcdTOvHImt3lscpuK0MqeTZzimnb8oGEWtxgEuyuS
         3YsNGDL9UxPvqh/WybUXq6bwyU1dXeusZW0SmhitQxvB+hu0+IMYgyLVwfHxd0vAtbc4
         TMJzYvwhxsgeTPbB2NIyqPzrtg8K9O1q7NWkdyyWACcQ2ucXnQ9BTFvKZjfqnpc2i15a
         nhlA==
X-Gm-Message-State: AOJu0YySFg28ji96WNlwEQUaquxnhu5LZizrM42OPC808XeDNsgEx+zL
	C22b0DEgm1BhvK/rvpbY4unOri8FwUU6yZdQuDEhti3BB/d4a8W50LCHqwc9m06zQtm22w==
X-Gm-Gg: AeBDiesnqQkk25z0kL4AZo8aSXxOUnuBiNbOQjFQGf30lRbLYX8PPEfNfTxpeEfBw6V
	jdsHbZTfxE9jzpyMzAaNlSn/5mlft+3olDpcNyVAezfjs6Po77yYAQuK7k3JxhdSzOMbc0lJ2ad
	Wg0Q46uX88AzI8PbUdCEtpr03Tvxo1QThsz8SWpdepTTdvJ7ALKqRPHW53opJ2ScAowmg6BKbZv
	ivzyyaa6eF/+rAhkaARX2+Rt36g9jNtXb5zi1b1PvLYwxNu9PLTmp69KQdSaKNfUZTYB/rTfQ2O
	F5eZiHx09cqSMfVt9FIO+1BJ++KKiRE+IDRzDEWqyHZXBFBe4Kkqrv3x73rtwPhMxK+FKafHuRM
	FhtVB+Um+5xCodtggpdg6mEC2SvpfagCKZ9Y1UU1Ox6+lvNdsMhzD1EKn8A48HF79Hh2XNhVlwT
	d1Xx91F7X2g7e/6VJMvXHui+DTZ+/ivtFkdtEc/zQiJzqY9WahsnGvI4rdRowp3wZOXegZ
X-Received: by 2002:a05:600c:c171:b0:488:a894:b27a with SMTP id 5b1f17b1804b1-488d67f0105mr45254075e9.8.1775829486246;
        Fri, 10 Apr 2026 06:58:06 -0700 (PDT)
Received: from kali.station (net-2-39-22-72.cust.vodafonedsl.it. [2.39.22.72])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43d63de2e4csm8191131f8f.2.2026.04.10.06.58.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Apr 2026 06:58:05 -0700 (PDT)
From: Cyber-JA <giuseppecaruso0990@gmail.com>
To: netfilter-devel@vger.kernel.org
Cc: Giuseppe Caruso <giuseppecaruso0990@gmail.com>
Subject: [PATCH 1/2] netfilter fix u16 overflow in get_port()
Date: Fri, 10 Apr 2026 09:57:33 -0400
Message-ID: <20260410135733.46391-1-giuseppecaruso0990@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Giuseppe Caruso <giuseppecaruso0990@gmail.com>

try_number() parses comma-separated decimal values from FTP PORT and
EPRT commands into a u_int32_t array, but does not validate that each
value fits in a single octet. RFC 959 specifies that PORT parameters
are decimal integers in the range 0-255, representing the four octets
of an IP address followed by two octets encoding the port number.

Values exceeding 255 are silently accepted. In try_rfc959(), the raw
u32 values are combined via shift-and-OR to form the IP and port:

  cmd->u3.ip = htonl((array[0] << 24) | (array[1] << 16) |
                     (array[2] << 8) | array[3]);
  cmd->u.tcp.port = htons((array[4] << 8) | array[5]);

When array elements exceed 255, bits from one field bleed into adjacent
fields after shifting, producing IP addresses and port numbers that
differ from what the text representation suggests. For example,
"PORT 10,0,1,2,256,22" yields port (256<<8)|22 = 65558, truncated to
u16 = 22. This mismatch between the textual and computed values can
confuse network monitoring tools that parse FTP commands independently.

Reject the command by returning 0 (no match) when any accumulated
value exceeds 255.

Signed-off-by: Giuseppe Caruso <giuseppecaruso0990@gmail.com>
---
 net/netfilter/nf_conntrack_ftp.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_ftp.c b/net/netfilter/nf_conntrack_ftp.c
index 5e00f9123c38..680dd7560ebc 100644
--- a/net/netfilter/nf_conntrack_ftp.c
+++ b/net/netfilter/nf_conntrack_ftp.c
@@ -195,7 +195,7 @@ static int try_rfc1123(const char *data, size_t dlen,
 static int get_port(const char *data, int start, size_t dlen, char delim,
 		    __be16 *port)
 {
-	u_int16_t tmp_port = 0;
+	u_int32_t tmp_port = 0;
 	int i;
 
 	for (i = start; i < dlen; i++) {
@@ -207,8 +207,14 @@ static int get_port(const char *data, int start, size_t dlen, char delim,
 			pr_debug("get_port: return %d\n", tmp_port);
 			return i + 1;
 		}
-		else if (data[i] >= '0' && data[i] <= '9')
+		else if (data[i] >= '0' && data[i] <= '9'){
 			tmp_port = tmp_port*10 + data[i] - '0';
+			if (tmp_port > 65535) {
+				pr_debug("get_port: port %u out of range.\n",
+					 tmp_port);
+				break;
+			}
+		}
 		else { /* Some other crap */
 			pr_debug("get_port: invalid char.\n");
 			break;
-- 
2.53.0

