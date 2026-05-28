Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAB8B30567E
	for <netfilter-devel@vger.kernel.org>; Thu, 28 May 2026 22:34:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780007660; cv=none; b=L1FNU9UQsN0U2LuNpRB1Bkv0E/jlBdWxr8fZt1OWbqdAX1XHF/9RnxLMIjITWVcFCk4+7WTT+NvBdbmWVmMrmWYGr6JAllk5c/Yvw8ptFTt7hdjfwn6n2PDV4df0cVOUgcnL20bBG4Hb4L0yYvjgnuMLLdMGETojavheJdoygYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780007660; c=relaxed/simple;
	bh=xjHdc+vc12MKCZBHKVjl8PEg9uX/avR1IAYxPXPh5jA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ihgiOoQuPKwiE1WHDbd4jZhlRp66Tm3NzUHVy5laRwZRYFiRsjmHXyXF2TVWckdfy5CvqDqVdrGT/SXE6W2l4cR/yoUnq2rDctBN/Dmw1L0SyuPBSOP3liJY1ifKUvR8aSRZl37+tlcqD+wO2xVsxwTrdGYniYQg1160zSZiNrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=e0nCwRC4; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e0nCwRC4"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4904c1ce4c1so72561335e9.3
        for <netfilter-devel@vger.kernel.org>; Thu, 28 May 2026 15:34:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780007657; x=1780612457; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mFy+qmKG40w4ZnEG39ULoB2AQiEuE/T4yBXKnfStJQU=;
        b=e0nCwRC4MYMX0NUvqz1odXpI04NBxW5keCFo5cwlmQnGVFWktenlyOhOnQ2otR0jfS
         r7ToCROIfMOTKaX7WtJho+FozZ3UwUyqgBaXEt7QZqJ3pTuMyYKU4Ns9wOdnBfsZBV9V
         LGq+Gq5HU+QgVUeurKVze5+SRnxAvSwEnvFGRbV4VYT12k0K3gmX/cuuc2pFFPN2G+w5
         E8nCdTYaiPoMJTOGJvuKLfxcjlqze28mKMhSqfAMxBIuozRfYFD4nO3RjwwAh9I0c+UL
         wJRaasuqe/d/riPUvqqjXTBonS+kLudh6eXor/fl5LufUDpbBXuzC9/8WYCKZlX5yMC2
         UG/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780007657; x=1780612457;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=mFy+qmKG40w4ZnEG39ULoB2AQiEuE/T4yBXKnfStJQU=;
        b=Kw2oz7flDbeg2Fn/KhDYW0IVhb1wYatruvwVSmkhKaVL+Puf7ew33actWXSerMfi/P
         mOh8UrVSZXiaIpPQd3dJYEGhD2sr/+w8IOGiMckIoozFMQIpjGX9HszV32NwVkh1cq9D
         PQ9WYlPDhMD+2qA7oz74MMRMOnYZU5eOcB/IZeg0UwGMQA2ShvXGYoWgQdpogtfqlDQo
         MZAr4tvFlSfuNQsZ0YAw6oLOf875Dq6kWo3u+0u4A6cgO1SBwi+cab1bAU3+ltLkAVur
         R+J7kds4GI0H1IoMaoIhtedLvU+RZKsbwwf+NYCGpVfj9tpFxGGvqveFtA98KhD1EAB0
         GQww==
X-Gm-Message-State: AOJu0YxaXuSKEjXKPp3Q54Dn7Cy++ZUMvi+edR2+RkMlJkBrmJyWSL3I
	L/YZZ+O28Ni1nwKmK9c5jVgk4Uasc3xFfr1jGwwDyByNvGse1Lcf5MLBZ5Xw60uT
X-Gm-Gg: Acq92OEjY1fckdgYDBnMNXkvnbOepFDCEogMc7TgHMbu5DIvyJj0d7Rrc1Pg0GvxKUK
	1JjmL8upndqXOS71Ktco8jjQUxxV2up++I7Faem+2j55zyGvmNm5+oyjc9ylE6W/RRVSpk3ZWWS
	ES1D0NLc2H3IevD9rEaaFkxS+14M9NRNE43AFUJB6KeseCmgTm0KLj8GiShSEf8tSvT4KeNDxgS
	h1KCMpIkl7jRf//hSmkH33oqF7k1t/hoCNyGNiyvOqxH9wJLG4KfSNAK4ffonIsh/mXCtPCKfR1
	bgEV/3HDqo8xPi+KTwszyafw4UwtJo6OHJz2KHcSwVSjd/6LUjibSYgxHWEW0HbISqaLI7Wm1n9
	YJB+622p4L34wuQ3TQk2p2PErLW6+YGU37seGJ/9vG4XXs1IRgCvHCdIQVbEDa0RopAwO9blXKn
	ewtgryHB/RnQKOg2psZmzDbclni3n2iG2UA4mJMeE5Fub0pztjgPbrw16TY7s1gW2QR6NXRPKbI
	w3MtbAJr0Br3ivnUl6mGj9f5soyP9I6/5ONJW96LOhatGOy
