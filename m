From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 0/3] [-stable] Netfilter updates for stable 3.6
Date: Tue, 20 Nov 2012 11:34:16 -0800
Message-ID: <20121120193416.GC9496@kroah.com>
References: <1353074550-21456-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
	stable@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:48023 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752284Ab2KTTeT (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 20 Nov 2012 14:34:19 -0500
Received: by mail-pa0-f46.google.com with SMTP id bh2so1483623pad.19
        for <netfilter-devel@vger.kernel.org>; Tue, 20 Nov 2012 11:34:19 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1353074550-21456-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Nov 16, 2012 at 03:02:27PM +0100, pablo@netfilter.org wrote:
> From: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> Hi!
> 
> Please, consider the following Netfilter patches for stable 3.6 and
> onwards inclusion.
> 
> The selected three patches are:
> 
> 2ad5b9e netfilter: xt_TEE: don't use destination address found in header
> bbb5823 netfilter: nf_conntrack: fix rt_gateway checks for H.323 helper

These two now applied to the 3.6-stable tree.

> 0153d5a netfilter: xt_CT: fix timeout setting with IPv6 [REQUIRES: 236df00 netfilter: xt_CT: refactorize xt_ct_tg_check]

This one didn't apply :(

thanks,

greg k-h
