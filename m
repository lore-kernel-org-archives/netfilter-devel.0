From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 0/3] netfilter: remove per-netns conntrack tables, part 2
Date: Fri,  6 May 2016 00:51:46 +0200
Message-ID: <1462488709-13031-1-git-send-email-fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:55662 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755589AbcEEWmo (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 5 May 2016 18:42:44 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.84_2)
	(envelope-from <fw@breakpoint.cc>)
	id 1ayRyj-0001yF-QX
	for netfilter-devel@vger.kernel.org; Fri, 06 May 2016 00:42:41 +0200
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This series removes the per-namespace duplication of the expectation table.
We use one table for all namespaces, using net_hash_mix(net) as additional
hash seed so entries are spread evenly even if addresses overlap.

The max limit was already global, even before this patch.
couting is still done per namespace.

