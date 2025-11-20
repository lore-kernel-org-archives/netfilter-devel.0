Received: from mail-24428.protonmail.ch (mail-24428.protonmail.ch [109.224.244.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC9323624B7
	for <netfilter-devel@vger.kernel.org>; Thu, 20 Nov 2025 15:19:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=109.224.244.28
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763651952; cv=none; b=VlK5xMgecNFPAz8YMnIeV/sNqCcSUb4j5tVgTEV9rWRX2DBtc7dWqBktcbQrfkh4vvdJrd5cS2pKs0lWh0ApmTEsfRcM7DbkmbiXFOZDu+Z6hGbk7NhzPWiIb2iaSZRyiYAMC9aC8gRpfdEf8gu4LJFnBhYSvDWeh3YQEk/tZyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763651952; c=relaxed/simple;
	bh=PCeJMFFzHYkGfYmGLzet/MuBMWWz18PimT2HoP0j9uQ=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=l2dgJZvQ0vxninfYeICDTEHaaSdL2n+YFUTS+NdvUlzU+r9cgPd3tmTr6bASWKvfXtGIIJfnkWVjMu1oh/XTjuOzoudf/xmDoaMsMOwwTW8rKVY6udPM0SuCGDIEbGoTZDS6WJ/DfX3mBqSy9qko9MlPieBRfqj6E0YrGW9IAQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com; spf=pass smtp.mailfrom=protonmail.com; dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b=nRobjeSY; arc=none smtp.client-ip=109.224.244.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=protonmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b="nRobjeSY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1763651948; x=1763911148;
	bh=nX24P09ZMgIQfFBCK8UIbPGF+gIsNfQYQgBbTLpmDZM=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=nRobjeSY7v9J7uWi7B7upUsiiveLKuZXG7VrFzu96yExuQc9IDUKpb/BFkKZQpb0m
	 eHfBbAHn7uzKGTOa0EdhCDpKoVk6BkYW7Tie9TXzrNWgFzo4LGe5vGJjUv1o9h6LcG
	 tfLe0N6wAWrp92zfcV/kx2nvfD2jEeUFwAGPM7Svn8LFBFKJzAvdDSLGy/rOSEFCyI
	 rZ1H21xpHBZ9P868Y7flm0e2bZBFDDRdfL2kLvM97tpRgVUB6TggHSJKZTS9vgXk1e
	 L+txbHvWrj8gJO1rKYSrNl+0bGtA5V0HhoRfkjmNOqQc8trdokhDlg42hsq4vo5Gxg
	 yN44vcBfPfKyw==
Date: Thu, 20 Nov 2025 15:18:56 +0000
To: Donald Hunter <donald.hunter@gmail.com>, Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
From: "Remy D. Farley" <one-d-wide@protonmail.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Jozsef Kadlecsik <kadlec@netfilter.org>, Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org, coreteam@netfilter.org, "Remy D. Farley" <one-d-wide@protonmail.com>
Subject: [PATCH v5 1/6] doc/netlink: netlink-raw: Add max check
Message-ID: <20251120151754.1111675-2-one-d-wide@protonmail.com>
In-Reply-To: <20251120151754.1111675-1-one-d-wide@protonmail.com>
References: <20251120151754.1111675-1-one-d-wide@protonmail.com>
Feedback-ID: 59017272:user:proton
X-Pm-Message-ID: 55f7d66ac4b8c543c70a0005c72455f1a2ae885e
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Suggested-by: Donald Hunter <donald.hunter@gmail.com>
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
2.50.1


