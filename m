Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.219.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794922863;
	b=GYAkF3dfoUw06QNfjvW/R8wBQDOJiRT8FFFY3bM93SYTHyB74ClLl47Gve6w27etD4cz
	 BHowenbcfoF5MYns320OtQvlVkR7oKbzRRTgAJLRp6mRn/JyH2nIAs33V2RdtDyrNUgoG
	 e3rW+k2W1zkydOw+b/ahY8SfJeCVHa2mZ8lVpgSnb8WP08NvVZiUa2eooj1whoGR+u997
	 jqS89rGXSECKdxRY/dsOB78Bb2zXXcKMfFsj7fFR1PmS2USi0Uw+VFuBGH8PY95f1/okM
	 hKCIaHpCJqfWMEFChj+hHOIeSqaUjX4Ye1mBgALWZOsiCZudPn7g5W7whuByf0KiZHg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794922863;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ggUMg57NI4rSntSxrT/atwUvnqGEIweOKKELEMre8CQ=;
	b=UDPV8zDpCkKBs+CqTb9QawnpvTdasXuapA6hy2UdRlg+ff57uaT7f2Qx7qH77JVBF6rC
	 /tqHUkT6hOL4880eXGjSISCG73BOekMdP1YU9+YM5zZvPMXDAtEpBE9uajD3lvcN5ttTw
	 JUInUCZ1JtHx9GY+oppfdt9hCu1fH0fF1DqibwZSu8NXzO6rMrzf7pffnaWO8/wtx+031
	 2Ps8eeNFmi0zSU3t5QV1pWfkl/SHBnukr46SdluysHm+exFFAd2ZPFP4wGrQqKk/IBp91
	 mKlT+vlzy6uWa/LUgI9FjezBQkJOogtzWLZWBe6ynYJAxoX9KDm6Jc3gQRtXMeKEzsw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=1password.com;
	spf=pass smtp.mailfrom=agilebits.com;
	dkim=pass header.d=1password.com header.i=@1password.com header.a=rsa-sha256 header.s=google header.b="X1186pl/";
	arc=none smtp.remote-ip=209.85.219.46
Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68E62606A33D
	for <netfilter-devel@vger.kernel.org>; Tue, 17 Nov 2026 13:41:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 68E62606A33D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=1password.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=agilebits.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=1password.com header.i=@1password.com header.a=rsa-sha256 header.s=google header.b=X1186pl/
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-91ccfb88e4dso70237206d6.0
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Nov 2026 05:41:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1password.com; s=google; t=1794922862; x=1795527662; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ggUMg57NI4rSntSxrT/atwUvnqGEIweOKKELEMre8CQ=;
        b=X1186pl/CKh0y0NtPcZQoWQJ/T1JZMTX2b8iz9xh1P0m/yqwrj6D1FqFpXGtGxwmDv
         OWVXdgTVS/i+yJtXU9W9o99iJlQu4GszSb+2rXXy/NUUvjmq5OD7xGhuTv38T2EM6ECb
         JlU186pBgSIrJWqOXC0ia98Z/zuThl2xHSnps=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794922862; x=1795527662;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ggUMg57NI4rSntSxrT/atwUvnqGEIweOKKELEMre8CQ=;
        b=U92EXpMVAJDKaL04P91qwSuPYb0CPR9evJ1l6NFv56toNnStV+ZnqVpydkg8nMW2iv
         KDpg8wf/l+kuubEN7ERmY2dF3fRw8RwUc8Z8Qp4jIv/AiWKcqJrWuGpY/sFPCWR1PElY
         /piHr3fAW/Xay/9/ksfCx8fdadjkJMUfYrzE9ZgKk37Yo4W0D0YhvR5OGJgQ8RxgL1ki
         qeOYXj3J7xppBIthjyUQxbbrfUOy7kO5eU/kBZc3NUInjtv5jFoobaIyvhYhtKZKVRI+
         vDI4ApI6JHJ/N8vsvtGXqusLzuAxo/GWj1zEJUiozP4rtJs2QIZYtSE/Cwkej4KqbhRY
         cvDA==
X-Forwarded-Encrypted: i=1; AL+hErG6yOL/njq7AhGT7lgHo6nEqxuHU/f3lg8aKdYb0GlcOeDgepfIop+ALlYiQkon87Js/xWLjInSS9ibO4Vr6x0=@vger.kernel.org
X-Gm-Message-State: APuU4Z8zhKuAQoQ/G36pxa2dzRuawi1DwLzXSVDCjAHu5F2vI3bZtpAK
	593uq0N3rQtiidPvkesH2SK3HHO5tiPdGFtmbWPeW9rK7FuPv914mp+J3l0r0xJ4PtQ=
