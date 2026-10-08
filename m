Received: from mail-ot1-f52.google.com (mail-ot1-f52.google.com [209.85.210.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAB6D4E36D4
	for <netfilter-devel@vger.kernel.org>; Thu,  8 Oct 2026 15:28:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791473333; cv=none; b=cl+qWEYrUXkiNv94kgFnv6wHYUqov7FA5ZLj5EtwRWD4lNLFGP9HPkb42G/A9WIVqBjnPr1XoxjxpR9FEirDqm6rncLr0ZBKkw71IydOC5aiUthAhNsXJ1HBrzA6QmJt19li3f1rKylpbdJdxXl1dvrpmevIBEUrMX1OxfdmYAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791473333; c=relaxed/simple;
	bh=9IArv5E0HDoDgrm+EOLj8lDAwLd2ErbcWCrSvCceLBw=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=qzOEk1GurjNqAAI6EBtdiyu0njDrsq8QL/qxK4AY1ecoMRiVpZPxnEuNaMAM98GBiluuhcn8D19LC7skCchaqYW6ob3fR4qAkTI/aVZv08tjRESnidArzk9BpVYH8PieWBtGimNZ7jsgP31I3eozRIKDFwJi+S7F98cOOgJVnHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NfXIMqsN; arc=none smtp.client-ip=209.85.210.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NfXIMqsN"
Received: by mail-ot1-f52.google.com with SMTP id 46e09a7af769-82478760557so4506868a34.3
        for <netfilter-devel@vger.kernel.org>; Thu, 08 Oct 2026 08:28:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791473326; x=1792078126; darn=vger.kernel.org;
        h=mime-version:content-transfer-encoding:content-type:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oQ/GaoOi8qfcW0im1RCBWVWH2WffDR373jza/mtw0gw=;
        b=NfXIMqsNGbw+vfpL75dXTzLc7fqvSAbsJjc0ESuyn/LJ7Vne/+1t85oReQgCzVV7tK
         L4Ji2k4CgmqzXdu5jFxVkLWY9Ujb3HpCjAUhbLnvZ6NBm8egTetndOMzAyqyF0WFVlCI
         Jyx/zMCaI4ahhDdVIwotYc1kCXMdH7SGwuUvJVlanRz0+eRDBjpwF/uoV/P7DxCua1jS
         s9m/SvkWMrus27hfoe2rcX/gYPNYQ8AaLpcySURnayhUSnvG0ecq3ToaVdzVPN4ZoJn2
         +cjMa99sDICTA8NF4tpOSYJvY+NqpcTc+be2yLq97VwXvy3L9+7V123p9iof+C6ykb0Y
         LX+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791473326; x=1792078126;
        h=mime-version:content-transfer-encoding:content-type:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=oQ/GaoOi8qfcW0im1RCBWVWH2WffDR373jza/mtw0gw=;
        b=ucqWh7r/8spYxMqB/4XSWzXJnEzeaWwKuzaPNZi44lw1yefIsQODJkDDzwoSBB+qHM
         IXvYD7oncGa9KJuryxkWW0IyfGOvkAfGYhP2hUZrTR706QcvpMI9oPGAwW0/cdYwzX4s
         PttwvC9H2zmXQHrJJysR5Fd7P6VWxT+AmaylfK0vEh9JKlW2ishZRzzFweTz97lCnVan
         f8wke+2MEJpaVWWeedZ0eYKfKUEyzHr3vdk6ohTUuLdnOv4O/8EgOIVbSppAIqr5ivx+
         Dov/QyL2eHnoZGkuCjLQAF3UnqwDjp5I0RLkypt0B3MWZTqQTZIR17d/y+XvVNNmP+DT
         w/LQ==
X-Forwarded-Encrypted: i=1; AKwUvByCull1JYacD1iUcDeH1iS2GwX/rxQyl2HcED79xdgawal7/Gh9NaAeixLbK0CJq4qRNqrwmDhFQ6+OAsUzJMU=@vger.kernel.org
X-Gm-Message-State: AFuF++lrI9IvVERtkl0akAyWaE/oNIzMkgf29W55nbEbERdONVdcqzV2
	AfRjempr2aSsYJrEtCUPyqPAqjgXwpk6HHD8zbPYTh2If1VBC3mSHJaDHut8HUXlPRuLJk+29cQ
	=
X-Gm-Gg: AYBFou22fXTVtcibtykxm6uyFtwfiUt2rI/DaZ4fZboGh1wqFSgWC+Qk+N5iRt6syjF
	9nC7p+NllZmI2UX8+nzPwRUirvjeo6f47cLWhUNNAvvMgl/KtXfm+pJQ2lZ6wLLIObVPpPP+jpL
	y0SAnhmrkpJ965wM4cyXSLgV1weW+IGPeu+DPempVwz13ejKhlqLJ1wDodKzDFryQayEP+rKQlv
	Vd4gTKLgTQFFTchXaMX1Gnf422TTNDQyRRLyDl+qyu8NyqDODwQiA7qcbSN/GkXEAVqC8m2UiKG
	0OSRj7qcL//Xafwn4cUKuLdPPlK2irQOTVaT6QQ28UDHK+J/h+7OdLSwVln8KDFi14Na8Kp5Jeq
	FNZYNGd66/0tRHQ66XrParl5p+g9AD/GIl0QkjgKDU8SvM40rlx68ddVhdxIDK/na0uKfb3/tzG
	knASkDcIY9beopnMY02JgUJeEO8mBEEPHs4e5QkO2/++rApyCGzgpL8ijVUwF/ZMXBQfvLyt/qs
	v98c2DGW77WQIx5TuoO9/gzwa6KPGcdrJ96vzAHGqlhbSX8uJ1iAHY47aqLOVTHFWKHGKg9aPTq
	r1taT9o+yCMrwS4ijbQBNUVL/VZ9jBnagt0FZd5nukSicztrYfC0z2g5cCzXQg==
X-Received: by 2002:a05:6830:349e:b0:800:d883:9988 with SMTP id 46e09a7af769-82ac9d8f975mr7498436a34.0.1791473326271;
        Thu, 08 Oct 2026 08:28:46 -0700 (PDT)
Received: from 1.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.ip6.arpa ([2804:7f0:b100:655c:c517:c6a0:13b2:a6e1])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-82adcd0f5d7sm5853429a34.27.2026.10.08.08.28.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2026 08:28:45 -0700 (PDT)
From: Joas Antonio dos Santos <joasantonio108@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>
Cc: Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org, netdev@vger.kernel.org
Subject: [PATCH nf-next v2] netfilter: nf_conntrack_sip: only honour Via: port
 in original direction
Date: Thu, 08 Oct 2026 12:28:37 -0300
Message-ID: <179147331732.58100.8577886696698663796@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

The Cisco phone workaround in process_sip_request() records the port
from the topmost Via: header in ct_sip_info->forced_dport whenever the
Via address matches the sender of the current request and the port
differs from the sender's source port.  nf_nat_sip() then rewrites the
UDP destination port of every reply-direction packet to that value.

The workaround is meant for phones behind the NAT, i.e. requests in the
original direction, but the check is done in both directions.  For a
request arriving in the reply direction, ct->tuplehash[dir].tuple.src
is the remote peer itself, so the peer meets the condition with a Via:
line carrying its own address and any port >= 1024.  From then on its
datagrams on that flow are delivered to the NATed host on the port it
chose rather than the mapped one.  No spoofing is needed, but the peer
has to be the SIP server or proxy the client talks to, and the effect
is limited to that flow.

Only honour the Via: port for requests in the original direction.

Found by manual inspection of nf_conntrack_sip.c and nf_nat_sip.c,
assisted by an LLM, and confirmed at runtime with client, router and
server network namespaces (nft masquerade plus a "sip" ct helper on the
router): the server's request and a following UDP payload reached the
client on the Via: port before this change, and the mapped port after.

Fixes: 7266507d8999 ("netfilter: nf_ct_sip: support Cisco 7941/7945 IP phones")
Signed-off-by: Joas Antonio dos Santos <joasantonio108@gmail.com>
Assisted-by: Claude:claude-opus-5-5
---
Changes in v2:
- Retarget to nf-next as a correctness fix (Pablo).
- Describe the precondition (rogue SIP peer, no spoofing) and how the
  issue was found in the commit message.

 net/netfilter/nf_conntrack_sip.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index 64bc440b1..ef655a0bb 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -1586,8 +1586,14 @@ static int process_sip_request(struct sk_buff *skb, unsigned int protoff,
 	 * router for one of these phones, save the port number from the
 	 * Via: header so that nf_nat_sip can redirect the responses to
 	 * the correct port.
+	 *
+	 * Only honour the Via: port for requests coming from the phone,
+	 * i.e. in the original direction.  The remote peer must not be
+	 * able to pick the destination port of packets delivered to the
+	 * NATed host.
 	 */
-	if (ct_sip_parse_header_uri(ct, *dptr, NULL, *datalen,
+	if (dir == IP_CT_DIR_ORIGINAL &&
+	    ct_sip_parse_header_uri(ct, *dptr, NULL, *datalen,
 				    SIP_HDR_VIA_UDP, NULL, &matchoff,
 				    &matchlen, &addr, &port) > 0 &&
 	    port != ct->tuplehash[dir].tuple.src.u.udp.port &&
