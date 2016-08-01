From: "Anders K. Pedersen" <akp@akp.dk>
Subject: Re: [PATCH nf] netfilter: nft_rbtree: ignore inactive matching
 element with no descendants
Date: Mon, 01 Aug 2016 16:27:38 +0200
Message-ID: <1470061658.1097.5.camel@akp.dk>
References: <1470051523-12223-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: fw@strlen.de
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 85.204.120.79.ip4.gigabit.dk ([85.204.120.79]:45576 "EHLO
	mail.kbh.akp.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752834AbcHAO1o (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Aug 2016 10:27:44 -0400
In-Reply-To: <1470051523-12223-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On man, 2016-08-01 at 13:38 +0200, Pablo Neira Ayuso wrote:
> If we find a matching element that is inactive with no descendants,
> we
> jump to the found label, then crash because of nul-dereference on the
> left branch.
> 
> Fix this by checking that the element is active and not an interval
> end
> and skipping the logic that only applies to the tree iteration.
> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

I applied this on top of Linux 4.7 and verified that it solves the
kernel BUGs, I previously ran into with nftables sets.

Tested-by: Anders K. Pedersen <akp@akp.dk>

Thanks,
Anders K. Pedersen
