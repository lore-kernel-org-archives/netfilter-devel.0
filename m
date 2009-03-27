From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] iptables: "cluster" match uses IPv6-specific code without
 ifdef
Date: Fri, 27 Mar 2009 13:47:45 +0100
Message-ID: <49CCCAF1.7060405@netfilter.org>
References: <1238100203-23454-1-git-send-email-steven@uplinklabs.net> <49CC9A32.3060303@netfilter.org> <49CC9C62.7080701@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Steven Noonan <steven@uplinklabs.net>,
	linux-kernel@vger.kernel.org,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41991 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756483AbZC0Mrw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 27 Mar 2009 08:47:52 -0400
In-Reply-To: <49CC9C62.7080701@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy wrote:
> Pablo Neira Ayuso wrote:
>> Steven Noonan wrote:
>>> The symbol __ipv6_addr_type is only available with CONFIG_IPV6 or
>>> CONFIG_IPV6_MODULE.
>>
>> Please, CC netfilter-devel for netfilter-related issues. Patrick, I'm
>> fine with this, can you apply this patch?
> 
> Is my reading correct that this won't introduce a module
> dependency on IPv6?

Hm, this fixes a compilation issue when IPv6 is not enabled. In that
case you can still use the cluster match, so I don't see any extra
modules dependencies.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
