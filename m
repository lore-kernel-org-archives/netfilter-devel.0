Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24DCE1847;
	Fri,  7 Jun 2024 12:34:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717763656; cv=none; b=XUIMTv1PCRJpsYN/m0Yu2xhAH2WwAfM4p4rD5JjXQSeKEXKuwlIcZPDeVRqpeiY2DJvg2AjnjAKhzASfEKrqumPhA11L7Et2JwAlGw3TPeRLhCH7TaKYMQb6pkzG+n/q5Myzm/nXKU3g2EeaNnlmeb5g4350mFCSXv5Lh8H56+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717763656; c=relaxed/simple;
	bh=BIR85JHk2mvMnrfqN9t80Q5WlHV7sDQEH1JX8HWex3g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QAhMOkvhRDDS2VzXih3DeQ3NAUwF2ksJYegIJ3cXKHkTdYKNXC/yNpg+ppTYgA+Hr2AfBTPdmVG1tCpwS1ei1GqvZ2o6S/wLISoyS+ECXA9kAFrwjuXusNqwUHPfrcBS9HqIWo+LxPlqMJNnV3bA4BuV2Jn0T5PzdgAJ/imEF7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AfNbKo69; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AfNbKo69"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717763653; x=1749299653;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=BIR85JHk2mvMnrfqN9t80Q5WlHV7sDQEH1JX8HWex3g=;
  b=AfNbKo69RrsQmOGBvNXGU/89UaNL6BQwXM1utbEfaxp6YoIvlXfGdbN/
   PX49YvbQYHUTBwGBQG7UgOqiNNOqd56Q6PfzzSkYG7vaLUq91AB37WJox
   gYGpKkS8uVkXReNv306ujeZ9xIq9+84dn3q/oC9RY6QRIQHXfxoPqdehh
   oFz/iQujM4YmT53UT+kqhIKSlq5p1Jh8rmBCHJpFt+TFwXl6xk8C3NMjc
   gnSj9QBeH+kUt9NZdz5vuFHQksqPIMEi/O6metO1cGHPQGofGR0H+Lpar
   Wjvl6fRFbH+Qrv+pElgNS2fxYqkS34Thag+WSAS2nuvkAwFGBwpe9wGY5
   Q==;
X-CSE-ConnectionGUID: ihTLEXG9TyiqqII+YYHfLA==
X-CSE-MsgGUID: QTQ4CTTvSuemJnCvMLpHzg==
X-IronPort-AV: E=McAfee;i="6600,9927,11095"; a="14707158"
X-IronPort-AV: E=Sophos;i="6.08,221,1712646000"; 
   d="scan'208";a="14707158"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2024 05:34:12 -0700
X-CSE-ConnectionGUID: QZ9V5JMXSQKMNUpICBhxNQ==
X-CSE-MsgGUID: 5BfkVLWBTOm8qgjtSfc9hw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,221,1712646000"; 
   d="scan'208";a="43251618"
Received: from unknown (HELO 0610945e7d16) ([10.239.97.151])
  by orviesa005.jf.intel.com with ESMTP; 07 Jun 2024 05:34:10 -0700
Received: from kbuild by 0610945e7d16 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1sFYnH-0004mM-1w;
	Fri, 07 Jun 2024 12:34:07 +0000
Date: Fri, 7 Jun 2024 20:33:42 +0800
From: kernel test robot <lkp@intel.com>
To: Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, netfilter-devel@vger.kernel.org,
	pablo@netfilter.org, willemb@google.com,
	Christoph Paasch <cpaasch@apple.com>
Subject: Re: [PATCH net-next 1/2] net: add and use skb_get_hash_net
Message-ID: <202406072022.OkRGOAuS-lkp@intel.com>
References: <20240607083205.3000-2-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240607083205.3000-2-fw@strlen.de>

Hi Florian,

kernel test robot noticed the following build warnings:

[auto build test WARNING on net-next/main]

url:    https://github.com/intel-lab-lkp/linux/commits/Florian-Westphal/net-add-and-use-skb_get_hash_net/20240607-163738
base:   net-next/main
patch link:    https://lore.kernel.org/r/20240607083205.3000-2-fw%40strlen.de
patch subject: [PATCH net-next 1/2] net: add and use skb_get_hash_net
config: openrisc-defconfig (https://download.01.org/0day-ci/archive/20240607/202406072022.OkRGOAuS-lkp@intel.com/config)
compiler: or1k-linux-gcc (GCC) 13.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240607/202406072022.OkRGOAuS-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202406072022.OkRGOAuS-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> net/core/flow_dissector.c:1872: warning: Function parameter or struct member 'net' not described in '__skb_get_hash_net'


vim +1872 net/core/flow_dissector.c

eb70db8756717b David S. Miller  2016-07-01  1861  
d4fd32757176d1 Jiri Pirko       2015-05-12  1862  /**
11b45a5b56dab6 Florian Westphal 2024-06-07  1863   * __skb_get_hash_net: calculate a flow hash
d4fd32757176d1 Jiri Pirko       2015-05-12  1864   * @skb: sk_buff to calculate flow hash from
d4fd32757176d1 Jiri Pirko       2015-05-12  1865   *
d4fd32757176d1 Jiri Pirko       2015-05-12  1866   * This function calculates a flow hash based on src/dst addresses
61b905da33ae25 Tom Herbert      2014-03-24  1867   * and src/dst port numbers.  Sets hash in skb to non-zero hash value
61b905da33ae25 Tom Herbert      2014-03-24  1868   * on success, zero indicates no valid hash.  Also, sets l4_hash in skb
441d9d327f1e77 Cong Wang        2013-01-21  1869   * if hash is a canonical 4-tuple hash over transport ports.
441d9d327f1e77 Cong Wang        2013-01-21  1870   */
11b45a5b56dab6 Florian Westphal 2024-06-07  1871  void __skb_get_hash_net(const struct net *net, struct sk_buff *skb)
441d9d327f1e77 Cong Wang        2013-01-21 @1872  {
441d9d327f1e77 Cong Wang        2013-01-21  1873  	struct flow_keys keys;
635c223cfa05af Gao Feng         2016-08-31  1874  	u32 hash;
441d9d327f1e77 Cong Wang        2013-01-21  1875  
11b45a5b56dab6 Florian Westphal 2024-06-07  1876  	memset(&keys, 0, sizeof(keys));
11b45a5b56dab6 Florian Westphal 2024-06-07  1877  
11b45a5b56dab6 Florian Westphal 2024-06-07  1878  	__skb_flow_dissect(net, skb, &flow_keys_dissector,
11b45a5b56dab6 Florian Westphal 2024-06-07  1879  			   &keys, NULL, 0, 0, 0,
11b45a5b56dab6 Florian Westphal 2024-06-07  1880  			   FLOW_DISSECTOR_F_STOP_AT_FLOW_LABEL);
11b45a5b56dab6 Florian Westphal 2024-06-07  1881  
50fb799289501c Tom Herbert      2015-05-01  1882  	__flow_hash_secret_init();
50fb799289501c Tom Herbert      2015-05-01  1883  
11b45a5b56dab6 Florian Westphal 2024-06-07  1884  	hash = __flow_hash_from_keys(&keys, &hashrnd);
635c223cfa05af Gao Feng         2016-08-31  1885  
635c223cfa05af Gao Feng         2016-08-31  1886  	__skb_set_sw_hash(skb, hash, flow_keys_have_l4(&keys));
441d9d327f1e77 Cong Wang        2013-01-21  1887  }
11b45a5b56dab6 Florian Westphal 2024-06-07  1888  EXPORT_SYMBOL(__skb_get_hash_net);
441d9d327f1e77 Cong Wang        2013-01-21  1889  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
