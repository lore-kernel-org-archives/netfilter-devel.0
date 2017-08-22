From: Florian Westphal <fw@strlen.de>
Subject: [PATCH v2 nft 0/3] nftables: tcp option set support
Date: Tue, 22 Aug 2017 15:51:38 +0200
Message-ID: <20170822135141.10785-1-fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:51056 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932523AbdHVNvX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 22 Aug 2017 09:51:23 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This version 2 of the patchset.
The libnftnl patches have been pushed already, so only the
nftables patches remain.

The 'more compact syntax' patch has been dropped.
'rt mss' has been renamed 'rt mtu' (so we don't need a new token).

Let me know if there are any problems.
This version also adds small sections in documentation.

