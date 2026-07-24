Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0188438A72F
	for <netfilter-devel@vger.kernel.org>; Fri, 24 Jul 2026 11:02:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784890955; cv=none; b=XfM9iE9mjqR8t6CRDivSgf8agjVO94OvBiLW+lu96S4i+TkayZwxtojMeSIDDJkqYRBtQT/z4UXJNsCpya4bDx0DOJjiZ7G3aOOCz0G4FWQsGAqX8Sxxlkq2lqxdnG/r5FjdmeYnPvWC3ymEGqQUsaQkBk+/on5aAkr6OWDG2Wg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784890955; c=relaxed/simple;
	bh=Tq0Y16kKw1wqlj8L/40jByVxkat2izdzFeEQ1a6wfOo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=liX2plYRC2vQR9ikLMBSpvFSPBQ9cKIXrgjViMe9BBbpkUxLqvcolwS/agGWSYNp+xF7J8ikp/QfsAXc380bhSdY+/iNWshIsVlBrIqQ+0X+SXW3wbIwY+x1aJUciNBFM0gumBqV/11hckVAPRlZw+wPelCjnT0cSBy+YApP9FU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AUHdaOE2; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AUHdaOE2"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2cf50c6f235so3673515ad.0
        for <netfilter-devel@vger.kernel.org>; Fri, 24 Jul 2026 04:02:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784890953; x=1785495753; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=zPjAJ5kgYS06Njyj98RM4lDleOAg/lumtemgB0chsZU=;
        b=AUHdaOE2LMhrFM2qrYfTh2W0mbmKt2SAXwWUvWmbVbLIymcXkXsyz8E793vNoFkwlT
         +R0gTRlF9JdFKqYJ3Smwmzj/fOMSZqtGkLfXnBsZaxIm7vDxQO2aMcwszbNqoqBvTLak
         WGYuYJgpj+dRLfFuY31Gw4VJ+4tG5VWwPZsLNc69yXgBmjZy65OP4o+CgMV+tzNTWlKd
         s558YpDGuP/gsqWdP10ww2FrJEAWJ2iU6b9jq6x6+swSrrSMhhXRnoGLw0ERoeUKvH6I
         QpuGkxQku8eQxctHS21K0Xt0ONmuFEvjwxww9V3rjdRwFw7OOIjFjnWTSQtXNhPKzT0y
         zMww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784890953; x=1785495753;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zPjAJ5kgYS06Njyj98RM4lDleOAg/lumtemgB0chsZU=;
        b=dVC+NrZkC5SFE1sea+u2L/lncA68XRcJ635JawlHqefin/uYA+n9kwAAOOF8jGl4ct
         4Bbj1o660Y1yhtm3Vgof3VVpLXhzjRb6nQqjgfrvm26lk/1q92h21QspjoRzGLxpGuv2
         WiKHkmXpmDol2wZDFPUNSuu7bD16WsUhI+X+wnCCk8tZ3g2FHg1hWtC15HyLZ4eVG7ey
         dhFA+KCSIFKjYSwSCO/594djf5rJqrPnfFCgMuGJBw5Z00iN7q5T1/If7Wi1efIIIWvo
         S0eZSIOVG+XgkWfh0SDpcATwEFVvfW7Y1Rqvu1RMwV0hPa78xFqwlUG11JtoliAU9TZ6
         ky+Q==
X-Forwarded-Encrypted: i=1; AHgh+Ro4sohOFrQOvi2FKmAjpkwRkysbdeXnz9PNhxeVXL620xsiL99KJll7zPHD112Xup3acrCXG7vrjS7SA03cG5M=@vger.kernel.org
X-Gm-Message-State: AOJu0YxvO/574sgiDKhqm7WgQtzFAwsTmxehKFkuAyBozQRkQV185Egc
	qhXIOi5Ag78mDAuARhnrbacpKUvP1xH6e3ecMx2bwozZL4PZ37EOB8Yv
