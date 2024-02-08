Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6221E823C2
	for <netfilter-devel@vger.kernel.org>; Thu,  8 Feb 2024 18:12:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707415977; cv=none; b=W34mKQPoKV+NiT4+hO83LTcWndk6fNYF5q1qGCS8gxvJE+Z0zSrbrBTtGMw48s7YiZIsl7uBUbdwzanu10C4fYw7hYkovZL06xsPV2rbjzCnkoucvvrJbX4fbe6K9LI84esrylnjWrXZImd578brWlLXeJRy7IAcEQSXJpqB1rw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707415977; c=relaxed/simple;
	bh=JQ0obMpmrQZMXgMet1DfYA+vEW/gj6cvoDLR4bVbKZQ=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=ugXPysyHaxWWBKX3XwhHnYnGA+8P9uATkeV7Yo1WZDd5sJEXwmbpbIc3YxZk2uJD0wA5vLWVRMSYj1QzVEknQ5j6T6rSGImVuFjGSKlgEA7DSzMNL2aZNQmEDT5UaOAa7iDo019DBu1tVHieK2Q8nM3ZJQIWGMHMFsvwU4A8FhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bnPJPOJq; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bnPJPOJq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1707415975; x=1738951975;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=JQ0obMpmrQZMXgMet1DfYA+vEW/gj6cvoDLR4bVbKZQ=;
  b=bnPJPOJqJRyZsg7IkJfcxk6upHAaAelbl4oHu/TJdM22QbHHaZG073dx
   jkt9+6rzQK9Xqm/jPucYTGgbpFURQbgTa0Y41qIt4JesEdxqhSN5MOTt4
   Y6GIofxfSx+9wX1zr3geqZjGZiJh9VxCjEwokP/F4gsbQwTsWRKVGobRa
   ig1eBZkTwJBhBHTEsl8rF8K2gdgrCufGBVCZG6dJ4/NVNKeTXT18L0GVP
   aEkEvnYHRrAz6n0xzP+72QjGxt8x+Ck+9J0OmLkYESM5Yi5HR3TJevar0
   J0Y0BAM12f7ByriDgnjNJuWqFiM4oDi+qs1j9N/7cnwaUgxlwPmQYo+gE
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10978"; a="12651192"
X-IronPort-AV: E=Sophos;i="6.05,254,1701158400"; 
   d="scan'208";a="12651192"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2024 10:12:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,254,1701158400"; 
   d="scan'208";a="32788428"
Received: from lkp-server01.sh.intel.com (HELO 01f0647817ea) ([10.239.97.150])
  by fmviesa001.fm.intel.com with ESMTP; 08 Feb 2024 10:12:53 -0800
Received: from kbuild by 01f0647817ea with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1rY8tG-00040w-37;
	Thu, 08 Feb 2024 18:12:50 +0000
Date: Fri, 9 Feb 2024 02:12:42 +0800
From: kernel test robot <lkp@intel.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: [netfilter-nf:testing 8/13] net/netfilter/nft_set_pipapo.c:518:
 warning: Function parameter or struct member 'tstamp' not described in
 'pipapo_get'
