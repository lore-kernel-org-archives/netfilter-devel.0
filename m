Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03575285C8A
	for <netfilter-devel@vger.kernel.org>; Wed, 16 Jul 2025 18:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752692053; cv=none; b=u4d+xW2FgfVR78ap+LzGSDMEzJtnU1r5RE0/y9+F4eecrQ7B9M2+WGXzJY5bLvpv12Dp9zA9zd+eZhBtAW07DUi2UiFT/8iTtuM3RPwqNjPppWg/Md6TBXqygD+SqjaTIkfJAisbv0zUSIRWOmI9gWkwNTF17qHxrgTQM/T5mkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752692053; c=relaxed/simple;
	bh=UNI4Yvxo/tCWdfrEpabndUynG1lNCXvmSuzKmPL2JT8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PXo4A6upCGUttwQ6GkSKmjslNasH4IEbCPGbNkID+DbGN4I0rH9snV9gX5Wo4a+TZlrXSElaRtgpN8a20lyXpOrI3ILHOO6SdSB1cDjfk6dmXYGpMkFukg/RA43Pba0V1I+p11b8gcCh87MNmCBw92l553Dj63607jXVxuRN+SE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=B3uqi8N7; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="B3uqi8N7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=3VpvHmUvm+UFs4jmwtR8F5cR/Hgn1s0KOLdHgVBk69E=; b=B3uqi8N7bUxLJcJvKx3Djsf4BA
	M4bB1qrGUQ7FARk0nXp0R2w4aMJufY2qINhBx7sSdY4m1cuh+D1hXi59EcMGKk+l+6y4jWOupz8w4
	XsxJYcWYVG7KKCL+SaWPv+flchva9bsjAqK4sl7OMmBWioDWOcONTDKjjBfrbLR6iRE5dzdhc4cm1
	QYimE+6AY/TKHs47HMDvID25IeSkwybMA7as1FbTbmO3nRAI8b6apiTMgrKKbimGXPN9E6SGaI4zg
	5T2Zdfk3X8J1XHH1R5zaAdTZVs2FiUUL3Y1DIBU2b9GlldSt3dEoYccPvmEx9O4Srd3z4iQZ8O9Ua
	Y5P0Qa7w==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uc7GZ-0000000082K-3zDD;
	Wed, 16 Jul 2025 20:54:08 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org
Subject: [nft PATCH v4 2/3] parser_bison: Accept ASTERISK_STRING in flowtable_expr_member
Date: Wed, 16 Jul 2025 20:54:01 +0200
Message-ID: <20250716185402.32532-3-phil@nwl.cc>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250716185402.32532-1-phil@nwl.cc>
References: <20250716185402.32532-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

All clauses are identical, so instead of adding a third one for
ASTERISK_STRING, use a single one for 'string' (which combines all three
variants).

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Changes since v3:
- Cover interface wildcards in nft.8
---
 doc/nft.txt        | 30 ++++++++++++++++++++++++++----
 src/parser_bison.y | 11 +----------
 2 files changed, 27 insertions(+), 14 deletions(-)

diff --git a/doc/nft.txt b/doc/nft.txt
index 8712981943d78..42cdd38a27b67 100644
--- a/doc/nft.txt
+++ b/doc/nft.txt
@@ -387,13 +387,19 @@ add table inet mytable
 CHAINS
 ------
 [verse]
-{*add* | *create*} *chain* ['family'] 'table' 'chain' [*{ type* 'type' *hook* 'hook' [*device* 'device'] *priority* 'priority' *;* [*policy* 'policy' *;*] [*comment* 'comment' *;*] *}*]
+____
+{*add* | *create*} *chain* ['family'] 'table' 'chain' [*{ type* 'type' *hook* 'hook' ['DEVICE'] *priority* 'priority' *;* [*policy* 'policy' *;*] [*comment* 'comment' *;*] *}*]
 {*delete* | *destroy* | *list* | *flush*} *chain* ['family'] 'table' 'chain'
 *list chains* ['family']
 *delete chain* ['family'] 'table' *handle* 'handle'
 *destroy chain* ['family'] 'table' *handle* 'handle'
 *rename chain* ['family'] 'table' 'chain' 'newname'
 
