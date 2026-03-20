Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0397F3D6CDC
	for <netfilter-devel@vger.kernel.org>; Fri, 20 Mar 2026 23:41:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774050099; cv=none; b=SZDuV2IvC0aHF9yN0AOP1ef5UNsW3Ci1/i3xyE/BfKxr5jc6RoOukwnKDqfFl9lCuCtHd6ZE4mG7jeYRTBN0q9IUmHOGGoYT1b5WStDLiHi4w67KRBx5KaLNxSST4ilsfmxAgdIjWik1R/V5XYbl8vgD2PjegkDjAE8/mLJLabc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774050099; c=relaxed/simple;
	bh=RG9m+65KizErNcRPnwlear+XqjWWhOlzutl7dui2VKQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tGGAHXbfjOIAwr6KGDltQ0lMOxVq1NWrF3/OVFD5C7dzdbjw8Lu4REvXzUEVnERUs5I/05TA/uJGvSO7ip4g1PwbQb3WTa27/ysHKHMBzC36dkd0PRvW9RMkbhORkwT9piAoHuORlMFM9OrvBeBd91x63iMHiZtH0A17ORWg2Tg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=JBEZ7Rlw; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="JBEZ7Rlw"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 9428560179;
	Sat, 21 Mar 2026 00:41:34 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1774050094;
	bh=1zoNO2+dd9iMlnu8/rlTv2CJ/d6qkMTurzEVuMvS04k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JBEZ7RlwZc1VzV8SLgdJ4gJUeVPcl58tfzSirDWwDSo2mPeIhnwls6cdlsn8Scq/i
	 zTnZg6Ovboo1VUajJIEv2vGMFCzVatQf2ijIRzP3YJiA/rqlwXlTnDujh/w5BxP0Lo
	 YVHH3x/N024oHvWtaqutIEnnulsLZrEZjaod3Ynnx9NpBkgg/onxWRKNTUhh+xQXrf
	 URNafBIxdPnGeg3nGUQYL0I6v7MRUgL0p9AmAYdmNT7UqYbdTuHtti/pOzwvmjXd2I
	 Pw4exeqx1nDMXVndKm50QIyKyjx8GJGMCWgM6G03Ydwvz/labl1XNM5SLJxReCQxWt
	 QbjzEyh/xlaYA==
Date: Sat, 21 Mar 2026 00:41:32 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: kernel test robot <lkp@intel.com>
Cc: oe-kbuild-all@lists.linux.dev, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, Florian Westphal <fw@strlen.de>
Subject: Re: [netfilter-nf:testing 7/9] net/sched/act_connmark.c:98:12:
 error: invalid storage class for function 'tcf_connmark_init'
Message-ID: <ab3bLEaBd1-QyZSX@chamomile>
References: <202603201919.Sx7L8wtQ-lkp@intel.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <202603201919.Sx7L8wtQ-lkp@intel.com>

Hi,

On Fri, Mar 20, 2026 at 08:07:57PM +0100, kernel test robot wrote:
> All error/warnings (new ones prefixed by >>):
> 
>    In file included from net/sched/act_connmark.c:26:
>    include/net/netfilter/nf_conntrack_core.h: In function 'lockdep_nfct_expect_lock_not_held':
>    include/net/netfilter/nf_conntrack_core.h:111: error: unterminated argument list invoking macro "WARN_ON_ONCE"
>      111 | #endif /* _NF_CONNTRACK_CORE_H */
>    include/net/netfilter/nf_conntrack_core.h:90:17: error: 'WARN_ON_ONCE' undeclared (first use in this function)
>       90 |                 WARN_ON_ONCE(lockdep_is_held(&nf_conntrack_expect_lock);
>          |                 ^~~~~~~~~~~~

I will follow up to address this lockdep issue asap.
