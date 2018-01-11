From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2] netfilter: nf_tables: delete table via table handle
Date: Thu, 11 Jan 2018 13:39:24 +0100
Message-ID: <20180111123924.fn2tgex2vdzzjbya@salvia>
References: <20180108175818.23100-1-harshasharmaiitr@gmail.com>
 <201801112043.txlnTvJB%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Harsha Sharma <harshasharmaiitr@gmail.com>, kbuild-all@01.org,
        netfilter-devel@vger.kernel.org
To: kbuild test robot <lkp@intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57908 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933184AbeAKMj3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 11 Jan 2018 07:39:29 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 724944DE727
        for <netfilter-devel@vger.kernel.org>; Thu, 11 Jan 2018 13:39:28 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5D15FDA38F
        for <netfilter-devel@vger.kernel.org>; Thu, 11 Jan 2018 13:39:28 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <201801112043.txlnTvJB%fengguang.wu@intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Harsha,

Ignore this, kbuild test robot is getting confused because you have
added table->handle in a separated patch.

On Thu, Jan 11, 2018 at 08:37:13PM +0800, kbuild test robot wrote:
> Hi Harsha,
> 
> Thank you for the patch! Yet something to improve:
> 
> [auto build test ERROR on nf/master]
> [also build test ERROR on v4.15-rc7 next-20180110]
> [cannot apply to nf-next/master]
> [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
> 
> url:    https://github.com/0day-ci/linux/commits/Harsha-Sharma/netfilter-nf_tables-delete-table-via-table-handle/20180111-153748
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git master
> config: x86_64-randconfig-u0-01111920 (attached as .config)
> compiler: gcc-5 (Debian 5.5.0-3) 5.4.1 20171010
> reproduce:
>         # save the attached .config to linux build tree
>         make ARCH=x86_64 
> 
> All errors (new ones prefixed by >>):
> 
>    net//netfilter/nf_tables_api.c: In function '__nft_table_lookup_byhandle':
>    net//netfilter/nf_tables_api.c:375:22: error: 'struct nft_table' has no member named 'handle'
>       if (handle == table->handle &&
>                          ^
>    net//netfilter/nf_tables_api.c: In function 'nf_tables_deltable':
> >> net//netfilter/nf_tables_api.c:890:66: error: 'NFTA_TABLE_HANDLE' undeclared (first use in this function)
>      if (family == AF_UNSPEC || (nla[NFTA_TABLE_NAME] == NULL && nla[NFTA_TABLE_HANDLE] == NULL))
>                                                                      ^
>    net//netfilter/nf_tables_api.c:890:66: note: each undeclared identifier is reported only once for each function it appears in
> 
> vim +/NFTA_TABLE_HANDLE +890 net//netfilter/nf_tables_api.c
> 
>    876	
>    877	static int nf_tables_deltable(struct net *net, struct sock *nlsk,
>    878				      struct sk_buff *skb, const struct nlmsghdr *nlh,
>    879				      const struct nlattr * const nla[],
>    880				      struct netlink_ext_ack *extack)
>    881	{
>    882		const struct nfgenmsg *nfmsg = nlmsg_data(nlh);
>    883		u8 genmask = nft_genmask_next(net);
>    884		struct nft_af_info *afi;
>    885		struct nft_table *table;
>    886		int family = nfmsg->nfgen_family;
>    887		struct nft_ctx ctx;
>    888	
>    889		nft_ctx_init(&ctx, net, skb, nlh, NULL, NULL, NULL, nla);
>  > 890		if (family == AF_UNSPEC || (nla[NFTA_TABLE_NAME] == NULL && nla[NFTA_TABLE_HANDLE] == NULL))
>    891			return nft_flush(&ctx, family);
>    892	
>    893		afi = nf_tables_afinfo_lookup(net, family, false);
>    894		if (IS_ERR(afi))
>    895			return PTR_ERR(afi);
>    896		if (nla[NFTA_TABLE_HANDLE])
>    897			table = nf_tables_table_lookup_byhandle(afi, nla[NFTA_TABLE_HANDLE], genmask);
>    898		else
>    899			table = nf_tables_table_lookup(afi, nla[NFTA_TABLE_NAME], genmask);
>    900	
>    901		if (IS_ERR(table))
>    902			return PTR_ERR(table);
>    903	
>    904		if (nlh->nlmsg_flags & NLM_F_NONREC &&
>    905		    table->use > 0)
>    906			return -EBUSY;
>    907	
>    908		ctx.afi = afi;
>    909		ctx.table = table;
>    910	
>    911		return nft_flush_table(&ctx);
>    912	}
>    913	
> 
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation


