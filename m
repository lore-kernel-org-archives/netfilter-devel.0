Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F24C23A99F
	for <netfilter-devel@vger.kernel.org>; Sun, 21 Jun 2026 18:49:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782067781; cv=none; b=Bl16XRJscD52y6gMob0MUlXDIO9PA5HLqEODHNjnvvVmH+2h7wW4gbU2VgsB9Fcok4Iw40QM/aJ+Xht8EFcI3qi+nnDNeb+2pDYaxYJ3ZepQixJ2fya3St07DnZOwqbU/Iv9brr9VQsxEEoVj2OJFawtFl3Xvrfg4WQR5hXaF3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782067781; c=relaxed/simple;
	bh=fg2Z5yWsPrCVVJ/sEpZZmfaN50vF39KwM6Wf//qFPP0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WQ8ufhZuEm4fi01uZjtaj3iEnJRrnMy+0zoJEbM02ki+BcPsBcWX6eHiIkobQvozjHJ5JWoz86/eUsySvj4UuK2gjNiB8wPkoF9ekIfE37wNz2CaMgNuivZGP/+v6MiFvuhF6lAcjicivjTEVj2pt4gKvsApV8gc1jbBidVirEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eW03vsjK; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eW03vsjK"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4908b92904fso51905045e9.0
        for <netfilter-devel@vger.kernel.org>; Sun, 21 Jun 2026 11:49:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782067778; x=1782672578; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HQS8YOQaAmDtiitnaliN5fbm65W+3tVHNnmASlMo0A8=;
        b=eW03vsjKPSSwlblgNf+XI+zQGrI6Ba/pNV1W+smnKqqCCTA2LjVzi+yRXGP2qGSiL6
         dalDweebDvIP//TcuiA40Nc0mb5TxX81WfbAi0C5jDVyIWBvWIDlzWEiVMVQkdj5R1ek
         h0+9ZL3psyx3Xd5rFYFF8trG74njfwisjy2big8K9TqWOYqlurg5El/IwZ6lxv12P1Ks
         qkJ6vI9eOcKUvRrpDAV+Am2FMfa9oAiPOD9QNIggLSkXgbQe2JyrfgW/xvlY9Bdriijw
         UakY1u3+hgz+A3DhHxrKE/k+VJN7xUioZw2fcvqVJkcTIM8cYWX4iGsg54dt7k/Wb6dw
         pjTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782067778; x=1782672578;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=HQS8YOQaAmDtiitnaliN5fbm65W+3tVHNnmASlMo0A8=;
        b=PBhWBOmnKhz0slzhHdRZq7WtO2MIGFekUnN67dEqqSasFVqwcDuHbF8NwEAj1Qzq2G
         mLNpbW6uHCgb2KGL7/XlkpyAazx1dwcuATRw9kOe88M/svANbZ2PcKjoseDPGQkmBmLX
         icsacX0Fxl0NOs6LNH1OpPApONw+5xqEAfTbUCBVNj3uffLS/fyY2G2YpYZ+SKukrAfd
         REGZC1L/8E04v6LhPIZRYMWzdpkXy6YI/4Nwc9WYbzcujAxNiyKKjlSXSDgAoQbKbLVJ
         kx+yZhEUxvu8QnNM6hDN290wO7kl9qzSOiffU0YbNqSdwN+/xivgQx0CbGMVGg8uSRXF
         3RiQ==
X-Gm-Message-State: AOJu0Yz24Wz13oSL12iOxalY4yYgdICCoCpa6Z1V9BiJvO/QupHUHmnW
	9DQCz7LSzfWHKbq7ys9KWqr9jI4xud6iUYgLBb7pXM+aB8FtQMBQ0Y+b7q5VByn2
X-Gm-Gg: AfdE7ckz6GO7kaI2Ltj9TXd87utnlcWc45Hm8dsYJSD/ICUr8F4ChVQm8F9drVP5+JE
	LVabRUQ3JY0HQPam2I9cnkGj9UHhee4DzZF8jMhsqT3gN/+hV7URQX5GGWTfouhSSX5jaz1rO3D
	cglpZeW0JdXkvvWQf2OHyXMH0pgqe1Rq4lxbF3lAs8RDqtfHn8p0UxDwW4zUu0qjqmxVVWWwL1C
	2R8xvA891juG7Au9NGwmacm33zdND3KbDSb4H1O/uG5HZ6DJbdzLPcmULi6yKTUpnJXkPQnt+U3
	13WjbjluaWIxqDtrU76yqTpx6Yd1vNQgHH69Ep18OEgI0Hk+V0vQGq7G2bDMyMj/EBR0p/BuZId
	i2aYhJQSpYEUv3z80EOxRPz3/i6HZTTV54DE+B9V8No/17FWasJt6Ify5WxZ4CgQQvBDRfE4Qgk
	FQSte3ItnyqC2VNgOvWBHuNXkRkpxLUiY7Ovad+melNlcZ/33CfmYfU5oke1W01vESWfULQuIxE
	drf1Kb04P+Sjknj4UCZ+EA+
X-Received: by 2002:a05:600c:3f12:b0:492:40f2:4d78 with SMTP id 5b1f17b1804b1-49242326cfemr123932785e9.2.1782067777843;
        Sun, 21 Jun 2026 11:49:37 -0700 (PDT)
