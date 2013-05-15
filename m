From: Florian Westphal <fw@strlen.de>
Subject: Re: v3.10-rc1 regression notice. (bug #818: NULL pointer
 dereference ipt_log_packet+0x2e/0x2b0)
Date: Wed, 15 May 2013 09:43:59 +0200
Message-ID: <20130515074359.GD18095@breakpoint.cc>
References: <CAF1_xX0ssFWyY8Lvi6z3pSAA4gPUEJXVxrfHhdPPG3hZoMD+dA@mail.gmail.com>
 <1368602693.3169.280.camel@hawk.mlab.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ronald <ronald645@gmail.com>, netfilter-devel@vger.kernel.org,
	gaofeng@cn.fujitsu.com
To: Hans Schillstrom <hans@schillstrom.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:46925 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757000Ab3EOHoG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 May 2013 03:44:06 -0400
Content-Disposition: inline
In-Reply-To: <1368602693.3169.280.camel@hawk.mlab.se>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hans Schillstrom <hans@schillstrom.com> wrote:
> > Since v3.10-rc1 I get kernel panics on two entirely different
> > machines. They seem to be related to netfilter. I posted a bugreport
> > [1], but have not seen any reply.
> 
> a quick look says that both net_device *in and *out is NULL
> Why is another question...

Yes.  Bug added in commit 69b34fb996b2eee3970548cf6eb516d3ecb5eeed
(netfilter: xt_LOG: add net namespace support for xt_LOG)

The oops trace shows we're being invoked from conntrack and not the
ruleset.  Both in and out are NULL in this case.
