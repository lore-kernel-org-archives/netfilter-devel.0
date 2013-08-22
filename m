From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] nftables: add additional --numeric level
Date: Thu, 22 Aug 2013 13:48:59 +0200
Message-ID: <20130822114859.GA15817@localhost>
References: <20130815232411.GA22555@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Phil Oester <kernel@linuxace.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48089 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753153Ab3HVLtD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 22 Aug 2013 07:49:03 -0400
Content-Disposition: inline
In-Reply-To: <20130815232411.GA22555@linuxace.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Aug 15, 2013 at 04:24:11PM -0700, Phil Oester wrote:
> Personally, I like seeing ports and IPs numerically, but prefer protocols
> to be shown by name.  As such, add a third --numeric level which will
> show protocols by number, splitting them out from ports.
> 
>   -n/--numeric                  When specified once, show network addresses numerically.
>                                 When specified twice, also show Internet services,
>                                 user IDs and group IDs numerically.
>                                 When specified thrice, also show protocols numerically.

Applied, thanks Phil.
