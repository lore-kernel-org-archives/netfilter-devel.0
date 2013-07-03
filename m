From: Phil Oester <kernel@linuxace.com>
Subject: Re: [PATCH] netfilter: ip[6]t_REJECT: tcp-reset using wrong MAC
 source if bridged
Date: Wed, 3 Jul 2013 09:59:20 -0700
Message-ID: <20130703165920.GA2500@linuxace.com>
References: <20130626211627.GA22947@gmail.com>
 <20130702234131.GA8412@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:48731 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932471Ab3GCQ7g (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 3 Jul 2013 12:59:36 -0400
Received: by mail-pa0-f50.google.com with SMTP id fb1so430513pad.9
        for <netfilter-devel@vger.kernel.org>; Wed, 03 Jul 2013 09:59:36 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20130702234131.GA8412@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jul 03, 2013 at 01:41:31AM +0200, Pablo Neira Ayuso wrote:
> > +	if (oldskb->nf_bridge) {
> > +		struct ethhdr *oeth = eth_hdr(oldskb);
> > +		nskb->dev = oldskb->nf_bridge->physindev;
> 
> This won't work for locally generated traffic, physindev is null in
> that case.

But nf_bridge is NULL for locally generated traffic, so we won't
even enter this section at all.

Phil
