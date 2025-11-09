Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEA552253EC
	for <netfilter-devel@vger.kernel.org>; Sun,  9 Nov 2025 19:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762716286; cv=none; b=njdEk/dKgOXnKvkOmdmKS627OOf3p+3/6U9U4HTE3zHGiufmOhS7UjTlE9LoVsAgWpzj/cXtAj/VUR8FC5WcLogIBPG9GnqwjPaQi0dY9+gfcYePYPU8/JvVoY1kgSCUMV3er4eZTuIiygDsdoUytxLyf9zpAsPniTnW/2sK77Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762716286; c=relaxed/simple;
	bh=fdY4s91tI+lPau1JubbQ0x8fEYiPT2Mrr0LtPH6xCk0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=my5OiWWfuSSSZDo7PJymX0v4gnkcNrt++FuYTTAV7NPJ1GgRhCrTkmPNg/tItp1ZRnlsN8e4PgzSVF+Bd+3nBgIurzHlchWqoWRK3bZwY6nmTIwFrg1j4MOV/bIxYc7G9PzvT7eyXpDYoMD80QOEOsLbFSYYk6LfR5OEKAAS6oQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EmB2l+B6; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EmB2l+B6"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-b710601e659so370525766b.1
        for <netfilter-devel@vger.kernel.org>; Sun, 09 Nov 2025 11:24:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762716282; x=1763321082; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/+3n/wt4G7GIqXmLm7jMx2L0Drt9lvIRoMC4cC/d+Ac=;
        b=EmB2l+B6gizAHsZ+0x5DOo1VURQjq4FqFDRQAQQvD73AygzFPREL0ckIcCBdw5w6Jk
         YoBu58htsURqGLty+mAizzNY/3IvusoU0DqmNwT6xIW8xpanKD/I3z1nT/kXpZdS+mRG
         viXqFUape+RjkomJ0hKFLN3Fa3M9w+Hvc/0m/ZaMIca/PEFd8DfvX8DHjWtV6KldKmuR
         Vjjoqbfsix+FdrD/PDCRkx0SPnPYK88ygww61RWCOScP5tje3yil0Lnwfi2eIaQgDzX5
         1sIcZZiFJLrdzjJ+OMq3d6WCKdh25hwHYjxUCCiEcxBhGBFM4SHJ0kCJJvY7h/5O6/iW
         fTng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762716282; x=1763321082;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/+3n/wt4G7GIqXmLm7jMx2L0Drt9lvIRoMC4cC/d+Ac=;
        b=b4aKBqKCwGwbfJD/mbsPp3mVAcvrGc8iszuW0kls96vlUWxl8v2Z9dwVTKjmmCIBpg
         H9Ah8vblIUOFHvEtk4Gl6cHeiv+0WRKQvgdMLT/vhia9ApxYHTIHVZCsPK3ToYLhi4LF
         Y/VQD22gyKSADNPj3FkQkhWWxyWgn3p/a1IjydT1cv1k+02haw0+NjDFNDPHTqirtLQ+
         EDNr0nVVUPmOtbOP85qBn98aEGQFZCgs0vezkBgeJx5zz3L8OLsmUBxSTxpf9GAjVk98
         8HHw2lqhBXfK/+T26I1VycJIRorWQNQQ0fuuRhGMQWNk6x2ayIRNJvZHwfwfTrJaYbWS
         orvQ==
X-Gm-Message-State: AOJu0YwJVPvmWCFU4KOxBxGLYS0/SnX987SiV9c3wmlJVzQiTXEgKBTF
	Kto2PN2jSqXdySQ/xY0+QQFhCHRkosZs2O7AHoyGftPq/gDBVZJ6tyZL
X-Gm-Gg: ASbGnctCx7rYJb4zWbzel+UyWMA66N0z6wweALRmpjikect4vV1VqbRohRy/OaEBX+4
	/qTIYqRdy7N7pCKj3OIPZCSfXOGgTdSRTPCs0Tnr3Ae0n3XLtM5qBxwSx03fdMyCciwclpdysQA
	c/4NX5f6wLDyJEEtDLQmTXFl+IzvSykw+S/oFavoegRlB0+usmcPskKt4HE6BLgrTnrZg9yFYWA
	hLly3TmukEmTDKFO6vWDaq1d+nh4bjNsSU3Q5ImOm+wruoqj5sHdwSxNGITjarGRCCXqjsyITwd
	Q7z6Y6MJAfYU+i+HiTDtUoOdg3hvj916jpo+turM44QzrMuzkpTH/+Br9L793ewY82uVMZCiMbZ
	nkOWf0vdsvFH3MeHTvq7ndpgEhmez4XlfBuiit3OYnC5v4/zPeWpOhiypTql3wRDjWJG6oELJr+
	gwbNJacxbAAa1cR0fFbJoNzfSZ7Wd7q/93MwNx2uTnZYf3hUI4rfBozIfBbTVxxNikK4ghKQ3RG
	4BsHT1vXi2kslA9VE5o
