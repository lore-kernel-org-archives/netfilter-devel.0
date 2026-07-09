Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2380C319871
	for <netfilter-devel@vger.kernel.org>; Thu,  9 Jul 2026 10:15:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783592151; cv=none; b=cU5CGHBlQrWXXk/Yct6h/0/WWAlnjHftQX0MdY/X+uVdq11yHSLqA1mceKpfOKIDAbViKtHGnGLqGRTnwXpxqbzYNNrOi+vjri/Po1Ok75syopNThGMCPvVICxCoLwHa7VuOLFknItY9jio9aKKAMWi2RWVIMtInCQQMD5Xmfa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783592151; c=relaxed/simple;
	bh=PUPMF2ROAdUKBpJzssA4g3N3uXtp5fOb4P0ADsjWl4Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KAPI/sy6JeLhT8Woi6lipzKSTR+SiExZ2wpJr6ZpK0pzFrOs9OHaf/t7oBmbhkTddX67KvA68yK7De428RzOX76wX3CxuVwdrNdamwm2QweAEiOfsNWlu1wYQ38ItCX3LHMBPDoN5mYHZSGxjc9y/7K0BFVHitCHGb4QeQItJxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 28E1060293; Thu, 09 Jul 2026 12:15:44 +0200 (CEST)
Date: Thu, 9 Jul 2026 12:15:43 +0200
From: Florian Westphal <fw@strlen.de>
To: Jozsef Kadlecsik <kadlec@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [netfilter-nf:testing 11/20]
 net/netfilter/ipset/ip_set_hash_gen.h:379:21: warning: result of comparison
 of constant -1 with expression of type 'u8' (aka 'unsigned char') is always
 false
Message-ID: <ak90z1152DRq1AIh@strlen.de>
References: <202607081250.ODagxDyb-lkp@intel.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202607081250.ODagxDyb-lkp@intel.com>

kernel test robot <lkp@intel.com> wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git testing
> head:   c2fbcb9151957c3d921a7441cf080e49eb13b05d
> commit: a900abcb974bae821a5d4ae79ad3442808915416 [11/20] netfilter: ipset: rework cidr bookkeeping
> config: x86_64-rhel-9.4-rust (https://download.01.org/0day-ci/archive/20260708/202607081250.ODagxDyb-lkp@intel.com/config)
> compiler: clang version 22.1.8 (https://github.com/llvm/llvm-project ca7933e47d3a3451d81e72ac174dcb5aa28b59d1)
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260708/202607081250.ODagxDyb-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202607081250.ODagxDyb-lkp@intel.com/
> 
> All warnings (new ones prefixed by >>):
> 
>    In file included from net/netfilter/ipset/ip_set_hash_ipportnet.c:131:
> >> net/netfilter/ipset/ip_set_hash_gen.h:379:21: warning: result of comparison of constant -1 with expression of type 'u8' (aka 'unsigned char') is always false [-Wtautological-constant-out-of-range-compare]
>      379 |         if (unlikely(found == -1))
>          |                      ~~~~~ ^  ~~
>    include/linux/compiler.h:77:42: note: expanded from macro 'unlikely'
>       77 | # define unlikely(x)    __builtin_expect(!!(x), 0)
>          |                                             ^
>    In file included from net/netfilter/ipset/ip_set_hash_ipportnet.c:391:
> >> net/netfilter/ipset/ip_set_hash_gen.h:379:21: warning: result of comparison of constant -1 with expression of type 'u8' (aka 'unsigned char') is always false [-Wtautological-constant-out-of-range-compare]
>      379 |         if (unlikely(found == -1))
>          |                      ~~~~~ ^  ~~
>    include/linux/compiler.h:77:42: note: expanded from macro 'unlikely'
>       77 | # define unlikely(x)    __builtin_expect(!!(x), 0)
>          |                                             ^
>    2 warnings generated.

FYI, I removed this patch from the batch that I sent to net tree.
