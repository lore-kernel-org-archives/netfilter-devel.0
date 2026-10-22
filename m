Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.176
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792689777;
	b=12AcwBXbk+tVHz/mcTbcl5nczARr7UyESB0Gh4Yr6KfjBW9PG3+YgdtExb7nMCsqK+u5
	 Ibvhm6jZEgv3dca2TmpSq/f6vZSVH2xgVG+SgbsL4rcXtWlUtMcHVlqNSVu7+Uk8vRNgK
	 /+nb+AXxBQeOPLiv3d6m4obcPtjcgEDsj5IaxQUj/e/NvZeAQA9hkrRolkMueZDsRGWOZ
	 8CS3TC5yfSy7fogtyuda6QblNiULIoiJPG4QCnuldfdeE2wcW+S9UBNiDtt+oFMDysHZt
	 /0VhGuQNRZomhQRxukFRkQot/LDKzQQWjsknMnhFGythUKGh1/66EkVezpjX3xfZu9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792689777;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=3Fxnb+tmDz8vD/RCSb1yDfS8uHLVRtbiJwimxAWXwl8=;
	b=i7P28Bs+TvPEZZGutm5WA4+4IAr4JntFLIG7yQl6qb5ZYm6X6poHoFK0yOqfKDNUrISG
	 YLMixKDW34wczyRwLt2/YVi8K2kkoauEXb+pagvCOYMrPDv2M4A4GnlCDQjo1b3laYj0e
	 trMYPD9GrbzE83JvMxtS1AqNLcSbHbuRXUusOlyv+DgutgGSovVHRaIqI2a237hM25FTx
	 m2p2wtbnauYEOnphyMGntTE6mTWv1vGyJ8cGa/pneRIWKHQm0rs/ZnD3cN+dHHNONZjai
	 ubZgHczpvlw+DEpg6mYtfGouvcblnY0IMVOmWlA6z2Hph8s+jlIdJqHuhd3r1n57T9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=D7y+e548;
	arc=none smtp.remote-ip=209.85.214.176
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A72D7606A31E
	for <netfilter-devel@vger.kernel.org>; Thu, 22 Oct 2026 17:22:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A72D7606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=D7y+e548
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2e9995ce866so16254295ad.0
        for <netfilter-devel@vger.kernel.org>; Thu, 22 Oct 2026 10:22:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792689776; x=1793294576; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=3Fxnb+tmDz8vD/RCSb1yDfS8uHLVRtbiJwimxAWXwl8=;
        b=D7y+e548RrVflPxq20p6GTx6fhtREdk3YQuLBVSgVzBv+bTswPoGTzj3iua7j9o1dk
         6YR/zzZ5fm9OmD91z2AUk2nEWIDH5+2Hv5gClEbE+knloO7Y4EiOheYnaoQc81H9Zp4B
         XWFsHK0v+nRiIcSyej8SvGnzPruFGf0D/+D6vPIJU+ZOQ32+dHKDgWBYjAnfpK4HXygv
         RzeRMc5jur2GRVX5+GDojE4Dcyy0ZLU5AHJxovZSFddDPdli05xu93cgEXlL/d0ZXMVw
         2TxF61j6SxekpAzrwUvE9mm3i8GCMX17RUE/tqzyT2Hc4OjX32M0fY2ovHrIRIHpizwn
         4S1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792689776; x=1793294576;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3Fxnb+tmDz8vD/RCSb1yDfS8uHLVRtbiJwimxAWXwl8=;
        b=O7f/PGuh6GP1HkQJsb87SZQgh2u8xc76iiRJpzHzZ6GrgY88RHEN0l9MYOif9+VHvN
         bSv7nOakx9FtMzBC+C40FfPExFX+8eTxR20ocMNBFFSMt/MF+MN6eoUBsCydbZQHSVk2
         Pq2y3aNBPPCwCmCS/MHvmEz/u2jzNyIpOgN0N5ZV0CMTft/qWwsnmv3+jBu3geJViLy/
         IXGV1X5R6L8NNS6S9VmsdLVDxoFMK4XcFRJRJwwh1lhtbaRnJERqjZsJtVPzZG19dEoy
         izOiPk8VGyuw8b57tprGpaABPQdrjos5eohzYwDnSGB41u+k777jSjo6wrmzoo1vFJJX
         uuxg==
X-Gm-Message-State: AFq9FYIMwXWzPqC0gnEkoY8jADZZ89AgEgWPNXr+QhiN+5MUm6tUZ9sc
	ATIzwN0uGjvUHXEqe40V6Dh1f4/e6WjSVH7QT/7O2xVm3BHS02aQh2qBxb94R+1+CvA=
