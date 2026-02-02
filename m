Received: from mail-24426.protonmail.ch (mail-24426.protonmail.ch [109.224.244.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFA552D7DC1
	for <netfilter-devel@vger.kernel.org>; Mon,  2 Feb 2026 09:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=109.224.244.26
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770025264; cv=none; b=g0uiMCuwHkomzHDz83ZEVG0ZNEpSJzmosY5MplMdVoK47x0uVKDRKoyeV3cM9fO/6yDA0SKgF4/K27N/RZkH5jg1L9R2kTtm9xhpxpLQCcQszZRI4NtaG6uqaIjCorA2jsXat3oWeD3c4h5oGki6CS0utViYQXrLEnwOL7T1CWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770025264; c=relaxed/simple;
	bh=n8FGee2L5bkPookg0YdJjFRKNtl4T+XNB6/eNYSidVM=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FMVQqVt3wEo2uHJCn7vrYHueUYQmr06lMlUOxGb+ZufNpttFOQ5Yzo698/jSAg2Mg4SIAZoYlw15Y3FXN/P3w+yr/3ebrNNK21z2v7ANkG1LZlxbOxq/tBg2skHL5zeb7N5+14qU5yTEactyJJirOXIVO4gjc8JgQmiZFYe0B8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com; spf=pass smtp.mailfrom=protonmail.com; dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b=nr6M6mM9; arc=none smtp.client-ip=109.224.244.26
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=protonmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b="nr6M6mM9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1770025255; x=1770284455;
	bh=Blr5GdP413xj9Y60FcLkP86aKJZ2VM3UVfsMfTMR3Dg=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=nr6M6mM9rH5zK0H27iqvYMk0IWghsFLzPBmvM/ea2Em+H909SlmNM1XNZJK5KK3t4
	 LgatK/mfwK0RvZvtAUSqK3n1Uofu3VlU3f63vz8JmZiOYJZDHgCsleQSwgxSxY/fxp
	 NGqHtUto4GorTdleUGJGcULoqVT+JOH6DDOX79KG/hZ0V4tB9Y3i+sBZ6P38T0rhgf
	 cpJRn+T4ppNFCgo7cB96g+3M0Mk2SbnPNfl4wx6VbNgNqDeY5v6WWM1DSMVlC2Mhgp
	 UzVwuGWowvBYFbTtdCLFKdluaL4TG4d0Oz5JSenIwnCC/aZQlE6cvAi/VkXQy2G0z2
	 VdurCaHdb70cQ==
Date: Mon, 02 Feb 2026 09:40:52 +0000
To: Donald Hunter <donald.hunter@gmail.com>, Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
From: "Remy D. Farley" <one-d-wide@protonmail.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org, coreteam@netfilter.org, "Remy D. Farley" <one-d-wide@protonmail.com>
Subject: [PATCH net-next v7 1/5] doc/netlink: netlink-raw: Add max check
Message-ID: <20260202093928.742879-2-one-d-wide@protonmail.com>
In-Reply-To: <20260202093928.742879-1-one-d-wide@protonmail.com>
References: <20260202093928.742879-1-one-d-wide@protonmail.com>
Feedback-ID: 59017272:user:proton
X-Pm-Message-ID: d9b4c9df7ae928fa84feb8348c8f54d961c45dd9
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Add definitions for max check and len-or-limit type, the same as in other
specifications.

Suggested-by: Donald Hunter <donald.hunter@gmail.com>
Reviewed-by: Donald Hunter <donald.hunter@gmail.com>
Signed-off-by: Remy D. Farley <one-d-wide@protonmail.com>
---
 Documentation/netlink/netlink-raw.yaml | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/Documentation/netlink/netlink-raw.yaml b/Documentation/netlink=
/netlink-raw.yaml
index 0166a7e4a..dd98dda55 100644
--- a/Documentation/netlink/netlink-raw.yaml
+++ b/Documentation/netlink/netlink-raw.yaml
@@ -19,6 +19,12 @@ $defs:
     type: [ string, integer ]
     pattern: ^[0-9A-Za-z_-]+( - 1)?$
     minimum: 0
+  len-or-limit:
+    # literal int, const name, or limit based on fixed-width type
+    # e.g. u8-min, u16-max, etc.
+    type: [ string, integer ]
+    pattern: ^[0-9A-Za-z_-]+$
+    minimum: 0
=20
 # Schema for specs
 title: Protocol
@@ -270,7 +276,10 @@ properties:
                     type: string
                   min:
                     description: Min value for an integer attribute.
-                    type: integer
+                    $ref: '#/$defs/len-or-limit'
+                  max:
+                    description: Max value for an integer attribute.
+                    $ref: '#/$defs/len-or-limit'
                   min-len:
                     description: Min length for a binary attribute.
                     $ref: '#/$defs/len-or-define'
--=20
2.51.2


