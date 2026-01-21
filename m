Received: from mail-10699.protonmail.ch (mail-10699.protonmail.ch [79.135.106.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96D993D332C;
	Wed, 21 Jan 2026 18:48:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=79.135.106.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769021286; cv=none; b=FzScXkSiRk42zAXKyqrgpAV3t9fakuqmsm92SUskFwROBcPENLgW8lh464a1sGYkXR26lvjOw9ct8oPKR6wJGaqHW1NgtvjW1zqqL6CmXpVZZ98opKblSxV6wSbcE350mRWPFEPplTrGVipU8YL3qfhXCG9x9odBrsTDWd4YD4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769021286; c=relaxed/simple;
	bh=bqy24RS7orfjFYmO/a4NSdvrVMe/IzQgxUirl7S7gVU=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ktOY5igv4UtFyp9E/3JYOpZPK1govEHc4vls6EoE2Qr5OtIVvCqNPIsh0YF8iydnLnYyhqpzt2QxKqkc7j0gNwUsUT6MZgBYXOdHH+KtSuUblhWXk+BGmhBFp6O3n4i4BafAe0wZyD1N8fsjUl3PYLtKvLV3n9XE6xlM/fC8YAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com; spf=pass smtp.mailfrom=protonmail.com; dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b=qykgIorz; arc=none smtp.client-ip=79.135.106.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=protonmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b="qykgIorz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1769021276; x=1769280476;
	bh=0VJPtau3dptbEIUP8vWDNEPq7hDIx3htzydYQPR9+Cg=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=qykgIorzrQmL+3K2bbaBy3/CdxlNlqywdytW5GhvhphQZGVsEuCBa82xQ9zEdsXKF
	 HqJBlYx+ICRNlKzT9Tv2c+mu7z0KYtIQA5rWmRkb+FcNVb+zSVJF5G1SsEuq2ZMZtg
	 ywx7u7Sgf4kMls63dvlb4TV+T+IiOTANIADgbdXfx19MQnm+JKbHGHjfZYatHPCci0
	 Tb++DsIkPeArKx7zmt5EhazjO9gVxtcDoUS48JLYQunCiA1sJfAk7kXRAujpY4MLX5
	 n5rcUnEojEiPNCy7ifcuSVx/JkKLujj53H6+DcOlqkR5To8KxKM3LRzE7SahEm1q3x
	 NmkfzGFwrUpNg==
Date: Wed, 21 Jan 2026 18:47:53 +0000
To: Donald Hunter <donald.hunter@gmail.com>, Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
From: "Remy D. Farley" <one-d-wide@protonmail.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Jozsef Kadlecsik <kadlec@netfilter.org>, Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org, coreteam@netfilter.org, "Remy D. Farley" <one-d-wide@protonmail.com>
Subject: [PATCH v6 6/6] doc/netlink: nftables: Fill out operation attributes
Message-ID: <20260121184621.198537-7-one-d-wide@protonmail.com>
In-Reply-To: <20260121184621.198537-1-one-d-wide@protonmail.com>
References: <20260121184621.198537-1-one-d-wide@protonmail.com>
Feedback-ID: 59017272:user:proton
X-Pm-Message-ID: 768f010b9f20c6c6806d536a2136859c08a3601b
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Filled out operation attributes:
- newtable
- gettable
- deltable
- destroytable
- newchain
- getchain
- delchain
- destroychain
- newrule
- getrule
- getrule-reset
- delrule
- destroyrule
- newset
- getset
- delset
- destroyset
- newsetelem
- getsetelem
- getsetelem-reset
- delsetelem
- destroysetelem
- getgen
- newobj
- getobj
- delobj
- destroyobj
- newflowtable
- getflowtable
- delflowtable
- destroyflowtable

Signed-off-by: Remy D. Farley <one-d-wide@protonmail.com>
---
 Documentation/netlink/specs/nftables.yaml | 292 ++++++++++++++++++----
 1 file changed, 250 insertions(+), 42 deletions(-)

diff --git a/Documentation/netlink/specs/nftables.yaml b/Documentation/netl=
ink/specs/nftables.yaml
index ce11312b9..973dcf8a0 100644
--- a/Documentation/netlink/specs/nftables.yaml
+++ b/Documentation/netlink/specs/nftables.yaml
@@ -1567,7 +1567,10 @@ operations:
         request:
           value: 0xa00
           attributes:
+            # Mentioned in nf_tables_newtable()
             - name
+            - flags
+            - userdata
     -
       name: gettable
       doc: Get / dump tables.
@@ -1577,11 +1580,21 @@ operations:
         request:
           value: 0xa01
           attributes:
+            # Mentioned in nf_tables_gettable()
             - name
         reply:
           value: 0xa00
-          attributes:
+          attributes: &get-table
+            # Mentioned in nf_tables_fill_table_info()
             - name
+            - use
+            - handle
+            - flags
+            - owner
+            - userdata
+      dump:
+        reply:
+          attributes: *get-table
     -
       name: deltable
       doc: Delete an existing table.
@@ -1590,8 +1603,10 @@ operations:
       do:
         request:
           value: 0xa02
-          attributes:
+          attributes: &del-table
+            # Mentioned in nf_tables_deltable()
             - name
+            - handle
     -
       name: destroytable
       doc: |
@@ -1602,8 +1617,7 @@ operations:
       do:
         request:
           value: 0xa1a
-          attributes:
-            - name
+          attributes: *del-table
     -
       name: newchain
       doc: Create a new chain.
@@ -1613,7 +1627,23 @@ operations:
         request:
           value: 0xa03
           attributes:
+            # Mentioned in nf_tables_newchain()
+            - table
+            - handle
+            - policy
+            - flags
+            # Mentioned in nf_tables_updchain()
+            - hook
             - name
+            - counters
+            - policy
+            # Mentioned in nf_tables_addchain()
+            - hook
+            - name
+            - counters
+            - userdata
+            # Mentioned in nft_chain_parse_hook()
+            - type
     -
       name: getchain
       doc: Get / dump chains.
@@ -1623,11 +1653,27 @@ operations:
         request:
           value: 0xa04
           attributes:
+            # Mentioned in nf_tables_getchain()
+            - table
             - name
         reply:
           value: 0xa03
-          attributes:
+          attributes: &get-chain
+            # Mentioned in nf_tables_fill_chain_info()
+            - table
             - name
+            - handle
+            - hook
+            - policy
+            - type
+            - flags
+            - counters
+            - id
+            - use
+            - userdata
+      dump:
+        reply:
+          attributes: *get-chain
     -
       name: delchain
       doc: Delete an existing chain.
@@ -1636,8 +1682,12 @@ operations:
       do:
         request:
           value: 0xa05
-          attributes:
+          attributes: &del-chain
+            # Mentioned in nf_tables_delchain()
+            - table
+            - handle
             - name
+            - hook
     -
       name: destroychain
       doc: |
@@ -1648,8 +1698,7 @@ operations:
       do:
         request:
           value: 0xa1b
-          attributes:
-            - name
+          attributes: *del-chain
     -
       name: newrule
       doc: Create a new rule.
@@ -1659,7 +1708,16 @@ operations:
         request:
           value: 0xa06
           attributes:
-            - name
+            # Mentioned in nf_tables_newrule()
+            - table
+            - chain
+            - chain-id
+            - handle
+            - position
+            - position-id
+            - expressions
+            - userdata
+            - compat
     -
       name: getrule
       doc: Get / dump rules.
@@ -1668,12 +1726,30 @@ operations:
       do:
         request:
           value: 0xa07
-          attributes:
-            - name
+          attributes: &get-rule-request
+            # Mentioned in nf_tables_getrule_single()
+            - table
+            - chain
+            - handle
         reply:
           value: 0xa06
+          attributes: &get-rule
+            # Mentioned in nf_tables_fill_rule_info()
+            - table
+            - chain
+            - handle
+            - position
+            - expressions
+            - userdata
+      dump:
+        request:
           attributes:
-            - name
+            # Mentioned in nf_tables_dump_rules_start()
+            - table
+            - chain
+        reply:
+          attributes: *get-rule
+
     -
       name: getrule-reset
       doc: Get / dump rules and reset stateful expressions.
@@ -1682,12 +1758,15 @@ operations:
       do:
         request:
           value: 0xa19
-          attributes:
-            - name
+          attributes: *get-rule-request
         reply:
           value: 0xa06
-          attributes:
-            - name
+          attributes: *get-rule
+      dump:
+        request:
+          attributes: *get-rule-request
+        reply:
+          attributes: *get-rule
     -
       name: delrule
       doc: Delete an existing rule.
@@ -1696,8 +1775,11 @@ operations:
       do:
         request:
           value: 0xa08
-          attributes:
-            - name
+          attributes: &del-rule
+            - table
+            - chain
+            - handle
+            - id
     -
       name: destroyrule
       doc: |
@@ -1707,8 +1789,7 @@ operations:
       do:
         request:
           value: 0xa1c
-          attributes:
-            - name
+          attributes: *del-rule
     -
       name: newset
       doc: Create a new set.
@@ -1718,7 +1799,24 @@ operations:
         request:
           value: 0xa09
           attributes:
+            # Mentioned in nf_tables_newset()
+            - table
             - name
+            - key-len
+            - id
+            - key-type
+            - key-len
+            - flags
+            - data-type
+            - data-len
+            - obj-type
+            - timeout
+            - gc-interval
+            - policy
+            - desc
+            - table
+            - name
+            - userdata
     -
       name: getset
       doc: Get / dump sets.
@@ -1728,11 +1826,35 @@ operations:
         request:
           value: 0xa0a
           attributes:
+            # Mentioned in nf_tables_getset()
+            - table
             - name
         reply:
           value: 0xa09
-          attributes:
+          attributes: &get-set
+            # Mentioned in nf_tables_fill_set()
+            - table
             - name
+            - handle
+            - flags
+            - key-len
+            - key-type
+            - data-type
+            - data-len
+            - obj-type
+            - gc-interval
+            - policy
+            - userdata
+            - desc
+            - expr
+            - expressions
+      dump:
+        request:
+          attributes:
+            # Mentioned in nf_tables_getset()
+            - table
+        reply:
+          attributes: *get-set
     -
       name: delset
       doc: Delete an existing set.
@@ -1741,7 +1863,10 @@ operations:
       do:
         request:
           value: 0xa0b
-          attributes:
+          attributes: &del-set
+            # Mentioned in nf_tables_delset()
+            - table
+            - handle
             - name
     -
       name: destroyset
@@ -1752,8 +1877,7 @@ operations:
       do:
         request:
           value: 0xa1d
-          attributes:
-            - name
+          attributes: *del-set
     -
       name: newsetelem
       doc: Create a new set element.
@@ -1763,7 +1887,11 @@ operations:
         request:
           value: 0xa0c
           attributes:
-            - name
+            # Mentioned in nf_tables_newsetelem()
+            - table
+            - set
+            - set-id
+            - elements
     -
       name: getsetelem
       doc: Get / dump set elements.
@@ -1773,11 +1901,27 @@ operations:
         request:
           value: 0xa0d
           attributes:
-            - name
+            # Mentioned in nf_tables_getsetelem()
+            - table
+            - set
+            - elements
         reply:
           value: 0xa0c
           attributes:
-            - name
+            # Mentioned in nf_tables_fill_setelem_info()
+            - elements
+      dump:
+        request:
+          attributes: &dump-set-request
+            # Mentioned in nft_set_dump_ctx_init()
+            - table
+            - set
+        reply:
+          attributes: &dump-set
+            # Mentioned in nf_tables_dump_set()
+            - table
+            - set
+            - elements
     -
       name: getsetelem-reset
       doc: Get / dump set elements and reset stateful expressions.
@@ -1787,11 +1931,20 @@ operations:
         request:
           value: 0xa21
           attributes:
-            - name
+            # Mentioned in nf_tables_getsetelem_reset()
+            - elements
         reply:
           value: 0xa0c
           attributes:
-            - name
+            # Mentioned in nf_tables_dumpreset_set()
+            - table
+            - set
+            - elements
+      dump:
+        request:
+          attributes: *dump-set-request
+        reply:
+          attributes: *dump-set
     -
       name: delsetelem
       doc: Delete an existing set element.
@@ -1800,8 +1953,11 @@ operations:
       do:
         request:
           value: 0xa0e
-          attributes:
-            - name
+          attributes: &del-setelem
+            # Mentioned in nf_tables_delsetelem()
+            - table
+            - set
+            - elements
     -
       name: destroysetelem
       doc: Delete an existing set element with destroy semantics.
@@ -1810,8 +1966,7 @@ operations:
       do:
         request:
           value: 0xa1e
-          attributes:
-            - name
+          attributes: *del-setelem
     -
       name: getgen
       doc: Get / dump rule-set generation.
@@ -1820,12 +1975,16 @@ operations:
       do:
         request:
           value: 0xa10
-          attributes:
-            - name
         reply:
           value: 0xa0f
-          attributes:
-            - name
+          attributes: &get-gen
+            # Mentioned in nf_tables_fill_gen_info()
+            - id
+            - proc-pid
+            - proc-name
+      dump:
+        reply:
+          attributes: *get-gen
     -
       name: newobj
       doc: Create a new stateful object.
@@ -1835,7 +1994,12 @@ operations:
         request:
           value: 0xa12
           attributes:
+            # Mentioned in nf_tables_newobj()
+            - type
             - name
+            - data
+            - table
+            - userdata
     -
       name: getobj
       doc: Get / dump stateful objects.
@@ -1845,11 +2009,29 @@ operations:
         request:
           value: 0xa13
           attributes:
+            # Mentioned in nf_tables_getobj_single()
             - name
+            - type
+            - table
         reply:
           value: 0xa12
-          attributes:
+          attributes: &obj-info
+            # Mentioned in nf_tables_fill_obj_info()
+            - table
             - name
+            - type
+            - handle
+            - use
+            - data
+            - userdata
+      dump:
+        request:
+          attributes:
+            # Mentioned in nf_tables_dump_obj_start()
+            - table
+            - type
+        reply:
+          attributes: *obj-info
     -
       name: delobj
       doc: Delete an existing stateful object.
@@ -1859,7 +2041,11 @@ operations:
         request:
           value: 0xa14
           attributes:
+            # Mentioned in nf_tables_delobj()
+            - table
             - name
+            - type
+            - handle
     -
       name: destroyobj
       doc: Delete an existing stateful object with destroy semantics.
@@ -1869,7 +2055,11 @@ operations:
         request:
           value: 0xa1f
           attributes:
+            # Mentioned in nf_tables_delobj()
+            - table
             - name
+            - type
+            - handle
     -
       name: newflowtable
       doc: Create a new flow table.
@@ -1879,7 +2069,11 @@ operations:
         request:
           value: 0xa16
           attributes:
+            # Mentioned in nf_tables_newflowtable()
+            - table
             - name
+            - hook
+            - flags
     -
       name: getflowtable
       doc: Get / dump flow tables.
@@ -1889,11 +2083,22 @@ operations:
         request:
           value: 0xa17
           attributes:
+            # Mentioned in nf_tables_getflowtable()
             - name
+            - table
         reply:
           value: 0xa16
-          attributes:
+          attributes: &flowtable-info
+            # Mentioned in nf_tables_fill_flowtable_info()
+            - table
             - name
+            - handle
+            - use
+            - flags
+            - hook
+      dump:
+        reply:
+          attributes: *flowtable-info
     -
       name: delflowtable
       doc: Delete an existing flow table.
@@ -1902,8 +2107,12 @@ operations:
       do:
         request:
           value: 0xa18
-          attributes:
+          attributes: &del-flowtable
+            # Mentioned in nf_tables_delflowtable()
+            - table
             - name
+            - handle
+            - hook
     -
       name: destroyflowtable
       doc: Delete an existing flow table with destroy semantics.
@@ -1912,8 +2121,7 @@ operations:
       do:
         request:
           value: 0xa20
-          attributes:
-            - name
+          attributes: *del-flowtable
=20
 mcast-groups:
   list:
--=20
2.51.2


