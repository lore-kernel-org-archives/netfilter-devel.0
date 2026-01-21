Received: from mail-05.mail-europe.com (mail-05.mail-europe.com [85.9.206.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB9E03BC4F4;
	Wed, 21 Jan 2026 18:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.9.206.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769021280; cv=none; b=OWSz+oX96R7jPqWxY08udjN7wqm8cS4p83Fqgq/cA0V2l+MXQ4Mg71PrNwswiVH6rMTUWRwI/QzOYBZXX8+QURbdALSPTfgxpbbiOfR0vYLei/Y9AWxaRlti/gJ0Uc1R62tA+pmZaptN5hmyGtMMrJQNAqbGJl1OkRLMPeu9QCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769021280; c=relaxed/simple;
	bh=2k+xa2OozsViZmJtLAVxnFv77Wx7BDEhcsb9Q5fpVBo=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=V6WS+ljELHeg2b1IBfrCXPcp1ZsXhl11pWjW+/MMQZr4ePLBSXPuVZ/+uVh6Xt5sD3gEIjQdi+u1CDJpbkv4WDUDOpWA3ffYjFPb5ayPPx0quMYzGXlNurXOtq/vPOUPraeA39kM4WcohqUwPUSmo0r4dT2ZwZiCc4LOhtsneoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com; spf=pass smtp.mailfrom=protonmail.com; dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b=vBilFy7H; arc=none smtp.client-ip=85.9.206.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=protonmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b="vBilFy7H"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1769021268; x=1769280468;
	bh=zgDBaq6W6wW7oGLEeEBePjUmm1IPAdlKRyQy5yeZuM4=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=vBilFy7HtAiBN8AUOVPx803IzoyR2H6WYFp+iBGBuoIf0GGH4ks9gQ0K/hNa/jG84
	 1+A99cfMsmXf0KHVoW1SdDrARJqWTdtFU9F5z9W9OisHBmWkoq13FqcFw3sV2hwvip
	 vsTp5ri6WJlViDPNrZ2ftt3oo2tRqurbr48OIj8Chnexv8n4ANI/SpHi36DWiLkGIo
	 S1QyPLx4ed1PtMD5zNJFWnmTD8xuOnNaT8/JK8WNdjuSCsXN+sO317jec6KTAy1TtO
	 /apfiE8JW/ZvqTLSt4b15bQY1CXTcT5qBQHAORJav2d9Ud3xZqd/NwwgDrHTmGNNpU
	 +RAH0OykYr9tA==
Date: Wed, 21 Jan 2026 18:47:45 +0000
To: Donald Hunter <donald.hunter@gmail.com>, Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
From: "Remy D. Farley" <one-d-wide@protonmail.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Jozsef Kadlecsik <kadlec@netfilter.org>, Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org, coreteam@netfilter.org, "Remy D. Farley" <one-d-wide@protonmail.com>
Subject: [PATCH v6 4/6] doc/netlink: nftables: Add sub-messages
Message-ID: <20260121184621.198537-5-one-d-wide@protonmail.com>
In-Reply-To: <20260121184621.198537-1-one-d-wide@protonmail.com>
References: <20260121184621.198537-1-one-d-wide@protonmail.com>
Feedback-ID: 59017272:user:proton
X-Pm-Message-ID: b9c9f00de5ac46d002c1ff027efce4cd29885886
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

New sub-messsages:
- log
- match
- numgen
- range

Signed-off-by: Remy D. Farley <one-d-wide@protonmail.com>
---
 Documentation/netlink/specs/nftables.yaml | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/Documentation/netlink/specs/nftables.yaml b/Documentation/netl=
ink/specs/nftables.yaml
index 826d3441b..4b1f5b107 100644
--- a/Documentation/netlink/specs/nftables.yaml
+++ b/Documentation/netlink/specs/nftables.yaml
@@ -1454,15 +1454,24 @@ sub-messages:
       -
         value: immediate
         attribute-set: expr-immediate-attrs
+      -
+        value: log
+        attribute-set: log-attrs
       -
         value: lookup
         attribute-set: expr-lookup-attrs
+      -
+        value: match
+        attribute-set: compat-match-attrs
       -
         value: meta
         attribute-set: expr-meta-attrs
       -
         value: nat
         attribute-set: expr-nat-attrs
+      -
+        value: numgen
+        attribute-set: numgen-attrs
       -
         value: objref
         attribute-set: expr-objref-attrs
@@ -1472,6 +1481,9 @@ sub-messages:
       -
         value: quota
         attribute-set: quota-attrs
+      -
+        value: range
+        attribute-set: range-attrs
       -
         value: reject
         attribute-set: expr-reject-attrs
@@ -1481,6 +1493,9 @@ sub-messages:
       -
         value: tproxy
         attribute-set: expr-tproxy-attrs
+        # There're more sub-messages to go:
+        #   grep -A10 nft_expr_type
+        # and look for .name\s*=3D\s*"..."
   -
     name: obj-data
     formats:
--=20
2.51.2


