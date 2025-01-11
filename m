Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C40A9B661
	for <netfilter-devel@vger.kernel.org>; Sat, 11 Jan 2025 13:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736603856; cv=none; b=BpjoIQzST0XzWSTif01FjGFEb7OpsL9sLTj02pSfjcq8zhEsm8HGb/eFPYNZoKgK+IWMsvmbRz8OneMZOwmzlkhmgRUudtG//cpIl+rWX1hfgjIR20Rd7tnt0MBrj+nk8mqlqss6wRpo/QlE35kVlRSCHxjcIjVwaP5MFCRiAjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736603856; c=relaxed/simple;
	bh=5EcrrivuHklqFOy93jvzRxl0sKiYdh4X98c7L1a+C4w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QKHbkNDItzJqkux37ABirI1kwht8QidlXUhBaQgLdmh8KmKDxoEIiIRy2JdABH7NvrwadY5FJ9lxiMeesgyMEWmjPC3gvD/u109Owz8rpCZD5kg55RsrPA9jLMGE1uEGQxmFP4ybWYepajXiPa2+BP6k9TzN65ghmZaZQvrm7sE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Date: Sat, 11 Jan 2025 14:57:23 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Maciej =?utf-8?Q?=C5=BBenczykowski?= <zenczykowski@gmail.com>
Cc: Netfilter Development Mailinglist <netfilter-devel@vger.kernel.org>,
	Florian Westphal <fw@strlen.de>
Subject: Re: Android boot failure with 6.12
Message-ID: <Z4J4wyhmYaSgBmnG@calendula>
References: <CAHo-OozVuh4wbTHLxM2Y2+qgQqHTwcmhAfeFOM9W8thqzz6gdg@mail.gmail.com>
 <CAHo-OozPA7Z9pwBgEA3whh_e3NBhVi1D7EC4EXjNJdVHYNToKg@mail.gmail.com>
 <CAHo-Ooz-_idiFe4RD8DtbojKJFEa1N-pdA8pdwUPLJTp7iwGhw@mail.gmail.com>
 <CAHo-OozUg4UWvaP-FtHL44mygWwsnGO_eeFREhHddf=cc2-+ww@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHo-OozUg4UWvaP-FtHL44mygWwsnGO_eeFREhHddf=cc2-+ww@mail.gmail.com>

On Fri, Jan 10, 2025 at 02:36:56PM -0800, Maciej Żenczykowski wrote:
> nvm - https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/net/netfilter/xt_mark.c?id=306ed1728e8438caed30332e1ab46b28c25fe3d8

Yes, 306ed1728e8438ca is the follow up fix you need:

commit 306ed1728e8438caed30332e1ab46b28c25fe3d8
Author: Pablo Neira Ayuso <pablo@netfilter.org>
Date:   Sun Oct 20 14:49:51 2024 +0200

    netfilter: xtables: fix typo causing some targets not to load on IPv6
    
    - There is no NFPROTO_IPV6 family for mark and NFLOG.
    - TRACE is also missing module autoload with NFPROTO_IPV6.
    
    This results in ip6tables failing to restore a ruleset. This issue has been
    reported by several users providing incomplete patches.
    
    Very similar to Ilya Katsnelson's patch including a missing chunk in the
    TRACE extension.

Thanks.
