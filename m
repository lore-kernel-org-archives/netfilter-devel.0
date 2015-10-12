From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf 1/3] netfilter: conntrack: fix crash on timeout object
 removal
Date: Mon, 12 Oct 2015 17:08:04 +0200
Message-ID: <20151012150804.GA10474@salvia>
References: <1444056663-5913-1-git-send-email-pablo@netfilter.org>
 <201510052348.MdM5Kc4Y%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kbuild-all@01.org, netfilter-devel@vger.kernel.org,
	stephen@networkplumber.org
To: kbuild test robot <lkp@intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51250 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751041AbbJLPOv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 Oct 2015 11:14:51 -0400
Content-Disposition: inline
In-Reply-To: <201510052348.MdM5Kc4Y%fengguang.wu@intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Oct 05, 2015 at 11:08:57PM +0800, kbuild test robot wrote:
> Hi Pablo,
> 
[...]
> 
> sparse warnings: (new ones prefixed by >>)
> 
> >> net/netfilter/nf_conntrack_core.c:956:54: sparse: incorrect type in argument 2 (different address spaces)
>    net/netfilter/nf_conntrack_core.c:956:54:    expected struct ctnl_timeout *timeout
>    net/netfilter/nf_conntrack_core.c:956:54:    got struct ctnl_timeout [noderef] <asn:4>*timeout
>    net/netfilter/nf_conntrack_core.c:1463:9: sparse: incompatible types in comparison expression (different address spaces)
>    net/netfilter/nf_conntrack_core.c:1468:9: sparse: incompatible types in comparison expression (different address spaces)
>    net/netfilter/nf_conntrack_core.c:1744:9: sparse: incompatible types in comparison expression (different address spaces)
>    net/netfilter/nf_conntrack_core.c:1745:9: sparse: incompatible types in comparison expression (different address spaces)
> 
> vim +956 net/netfilter/nf_conntrack_core.c
[...]
>
> 60b5f8f7 Pablo Neira Ayuso       2012-03-23  955  	if (timeout_ext)
> 60b5f8f7 Pablo Neira Ayuso       2012-03-23 @956  		nf_ct_timeout_ext_add(ct, timeout_ext->timeout, GFP_ATOMIC);

Fixed here through before pushing out this patch:

        nf_ct_timeout_ext_add(ct, rcu_deference(timeout_ext->timeout), GFP_ATOMIC);

I can't see any sparse warning anymore with the change above.

Thanks!