X-Google-Smtp-Source: AGHT+IGz2KRI1O39uoZsEqlvnLp53H/kYakBnxCti71eJRyaYaJ3y+qwmBNp1s7c1ixCSsXVxeHDAA==
X-Received: by 2002:a17:906:ef02:b0:b72:b97b:b6fc with SMTP id a640c23a62f3a-b72e03ef38emr633081066b.30.1762716282139;
        Sun, 09 Nov 2025 11:24:42 -0800 (PST)
Received: from eric (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b72bf97e447sm919652466b.42.2025.11.09.11.24.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Nov 2025 11:24:41 -0800 (PST)
From: Eric Woudstra <ericwouds@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>
Cc: netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org,
	bridge@lists.linux.dev,
	Eric Woudstra <ericwouds@gmail.com>
Subject: [PATCH v17 nf-next 1/4] netfilter: utils: nf_checksum(_partial) correct data!=networkheader
Date: Sun,  9 Nov 2025 20:24:24 +0100
Message-ID: <20251109192427.617142-2-ericwouds@gmail.com>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20251109192427.617142-1-ericwouds@gmail.com>
References: <20251109192427.617142-1-ericwouds@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In the conntrack hook it may not always be the case that:
skb_network_header(skb) == skb->data, i.e. skb_network_offset(skb)
is zero.

This is problematic when L4 function nf_conntrack_handle_packet()
is accessing L3 data. This function uses thoff and ip_hdr()
to finds it's data. But it also calculates the checksum.
nf_checksum() and nf_checksum_partial() both use lower skb-checksum
functions that are based on using skb->data.

Adjust for skb_network_offset(skb), so that the checksum is calculated
correctly.

Signed-off-by: Eric Woudstra <ericwouds@gmail.com>
---
 net/netfilter/utils.c | 28 ++++++++++++++++++++++------
 1 file changed, 22 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/utils.c b/net/netfilter/utils.c
index 008419db815a..7b33fe63c5fa 100644
--- a/net/netfilter/utils.c
+++ b/net/netfilter/utils.c
@@ -124,16 +124,25 @@ __sum16 nf_checksum(struct sk_buff *skb, unsigned int hook,
 		    unsigned int dataoff, u8 protocol,
 		    unsigned short family)
 {
+	unsigned int nhpull = skb_network_offset(skb);
 	__sum16 csum = 0;
 
+	if (WARN_ON(!skb_pointer_if_linear(skb, nhpull, 0)))
+		return 0;
+
+	/* pull/push because the lower csum functions assume that
+	 * skb_network_offset(skb) is zero.
+	 */
+	__skb_pull(skb, nhpull);
 	switch (family) {
 	case AF_INET:
-		csum = nf_ip_checksum(skb, hook, dataoff, protocol);
+		csum = nf_ip_checksum(skb, hook, dataoff - nhpull, protocol);
 		break;
 	case AF_INET6:
-		csum = nf_ip6_checksum(skb, hook, dataoff, protocol);
+		csum = nf_ip6_checksum(skb, hook, dataoff - nhpull, protocol);
 		break;
 	}
+	__skb_push(skb, nhpull);
 
 	return csum;
 }
@@ -143,18 +152,25 @@ __sum16 nf_checksum_partial(struct sk_buff *skb, unsigned int hook,
 			    unsigned int dataoff, unsigned int len,
 			    u8 protocol, unsigned short family)
 {
+	unsigned int nhpull = skb_network_offset(skb);
 	__sum16 csum = 0;
 
+	if (WARN_ON(!skb_pointer_if_linear(skb, nhpull, 0)))
+		return 0;
+
+	/* See nf_checksum() */
+	__skb_pull(skb, nhpull);
 	switch (family) {
 	case AF_INET:
-		csum = nf_ip_checksum_partial(skb, hook, dataoff, len,
-					      protocol);
+		csum = nf_ip_checksum_partial(skb, hook, dataoff - nhpull,
+					      len, protocol);
 		break;
 	case AF_INET6:
-		csum = nf_ip6_checksum_partial(skb, hook, dataoff, len,
-					       protocol);
+		csum = nf_ip6_checksum_partial(skb, hook, dataoff - nhpull,
+					       len, protocol);
 		break;
 	}
+	__skb_push(skb, nhpull);
 
 	return csum;
 }
-- 
2.50.0

