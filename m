From: Michal Kubecek <mkubecek@suse.cz>
Subject: Re: Can we rely on ethernet header padding?
Date: Tue, 19 Mar 2013 16:48:06 +0100
Message-ID: <20130319154806.GB18218@unicorn.suse.cz>
References: <20130319150545.GA18218@unicorn.suse.cz>
 <1363706495.2558.14.camel@edumazet-glaptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45287 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756604Ab3CSPsH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Mar 2013 11:48:07 -0400
Content-Disposition: inline
In-Reply-To: <1363706495.2558.14.camel@edumazet-glaptop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Mar 19, 2013 at 08:21:35AM -0700, Eric Dumazet wrote:
> 
> Normally a driver has NET_SKB_PAD bytes of headroom before the ethernet
> header, so the bridge code is safe only if all drivers use this
> NET_SKB_PAD padding on receive side. And they really should for
> performance reasons.
> 
> Better not touch bridge code to catch offending drivers

That makes sense. Thank you for your reply.

                                                   Michal Kubecek

