Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 396F62F2357
	for <netfilter-devel@vger.kernel.org>; Wed, 16 Jul 2025 10:01:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752660121; cv=none; b=fk2l1NH7TAjA/qqNDXHeGz/qIALSWTX14Yvi4VQNZ0uT6wcCxrG9aoT2kQSAQIfApuUQg6zS1rKZtWHtImavZjBCRzQvpklelyTnRxxngPAErW9x9vGv2vA6CJ3FBqnxbxZfOW9nPuNQzhOz9Tlj7myV2BE91A2HqR0/PkuK230=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752660121; c=relaxed/simple;
	bh=2ZnRVNtrVccs04D0sUHhLSWBvEKVN68fKD5QTL/Q6SU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q614OCspqICG3px1M7L7PAl0mqzhu9Hg8GOj2gjqwhVm0k6NlCi9vAmChzwQnUgjzj7mT7rGit4U9UeEcU+rRGSFKXYaLPJafZjFP41pa3Th1oTK79t2sJOPIFkv/lHsMDSf6nynQS42yoAcpc7gRedm4AOSpRP2S/ummhrqISc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=CEk9Z+Bd; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="CEk9Z+Bd"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=l+iHmzteCzcFj4NoS6JwHpgZLsu7q3hWfXua2UJcRSc=; b=CEk9Z+BdTaHog1IlT4N0pG3QYB
	fF6BjSEPLbo02dAocS7GMv2wry4n9VrzA356FU2qljkNCo8hOCGJ3S8ifvaqrqyrbzzDuBE1TX3C/
	hMqNHRPkZP77oJaryMy/bG8SbpOzhwz1oiOg5sY8IkllfL4Up6iuAISXzN+yzu39ULAofAblnRPNt
	2MAB/dIkjBEWV1cgWVXpAMV3vPAWqUMj6k+GfJw3shdRObhNiasvORVRWwyWCqzUwBJLeUYukhpHW
	7hFv/t03vIPfizcfrCuGOmJXxk+CSRi5jBGtAT4hiM0TWRaSjVyzMvRC3MVYZOKZhwMnj1dTPSbhZ
	JsAGs0vg==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1ubyxX-000000001DM-35wv;
	Wed, 16 Jul 2025 12:01:55 +0200
Date: Wed, 16 Jul 2025 12:01:55 +0200
From: Phil Sutter <phil@nwl.cc>
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Subject: Re: [libnftnl PATCH v2] utils: Add helpers for interface name
 wildcards
Message-ID: <aHd4k3kkCfI2o4NV@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20250715151526.14573-1-phil@nwl.cc>
 <aHd0mxVSp_cFcn16@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aHd0mxVSp_cFcn16@strlen.de>

Hi,

On Wed, Jul 16, 2025 at 11:44:59AM +0200, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> >  #include <string.h>
> >  #include <stdlib.h>
> > +#include <libmnl/libmnl.h>
> 
> Why is this include needed?

Because of:

| In file included from udata.c:9:
| ../include/utils.h:88:40: warning: 'struct nlattr' declared inside parameter list will not be visible outside of this definition or declaration
|    88 | const char *mnl_attr_get_ifname(struct nlattr *attr);
|       |                                        ^~~~~~

> >  #include <libnftnl/common.h>
> >  
> >  #include "config.h"
> > @@ -83,4 +84,7 @@ int nftnl_fprintf(FILE *fpconst, const void *obj, uint32_t cmd, uint32_t type,
> >  int nftnl_set_str_attr(const char **dptr, uint32_t *flags,
> >  		       uint16_t attr, const void *data, uint32_t data_len);
> >  
> > +void mnl_attr_put_ifname(struct nlmsghdr *nlh, int attr, const char *ifname);
> > +const char *mnl_attr_get_ifname(struct nlattr *attr);
> > +
> 
> nftnl_attr_put_ifname, nftnl_attr_get_ifname?
> Using mnl_ prefix seems wrong, that should be reserved for libmnl.

I chose the prefix since they 1:1 replace calls to mnl_attr_put_strz() and
mnl_attr_get_str(). You're right, since they are implemented by libnftnl the
prefix is wrong. I was a bit undecided whether to put them into libmnl, but
they are a bit too specific for that. Will fix the prefix and respin!

Thanks, Phil
