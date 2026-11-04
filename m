Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.20
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793754006;
	b=Bpk9fcPoHe9Q2b0Hjx2HpSV7QohdLaPsv6lXy6v8AbeV7ik2zXZ846piOUuGeTGs/NVV
	 fjEJ0Vl8F2q/IjsC5oOQagXPPBo0l7FUQhVQ0gpGz0tDxTdUvHGpkcy2pPbAvJvrL5LLN
	 Kv7KMt/n28myjr9BCYKsZkU+Svk6TiI6r/GubXfqTG70yB6JBsy+yiVl9LExDZYM6lKI1
	 SuQ3/zr70w3YypltPeh/R3IN4h79YK4uWc/rzq0foQgIU00tRPWlYnxDJa/Xz0UEjzO0b
	 90UPIr8PRHucZlKJ4lKhoLDNj7lZYoyDBfBqhqO3+qbAsQ/VKypaRflcbrZI4QIbcIw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793754006;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Date:From:To:
	 Cc:Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=DkN5EBdbPUtDHIozM/fmpd/KL54M6Mf5B1VBYAKsU9k=;
	b=F0Dl4+VsfmqFo1P/fj8HAp+Xm4XjTeez2E3OH+9VCppoTlzpwco0v4mBiMOxp8JufoNT
	 022Jy/UhPXQDKs9oOI6kRT9yF0h0ntyyQjODC5bpzUYci2tgD0LGlEpoeF23l+yrGgdmW
	 RL7s8puyaZwTNx3nDpgS0MtiStUXa+6dvCvRLWhVlKeQTYfPm5mXkbj82hYnFhi5jYb18
	 PbrJahuRxdFBZn+hHRDCIJwA6wGW3yeq7gBQ8FRvFt7SFHnLMJx8rogkkMwnlRW7sSTI7
	 RN0jHYgMBKDdk5c78EnMb+DHOa4obx5iKo0nZaA7yw0P3spAdgfS/GPXQ+sKLQ7xvww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=fAAwuHKW;
	arc=none smtp.remote-ip=198.175.65.20
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA2DA606A326
	for <netfilter-devel@vger.kernel.org>; Wed,  4 Nov 2026 01:00:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AA2DA606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=fAAwuHKW
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793754005; x=1825290005;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=7iNH0ZCFPCuLx066aBsp3hyWUzPD69yXDaRM1P+78Fc=;
  b=fAAwuHKWa8ewBTSC5uDiq+ZOi6O9KZQULhY8n56JI+OoAIbu4jcOq4+x
   WMRib7SYv/98PuukymYWPH10KjmACjZ7wq1znGuaTbZybS6x+jiQG6AMm
   PaFbNS3qF/UCIRh5sNGMySi6lqDdY6Rag/UIlcG5Yg3gzXId7bjL+ZxYU
   CVaBTUskuBHB4tRcFKnWeEVPMKLawPABcjW1/hmhfF3p7+PfVOMlYrK0b
   Ei3liTcTCQb3vgvdwhmCkH4z/lLyHOfEsbtdQWYDTW4kQccI5MajiADX5
   OzvUE3cqdJDuHE32Pz+qutteR45oGUArc38HtHTRW3GZ8k8pTIEF+iJ84
   w==;
X-CSE-ConnectionGUID: fwkrkQAmQu2UlmlDNgaU3A==
X-CSE-MsgGUID: XVsx/k6DRrqky8yiJ53NFw==
X-IronPort-AV: E=McAfee;i="6800,10657,11955"; a="2528330"
X-IronPort-AV: E=Sophos;i="6.27,194,1787036400"; 
   d="scan'208";a="2528330"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2026 17:00:05 -0800
X-CSE-ConnectionGUID: iIhjQ9bJQeafV4/CHTOQ6A==
X-CSE-MsgGUID: NMOFN8axSC2vmazRKiLDig==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,194,1787036400"; 
   d="scan'208";a="7128015"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa010.fm.intel.com with ESMTP; 03 Nov 2026 17:00:03 -0800
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xOPM8-00000000jYV-1XdH;
	Wed, 04 Nov 2026 01:00:00 +0000
Date: Wed, 4 Nov 2026 08:59:06 +0800
From: kernel test robot <lkp@intel.com>
To: Fernando Fernandez Mancera <fmancera@suse.de>,
	netfilter-devel@vger.kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	coreteam@netfilter.org, phil@nwl.cc, fw@strlen.de,
	pablo@netfilter.org, Fernando Fernandez Mancera <fmancera@suse.de>
Subject: Re: [PATCH nf] netfilter: synproxy: prevent unbounded recursion in
 transmit path
Message-ID: <202611040824.Zozbyqd6-lkp@intel.com>
References: <20261103125638.4667-1-fmancera@suse.de>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261103125638.4667-1-fmancera@suse.de>

Hi Fernando,

kernel test robot noticed the following build errors:

[auto build test ERROR on netfilter-nf/main]

url:    https://github.com/intel-lab-lkp/linux/commits/Fernando-Fernandez-Mancera/netfilter-synproxy-prevent-unbounded-recursion-in-transmit-path/20261103-135638
base:   https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git main
patch link:    https://lore.kernel.org/r/20261103125638.4667-1-fmancera%40suse.de
patch subject: [PATCH nf] netfilter: synproxy: prevent unbounded recursion in transmit path
config: s390-defconfig (https://download.01.org/0day-ci/archive/20261104/202611040824.Zozbyqd6-lkp@intel.com/config)
compiler: clang version 18.1.8 (https://github.com/llvm/llvm-project 3b5b5c1ec4a3095ab096dd780e84d7ab81f3d7ff)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261104/202611040824.Zozbyqd6-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202611040824.Zozbyqd6-lkp@intel.com/

All errors (new ones prefixed by >>):

>> net/netfilter/nf_synproxy_core.c:24:10: fatal error: 'net/netfilter/nf_recursion.h' file not found
      24 | #include <net/netfilter/nf_recursion.h>
         |          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   1 error generated.


vim +24 net/netfilter/nf_synproxy_core.c

    16	
    17	#include <net/netfilter/nf_conntrack.h>
    18	#include <net/netfilter/nf_conntrack_ecache.h>
    19	#include <net/netfilter/nf_conntrack_extend.h>
    20	#include <net/netfilter/nf_conntrack_seqadj.h>
    21	#include <net/netfilter/nf_conntrack_synproxy.h>
    22	#include <net/netfilter/nf_conntrack_zones.h>
    23	#include <net/netfilter/nf_synproxy.h>
  > 24	#include <net/netfilter/nf_recursion.h>
    25	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
