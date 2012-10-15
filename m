From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] Netfilter/IPVS updates for stable 3.4 onwards
Date: Mon, 15 Oct 2012 16:18:57 -0700
Message-ID: <20121015231857.GA2118@kroah.com>
References: <1349950658-12548-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: stable@vger.kernel.org, netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:36800 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752237Ab2JOXTB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Oct 2012 19:19:01 -0400
Received: by mail-pa0-f46.google.com with SMTP id hz1so5319855pad.19
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Oct 2012 16:19:01 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1349950658-12548-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Oct 11, 2012 at 12:17:35PM +0200, pablo@netfilter.org wrote:
> From: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> Hi!
> 
> The following patchset contain fixes for stable 3.4 onwards.
> 
> The selected three patches are:
> 
> 283283c ipvs: fix oops in ip_vs_dst_event on rmmod
> 66b6aaf netfilter: nf_conntrack: fix racy timer handling with reliable events

Where did this git commit id come from?  It's really
5b423f6a40a0327f9d40bc8b97ce9be266f74368 in Linus's tree.

thanks,

greg k-h
