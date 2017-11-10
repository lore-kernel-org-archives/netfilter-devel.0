From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: netfilter patches for stable 4.13
Date: Fri, 10 Nov 2017 12:42:34 +0100
Message-ID: <20171110114234.GA11679@kroah.com>
References: <20171110005556.GA15570@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35806 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752695AbdKJLmY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 10 Nov 2017 06:42:24 -0500
Content-Disposition: inline
In-Reply-To: <20171110005556.GA15570@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Nov 10, 2017 at 01:55:57AM +0100, Pablo Neira Ayuso wrote:
> Hi Greg,
> 
> I'd appreciate if you can cherry-pick these two patches into stable 4.13:
> 
> e1bf1687740c ("netfilter: nat: Revert "netfilter: nat: convert nat bysrc
> hash to rhashtable"")
> 
> 0414c78f1486 ("netfilter: nft_set_hash: disable fast_ops for 2-len keys")

Now queued up, thanks.

greg k-h
