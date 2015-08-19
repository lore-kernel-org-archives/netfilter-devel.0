From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCHv4 nf-next] netfilter: bridge: fix IPv6 packets not being
 bridged with CONFIG_IPV6=n
Date: Wed, 19 Aug 2015 21:22:40 +0200
Message-ID: <20150819192240.GA4625@salvia>
References: <1439449095-21947-1-git-send-email-bernhard.thaler@wvnet.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kadlec@blackhole.kfki.hu, netfilter-devel@vger.kernel.org
To: Bernhard Thaler <bernhard.thaler@wvnet.at>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45323 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750933AbbHSTQa (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 19 Aug 2015 15:16:30 -0400
Content-Disposition: inline
In-Reply-To: <1439449095-21947-1-git-send-email-bernhard.thaler@wvnet.at>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Aug 13, 2015 at 08:58:15AM +0200, Bernhard Thaler wrote:
> 230ac490f7fba introduced a dependency to CONFIG_IPV6 which breaks bridging
> of IPv6 packets on a bridge with CONFIG_IPV6=n.
> 
> Sysctl entry /proc/sys/net/bridge/bridge-nf-call-ip6tables defaults to 1,
> for this reason packets are handled by br_nf_pre_routing_ipv6(). When compiled
> with CONFIG_IPV6=n this function returns NF_DROP but should return NF_ACCEPT
> to let packets through.
> 
> Change CONFIG_IPV6=n br_nf_pre_routing_ipv6() return value to NF_ACCEPT.
> 
> Tested with a simple bridge with two interfaces and IPv6 packets trying
> to pass from host on left side to host on right side of the bridge.
> 
> Fixes: 230ac490f7fba ("netfilter: bridge: split ipv6 code into separated file")

Applied this oneliner to the nf tree, thanks.
