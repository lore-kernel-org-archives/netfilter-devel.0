Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC42F1DF736
	for <netfilter-devel@vger.kernel.org>; Wed, 22 Jul 2026 12:57:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784725040; cv=none; b=qJgMrsx0qdUbeqyDQx/SFPPUE09/ry/jd+x/fwVeNVDt00CGlnfwaHlFamfnxBKxmrTsb6BwYOk/P5X+0lJY75bcdJPi+jtbbpbviDsWLnfXD2b2G4xEL11rGIMptuaHag+8+2HW+pee83GjefktJwNYHs8TIldD+sZ21Ell1Ho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784725040; c=relaxed/simple;
	bh=0juL770o7AYBx5qshZWKcpjN9zwA1c9uhtiLW3aAZv8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kgUxsb7lW84wjXdA7jyR7qkz9/oFmsudI+pzOVZVQlCgcljY0R+wczkz5jcv5vEqgLn9YE5GX0noU8cxLe38kK8Q4GPHsxCXDR5a4OGGYiDJ47D8mZ3flqRFXE2pc7X7l3vkN0JqP6AT98VDq5QLkE81DMANItRs9eBZsL6wyKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=em6FMAw8; arc=none smtp.client-ip=209.85.215.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="em6FMAw8"
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-c999f162c9aso8071063a12.3
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Jul 2026 05:57:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784725038; x=1785329838; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=I2rB9Ndyno38tvnD2Ic7hgwBLudpITP00SlVTEt+t4E=;
        b=em6FMAw8zJPjKVVTkU8IO7cwgaE14ywqzb5J80vLAEUlM1yFXrNXrAi8x7BxLoUw3S
         XbCDGnLDMYkI1Um06LvilcSHHPaB9TJPMt2fy97QRL1b/UUckhHNJRyk8Uy0D0pTYGnJ
         nW3ZsFRzcQ1da1OidkRbMRNYLrzB4IN8tu1IhySE3FNF1LNfqid6/eF4Za7U+9mMdtGo
         AJ7PFtGvSglK67OqwyL/FAwbgr/dMADmlOWCk8AhjB7kVPtlNjUiwOR4aT/MvPXG66gw
         nnx4w+cV9GSlvooCmk2G9yIXTheaQxFxrqh0etRnBnZi0p8uOQTHyun1d5paT3+y0ktG
         yVJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784725038; x=1785329838;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=I2rB9Ndyno38tvnD2Ic7hgwBLudpITP00SlVTEt+t4E=;
        b=FI+rd27/SDuCYS7TYX3T8jhUNCzDunOJo68wBVUNF+oBfMAEgjvntU2ot+peArWnNz
         PVjPtJ1i30boNLslgmxBTAIOIhE2B06HDVFp8e6NC810l7NACwIz3wJqSr2sWbzjlnqw
         hOnUki4raeaTnYlNXKOzN/1udUxc5ZIV1oSVtIzw2+Kb7YC4fL7KUcH9BBWOed9I1P6P
         NeGsY/N32nb5IxSuWSGgcsjBuw0oiZKzmdM0Hwf+pLfORJOAsrjJH3ijwQ4kvh2t+Bc2
         twvkjB/WxZPG+3c+R0qBiFRB5/JNeS3uCoFjTDudgSz4lAtZGruABRKcWgHpriGg8p1j
         hoPg==
X-Gm-Message-State: AOJu0YwtgBBqn3C+H0qDily2tyXYNO+zMXaWEO68LnLaoZ0idPkwv3Wc
	oJAbNZcIdMX05bB2XrP6iGz4UgOVFcdcv4Z5lunDqIzdzBPdiCVxjFCv3xA8MhRQ
