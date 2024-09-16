Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E5781586DB;
	Mon, 16 Sep 2024 15:29:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726500594; cv=none; b=mUGusZvEjkpcjRXLwVE525P+8HRGQM1eVYQcjA78nz3M/0hzPg9J9zXt1X6t+Tk+B3cWWt8iST4cYPUPY9h9PFS2sy1ECM2SdTo+wceTIPu6piduj8/oUpNA+Be0b4ddGBt6bOfcy0MIC7UDOZK2iLUAE36xnfH8kJ8twCsfSHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726500594; c=relaxed/simple;
	bh=MlnJdle5JwKPzYjLf3phw0YvyewBny+20yGfy84n/EI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cmSgRAhD9iu62HQove6DI/8NcIraLzOvLjmqto+sGawWlWOTc0FDSRa+3NOAQJ5h1eX6i0E0Y9pydMRyO28Vtu1/06T8hJJZkeq3ip//NUCedqAmDvo1R4k99q9j45SQ0aaALVWCnh/F2qjpElHeVcHBW8Jcu8sJOAJ+/8tVKpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TJX5wm9J; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TJX5wm9J"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726500592; x=1758036592;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=MlnJdle5JwKPzYjLf3phw0YvyewBny+20yGfy84n/EI=;
  b=TJX5wm9JVddMpmUtMtcYS3YncCO2JSU0aGoILVua3bZA5w035vKnufp4
   OrvU9IUJDbnx1aj3P1lmv4Ey6nrhu5zm91KVC+ZtCqA/h9tzfG8QknAAT
   FNnJgnMNC0rpwAtyR1nROZvyf0+h3f1VIO6zH4Ch4kTAzjJyES8d7g4O5
   GPmPYRJRrid6UDDdAfqgpeJimc+rMcCKOkAF89ySbPsVzY940tsZPKviN
   8NvQ/CeW6TNWKpDyKEdGYa25Qnnr026o2Qspew8LvT5LdSreu99p2uvwa
   NV9pwWtT3SyDCaezx+GwjmWBq+dogO3y2rZ8XhYzf9O9r1KktHlL+rc/E
   A==;
X-CSE-ConnectionGUID: uNqZllVZTyungdDHAfA5Pg==
X-CSE-MsgGUID: lI4yKvhnQziKcCsBEZoatw==
X-IronPort-AV: E=McAfee;i="6700,10204,11197"; a="24812896"
X-IronPort-AV: E=Sophos;i="6.10,233,1719903600"; 
   d="scan'208";a="24812896"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2024 08:29:52 -0700
X-CSE-ConnectionGUID: MF6XvnWnTKWSy4D6QideRA==
X-CSE-MsgGUID: eqncptBnTvKZCtJUhIJFtQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,233,1719903600"; 
   d="scan'208";a="73729904"
Received: from smile.fi.intel.com ([10.237.72.54])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2024 08:29:48 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.98)
	(envelope-from <andriy.shevchenko@linux.intel.com>)
	id 1sqDfd-00000009VX1-1xi6;
	Mon, 16 Sep 2024 18:29:45 +0300
Date: Mon, 16 Sep 2024 18:29:45 +0300
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Simon Horman <horms@kernel.org>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, llvm@lists.linux.dev
Subject: Re: [PATCH nf-next 0/2] netfilter: conntrack: label helpers
 conditional compilation updates
Message-ID: <ZuhO6XRAS0Qq3A1g@smile.fi.intel.com>
References: <20240916-ct-ifdef-v1-0-81ef1798143b@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240916-ct-ifdef-v1-0-81ef1798143b@kernel.org>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo

On Mon, Sep 16, 2024 at 04:14:40PM +0100, Simon Horman wrote:
> Hi,
> 
> This short series updates conditional compilation of label helpers to:
> 
> 1) Compile them regardless of if CONFIG_NF_CONNTRACK_LABELS is enabled
>    or not. It is safe to do so as the functions will always return 0 if
>    CONFIG_NF_CONNTRACK_LABELS is not enabled.  And the compiler should
>    optimise waway the code.  Which is the desired behaviour.
> 
> 2) Only compile ctnetlink_label_size if CONFIG_NF_CONNTRACK_EVENTS is
>    enabled.  This addresses a warning about this function being unused
>    in this case.

Both make sense to me, FWIW,
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

-- 
With Best Regards,
Andy Shevchenko


