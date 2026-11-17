Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794922861;
	b=aa14GAN8ymmuNYQj/gfXplf6CNS58vJRdWKyg0lhTjIaSuUSy+VZmWD0wyZ60BXmJE+u
	 7NAOofbMgX/T+g0+gSMSy7xtGzt6I7B9iW5hNNttQ4SPvSKGkLYpOGqgv8da6+Kb/qqN8
	 iZu7AFXg6Qe+abQNasqY502OgtTQSo+ZHjXC0IqFL0msF9indKDduqv/LGuWhnqLzdIJv
	 eJfNk+h5YNdyDT1dWVr8hmIOXLxL1LyWkaqJz/apid9MChOcVMfP470JQX+OmVbwLh4Ga
	 MlUi4MSkzTeCaF0b3XTxlJFAShkJywTWLg0Z35omKg7uLL8vdZ/wWZYRWk6haTSIgNQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794922861;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xbM/8NkFsyBNUIt/zB1tHx2aYKgPjS1RSmbEYKw0CLs=;
	b=PYbyVUStfKtuNm0trYF9zSkmlHRu3xqfWvzzu04CspJpfRHHB3liAN9kwmUE4FhIl1ly
	 xnwBxSgK1KgxHWAJkd7zAwjeULDdaHA/uZ7/Gehk3alz4AqZvdJgmn08YwN1UrZ4bzaxg
	 GlO/zP3zzSqaQKoPe5+x/XmcwVGXxg9I0L34NxWKXvkIlcBl6fBf34bv9SaVqD6eW+MIA
	 Euj6Lvy738hdkinii8NO+e1grm1D5VuY3Ns17a4/eSfL/Upw2bRLt2b6xrW5EwXsXr56u
	 0xJEU31Y4hfWm29ulctm7TFJxgtYc627kMWkJSu+Ja03KsI0y9QPOlUp4U7tpAEvmOQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=1password.com;
	spf=pass smtp.mailfrom=agilebits.com;
	dkim=pass header.d=1password.com header.i=@1password.com header.a=rsa-sha256 header.s=google header.b=foXaldXx;
	arc=none smtp.remote-ip=209.85.160.172
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C7B8606A339
	for <netfilter-devel@vger.kernel.org>; Tue, 17 Nov 2026 13:41:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4C7B8606A339
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=1password.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=agilebits.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=1password.com header.i=@1password.com header.a=rsa-sha256 header.s=google header.b=foXaldXx
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-5364d86f7f0so29457811cf.1
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Nov 2026 05:41:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1password.com; s=google; t=1794922860; x=1795527660; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xbM/8NkFsyBNUIt/zB1tHx2aYKgPjS1RSmbEYKw0CLs=;
        b=foXaldXxEEH54V2YER/HHxt3jQlsWT7az36Ckd/VVrISFU+poHoFoVbuu7oDwkMqzU
         qb2Irozt25K9uH+74SzjT1PdSdXH54erl8ewjyR8naD8oGSgnVqYFLAsTrAhqK+ZjDqk
         stYd45245HPCPLkxFvpF7zkqwuKxfJCeAjwcM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794922860; x=1795527660;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=xbM/8NkFsyBNUIt/zB1tHx2aYKgPjS1RSmbEYKw0CLs=;
        b=ViUjA3jqV5dnTRWqbthiaKBFIdit4uNigu4aAt+kHwpkAU7XQ1/el6LMNuy84sj7s6
         e7KwcFGDL/mqt6CiEITblRQFYGnXvLxNFulU2cqWYPmc0tmQ6jw2pqw5d5hmTVESmJgs
         kPBg+CtNB9HdRRZoi8518sfcVfdwdTgDcBqmiAiK/oQB5FcRvCuwXVWs+IyN06Ia26Vt
         cNJBft/rptBk0qXJ/ZMq5huqMnFxiySYVCUfswkMBw9euElll8y6YtMYZ8H+yunOvkMa
         fdefLERTR1uA6vEdCl7MB9aSaaBw+faQoxYntonBWI0Pm6Ivs865620rkWN0doZkslwP
         Fh+Q==
X-Forwarded-Encrypted: i=1; AL+hErHesxkllud1Kool9o/uHBkyJg3PB4WzcK+zGnjLYUyOLYrFKzNIs7tYE+7Bfee4arw/A5oQ8kxlPKWivrzyRkg=@vger.kernel.org
X-Gm-Message-State: APuU4Z+m20zB646fa8/aSFX45rOv7OQsHMei7el2qHMFUjgwWjgad0iY
	fva5HaChvqxxBKv3aaJekpZmhT5PwuKKPFF0y3/39AltB2VByTe+/J1XG3WO4l4ZX5I=