X-Gm-Gg: AR+sD13VzICFcMBUw+q0vCf5Ow6JN6yQH1yS6eiLKRascrKpXiu1VEPvgqEdf/JBOZx
	XtRQckhzFyw6BmYyC6sohT3Z4JeM1w67YXJTM94GkJeEau1UdUoCBLWFptMNtacfDfwSyyTj7/l
	d4ElaIzncn79/usY0H5vdLmwKL/wYlwAmNPfLQuPnaviT/n7x29eG6Uph7HlV17OkzcsUEGk92i
	+ska4Xp2W4hhYTCj5/mana5BYNS6I+FOe+C/5NWrRtJC5FI1St8Bz/NmR8TLAS/iql/zqLfbyGm
	IzXa6ePs8ozMjOXOaC9nKr/wGVPw5kAmmZOQLbxzcsCpDzrytvd4xxFXoH4iPIU65U2e0PwoenQ
	B/I8nXqYMDhwaCKIi4fIq5beq08MeWc7a3NTwhiBXB5Q2yS6yGePB5TiFldedsXyLtOe5wsxFwe
	MmAmmAum1H4XrK
X-Received: by 2002:a17:903:fa7:b0:2ca:e08e:9e70 with SMTP id d9443c01a7336-2cfa7530ed0mr76239605ad.46.1784890952300;
        Fri, 24 Jul 2026 04:02:32 -0700 (PDT)
Received: from c79ofce.localdomain ([103.165.85.242])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cf8edea703sm49727885ad.0.2026.07.24.04.02.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jul 2026 04:02:31 -0700 (PDT)
From: Zhixing Chen <running910@gmail.com>
To: Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Phil Sutter <phil@nwl.cc>
Cc: "David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	Zhixing Chen <running910@gmail.com>
Subject: [PATCH nf v3] netfilter: ip6tables: set hotdrop for malformed extension header matches
Date: Fri, 24 Jul 2026 19:01:11 +0800
Message-Id: <20260724110111.18783-1-running910@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The hbh, srh and ipv6header matches have paths that return false for
malformed IPv6 extension header packets without setting hotdrop.

For hbh, strict option parsing stops when the option type or length field
cannot be read, or when advancing to the next requested option would
exceed the available header data. Mark these packets for hotdrop instead
of treating them as a rule mismatch.

For srh, keep a missing SRH as a normal mismatch, but set hotdrop when
header lookup fails for other reasons, when the SRH fixed header is not
present, when the advertised SRH length exceeds the available skb data,
when segments_left exceeds first_segment, when the SID list implied by
first_segment exceeds the advertised SRH length, or when SID selector
reads fail.

For ipv6header, set hotdrop when the advertised extension header length
exceeds the available skb data.

Returning false treats the packet as a rule mismatch. Set hotdrop for
these malformed packets so they cannot bypass rules intended to drop
packets with these IPv6 extension headers.

Signed-off-by: Zhixing Chen <running910@gmail.com>
---

Changes in v3:
- Remove the unused len variable from ipv6header_mt6().
- Validate that the SID list implied by first_segment fits within the
  advertised SRH length in srh1_mt6().

Changes in v2:
- Use hotdrop labels for hbh and srh paths.
- Mark SRH packets with segments_left greater than first_segment for
  hotdrop.
- Drop the redundant ipv6header length check before skb_header_pointer().

v2: https://lore.kernel.org/netdev/20260714032124.7042-1-running910@gmail.com/T/
v1: https://lore.kernel.org/netdev/20260709063012.33160-1-running910@gmail.com/T/

---
 net/ipv6/netfilter/ip6t_hbh.c        | 27 +++++++++--------
 net/ipv6/netfilter/ip6t_ipv6header.c | 13 +++-----
 net/ipv6/netfilter/ip6t_srh.c        | 44 +++++++++++++++++++++-------
 3 files changed, 51 insertions(+), 33 deletions(-)

diff --git a/net/ipv6/netfilter/ip6t_hbh.c b/net/ipv6/netfilter/ip6t_hbh.c
index 6d1a5d2026a6..1b5dcc92b7da 100644
--- a/net/ipv6/netfilter/ip6t_hbh.c
+++ b/net/ipv6/netfilter/ip6t_hbh.c
@@ -62,21 +62,18 @@ hbh_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 			    NEXTHDR_HOP : NEXTHDR_DEST, NULL, NULL);
 	if (err < 0) {
 		if (err != -ENOENT)
-			par->hotdrop = true;
+			goto hotdrop;
 		return false;
 	}
 
 	oh = skb_header_pointer(skb, ptr, sizeof(_optsh), &_optsh);
