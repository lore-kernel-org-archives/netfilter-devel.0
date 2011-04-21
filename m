From: Florian Westphal <fw@strlen.de>
Subject: "xt_conntrack: warn about use in raw table" and lo packets
Date: Thu, 21 Apr 2011 14:51:39 +0200
Message-ID: <20110421125139.GA11260@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Engelhardt <jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:58338 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751298Ab1DUMvl (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 21 Apr 2011 08:51:41 -0400
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The commit a2361c8735e07322023aedc36e4938b35af31eb0
("netfilter: xt_conntrack: warn about use in raw table")
disallows use of -m conntrack in the raw table:
"nfct happens to run after the raw table only".

Thats correct, but when the packet was sent from the local machine the
skb already has ->nfct attached, and -m conntrack seems to do
the right thing.

Is the use of -m conntrack in such a scenario considered invalid?

Thanks,
Florian
