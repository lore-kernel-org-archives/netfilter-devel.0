Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4552B1EE038
	for <netfilter-devel@vger.kernel.org>; Wed, 30 Oct 2024 13:33:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730295238; cv=none; b=sGVmBzV+9LWeTGgTNFblpTKHWXRTBFjgAvaDKj38PNBgr8CSCV8IbmvoUxHVVswameQ9MVqx0zX29tQCGsCFYOyTW1x/B/bEax2Vnxjraad7JwEnxJd8cJheInCejpRhuar897nngQHSpW0amFLM7RCFQTAVZ83w7lWOps0oduQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730295238; c=relaxed/simple;
	bh=jHyZk8QfsItIZ1K5H65FKwRL//57QJmGMZs7eduzW1A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=sp4PaY/CYSb088laUMl43EGGON7MpSSaAbNjao5fRkEoAeTFvblJ7ICJ/mnHQQycmn6w5ZIwFBV0V+AH0I44dN5kziNr7Fl8q75RPb4Lcf740Ho0dxI5AZ2MhYnfYjoHAm8BrX6odjo/4s6kqlLCTin0qSub6IgCiJoOILqmFq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1t68pc-0002yA-Qy; Wed, 30 Oct 2024 14:33:52 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft v2] doc: extend description of fib expression
Date: Wed, 30 Oct 2024 14:27:52 +0100
Message-ID: <20241030132756.19532-1-fw@strlen.de>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Describe the input keys and the result types.
Mention which input keys are mandatory and which keys are mutually
exclusive.

Describe which hooks can be used with the various lookup modifiers
and extend the examples with more information on fib expression
capabilities.

Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1663
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 v2: some rewording as per Pablo, esp. iif/oif description.
 Point to nft describe to obtain type list.

 doc/primary-expression.txt | 77 +++++++++++++++++++++++++++++++-------
 1 file changed, 63 insertions(+), 14 deletions(-)

diff --git a/doc/primary-expression.txt b/doc/primary-expression.txt
index 782494bda6f3..c6a33bbe4184 100644
--- a/doc/primary-expression.txt
+++ b/doc/primary-expression.txt
@@ -310,17 +310,48 @@ table inet x {
 FIB EXPRESSIONS
 ~~~~~~~~~~~~~~~
 [verse]
-*fib* {*saddr* | *daddr* | *mark* | *iif* | *oif*} [*.* ...] {*oif* | *oifname* | *type*}
+*fib* 'FIB_TUPLE' 'FIB_RESULT'
+'FIB_TUPLE' := { *saddr* | *daddr*} [ *.* { *iif* | *oif* } *.* *mark* ]
+'FIB_RESULT'  := { *oif* | *oifname* | *type* }
 
-A fib expression queries the fib (forwarding information base) to obtain
-information such as the output interface index a particular address would use.
-The input is a tuple of elements that is used as input to the fib lookup
-functions.
 
-.fib expression specific types
+A fib expression queries the fib (forwarding information base) to obtain information
+such as the output interface index.
+
+The first arguments to the *fib* expression are the input keys to be passed to the fib lookup function.
+One of *saddr* or *daddr* is mandatory, they are also mutually exclusive.
+
+*mark*, *iif* and *oif* keywords are optional modifiers to influence the search result, see
+the *FIB_TUPLE* keyword table below for a description.
+The *iif* and *oif* tuple keywords are also mutually exclusive.
+
+The last argument to the *fib* expression is the desired result type.
+
+*oif* asks to obtain the interface index that would be used to send packets to the packets source
+(*saddr* key) or destination (*daddr* key).  If no routing entry is found, the returned interface
+index is 0.
+
+*oifname* is like *oif*, but it fills the interface name instead.  This is useful to check dynamic
+interfaces such as ppp devices.  If no entry is found, an empty interface name is returned.
+
+*type* returns the address type such as unicast or multicast.  A complete list of supported
+address types can be shown with *nft* *describe* *fib_addrtype*.
+
+.FIB_TUPLE keywords
 [options="header"]
 |==================
-|Keyword| Description| Type
+|flag| Description
+|daddr| Perform a normal route lookup: search fib for route to the *destination address* of the packet.
+|saddr| Perform a reverse route lookup: search the fib for route to the *source address* of the packet.
+|mark | consider the packet mark (nfmark) when querying the fib.
+|iif  | if fib lookups provides a route then check its output interface is identical to the packets *input* interface.
+|oif  | if fib lookups provides a route then check its output interface is identical to the packets *output* interface.  This flag can only be used with the *type* result.
+|=======================
+
+.FIB_RESULT keywords
+[options="header"]
+|==================
+|Keyword| Description| Result Type
 |oif|
 Output interface index|
 integer (32 bit)
@@ -329,25 +360,43 @@ Output interface name|
 string
 |type|
 Address type |
-fib_addrtype
+fib_addrtype (see *nft* *describe* *fib_addrtype* for a list)
 |=======================
 
-Use *nft* *describe* *fib_addrtype* to get a list of all address types.
+The *oif* and *oifname* result is only valid in the *prerouting*, *input* and *forward* hooks.
+The *type* can be queried from any one of *prerouting*, *input*, *forward* *output* and *postrouting*.
+
+For *type*, the presence of the *iif* keyword in the 'FIB_TUPLE' modifiers restrict the available
+hooks to those where the packet is associated with an incoming interface, i.e. *prerouting*, *input* and *forward*.
+Likewise, the *oif* keyword in the 'FIB_TUPLE' modifier list will limit the available hooks to
+*forward*, *output* and *postrouting*.
 
 .Using fib expressions
 ----------------------
 # drop packets without a reverse path
 filter prerouting fib saddr . iif oif missing drop
 
-In this example, 'saddr . iif' looks up routing information based on the source address and the input interface.
-oif picks the output interface index from the routing information.
+In this example, 'saddr . iif' looks up a route to the *source address* of the packet and restricts matching
+results to the interface that the packet arrived on, then stores the output interface index from the obtained
+fib route result.
+
 If no route was found for the source address/input interface combination, the output interface index is zero.
-In case the input interface is specified as part of the input key, the output interface index is always the same as the input interface index or zero.
-If only 'saddr oif' is given, then oif can be any interface index or zero.
+Hence, this rule will drop all packets that do not have a strict reverse path (hypothetical reply packet
+would be sent via the interface the tested packet arrived on).
+
+If only 'saddr oif' is used as the input key, then this rule would only drop packets where the fib cannot
+find a route. In most setups this will never drop packets because the default route is returned.
 
-# drop packets to address not configured on incoming interface
+# drop packets if the destination ip address is not configured on the incoming interface
 filter prerouting fib daddr . iif type != { local, broadcast, multicast } drop
 
+This queries the fib based on the current packets' destination address and the incoming interface.
+
+If the packet is sent to a unicast address that is configured on a different interface, then the packet
+will be dropped as such an address would be classified as 'unicast' type.
+Without the 'iif' modifier, any address configured on the local machine is 'local', and unicast addresses
+not configured on any interface would return the type 'unicast'.
+
 # perform lookup in a specific 'blackhole' table (0xdead, needs ip appropriate ip rule)
 filter prerouting meta mark set 0xdead fib daddr . mark type vmap { blackhole : drop, prohibit : jump prohibited, unreachable : drop }
 ----------------------
-- 
2.45.2

