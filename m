Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FA5D22D7B1
	for <netfilter-devel@vger.kernel.org>; Mon, 28 Jul 2025 07:17:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753687054; cv=none; b=ZWxhIRVpJhaj8UZGsxpbVIOytx4TYVa1up9Wu+b6hVOttLZrydF7qXU/gA2OHicy6kKWA/1t3iCvT02r/I5SPThO8W80bpzgGmdriKt6UgwO5dyESKJby5Yqq9EgvXQOcey6oV6qsr1uV8B89ADDCk5YjVo66HtX2Ikkfd78yTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753687054; c=relaxed/simple;
	bh=FI8rHfaFKuwN+SfXXor/B3kscyjTORxXZ54WjeZWqEw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Wmgo20wqIh+4z9JniXciTVSxoURA6Qeju1y1JdtEEA+XK9/bYdwdVZIgUQXrFyZK7SDtIm5pFT66QpikX+b0j8m39FNvPKa7gFdj3bWOa6UDkXXZ7uNjmaXoHOGOHIDNpNy0RF5AX0GPeio45Ofxody0V1UNCVVVkN3L9Jedg/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Bgu/Hmh3; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Bgu/Hmh3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753687052; x=1785223052;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=FI8rHfaFKuwN+SfXXor/B3kscyjTORxXZ54WjeZWqEw=;
  b=Bgu/Hmh3CDc0Dt85GCxJSgJKK0Z+THavePoIOjLomfiqbZTIt0W3yZGm
   Fk67KJ6DTcAcak+Vw9PytqfqI0igLTRSB/GukGtcnsLPm6EG/lOgwG41d
   yeQDMhlqtZ5n4UcM2ZipQx/Tp4fVhr0UeMXX3E36iqLrcvRUYLDssu429
   k0NYLa5M8pFMEiWZf76oVmorrdRgHouNSPv7scCgwk47DF+4e3R8J9Z0X
   oGSWBXacjS3lWhI4ftuFB+zc6VfUV2UMExHusDzj/+WefR4Zo3KwkZFaU
   0R03jQUbwQHet2ffbTiqCz6soLBNSkJd0ZSWWha0A14q2Dm4hmiUgpDzX
   w==;
X-CSE-ConnectionGUID: eNCJI1HXRimugz97USor/w==
X-CSE-MsgGUID: tV7kFnQkSRCCbuEUjW1tHQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11504"; a="81372878"
X-IronPort-AV: E=Sophos;i="6.16,339,1744095600"; 
   d="scan'208";a="81372878"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jul 2025 00:17:32 -0700
X-CSE-ConnectionGUID: Y3m4DNQeTWupRqRDmqZYaA==
X-CSE-MsgGUID: Z7N+HkB7Tpev1VQOovkcgw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,339,1744095600"; 
   d="scan'208";a="166820928"
Received: from lkp-server01.sh.intel.com (HELO 160750d4a34c) ([10.239.97.150])
  by orviesa004.jf.intel.com with ESMTP; 28 Jul 2025 00:17:29 -0700
Received: from kbuild by 160750d4a34c with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1ugI6x-0000I7-1P;
	Mon, 28 Jul 2025 07:17:27 +0000
Date: Mon, 28 Jul 2025 15:17:18 +0800
From: kernel test robot <lkp@intel.com>
To: Shaun Brady <brady.1345@gmail.com>, netfilter-devel@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, ppwaskie@kernel.org, fw@strlen.de,
	pablo@netfilter.org
Subject: Re: [PATCH v6 1/2] netfilter: nf_tables: Implement jump limit for
 nft_table_validate
Message-ID: <202507281408.4TSYx6Hl-lkp@intel.com>
References: <20250728040315.1014454-1-brady.1345@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250728040315.1014454-1-brady.1345@gmail.com>

Hi Shaun,

kernel test robot noticed the following build warnings:

