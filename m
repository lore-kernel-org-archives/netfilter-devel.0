From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 00/25] Conntracking and NAT in netns
Date: Mon, 23 Jun 2008 11:57:56 +0200
Message-ID: <485F73A4.8030108@trash.net>
References: <20080622005916.GA5392@martell.zuzino.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
	den@openvz.org, xemul@openvz.org, ebiederm@xmission.com,
	benjamin.thery@bull.net, dlezcano@fr.ibm.com
To: Alexey Dobriyan <adobriyan@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:43553 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752217AbYFWJ6A (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 Jun 2008 05:58:00 -0400
In-Reply-To: <20080622005916.GA5392@martell.zuzino.mipt.ru>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Alexey Dobriyan wrote:
> Hi, patchbomb below makes significant parts of connection tracking and
> NAT code usable in netns and independent from other netns.
> 
> Status is that it is lightly tested but more or less works, I used it on
> a box which provides NAT for another with all netdevices moved to netns,
> routing and iptables rules set up and rules flushed in init_net.

OK, I assume "Do not apply" applies to all patches then.

> So far so good.
> 
> Weak points:
> a) races during netns destruction or conntrack modules unload
>    (see more in patches)
> b) grabbing netns from skb->dev or skb->dst->dev
>    these places should be checked with extreme scrunity :-\

Will do.

> c) some stuff not converted (pptp, h323) -- it's like 10 minutes to make
>    a patch and full day to setup and test it :^)
> d) IPv6 conntracking wasn't tested.
 >
> e) ordering probably should be redone (or it shouldn't since netfilter
>    is banned in netns as is, so nobody will care)

I think its most important that its bisectable for the non-ns
case. So thats OK.