+'DEVICE' := {*device* 'DEVICE_NAME' | *devices = {* 'DEVICE_LIST' *}*}
+'DEVICE_LIST' := 'DEVICE_NAME' [*,* 'DEVICE_LIST']
+'DEVICE_NAME' := 'string' | 'string'***
+____
+
 Chains are containers for rules. They exist in two kinds, base chains and
 regular chains. A base chain is an entry point for packets from the networking
 stack, a regular chain may be used as jump target and is used for better rule
@@ -436,7 +442,7 @@ Apart from the special cases illustrated above (e.g. *nat* type not supporting
 
 * The netdev family supports merely two combinations, namely *filter* type with
   *ingress* hook and *filter* type with *egress* hook. Base chains in this
-  family also require the *device* parameter to be present since they exist per
+  family also require the 'DEVICE' parameter to be present since they exist per
   interface only.
 * The arp family supports only the *input* and *output* hooks, both in chains of type
   *filter*.
@@ -449,7 +455,13 @@ Apart from the special cases illustrated above (e.g. *nat* type not supporting
 The *device* parameter accepts a network interface name as a string, and is
 required when adding a base chain that filters traffic on the ingress or
 egress hooks. Any ingress or egress chains will only filter traffic from the
-interface specified in the *device* parameter.
+interface specified in the *device* parameter. The same base chain may be used
+for multiple devices by using the *devices* parameter instead.
+
+With newer kernels there is also basic support for wildcards in 'DEVICE_NAME'
+by specifying an asterisk suffix. The chain will apply to all interfaces
+matching the given prefix. Use the *list hooks* command to see the current
+status.
 
 The *priority* parameter accepts a signed integer value or a standard priority
 name which specifies the order in which chains with the same *hook* value are
@@ -763,11 +775,16 @@ per element comment field
 FLOWTABLES
 -----------
 [verse]
-{*add* | *create*} *flowtable* ['family'] 'table' 'flowtable' *{ hook* 'hook' *priority* 'priority' *; devices = {* 'device'[*,* ...] *} ; }*
+____
+{*add* | *create*} *flowtable* ['family'] 'table' 'flowtable' *{ hook* 'hook' *priority* 'priority' *; devices = {* 'DEVICE_LIST' *} ; }*
 *list flowtables* ['family'] ['table']
 {*delete* | *destroy* | *list*} *flowtable* ['family'] 'table' 'flowtable'
 *delete* *flowtable* ['family'] 'table' *handle* 'handle'
 
+'DEVICE_LIST' := 'DEVICE_NAME' [*,* 'DEVICE_LIST']
+'DEVICE_NAME' := 'string' | 'string'***
+____
+
 Flowtables allow you to accelerate packet forwarding in software. Flowtables
 entries are represented through a tuple that is composed of the input interface,
 source and destination address, source and destination port; and layer 3/4
@@ -786,6 +803,11 @@ The *priority* can be a signed integer or *filter* which stands for 0. Addition
 and subtraction can be used to set relative priority, e.g. filter + 5 equals to
 5.
 
+With newer kernels there is basic support for wildcards in 'DEVICE_LIST' by
+specifying an asterisk suffix. The flowtable will apply to all interfaces
+matching the given prefix. Use the *list hooks* command to see the current
+status.
+
 [horizontal]
 *add*:: Add a new flowtable for the given family with the given name.
 *delete*:: Delete the specified flowtable.
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 5b84331f220d3..c31fd05ec09cd 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -2472,16 +2472,7 @@ flowtable_list_expr	:	flowtable_expr_member
 			|	flowtable_list_expr	COMMA	opt_newline
 			;
 
-flowtable_expr_member	:	QUOTED_STRING
-			{
-				struct expr *expr = ifname_expr_alloc(&@$, state->msgs, $1);
-
-				if (!expr)
-					YYERROR;
-
-				$$ = expr;
-			}
-			|	STRING
+flowtable_expr_member	:	string
 			{
 				struct expr *expr = ifname_expr_alloc(&@$, state->msgs, $1);
 
-- 
2.49.0

