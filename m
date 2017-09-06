From: Florian Westphal <fw@strlen.de>
Subject: Re: nf_nat_cleanup_conntrack performance with rhlist
Date: Wed, 6 Sep 2017 14:39:43 +0200
Message-ID: <20170906123943.GD11551@breakpoint.cc>
References: <CANWdNRCtJreq1xP2sgA=mgV8X15W1Ki-u=Ot3r1eANEVeHKRSA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de, pablo@netfilter.org
To: Ivan Babrou <ibobrik@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:34920 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753989AbdIFMmj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 6 Sep 2017 08:42:39 -0400
Content-Disposition: inline
In-Reply-To: <CANWdNRCtJreq1xP2sgA=mgV8X15W1Ki-u=Ot3r1eANEVeHKRSA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Ivan Babrou <ibobrik@gmail.com> wrote:
> Hello,
> 
> We hit a bug where nf_nat_cleanup_conntrack is taking exponential amount of time
> if you ping a lot of distinct IPs. It seems to be related to hlist ->
> rhlist migration.

Yes, and its best to revert, I sent patches to do just that.

Thanks for the heads-up.
