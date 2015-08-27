From: Florian Westphal <fw@strlen.de>
Subject: nftables batch abi broken ...
Date: Thu, 27 Aug 2015 17:31:51 +0200
Message-ID: <20150827153151.GA17804@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:55915 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751559AbbH0Pbx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 27 Aug 2015 11:31:53 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.80)
	(envelope-from <fw@strlen.de>)
	id 1ZUz9b-0005KL-JZ
	for netfilter-devel@vger.kernel.org; Thu, 27 Aug 2015 17:31:51 +0200
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi.

batch handling in libnftnl uses this:
libnftnl/src/common.c:  nfg->res_id = NFNL_SUBSYS_NFTABLES;

It SHOULD be:
libnftnl/src/common.c:  nfg->res_id = htons(NFNL_SUBSYS_NFTABLES)

since res_id is a __be16.

The kernel contains the same error when decoding batch messages
which is why this works :-/

I found this problem when looking at sparse error reports on the kernel
where sparse complains about the following line in nfnetlink_rcv():

    nfnetlink_rcv_batch(skb, nlh, nfgenmsg->res_id);

and sparse complaint is correct, __be16 is treated as u16 without
conversion.

How to fix this?
If we want to maintain ABI on Little Endian only solution is to "fix"
it in kernel by annotating this with explicit cast to u16.

But it sucks since ->res_id is used via htons/ntohs in all other places
:-/

Any ideas?

Fix userspace and play 'guess todays endianess' in the kernel...?