X-Gm-Gg: AZFdTZd/FbwbB+9PJtVFQBqa8QzkV/OBmKdj693RrGJuF7Tpwk8updfiK14s8iq+MeJ
	3ypJTmZfosvkD6sStoU+RHkfosv9SsQnAcx5IBIY65vtCa/cv1TZvsvcPInv3deL+7deRbaQw7W
	nPQx272zXPsidCCm0SadEg+7np/ht+w+Xf0Ak09zix2OTxjRsnypkAVJ1bFfrhnJoEEk6hR0T+m
	PaOIXf9IlARxAdR+PTPRXnufFT554vQ/fyBQbXbTVM1kBxRrJCVAABTPuDT5N0ZtUxeA5g4u5pQ
	GzEDZr2SXY6W71AWFACSN1gH3wWe9BsUm21b6nly5kUzKIX8HQvDV8+SA4kvHv1VcP9JyueU4kY
	piNyrupcVZt0J1iNWWjDZBWsGwePs9MnCqJ8CoNowiYyacpLxQoXSrnXZgJgmypurL5RQXZIyXL
	0PUPemgVepsjNafWPwTOudO8i/COdkY7tVmee37zleTQrQXcNEOx18Z6igjS+hwAy6PY9jhEeQb
	wJFCR7MlSyk2NvGEGCoDE7tMJpOzUo+7ptbJHAD0XDbC7CgEDOYVkuXok2XRkernNu9Yog5Bi5i
	X1RQbPAs+H192lHIGKELvRmafghwseaGexDIWEKIzDhLvaPbcRoJClZvGY3g
X-Received: by 2002:a05:6214:318e:b0:91f:1e1b:7b3a with SMTP id 6a1803df08f44-91f2425dae2mr206400816d6.57.1794922862205;
        Tue, 17 Nov 2026 05:41:02 -0800 (PST)
Received: from localhost ([2600:4041:59c3:300:b8f8:e592:18c8:ba23])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91f23d5f3e4sm112644946d6.16.2026.11.17.05.41.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 05:41:01 -0800 (PST)
From: Axel Mierczuk <axel.mierczuk@1password.com>
To: ja@ssi.bg,
	horms@verge.net.au,
	pablo@netfilter.org
Cc: fw@strlen.de,
	phil@nwl.cc,
	dsahern@kernel.org,
	kuba@kernel.org,
	edumazet@kernel.org,
	pabeni@redhat.com,
	davem@davemloft.net,
	netfilter-devel@vger.kernel.org,
	lvs-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	w@1wt.eu,
	Axel Mierczuk <axel.mierczuk@1password.com>
Subject: [PATCH nf v2 2/2] ipv6: update *offset for non-first fragments in ipv6_find_hdr()
Date: Tue, 17 Nov 2026 08:40:49 -0500
Message-ID: <20261117134049.52386-3-axel.mierczuk@1password.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20261117134049.52386-1-axel.mierczuk@1password.com>
References: <20261117134049.52386-1-axel.mierczuk@1password.com>
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

The non-first fragment early return is the only successful exit of
ipv6_find_hdr() that leaves *offset untouched, so a target < 0 caller
gets back the offset it started with, the network header, instead of
a position past the headers it asked to skip.

IPVS relies on the offset being advanced. ip_vs_fill_iph_skb_off()
stores it in iph->len, and handle_response() sizes
skb_ensure_writable() from it before rewriting the IPv6 source
address, so for a non-first ESP fragment matched through
ah_esp_conn_out_get() the copy-on-write check covered none of the
header. The ICMPv6 paths had the same problem with the embedded
header. The previous patch works around it there so that it can be
backported on its own.

For non-first fragments with target < 0, set *offset immediately
after the Fragment header, at the start of the fragment payload, and
return -EBADMSG when the Fragment header is truncated, as the other
exits already do for the header they skip. Callers must still account
for the nonzero fragment offset. A NEXTHDR_FRAGMENT search continues
to return the Fragment header's offset.

nf_tables stores the offset in pkt->thoff whatever the fragment
offset is, so nf_trace_fill_pkt_info() now dumps the network headers
up to the fragment payload for non-first fragments instead of an
empty network header and the IPv6 header as transport header.
SYNPROXY uses the offset without checking the fragment offset as
well and now reads the fragment payload instead of the IPv6 header;
the -EBADMSG check keeps the offset within the packet. The other
target < 0 users check the fragment offset first or only use the
returned protocol.

