From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] Add support to log original and NAT-ed IP addresses
Date: Mon, 20 Apr 2009 11:58:38 +0200
Message-ID: <49EC474E.8090604@netfilter.org>
References: <alpine.DEB.2.00.0904201012170.10463@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50146 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753384AbZDTJ6w (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 20 Apr 2009 05:58:52 -0400
In-Reply-To: <alpine.DEB.2.00.0904201012170.10463@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Jozsef,

Jozsef Kadlecsik wrote:
> Hi,
> 
> Attached you can find patches for netfilter and iptabes to support the 
> logging of the original and NAT-ed IP addresses together.
> 
> Currently there's no way to do it by netfilter/iptables. If we log in the 
> filter table, there we can record the original src IP address only. 
> However, we cannot log the src IP address after NAT at all: SNAT happens 
> in the nat table at POSTROUTING, and there's no other table to which the 
> logging rule could be added (and the NAT targets return ACCEPT, so we 
> cannot add the loggin rule to the nat table either).
> 
> The only way to log src/dst IP before/after NAT presently is to run 
> 'conntrack' in event mode like this:
> 
> 	conntrack -E -e NEW | logger -p kernel.info

We can also do this by means of ulogd2 or, alternatively, conntrackd in
its very basic statistics mode.

> which is a little bit cumbersome and requires the libnfnetlink, 
> libnetfilter_conntrack libraries too.

Yes, this needs some extra user-space software. With regards to logging,
I think that the current policy is to move most of the logics to
user-space, I don't think that overloading iptables with yet another
logging facility is the way to go.

> The attached netfilter patch is questionable/incomplete in the sense that:
> 
> - it adds the POST_ROUTING hook to the raw table and in the IPv4 case 
>   only: but there's no much point to add the hook to IPv6
> - for the sake of completeness the LOCAL_IN hook should be added too, 
>   in order to make possilbe the logging of local SNAT-ed addresses
> - the original src/dst ports could be logged as well: in practice the
>   original src IP address matters only when one wants to hunt down
>   an infected machine on a NATed network

I think that Patrick is not going to like the idea of adding more hooks,
what do you think Patrick?

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
