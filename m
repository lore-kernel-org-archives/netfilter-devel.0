Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46A884D09E6
	for <netfilter-devel@vger.kernel.org>; Thu, 15 Oct 2026 12:07:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792066063; cv=none; b=uSF9TJTgQSCh9RDzxCTERC8Pq0nvQiBcCF1z5fsBpq58hcbKUhXxC37iyTG7QNVq4V2IwTCjoo4Cmix5VOoCEp4RQ2UEspjogJqo6+6U91F/HBqIK6iEUWR5vAsTQoaAgwvxhM36eG2oIhZ8PiGVeu8VFLb3Md31c18lFQUhFN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792066063; c=relaxed/simple;
	bh=BwCFbp/zevL9TFCmfYwXvVNxS6Wcegx8/forJCOM8Wo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Dlsc0c6z1AxdDNTgSsvNH5S3vlHRW0nqXRFVsH79m629YC7TLTgc3ad+LSPhwfzds/lwHNu4ZvAOQeC+uRs1Bmw/M4A060GbqezTc8wX6XY8mnIhvmrPl21tVrx7XzAwHjAjyYqS+JDGnEXxTntuZiD52zwRVZflrNbrcaEhtNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Gll/oAmA; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Gll/oAmA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792066062; x=1823602062;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=BwCFbp/zevL9TFCmfYwXvVNxS6Wcegx8/forJCOM8Wo=;
  b=Gll/oAmAql850zuBCzFBX/gIsSI4S/aOR0YqzX6snA5WPXB/TEyD6E9t
   SY5B0Twmd4L9ojvCwagEgu6Rg12Pw5JUi2QZZDeWyWP2m8vL5+RaVP6VC
   F8ByeBO8IV5oaPTBO5gTD+TiHED91Aq6/GHXXOtHsvjKSqQ1HQlz0lUQZ
   DwDWqOpLvyvOSqf6mKHTBr0xnaJx1F02bTYa8MFDPjX17opz8Hm0QN90x
   eRYWwcHi+nWMvWD0gwujKqcnXWkXq3DxLD/OnluQIcXYBZOWRKpphWrev
   aDBrI9QKAXEy8zD/GfDGCqud1v09Dw2VNFXqeGd2des9mQ17W39r1O3b/
   g==;
X-CSE-ConnectionGUID: MpDx6ub5SqqBqLZoA9RuEQ==
X-CSE-MsgGUID: yH+PqMBiTkKtkNc9wPuQlg==
X-IronPort-AV: E=McAfee;i="6800,10657,11935"; a="935590"
X-IronPort-AV: E=Sophos;i="6.27,159,1787036400"; 
   d="scan'208";a="935590"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Oct 2026 05:07:41 -0700
X-CSE-ConnectionGUID: uq6FfK3MQCKwsIWeLKgzyw==
X-CSE-MsgGUID: pK8h2HCVTbSCynzJ8p5hwg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,159,1787036400"; 
   d="scan'208";a="2008254"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa008.fm.intel.com with ESMTP; 15 Oct 2026 05:07:39 -0700
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xHKFE-00000000GQ6-20CF;
	Thu, 15 Oct 2026 12:07:36 +0000
Date: Thu, 15 Oct 2026 20:07:10 +0800
From: kernel test robot <lkp@intel.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	julius@bairaktaris.de, ericwouds@gmail.com, razor@blackwall.org
Subject: Re: [PATCH nf-next] netfilter: flowtable: teardown flow reaching
 bridge port on fdb updates
Message-ID: <202610152010.2EqEudOw-lkp@intel.com>
References: <20261014210256.1573072-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261014210256.1573072-1-pablo@netfilter.org>

Hi Pablo,

kernel test robot noticed the following build errors:

[auto build test ERROR on nf-next/main]

url:    https://github.com/intel-lab-lkp/linux/commits/Pablo-Neira-Ayuso/netfilter-flowtable-teardown-flow-reaching-bridge-port-on-fdb-updates/20261014-230256
base:   https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git main
patch link:    https://lore.kernel.org/r/20261014210256.1573072-1-pablo%40netfilter.org
patch subject: [PATCH nf-next] netfilter: flowtable: teardown flow reaching bridge port on fdb updates
config: hexagon-randconfig-1000-20261015 (https://download.01.org/0day-ci/archive/20261015/202610152010.2EqEudOw-lkp@intel.com/config)
compiler: clang version 24.0.0git (https://github.com/llvm/llvm-project 6719b9e31d6a93099612c474eec76d9f41d0275a)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261015/202610152010.2EqEudOw-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202610152010.2EqEudOw-lkp@intel.com/

All errors (new ones prefixed by >>):

>> net/bridge/br_nf_utils.c:32:6: error: assigning to 'const struct net_bridge_port *' from incompatible type 'typeof_unqual (f->dst)' (aka 'struct net_bridge_dst')
      32 |         dst = READ_ONCE(f->dst);
         |             ^ ~~~~~~~~~~~~~~~~~
   1 error generated.


vim +32 net/bridge/br_nf_utils.c

     8	
     9	static bool nf_br_fdb_valid_dst(struct net *net, int ifindex,
    10					const unsigned char *addr, __u16 vid)
    11	{
    12		const struct net_bridge_port *dst;
    13		struct net_device *dev, *upper;
    14		struct net_bridge_fdb_entry *f;
    15		struct net_bridge *br;
    16	
    17		rcu_read_lock();
    18		dev = dev_get_by_index_rcu(net, ifindex);
    19		if (!dev || !netif_is_bridge_port(dev))
    20			goto out;
    21	
    22		upper = netdev_master_upper_dev_get_rcu(dev);
    23		if (!upper)
    24			goto out;
    25	
    26		br = netdev_priv(upper);
    27	
    28		f = br_fdb_find_rcu(br, addr, vid);
    29		if (!f)
    30			goto out;
    31	
  > 32		dst = READ_ONCE(f->dst);
    33		if (dst && dst->dev->ifindex == ifindex) {
    34			rcu_read_unlock();
    35			return true;
    36		}
    37	out:
    38		rcu_read_unlock();
    39	
    40		return false;
    41	}
    42	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