Drop the ciph.len workaround from the previous patch: every
successful return now writes *offset, so ciph.len can no longer equal
ciph.off.

Fixes: b777e0ce7437 ("[NETFILTER]: make ipv6_find_hdr() find transport protocol header")
Suggested-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Axel Mierczuk <axel.mierczuk@1password.com>
---
 net/ipv6/exthdrs_core.c         |  9 ++++++++-
 net/netfilter/ipvs/ip_vs_core.c | 20 --------------------
 2 files changed, 8 insertions(+), 21 deletions(-)

diff --git a/net/ipv6/exthdrs_core.c b/net/ipv6/exthdrs_core.c
index 4a9748338cf4..3112408ed2f3 100644
--- a/net/ipv6/exthdrs_core.c
+++ b/net/ipv6/exthdrs_core.c
@@ -179,7 +179,10 @@ EXPORT_SYMBOL_GPL(ipv6_find_tlv);
  *
  * Note that non-1st fragment is special case that "the protocol number
  * of last header" is "next header" field in Fragment header. In this case,
- * *offset is meaningless and fragment offset is stored in *fragoff if fragoff
+ * for target < 0, *offset points immediately after the Fragment header,
+ * at the start of the fragment payload. Callers must still account for
+ * the nonzero fragment offset before interpreting the payload. The
+ * fragment offset is stored in *fragoff if fragoff
  * isn't NULL.
  *
  * if flags is not NULL and it's a fragment, then the frag flag
@@ -259,8 +262,12 @@ int ipv6_find_hdr(const struct sk_buff *skb, unsigned int *offset,
 				if (target < 0 &&
 				    ((!ipv6_ext_hdr(hp->nexthdr)) ||
 				     hp->nexthdr == NEXTHDR_NONE)) {
+					if (skb->len - start <
+					    sizeof(struct frag_hdr))
+						return -EBADMSG;
 					if (fragoff)
 						*fragoff = _frag_off;
+					*offset = start + sizeof(struct frag_hdr);
 					return hp->nexthdr;
 				}
 				if (!found)
diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
index d5da16ff9673..fd503f0efb57 100644
--- a/net/netfilter/ipvs/ip_vs_core.c
+++ b/net/netfilter/ipvs/ip_vs_core.c
@@ -1206,16 +1206,6 @@ static int ip_vs_out_icmp_v6(struct netns_ipvs *ipvs, struct sk_buff *skb,
 				     true, &ciph))
 		return NF_ACCEPT; /* The packet looks wrong, ignore */
 
-	/* ipv6_find_hdr() stops at the Fragment header of a non-first
-	 * fragment and leaves ciph.len == ciph.off. Only AH and ESP
-	 * (pp->dont_defrag) pass the fragoffs check below and their
-	 * lookup reads only the addresses, but handle_response_icmp()
-	 * sizes skb_ensure_writable() from ciph.len before
-	 * ip_vs_nat_icmp_v6() rewrites the embedded header. Include it.
-	 */
-	if (ciph.len == ciph.off)
-		ciph.len += sizeof(struct ipv6hdr);
-
 	pp = ip_vs_proto_get(ciph.protocol);
 	if (!pp)
 		return NF_ACCEPT;
@@ -2046,16 +2036,6 @@ static int ip_vs_in_icmp_v6(struct netns_ipvs *ipvs, struct sk_buff *skb,
 	if (!ip_vs_fill_iph_skb_icmp(AF_INET6, skb, offset, true, &ciph))
 		return NF_ACCEPT;
 
-	/* ipv6_find_hdr() stops at the Fragment header of a non-first
-	 * fragment and leaves ciph.len == ciph.off. Only AH and ESP
-	 * (pp->dont_defrag) pass the fragoffs check below and their
-	 * lookup reads only the addresses, but ip_vs_icmp_xmit_v6()
-	 * sizes skb_ensure_writable() from ciph.len before
-	 * ip_vs_nat_icmp_v6() rewrites the embedded header. Include it.
-	 */
-	if (ciph.len == ciph.off)
-		ciph.len += sizeof(struct ipv6hdr);
-
 	pd = ip_vs_proto_data_get(ipvs, ciph.protocol);
 	if (!pd)
 		return NF_ACCEPT;
-- 
2.50.1 (Apple Git-155)