X-Gm-Gg: AYBFou1UvDpLpa6HqWk5WfZQ6unSy59Z8LzDYTASPDvAJSwgGCNM3dUkPAuvzY0Zp0k
	jR1y8uZ8cC04+SYR/7Dpul4CWIt2VW6d0CK+rTz2dj8rcwtmchbCbeOOa2K11I+SvN14maxOwnP
	oJL2X2ZefrdexhH8FdrTahEjfm2PH62402+53zLIthbqvAR5OLHacCH/GMQdIK/CcnNLP9BfPT1
	Qeodloe1xfimSaxDJ+nEWszFtDoRwKCTUcnSdkoWjF/94yvM8rZcbRxb5+oNHHd4M65aH9C6kiG
	5OA9kYfp8Pf/GIao+veL2eHnP2Fi3ZYEoZygYMA+cf8VXy5GRCgPLW2gqfAWyxWTyrTzp1XAe7z
	q9vNa/lCv8XJycyhpvy8fl97OCGoXdAooSn1lHhYzpnJ+ERuIIhVtf6PMCS4yesrT+eehFxlmYa
	bVw1kXO5z7HN9+RkaY0KE1y5Kz6HqTUYqGWdnWJbrjKeO3OwmN3606dIw5AUWsd8OPdGgWwb+Oh
	4Y/Tj8oz4GSo6kt5cbHOwub7RuRhwqHi4Xg+PNDWAkrUNppGljrHj1MZglOedxCIxHXBeeg9nqE
	k391qYa3ep/wWMkcBeuWPdgeXvvnGBKH3nqRcUVFMIU1ktk=
X-Received: by 2002:ac8:5d04:0:b0:55c:8b2d:bb41 with SMTP id d75a77b69052e-55d4a6ce73amr38497231cf.57.1794922860216;
        Tue, 17 Nov 2026 05:41:00 -0800 (PST)
Received: from localhost ([96.239.0.47])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-55ad0534196sm104516571cf.9.2026.11.17.05.40.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 05:40:59 -0800 (PST)
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
	Axel Mierczuk <axel.mierczuk@1password.com>,
	stable@vger.kernel.org
Subject: [PATCH nf v2 1/2] ipvs: avoid out-of-bounds write in ip_vs_nat_icmp_v6
Date: Tue, 17 Nov 2026 08:40:48 -0500
Message-ID: <20261117134049.52386-2-axel.mierczuk@1password.com>
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

When an ICMPv6 error embeds a non-first fragment, ipv6_find_hdr()
returns at the Fragment header without updating *offset, so
ip_vs_fill_iph_skb_icmp() leaves ciph.len equal to ciph.off, the
start of the embedded IPv6 header.

ip_vs_out_icmp_v6() and ip_vs_in_icmp_v6() pass embedded non-first
TCP, UDP and SCTP fragments through before any lookup. AH and ESP set
pp->dont_defrag, so their fragments continue. Their lookups read only
the addresses and never use ciph.len, but handle_response_icmp() and
ip_vs_icmp_xmit_v6() size skb_ensure_writable() from ciph.len, which
then covers nothing of the embedded header. ip_vs_nat_icmp_v6()
rewrites the embedded destination or source address, 16 bytes
located 8 or 24 bytes past the end of the validated area.

Include the embedded IPv6 header in ciph.len at both call sites when
ipv6_find_hdr() stopped at a non-first fragment. Only the size of the
writable check changes; the AH and ESP lookups do not use ciph.len.

This fix does not depend on patch 2. Stable kernels without commit
342e24a339b9 ("ipvs: do not mangle ICMP replies for non-first fragments")
also need that commit to handle incoming ICMPv6 errors quoting
non-first ESP fragments.

Fixes: 63dca2c0b0e7 ("ipvs: Fix faulty IPv6 extension header handling in IPVS")
Cc: stable@vger.kernel.org
Suggested-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Axel Mierczuk <axel.mierczuk@1password.com>
---
 net/netfilter/ipvs/ip_vs_core.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
index fd503f0efb57..d5da16ff9673 100644
--- a/net/netfilter/ipvs/ip_vs_core.c
+++ b/net/netfilter/ipvs/ip_vs_core.c
@@ -1206,6 +1206,16 @@ static int ip_vs_out_icmp_v6(struct netns_ipvs *ipvs, struct sk_buff *skb,
 				     true, &ciph))
 		return NF_ACCEPT; /* The packet looks wrong, ignore */
 
+	/* ipv6_find_hdr() stops at the Fragment header of a non-first
+	 * fragment and leaves ciph.len == ciph.off. Only AH and ESP
+	 * (pp->dont_defrag) pass the fragoffs check below and their
+	 * lookup reads only the addresses, but handle_response_icmp()
+	 * sizes skb_ensure_writable() from ciph.len before
+	 * ip_vs_nat_icmp_v6() rewrites the embedded header. Include it.
+	 */
+	if (ciph.len == ciph.off)
+		ciph.len += sizeof(struct ipv6hdr);
+
 	pp = ip_vs_proto_get(ciph.protocol);
 	if (!pp)
 		return NF_ACCEPT;
@@ -2036,6 +2046,16 @@ static int ip_vs_in_icmp_v6(struct netns_ipvs *ipvs, struct sk_buff *skb,
 	if (!ip_vs_fill_iph_skb_icmp(AF_INET6, skb, offset, true, &ciph))
 		return NF_ACCEPT;
 
+	/* ipv6_find_hdr() stops at the Fragment header of a non-first
+	 * fragment and leaves ciph.len == ciph.off. Only AH and ESP
+	 * (pp->dont_defrag) pass the fragoffs check below and their
+	 * lookup reads only the addresses, but ip_vs_icmp_xmit_v6()
+	 * sizes skb_ensure_writable() from ciph.len before
+	 * ip_vs_nat_icmp_v6() rewrites the embedded header. Include it.
+	 */
+	if (ciph.len == ciph.off)
+		ciph.len += sizeof(struct ipv6hdr);
+
 	pd = ip_vs_proto_data_get(ipvs, ciph.protocol);
 	if (!pd)
 		return NF_ACCEPT;
-- 
2.50.1 (Apple Git-155)

