From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 22/25] netns ct: per-netns nf_conntrack_max
Date: Mon, 23 Jun 2008 12:53:28 +0200
Message-ID: <485F80A8.30200@trash.net>
References: <20080622011923.GX5392@martell.zuzino.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
	den@openvz.org, xemul@openvz.org, ebiederm@xmission.com,
	benjamin.thery@bull.net, dlezcano@fr.ibm.com
To: Alexey Dobriyan <adobriyan@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:45095 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753952AbYFWKxc (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 Jun 2008 06:53:32 -0400
In-Reply-To: <20080622011923.GX5392@martell.zuzino.mipt.ru>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Alexey Dobriyan wrote:
>  struct netns_ct {
> -	atomic_t	count;
> +	atomic_t		count;
> +	int			max;

That only makes real sense if the hash size is also per ns.
