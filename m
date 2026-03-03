Received: from mail-10699.protonmail.ch (mail-10699.protonmail.ch [79.135.106.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9328F30C371;
	Tue,  3 Mar 2026 19:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=79.135.106.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772567907; cv=none; b=JvcOQrlK5woo4yhXREqU3wR4TeJ7MzL9w/4g5ZPs5gPGdGj5iVLapWs7CHYDkCvOCdgUdDScPFpcjxpK20mlgpV2zFH1hytEGq/Frxy54c3qEHNsQOPP2IU0P9Pgo6bpKCI9TuExM5/5BuNvv1dYXJrl1yT5uKkfv0LILPG7OB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772567907; c=relaxed/simple;
	bh=Hu76kATG9N/5plvjm+rJh6m84mUVO8POtXZlv0F8oKg=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mXGdIsnJd07ENyeFytQQc9HoOFARcpBtTIzYUn6pX9Fh8qwgCCyQ9rP3zuFF9SDS2/pHy1MOuU44lLngVmTq1VZBfGG32gUx1c1GDQnx/3tE8jkgFgdVRxUkXghR0z+P/2OIVSKaELhTcTM8304/ui/1knvOB7tjmULoB4Cqf6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com; spf=pass smtp.mailfrom=protonmail.com; dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b=p7UqHcBV; arc=none smtp.client-ip=79.135.106.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=protonmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b="p7UqHcBV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1772567897; x=1772827097;
	bh=WRw9OzXx5E/BGMbZ5iV68e85Ik47NEOdpd1i9spn58Y=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=p7UqHcBVCxrN6vyQtJmG2UJRN8rv7vYW8ZBkoroHSQ/qsbgDC7sUYcJW9FzxciYda
	 ulwpQOtb2P8F0f3uNsceb5zewN9CmDMMTmQgnhqgv+n1Sw+vtuzCAWSQFyP/O/I0kR
	 Hk5/9lGUdFGHQ9iFyPT62VRvg9MWR8ISv301s0xiX3Ar25KAQrioUSW3skgfmgK4/P
	 2ztu059DLZiz4zxDKpk4Chza0g5ZHPf0Pxo+tVcPxtTzH6ZSajYVf9cojJB1hADEa6
	 LGP9VISXdYHRthIKXika9izjYKg8A3tLYJlCovuITnPOrnkUTOkNbFyxqbMk315jvv
	 vO1/Z5zRgdx2w==
Date: Tue, 03 Mar 2026 19:58:13 +0000
To: Donald Hunter <donald.hunter@gmail.com>, Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
From: "Remy D. Farley" <one-d-wide@protonmail.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org, coreteam@netfilter.org, "Remy D. Farley" <one-d-wide@protonmail.com>
Subject: [PATCH net-next v8 2/5] doc/netlink: nftables: Add definitions
Message-ID: <20260303195638.381642-3-one-d-wide@protonmail.com>
In-Reply-To: <20260303195638.381642-1-one-d-wide@protonmail.com>
References: <20260303195638.381642-1-one-d-wide@protonmail.com>
Feedback-ID: 59017272:user:proton
X-Pm-Message-ID: 51b05305c60acbd5d7be2abd12439db203a3376b
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

Reviewed-by: Donald Hunter <donald.hunter@gmail.com>
Signed-off-by: Remy D. Farley <one-d-wide@protonmail.com>
---
 Documentation/netlink/specs/nftables.yaml | 181 +++++++++++++++++++++-
 1 file changed, 178 insertions(+), 3 deletions(-)

diff --git a/Documentation/netlink/specs/nftables.yaml b/Documentation/netl=
ink/specs/nftables.yaml
index 17ad707fa..f15f825cb 100644
--- a/Documentation/netlink/specs/nftables.yaml
+++ b/Documentation/netlink/specs/nftables.yaml
@@ -66,9 +66,21 @@ definitions:
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
+      -
+        name: lshift
+      -
+        name: rshift
+      -
+        name: and
+      -
+        name: or
+      -
+        name: xor
   -
     name: cmp-ops
     type: enum
@@ -132,6 +144,12 @@ definitions:
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
@@ -225,6 +243,147 @@ definitions:
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
+      -
+        name: reg-verdict
+      -
+        name: reg-1
+      -
+        name: reg-2
+      -
+        name: reg-3
+      -
+        name: reg-4
+      -
+        name: reg32-00
+        value: 8
+      -
+        name: reg32-01
+      -
+        name: reg32-02
+      -
+        name: reg32-03
+      -
+        name: reg32-04
+      -
+        name: reg32-05
+      -
+        name: reg32-06
+      -
+        name: reg32-07
+      -
+        name: reg32-08
+      -
+        name: reg32-09
+      -
+        name: reg32-10
+      -
+        name: reg32-11
+      -
+        name: reg32-12
+      -
+        name: reg32-13
+      -
+        name: reg32-14
+      -
+        name: reg32-15
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
@@ -767,6 +926,22 @@ attribute-sets:
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


