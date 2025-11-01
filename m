Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E78CC26CE2E;
	Sat,  1 Nov 2025 04:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761969857; cv=none; b=YHmcZpEsTWuAVxuN33K/Jm2pMmhToWDsIAPOW029gmCCLkhqZwydjw9FAppvmPZx29QY6IGsd3NjbuaecgW6dPCRMH4S3JnfZcTG1/Arq8EEJKDiQzPksl+//xRbLbDOve+cC0Og+IpmIvVXMPygALOvZP19u/6+LrhapEFyIsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761969857; c=relaxed/simple;
	bh=+06dwvzshapU/FsXZklgruPzCGBFbLFbTd1DiaDxtSc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XDslNVi+C8JN3DKwVPQjaHQyJn+F/q79WJOFPn5Lx3Eg6+77Nk879a7zayqBnN4rlWCUCxK+r0olFY2hWJaOerpEqmG/6o+CBOw5AzeiteeSoXMRKymYyCqwqb/EJebE6P1pP8eGESutU3zJMjgwg/C4jZ3q6j2VdglCK/k4S/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RdiHz/ju; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RdiHz/ju"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761969854; x=1793505854;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=+06dwvzshapU/FsXZklgruPzCGBFbLFbTd1DiaDxtSc=;
  b=RdiHz/juus//8cfjZMwq2Wy96ASyNQDtPD383HbZPhbTEM5aH8x/0dca
   4Nne3+hIIZsrbr2AezY201TwwCHOVg8O2Sm4/h2B05qEYMRGTDtngE9J4
   G4OdhX0oN3Hxj2QNpxqRg8SehDWyguQioBM9n8fvL8scAl+bHFXUpQXQZ
   5Gsg4HiRs5bXItXFivelNFaQyHVD/unC5Wh/peHfEe3J4BJUf3tWkHtGG
   biEakdaMVogfkj0+ayUaxZRXRj1ezEBMWEM9IBFd8sK2K23/YsNe7GKOc
   CvD+PXt5iZGFf8Fvezz/9PKNJ9OEAZ3aqnbTeN7qKdgqxCFCw1284JRnV
   g==;
X-CSE-ConnectionGUID: ss3EbAv8QWSxohDQRBS3Mg==
X-CSE-MsgGUID: Jry4pUs9TIi5yE7BoFDxrA==
X-IronPort-AV: E=McAfee;i="6800,10657,11599"; a="63336063"
X-IronPort-AV: E=Sophos;i="6.19,271,1754982000"; 
   d="scan'208";a="63336063"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2025 21:04:13 -0700
X-CSE-ConnectionGUID: A7zAVQ6JSDSpEQhsipyv2w==
X-CSE-MsgGUID: 7l2A/wjCQyKRaxhB7bOolw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,271,1754982000"; 
   d="scan'208";a="191537965"
Received: from lkp-server02.sh.intel.com (HELO 66d7546c76b2) ([10.239.97.151])
  by orviesa005.jf.intel.com with ESMTP; 31 Oct 2025 21:04:11 -0700
Received: from kbuild by 66d7546c76b2 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vF2qV-000NuG-2z;
	Sat, 01 Nov 2025 04:04:07 +0000
Date: Sat, 1 Nov 2025 12:03:16 +0800
From: kernel test robot <lkp@intel.com>
To: Ricardo Robaina <rrobaina@redhat.com>, audit@vger.kernel.org,
	linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org
Cc: oe-kbuild-all@lists.linux.dev, paul@paul-moore.com, eparis@redhat.com,
	fw@strlen.de, pablo@netfilter.org, kadlec@netfilter.org,
	Ricardo Robaina <rrobaina@redhat.com>
Subject: Re: [PATCH v4 2/2] audit: include source and destination ports to
 NETFILTER_PKT
Message-ID: <202511011146.aPtw8SOn-lkp@intel.com>
References: <6ac2baf0d5ae176cbd3279a4dff9e2c7750c6d45.1761918165.git.rrobaina@redhat.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6ac2baf0d5ae176cbd3279a4dff9e2c7750c6d45.1761918165.git.rrobaina@redhat.com>

Hi Ricardo,

kernel test robot noticed the following build errors:

