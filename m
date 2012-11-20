From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 2/3] [-stable] netfilter: xt_CT: fix timeout setting with
 IPv6
Date: Tue, 20 Nov 2012 11:33:54 -0800
Message-ID: <20121120193354.GB9496@kroah.com>
References: <1353074550-21456-1-git-send-email-pablo@netfilter.org>
 <1353074550-21456-3-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
	stable@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50924 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752475Ab2KTTd6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 20 Nov 2012 14:33:58 -0500
Received: by mail-pb0-f46.google.com with SMTP id wy7so4498900pbc.19
        for <netfilter-devel@vger.kernel.org>; Tue, 20 Nov 2012 11:33:57 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1353074550-21456-3-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Nov 16, 2012 at 03:02:29PM +0100, pablo@netfilter.org wrote:
> From: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> This patch fixes ip6tables and the CT target if it is used to set
> some custom conntrack timeout policy for IPv6.
> 
> Use xt_ct_find_proto which already handles the ip6tables case for us.
> 
> [ This patch requires: 236df00 netfilter: xt_CT: refactorize xt_ct_tg_check ]
> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  net/netfilter/xt_CT.c |   10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)

This one doesn't apply to the 3.6-stable tree, care to provide a
backport that works properly?

thanks,

greg k-h
