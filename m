From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] iptables: "cluster" match uses IPv6-specific code without
 ifdef
Date: Fri, 27 Mar 2009 13:50:16 +0100
Message-ID: <49CCCB88.1070104@trash.net>
References: <1238100203-23454-1-git-send-email-steven@uplinklabs.net> <49CC9A32.3060303@netfilter.org> <49CC9C62.7080701@trash.net> <49CCCAF1.7060405@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Steven Noonan <steven@uplinklabs.net>,
	linux-kernel@vger.kernel.org,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:60946 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751175AbZC0Mu0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 27 Mar 2009 08:50:26 -0400
In-Reply-To: <49CCCAF1.7060405@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> Patrick McHardy wrote:
>> Pablo Neira Ayuso wrote:
>>> Steven Noonan wrote:
>>>> The symbol __ipv6_addr_type is only available with CONFIG_IPV6 or
>>>> CONFIG_IPV6_MODULE.
>>> Please, CC netfilter-devel for netfilter-related issues. Patrick, I'm
>>> fine with this, can you apply this patch?
>> Is my reading correct that this won't introduce a module
>> dependency on IPv6?
> 
> Hm, this fixes a compilation issue when IPv6 is not enabled. In that
> case you can still use the cluster match, so I don't see any extra
> modules dependencies.

That was badly phrased, sorry. The patch of course doesn't change
anything in that regard.

I'm wondering whether we have a (runtime) dependency on the ipv6
module due to the ipv6_addr_type() call. If that's the case, it
would need to be fixed as well.