X-Gm-Gg: AYBFou0l9mY6t39+oU+0NhjuE/lj/HZKDgDVOR87JW4XcCGJl3sXkXd7RodHBNsUwUv
	Dv+kUF92M77f2T3GRNsH+sQ3G0CoC0nrn/hLDPg+p13XsKEE2AzhlSyXRThBMqnFyIXkzdwCEeU
	9gIG4Keyjb2UNpXUlqybZUlgSZQNJyFzOuExLXHL4g7KD9o7IwjF//h7e94LEXTO2FRHk6gHLFy
	huF0NEmvTfwXpk6UrmKO6WyD7JCkLaII4vMPMMtr6ESWWCotLx7aAcvSdq9a9T+mbJMrygReYW7
	aXu4yFk1jIGyBX5Lv+YDTRKzvOxYAcNZ6IV/X4n3qjN70PI6P0bWXOj7FFpWgrbjGUGqoCIgVw0
	NRAly8qTD69cPuhqi9A+GZ0DQitH0Z4FcH2fusHVMdCD3dfl2jS174HS1oVwVWeWLR1sZwzFM1o
	0MAhNtT9MQ/0gUwg4kYnD9myN+2MsBVkNBowAOpU1m8ingSFPxYsHjhpwGJIfvM4bt17FzZ7bFD
	lRN+h97YpWSXofEHlkKUILnpmAfQkBvUskDkT6v8cbXV1a6NIonq4CkoHXPIdHdnPuk4kSRnS/O
	n8+xKMDQf4DYwKiJjmCuykYmW5yA/Lr1dz0gGkLmZU5wAiKOw1Y2mApdSBwD5EEChN5MFJ9z7JT
	eeWFVzRpYTvs=
X-Received: by 2002:a17:903:1acc:b0:2e5:cb1f:898c with SMTP id d9443c01a7336-2ea43fb8270mr49485025ad.46.1792689775940;
        Thu, 22 Oct 2026 10:22:55 -0700 (PDT)
Received: from test.. ([118.68.116.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ea7b3bc816sm1217915ad.51.2026.10.22.10.22.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 10:22:55 -0700 (PDT)
From: Duc Anh Luu <luuducanh05051995@gmail.com>
To: pablo@netfilter.org,
	fw@strlen.de
Cc: netfilter-devel@vger.kernel.org,
	phil@nwl.cc,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Duc Anh Luu <luuducanh05051995@gmail.com>
Subject: [PATCH] netfilter: nf_conntrack_sip: fix out-of-bounds read in ct_sip_parse_transport()
Date: Fri, 23 Oct 2026 00:22:48 +0700
Message-ID: <20261022172248.554687-1-luuducanh05051995@gmail.com>
X-Mailer: git-send-email 2.43.0
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

ct_sip_parse_transport() compares the "transport=" parameter value against
"TCP" and "UDP" with a fixed length of 3, without first checking that the
parsed value is that long:

	if (ct_sip_parse_param(ct, dptr, dataoff, datalen, "transport=",
			       &matchoff, &matchlen)) {
		if (!strncasecmp(dptr + matchoff, "TCP", strlen("TCP")))
		...

ct_sip_parse_param() sets the value end to the surrounding limit when no
';' delimiter follows, and that limit can be the end of the SIP message
(dptr + datalen) when no ',' is present either. A Contact/Via parameter
such as "transport=tc" placed at the very end of the payload therefore
yields matchlen < 3 with matchoff + matchlen == datalen, and the
strncasecmp() reads up to two bytes past the end of the message buffer.

The value of the over-read bytes can also flip the detected transport,
so this is not purely a read: a crafted short value can make the helper
classify the transport using out-of-bounds data.

Both call sites (process_register_request() and
process_register_response()) are reached from attacker-supplied SIP
traffic when the nf_conntrack_sip helper is active.

Bound each comparison by matchlen. A value shorter than three characters
can never equal "TCP"/"UDP", so this only rejects already-malformed input
and leaves valid transports (TCP, UDP, TLS, SCTP, ...) unchanged.

Reachability and behavioural equivalence were verified with a userspace
ASan harness built from the verbatim parser functions: the over-read is
confirmed as a read past dptr + datalen, and the fix removes it while
producing identical results for all well-formed transport values.

Fixes: f5b321bd37fb ("netfilter: nf_conntrack_sip: add TCP support")
Signed-off-by: Duc Anh Luu <luuducanh05051995@gmail.com>
---
 net/netfilter/nf_conntrack_sip.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index 64bc440b1181..1f9cf75c7bd5 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -701,9 +701,11 @@ static int ct_sip_parse_transport(struct nf_conn *ct, const char *dptr,
 
 	if (ct_sip_parse_param(ct, dptr, dataoff, datalen, "transport=",
 			       &matchoff, &matchlen)) {
-		if (!strncasecmp(dptr + matchoff, "TCP", strlen("TCP")))
+		if (matchlen >= 3 &&
+		    !strncasecmp(dptr + matchoff, "TCP", strlen("TCP")))
 			*proto = IPPROTO_TCP;
-		else if (!strncasecmp(dptr + matchoff, "UDP", strlen("UDP")))
+		else if (matchlen >= 3 &&
+			 !strncasecmp(dptr + matchoff, "UDP", strlen("UDP")))
 			*proto = IPPROTO_UDP;
 		else
 			return 0;
-- 
2.43.0

