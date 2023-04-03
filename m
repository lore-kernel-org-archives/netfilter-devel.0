Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C2DAC77B60
	for <netfilter-devel@archiver.kernel.org>; Mon,  3 Apr 2023 09:14:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231571AbjDCJOC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 3 Apr 2023 05:14:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231285AbjDCJOB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 3 Apr 2023 05:14:01 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB5424ED5
        for <netfilter-devel@vger.kernel.org>; Mon,  3 Apr 2023 02:13:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680513239; x=1712049239;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=6+SAyrxuNamj1Gz85be/Ibt2hM7RxeSogWrKgGtCiUQ=;
  b=e8h3jwNXpok2JAIRIuvVQqk04OQtnNIPW5+EfUrZed/HpLDidoP0Amoi
   eMx6f9MllgN0Mn6op1aHLPEeWwkCiM7FWa2EBW7le2+gvauoCdgkx8NZt
   qalB6emf2sIbAYQ2lr/m23oo2qkF/XvNqqqcC4eS7kCxO26a5mfj3+H1y
   MTFhjnqq7b2y2dmQMGqD+nPqhVPEIJVoCk+scQRsf/Ch+KllEQzzLaU7s
   VYaRzfkSzHRnUJSraOallL9XWzeVyVe6+ThqgSGV81yTJ5eXvlSms0z08
   YUsKNcUZ5AINZ/H3oukyGZOrNmYA0yhQ2kq+r+eX3PCV6UDVKPWrU4Fw5
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10668"; a="344401042"
X-IronPort-AV: E=Sophos;i="5.98,314,1673942400"; 
   d="scan'208";a="344401042"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2023 02:13:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10668"; a="663136721"
X-IronPort-AV: E=Sophos;i="5.98,314,1673942400"; 
   d="scan'208";a="663136721"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by orsmga006.jf.intel.com with ESMTP; 03 Apr 2023 02:13:57 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pjGGD-000O95-04;
        Mon, 03 Apr 2023 09:13:57 +0000
Date:   Mon, 3 Apr 2023 17:12:57 +0800
From:   kernel test robot <lkp@intel.com>
To:     Fei Cheng <chenwei.0515@bytedance.com>,
        willemdebruijn.kernel@gmail.com, dsahern@kernel.org,
        davem@davemloft.net, netfilter-devel@vger.kernel.org
Cc:     oe-kbuild-all@lists.linux.dev, chenwei.0515@bytedance.com
Subject: Re: [PATCH]     udp:nat:vxlan tx after nat should recsum if vxlan tx
 offload on
Message-ID: <202304031611.3W21vgtb-lkp@intel.com>
References: <20230401023029.967357-1-chenwei.0515@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230401023029.967357-1-chenwei.0515@bytedance.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Fei,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on linus/master]
[also build test WARNING on v6.3-rc5]
[cannot apply to next-20230331]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Fei-Cheng/udp-nat-vxlan-tx-after-nat-should-recsum-if-vxlan-tx-offload-on/20230401-103127
patch link:    https://lore.kernel.org/r/20230401023029.967357-1-chenwei.0515%40bytedance.com
patch subject: [PATCH]     udp:nat:vxlan tx after nat should recsum if vxlan tx offload on
config: microblaze-randconfig-s052-20230402 (https://download.01.org/0day-ci/archive/20230403/202304031611.3W21vgtb-lkp@intel.com/config)
compiler: microblaze-linux-gcc (GCC) 12.1.0
reproduce:
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # apt-get install sparse
        # sparse version: v0.6.4-39-gce1a6720-dirty
        # https://github.com/intel-lab-lkp/linux/commit/58c404cd43734d67706e3dc48c04a3e11e9dd8e8
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Fei-Cheng/udp-nat-vxlan-tx-after-nat-should-recsum-if-vxlan-tx-offload-on/20230401-103127
        git checkout 58c404cd43734d67706e3dc48c04a3e11e9dd8e8
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=microblaze olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=microblaze SHELL=/bin/bash net/netfilter/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202304031611.3W21vgtb-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
>> net/netfilter/nf_nat_proto.c:81:43: sparse: sparse: cast from restricted __be16
>> net/netfilter/nf_nat_proto.c:81:43: sparse: sparse: incorrect type in argument 1 (different base types) @@     expected int len @@     got restricted __be16 [usertype] @@
   net/netfilter/nf_nat_proto.c:81:43: sparse:     expected int len
   net/netfilter/nf_nat_proto.c:81:43: sparse:     got restricted __be16 [usertype]

vim +81 net/netfilter/nf_nat_proto.c

    65	
    66	static bool udp_manip_pkt(struct sk_buff *skb,
    67				  unsigned int iphdroff, unsigned int hdroff,
    68				  const struct nf_conntrack_tuple *tuple,
    69				  enum nf_nat_manip_type maniptype)
    70	{
    71		struct udphdr *hdr;
    72	
    73		if (skb_ensure_writable(skb, hdroff + sizeof(*hdr)))
    74			return false;
    75	
    76		hdr = (struct udphdr *)(skb->data + hdroff);
    77		__udp_manip_pkt(skb, iphdroff, hdr, tuple, maniptype, !!hdr->check);
    78	
    79		if (skb->csum_local) {
    80			hdr->check = 0;
  > 81			hdr->check = udp_v4_check(htons(hdr->len), tuple->src.u3.ip, tuple->dst.u3.ip,
    82						  lco_csum(skb));
    83			if (hdr->check == 0)
    84				hdr->check = CSUM_MANGLED_0;
    85		}
    86	
    87		return true;
    88	}
    89	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
