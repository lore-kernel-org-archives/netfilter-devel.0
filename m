Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.8
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793771194;
	b=kvxV8Gz+aiRsiXtqiRPw2s8Vd0XGPYD2z6+d7J+YFEj5gSO4W1M7s/9/NtdzPKpMLaqN
	 szRDdYG9vRTcRmFqN3lSJ4bjYe5ur3HNHk1hT72VvgkspbDhxPLPx6Og79raSk6+VxnAG
	 dIOcToylo85r4n1PQFUWxZMPhZE5rISvkTirJl0q8EOTESgPEVZt2xbAWtFBIrPl2VrZH
	 YA9NJad2mNxZSz0L/pDDazFpNz1d1fFoAElLnSiZemUJz8N67vbihTY8opyE+WhcGnpkP
	 pO/vSYbBSdzE3ibXqh0e20T7llz4xt66b8R3sPimokPu0GHSDy+uMmP3zEGZMtt8OnA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793771194;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Date:From:To:
	 Cc:Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=ALKW+m44fAiyC37sUwJTPfNcb+dgH1kvoHtEoKQd/UU=;
	b=5JhKOC/Hk9SHTmIWVTs9gdW/ePEO/gzsEiAjXDMU1CDTJanjEwiZ/gz3dYPguOIZWIOU
	 gbA6DRu+tznBMEXx05aJqKo6RFZDg4PLq/9BXOGRhy70twZlhxZAQrU07ecMR5k8HM9gl
	 l8XFL//PkdylTDD78+o+vyxMSWNHaetrQBghW50ED3zZ8DrEu1CC/rmMlP/lPmK8UOU48
	 lpCeJW1PdL2jBMAsT2NZfIlKX7CE4i2PN6QW0Y7ipU33grp2zI/y25hTi/tCs7HaY2L8F
	 GkwihKz0u2Z+Z0BcVS9Vme25qWOiFr5t2YO3GXRoJlK9fPKdPQ6fZU7Q+s1TcLPA/XA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=JpQ2OlBU;
	arc=none smtp.remote-ip=192.198.163.8
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B937606A331
	for <netfilter-devel@vger.kernel.org>; Wed,  4 Nov 2026 05:46:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6B937606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=JpQ2OlBU
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793771194; x=1825307194;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Mk62jaZ2ayTsTTIc+7nR7H6Khoyr50XODENsIf16K4A=;
  b=JpQ2OlBUk69twhWJm/mW1pub8DaJT3PIX6xBVtL2GN0bMVoxbLUxKodj
   mcQ12Z5IWXMO3f7/vRmpjZaxU0wAXxXUmCvQqK8P7Wn4GuBn9vvqhi9FG
   IFSDfZPWqIIPEC7EqVUI2ohIt6zrxk7iOEeRKV6svrZ566a7jhFQanXos
   OTsBB3nrQQdg2fI0AarSvKDYSDljJYjdqHLHue/Xp0FrqIA14RKXORMgY
   kIIEPFWOYYBe8QYyPs89bcge04EBRNabyKNpp1zBJ14cxKduaPxvvjy5+
   Q4Rca/EjxF1KSelYIAmg06bc5oDnTXgY3vDtzlS8eump1ZMQNwkHMMAXk
   A==;
X-CSE-ConnectionGUID: kfkFA/O/RwW85OCih4FDCA==
X-CSE-MsgGUID: 1jSEBv6nTJOnsq7leQFxew==
X-IronPort-AV: E=McAfee;i="6800,10657,11955"; a="2403417"
X-IronPort-AV: E=Sophos;i="6.27,194,1787036400"; 
   d="scan'208";a="2403417"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2026 21:46:33 -0800
X-CSE-ConnectionGUID: jT0U27Q/RUuNphOoINYBDw==
X-CSE-MsgGUID: DuphwukhSiOxYn8rmiM80A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,194,1787036400"; 
   d="scan'208";a="6729635"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by orviesa009.jf.intel.com with ESMTP; 03 Nov 2026 21:46:31 -0800
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xOTpL-00000000jpj-0uyv;
	Wed, 04 Nov 2026 05:46:27 +0000
Date: Wed, 4 Nov 2026 13:46:21 +0800
From: kernel test robot <lkp@intel.com>
To: Fernando Fernandez Mancera <fmancera@suse.de>,
	netfilter-devel@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, coreteam@netfilter.org, phil@nwl.cc,
	fw@strlen.de, pablo@netfilter.org,
	Fernando Fernandez Mancera <fmancera@suse.de>
Subject: Re: [PATCH nf] netfilter: synproxy: prevent unbounded recursion in
 transmit path
Message-ID: <202611041332.BDDaWwCF-lkp@intel.com>
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
config: sh-allyesconfig (https://download.01.org/0day-ci/archive/20261104/202611041332.BDDaWwCF-lkp@intel.com/config)
compiler: sh4-linux-gcc (GCC) 16.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261104/202611041332.BDDaWwCF-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202611041332.BDDaWwCF-lkp@intel.com/

All errors (new ones prefixed by >>):

>> net/netfilter/nf_synproxy_core.c:24:10: fatal error: net/netfilter/nf_recursion.h: No such file or directory
      24 | #include <net/netfilter/nf_recursion.h>
         |          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   compilation terminated.


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
