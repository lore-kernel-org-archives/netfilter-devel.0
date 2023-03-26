Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F44DC6FD1C
	for <netfilter-devel@archiver.kernel.org>; Sun, 26 Mar 2023 04:54:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231862AbjCZEye (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 26 Mar 2023 00:54:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231410AbjCZEyd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 26 Mar 2023 00:54:33 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A6DB1A7
        for <netfilter-devel@vger.kernel.org>; Sat, 25 Mar 2023 21:54:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679806472; x=1711342472;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=goI5FIzzqqXyMlc1zypX0lLLheZbHnfA8Kj2NjXg4io=;
  b=LXivRa0o5ZktbbCC4oJPRQ6FwRm4JXeZi7iL88QF0DU5xwiyr7ZZd+gS
   8NTpdoFNkbuuuzF6hFWRxTB0Qb0ufaSwueTaHZxgtgEtFimhD3rURCtfM
   HVKGCaCZg4y2/X1EkGfZ5bkZp0ounf/ek435I3h1IQPZ1Cc+tNV4aDWVA
   VT2GDFq9HR3ftXj/ZhVR/ZM5l5lSSWRMkODGLTgYYqzGkTM0xcFKuFTaX
   1PG8hta1zJWRnxXAi1ZLh8EZxUC3Uvw0k5sTsFd1EuzkbJTO0fGlL9Plz
   +ZJxDeTU0RgzkH0lL2Puwgrgs4S7BZMAoUiaa8QTUqZH1k6BSEdaOh2tD
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10660"; a="341622491"
X-IronPort-AV: E=Sophos;i="5.98,291,1673942400"; 
   d="scan'208";a="341622491"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2023 21:54:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10660"; a="793913345"
X-IronPort-AV: E=Sophos;i="5.98,291,1673942400"; 
   d="scan'208";a="793913345"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by fmsmga002.fm.intel.com with ESMTP; 25 Mar 2023 21:54:30 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pgIOj-000GtJ-0t;
        Sun, 26 Mar 2023 04:54:29 +0000
Date:   Sun, 26 Mar 2023 12:54:04 +0800
From:   kernel test robot <lkp@intel.com>
To:     Eric Sage <eric_sage@apple.com>, netfilter-devel@vger.kernel.org
Cc:     oe-kbuild-all@lists.linux.dev, fw@strlen.de, kadlec@netfilter.org,
        pablo@netfilter.org, Eric Sage <eric_sage@apple.com>
Subject: Re: [PATCH v4] netfilter: nfnetlink_queue: enable classid socket
 info retrieval
Message-ID: <202303261230.0O0Nxzgo-lkp@intel.com>
References: <20230326022449.92668-1-eric_sage@apple.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230326022449.92668-1-eric_sage@apple.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Eric,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on horms-ipvs/master]
[also build test ERROR on linus/master v6.3-rc3 next-20230324]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Eric-Sage/netfilter-nfnetlink_queue-enable-classid-socket-info-retrieval/20230326-102636
base:   https://git.kernel.org/pub/scm/linux/kernel/git/horms/ipvs.git master
patch link:    https://lore.kernel.org/r/20230326022449.92668-1-eric_sage%40apple.com
patch subject: [PATCH v4] netfilter: nfnetlink_queue: enable classid socket info retrieval
config: m68k-defconfig (https://download.01.org/0day-ci/archive/20230326/202303261230.0O0Nxzgo-lkp@intel.com/config)
compiler: m68k-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/fea5f85f8e567b36d6ec0091654a910e282bac4e
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Eric-Sage/netfilter-nfnetlink_queue-enable-classid-socket-info-retrieval/20230326-102636
        git checkout fea5f85f8e567b36d6ec0091654a910e282bac4e
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=m68k olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=m68k SHELL=/bin/bash net/netfilter/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202303261230.0O0Nxzgo-lkp@intel.com/

All errors (new ones prefixed by >>):

   net/netfilter/nfnetlink_queue.c: In function 'nfqnl_build_packet_message':
>> net/netfilter/nfnetlink_queue.c:423:56: error: expected ';' before 'tstamp'
     423 |                 + nla_total_size(sizeof(u_int32_t))     /* cap_len */
         |                                                    ^~~~~
         |                                                        ;
   ......
     428 |         tstamp = skb_tstamp_cond(entskb, false);
         |         ~~~~~~                                      


vim +423 net/netfilter/nfnetlink_queue.c

   387	
   388	static struct sk_buff *
   389	nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
   390				   struct nf_queue_entry *entry,
   391				   __be32 **packet_id_ptr)
   392	{
   393		size_t size;
   394		size_t data_len = 0, cap_len = 0;
   395		unsigned int hlen = 0;
   396		struct sk_buff *skb;
   397		struct nlattr *nla;
   398		struct nfqnl_msg_packet_hdr *pmsg;
   399		struct nlmsghdr *nlh;
   400		struct sk_buff *entskb = entry->skb;
   401		struct net_device *indev;
   402		struct net_device *outdev;
   403		struct nf_conn *ct = NULL;
   404		enum ip_conntrack_info ctinfo = 0;
   405		const struct nfnl_ct_hook *nfnl_ct;
   406		bool csum_verify;
   407		char *secdata = NULL;
   408		u32 seclen = 0;
   409		ktime_t tstamp;
   410	
   411		size = nlmsg_total_size(sizeof(struct nfgenmsg))
   412			+ nla_total_size(sizeof(struct nfqnl_msg_packet_hdr))
   413			+ nla_total_size(sizeof(u_int32_t))	/* ifindex */
   414			+ nla_total_size(sizeof(u_int32_t))	/* ifindex */
   415	#if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
   416			+ nla_total_size(sizeof(u_int32_t))	/* ifindex */
   417			+ nla_total_size(sizeof(u_int32_t))	/* ifindex */
   418	#endif
   419			+ nla_total_size(sizeof(u_int32_t))	/* mark */
   420			+ nla_total_size(sizeof(u_int32_t))	/* priority */
   421			+ nla_total_size(sizeof(struct nfqnl_msg_packet_hw))
   422			+ nla_total_size(sizeof(u_int32_t))	/* skbinfo */
 > 423			+ nla_total_size(sizeof(u_int32_t))	/* cap_len */
   424	#if IS_ENABLED(CONFIG_CGROUP_NET_CLASSID)
   425			+ nla_total_size(sizeof(u_int32_t));	/* classid */
   426	#endif
   427	
   428		tstamp = skb_tstamp_cond(entskb, false);
   429		if (tstamp)
   430			size += nla_total_size(sizeof(struct nfqnl_msg_packet_timestamp));
   431	
   432		size += nfqnl_get_bridge_size(entry);
   433	
   434		if (entry->state.hook <= NF_INET_FORWARD ||
   435		   (entry->state.hook == NF_INET_POST_ROUTING && entskb->sk == NULL))
   436			csum_verify = !skb_csum_unnecessary(entskb);
   437		else
   438			csum_verify = false;
   439	
   440		outdev = entry->state.out;
   441	
   442		switch ((enum nfqnl_config_mode)READ_ONCE(queue->copy_mode)) {
   443		case NFQNL_COPY_META:
   444		case NFQNL_COPY_NONE:
   445			break;
   446	
   447		case NFQNL_COPY_PACKET:
   448			if (!(queue->flags & NFQA_CFG_F_GSO) &&
   449			    entskb->ip_summed == CHECKSUM_PARTIAL &&
   450			    skb_checksum_help(entskb))
   451				return NULL;
   452	
   453			data_len = READ_ONCE(queue->copy_range);
   454			if (data_len > entskb->len)
   455				data_len = entskb->len;
   456	
   457			hlen = skb_zerocopy_headlen(entskb);
   458			hlen = min_t(unsigned int, hlen, data_len);
   459			size += sizeof(struct nlattr) + hlen;
   460			cap_len = entskb->len;
   461			break;
   462		}
   463	
   464		nfnl_ct = rcu_dereference(nfnl_ct_hook);
   465	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
