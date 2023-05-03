Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 749ADC77B7F
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 May 2023 15:41:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229530AbjECPl0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 3 May 2023 11:41:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229626AbjECPlZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 3 May 2023 11:41:25 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DE9D1997
        for <netfilter-devel@vger.kernel.org>; Wed,  3 May 2023 08:41:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683128484; x=1714664484;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=9HA1S84wZNk6GkRlQO3x/m2Oi6FiXO4dgjR6rmy9XR4=;
  b=YtHDamwFZ083Jl14mUBIrEkX6P7RtaUtrdhPR0jY3EZKeJ3rZzK29mzF
   RTP7wulAjmcTjJeK/39wwv5Kh8pATxiqO9shc8viRUaCrP/a6FY26P2M3
   0C/ap0TBNpXAd5BcV2TF1z0yAsMjmFdXZDtCCCGyaoPSgoFP4s1ZCZGIG
   2wLPRFASrikS/Lj6F6IrNZampIIoweUCTchdde/yU/jrC5EZvQOs0BO4V
   kYcOJYNG0LQPQKYHCDZqfbpGvC+AEAnK/g3cmhqKkU5735DRX/04vB1uU
   16cjfhZ/4a4pQrfnNfc0sL+sZ9qDp6mgd2S1zWWrp60nR4Zq1kBFae9lg
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10699"; a="337821054"
X-IronPort-AV: E=Sophos;i="5.99,247,1677571200"; 
   d="scan'208";a="337821054"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 May 2023 08:41:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10699"; a="840721880"
X-IronPort-AV: E=Sophos;i="5.99,247,1677571200"; 
   d="scan'208";a="840721880"
Received: from lkp-server01.sh.intel.com (HELO e3434d64424d) ([10.239.97.150])
  by fmsmga001.fm.intel.com with ESMTP; 03 May 2023 08:41:22 -0700
Received: from kbuild by e3434d64424d with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1puEbZ-00026q-1R;
        Wed, 03 May 2023 15:41:21 +0000
Date:   Wed, 3 May 2023 23:41:01 +0800
From:   kernel test robot <lkp@intel.com>
To:     Boris Sukholitko <boris.sukholitko@broadcom.com>,
        netfilter-devel@vger.kernel.org
Cc:     oe-kbuild-all@lists.linux.dev,
        Ilya Lifshits <ilya.lifshits@broadcom.com>,
        Boris Sukholitko <boris.sukholitko@broadcom.com>
Subject: Re: [PATCH nf-next 16/19] netfilter: nftables: fast path payload
 mangle
Message-ID: <202305032310.WgPNAhx8-lkp@intel.com>
References: <20230503125552.41113-17-boris.sukholitko@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230503125552.41113-17-boris.sukholitko@broadcom.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Boris,

kernel test robot noticed the following build warnings:

