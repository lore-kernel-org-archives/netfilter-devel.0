From: Greg KH <greg@kroah.com>
Subject: Re: [4.9.y,netfilter] please, cherry-pick da2f27e9e615
Date: Thu, 15 Jun 2017 09:22:15 +0200
Message-ID: <20170615072215.GE25693@kroah.com>
References: <20170612212523.GA12418@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: stable@vger.kernel.org, Juergen Schmidt <abcdmail@freenet.de>,
        netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:37995 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752063AbdFOHWY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 15 Jun 2017 03:22:24 -0400
Content-Disposition: inline
In-Reply-To: <20170612212523.GA12418@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jun 12, 2017 at 11:25:23PM +0200, Pablo Neira Ayuso wrote:
> Resending this, I used the wrong stable email address.
> 
> -o-
> 
> Hi,
> 
> Please, 4.9 stable maintainer, cherry-pick this commit:
> 
> commit da2f27e9e615d1c799c9582b15262458da61fddc
> Author: Christophe Leroy <christophe.leroy@c-s.fr>
> Date:   Wed Mar 1 15:33:26 2017 +0100
> 
>     netfilter: nf_conntrack_sip: fix wrong memory initialisation
> 
> We have a user complaining about this bug that manifests in 4.9:
> 
> http://marc.info/?l=netfilter&m=149577235017072&w=2
> 
> Thanks!

Thanks, now queued up.

greg k-h
