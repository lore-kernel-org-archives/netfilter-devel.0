Received: from mail-24428.protonmail.ch (mail-24428.protonmail.ch [109.224.244.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84BF64A21;
	Mon,  2 Feb 2026 09:41:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=109.224.244.28
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770025280; cv=none; b=Dmw8ENq+pHzgWvBsxd7bw47l1iVJqY9ldyEdh137va5kFI80DPP0VRXZ/zoRZdnpL2QeClHj0XRW67TF4PyxmuZ8ph++pNqCNmoOIMWtK3RcldV+sCYy73/TAKmKajDluVN+JOvWD9Smxd45GZKmbh/8crLP7YCf5eAMjXohAG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770025280; c=relaxed/simple;
	bh=QJZjowOtK0/by+xhEWVSBQBQZze3KAhc+NgA4nLwZ8g=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=A0cmNjC9RkXl54gxOn0SfOT2J4dedjEEq/9kYvtbcsWYmAgMfWjPidazbS0jZLYZPuRTR7mWc0dkJ432vtlvshryEyM/CRil7hHTI0+puJiTaEsYA8i+cdtPrA6DGLuwvXx4jYOPVlST2wlYbFkJrGCfBW+nLg8eOPYENulHL/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com; spf=pass smtp.mailfrom=protonmail.com; dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b=YLnhYZ+v; arc=none smtp.client-ip=109.224.244.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=protonmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b="YLnhYZ+v"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1770025276; x=1770284476;
	bh=n7+4tdcZCvoxWkNx6ZUG9llFiUi1cRnrd1biahF2TEc=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=YLnhYZ+vzW4/LV7R0UhhAtAajPelizLcc1JlhXnaBf3XD5xk+DGI4cG2vJoTcWfEP
	 ydg8vIdd+M5E/u7mnlnEkaC1CWFS20ZDpM7W8N3M06Her9GQyqPm0vOwTDAYHZI2SU
	 ZahfGGPxdKF6gAgPckMMynHAmTkPd5o6AlmCJpOn8YKaiwHAg8WRWSsQtbJJkSS3rT
	 k+AwYk59ioXT/M1vYmLZqIsl15fCtuNherRBAIVsr+MQqkbeAoIkdqOdGfQfTegeUo
	 QdF+qMHzhZWLWr5wIh+q+B3saiUd3hYuKc7bcV4NhftcfbMSiNCCh1QdJ6yoOMLVuD
	 olWv6wI4N+Beg==
Date: Mon, 02 Feb 2026 09:41:14 +0000
To: Donald Hunter <donald.hunter@gmail.com>, Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
From: "Remy D. Farley" <one-d-wide@protonmail.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org, coreteam@netfilter.org, "Remy D. Farley" <one-d-wide@protonmail.com>
Subject: [PATCH net-next v7 5/5] doc/netlink: nftables: Fill out operation attributes
Message-ID: <20260202093928.742879-6-one-d-wide@protonmail.com>
In-Reply-To: <20260202093928.742879-1-one-d-wide@protonmail.com>
References: <20260202093928.742879-1-one-d-wide@protonmail.com>
Feedback-ID: 59017272:user:proton
X-Pm-Message-ID: 08c0c1da51c00866807755c1f583af91e297b096
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
index ced567e7a..5a9d8727a 100644
--- a/Documentation/netlink/specs/nftables.yaml
+++ b/Documentation/netlink/specs/nftables.yaml
@@ -1566,7 +1566,10 @@ operations:
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
@@ -1576,11 +1579,21 @@ operations:
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
@@ -1589,8 +1602,10 @@ operations:
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
@@ -1601,8 +1616,7 @@ operations:
       do:
         request:
           value: 0xa1a
-          attributes:
-            - name
+          attributes: *del-table
     -
       name: newchain
       doc: Create a new chain.
@@ -1612,7 +1626,23 @@ operations:
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
+            - name
+            - counters
+            - policy
+            # Mentioned in nf_tables_addchain()
+            - hook
             - name
+            - counters
+            - userdata
+            # Mentioned in nft_chain_parse_hook()
+            - type
     -
       name: getchain
       doc: Get / dump chains.
@@ -1622,11 +1652,27 @@ operations:
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
@@ -1635,8 +1681,12 @@ operations:
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
@@ -1647,8 +1697,7 @@ operations:
       do:
         request:
           value: 0xa1b
-          attributes:
-            - name
+          attributes: *del-chain
     -
       name: newrule
       doc: Create a new rule.
@@ -1658,7 +1707,16 @@ operations:
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
@@ -1667,12 +1725,30 @@ operations:
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
@@ -1681,12 +1757,15 @@ operations:
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
@@ -1695,8 +1774,11 @@ operations:
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
@@ -1706,8 +1788,7 @@ operations:
       do:
         request:
           value: 0xa1c
-          attributes:
-            - name
+          attributes: *del-rule
     -
       name: newset
       doc: Create a new set.
@@ -1717,7 +1798,24 @@ operations:
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
@@ -1727,11 +1825,35 @@ operations:
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
@@ -1740,7 +1862,10 @@ operations:
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
@@ -1751,8 +1876,7 @@ operations:
       do:
         request:
           value: 0xa1d
-          attributes:
-            - name
+          attributes: *del-set
     -
       name: newsetelem
       doc: Create a new set element.
@@ -1762,7 +1886,11 @@ operations:
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
@@ -1772,11 +1900,27 @@ operations:
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
@@ -1786,11 +1930,20 @@ operations:
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
@@ -1799,8 +1952,11 @@ operations:
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
@@ -1809,8 +1965,7 @@ operations:
       do:
         request:
           value: 0xa1e
-          attributes:
-            - name
+          attributes: *del-setelem
     -
       name: getgen
       doc: Get / dump rule-set generation.
@@ -1819,12 +1974,16 @@ operations:
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
@@ -1834,7 +1993,12 @@ operations:
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
@@ -1844,11 +2008,29 @@ operations:
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
@@ -1858,7 +2040,11 @@ operations:
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
@@ -1868,7 +2054,11 @@ operations:
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
@@ -1878,7 +2068,11 @@ operations:
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
@@ -1888,11 +2082,22 @@ operations:
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
@@ -1901,8 +2106,12 @@ operations:
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
@@ -1911,8 +2120,7 @@ operations:
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


