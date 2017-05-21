From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 0/5] netfilter: conntrack: rework nf_ct_iterate, part 1.
Date: Sun, 21 May 2017 12:52:54 +0200
Message-ID: <20170521105259.10239-1-fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:37096 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751233AbdEUKwr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 21 May 2017 06:52:47 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

First batch of changes to rework how we iterate over the conntrack table.

Historically, we had one table.
When net namespaces were added, we got one table per namespace.
Nowadays we again only have a single table (which considers netns
during lookups).

This series prepares for removal of some open-coded table iteration
places.

It also adds nf_ct_iterate_destroy(), to be used in module exit path
when we need to inspect every conntrack entry regardless of namespace,
then uses it from nat module exit path.

