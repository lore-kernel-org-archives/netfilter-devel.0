From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] netfilter: conntrack: add support for flextuples
Date: Thu, 7 May 2015 20:10:24 +0200
Message-ID: <20150507181004.GA3470@salvia>
References: <776b8819c85c83088478b933a35691133055347a.1430733932.git.daniel@iogearbox.net>
 <20150504103451.GA12200@salvia>
 <55475F13.1000304@iogearbox.net>
 <20150504130828.GA3607@salvia>
 <20150504134733.GB1405@pox.localdomain>
 <20150506142741.GA3547@salvia>
 <554A56CA.4040101@iogearbox.net>
 <20150506185040.GA14459@salvia>
 <554B5407.1060203@iogearbox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Thomas Graf <tgraf@suug.ch>, netfilter-devel@vger.kernel.org,
	Madhu Challa <challa@noironetworks.com>
To: Daniel Borkmann <daniel@iogearbox.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40695 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751068AbbEGSF4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 7 May 2015 14:05:56 -0400
Content-Disposition: inline
In-Reply-To: <554B5407.1060203@iogearbox.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Daniel,

On Thu, May 07, 2015 at 02:01:11PM +0200, Daniel Borkmann wrote:
> ...
> >>>Another question is if it makes sense to have part of the flows using
> >>>your flextuple idea while some others not, ie.
> >>>
> >>>         -s x.y.z.w/24 -j CT --flextuple original
> >>>
> >>>so shouldn't this be a global switch that includes the skb->mark
> >>>only for packets coming in the original direction?
> >>
> >>I first thought about a global sysctl switch, but eventually found
> >>this config possibility from iptables side much cleaner resp. better
> >>integrated. I think if the environment is correctly configured for
> >>that, such a partial flextuple scenario works, too.
> >
> >This is consuming two ct status bits, these are exposed to userspace,
> >and we have a limited number of bits there. The one in the original
> >direction might be justified for the SNAT case in the specific
> >scenario that you show.
> 
> Okay, agreed. I will respin the set with --flextuple ORIGINAL direction
> allowed where we'd for now only consume a single status bit. If later
> on there's a need to extend this for REPLY (or even hybrid), we still
> have the option to extend it.

I would like to know if it makes sense to add this later on. Would you
elaborate a useful DNAT scenario where this can be useful?

Thanks.
