Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67AE1192D9A
	for <netfilter-devel@vger.kernel.org>; Sun, 16 Feb 2025 15:23:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739719405; cv=none; b=FWnmWMZRPaKM82QVFWwm/WaTVQ3LR92Nw/ATTYK1ix22RU64GnyDLD3W4cDmsMEzQC/AuUOndZhMSo6F3eekLBSluEGdLaISfnxG2To23anCYUzVbAhvoyIkHvPzryhiOTJRqRe3BLKQkKXZEhnVh+kgEUwafGv0vm0OZFVsR7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739719405; c=relaxed/simple;
	bh=po62Jc1XMG8GWgLcWzL9t2XBsDzkbQQSYDMWB4lIbB8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gn6R4/PqrF4lY6d7PogkJgfKcnRGJ/hScJVZF9uaqSfIxbzqBbpYHC1k44geDzWdTghsaif3IQumnQ7JJnn0A8IPd2KwzDprrLhQil8KGzQdRe2Z9/k491FyPAWBdP9OyFA6uPaG5uA7xY55bDS8mrpskMFIU83k4BGKZzglCCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Xa09SWnL; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Xa09SWnL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739719403; x=1771255403;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=po62Jc1XMG8GWgLcWzL9t2XBsDzkbQQSYDMWB4lIbB8=;
  b=Xa09SWnLS6OiwktNQoUeH48TXsesBGUF6CyNCneGXylgcB04N5awq+1C
   KUhAnPakZfaeMnNrVs6h0pP2fNMFifb102wm2pQbKS2fOQgNcFF/6Jon3
   fi+zW0C/32TLtVtgsE3QLm+bpcAqIDg8zcaiL4v9ZDO8Pk/J/DVEugS5p
   UQVd4wUXbP/ewlygzKw2Zg0w/j0t5+SBS/Elvpx/O0vbe6oJYAApEnWG1
   R6evenr7jiQf1UTSc7pyY2q7EInttG+IqQkMZDnT7Bon5ZqE+2AwP9Ed2
   AxoKJH/Aaxm/YZaXH3GX6DnGJyWuL82bd11a0qUIBlauttsnE6XHq+q9w
   A==;
X-CSE-ConnectionGUID: oy2iV2qBSWOeGrs00lZK8w==
X-CSE-MsgGUID: nxwnE87cTH+VvBHR+GA6lg==
X-IronPort-AV: E=McAfee;i="6700,10204,11347"; a="51035121"
X-IronPort-AV: E=Sophos;i="6.13,291,1732608000"; 
   d="scan'208";a="51035121"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2025 07:23:23 -0800
X-CSE-ConnectionGUID: yiOXorRESNWuSBgtzbggww==
X-CSE-MsgGUID: wHTmw9t8TzGZAMTX7DcqPQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,291,1732608000"; 
   d="scan'208";a="113783009"
Received: from lkp-server01.sh.intel.com (HELO d63d4d77d921) ([10.239.97.150])
  by fmviesa006.fm.intel.com with ESMTP; 16 Feb 2025 07:23:21 -0800
Received: from kbuild by d63d4d77d921 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1tjgUI-001C1D-2n;
	Sun, 16 Feb 2025 15:23:18 +0000
Date: Sun, 16 Feb 2025 23:22:32 +0800
From: kernel test robot <lkp@intel.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	linux-rt-devel@lists.linux.dev
Cc: oe-kbuild-all@lists.linux.dev, Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [PATCH net-next 2/3] netfilter: Split the xt_counters type
 between kernel and user.
Message-ID: <202502162342.iQ248XrR-lkp@intel.com>
References: <20250216125135.3037967-3-bigeasy@linutronix.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250216125135.3037967-3-bigeasy@linutronix.de>

Hi Sebastian,

kernel test robot noticed the following build warnings:

[auto build test WARNING on net-next/main]

