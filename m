Received: from mail-4319.protonmail.ch (mail-4319.protonmail.ch [185.70.43.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D36B38643D
	for <netfilter-devel@vger.kernel.org>; Tue,  3 Mar 2026 19:59:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.70.43.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772567945; cv=none; b=LjkFEoUF0CSm4u+oRtm2DwmR3bJgNQ60ALBSQFKVrORmqUSvaWW8yCRIak1gAZ8yVCG9omQWl2GdGbgxHcRnwf44oi3rS5v8cSJXnVOdyP51n7vYwxevXP5Qx51rhQpcNEkUQgYXnYuzWBRe42X/lQJbCVZMfgZP7jlTD8QTe4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772567945; c=relaxed/simple;
	bh=nglxQM+IF1jwUObErERoVtCIF4I//VfoKKN9IY3dM6g=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Tv4oOj9dzZDRJNaQNfYKEPcCtznzpiQz3f4jT1RlJE1nkasmQ7pmQXgCselp90jQx2vTqyCLbpLMguc8mzqsVN46gMJef59L3WNNH1C8o77yX92ZGLstSD9ndqAgeUzsgk3pnDvCtgo00MGGKo1+jybIczVtRxAt7IDfFxD43LU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com; spf=pass smtp.mailfrom=protonmail.com; dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b=jYZdRQFP; arc=none smtp.client-ip=185.70.43.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=protonmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b="jYZdRQFP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1772567935; x=1772827135;
	bh=r1folD7/1fc+ukqhZfMz6M2F0RvSCyDSBPuwra8JrRg=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=jYZdRQFPRs60dO+JQNxndrBbpM00AZzYYaoajp0iPQ9TFn4uVKOzqkBiwwLE9s0UB
	 ek06lt7DBmlnsqMzV/n97cMDq+zah2Owt+sIMmPEQNAh3jA/xlIXLXvKokkUlh6TO/
	 yu9tXolJhrPHP/XO9dlI3I8xpVkdlXc0tvrvnh7Jp/kq0jJqDsPdMZLVHS7GH78DzN
	 R96ILOW3dW5o4T7NUtRq5o3nB+rbqgYEI1KlKRFwanfjhflbZIFo6Q/YJFrYo0KBZo
	 rwln28i/Dd5JWpPAxAbsMk98M6nzsrtOlSL6snHlqIw/z7CnCiYu7UaaL5YmyXPj7r
	 mLkFzYWJWMksQ==
Date: Tue, 03 Mar 2026 19:58:52 +0000
To: Donald Hunter <donald.hunter@gmail.com>, Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
From: "Remy D. Farley" <one-d-wide@protonmail.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org, coreteam@netfilter.org, "Remy D. Farley" <one-d-wide@protonmail.com>
Subject: [PATCH net-next v8 3/5] doc/netlink: nftables: Update attribute sets
Message-ID: <20260303195638.381642-4-one-d-wide@protonmail.com>
In-Reply-To: <20260303195638.381642-1-one-d-wide@protonmail.com>
References: <20260303195638.381642-1-one-d-wide@protonmail.com>
Feedback-ID: 59017272:user:proton
X-Pm-Message-ID: d54f405faada69f9f03c053b97339f575068f8bf
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

New attribute sets:
- log-attrs
- numgen-attrs
- range-attrs
- compat-target-attrs
- compat-match-attrs
- compat-attrs

Added missing attributes:
- table-attrs (pad, owner)
- set-attrs (type, count)

Added missing checks:
- range-attrs
- expr-bitwise-attrs
- compat-target-attrs
- compat-match-attrs
- compat-attrs

Annotated doc comment or associated enum:
- batch-attrs
- verdict-attrs
- expr-payload-attrs

Fixed byte order:
- nft-counter-attrs
- expr-counter-attrs
- rule-compat-attrs

Reviewed-by: Donald Hunter <donald.hunter@gmail.com>
Signed-off-by: Remy D. Farley <one-d-wide@protonmail.com>
---
 Documentation/netlink/specs/nftables.yaml | 208 +++++++++++++++++++++-
 1 file changed, 204 insertions(+), 4 deletions(-)

diff --git a/Documentation/netlink/specs/nftables.yaml b/Documentation/netl=
ink/specs/nftables.yaml
index f15f825cb..ba62adfb4 100644
--- a/Documentation/netlink/specs/nftables.yaml
+++ b/Documentation/netlink/specs/nftables.yaml
@@ -387,16 +387,100 @@ definitions:
=20
 attribute-sets:
   -
-    name: empty-attrs
+    name: log-attrs
+    doc: log expression netlink attributes
     attributes:
+      # Mentioned in nft_log_init()
       -
-        name: name
+        name: group
+        doc: netlink group to send messages to
+        type: u16
+        byte-order: big-endian
+      -
+        name: prefix
+        doc: prefix to prepend to log messages
         type: string
+      -
+        name: snaplen
+        doc: length of payload to include in netlink message
+        type: u32
+        byte-order: big-endian
+      -
+        name: qthreshold
+        doc: queue threshold
+        type: u16
+        byte-order: big-endian
+      -
+        name: level
+        doc: log level
+        type: u32
+        enum: log-level
+        byte-order: big-endian
+      -
+        name: flags
+        doc: logging flags
+        type: u32
+        enum: log-flags
+        byte-order: big-endian
+  -
+    name: numgen-attrs
+    doc: nf_tables number generator expression netlink attributes
+    attributes:
+      -
+        name: dreg
+        doc: destination register
+        type: u32
+        enum: registers
+      -
+        name: modulus
+        doc: maximum counter value
+        type: u32
+        byte-order: big-endian
+      -
+        name: type
+        doc: operation type
+        type: u32
+        byte-order: big-endian
+        enum: numgen-types
+      -
+        name: offset
+        doc: offset to be added to the counter
+        type: u32
+        byte-order: big-endian
+  -
+    name: range-attrs
+    attributes:
+      # Mentioned in net/netfilter/nft_range.c
+      -
+        name: sreg
+        doc: source register of data to compare
+        type: u32
+        byte-order: big-endian
+        enum: registers
+      -
+        name: op
+        doc: cmp operation
+        type: u32
+        byte-order: big-endian
+        enum: range-ops
+        checks:
+          max: 255
+      -
+        name: from-data
+        doc: data range from
+        type: nest
+        nested-attributes: data-attrs
+      -
+        name: to-data
+        doc: data range to
+        type: nest
+        nested-attributes: data-attrs
   -
     name: batch-attrs
     attributes:
       -
         name: genid
+        doc: generation ID for this changeset
         type: u32
         byte-order: big-endian
   -
@@ -423,10 +507,18 @@ attribute-sets:
         type: u64
         byte-order: big-endian
         doc: numeric handle of the table
+      -
+        name: pad
+        type: pad
       -
         name: userdata
         type: binary
         doc: user data
+      -
+        name: owner
+        type: u32
+        byte-order: big-endian
+        doc: owner of this table through netlink portID
   -
     name: chain-attrs
     attributes:
@@ -530,9 +622,11 @@ attribute-sets:
       -
         name: bytes
         type: u64
+        byte-order: big-endian
       -
         name: packets
         type: u64
+        byte-order: big-endian
   -
     name: rule-attrs
     attributes:
@@ -602,15 +696,18 @@ attribute-sets:
         selector: name
         doc: type specific data
   -
+    # Mentioned in nft_parse_compat() in net/netfilter/nft_compat.c
     name: rule-compat-attrs
     attributes:
       -
         name: proto
-        type: binary
+        type: u32
+        byte-order: big-endian
         doc: numeric value of the handled protocol
       -
         name: flags
-        type: binary
+        type: u32
+        byte-order: big-endian
         doc: bitmask of flags
   -
     name: set-attrs
@@ -699,6 +796,15 @@ attribute-sets:
         type: nest
         nested-attributes: set-list-attrs
         doc: list of expressions
+      -
+        name: type
+        type: string
+        doc: set backend type
+      -
+        name: count
+        type: u32
+        byte-order: big-endian
+        doc: number of set elements
   -
     name: set-desc-attrs
     attributes:
@@ -968,6 +1074,8 @@ attribute-sets:
         type: u32
         byte-order: big-endian
         enum: bitwise-ops
+        checks:
+          max: 255
       -
         name: data
         type: nest
@@ -1004,25 +1112,31 @@ attribute-sets:
     attributes:
       -
         name: code
+        doc: nf_tables verdict
         type: u32
         byte-order: big-endian
         enum: verdict-code
       -
         name: chain
+        doc: jump target chain name
         type: string
       -
         name: chain-id
+        doc: jump target chain ID
         type: u32
+        byte-order: big-endian
   -
     name: expr-counter-attrs
     attributes:
       -
         name: bytes
         type: u64
+        byte-order: big-endian
         doc: Number of bytes
       -
         name: packets
         type: u64
+        byte-order: big-endian
         doc: Number of packets
       -
         name: pad
@@ -1107,6 +1221,25 @@ attribute-sets:
         type: u32
         byte-order: big-endian
         enum: lookup-flags
+  -
+    name: expr-masq-attrs
+    attributes:
+      -
+        name: flags
+        type: u32
+        byte-order: big-endian
+        enum: nat-range-flags
+        enum-as-flags: true
+      -
+        name: reg-proto-min
+        type: u32
+        byte-order: big-endian
+        enum: registers
+      -
+        name: reg-proto-max
+        type: u32
+        byte-order: big-endian
+        enum: registers
   -
     name: expr-meta-attrs
     attributes:
@@ -1158,37 +1291,49 @@ attribute-sets:
         enum-as-flags: true
   -
     name: expr-payload-attrs
+    doc: nf_tables payload expression netlink attributes
     attributes:
       -
         name: dreg
+        doc: destination register to load data into
         type: u32
         byte-order: big-endian
+        enum: registers
       -
         name: base
+        doc: payload base
         type: u32
+        enum: payload-base
         byte-order: big-endian
       -
         name: offset
+        doc: payload offset relative to base
         type: u32
         byte-order: big-endian
       -
         name: len
+        doc: payload length
         type: u32
         byte-order: big-endian
       -
         name: sreg
+        doc: source register to load data from
         type: u32
         byte-order: big-endian
+        enum: registers
       -
         name: csum-type
+        doc: checksum type
         type: u32
         byte-order: big-endian
       -
         name: csum-offset
+        doc: checksum offset relative to base
         type: u32
         byte-order: big-endian
       -
         name: csum-flags
+        doc: checksum flags
         type: u32
         byte-order: big-endian
   -
@@ -1254,6 +1399,61 @@ attribute-sets:
         type: u32
         byte-order: big-endian
         doc: id of object map
+  -
+    name: compat-target-attrs
+    header: linux/netfilter/nf_tables_compat.h
+    attributes:
+      -
+        name: name
+        type: string
+        checks:
+          max-len: 32
+      -
+        name: rev
+        type: u32
+        byte-order: big-endian
+        checks:
+          max: 255
+      -
+        name: info
+        type: binary
+  -
+    name: compat-match-attrs
+    header: linux/netfilter/nf_tables_compat.h
+    attributes:
+      -
+        name: name
+        type: string
+        checks:
+          max-len: 32
+      -
+        name: rev
+        type: u32
+        byte-order: big-endian
+        checks:
+          max: 255
+      -
+        name: info
+        type: binary
+  -
+    name: compat-attrs
+    header: linux/netfilter/nf_tables_compat.h
+    attributes:
+      -
+        name: name
+        type: string
+        checks:
+          max-len: 32
+      -
+        name: rev
+        type: u32
+        byte-order: big-endian
+        checks:
+          max: 255
+      -
+        name: type
+        type: u32
+        byte-order: big-endian
=20
 sub-messages:
   -
--=20
2.51.2


