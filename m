From: Eric Leblond <eric@regit.org>
Subject: [nftables RFC PATCH 0/1] implementing icmp code filtering
Date: Mon, 10 Feb 2014 13:33:24 +0100
Message-ID: <1392035605-2889-1-git-send-email-eric@regit.org>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:58851 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752303AbaBJMdr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Feb 2014 07:33:47 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Hello,

I've started to work on completing the reject implementation. I've
got a decent patchset but one specific point in my current work
is not valid for me.

There is multiple ICMP code lists depending on the value of the type. So
the straightforward implementation updating proto_icmp has some issue:

 const struct proto_desc proto_icmp = {
 	.name		= "icmp",
 	.base		= PROTO_BASE_TRANSPORT_HDR,
 	.templates	= {
 		[ICMPHDR_TYPE]		= ICMPHDR_TYPE("type", &icmp_type_type, type),
-		[ICMPHDR_CODE]		= ICMPHDR_FIELD("code", code),
+		[ICMPHDR_CODE]		= ICMPHDR_TYPE("code", &icmp_code_type, code),
 
We have only one icmp_code_type symbo_table possible. For the userspace
to kernel way this is not an issue. As matching on the key name will
lead to a single value. Reverse order is not working as we need to know
the context (here the type) for converting the code to a name.

A possible solution could be to declare a subtype in the symbol_table
that could be used to set the context. For example, we could do
something like:

+static const struct symbol_table icmp_code_tbl = {
+       .symbols        = {
+               SYMBOL_WITH_SUBTYPE("network-unreachable",           ICMP_NET_UNREACH, TYPE_ICMP_CODE_REJECT),

It we set the type to TYPE_ICMP_CODE_REJECT when sending the netlink
message to kernel, then when reading back from kernel we will know
what translation to use.

An alternative approach is to use multiple symbol_table and then create
a structure aggregating the different symbol_table in one object that can
be given as parameters to ICMPHDR_TYPE.

What do you think ? Any better idea ?

BR,
--
Eric
