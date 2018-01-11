From: Florian Westphal <fw@strlen.de>
Subject: [nftables] vmap and bit-sized headers
Date: Thu, 11 Jan 2018 16:30:18 +0100
Message-ID: <20180111153024.25198-1-fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:57482 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751968AbeAKPmd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 11 Jan 2018 10:42:33 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

nftables doesn't support vmap with bit-sized headers, such as flow label or dscp:

nft add rule ip filter input ip dscp vmap \{ 4 : accept, 63 : continue \}
BUG: invalid binary operation 5

Unlike plain 'ip dscp { ..' we do not have a relational operation,
so binop_transfer() is never invoked to fix up the shifts.

I tried to fix this without success, this is the best I could come up with.
Please consider this a bug report only, altough I am resonable sure the
first 2 patches are correct.


