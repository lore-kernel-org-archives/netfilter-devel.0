From: Phil Sutter <phil@nwl.cc>
Subject: Re: [nft PATCH RFC 0/4] Implement --echo option
Date: Thu, 27 Jul 2017 17:02:52 +0200
Message-ID: <20170727150252.GR2235@orbyte.nwl.cc>
References: <20170727142622.12029-1-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:58129 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750836AbdG0PCx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 27 Jul 2017 11:02:53 -0400
Content-Disposition: inline
In-Reply-To: <20170727142622.12029-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jul 27, 2017 at 04:26:18PM +0200, Phil Sutter wrote:
> Long description of what it is and how it works in patch 3. Patches 1
> and 2 are dependencies to patch 3.
> 
> The whole thing is RFC, mainly because of NFT_MSG_META_ECHO which
> doesn't quite belong to where it is but I didn't find a better way to
> reuse monitor callbacks for the job at hand.
> 
> Feedback highly appreciated, of course!

Crap! I just found some unstaged changes in my tree which belong to this
series. Will send a v2 soon. Sorry for the mess.

Cheers, Phil