X-Received: by 2002:a05:600c:c047:b0:48a:9540:1a3a with SMTP id 5b1f17b1804b1-4909c07faa8mr4076425e9.8.1780007656895;
        Thu, 28 May 2026 15:34:16 -0700 (PDT)
Received: from britney-pc.tail2180da.ts.net (host81-152-149-195.range81-152.btcentralplus.com. [81.152.149.195])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4909caa7e17sm2611475e9.9.2026.05.28.15.34.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 May 2026 15:34:16 -0700 (PDT)
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
Subject: [PATCH v2] netfilter: TCPMSS: fix dropped packets when MSS option is unaligned
Date: Thu, 28 May 2026 23:34:11 +0100
Message-ID: <20260528223412.27311-1-kacper.kokot.44@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260528204020.7ae744ab@pumpkin>
References: <20260528204020.7ae744ab@pumpkin>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Padding TCP options with NOPs is optional, so it is legal to send an
MSS option that is not aligned to a word boundary and therefore not
aligned for checksum calculation. The current TCPMSS target is not
robust to this: when the MSS option is unaligned it produces an
invalid checksum, and the packet is dropped.

This has not been observed in any real environment. Senders place the
MSS at the beginning of the options block, where it is naturally
aligned, but the spec allows unaligned options and the kernel shouldn't
silently drop legal packets.

When the changed word is not aligned, the modified bytes straddle two
checksum words, and using the standard incremental update helper
(which assumes alignment) produces an invalid checksum:

    | w1     | w2     |
OLD |  a  b  |  c  d  |
NEW |  a  b' |  c' d  |

Since b' and c' sit across w1 and w2, we could compute the incremental
checksum in two operations by recalculating w1 and then w2:

    C' = C - w1 + w1' - w2 + w2'

But working it out:

    C' = C - w1 - w2 + w1' + w2'
       = C - (a * 2^8 + b)  - (c * 2^8 + d)
           + (a * 2^8 + b') + (c' * 2^8 + d)
       = C + 2^8 * (a - a + c' - c) + (b' - b + d - d)
       = C + 2^8 * (c' - c) + (b' - b)
       = C - (2^8 * c + b) + (2^8 * c' + b')

So an unaligned incremental checksum can be done in a single operation
by byteswapping the changed bytes before passing them to the helper.
This patch implements that trick for unaligned MSS option updates.

Signed-off-by: Kacper Kokot <kacper.kokot.44@gmail.com>
---
I decided to go with the get_unaligned_be16 suggestion because
it's idiomatic and it produces shorter assembly on x86-64
(6 instructions vs 9). SYN processing is a cold path so
I didn't look into it further.

v2:
 - Use get_unaligned_be16 (Fernando's suggestion)
 - Fix alignment check expression (David)
 - Mention it's a theoretical bug in the commit message
 - Drop cc stable, the bug is only theoretical

 net/netfilter/xt_TCPMSS.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/xt_TCPMSS.c b/net/netfilter/xt_TCPMSS.c
index 80e1634bc51f..32c87a520361 100644
--- a/net/netfilter/xt_TCPMSS.c
+++ b/net/netfilter/xt_TCPMSS.c
@ -117,8 +117,9 @@ tcpmss_mangle_packet(struct sk_buff *skb,
 	for (i = sizeof(struct tcphdr); i <= tcp_hdrlen - TCPOLEN_MSS; i += optlen(opt, i)) {
 		if (opt[i] == TCPOPT_MSS && opt[i+1] == TCPOLEN_MSS) {
 			u_int16_t oldmss;
+			u16 csum_oldmss, csum_newmss;
 
-			oldmss = (opt[i+2] << 8) | opt[i+3];
+			oldmss = get_unaligned_be16(&opt[i+2]);
 
 			/* Never increase MSS, even when setting it, as
 			 * doing so results in problems for hosts that rely
@@ -130,8 +131,19 @@ tcpmss_mangle_packet(struct sk_buff *skb,
 			opt[i+2] = (newmss & 0xff00) >> 8;
 			opt[i+3] = newmss & 0x00ff;
 
+			csum_oldmss = htons(oldmss);
+			csum_newmss = htons(newmss);
+
+			/* MSS may be unaligned; fix up the incremental checksum
+			 * to avoid an invalid checksum and a dropped packet.
+			 */
+			if (((char *)&opt[i + 2] - (char *)tcph) & 0x1) {
+				csum_oldmss = swab16(csum_oldmss);
+				csum_newmss = swab16(csum_newmss);
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

