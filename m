Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.210.44
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795239794;
	b=4DUD5i0blZgFCekjxjXDPzj6aKGTlYEhdb3mhggvdoRwDSWY40gRkVZ1+4XLhQXhJXcI
	 QQlvEFQZoCGIYiWgbTn5VsFjP+bIy66rL374xk6zaHrYsB8RCDDpTFAEFaGoEhpu1fcHw
	 BXdWAq2Nc9uvo+x7wUq1wHoJ9Gc0wDrW6kftPynt22ia7S9NYqsBlSpjKKHbcS3Xqm4RY
	 OT1EzroGqaBfNhLKWhwtGQVLXKRcsx2oo5ZF083XeeqkjcHTH8d6WwFwB9/61RRv0bPgE
	 pN9Q1s/jGJt67zldkCGx9FqZLbME3Gi/Z5LXZkqrGl0ZOHY6q6AigXE6piYCd75/Yng==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795239794;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Received:MIME-Version:From:Date:X-Gm-Features:Message-ID:Subject:To:
	 Cc:Content-Type;
	bh=GyCQbqHslRPCN0BlcAsTpuqOM8qUEQ/kj7/bK6QLs2o=;
	b=k6eFaNPXgLY6UDhcqIIkuTS23xits8noaBYlN+fqxAucRumd+GktvESrlZgj2k4V83Ko
	 2NVPMxC7JserLQAf3exeRFfSM05Km+Tf0ZHdpPX1ZcRF6Hb6cD4Yzrpmr07lCNFaGgA3p
	 SToJqVXhJ9+lTg5p96FAlKDOSfhzSuvAcRnmis6+hzt26AIe6oVIAXMn/ljYAFokbqJN8
	 HlwhaxHzgzE1ruH+C57SmHHOOQOeW8FYIQKNlUOQT27JAog0NqeYDD9XzJaVuQHJ2pqoj
	 k7n3m3W1dtxU8QjttJs/sTwcfUZN44dz6MNsFzi3gMEkOfbO/TgDidxYj7XlpwRLA3g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=none header.from=ikotaslabs.com;
	spf=pass smtp.mailfrom=ikotaslabs.com;
	dkim=pass header.d=ikotaslabs.com header.i=@ikotaslabs.com header.a=rsa-sha256 header.s=google header.b=Z2c6XH5I;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.210.44
