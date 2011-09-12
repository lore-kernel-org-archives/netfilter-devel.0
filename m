From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH] Fix repeatable Oops on container destroy with conntrack
Date: Mon, 12 Sep 2011 10:25:24 +0300
Message-ID: <20110912072524.GA2996@p183.telecom.by>
References: <2184C0CE5A5EDC94CDDA5053@Ximines.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
	coreteam@netfilter.org, linux-kernel@vger.kernel.org,
	containers@lists.linux-foundation.org,
	Linux Containers <containers@lists.osdl.org>
To: Alex Bligh <alex@alex.org.uk>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33727 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235Ab1ILHZa (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 Sep 2011 03:25:30 -0400
Content-Disposition: inline
In-Reply-To: <2184C0CE5A5EDC94CDDA5053@Ximines.local>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Sep 10, 2011 at 07:48:43PM +0100, Alex Bligh wrote:
> --- a/net/netfilter/nf_conntrack_netlink.c
> +++ b/net/netfilter/nf_conntrack_netlink.c
> @@ -570,6 +570,11 @@ ctnetlink_conntrack_event(unsigned int events, struct nf_ct_event *item)
>  		return 0;
> 
>  	net = nf_ct_net(ct);
> +
> +	/* container deinit, netlink may have died before death_by_timeout */
> +	if (!net->nfnl)
> +		return 0;
> +
>  	if (!item->report && !nfnetlink_has_listeners(net, group))
>  		return 0;

If this is correct fix, ->nfnl check should be folded into
nfnetlink_has_listeners(), otherwise expectations aren't covered.
