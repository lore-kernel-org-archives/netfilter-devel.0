Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18E3625290D
	for <netfilter-devel@vger.kernel.org>; Wed, 26 Mar 2025 19:23:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743017029; cv=none; b=O3/3Zi2g3O6algVVZ9HcKZIdjy0PmyfkGczbTBgyz7aqcsY+os76GhIZLSULhVnTsPcdqMUO7L/L6t6Vr3UMKypMbn7CkGSYWBDR8/xD0g75/ew6yp1sV6JEmqxWyzH1l9LWwiyAYChZhZcYzaDpPWx2On6+hBgTqAyUVrLx3ek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743017029; c=relaxed/simple;
	bh=7jnwtPCf2qe1UxFgsWP9cIeydcIoXL6VhC1nIqXf1BM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qvlE4SVMVrXlaUiRs+pM3FvQMwnfR5NG3WGuCETXV3lDK4fsc/K5NXHoegjSFiVlzvgtN3hvv6VTGxs3OT6fRay7C+uRlaidqMIKo5r0hrRYSsicOb07RCY9SiIhoAM6LFNbZBe9YTRBeXQ99BskMF46nRWOw5/SXtsWJhLh2k0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1txWLn-0000hL-P5; Wed, 26 Mar 2025 20:23:43 +0100
Date: Wed, 26 Mar 2025 20:23:43 +0100
From: Florian Westphal <fw@strlen.de>
To: Corubba Smith <corubba@gmx.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH ulogd2,v2 1/4] ulogd: add linux namespace helper
Message-ID: <20250326192343.GA2205@breakpoint.cc>
References: <c5cd1c3a-3875-4352-8181-5081103f96f6@gmx.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c5cd1c3a-3875-4352-8181-5081103f96f6@gmx.de>
User-Agent: Mutt/1.10.1 (2018-07-13)

Corubba Smith <corubba@gmx.de> wrote:
> The new namespace helper provides an internal stable interface for
> plugins to use for switching various linux namespaces. Currently only
> network namespaces are supported/implemented, but can easily be extended
> if needed. autoconf will enable it automatically if the required symbols
> are available. If ulogd is compiled without namespace support, the
> functions will simply return an error, there is no need for conditional
> compilation or special handling in plugin code.
> 
> Signed-off-by: Corubba Smith <corubba@gmx.de>

Looks good to me, I intend to apply this later this week unless
there are objections.

>     and NFACCT plugins. I skipped ULOG because it's removed from the
>     kernel since 7200135bc1e6 ("netfilter: kill ulog targets") aka v3.17

Yeah, ULOG code should just be axed, there is no point in carrying this
in the tree anymore.

> --- a/src/Makefile.am
> +++ b/src/Makefile.am
> @@ -6,6 +6,7 @@ AM_CPPFLAGS += -DULOGD_CONFIGFILE='"$(sysconfdir)/ulogd.conf"' \
> 
>  sbin_PROGRAMS = ulogd
> 
> -ulogd_SOURCES = ulogd.c select.c timer.c rbtree.c conffile.c hash.c addr.c
> +ulogd_SOURCES = ulogd.c select.c timer.c rbtree.c conffile.c hash.c \
> +                addr.c namespace.c
>  ulogd_LDADD   = ${libdl_LIBS} ${libpthread_LIBS}
>  ulogd_LDFLAGS = -export-dynamic
> diff --git a/src/namespace.c b/src/namespace.c
> new file mode 100644
> index 0000000..f9f23d4
> --- /dev/null
> +++ b/src/namespace.c
> @@ -0,0 +1,237 @@
> +/* namespace helper
> + *
> + * userspace logging daemon for the netfilter subsystem
> + *
> + * (C) 2025 The netfilter project
> + *
> + *  This program is free software; you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License version 2
> + *  as published by the Free Software Foundation.

I intend to replace all of this with

/* SPDX-License-Identifier: GPL-2.0 */

No need for license boilerplate, IMO.
