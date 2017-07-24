From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [4.4.y,netfilter/ipvs] please, apply 3c5ab3f395d6
Date: Mon, 24 Jul 2017 16:36:15 -0700
Message-ID: <20170724233615.GB4315@kroah.com>
References: <20170724095940.GA3853@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: stable@vger.kernel.org, Julian Anastasov <ja@ssi.bg>,
        netfilter-devel@vger.kernel.org, Simon Horman <horms@verge.net.au>,
        lvs-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52968 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753593AbdGXXgW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 24 Jul 2017 19:36:22 -0400
Content-Disposition: inline
In-Reply-To: <20170724095940.GA3853@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jul 24, 2017 at 11:59:40AM +0200, Pablo Neira Ayuso wrote:
> Hi Greg,
> 
> Please, apply this commit:
> 
> commit 3c5ab3f395d66a9e4e937fcfdf6ebc63894f028b
> Author: Julian Anastasov <ja@ssi.bg>
> Date:   Sat Apr 29 20:33:09 2017 +0300
> 
>     ipvs: SNAT packet replies only for NATed connections
> 
> to stable 4.4.y.
> 
> Julian made a backport for you, in case cherry-pick doesn't work, that
> is available at Netfilter's patchwork:
> 
>         http://patchwork.ozlabs.org/patch/789260/

Thanks for that, I've also applied the original to the 4.9-stable tree.

greg k-h
