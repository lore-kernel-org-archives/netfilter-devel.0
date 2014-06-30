From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2] netfilter: use IS_ENABLED() macro
Date: Mon, 30 Jun 2014 11:43:15 +0200
Message-ID: <20140630094315.GA4604@localhost>
References: <53B0BB24.2060201@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Duan Jiong <duanj.fnst@cn.fujitsu.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38179 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755108AbaF3JnX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 Jun 2014 05:43:23 -0400
Content-Disposition: inline
In-Reply-To: <53B0BB24.2060201@cn.fujitsu.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jun 30, 2014 at 09:19:32AM +0800, Duan Jiong wrote:
> 
> replace:
>  #if defined(CONFIG_NF_CT_NETLINK) || defined(CONFIG_NF_CT_NETLINK_MODULE)
> with
>  #if IS_ENABLED(CONFIG_NF_CT_NETLINK)
> 
> replace:
>  #if !defined(CONFIG_NF_NAT) && !defined(CONFIG_NF_NAT_MODULE)
> with
>  #if !IS_ENABLED(CONFIG_NF_NAT)

Applied.

I have also appended to the patch description this:

    replace:
     #if !defined(CONFIG_NF_CONNTRACK) &&
!defined(CONFIG_NF_CONNTRACK_MODULE)
    with
     #if !IS_ENABLED(CONFIG_NF_CONNTRACK)

And I have squashed this patch:

http://patchwork.ozlabs.org/patch/364781/

I think it was too small for two patches which are really related. And
I also appended this:

    And add missing:
     IS_ENABLED(CONFIG_NF_CT_NETLINK)

    in net/ipv{4,6}/netfilter/nf_nat_l3proto_ipv{4,6}.c

Final patch is here:

http://git.kernel.org/cgit/linux/kernel/git/pablo/nf-next.git/commit/?id=24de3d377539e384621c5b8f8f8d8d01852dddc8

Thanks.