Message-ID: <202402090259.6dQytidE-lkp@intel.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git testing
head:   a7eaa3316ffa17957ee70a705000a3a942128820
commit: 72368c496f3f456b1d89504b0125e9fb26ae91de [8/13] netfilter: nf_tables: use timestamp to check for set element timeout
config: x86_64-rhel-8.3-bpf (https://download.01.org/0day-ci/archive/20240209/202402090259.6dQytidE-lkp@intel.com/config)
compiler: clang version 17.0.6 (https://github.com/llvm/llvm-project 6009708b4367171ccdbf4b5905cb6a803753fe18)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240209/202402090259.6dQytidE-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202402090259.6dQytidE-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> net/netfilter/nft_set_pipapo.c:518: warning: Function parameter or struct member 'tstamp' not described in 'pipapo_get'


vim +518 net/netfilter/nft_set_pipapo.c

3c4287f62044a9 Stefano Brivio    2020-01-22  500  
3c4287f62044a9 Stefano Brivio    2020-01-22  501  /**
3c4287f62044a9 Stefano Brivio    2020-01-22  502   * pipapo_get() - Get matching element reference given key data
3c4287f62044a9 Stefano Brivio    2020-01-22  503   * @net:	Network namespace
3c4287f62044a9 Stefano Brivio    2020-01-22  504   * @set:	nftables API set representation
3c4287f62044a9 Stefano Brivio    2020-01-22  505   * @data:	Key data to be matched against existing elements
3c4287f62044a9 Stefano Brivio    2020-01-22  506   * @genmask:	If set, check that element is active in given genmask
3c4287f62044a9 Stefano Brivio    2020-01-22  507   *
3c4287f62044a9 Stefano Brivio    2020-01-22  508   * This is essentially the same as the lookup function, except that it matches
3c4287f62044a9 Stefano Brivio    2020-01-22  509   * key data against the uncommitted copy and doesn't use preallocated maps for
3c4287f62044a9 Stefano Brivio    2020-01-22  510   * bitmap results.
3c4287f62044a9 Stefano Brivio    2020-01-22  511   *
3c4287f62044a9 Stefano Brivio    2020-01-22  512   * Return: pointer to &struct nft_pipapo_elem on match, error pointer otherwise.
3c4287f62044a9 Stefano Brivio    2020-01-22  513   */
3c4287f62044a9 Stefano Brivio    2020-01-22  514  static struct nft_pipapo_elem *pipapo_get(const struct net *net,
3c4287f62044a9 Stefano Brivio    2020-01-22  515  					  const struct nft_set *set,
72368c496f3f45 Pablo Neira Ayuso 2024-02-06  516  					  const u8 *data, u8 genmask,
72368c496f3f45 Pablo Neira Ayuso 2024-02-06  517  					  u64 tstamp)
3c4287f62044a9 Stefano Brivio    2020-01-22 @518  {
3c4287f62044a9 Stefano Brivio    2020-01-22  519  	struct nft_pipapo_elem *ret = ERR_PTR(-ENOENT);
3c4287f62044a9 Stefano Brivio    2020-01-22  520  	struct nft_pipapo *priv = nft_set_priv(set);
3c4287f62044a9 Stefano Brivio    2020-01-22  521  	struct nft_pipapo_match *m = priv->clone;
3c4287f62044a9 Stefano Brivio    2020-01-22  522  	unsigned long *res_map, *fill_map = NULL;
3c4287f62044a9 Stefano Brivio    2020-01-22  523  	struct nft_pipapo_field *f;
3c4287f62044a9 Stefano Brivio    2020-01-22  524  	int i;
3c4287f62044a9 Stefano Brivio    2020-01-22  525  
3c4287f62044a9 Stefano Brivio    2020-01-22  526  	res_map = kmalloc_array(m->bsize_max, sizeof(*res_map), GFP_ATOMIC);
3c4287f62044a9 Stefano Brivio    2020-01-22  527  	if (!res_map) {
3c4287f62044a9 Stefano Brivio    2020-01-22  528  		ret = ERR_PTR(-ENOMEM);
3c4287f62044a9 Stefano Brivio    2020-01-22  529  		goto out;
3c4287f62044a9 Stefano Brivio    2020-01-22  530  	}
3c4287f62044a9 Stefano Brivio    2020-01-22  531  
3c4287f62044a9 Stefano Brivio    2020-01-22  532  	fill_map = kcalloc(m->bsize_max, sizeof(*res_map), GFP_ATOMIC);
3c4287f62044a9 Stefano Brivio    2020-01-22  533  	if (!fill_map) {
3c4287f62044a9 Stefano Brivio    2020-01-22  534  		ret = ERR_PTR(-ENOMEM);
3c4287f62044a9 Stefano Brivio    2020-01-22  535  		goto out;
3c4287f62044a9 Stefano Brivio    2020-01-22  536  	}
3c4287f62044a9 Stefano Brivio    2020-01-22  537  
3c4287f62044a9 Stefano Brivio    2020-01-22  538  	memset(res_map, 0xff, m->bsize_max * sizeof(*res_map));
3c4287f62044a9 Stefano Brivio    2020-01-22  539  
3c4287f62044a9 Stefano Brivio    2020-01-22  540  	nft_pipapo_for_each_field(f, i, m) {
3c4287f62044a9 Stefano Brivio    2020-01-22  541  		bool last = i == m->field_count - 1;
e807b13cb3e3bc Stefano Brivio    2020-03-07  542  		int b;
3c4287f62044a9 Stefano Brivio    2020-01-22  543  
e807b13cb3e3bc Stefano Brivio    2020-03-07  544  		/* For each bit group: select lookup table bucket depending on
3c4287f62044a9 Stefano Brivio    2020-01-22  545  		 * packet bytes value, then AND bucket value
3c4287f62044a9 Stefano Brivio    2020-01-22  546  		 */
4051f43116cdc7 Stefano Brivio    2020-03-07  547  		if (f->bb == 8)
4051f43116cdc7 Stefano Brivio    2020-03-07  548  			pipapo_and_field_buckets_8bit(f, res_map, data);
4051f43116cdc7 Stefano Brivio    2020-03-07  549  		else if (f->bb == 4)
e807b13cb3e3bc Stefano Brivio    2020-03-07  550  			pipapo_and_field_buckets_4bit(f, res_map, data);
e807b13cb3e3bc Stefano Brivio    2020-03-07  551  		else
e807b13cb3e3bc Stefano Brivio    2020-03-07  552  			BUG();
3c4287f62044a9 Stefano Brivio    2020-01-22  553  
e807b13cb3e3bc Stefano Brivio    2020-03-07  554  		data += f->groups / NFT_PIPAPO_GROUPS_PER_BYTE(f);
3c4287f62044a9 Stefano Brivio    2020-01-22  555  
3c4287f62044a9 Stefano Brivio    2020-01-22  556  		/* Now populate the bitmap for the next field, unless this is
3c4287f62044a9 Stefano Brivio    2020-01-22  557  		 * the last field, in which case return the matched 'ext'
3c4287f62044a9 Stefano Brivio    2020-01-22  558  		 * pointer if any.
3c4287f62044a9 Stefano Brivio    2020-01-22  559  		 *
3c4287f62044a9 Stefano Brivio    2020-01-22  560  		 * Now res_map contains the matching bitmap, and fill_map is the
3c4287f62044a9 Stefano Brivio    2020-01-22  561  		 * bitmap for the next field.
3c4287f62044a9 Stefano Brivio    2020-01-22  562  		 */
3c4287f62044a9 Stefano Brivio    2020-01-22  563  next_match:
3c4287f62044a9 Stefano Brivio    2020-01-22  564  		b = pipapo_refill(res_map, f->bsize, f->rules, fill_map, f->mt,
3c4287f62044a9 Stefano Brivio    2020-01-22  565  				  last);
3c4287f62044a9 Stefano Brivio    2020-01-22  566  		if (b < 0)
3c4287f62044a9 Stefano Brivio    2020-01-22  567  			goto out;
3c4287f62044a9 Stefano Brivio    2020-01-22  568  
3c4287f62044a9 Stefano Brivio    2020-01-22  569  		if (last) {
72368c496f3f45 Pablo Neira Ayuso 2024-02-06  570  			if (__nft_set_elem_expired(&f->mt[b].e->ext, tstamp))
7845914f45f066 Florian Westphal  2023-08-12  571  				goto next_match;
24138933b97b05 Florian Westphal  2023-08-09  572  			if ((genmask &&
3c4287f62044a9 Stefano Brivio    2020-01-22  573  			     !nft_set_elem_active(&f->mt[b].e->ext, genmask)))
3c4287f62044a9 Stefano Brivio    2020-01-22  574  				goto next_match;
3c4287f62044a9 Stefano Brivio    2020-01-22  575  
3c4287f62044a9 Stefano Brivio    2020-01-22  576  			ret = f->mt[b].e;
3c4287f62044a9 Stefano Brivio    2020-01-22  577  			goto out;
3c4287f62044a9 Stefano Brivio    2020-01-22  578  		}
3c4287f62044a9 Stefano Brivio    2020-01-22  579  
e807b13cb3e3bc Stefano Brivio    2020-03-07  580  		data += NFT_PIPAPO_GROUPS_PADDING(f);
3c4287f62044a9 Stefano Brivio    2020-01-22  581  
3c4287f62044a9 Stefano Brivio    2020-01-22  582  		/* Swap bitmap indices: fill_map will be the initial bitmap for
3c4287f62044a9 Stefano Brivio    2020-01-22  583  		 * the next field (i.e. the new res_map), and res_map is
3c4287f62044a9 Stefano Brivio    2020-01-22  584  		 * guaranteed to be all-zeroes at this point, ready to be filled
3c4287f62044a9 Stefano Brivio    2020-01-22  585  		 * according to the next mapping table.
3c4287f62044a9 Stefano Brivio    2020-01-22  586  		 */
3c4287f62044a9 Stefano Brivio    2020-01-22  587  		swap(res_map, fill_map);
3c4287f62044a9 Stefano Brivio    2020-01-22  588  	}
3c4287f62044a9 Stefano Brivio    2020-01-22  589  
3c4287f62044a9 Stefano Brivio    2020-01-22  590  out:
3c4287f62044a9 Stefano Brivio    2020-01-22  591  	kfree(fill_map);
3c4287f62044a9 Stefano Brivio    2020-01-22  592  	kfree(res_map);
3c4287f62044a9 Stefano Brivio    2020-01-22  593  	return ret;
3c4287f62044a9 Stefano Brivio    2020-01-22  594  }
3c4287f62044a9 Stefano Brivio    2020-01-22  595  

:::::: The code at line 518 was first introduced by commit
:::::: 3c4287f62044a90e73a561aa05fc46e62da173da nf_tables: Add set type for arbitrary concatenation of ranges

:::::: TO: Stefano Brivio <sbrivio@redhat.com>
:::::: CC: Pablo Neira Ayuso <pablo@netfilter.org>

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
