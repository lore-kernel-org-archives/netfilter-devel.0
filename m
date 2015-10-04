From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next,v2] netfilter: ctnetlink: remove function inline
 declaration
Date: Sun, 4 Oct 2015 21:39:22 +0200
Message-ID: <20151004193922.GA2213@salvia>
References: <1443986000-18068-1-git-send-email-pablo@netfilter.org>
 <201510050340.pagDNZBc%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kbuild-all@01.org, netfilter-devel@vger.kernel.org
To: kbuild test robot <lkp@intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45351 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751518AbbJDTc0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 4 Oct 2015 15:32:26 -0400
Content-Disposition: inline
In-Reply-To: <201510050340.pagDNZBc%fengguang.wu@intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Oct 05, 2015 at 03:18:04AM +0800, kbuild test robot wrote:
> Hi Pablo,
> 
> [auto build test results on v4.3-rc4 -- if it's inappropriate base, please ignore]
> 
> config: i386-defconfig (attached as .config)
> reproduce:
>         # save the attached .config to linux build tree
>         make ARCH=i386 
> 
> All warnings (new ones prefixed by >>):
> 
> >> net/netfilter/nf_conntrack_netlink.c:529:15: warning: 'ctnetlink_proto_size' defined but not used [-Wunused-function]
>     static size_t ctnetlink_proto_size(const struct nf_conn *ct)
>                   ^
> >> net/netfilter/nf_conntrack_netlink.c:546:15: warning: 'ctnetlink_acct_size' defined but not used [-Wunused-function]
>     static size_t ctnetlink_acct_size(const struct nf_conn *ct)
>                   ^
> >> net/netfilter/nf_conntrack_netlink.c:556:12: warning: 'ctnetlink_secctx_size' defined but not used [-Wunused-function]
>     static int ctnetlink_secctx_size(const struct nf_conn *ct)
>                ^
> >> net/netfilter/nf_conntrack_netlink.c:572:15: warning: 'ctnetlink_timestamp_size' defined but not used [-Wunused-function]
>     static size_t ctnetlink_timestamp_size(const struct nf_conn *ct)
>                   ^
> 
> vim +/ctnetlink_proto_size +529 net/netfilter/nf_conntrack_netlink.c
> 
>    523	nlmsg_failure:
>    524	nla_put_failure:
>    525		nlmsg_cancel(skb, nlh);
>    526		return -1;
>    527	}
>    528	
>  > 529	static size_t ctnetlink_proto_size(const struct nf_conn *ct)

Argh.

I'm going to stop and give a closer look to this. Sorry.

