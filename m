Received: from pepin.polanet.pl (pepin.polanet.pl [193.34.52.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E027129EF9
	for <netfilter-devel@vger.kernel.org>; Mon, 18 Dec 2023 13:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=polanet.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=polanet.pl
Date: Mon, 18 Dec 2023 14:29:28 +0100
From: Tomasz Pala <gotar@polanet.pl>
To: Samuel Marks <samuelmarks@gmail.com>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: PATCH [netfilter] Remove old case sensitive variants of
 lowercase .c and .h files
Message-ID: <20231218132928.GA5123@polanet.pl>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)

The net/netfilter/Makefile is also case-sensitive and obsoleted,
is there any reason you've left it not cleaned up?

On Sat, Dec 16, 2023 at 19:22:46 +0000, Samuel Marks wrote:

> ---
> `git clone` fails on case-insensitive file systems, e.g., on Windows,
> MSYS, Cygwin due to case sensitive files. All but one are in
> netfilter, and they seem to be old code that isn't necessary.
> 
>  include/uapi/linux/netfilter/xt_CONNMARK.h  |   7 -
>  include/uapi/linux/netfilter/xt_DSCP.h      |  27 --
>  include/uapi/linux/netfilter/xt_MARK.h      |   7 -
>  include/uapi/linux/netfilter/xt_RATEEST.h   |  17 -
>  include/uapi/linux/netfilter/xt_TCPMSS.h    |  13 -
>  include/uapi/linux/netfilter_ipv4/ipt_ECN.h |  34 --
>  include/uapi/linux/netfilter_ipv4/ipt_TTL.h |  24 --
>  include/uapi/linux/netfilter_ipv6/ip6t_HL.h |  25 --
>  net/netfilter/Makefile                      |   4 -
>  net/netfilter/xt_DSCP.c                     | 161 ---------
>  net/netfilter/xt_HL.c                       | 159 ---------
>  net/netfilter/xt_RATEEST.c                  | 233 -------------
>  net/netfilter/xt_TCPMSS.c                   | 345 --------------------
>  13 files changed, 1056 deletions(-)
>  delete mode 100644 include/uapi/linux/netfilter/xt_CONNMARK.h
>  delete mode 100644 include/uapi/linux/netfilter/xt_DSCP.h
>  delete mode 100644 include/uapi/linux/netfilter/xt_MARK.h
>  delete mode 100644 include/uapi/linux/netfilter/xt_RATEEST.h
>  delete mode 100644 include/uapi/linux/netfilter/xt_TCPMSS.h
>  delete mode 100644 include/uapi/linux/netfilter_ipv4/ipt_ECN.h
>  delete mode 100644 include/uapi/linux/netfilter_ipv4/ipt_TTL.h
>  delete mode 100644 include/uapi/linux/netfilter_ipv6/ip6t_HL.h
>  delete mode 100644 net/netfilter/xt_DSCP.c
>  delete mode 100644 net/netfilter/xt_HL.c
>  delete mode 100644 net/netfilter/xt_RATEEST.c
>  delete mode 100644 net/netfilter/xt_TCPMSS.c

-- 
Tomasz Pala <gotar@pld-linux.org>
