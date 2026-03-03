Received: from mail-106103.protonmail.ch (mail-106103.protonmail.ch [79.135.106.103])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDDBF3890EA
	for <netfilter-devel@vger.kernel.org>; Tue,  3 Mar 2026 19:57:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=79.135.106.103
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772567870; cv=none; b=K2lF1B9fpMNC/7p6CGX8NmeVW7HdW66MqYf+uwrnkRuEkvDdcezhPU2fbb5TSIPpjMlMGXwZK7ONtQlwxDnAdWy8Ur6Jyugv8uZ7Kb2unbJd1oVhSTlNnlM6naI0THLv760N4bjtYJXQU1RtxxZ2KOlJKp5rjtahY/vFm37SVCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772567870; c=relaxed/simple;
	bh=n8FGee2L5bkPookg0YdJjFRKNtl4T+XNB6/eNYSidVM=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qCTN4gK/GML2ie0j0e4U2OOykFThPAr+kbBUwLOX5cKEcfTGM/BtaN2avR9c5pgJyxa1EJVHdJkFyumU8oY4Wqs8TCtXzgyphnOrjLyQ/L2gJnIlojFiCLgr0O33/H7COBTGIGPah+0HpQAUYOGrgHW+4xayFPJ/YL2+iZ8t+as=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com; spf=pass smtp.mailfrom=protonmail.com; dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b=lesEg0+c; arc=none smtp.client-ip=79.135.106.103
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=protonmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b="lesEg0+c"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1772567865; x=1772827065;
	bh=Blr5GdP413xj9Y60FcLkP86aKJZ2VM3UVfsMfTMR3Dg=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=lesEg0+caXeyNutxOjIsq9f14hE5166VPdjEgLu1ha49TmUPkEqIfW+Fjh32MkEtR
	 Ip8BqXPzmodtzUkU4hf2bnaKW7tNBN94BRDdXTs8CQuioZcTyaC3r3IiKD9wYKfbEy
	 r8ROuHRT9DrgMmwMoOhqaTFKwy+lEdRkduJOpxZz0wiez0XTPFaoJi9mf+bWiJJvvz
	 TZx4t5aqoSIjaSIXnfb2DLipL4lDaOl0HoTayWcKTfXpYwbLJtwbAcpbF3jTbCF/Fu
	 bRs87SuVgS2pTfbjt6oSfhx562MxX0hj+qJzg+l1ZbVUV+eXiByRGlVDF6G2KQKAUo
	 myV17Fs+K3Ogw==
Date: Tue, 03 Mar 2026 19:57:41 +0000
To: Donald Hunter <donald.hunter@gmail.com>, Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
From: "Remy D. Farley" <one-d-wide@protonmail.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org, coreteam@netfilter.org, "Remy D. Farley" <one-d-wide@protonmail.com>
Subject: [PATCH net-next v8 1/5] doc/netlink: netlink-raw: Add max check
Message-ID: <20260303195638.381642-2-one-d-wide@protonmail.com>
In-Reply-To: <20260303195638.381642-1-one-d-wide@protonmail.com>
References: <20260303195638.381642-1-one-d-wide@protonmail.com>
Feedback-ID: 59017272:user:proton
X-Pm-Message-ID: f38a3efdbe692eefe5f20ed36d21ed372d250cc5
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


