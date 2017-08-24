From: Florian Westphal <fw@strlen.de>
Subject: netfilter fixes for 4.12.y tree
Date: Thu, 24 Aug 2017 15:30:39 +0200
Message-ID: <20170824133039.GC15739@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org
To: stable@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:35802 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751300AbdHXNdO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Aug 2017 09:33:14 -0400
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi stable team,

please consider picking up the following commits for
4.12.y:

36ac344e16e04e3e55e8fed7446095a6458c64e6
netfilter: expect: fix crash when putting uninited expectation

97772bcd56efa21d9d8976db6f205574ea602f51
netfilter: nat: fix src map lookup
(this causes severe issues when lots of nat mappings are active as we
 run out of local source ports).

f55ce7b024090a51382ccab2730b96e2f7b4e9cf
netfilter: nfnetlink: Improve input length sanitization in nfnetlink_rcv

all cherry-pick cleanly.

Thanks,
Florian
