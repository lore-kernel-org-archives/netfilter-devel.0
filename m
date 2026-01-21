Received: from mail-07.mail-europe.com (mail-0701.mail-europe.com [51.83.17.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69CE63BBA01
	for <netfilter-devel@vger.kernel.org>; Wed, 21 Jan 2026 18:47:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=51.83.17.38
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769021277; cv=none; b=NvGk/zrkNtxtNeS/AnVhQDyr7LL6zOsnGsA9IOSYUJSmRsWXNvl4+Geo/oQtfTlXVac5k8B+xkzv7eVL7s0Bk3cJrDVdcWVF270nQba+RAcyWWf/9LIm4qLr0Kzfg9LI9YAQFUh//j0MGU8nJF4bT3KqRsl1Joqqu98VPfBt4Ng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769021277; c=relaxed/simple;
	bh=aZONMKoV3xeXKKuBsZfM6q1uWuGSbxY9g6oW7EZ0P1g=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pDgiTf9vffP+guyZShoGFi4m/Yf86cogsBOdEEk3QGvcAT2fbjB6P2o7KVEFxcYKMN6YtdC8pl3G8ySLz1H1+giNljJa6VOPucgHK6yjZJYZZ3vVjdxGz2WtAbzbIg3NS5EzfgJYtCI8uEhi619kJaH1BU97QQV7zsI/8bNiB1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com; spf=fail smtp.mailfrom=protonmail.com; dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b=rz5ixGpe; arc=none smtp.client-ip=51.83.17.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=protonmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b="rz5ixGpe"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1769021265; x=1769280465;
	bh=tODji/mp4vInkpmzMpKwslnkKQv+DRfMWiGB/PzfZJw=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=rz5ixGpeHwwX9/iRBHLrubyaLJ/k2a1iZVv2LNVfNNg3WZvBvdv0011XOVwMsuzMS
	 F94cQFjYJA6vEtC/25lp14ckptf4Ig4PnvtIubzy9ThxZDjikatjxJHXvrcspl5nI1
	 dtUj1UwEyoeQZB4icv0v9ObJ/cUqaQCdgoZ9ht5aDsTNM2B2v+LjBotKHhqnRTxhIb
	 KgFWF0bHFLwUX8c5Ra4/AF9iXodR0cv0JkR7gnqsCONeJlpSiaWS1S6b5ynloIGS5C
	 wU0/OlksM0XyFNkVa/AlF9fOBnrJV6c+oSltzfCTeeCJsqsUPAAeJX4m76VYTMjz01
	 M5pfksTGAwtjg==
Date: Wed, 21 Jan 2026 18:47:39 +0000
To: Donald Hunter <donald.hunter@gmail.com>, Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
From: "Remy D. Farley" <one-d-wide@protonmail.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Jozsef Kadlecsik <kadlec@netfilter.org>, Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org, coreteam@netfilter.org, "Remy D. Farley" <one-d-wide@protonmail.com>
Subject: [PATCH v6 2/6] doc/netlink: nftables: Add definitions
Message-ID: <20260121184621.198537-3-one-d-wide@protonmail.com>
In-Reply-To: <20260121184621.198537-1-one-d-wide@protonmail.com>
References: <20260121184621.198537-1-one-d-wide@protonmail.com>
Feedback-ID: 59017272:user:proton
X-Pm-Message-ID: 00d1083878b6512b1df0c36437bb077d7d9a7a86
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

New enums/flags:
- payload-base
- range-ops
- registers
- numgen-types
- log-level
- log-flags

Added missing enumerations:
- bitwise-ops

Annotated doc comment or associated enum:
- bitwise-ops

Signed-off-by: Remy D. Farley <one-d-wide@protonmail.com>
---
 Documentation/netlink/specs/nftables.yaml | 157 +++++++++++++++++++++-
 1 file changed, 154 insertions(+), 3 deletions(-)

diff --git a/Documentation/netlink/specs/nftables.yaml b/Documentation/netl=
ink/specs/nftables.yaml
index 17ad707fa..87cd4d201 100644
--- a/Documentation/netlink/specs/nftables.yaml
+++ b/Documentation/netlink/specs/nftables.yaml
@@ -66,9 +66,17 @@ definitions:
     name: bitwise-ops
     type: enum
     entries:
-      - bool
-      - lshift
-      - rshift
+      -
+        name: mask-xor  # aka bool (old name)
+        doc: >-
+          mask-and-xor operation used to implement NOT, AND, OR and XOR bo=
olean
+          operations
+      # Spinx docutils display warning when interleaving attrsets with str=
ings
+      - name: lshift
+      - name: rshift
+      - name: and
+      - name: or
+      - name: xor
   -
     name: cmp-ops
     type: enum
@@ -132,6 +140,12 @@ definitions:
       - object
       - concat
       - expr
+  -
+    name: set-elem-flags
+    type: flags
+    entries:
+      - interval-end
+      - catchall
   -
     name: lookup-flags
     type: flags
@@ -225,6 +239,127 @@ definitions:
       - icmp-unreach
       - tcp-rst
       - icmpx-unreach
+  -
+    name: reject-inet-code
+    doc: These codes are mapped to real ICMP and ICMPv6 codes.
+    type: enum
+    entries:
+      - icmpx-no-route
+      - icmpx-port-unreach
+      - icmpx-host-unreach
+      - icmpx-admin-prohibited
+  -
+    name: payload-base
+    type: enum
+    entries:
+      - link-layer-header
+      - network-header
+      - transport-header
+      - inner-header
+      - tun-header
+  -
+    name: range-ops
+    doc: Range operator
+    type: enum
+    entries:
+      - eq
+      - neq
+  -
+    name: registers
+    doc: |
+      nf_tables registers.
+      nf_tables used to have five registers: a verdict register and four d=
ata
+      registers of size 16. The data registers have been changed to 16 reg=
isters
+      of size 4. For compatibility reasons, the NFT_REG_[1-4] registers st=
ill
+      map to areas of size 16, the 4 byte registers are addressed using
+      NFT_REG32_00 - NFT_REG32_15.
+    type: enum
+    entries:
+      # Spinx docutils display warning when interleaving attrsets and stri=
ngs
+      - name: reg-verdict
+      - name: reg-1
+      - name: reg-2
+      - name: reg-3
+      - name: reg-4
+      - name: reg32-00
+        value: 8
+      - name: reg32-01
+      - name: reg32-02
+      - name: reg32-03
+      - name: reg32-04
+      - name: reg32-05
+      - name: reg32-06
+      - name: reg32-07
+      - name: reg32-08
+      - name: reg32-09
+      - name: reg32-10
+      - name: reg32-11
+      - name: reg32-12
+      - name: reg32-13
+      - name: reg32-14
+      - name: reg32-15
+  -
+    name: numgen-types
+    type: enum
+    entries:
+      - incremental
+      - random
+  -
+    name: log-level
+    doc: nf_tables log levels
+    type: enum
+    entries:
+      -
+        name: emerg
+        doc: system is unusable
+      -
+        name: alert
+        doc: action must be taken immediately
+      -
+        name: crit
+        doc: critical conditions
+      -
+        name: err
+        doc: error conditions
+      -
+        name: warning
+        doc: warning conditions
+      -
+        name: notice
+        doc: normal but significant condition
+      -
+        name: info
+        doc: informational
+      -
+        name: debug
+        doc: debug-level messages
+      -
+        name: audit
+        doc: enabling audit logging
+  -
+    name: log-flags
+    doc: nf_tables log flags
+    header: linux/netfilter/nf_log.h
+    type: flags
+    entries:
+      -
+        name: tcpseq
+        doc: Log TCP sequence numbers
+      -
+        name: tcpopt
+        doc: Log TCP options
+      -
+        name: ipopt
+        doc: Log IP options
+      -
+        name: uid
+        doc: Log UID owning local socket
+      -
+        name: nflog
+        doc: Unsupported, don't reuse
+      -
+        name: macdecode
+        doc: Decode MAC header
=20
 attribute-sets:
   -
@@ -767,6 +902,22 @@ attribute-sets:
         nested-attributes: hook-dev-attrs
   -
     name: expr-bitwise-attrs
+    doc: |
+      The bitwise expression supports boolean and shift operations. It
+      implements the boolean operations by performing the following
+      operation::
+
+          dreg =3D (sreg & mask) ^ xor
+
+          with these mask and xor values:
+
+          op      mask    xor
+          ----    ----    ---
+          NOT:     1       1
+          OR:     ~x       x
+          XOR:     1       x
+          AND:     x       0
+
     attributes:
       -
         name: sreg
--=20
2.51.2


