Received: from mail-06.mail-europe.com (mail-06.mail-europe.com [85.9.210.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56FA2369990
	for <netfilter-devel@vger.kernel.org>; Thu, 20 Nov 2025 15:19:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.9.210.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763651971; cv=none; b=Ua/69PkwiYHz4JV2fm6xA+ywwnCOnNB07tfc2tui+7vFDBkkqE4Ow51qQYc0AypHA6iT8sP7SVX2CWH3Yx94dwnWIWMGubmspuW6UxvLCWryl1gEWlbEGIrYSwFnJFRkL29AZe3rb8ry0/OjTK48nYjIns2pAuZnGHmwqUxA6Yw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763651971; c=relaxed/simple;
	bh=ocaPa10ovCwQnP3llvMPFtgbMoJGcdKKt3+T+kIQBT4=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mmHymfvInyxuxS4VV0lOBXCocw8voRvb5hNA6uBAP0/FMNkuOV7ZvEDvBojCd7nR3MEwS4+uKWLYsd+t6CrSv3I50S6T+nT6892jFFJq7mu6jNcbs1oxP6EdZFXcN76wH4TjeqRab3Y+qvgZqwaeNHswfpZbBJmmaptvI6Gzgw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com; spf=pass smtp.mailfrom=protonmail.com; dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b=Nr5YTYRi; arc=none smtp.client-ip=85.9.210.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=protonmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b="Nr5YTYRi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1763651954; x=1763911154;
	bh=c08RPYZJ0S+GTO2oq9Kbn61ZG/CvKokErkM/UXAkO1M=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=Nr5YTYRi80eqnB1D8lO7KfOPyYmwthPlRSGPF8CiNm6MgscjKfjd5K3kVphJ1d2ed
	 Rmq/jc12KRSQZqosTxOX8VhS3Hoxz2ABUEcM1SKsKdqV4Rs0XctgJjpBy0VHhVwBEy
	 2JPP2dQksnolJ1ollb/VFp1MUVmEQW1aPb9lAZaLkYu/Sp1Kky4pT4m40uWe1G4bG2
	 rbnHR+R7H8zLq0OV9w6HB01mGtSgFEyjbyupaqXlL1w7ptGnuwH2BR0b+DldUIKeOQ
	 RZR21NLqTd8RVDI+IsU8Pn0jpTG8roAxHpnlIq1UCVjt/kWe68sez4GSJMnY2QsGMd
	 NqTLRHTFuxO1Q==
Date: Thu, 20 Nov 2025 15:19:07 +0000
To: Donald Hunter <donald.hunter@gmail.com>, Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
From: "Remy D. Farley" <one-d-wide@protonmail.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Jozsef Kadlecsik <kadlec@netfilter.org>, Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org, coreteam@netfilter.org, "Remy D. Farley" <one-d-wide@protonmail.com>
Subject: [PATCH v5 2/6] doc/netlink: nftables: Add definitions
Message-ID: <20251120151754.1111675-3-one-d-wide@protonmail.com>
In-Reply-To: <20251120151754.1111675-1-one-d-wide@protonmail.com>
References: <20251120151754.1111675-1-one-d-wide@protonmail.com>
Feedback-ID: 59017272:user:proton
X-Pm-Message-ID: 1c1c57f0272f98c4207ca20be5bd623944db6eed
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

Annotated with a doc comment:
- bitwise-ops

Signed-off-by: Remy D. Farley <one-d-wide@protonmail.com>
---
 Documentation/netlink/specs/nftables.yaml | 147 +++++++++++++++++++++-
 1 file changed, 144 insertions(+), 3 deletions(-)

diff --git a/Documentation/netlink/specs/nftables.yaml b/Documentation/netl=
ink/specs/nftables.yaml
index cce88819b..e0c25af1d 100644
--- a/Documentation/netlink/specs/nftables.yaml
+++ b/Documentation/netlink/specs/nftables.yaml
@@ -66,9 +66,23 @@ definitions:
     name: bitwise-ops
     type: enum
     entries:
-      - bool
-      - lshift
-      - rshift
+      -
+        name: mask-xor  # aka bool (old name)
+        doc: |
+          mask-and-xor operation used to implement NOT, AND, OR and XOR
+            dreg =3D (sreg & mask) ^ xor
+          with these mask and xor values:
+                    mask    xor
+            NOT:    1       1
+            OR:     ~x      x
+            XOR:    1       x
+            AND:    x       0
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
@@ -132,6 +146,12 @@ definitions:
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
@@ -225,6 +245,127 @@ definitions:
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
--=20
2.50.1


