From: Florian Westphal <fw@strlen.de>
Subject: ctnetlink: remove remaining module refcount usage
Date: Wed, 18 Mar 2009 16:42:01 +0100
Message-ID: <1237390923-3122-1-git-send-email-fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:53677 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751300AbZCRPmL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 18 Mar 2009 11:42:11 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello list,

The following (small) patch converts the remaining module refcounting
in conntrack_netlink to RCU.

First patch does the conversion, 2nd one removes
nf_ct_l4proto_find_get/put (there are no more in-tree users).

Thanks, Florian