X-Gm-Gg: AR+sD11gp6RjiO07JeE1VKWxrT1XxvtsrRdaj/UUIhc7YwQIBcl6RiOD+EecL0jH4Jz
	eZfXQpOkbWXOT4wklQzp2sjqzYPwMy+Tsb35lahInVGwd15Dt+NmKn79YNvTSV+jlIJ49h1cPo7
	iGD52/BDArA97W3qbcMj727HqCash2SBr9zupUs5cLYfZFvAAFVFuoHVcdcdXYjcp0tcaCUwQf4
	Q0UT9rjonkgIFYyrJBlCfbkO3gjA5hN61sVt24zYHqZoLJX9PuR8uDvX7HZftj1RgkzryXR5baM
	98IYjWeJ+CQxX8Pa0R0L6QP7Dv3xh+uXJwKbOoK5iEMSZUBVealJ7ssl+nDLBLra1m+govUu891
	KX0QXJuH+mBSy9ZZ7Td2aQGrNHT4PwPUSzeDD9l5mNqohMltNuxQQOUQZxIXA8nVtapRKOflxdz
	9HqvpRaWf48y/gsr+8w8Msl5hzbH22dEUoIPQDCDdNcxppmyWGh0oa
X-Received: by 2002:a05:6a21:7008:b0:3b4:8ba9:4d8e with SMTP id adf61e73a8af0-3c3ad7a3d10mr26306035637.23.1784725038068;
        Wed, 22 Jul 2026 05:57:18 -0700 (PDT)
Received: from DESKTOP-L3Q0GIV.localdomain ([203.230.195.19])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cbb8f0d7acfsm1140282a12.3.2026.07.22.05.57.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2026 05:57:17 -0700 (PDT)
From: Sangho Lee <kudo3228@gmail.com>
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	netdev@vger.kernel.org,
	Sangho Lee <kudo3228@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH net] netfilter: nf_conntrack_h323: fix get_bitmap() overread
Date: Wed, 22 Jul 2026 21:57:14 +0900
Message-ID: <20260722125714.1389705-1-kudo3228@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

get_bitmap() first consumes the complete bytes covered by the current bit
offset and the requested bitmap length.  For totals below 32 bits, it then
unconditionally reads one more byte for the partial-byte remainder.

When the total is already byte aligned, there is no remainder.  The
caller's boundary check correctly permits only the complete bytes, so the
extra load reads one byte past the supplied PER buffer.  A crafted Q.931
User-User IE reaches this with a 17-bit sequence extension bitmap starting
at bit offset 7.  An AddressSanitizer build of the decoder reports:

  heap-buffer-overflow in get_bitmap
  decode_seq
  decode_seq
  DecodeH323_UserInformation
  DecodeQ931

The same condition also excludes a total of exactly 32 bits from the
alignment shift, producing an incorrect bitmap for unaligned inputs.

Read a trailing byte only when there is a partial-byte remainder.  Include
the 32-bit total in the alignment branch.  This makes all start offsets
and bitmap lengths from 1 through 32 agree with a bit-by-bit reference
decoder.

The same input reaches q931_help(), DecodeQ931(), and decode_seq() through
an nftables Q.931 conntrack helper on current nf.git.  The helper's static
scratch buffer has tailroom, so in-kernel KASAN does not report this logical
packet-boundary overread.  A diagnostic check immediately before the load
does observe bs->cur == bs->end.  No crash, disclosure, or corruption has
been demonstrated.

Fixes: 5e35941d9901 ("[NETFILTER]: Add H.323 conntrack/NAT helper")
Cc: stable@vger.kernel.org
Signed-off-by: Sangho Lee <kudo3228@gmail.com>
---
 net/netfilter/nf_conntrack_h323_asn1.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_h323_asn1.c b/net/netfilter/nf_conntrack_h323_asn1.c
index 6830c9da3..482860d2c 100644
--- a/net/netfilter/nf_conntrack_h323_asn1.c
+++ b/net/netfilter/nf_conntrack_h323_asn1.c
@@ -228,8 +228,9 @@ static unsigned int get_bitmap(struct bitstr *bs, unsigned int b)
 		     bytes--, shift -= 8)
 			v |= (unsigned int)(*bs->cur++) << shift;
 
-		if (l < 32) {
-			v |= (unsigned int)(*bs->cur) << shift;
+		if (l <= 32) {
+			if (l & 7)
+				v |= (unsigned int)(*bs->cur) << shift;
 			v <<= bs->bit;
 		} else if (l > 32) {
 			v <<= bs->bit;
-- 
2.43.0