Received: from mail-ot1-f44.google.com (mail-ot1-f44.google.com [209.85.210.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 925B7606A690
	for <netfilter-devel@vger.kernel.org>; Sat, 21 Nov 2026 05:43:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 925B7606A690
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ikotaslabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ikotaslabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ikotaslabs.com header.i=@ikotaslabs.com header.a=rsa-sha256 header.s=google header.b=Z2c6XH5I
Received: by mail-ot1-f44.google.com with SMTP id 46e09a7af769-862b090e3c3so930720a34.2
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Nov 2026 21:43:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795239792; cv=none;
        d=google.com; s=arc-20260327;
        b=VLzsnlr3LtWfir3JEWP20wRKk/1aKOXi7yyN9jHTDrpXPt1dkPwKXJMnXcX+2nzFtL
         zmhsdLyCG3LqqpVw1aX41OlOBecTs49vsaeKP4WCjxMXYoHY9W0/ei+/6MkjJ6gAK7Po
         PNzUotK9d3IRVbm/kKc5S6O9iiypNzr+jwFXozkVU70Cm66xbCNzUyJjTUFcGveJJiXn
         uVhVdaPzVDu+FC9aSuz4vogvEfh1fygqpIE1LjlScCRnre7tw6d/o3ELkm6SuMoUqgGf
         mDKHwRW3x6cLZHEjGLj+h28y2Vgdt2u3qV4jrsFqlm8yvNNwU4P1eR30SRkHnvqXhhzG
         I9DQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=GyCQbqHslRPCN0BlcAsTpuqOM8qUEQ/kj7/bK6QLs2o=;
        fh=N0PyFurO0Vp3n5npphqqs0IfKKxPlbi6RZCmrP9mihU=;
        b=HZQZ4olcSV2etL6u9E7tvvlfRQSQMYjq5qMwrRpIuRK39pvM4xF4cPxLy0jw8j5cY9
         hv5mXRZJI98HVaqwx1cgipdEgcsjC6L8uHzXucAkL4urgTC228dMB4t0xrHuKM4HBtTR
         88vKrtre6q1+yK/PocDSqzMmM6EX4dKsis/porwBNWaD6vmiuIpy1Lby6LbHqN091+gp
         Y5xr7pTLlcX5GMalD3ZoJZpZS0PyS5ERyJV7I07s5WFjjQiFxZNWOkRhAi+IWWwmuPOX
         mn09iJth8eFDs3NOiQvdZsOjvW4uWFdtlxavOvhg69YuhgWqjfRFDLMJupFSZV54B4lu
         H3AA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ikotaslabs.com; s=google; t=1795239792; x=1795844592; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=GyCQbqHslRPCN0BlcAsTpuqOM8qUEQ/kj7/bK6QLs2o=;
        b=Z2c6XH5Iv9rSSoZa5wVTh0Qc2DZsmogPUdOuo6NLdCc7yUdJWJTTt3JYgWLMvmSaXT
         HHhxg4QZ2fKLpJdSb5Wt55S6+DaApKaGcrrLay4pJ1vJcswOr+krxe1/H+kO5DllKQnq
         rSE4oyYngfgs+Cn6tVRd6XSz2nPtNSx0WWPSiSBdvsI4BxmjMeVrKQ5Uk47FEBej9CuQ
         Sku71Hr75k3Pl5dKYaaamkKkZafMI4qbxIPaZrHaAu8IYu3HqzgK42MCN7Q+CA/T9Op8
         IFbFETdHd8dMGI+nVXcLfhxLy7zD84gGNvQBN8u3uuDWkIZjuFOfVSODNFeehVIGSAgl
         Jp8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795239792; x=1795844592;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=GyCQbqHslRPCN0BlcAsTpuqOM8qUEQ/kj7/bK6QLs2o=;
        b=iWdY4bKGdY/qGm/X+Yih0wWMEgSQduP5V4mqQB8OgoBd7huWLkGcj2s9DUqY0Bx3E7
         N4bYiw0KZQ+C4NbS0quHrr4khbQy+kIiU/9z1jRSRwMMgmrG4saZgR+BQsnKmNfZKRHt
         LZHHwqg9rxP0UY4lMTpHZViCdD3qhDjIvaSTiALBgbI8JMpoLsBQiRx51dO1YJvokWD5
         iyaa2NJrTQruUsblNXcsepCmKwME/rpdjnfJ//FYgDhJ6AO8ULu7kMzU2sMLPIK7B4Ip
         W08p8EGnQYdEVrEwdQeMwobOR3OzcrpP5tBd0WPCAiadj3WgDbD9pYUgmAJltDxzRA/k
         xy2g==
X-Forwarded-Encrypted: i=1; AL+hErGQpRn71IdLPmBIsPfCBsJ6l6Eyo5J3CDuOm47oGqs7DJtAIfzu0zOq0EMw0f/8YxVTH50HD557B4Rt2CVxj3I=@vger.kernel.org
X-Gm-Message-State: APuU4Z8b2SQLpaV7B6sA8EHt2kifwIj5BJ2SKm72Y4/gpLZ5FQpbgAKp
	hyg/8tBEBmgpnaUMDsZiI079vA49vdVFSzmYHXxCgLmVVHN0f+pL8vu9dRYy5Cb2Sg9qfeytHgh
	pRBuTdHGxzkBrd7CscybXBmbcz9CQ3mqoQYZYu6lKmwTupABLPLMh9Q==
X-Gm-Gg: AZFdTZclkaGcZxfd/xRNqjqBzfml2aDgAUN4S2q1HliXYsOIr+0gJUiw7PegM9tfrgg
	xgj03pbRE4PTKtVagyf6xdJ4IwtPqgMRd1LOH5TPQAvU5ekgil0SX9J0VkusvDhTrKYMsglQttC
	ML1q/8TM7YITCTcC8p3cPJIs6ujIWurSctrG+QT2vYjcGdyOYgZ2kD+ok2U//A/P6rizRegKxBq
	dLBegPOtJCGV0aZgI0ljJv+mwiNYmtqJKvFG1h9N6D0qrBbOXhOb4DNMUEtFZjvb/wadXkL2iOh
	t5CbScanpijoxPdIkH1Xzn56BbNkgzAc/PZOclotLsQmQOwlXIK7KSredozjE28zl7KzBZv2EGx
	7SoVBRxJ39J0zqviev4pgQvQ1/v9z4eWesVrD53rIdTTbA5TFBzuG8TajiNkQ7IWRXk01+dFhU7
	CA69nVqB2mgFhz0A7FI/3DzvuQzLOp8cewESQd3k9pWg7BfPF8a1xT
X-Received: by 2002:a05:6808:1994:b0:55c:7ce:cb77 with SMTP id
 5614622812f47-57a0ab3002emr6180168b6e.36.1795239792508; Fri, 20 Nov 2026
 21:43:12 -0800 (PST)
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Fri, 20 Nov 2026 23:43:12 -0600
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Fri, 20 Nov 2026 21:43:09 -0800
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
From: Ryosuke Iwahashi <ryosuke@ikotaslabs.com>
Date: Fri, 20 Nov 2026 23:43:12 -0600
X-Gm-Features: Aa3M54pygLHkkrw6rr2bSztJSkdHRt2AkqoFHCLYkS_7I6WmDcrV3O9wcYd2niQ
Message-ID: <CAN2NGG5eq=HbzKRJzErww6uFSR3rtNJquMwESTGPBcAuLyhfGQ@mail.gmail.com>
Subject: [PATCH nf] netfilter: nft_exthdr: stop the TCP option walk at EOL
To: Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>
Cc: Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

RFC 9293 section 3.1 requires zero padding after the TCP End of Option
List (EOL). The nftables expressions that read, set or strip TCP options
keep searching this padding for the target option.

Stop the search for other option kinds at the first EOL. Keep the
existing behavior for explicit EOL matches.

Fixes: 935b7f643018 ("netfilter: nft_exthdr: add TCP option matching")
Signed-off-by: Ryosuke Iwahashi <ryosuke@ikotaslabs.com>
---
 net/netfilter/nft_exthdr.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nft_exthdr.c b/net/netfilter/nft_exthdr.c
index 861bab93f435..ce5494cfd4e8 100644
--- a/net/netfilter/nft_exthdr.c
+++ b/net/netfilter/nft_exthdr.c
@@ -204,8 +204,11 @@ static void nft_exthdr_tcp_eval(const struct
nft_expr *expr,
 	for (i = sizeof(*tcph); i < tcphdr_len - 1; i += optl) {
 		optl = optlen(opt, i);

-		if (priv->type != opt[i])
+		if (priv->type != opt[i]) {
+			if (opt[i] == TCPOPT_EOL)
+				break;
 			continue;
+		}

 		if (i + optl > tcphdr_len || priv->len + priv->offset > optl)
 			goto err;
@@ -264,8 +267,11 @@ static void nft_exthdr_tcp_set_eval(const struct
nft_expr *expr,

 		optl = optlen(opt, i);

-		if (priv->type != opt[i])
+		if (priv->type != opt[i]) {
+			if (opt[i] == TCPOPT_EOL)
+				break;
 			continue;
+		}

 		if (i + optl > tcphdr_len || priv->len + priv->offset > optl)
 			goto err;
@@ -347,8 +353,11 @@ static void nft_exthdr_tcp_strip_eval(const
struct nft_expr *expr,
 		unsigned int j;

 		optl = optlen(opt, i);
-		if (priv->type != opt[i])
+		if (priv->type != opt[i]) {
+			if (opt[i] == TCPOPT_EOL)
+				break;
 			continue;
+		}

 		if (i + optl > tcphdr_len)
 			goto drop;
