From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 0/3] [-stable] Netfilter updates for stable 3.0 onwards
Date: Tue, 20 Nov 2012 11:31:46 -0800
Message-ID: <20121120193146.GA9496@kroah.com>
References: <1353074415-21379-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
	stable@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:58792 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752153Ab2KTTbv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 20 Nov 2012 14:31:51 -0500
Received: by mail-pa0-f46.google.com with SMTP id bh2so1482215pad.19
        for <netfilter-devel@vger.kernel.org>; Tue, 20 Nov 2012 11:31:50 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1353074415-21379-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Nov 16, 2012 at 03:00:11PM +0100, pablo@netfilter.org wrote:
> From: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> Hi!
> 
> Please, consider the following Netfilter patches for stable 3.0 and
> onwards inclusion.
> 
> The selected three patches are:
> 
> 4a70bbf netfilter: Validate the sequence number of dataless ACK packets as well
> 64f509c netfilter: Mark SYN/ACK packets as invalid from original direction
> [BACKPORT] 38fe36a netfilter: nf_nat: don't check for port change on ICMP tuples
> 
> The first two patches can be considered security fixes in the TCP connection
> tracking to make harder off-path attacks. For more information you can read:
> "Reflection scan: an Off-Path Attack on TCP" by Jan Wrobel.
> 
> The latter fixes the re-routing of every ICMP packet going through NAT even
> if it is not required, which is an expensive operation. That one has been
> backported to 3.0.
> 
> Please, cherry-pick them. Thanks!

All applied, thanks.

greg k-h
