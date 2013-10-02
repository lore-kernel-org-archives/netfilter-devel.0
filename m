From: Eric Leblond <eric@regit.org>
Subject: [nftables RFC PATCH]limit netlink message size during delete
 operation
Date: Thu, 03 Oct 2013 01:12:33 +0200
Message-ID: <1380755553.6862.32.camel@tiger2>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: Netfilter Devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:50398 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753104Ab3JBXMf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Oct 2013 19:12:35 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

When working on the flush issue, I've observed that the deletion message
was containing the whole the rule definition. This seems to be useless
as only table, chain and handle number are used to delete a rule.

The following patchset introduces a new function in libnftables to be
able to only put only these identifiers in the deletion message.

BR,
-- 
Eric Leblond <eric@regit.org>
Blog: https://home.regit.org/

