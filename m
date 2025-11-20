Received: from mail-10699.protonmail.ch (mail-10699.protonmail.ch [79.135.106.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C2A13702EA;
	Thu, 20 Nov 2025 15:19:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=79.135.106.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763651977; cv=none; b=CbDpibq/vIJWYCC1GNYl0Lh6Y8rjh2uqYwtvjE7/aH8u5pF0P0sqQH8AMFPduK/x/nfzXJL0bg+gYpre13FN0Op5zcQWla7ib3TSrCXxk4zsEj9xvST49znojisLapQJnqJH9G7mTZHEXZxuueTEAZ4u1m2d1V9vu3TPtlIYh/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763651977; c=relaxed/simple;
	bh=Dh3DrdCTcihW/wUBw06SIxbpfjR492XI0rSutFnv+1s=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kIekEb+JqTFykl6UUy3GOUY1w7fKrtxYUJVeXisml2iw2CEHlobVdSI2O9RuOBDN3HIn5MR4b1/MXKccdvkcUgh2XgryNmcs3YFmxrCiXQhqwR41TG8ZiwA9RsZAVsyZDjQrBNyYpvOfoAW0Tfw1c9uIk2yJPykenllxjRZqOPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com; spf=pass smtp.mailfrom=protonmail.com; dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b=sNrOZIuP; arc=none smtp.client-ip=79.135.106.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=protonmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b="sNrOZIuP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1763651973; x=1763911173;
	bh=xEqiZkirnigTjhRtKXY3tXH/5TLdPTHvHlV0Do0VpWM=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=sNrOZIuPVPfcdqwB/1zK+toroBNgOCuhNqr4vYHavRsIELAnkSfPpdYljhSxZgDKf
	 X3tkG3w3CC1XVrDiuEdFfZkWr+SXie1RQy8ddzRrnoUhMGihe03iNN2UeWdy2DVq4f
	 XaZ8NR16aKaF7ek++7Ez02mWh/yVLM1wENjb80ATsXkN5SrOvwVEz6LhHbeELqc/Rg
	 TNeY96aOpCUi9+LpVHRz/7imVafD5Y4djeqUZoiVsUBfCYoTxwruPbcvMkXD4/ZL3D
	 MJUdyE5VpIFkST8EjdZZ668KP0HoDhgHLs0+AIZaag2EQEg9uv4MsL9PU/3pez+tr6
	 /YIT4JZvwp7LA==
Date: Thu, 20 Nov 2025 15:19:29 +0000
To: Donald Hunter <donald.hunter@gmail.com>, Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
From: "Remy D. Farley" <one-d-wide@protonmail.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Jozsef Kadlecsik <kadlec@netfilter.org>, Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org, coreteam@netfilter.org, "Remy D. Farley" <one-d-wide@protonmail.com>
Subject: [PATCH v5 4/6] doc/netlink: nftables: Add sub-messages
Message-ID: <20251120151754.1111675-5-one-d-wide@protonmail.com>
In-Reply-To: <20251120151754.1111675-1-one-d-wide@protonmail.com>
References: <20251120151754.1111675-1-one-d-wide@protonmail.com>
Feedback-ID: 59017272:user:proton
X-Pm-Message-ID: 3caa4e4e43760f5f78e1e66e3a2152774d3f6a43
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

New sub-messsages:
- match
- range
- numgen
- log

Signed-off-by: Remy D. Farley <one-d-wide@protonmail.com>
---
 Documentation/netlink/specs/nftables.yaml | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/Documentation/netlink/specs/nftables.yaml b/Documentation/netl=
ink/specs/nftables.yaml
index 01f44da90..3cad6f857 100644
--- a/Documentation/netlink/specs/nftables.yaml
+++ b/Documentation/netlink/specs/nftables.yaml
@@ -1471,6 +1471,21 @@ sub-messages:
       -
         value: tproxy
         attribute-set: expr-tproxy-attrs
+      -
+        value: match
+        attribute-set: compat-match-attrs
+      -
+        value: range
+        attribute-set: range-attrs
+      -
+        value: numgen
+        attribute-set: numgen-attrs
+      -
+        value: log
+        attribute-set: log-attrs
+        # There're more sub-messages to go:
+        #   grep -A10 nft_expr_type
+        # and look for .name\s*=3D\s*"..."
   -
     name: obj-data
     formats:
--=20
2.50.1