[auto build test WARNING on shuah-kselftest/next]
[also build test WARNING on shuah-kselftest/fixes linus/master v6.3 next-20230428]
[cannot apply to nf-next/master]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Boris-Sukholitko/selftest-netfilter-use-proc-for-pid-checking/20230503-205838
base:   https://git.kernel.org/pub/scm/linux/kernel/git/shuah/linux-kselftest.git next
patch link:    https://lore.kernel.org/r/20230503125552.41113-17-boris.sukholitko%40broadcom.com
patch subject: [PATCH nf-next 16/19] netfilter: nftables: fast path payload mangle
config: m68k-allyesconfig (https://download.01.org/0day-ci/archive/20230503/202305032310.WgPNAhx8-lkp@intel.com/config)
compiler: m68k-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/35886376721f375b56fd9b99c079298c8e027a26
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Boris-Sukholitko/selftest-netfilter-use-proc-for-pid-checking/20230503-205838
        git checkout 35886376721f375b56fd9b99c079298c8e027a26
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=m68k olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=m68k SHELL=/bin/bash net/netfilter/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202305032310.WgPNAhx8-lkp@intel.com/

All warnings (new ones prefixed by >>):

   net/netfilter/nf_flow_table_ip.c: In function 'nf_flow_offload_ip_hook':
>> net/netfilter/nf_flow_table_ip.c:395:58: warning: implicit conversion from 'enum flow_offload_tuple_dir' to 'enum ip_conntrack_dir' [-Wenum-conversion]
     395 |         if (nf_flow_offload_apply_payload(skb, flow->ct, dir, thoff))
         |                                                          ^~~


vim +395 net/netfilter/nf_flow_table_ip.c

   339	
   340	unsigned int
   341	nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
   342				const struct nf_hook_state *state)
   343	{
   344		struct flow_offload_tuple_rhash *tuplehash;
   345		struct nf_flowtable *flow_table = priv;
   346		struct flow_offload_tuple tuple = {};
   347		enum flow_offload_tuple_dir dir;
   348		struct flow_offload *flow;
   349		struct net_device *outdev;
   350		u32 hdrsize, offset = 0;
   351		unsigned int thoff, mtu;
   352		struct rtable *rt;
   353		struct iphdr *iph;
   354		__be32 nexthop;
   355		int ret;
   356	
   357		if (skb->protocol != htons(ETH_P_IP) &&
   358		    !nf_flow_skb_encap_protocol(skb, htons(ETH_P_IP), &offset))
   359			return NF_ACCEPT;
   360	
   361		if (nf_flow_tuple_ip(skb, state->in, &tuple, &hdrsize, offset) < 0)
   362			return NF_ACCEPT;
   363	
   364		tuplehash = flow_offload_lookup(flow_table, &tuple);
   365		if (tuplehash == NULL)
   366			return NF_ACCEPT;
   367	
   368		dir = tuplehash->tuple.dir;
   369		flow = container_of(tuplehash, struct flow_offload, tuplehash[dir]);
   370	
   371		mtu = flow->tuplehash[dir].tuple.mtu + offset;
   372		if (unlikely(nf_flow_exceeds_mtu(skb, mtu)))
   373			return NF_ACCEPT;
   374	
   375		iph = (struct iphdr *)(skb_network_header(skb) + offset);
   376		thoff = (iph->ihl * 4) + offset;
   377		if (nf_flow_state_check(flow, iph->protocol, skb, thoff))
   378			return NF_ACCEPT;
   379	
   380		if (!nf_flow_dst_check(&tuplehash->tuple)) {
   381			flow_offload_teardown(flow);
   382			return NF_ACCEPT;
   383		}
   384	
   385		if (skb_try_make_writable(skb, thoff + hdrsize))
   386			return NF_DROP;
   387	
   388		flow_offload_refresh(flow_table, flow);
   389	
   390		nf_flow_encap_pop(skb, tuplehash);
   391		thoff -= offset;
   392	
   393		iph = ip_hdr(skb);
   394		nf_flow_nat_ip(flow, skb, thoff, dir, iph);
 > 395		if (nf_flow_offload_apply_payload(skb, flow->ct, dir, thoff))
   396			return NF_DROP;
   397	
   398		ip_decrease_ttl(iph);
   399		skb_clear_tstamp(skb);
   400	
   401		if (flow_table->flags & NF_FLOWTABLE_COUNTER)
   402			nf_ct_acct_update(flow->ct, tuplehash->tuple.dir, skb->len);
   403	
   404		if (unlikely(tuplehash->tuple.xmit_type == FLOW_OFFLOAD_XMIT_XFRM)) {
   405			rt = (struct rtable *)tuplehash->tuple.dst_cache;
   406			memset(skb->cb, 0, sizeof(struct inet_skb_parm));
   407			IPCB(skb)->iif = skb->dev->ifindex;
   408			IPCB(skb)->flags = IPSKB_FORWARDED;
   409			return nf_flow_xmit_xfrm(skb, state, &rt->dst);
   410		}
   411	
   412		switch (tuplehash->tuple.xmit_type) {
   413		case FLOW_OFFLOAD_XMIT_NEIGH:
   414			rt = (struct rtable *)tuplehash->tuple.dst_cache;
   415			outdev = rt->dst.dev;
   416			skb->dev = outdev;
   417			nexthop = rt_nexthop(rt, flow->tuplehash[!dir].tuple.src_v4.s_addr);
   418			skb_dst_set_noref(skb, &rt->dst);
   419			neigh_xmit(NEIGH_ARP_TABLE, outdev, &nexthop, skb);
   420			ret = NF_STOLEN;
   421			break;
   422		case FLOW_OFFLOAD_XMIT_DIRECT:
   423			ret = nf_flow_queue_xmit(state->net, skb, tuplehash, ETH_P_IP);
   424			if (ret == NF_DROP)
   425				flow_offload_teardown(flow);
   426			break;
   427		default:
   428			WARN_ON_ONCE(1);
   429			ret = NF_DROP;
   430			break;
   431		}
   432	
   433		return ret;
   434	}
   435	EXPORT_SYMBOL_GPL(nf_flow_offload_ip_hook);
   436	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
