From: pablo@netfilter.org
Subject: [PATCH 0/2] [RFC] nf_tables: speed up rule addition and deletion
Date: Thu,  1 Nov 2012 17:02:22 +0100
Message-ID: <1351785744-7492-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37643 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964813Ab2KAQCd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 1 Nov 2012 12:02:33 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira Ayuso <pablo@netfilter.org>

Hi!

The following two RFC patches aim to improve rule addition and
deletion timing.

The current major bottleneck in the rule addition is the handle
allocation per chain which is O(n), a simple way to get it O(1)
is to use a 64-bits handle instead of 16-bits to uniquely identify
the rule.

The main concern here is to avoid wrap around of the handle
(so we have no two rules with the same handle). We could stick
to 32-bits. Overrun would happen after 2^32 rule additions, that
seems unlikely but still possible in scenario in which rules
are dynamically added and deleted.

Regarding deletion, as it was documented in the source code,
synchronize_rcu() really make performance suck. The alternative
is to use kfree_rcu() and add one struct rcu_head per rule. This
increases the length of the rule structure.

I didn't come with any better simple solution like these two.

I think this is yet another space-time tradeoff thing. So I'd put
pressure on the memory side at this moment.

Comments welcome.

-- 
1.7.10.4