Received: from britney-pc.tail2180da.ts.net (host86-132-246-30.range86-132.btcentralplus.com. [86.132.246.30])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-466648c5397sm21085938f8f.13.2026.06.21.11.49.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Jun 2026 11:49:37 -0700 (PDT)
From: Kacper Kokot <kacper.kokot.44@gmail.com>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org,
	kadlec@netfilter.org,
	fmancera@suse.de,
	fw@strlen.de,
	david.laight.linux@gmail.com,
	Kacper Kokot <kacper.kokot.44@gmail.com>,
	Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH nf-next v3] netfilter: TCPMSS: handle packets with unaligned MSS option
Date: Sun, 21 Jun 2026 19:49:33 +0100
Message-ID: <20260621184934.75832-1-kacper.kokot.44@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260528223412.27311-1-kacper.kokot.44@gmail.com>
References: <20260528223412.27311-1-kacper.kokot.44@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

RFC 9293 permits TCP options to begin on any octet boundary. Padding
to a word boundary with NOPs is a sender convention, not a requirement,
and robust receivers must handle unaligned options (MUST-64).

The xt_TCPMSS target's incremental checksum update assumes the MSS
option is word-aligned. When it's not, the modified bytes straddle
two checksum words and the resulting checksum is incorrect. The mangled
packet may then fail checksum validation and be dropped downstream.
That said, all mainstream stacks emit a word-aligned MSS, this change is
motivated by spec conformance rather than a bug observed in the wild.

Extend the checksum update to handle unaligned MSS options. When the
changed word is unaligned, the modified bytes b' and c' straddle two
checksum words w1 and w2:

    | w1     | w2     |
OLD |  a  b  |  c  d  |
NEW |  a  b' |  c' d  |

The two-step update C' = C - w1 + w1' - w2 + w2' reduces algebraically
to a single word incremental checksum update with byteswapped operands:

    C' = C - w1 - w2 + w1' + w2'
       = C - (a * 2^8 + b)  - (c * 2^8 + d)
           + (a * 2^8 + b') + (c' * 2^8 + d)
       = C + 2^8 * (a - a + c' - c) + (b' - b + d - d)
       = C + 2^8 * (c' - c) + (b' - b)
       = C - (2^8 * c + b) + (2^8 * c' + b')

So the unaligned case adds no extra checksum operations.

Signed-off-by: Kacper Kokot <kacper.kokot.44@gmail.com>
---
v3:
 - Reframe as enhancement, not a fix (Pablo/Fernando)
 - Rename subject to xt_TCPMSS, drop "fix" wording
 - Reword commit message: packet may fail checksum validation and be
   dropped downstream (Pablo)
 - Target nf-next (Fernando)
 - Use __be16 for csum_oldmss/csum_newmss (sparse warning from
   kernel test robot)
 - Reorder local variable declarations to reverse xmas tree (Fernando)

v2:
 - Use get_unaligned_be16 (Fernando's suggestion)
 - Fix alignment check expression (David)
 - Mention it's a theoretical bug in the commit message
 - Drop cc stable, the bug is only theoretical

diff --git a/net/netfilter/xt_TCPMSS.c b/net/netfilter/xt_TCPMSS.c
index 80e1634bc51f..037add799d41 100644
--- a/net/netfilter/xt_TCPMSS.c
+++ b/net/netfilter/xt_TCPMSS.c
@@ -116,9 +116,10 @@ tcpmss_mangle_packet(struct sk_buff *skb,
 	opt = (u_int8_t *)tcph;
 	for (i = sizeof(struct tcphdr); i <= tcp_hdrlen - TCPOLEN_MSS; i += optlen(opt, i)) {
 		if (opt[i] == TCPOPT_MSS && opt[i+1] == TCPOLEN_MSS) {
+			__be16 csum_oldmss, csum_newmss;
 			u_int16_t oldmss;
 
-			oldmss = (opt[i+2] << 8) | opt[i+3];
+			oldmss = get_unaligned_be16(&opt[i + 2]);
 
 			/* Never increase MSS, even when setting it, as
 			 * doing so results in problems for hosts that rely
@@ -130,8 +131,25 @@ tcpmss_mangle_packet(struct sk_buff *skb,
 			opt[i+2] = (newmss & 0xff00) >> 8;
 			opt[i+3] = newmss & 0x00ff;
 
+			csum_oldmss = htons(oldmss);
+			csum_newmss = htons(newmss);
+
+			if (((char *)&opt[i + 2] - (char *)tcph) & 0x1) {
+				/* MSS option is unaligned: the modified bytes
+				 * straddle two checksum words. Byteswapping
+				 * the operands lets a single incremental
+				 * update produce the correct checksum delta
+				 * (see commit message for the derivation).
+				 */
+				csum_oldmss = htons(swab16(oldmss));
+				csum_newmss = htons(swab16(newmss));
+			} else {
+				csum_oldmss = htons(oldmss);
+				csum_newmss = htons(newmss);
+			}
+
 			inet_proto_csum_replace2(&tcph->check, skb,
-						 htons(oldmss), htons(newmss),
+						 csum_oldmss, csum_newmss,
 						 false);
 			return 0;
 		}
-- 
2.43.0