[auto build test WARNING on netfilter-nf/main]
[also build test WARNING on linus/master v6.16 next-20250725]
[cannot apply to nf-next/master horms-ipvs/master]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Shaun-Brady/Add-test-for-nft_max_table_jumps_netns-sysctl/20250728-120528
base:   https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git main
patch link:    https://lore.kernel.org/r/20250728040315.1014454-1-brady.1345%40gmail.com
patch subject: [PATCH v6 1/2] netfilter: nf_tables: Implement jump limit for nft_table_validate
config: csky-randconfig-001-20250728 (https://download.01.org/0day-ci/archive/20250728/202507281408.4TSYx6Hl-lkp@intel.com/config)
compiler: csky-linux-gcc (GCC) 10.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250728/202507281408.4TSYx6Hl-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202507281408.4TSYx6Hl-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from include/net/net_namespace.h:25,
                    from include/linux/inet.h:42,
                    from fs/nfs/localio.c:15:
>> include/net/netns/netfilter.h:37:2: warning: 'unused' attribute ignored [-Wattributes]
      37 |  u32 nf_max_table_jumps_netns __maybe_unused;
         |  ^~~
--
   In file included from include/net/net_namespace.h:25,
                    from include/linux/inet.h:42,
                    from include/linux/sunrpc/msg_prot.h:205,
                    from include/linux/sunrpc/clnt.h:19,
                    from fs/nfs/nfs4proc.c:45:
>> include/net/netns/netfilter.h:37:2: warning: 'unused' attribute ignored [-Wattributes]
      37 |  u32 nf_max_table_jumps_netns __maybe_unused;
         |  ^~~
   fs/nfs/nfs4proc.c: In function 'nfs4_proc_create_session':
   fs/nfs/nfs4proc.c:9534:12: warning: variable 'ptr' set but not used [-Wunused-but-set-variable]
    9534 |  unsigned *ptr;
         |            ^~~
--
   In file included from include/net/net_namespace.h:25,
                    from include/linux/inet.h:42,
                    from include/linux/sunrpc/msg_prot.h:205,
                    from include/linux/sunrpc/auth.h:14,
                    from include/linux/nfs_fs.h:31,
                    from fs/nfs/flexfilelayout/flexfilelayout.c:10:
>> include/net/netns/netfilter.h:37:2: warning: 'unused' attribute ignored [-Wattributes]
      37 |  u32 nf_max_table_jumps_netns __maybe_unused;
         |  ^~~
   fs/nfs/flexfilelayout/flexfilelayout.c: In function 'ff_layout_io_track_ds_error':
   fs/nfs/flexfilelayout/flexfilelayout.c:1312:6: warning: variable 'err' set but not used [-Wunused-but-set-variable]
    1312 |  int err;
         |      ^~~
--
   In file included from include/net/net_namespace.h:25,
                    from include/linux/inet.h:42,
                    from include/linux/sunrpc/msg_prot.h:205,
                    from include/linux/sunrpc/auth.h:14,
                    from include/linux/nfs_fs.h:31,
                    from fs/nfs/flexfilelayout/flexfilelayoutdev.c:10:
>> include/net/netns/netfilter.h:37:2: warning: 'unused' attribute ignored [-Wattributes]
      37 |  u32 nf_max_table_jumps_netns __maybe_unused;
         |  ^~~
   fs/nfs/flexfilelayout/flexfilelayoutdev.c: In function 'nfs4_ff_alloc_deviceid_node':
   fs/nfs/flexfilelayout/flexfilelayoutdev.c:56:9: warning: variable 'ret' set but not used [-Wunused-but-set-variable]
      56 |  int i, ret = -ENOMEM;
         |         ^~~
--
   In file included from include/net/net_namespace.h:25,
                    from include/linux/inet.h:42,
                    from include/linux/sunrpc/msg_prot.h:205,
                    from include/linux/sunrpc/clnt.h:19,
                    from nfs4proc.c:45:
>> include/net/netns/netfilter.h:37:2: warning: 'unused' attribute ignored [-Wattributes]
      37 |  u32 nf_max_table_jumps_netns __maybe_unused;
         |  ^~~
   nfs4proc.c: In function 'nfs4_proc_create_session':
   nfs4proc.c:9534:12: warning: variable 'ptr' set but not used [-Wunused-but-set-variable]
    9534 |  unsigned *ptr;
         |            ^~~
--
   In file included from include/net/net_namespace.h:25,
                    from include/linux/inet.h:42,
                    from include/linux/sunrpc/msg_prot.h:205,
                    from include/linux/sunrpc/auth.h:14,
                    from include/linux/nfs_fs.h:31,
                    from flexfilelayout/flexfilelayout.c:10:
>> include/net/netns/netfilter.h:37:2: warning: 'unused' attribute ignored [-Wattributes]
      37 |  u32 nf_max_table_jumps_netns __maybe_unused;
         |  ^~~
   flexfilelayout/flexfilelayout.c: In function 'ff_layout_io_track_ds_error':
   flexfilelayout/flexfilelayout.c:1312:6: warning: variable 'err' set but not used [-Wunused-but-set-variable]
    1312 |  int err;
         |      ^~~
--
   In file included from include/net/net_namespace.h:25,
                    from include/linux/inet.h:42,
                    from include/linux/sunrpc/msg_prot.h:205,
                    from include/linux/sunrpc/auth.h:14,
                    from include/linux/nfs_fs.h:31,
                    from flexfilelayout/flexfilelayoutdev.c:10:
>> include/net/netns/netfilter.h:37:2: warning: 'unused' attribute ignored [-Wattributes]
      37 |  u32 nf_max_table_jumps_netns __maybe_unused;
         |  ^~~
   flexfilelayout/flexfilelayoutdev.c: In function 'nfs4_ff_alloc_deviceid_node':
   flexfilelayout/flexfilelayoutdev.c:56:9: warning: variable 'ret' set but not used [-Wunused-but-set-variable]
      56 |  int i, ret = -ENOMEM;
         |         ^~~


vim +/unused +37 include/net/netns/netfilter.h

    10	
    11	struct netns_nf {
    12	#if defined CONFIG_PROC_FS
    13		struct proc_dir_entry *proc_netfilter;
    14	#endif
    15		const struct nf_logger __rcu *nf_loggers[NFPROTO_NUMPROTO];
    16	#ifdef CONFIG_SYSCTL
    17		struct ctl_table_header *nf_log_dir_header;
    18		struct ctl_table_header *nf_limit_control_dir_header;
    19	#ifdef CONFIG_LWTUNNEL
    20		struct ctl_table_header *nf_lwtnl_dir_header;
    21	#endif
    22	#endif
    23		struct nf_hook_entries __rcu *hooks_ipv4[NF_INET_NUMHOOKS];
    24		struct nf_hook_entries __rcu *hooks_ipv6[NF_INET_NUMHOOKS];
    25	#ifdef CONFIG_NETFILTER_FAMILY_ARP
    26		struct nf_hook_entries __rcu *hooks_arp[NF_ARP_NUMHOOKS];
    27	#endif
    28	#ifdef CONFIG_NETFILTER_FAMILY_BRIDGE
    29		struct nf_hook_entries __rcu *hooks_bridge[NF_INET_NUMHOOKS];
    30	#endif
    31	#if IS_ENABLED(CONFIG_NF_DEFRAG_IPV4)
    32		unsigned int defrag_ipv4_users;
    33	#endif
    34	#if IS_ENABLED(CONFIG_NF_DEFRAG_IPV6)
    35		unsigned int defrag_ipv6_users;
    36	#endif
  > 37		u32 nf_max_table_jumps_netns __maybe_unused;

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
