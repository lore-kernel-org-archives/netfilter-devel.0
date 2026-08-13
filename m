Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC0DD381B01
	for <netfilter-devel@vger.kernel.org>; Thu, 13 Aug 2026 18:34:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786646073; cv=none; b=lSf5JtsOiK0KU0GSZ/Mzx4mS8qZ1yuaMQ34xwhk96zvLA+i8ODgEX+p2JONEFBnArGJDDs9NH6/eswz1TIN1v15v552ZNfdkSHSF2i7x39pOLI9CeJ8A70mrDeQ8LV3AU0TDLMVahYuV192NosygHribnSQTTXxXy9+c+/YWo64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786646073; c=relaxed/simple;
	bh=mqYEFzcu9adlmzMlbAGBlaKC7RKZhOj1IPYoG0xJLLg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Xtx91GIao8f6qNA9LNffTPVeHW/Nn/voFA/QtphkI69s8ZYA/eFdHxQ2bcYhq11B9iJFOuF0LTFFw8+bvigxX2wkqVEM+HoS/CxR9iJsOLcATbZAXF53syKvIshVx3cZFsfohIOpQigBCqVfk8ZCK4Iv8AUePdCLlcU/k1fAiI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=p/OKSJRx; arc=none smtp.client-ip=209.85.215.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="p/OKSJRx"
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-c9eefcf9175so120038a12.3
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Aug 2026 11:34:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786646071; x=1787250871; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=7YHG5aECJfFEafyUES+0YBuoUGPDTuM9lTTdzyRLjcg=;
        b=p/OKSJRxf7ptWC2hVbg2/OknYjufxh+QBNiirT0t5UCmjXMaoc5hnAAvmr2Dd2R4+M
         4EtJjpqTS/xccoolIpkN2S0Z6vD14kfL6i8/AT/BLY5KgQiHCDaymj5d3sB6S0oooHP3
         /MLB8CxWqNshYxTs+GPzVnlIK3RptOtj6enNt5e3biUZJZUJj/MkIle5jadep0o8tyh9
         vuT49udVZdeEl1l5D/CWW1mj12JN8VSaTuk8M1UFgYhIrqFo0478G3QvD/pCjOIsRX1h
         iqLxC8pRLyq3qHoNX1kesGVk6dnbEyCPp+lp1fKoKNmjNMMPEAqVodPD7+He9wGKcIa4
         92rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786646071; x=1787250871;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7YHG5aECJfFEafyUES+0YBuoUGPDTuM9lTTdzyRLjcg=;
        b=ZvvYYr/hzYVNxfMy5xtxr3d3p/xuvzUWU+WRM2bbYkd7odUFcSqsPmnmMzJzzdW8AT
         Ph9FzaElugCAUKE98Y3uApb3ZItxFE7xtk7GTQTq+B4f5aMEP4qEL1Pq5N+/DQF8t19K
         f7yv3sXQ3H+5kTDziMkjb7TBERJ0bD3kau+dBR4bqXXOBRCYYuclZPV18qaVnGI/Wewi
         ePZaFg89U/sHnFqQLwxnokRPg/hmSN0vzZMkBpFpGAX+OjpmLOhiCHW378yFBQ/WsmzH
         NKz5glGBzKP4GRfGmqw+2svI840ZkpWF46aM2Vu1DDVjiGAyPy4CwKDpH236fQ566E7T
         +waA==
X-Forwarded-Encrypted: i=1; AHgh+RoKjbuxWCDwX0qOF+xJKR8Bvw4fQjbe9qhlDuHN5hq2HP78mii0HhdokUuC3fPnrNg9K4VMdSoRuxLVzEFwAvA=@vger.kernel.org
X-Gm-Message-State: AOJu0YyWaEWVazhebBmLwHBP72IJ8uZ1oN5GKVqwx28MTZlWxZ0cbrAF
	oeiShdaSEfYB8OKQpBAB73ZHUFrnB/g19h2rXkNV8gyUIi7MHiONACZT
