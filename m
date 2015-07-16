From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCHv2 nf] netfilter: bridge: fix IPv6 packets not being
 bridged with CONFIG_IPV6=n
Date: Thu, 16 Jul 2015 13:17:32 +0200
Message-ID: <20150716111732.GB3920@salvia>
References: <20150715174702.GA7407@salvia>
 <1437006884-11116-1-git-send-email-bernhard.thaler@wvnet.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kadlec@blackhole.kfki.hu, netfilter-devel@vger.kernel.org
To: Bernhard Thaler <bernhard.thaler@wvnet.at>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34018 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750769AbbGPLMI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 16 Jul 2015 07:12:08 -0400
Content-Disposition: inline
In-Reply-To: <1437006884-11116-1-git-send-email-bernhard.thaler@wvnet.at>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jul 16, 2015 at 02:34:44AM +0200, Bernhard Thaler wrote:
[...]
> * checkpatch.pl throws error "ERROR: do not initialise statics to 0 or NULL"
> but left for consistency with similar declarations

I'd appreciate if you can address this in first place, so we don't have
to undo what we've just done for the ip6tables LOCs.

> * dependency to CONFIG_IPV6 instead of CONFIG_IP6_NF_IPTABLES would be more
>   "conservative" approach as br_netfilter_ipv6.o was introduced due to
>   dependencies in br_validate_ipv6() to CONFIG_IPV6; but CONFIG_IP6_NF_IPTABLES
>   will be needed for ip6tables so this dependency may be more "holistic"

I'm fine if you want to restrict this to ip6tables. This may break
out-of-tree modules since they may be relying on these hooks, but we
don't care about those.

I think this s/CONFIG_IPV6/CONFIG_IP6_NF_IPTABLES should come in a
separated patch, just after the one that removes the checkpatch
errors I'd suggest.

> * CONFIG_IP6_NF_IPTABLES=n makes br_validate_ipv6() being imported from
>   br_netfilter.h; it is used in br_netfilter_hooks.c within br_nf_forward_ip()
>   and br_nf_dev_queue_xmit() and returns -1 which will lead to NF_DROP;
>   After defaulting /proc/sys/net/bridge/bridge-nf-call-ip6tables to 0 with
>   CONFIG_IP6_NF_IPTABLES=n these two functions me never see IPV6 packets and 
>   therefore this may not be a problem; I was not able to fully confirm this

It would be great if you can reduce #ifdef pollution. Now that we have
a br_netfilter_ipv6.c file, I think it should be possible to move the
IPv6 specific code there, at least the /proc code chunk.

Could you have a look into this? Thanks!