url:    https://github.com/intel-lab-lkp/linux/commits/Sebastian-Andrzej-Siewior/netfilter-Make-xt_table-private-RCU-protected/20250216-210418
base:   net-next/main
patch link:    https://lore.kernel.org/r/20250216125135.3037967-3-bigeasy%40linutronix.de
patch subject: [PATCH net-next 2/3] netfilter: Split the xt_counters type between kernel and user.
config: i386-buildonly-randconfig-001-20250216 (https://download.01.org/0day-ci/archive/20250216/202502162342.iQ248XrR-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250216/202502162342.iQ248XrR-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202502162342.iQ248XrR-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> net/netfilter/x_tables.c:1912: warning: Function parameter or struct member 'xt_pad' not described in 'xt_percpu_counter_alloc'
>> net/netfilter/x_tables.c:1912: warning: Excess function parameter 'counter' description in 'xt_percpu_counter_alloc'


vim +1912 net/netfilter/x_tables.c

2e4e6a17af35be Harald Welte              2006-01-12  1887  
f28e15bacedd44 Florian Westphal          2016-11-22  1888  /**
f28e15bacedd44 Florian Westphal          2016-11-22  1889   * xt_percpu_counter_alloc - allocate x_tables rule counter
f28e15bacedd44 Florian Westphal          2016-11-22  1890   *
ae0ac0ed6fcf5a Florian Westphal          2016-11-22  1891   * @state: pointer to xt_percpu allocation state
f28e15bacedd44 Florian Westphal          2016-11-22  1892   * @counter: pointer to counter struct inside the ip(6)/arpt_entry struct
f28e15bacedd44 Florian Westphal          2016-11-22  1893   *
f28e15bacedd44 Florian Westphal          2016-11-22  1894   * On SMP, the packet counter [ ip(6)t_entry->counters.pcnt ] will then
f28e15bacedd44 Florian Westphal          2016-11-22  1895   * contain the address of the real (percpu) counter.
f28e15bacedd44 Florian Westphal          2016-11-22  1896   *
f28e15bacedd44 Florian Westphal          2016-11-22  1897   * Rule evaluation needs to use xt_get_this_cpu_counter() helper
f28e15bacedd44 Florian Westphal          2016-11-22  1898   * to fetch the real percpu counter.
f28e15bacedd44 Florian Westphal          2016-11-22  1899   *
ae0ac0ed6fcf5a Florian Westphal          2016-11-22  1900   * To speed up allocation and improve data locality, a 4kb block is
9ba5c404bf1d62 Ben Hutchings             2018-03-29  1901   * allocated.  Freeing any counter may free an entire block, so all
9ba5c404bf1d62 Ben Hutchings             2018-03-29  1902   * counters allocated using the same state must be freed at the same
9ba5c404bf1d62 Ben Hutchings             2018-03-29  1903   * time.
ae0ac0ed6fcf5a Florian Westphal          2016-11-22  1904   *
ae0ac0ed6fcf5a Florian Westphal          2016-11-22  1905   * xt_percpu_counter_alloc_state contains the base address of the
ae0ac0ed6fcf5a Florian Westphal          2016-11-22  1906   * allocated page and the current sub-offset.
ae0ac0ed6fcf5a Florian Westphal          2016-11-22  1907   *
f28e15bacedd44 Florian Westphal          2016-11-22  1908   * returns false on error.
f28e15bacedd44 Florian Westphal          2016-11-22  1909   */
ae0ac0ed6fcf5a Florian Westphal          2016-11-22  1910  bool xt_percpu_counter_alloc(struct xt_percpu_counter_alloc_state *state,
e99ca3c3e3ed04 Sebastian Andrzej Siewior 2025-02-16  1911  			     struct xt_counter_pad *xt_pad)
f28e15bacedd44 Florian Westphal          2016-11-22 @1912  {
e99ca3c3e3ed04 Sebastian Andrzej Siewior 2025-02-16  1913  	union xt_counter_k *xt_cnt = (union xt_counter_k *)xt_pad;
e99ca3c3e3ed04 Sebastian Andrzej Siewior 2025-02-16  1914  
e99ca3c3e3ed04 Sebastian Andrzej Siewior 2025-02-16  1915  	BUILD_BUG_ON(XT_PCPU_BLOCK_SIZE < (sizeof(struct xt_counters_k) * 2));
e99ca3c3e3ed04 Sebastian Andrzej Siewior 2025-02-16  1916  	BUILD_BUG_ON(sizeof(struct xt_counters_k) != sizeof(struct xt_counters));
e99ca3c3e3ed04 Sebastian Andrzej Siewior 2025-02-16  1917  	BUILD_BUG_ON(sizeof(struct xt_counters_k) != sizeof(struct xt_counter_pad));
f28e15bacedd44 Florian Westphal          2016-11-22  1918  
f28e15bacedd44 Florian Westphal          2016-11-22  1919  	if (nr_cpu_ids <= 1)
f28e15bacedd44 Florian Westphal          2016-11-22  1920  		return true;
f28e15bacedd44 Florian Westphal          2016-11-22  1921  
ae0ac0ed6fcf5a Florian Westphal          2016-11-22  1922  	if (!state->mem) {
ae0ac0ed6fcf5a Florian Westphal          2016-11-22  1923  		state->mem = __alloc_percpu(XT_PCPU_BLOCK_SIZE,
ae0ac0ed6fcf5a Florian Westphal          2016-11-22  1924  					    XT_PCPU_BLOCK_SIZE);
ae0ac0ed6fcf5a Florian Westphal          2016-11-22  1925  		if (!state->mem)
f28e15bacedd44 Florian Westphal          2016-11-22  1926  			return false;
ae0ac0ed6fcf5a Florian Westphal          2016-11-22  1927  	}
e99ca3c3e3ed04 Sebastian Andrzej Siewior 2025-02-16  1928  	xt_cnt->pcpu = state->mem + state->off;
e99ca3c3e3ed04 Sebastian Andrzej Siewior 2025-02-16  1929  	state->off += sizeof(struct xt_counters_k);
e99ca3c3e3ed04 Sebastian Andrzej Siewior 2025-02-16  1930  	if (state->off > (XT_PCPU_BLOCK_SIZE - sizeof(struct xt_counters_k))) {
ae0ac0ed6fcf5a Florian Westphal          2016-11-22  1931  		state->mem = NULL;
ae0ac0ed6fcf5a Florian Westphal          2016-11-22  1932  		state->off = 0;
ae0ac0ed6fcf5a Florian Westphal          2016-11-22  1933  	}
f28e15bacedd44 Florian Westphal          2016-11-22  1934  	return true;
f28e15bacedd44 Florian Westphal          2016-11-22  1935  }
f28e15bacedd44 Florian Westphal          2016-11-22  1936  EXPORT_SYMBOL_GPL(xt_percpu_counter_alloc);
f28e15bacedd44 Florian Westphal          2016-11-22  1937  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
