From: Florian Westphal <fw@strlen.de>
Subject: nfqueue max copy_range broken, how to fix/mitigate?
Date: Fri, 17 Aug 2012 11:12:07 +0200
Message-ID: <20120817091207.GA12344@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:33351 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752698Ab2HQJMI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 17 Aug 2012 05:12:08 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.72)
	(envelope-from <fw@strlen.de>)
	id 1T2Ib9-0001YS-6H
	for netfilter-devel@vger.kernel.org; Fri, 17 Aug 2012 11:12:07 +0200
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

nf_queue claims to support copy size of up to 0xffff:

case NFQNL_COPY_PACKET:
        /* we're using struct nlattr which has 16bit nla_len */
        if (range > 0xffff)
               queue->copy_range = 0xffff;

Which is incorrect, as the maximum attribute size is 0xffff - NLA_HDRLEN.
Thus, when trying to queue a maximum-sized IP packet, you get
NFQA_PAYLOAD with nla->len = 4 (due to overflow), i.e. no payload at
all.

Since this is a limitation of netlink this isn't fixable in nfqueue.
How to best handle this situation?

We can either truncate and queue 0xffff - NLA_HDRLEN (i.e., cut off 4
bytes from what will be queued), or we could refuse to queue the packet
(userspace asked for the full packet, but we can't fullfill the
 request).

Any ideas/suggestions?

Thanks,
Florian