-	if (oh == NULL) {
-		par->hotdrop = true;
-		return false;
-	}
+	if (!oh)
+		goto hotdrop;
 
 	hdrlen = ipv6_optlen(oh);
 	if (skb->len - ptr < hdrlen) {
 		/* Packet smaller than it's length field */
-		par->hotdrop = true;
-		return false;
+		goto hotdrop;
 	}
 
 	pr_debug("IPv6 OPTS LEN %u %u ", hdrlen, oh->hdrlen);
@@ -104,8 +101,8 @@ hbh_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 				break;
 			tp = skb_header_pointer(skb, ptr, sizeof(_opttype),
 						&_opttype);
-			if (tp == NULL)
-				break;
+			if (!tp)
+				goto hotdrop;
 
 			/* Type check */
 			if (*tp != (optinfo->opts[temp] & 0xFF00) >> 8) {
@@ -121,12 +118,12 @@ hbh_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 
 				/* length field exists ? */
 				if (hdrlen < 2)
-					break;
+					goto hotdrop;
 				lp = skb_header_pointer(skb, ptr + 1,
 							sizeof(_optlen),
 							&_optlen);
-				if (lp == NULL)
-					break;
+				if (!lp)
+					goto hotdrop;
 				spec_len = optinfo->opts[temp] & 0x00FF;
 
 				if (spec_len != 0x00FF && spec_len != *lp) {
@@ -147,7 +144,7 @@ hbh_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 			if ((ptr > skb->len - optlen || hdrlen < optlen) &&
 			    temp < optinfo->optsnr - 1) {
 				pr_debug("new pointer is too large!\n");
-				break;
+				goto hotdrop;
 			}
 			ptr += optlen;
 			hdrlen -= optlen;
@@ -159,6 +156,10 @@ hbh_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 	}
 
 	return false;
+
+hotdrop:
+	par->hotdrop = true;
+	return false;
 }
 
 static int hbh_mt6_check(const struct xt_mtchk_param *par)
diff --git a/net/ipv6/netfilter/ip6t_ipv6header.c b/net/ipv6/netfilter/ip6t_ipv6header.c
index c52ff929c93b..91a35e83b27f 100644
--- a/net/ipv6/netfilter/ip6t_ipv6header.c
+++ b/net/ipv6/netfilter/ip6t_ipv6header.c
@@ -28,7 +28,6 @@ ipv6header_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	const struct ip6t_ipv6header_info *info = par->matchinfo;
 	unsigned int temp;
-	int len;
 	u8 nexthdr;
 	unsigned int ptr;
 
@@ -38,8 +37,6 @@ ipv6header_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 	nexthdr = ipv6_hdr(skb)->nexthdr;
 	/* pointer to the 1st exthdr */
 	ptr = sizeof(struct ipv6hdr);
-	/* available length */
-	len = skb->len - ptr;
 	temp = 0;
 
 	while (nf_ip6_ext_hdr(nexthdr)) {
@@ -52,9 +49,6 @@ ipv6header_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 			temp |= MASK_NONE;
 			break;
 		}
-		/* Is there enough space for the next ext header? */
-		if (len < (int)sizeof(struct ipv6_opt_hdr))
-			return false;
 		/* ESP -> evaluate */
 		if (nexthdr == NEXTHDR_ESP) {
 			temp |= MASK_ESP;
@@ -97,10 +91,11 @@ ipv6header_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 		}
 
 		nexthdr = hp->nexthdr;
-		len -= hdrlen;
 		ptr += hdrlen;
-		if (ptr > skb->len)
-			break;
+		if (ptr > skb->len) {
+			par->hotdrop = true;
+			return false;
+		}
 	}
 
 	if (nexthdr != NEXTHDR_NONE && nexthdr != NEXTHDR_ESP)
diff --git a/net/ipv6/netfilter/ip6t_srh.c b/net/ipv6/netfilter/ip6t_srh.c
index db0fd64d8986..6fcc40102fe3 100644
--- a/net/ipv6/netfilter/ip6t_srh.c
+++ b/net/ipv6/netfilter/ip6t_srh.c
@@ -27,22 +27,27 @@ static bool srh_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 	struct ipv6_sr_hdr *srh;
 	struct ipv6_sr_hdr _srh;
 	int hdrlen, srhoff = 0;
+	int err;
 
-	if (ipv6_find_hdr(skb, &srhoff, IPPROTO_ROUTING, NULL, NULL) < 0)
+	err = ipv6_find_hdr(skb, &srhoff, IPPROTO_ROUTING, NULL, NULL);
+	if (err < 0) {
+		if (err != -ENOENT)
+			goto hotdrop;
 		return false;
+	}
 	srh = skb_header_pointer(skb, srhoff, sizeof(_srh), &_srh);
 	if (!srh)