X-Gm-Gg: AR+sD132iUszP/Yd1mNlwB5PP42pFbc26ZTtuNwL6Vm7JmQjh6XmHl4szpfyS6FSoDO
	tyDWdvb9s/xLbs+Ihw98BOgV+otezgSmfhRWvYTf76UUlHnJ51NBAESK6YAYFXvP90IDU06Fsk8
	9f6NdU+2VSDGBpMAjpw9OBpzpBsolWDBtKIoUxf/1O9j1F+1inuR+rtxHv2/3HRSxMejht4UycO
	pJ9rLsGONbpWXNDtfKLVNt6K3YPe0xTqwqdNbCriBjnMwjFOsy76NHzEHwC2Qjxn+z/ZrwMHZ+u
	N+WBdjswhi8RluALO5hdjGvat23wqM/La6I8PoYyleMuEUiCJXX7/yxcwJ/12I+VhwxXLOL7axx
	3HlBYvDqJPq5zYOLnhHQTtAq1QJiQFPaNDKS+jYOzSkxBoMnwX0BHsZygZiuMRWGJoVxODdmq+c
	lI1nQ8XyPuCdUwobUq9O6ZAlW2Zz50cSJ324AyHeTmxTJhvxdDsa/o84SfZSV30bm7Z/2NhCCHE
	+8MsVeGm7QeyybSjSYJrbq//Pbc2LPBr80lCmbDyAk2l2FdoJ6DSnI/zGM=
X-Received: by 2002:a05:6a21:398:b0:3c4:1493:6822 with SMTP id adf61e73a8af0-3cc5527de3dmr10298362637.18.1786646071025;
        Thu, 13 Aug 2026 11:34:31 -0700 (PDT)
Received: from localhost.localdomain ([2804:7f0:b103:29aa:a46e:b8bb:4db6:5c63])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-31ebfc3ca41sm10226567eec.21.2026.08.13.11.34.28
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 13 Aug 2026 11:34:30 -0700 (PDT)
From: Joas Antonio <joasantonio108@gmail.com>
To: horms@verge.net.au,
	ja@ssi.bg,
	pablo@netfilter.org,
	fw@strlen.de
Cc: netdev@vger.kernel.org,
	lvs-devel@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	linux-kernel@vger.kernel.org,
	Joas Antonio dos Santos <joasantonio108@gmail.com>
Subject: [PATCH v2 ipvs] ipvs: fix integer overflow in ftp helper port/address parsing
Date: Thu, 13 Aug 2026 15:34:24 -0300
Message-Id: <20260813183424.47522-1-joasantonio108@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Joas Antonio dos Santos <joasantonio108@gmail.com>

ip_vs_ftp_get_addrport() accumulates decimal digits into a __u16
(hport) and into unsigned char (p[]) without checking for overflow.
A crafted FTP PASV/EPSV response with an over-long port or address
octet wraps the value, so the helper configures the data connection
with a truncated port/address.

The netfilter conntrack FTP helper had the same defect, fixed in
commit 2b413fc689ba ("netfilter: nf_conntrack_ftp: avoid u16
overflows"). Apply the equivalent fix here: widen the port accumulator
to u32 and reject values above 65535, and reject address octets above
255.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Joas Antonio dos Santos <joasantonio108@gmail.com>
---
v2: use real name in Signed-off-by, add subsystem tag to subject (per
    Pablo Neira Ayuso)

 net/netfilter/ipvs/ip_vs_ftp.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_ftp.c b/net/netfilter/ipvs/ip_vs_ftp.c
index b315c608f..9e3e005a8 100644
--- a/net/netfilter/ipvs/ip_vs_ftp.c
+++ b/net/netfilter/ipvs/ip_vs_ftp.c
@@ -102,7 +102,7 @@ static int ip_vs_ftp_get_addrport(char *data, char *data_limit,
 	char *s, c;
 	unsigned char p[6];
 	char edelim;
-	__u16 hport;
+	__u32 hport;
 	int i = 0;
 
 	if (data_limit - data < plen) {
@@ -144,7 +144,11 @@ static int ip_vs_ftp_get_addrport(char *data, char *data_limit,
 				return -1;
 			c = *data;
 			if (isdigit(c)) {
-				p[i] = p[i]*10 + c - '0';
+				unsigned int val = p[i] * 10 + c - '0';
+
+				if (val > 255)
+					return -1;
+				p[i] = val;
 			} else if (c == ',' && i < 5) {
 				i++;
 				p[i] = 0;
@@ -222,6 +226,8 @@ static int ip_vs_ftp_get_addrport(char *data, char *data_limit,
 		if (!isdigit(*s))
 			break;
 		hport = hport * 10 + *s - '0';
+		if (hport > 65535)
+			return -1;
 	}
 	if (s == data_limit || !hport || *s != edelim)
 		return -1;
-- 
2.39.5 (Apple Git-154)

