Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F7AF1B7EF
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Mar 2024 09:08:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710320903; cv=none; b=m9JMW6VTkYuJtbKUYFNShndQNPTISpzvhTCIem5sPd1EetwXhqm1Sz24cdOVLb0Q2TkXLIGJl19tCfrgZgwWWT39UZo8ImtSW18lZpLma9OB1a72Ji+K+TsWSS/FjxFVI4Gmbre5WIdnukfpIDJW987c2ncSj+o43iBI1z/6+ao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710320903; c=relaxed/simple;
	bh=atjGYn/upnCyH0mcou6V4VvVDT2K5iwoBKEjF6n3qso=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=h2+mxmU9P2UVcqYklLx2q+FTJDuU23wnJqEmZRsEPWDVzmd6XMdgnO6IOUhqhmtAqcQtjA8FrFkYjHr4Kr4kvnWBJ41UYVsh3znVeS7sDlvV9hCMIPLslULUEPDh+aZ5THCd9z/2vU7s1jctyOQg1qStHi66MbyH9VfooJmDlwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZcsLyf7j; arc=none smtp.client-ip=209.85.219.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZcsLyf7j"
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-690ddcd97dbso15192606d6.2
        for <netfilter-devel@vger.kernel.org>; Wed, 13 Mar 2024 02:08:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710320900; x=1710925700; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=xTDvq3R7VGNG89SZNhL/EGWnDOGocbPH5NzvAO5fUEU=;
        b=ZcsLyf7jmlTTuVdf6GeYvTFZbfbbGXTjj/sx9FahhNIT8iHNDl/A+5FDnmAKb/LId2
         11sNUSN/VVbVT/CMJcKJPpG440CKz1lLZVhvcSHay2rOvCL57baoOFL/TibPdwqzslRI
         lc13J3ry/Fv2LDusduRFFu/OUOIS5C3OmtiTzzKokMsBn6TQmQQ+JQSrGO36mFRsS3zF
         ztzG6X5rPKVVHTtIEFV/jGW8wxSVYPIBfWogpNgYpFeVvm4hQqveLgFl86+iD1pdq6vR
         TEqyQ8MqsXDuWsL66P5rXcOde2S7qBQghF9pkhPgWvmS6Ycugnlsl5PLMi9s0cEkZA0X
         VSrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710320900; x=1710925700;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xTDvq3R7VGNG89SZNhL/EGWnDOGocbPH5NzvAO5fUEU=;
        b=tw+76xS/ee7oUz3BPP39pX5bzBCecLNGLROFQ7zr1Y7jZ9vMKpgz7X2RSPc9nsw0Kl
         +lxnSzpOIAdlEC1mc5D8UDqK01kr6xHCludNrx2n3WMZ04P+MpkPNJSvePxDYEsBU3Sr
         D6xAMejXOMC4Tn1mJPs0h9dcIo0UGEzh1eieLgs/dYNOZCrKcxQ4lId98b1Yn+IsYJQU
         15OMOZPMuB0cYqZfU/Ts3lR50h8Tm3nE04j0wE5Rz7EkvRxt2hwF+Hd6J23RWrG5Pj1E
         Vr1Z0mTu0tHiYRHUQLS+w+rw1HAtcQigYFa2YbqU7Aw6GgABCIaBwrWgunOE79XeXbX4
         3MVQ==
X-Gm-Message-State: AOJu0YxnwBKhqRlTAfAOI2mjKvY6f9B1VMvQbN+fDFPWc6ujr9cQk27P
	i/ZLG5vX+SzZ7HxrPEnhI9bgKPXeL6idLhxUQpkuwfC5E0vnX5Wv9kkf7nlCyFvMRVcRjcjbj5Q
	rXC9eTRDB37TJt/cZ+mKVrHJPvg5wXkeetSE=
X-Google-Smtp-Source: AGHT+IHfkE++lKHGo+laf/GnC4umjZleVq0GpQBI+dl4WrLcrCbFNu670oc4ETlhz5TZ9xW4toSOlvr6U9qs8gXStL4=
X-Received: by 2002:a0c:efd3:0:b0:690:b2c1:83d6 with SMTP id
 a19-20020a0cefd3000000b00690b2c183d6mr2864708qvt.25.1710320899994; Wed, 13
 Mar 2024 02:08:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Sriram Rajagopalan <bglsriram@gmail.com>
Date: Wed, 13 Mar 2024 14:38:07 +0530
Message-ID: <CAPtndGC29Zc6K8V3v4LStfrcnvdCNNfTmjP-Ma9dM+21f1069w@mail.gmail.com>
Subject: [PATCH] iptables: Fixed the issue with combining the payload in case
 of invert filter for tcp src and dst ports
To: netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

From: Sriram Rajagopalan <bglsriram@gmail.com>
Date: Wed, 13 Mar 2024 02:04:37 -0700
Subject: [PATCH] iptables: Fixed the issue with combining the payload in case
 of invert filter for tcp src and dst ports

Signed-off-by: Sriram Rajagopalan <sriramr@arista.com>
Acked-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index ee63c3dc..884cc77e 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -1307,14 +1307,12 @@ static int add_nft_tcpudp(struct nft_handle
*h,struct nftnl_rule *r,
        uint8_t reg;
        int ret;

-       if (src[0] && src[0] == src[1] &&
+       if (!invert_src &&
+           src[0] && src[0] == src[1] &&
            dst[0] && dst[0] == dst[1] &&
            invert_src == invert_dst) {
                uint32_t combined = dst[0] | (src[0] << 16);

-               if (invert_src)
-                       op = NFT_CMP_NEQ;
-
                expr = gen_payload(h, NFT_PAYLOAD_TRANSPORT_HEADER, 0, 4, &reg);
                if (!expr)
                        return -ENOMEM;
--
2.41.0