-		return false;
+		goto hotdrop;
 
 	hdrlen = ipv6_optlen(srh);
 	if (skb->len - srhoff < hdrlen)
-		return false;
+		goto hotdrop;
 
 	if (srh->type != IPV6_SRCRT_TYPE_4)
 		return false;
 
 	if (srh->segments_left > srh->first_segment)
-		return false;
+		goto hotdrop;
 
 	/* Next Header matching */
 	if (srhinfo->mt_flags & IP6T_SRH_NEXTHDR)
@@ -111,6 +116,10 @@ static bool srh_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 				!(srh->tag == srhinfo->tag)))
 			return false;
 	return true;
+
+hotdrop:
+	par->hotdrop = true;
+	return false;
 }
 
 static bool srh1_mt6(const struct sk_buff *skb, struct xt_action_param *par)
@@ -121,22 +130,31 @@ static bool srh1_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 	struct in6_addr _psid, _nsid, _lsid;
 	struct ipv6_sr_hdr *srh;
 	struct ipv6_sr_hdr _srh;
+	int err;
 
-	if (ipv6_find_hdr(skb, &srhoff, IPPROTO_ROUTING, NULL, NULL) < 0)
+	err = ipv6_find_hdr(skb, &srhoff, IPPROTO_ROUTING, NULL, NULL);
+	if (err < 0) {
+		if (err != -ENOENT)
+			goto hotdrop;
 		return false;
+	}
 	srh = skb_header_pointer(skb, srhoff, sizeof(_srh), &_srh);
 	if (!srh)
-		return false;
+		goto hotdrop;
 
 	hdrlen = ipv6_optlen(srh);
 	if (skb->len - srhoff < hdrlen)
-		return false;
+		goto hotdrop;
 
 	if (srh->type != IPV6_SRCRT_TYPE_4)
 		return false;
 
+	if (sizeof(*srh) +
+	    ((srh->first_segment + 1) * sizeof(struct in6_addr)) > hdrlen)
+		goto hotdrop;
+
 	if (srh->segments_left > srh->first_segment)
-		return false;
+		goto hotdrop;
 
 	/* Next Header matching */
 	if (srhinfo->mt_flags & IP6T_SRH_NEXTHDR)
@@ -207,7 +225,7 @@ static bool srh1_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 			  ((srh->segments_left + 1) * sizeof(struct in6_addr));
 		psid = skb_header_pointer(skb, psidoff, sizeof(_psid), &_psid);
 		if (!psid)
-			return false;
+			goto hotdrop;
 		if (NF_SRH_INVF(srhinfo, IP6T_SRH_INV_PSID,
 				ipv6_masked_addr_cmp(psid, &srhinfo->psid_msk,
 						     &srhinfo->psid_addr)))
@@ -222,7 +240,7 @@ static bool srh1_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 			  ((srh->segments_left - 1) * sizeof(struct in6_addr));
 		nsid = skb_header_pointer(skb, nsidoff, sizeof(_nsid), &_nsid);
 		if (!nsid)
-			return false;
+			goto hotdrop;
 		if (NF_SRH_INVF(srhinfo, IP6T_SRH_INV_NSID,
 				ipv6_masked_addr_cmp(nsid, &srhinfo->nsid_msk,
 						     &srhinfo->nsid_addr)))
@@ -234,13 +252,17 @@ static bool srh1_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 		lsidoff = srhoff + sizeof(struct ipv6_sr_hdr);
 		lsid = skb_header_pointer(skb, lsidoff, sizeof(_lsid), &_lsid);
 		if (!lsid)
-			return false;
+			goto hotdrop;
 		if (NF_SRH_INVF(srhinfo, IP6T_SRH_INV_LSID,
 				ipv6_masked_addr_cmp(lsid, &srhinfo->lsid_msk,
 						     &srhinfo->lsid_addr)))
 			return false;
 	}
 	return true;
+
+hotdrop:
+	par->hotdrop = true;
+	return false;
 }
 
 static int srh_mt6_check(const struct xt_mtchk_param *par)

base-commit: 56d96fededd61192cd7cc8d2b0f36adfd59036c3
-- 
2.34.1

