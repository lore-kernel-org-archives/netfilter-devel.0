Received: from mail-10697.protonmail.ch (mail-10697.protonmail.ch [79.135.106.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4E6636A03F;
	Thu, 20 Nov 2025 15:20:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=79.135.106.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763652005; cv=none; b=mLcZ3Yt+xDaQTF4Y38WXRXfzaWcz91Vh3hSoNU4wFpM8nJiurqOWX4LNk4jgPS0PssbcIlSm/YXBEMYEDdOtmGg+4VV0NskKLvh/Y8QoSTXH/vmZam6A/l3w9lO3B34z40k7NEQyBX+Gkss+JV/KnSlDrWbUH2/4gV5g+Th0QU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763652005; c=relaxed/simple;
	bh=ejblmVm/5VFJ/xz5i1sikrMsvlMTHx9pzxPIS7Ve5hk=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OBmTqDlVDNV3ZbOYtEmcCHD7XKnz25cnlGJH73ILeJtP7h9ermd5SGjeqn1X921+TgP7xCO1W+2MzQjKUsbX2DydDjWlOFJIUQsKqkIa8EIPYZzCwD7cdCRXh8lC+W1EhEuiv2Q8564MjluUV2T/a1F3jOQxevM8x4wdA7OxCt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com; spf=pass smtp.mailfrom=protonmail.com; dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b=r6zBi5Nz; arc=none smtp.client-ip=79.135.106.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=protonmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b="r6zBi5Nz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1763651999; x=1763911199;
	bh=ki/06JwMX2BgRhnH9CN7TR2N9Piv2RnfQ9jmXrQ68fE=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=r6zBi5NzOmSVbSDXkYWOuhr0sPJF6KEPDxtYaJgFV05XT81jQA72hk86SwFvJesXY
	 cV9KsVUrx1X4sPoc2F4Qm3K/SFRg2GdFwnFvXhzKw5aRQ2xt8FLXmaZzkFs2ENyWbt
	 sWmHUlR08ckUURiAfrqGkdQL44Bxv06H/Lg2yWVgDHccQIobH2Vye541CqPQ8LSIqz
	 Zwx/SD7GIc5xA1YHFdUoz/6H8bD6dYImPdT0GTQCMkgX3gj5/A0zCvDJZ9z4XvnkwU
	 um08rLDGImMIVaciMyjBolfJvO5YdUhm5m09v8MjZyfks6h8/OXqPTDN98APAO9pOo
	 SK7RzlYq6qOew==
Date: Thu, 20 Nov 2025 15:19:51 +0000
To: Donald Hunter <donald.hunter@gmail.com>, Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
From: "Remy D. Farley" <one-d-wide@protonmail.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Jozsef Kadlecsik <kadlec@netfilter.org>, Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org, coreteam@netfilter.org, "Remy D. Farley" <one-d-wide@protonmail.com>
Subject: [PATCH v5 6/6] doc/netlink: nftables: Fill out operation attributes
Message-ID: <20251120151754.1111675-7-one-d-wide@protonmail.com>
In-Reply-To: <20251120151754.1111675-1-one-d-wide@protonmail.com>
References: <20251120151754.1111675-1-one-d-wide@protonmail.com>
Feedback-ID: 59017272:user:proton
X-Pm-Message-ID: 459e0fb04093260b569b19c90042e17d2ce3e23b
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
index 79a3b9a20..136b2502a 100644
--- a/Documentation/netlink/specs/nftables.yaml
+++ b/Documentation/netlink/specs/nftables.yaml
@@ -1557,7 +1557,10 @@ operations:
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
@@ -1567,11 +1570,21 @@ operations:
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
@@ -1580,8 +1593,10 @@ operations:
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
@@ -1592,8 +1607,7 @@ operations:
       do:
         request:
           value: 0xa1a
-          attributes:
-            - name
+          attributes: *del-table
     -
       name: newchain
       doc: Create a new chain.
@@ -1603,7 +1617,23 @@ operations:
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
@@ -1613,11 +1643,27 @@ operations:
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
@@ -1626,8 +1672,12 @@ operations:
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
@@ -1638,8 +1688,7 @@ operations:
       do:
         request:
           value: 0xa1b
-          attributes:
-            - name
+          attributes: *del-chain
     -
       name: newrule
       doc: Create a new rule.
@@ -1649,7 +1698,16 @@ operations:
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
@@ -1658,12 +1716,30 @@ operations:
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
@@ -1672,12 +1748,15 @@ operations:
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
@@ -1686,8 +1765,11 @@ operations:
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
@@ -1697,8 +1779,7 @@ operations:
       do:
         request:
           value: 0xa1c
-          attributes:
-            - name
+          attributes: *del-rule
     -
       name: newset
       doc: Create a new set.
@@ -1708,7 +1789,24 @@ operations:
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
@@ -1718,11 +1816,35 @@ operations:
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
@@ -1731,7 +1853,10 @@ operations:
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
@@ -1742,8 +1867,7 @@ operations:
       do:
         request:
           value: 0xa1d
-          attributes:
-            - name
+          attributes: *del-set
     -
       name: newsetelem
       doc: Create a new set element.
@@ -1753,7 +1877,11 @@ operations:
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
@@ -1763,11 +1891,27 @@ operations:
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
@@ -1777,11 +1921,20 @@ operations:
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
@@ -1790,8 +1943,11 @@ operations:
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
@@ -1800,8 +1956,7 @@ operations:
       do:
         request:
           value: 0xa1e
-          attributes:
-            - name
+          attributes: *del-setelem
     -
       name: getgen
       doc: Get / dump rule-set generation.
@@ -1810,12 +1965,16 @@ operations:
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
@@ -1825,7 +1984,12 @@ operations:
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
@@ -1835,11 +1999,29 @@ operations:
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
@@ -1849,7 +2031,11 @@ operations:
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
@@ -1859,7 +2045,11 @@ operations:
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
@@ -1869,7 +2059,11 @@ operations:
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
@@ -1879,11 +2073,22 @@ operations:
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
@@ -1892,8 +2097,12 @@ operations:
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
@@ -1902,8 +2111,7 @@ operations:
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
2.50.1