[auto build test ERROR on pcmoore-audit/next]
[also build test ERROR on netfilter-nf/main nf-next/master linus/master v6.18-rc3 next-20251031]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Ricardo-Robaina/audit-add-audit_log_packet_ip4-and-audit_log_packet_ip6-helper-functions/20251031-220605
base:   https://git.kernel.org/pub/scm/linux/kernel/git/pcmoore/audit.git next
patch link:    https://lore.kernel.org/r/6ac2baf0d5ae176cbd3279a4dff9e2c7750c6d45.1761918165.git.rrobaina%40redhat.com
patch subject: [PATCH v4 2/2] audit: include source and destination ports to NETFILTER_PKT
config: arc-randconfig-002-20251101 (https://download.01.org/0day-ci/archive/20251101/202511011146.aPtw8SOn-lkp@intel.com/config)
compiler: arc-linux-gcc (GCC) 8.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251101/202511011146.aPtw8SOn-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202511011146.aPtw8SOn-lkp@intel.com/

All errors (new ones prefixed by >>):

   kernel/audit.c: In function 'audit_log_packet_ip4':
>> kernel/audit.c:2555:3: error: a label can only be part of a statement and a declaration is not a statement
      struct tcphdr _tcph;
      ^~~~~~
>> kernel/audit.c:2556:3: error: expected expression before 'const'
      const struct tcphdr *th;
      ^~~~~
>> kernel/audit.c:2558:3: error: 'th' undeclared (first use in this function); did you mean 'ih'?
      th = skb_header_pointer(skb, skb_transport_offset(skb), sizeof(_tcph), &_tcph);
      ^~
      ih
   kernel/audit.c:2558:3: note: each undeclared identifier is reported only once for each function it appears in
   kernel/audit.c:2568:3: error: a label can only be part of a statement and a declaration is not a statement
      struct udphdr _udph;
      ^~~~~~
   kernel/audit.c:2569:3: error: expected expression before 'const'
      const struct udphdr *uh;
      ^~~~~
>> kernel/audit.c:2571:3: error: 'uh' undeclared (first use in this function); did you mean 'ih'?
      uh = skb_header_pointer(skb, skb_transport_offset(skb), sizeof(_udph), &_udph);
      ^~
      ih
   kernel/audit.c:2580:3: error: a label can only be part of a statement and a declaration is not a statement
      struct sctphdr _sctph;
      ^~~~~~
   kernel/audit.c:2581:3: error: expected expression before 'const'
      const struct sctphdr *sh;
      ^~~~~
>> kernel/audit.c:2583:3: error: 'sh' undeclared (first use in this function); did you mean 'ih'?
      sh = skb_header_pointer(skb, skb_transport_offset(skb), sizeof(_sctph), &_sctph);
      ^~
      ih
   kernel/audit.c: In function 'audit_log_packet_ip6':
   kernel/audit.c:2616:3: error: a label can only be part of a statement and a declaration is not a statement
      struct tcphdr _tcph;
      ^~~~~~
   kernel/audit.c:2617:3: error: expected expression before 'const'
      const struct tcphdr *th;
      ^~~~~
   kernel/audit.c:2619:3: error: 'th' undeclared (first use in this function); did you mean 'ih'?
      th = skb_header_pointer(skb, skb_transport_offset(skb), sizeof(_tcph), &_tcph);
      ^~
      ih
   kernel/audit.c:2629:3: error: a label can only be part of a statement and a declaration is not a statement
      struct udphdr _udph;
      ^~~~~~
   kernel/audit.c:2630:3: error: expected expression before 'const'
      const struct udphdr *uh;
      ^~~~~
   kernel/audit.c:2632:3: error: 'uh' undeclared (first use in this function); did you mean 'ih'?
      uh = skb_header_pointer(skb, skb_transport_offset(skb), sizeof(_udph), &_udph);
      ^~
      ih
   kernel/audit.c:2641:3: error: a label can only be part of a statement and a declaration is not a statement
      struct sctphdr _sctph;
      ^~~~~~
   kernel/audit.c:2642:3: error: expected expression before 'const'
      const struct sctphdr *sh;
      ^~~~~
   kernel/audit.c:2644:3: error: 'sh' undeclared (first use in this function); did you mean 'ih'?
      sh = skb_header_pointer(skb, skb_transport_offset(skb), sizeof(_sctph), &_sctph);
      ^~
      ih


vim +2555 kernel/audit.c

  2543	
  2544	bool audit_log_packet_ip4(struct audit_buffer *ab, struct sk_buff *skb)
  2545	{
  2546		struct iphdr _iph;
  2547		const struct iphdr *ih;
  2548	
  2549		ih = skb_header_pointer(skb, skb_network_offset(skb), sizeof(_iph), &_iph);
  2550		if (!ih)
  2551			return false;
  2552	
  2553		switch (ih->protocol) {
  2554		case IPPROTO_TCP:
> 2555			struct tcphdr _tcph;
> 2556			const struct tcphdr *th;
  2557	
> 2558			th = skb_header_pointer(skb, skb_transport_offset(skb), sizeof(_tcph), &_tcph);
  2559			if (!th)
  2560				return false;
  2561	
  2562			audit_log_format(ab, " saddr=%pI4 daddr=%pI4 proto=%hhu sport=%hu dport=%hu",
  2563					 &ih->saddr, &ih->daddr, ih->protocol,
  2564					 ntohs(th->source), ntohs(th->dest));
  2565			break;
  2566		case IPPROTO_UDP:
  2567		case IPPROTO_UDPLITE:
  2568			struct udphdr _udph;
  2569			const struct udphdr *uh;
  2570	
> 2571			uh = skb_header_pointer(skb, skb_transport_offset(skb), sizeof(_udph), &_udph);
  2572			if (!uh)
  2573				return false;
  2574	
  2575			audit_log_format(ab, " saddr=%pI4 daddr=%pI4 proto=%hhu sport=%hu dport=%hu",
  2576					 &ih->saddr, &ih->daddr, ih->protocol,
  2577					 ntohs(uh->source), ntohs(uh->dest));
  2578			break;
  2579		case IPPROTO_SCTP:
  2580			struct sctphdr _sctph;
  2581			const struct sctphdr *sh;
  2582	
> 2583			sh = skb_header_pointer(skb, skb_transport_offset(skb), sizeof(_sctph), &_sctph);
  2584			if (!sh)
  2585				return false;
  2586	
  2587			audit_log_format(ab, " saddr=%pI4 daddr=%pI4 proto=%hhu sport=%hu dport=%hu",
  2588					 &ih->saddr, &ih->daddr, ih->protocol,
  2589					 ntohs(sh->source), ntohs(sh->dest));
  2590			break;
  2591		default:
  2592			audit_log_format(ab, " saddr=%pI4 daddr=%pI4 proto=%hhu",
  2593					 &ih->saddr, &ih->daddr, ih->protocol);
  2594		}
  2595	
  2596		return true;
  2597	}
  2598	EXPORT_SYMBOL(audit_log_packet_ip4);
  2599	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
