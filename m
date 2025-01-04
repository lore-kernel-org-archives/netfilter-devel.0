Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8076117FE;
	Sat,  4 Jan 2025 22:24:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=156.67.10.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736029497; cv=none; b=HobGxcz8HIs8B33FvIZDFO4RNNIkLdfoxfn2dv2JrW5jFa1fRJEm4qaVZWsPdhw0Nu6dKj6DNkj+Is5928t4F+68NRD/biv8YLbcmqrhKcllEGYRLNQJzcoRfU5YS8z/U+MzEbvZXlCDBD0Wu+/JP6TLUpNJEvpjvy1bfy3Kgew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736029497; c=relaxed/simple;
	bh=1M7sIQ7pju7qsQTrMz1lG5QcfgYqg97T2Ui4bgOCOIo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pWM2EBzGompeS5NEeMucdOpeeATSE9cfiS9xt7JERgDDjI5cE8Ctv1r3oG3maGlOhzkD65bueZ9NaL+WzrNtTdruFklNfeERbI+a9+Q9Ugk/yHcgW8FYcUkhr+eyCGPyOxZrKrbYk765tVkIzc++N3SeG1rX9nuZ7eauvrsKqWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lunn.ch; spf=pass smtp.mailfrom=lunn.ch; dkim=pass (1024-bit key) header.d=lunn.ch header.i=@lunn.ch header.b=Tjh8Ih30; arc=none smtp.client-ip=156.67.10.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lunn.ch
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lunn.ch
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=lunn.ch header.i=@lunn.ch header.b="Tjh8Ih30"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
	Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
	Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
	In-Reply-To:References; bh=Hppf6MpU5JdiOXZzsLX4NVKfqGKADtmdjlhIj28/qoQ=; b=Tj
	h8Ih30aeMrsSt/tzSA5oK1O9tt2+VxwCRefrP8sPfipAvYAV82YRp3cimqzyjQHce1vIBaGw75cOd
	rMKWsQsfoFDcYuTHVTDQlgaYaCp7xpzdxSvzb9C0JEnYPcVxZBKbvE1otV8U8nklNYjy4//NWN4Un
	Vne92/GFF1b6f7I=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1tUCZK-001QO0-Ho; Sat, 04 Jan 2025 23:24:30 +0100
Date: Sat, 4 Jan 2025 23:24:30 +0100
From: Andrew Lunn <andrew@lunn.ch>
To: egyszeregy@freemail.hu
Cc: fw@strlen.de, pablo@netfilter.org, lorenzo@kernel.org,
	daniel@iogearbox.net, leitao@debian.org, amiculas@cisco.com,
	kadlec@netfilter.org, davem@davemloft.net, dsahern@kernel.org,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	horms@kernel.org, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org, kernel test robot <lkp@intel.com>
Subject: Re: [PATCH v4] netfilter: x_tables: Merge xt_*.c source files which
 has same name.
Message-ID: <83d71044-449a-4421-97b9-fc2dfcf3f283@lunn.ch>
References: <20250104174155.611323-1-egyszeregy@freemail.hu>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250104174155.611323-1-egyszeregy@freemail.hu>

On Sat, Jan 04, 2025 at 06:41:55PM +0100, egyszeregy@freemail.hu wrote:
> From: Benjamin Szőke <egyszeregy@freemail.hu>
> 
> Merge and refactoring xt_*.h, ipt_*.h and ip6t_*.h header and xt_*.c
> source files, which has same upper and lower case name format. Combining
> these modules should provide some decent code size and memory savings.
> 
> test-build:
> $ mkdir build
> $ wget -O ./build/.config https://pastebin.com/raw/teShg1sp
> $ make O=./build/ ARCH=x86 -j 16
> 
> x86_64-before:
> -rw-rw-r-- 1 user users 5120 jan 3 13.52 xt_dscp.o
> -rw-rw-r-- 1 user users 5984 jan 3 13.52 xt_DSCP.o
> -rw-rw-r-- 1 user users 4584 jan 3 13.52 xt_hl.o
> -rw-rw-r-- 1 user users 5304 jan 3 13.52 xt_HL.o
> -rw-rw-r-- 1 user users 5744 jan 3 13.52 xt_rateest.o
> -rw-rw-r-- 1 user users 10080 jan 3 13.52 xt_RATEEST.o
> -rw-rw-r-- 1 user users 4640 jan 3 13.52 xt_tcpmss.o
> -rw-rw-r-- 1 user users 9504 jan 3 13.52 xt_TCPMSS.o
> total size: 50960 bytes
> 
> x86_64-after:
> -rw-rw-r-- 1 user users 8000 jan 3 14.09 xt_dscp.o
> -rw-rw-r-- 1 user users 6736 jan 3 14.09 xt_hl.o
> -rw-rw-r-- 1 user users 12536 jan 3 14.09 xt_rateest.o
> -rw-rw-r-- 1 user users 10992 jan 3 14.09 xt_tcpmss.o
> total size: 38264 bytes
> 
> Code size reduced by 24.913%.

The .o file is a lot more than code. It contains symbol tables, debug
information etc. That is why i suggested size(1).

So in general, i'm sceptical about these changes. But we can keep
going, in the end we might get to something which is mergable.

This patch is too big, and i think you can easily split it up. We want
lots of simple patches which are obviously correct and easy to review,
not one huge patch.

Also, this patch is doing two different things, merging some files,
and addressing case insensitive filesystems. You should split these
changes into two patchsets. Please first produce a patchset for
merging files. Once that has been merged we can look at case
insensitive files.

FYI:

~/linux$ find . -name "*[A-Z]*.[ch]" | wc
    214     214    9412

This is a much bigger issue than just a couple of networking files. Do
you plan to submit patches for over 200 files?

> -#endif /*_XT_CONNMARK_H_target*/
> +#pragma message("xt_CONNMARK.h header is deprecated. Use xt_connmark.h instead.")
> +
> +#endif /* _XT_CONNMARK_TARGET_H */
> diff --git a/include/uapi/linux/netfilter/xt_DSCP.h b/include/uapi/linux/netfilter/xt_DSCP.h
> index 223d635e8b6f..bd550292803d 100644
> --- a/include/uapi/linux/netfilter/xt_DSCP.h
> +++ b/include/uapi/linux/netfilter/xt_DSCP.h
> @@ -1,27 +1,9 @@
>  /* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
> -/* x_tables module for setting the IPv4/IPv6 DSCP field
> - *
> - * (C) 2002 Harald Welte <laforge@gnumonks.org>
> - * based on ipt_FTOS.c (C) 2000 by Matthew G. Marsh <mgm@paktronix.com>
> - * This software is distributed under GNU GPL v2, 1991

Removing copyright notices will not make lawyers happy. Are you really
removing this, or just moving it somewere else.

> - *
> - * See RFC2474 for a description of the DSCP field within the IP Header.
> - *
> - * xt_DSCP.h,v 1.7 2002/03/14 12:03:13 laforge Exp
> -*/
>  #ifndef _XT_DSCP_TARGET_H
>  #define _XT_DSCP_TARGET_H
> -#include <linux/netfilter/xt_dscp.h>
> -#include <linux/types.h>
>  
> -/* target info */
> -struct xt_DSCP_info {
> -	__u8 dscp;
> -};
> +#include <linux/netfilter/xt_dscp.h>
>  
> -struct xt_tos_target_info {
> -	__u8 tos_value;
> -	__u8 tos_mask;
> -};
> +#pragma message("xt_DSCP.h header is deprecated. Use xt_dscp.h instead.")
>  
>  #endif /* _XT_DSCP_TARGET_H */
> diff --git a/include/uapi/linux/netfilter/xt_MARK.h b/include/uapi/linux/netfilter/xt_MARK.h
> index f1fe2b4be933..9f6c03e26c96 100644
> --- a/include/uapi/linux/netfilter/xt_MARK.h
> +++ b/include/uapi/linux/netfilter/xt_MARK.h
> @@ -1,7 +1,9 @@
>  /* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
> -#ifndef _XT_MARK_H_target
> -#define _XT_MARK_H_target
> +#ifndef _XT_MARK_H_TARGET_H
> +#define _XT_MARK_H_TARGET_H
>  
>  #include <linux/netfilter/xt_mark.h>
>  
> -#endif /*_XT_MARK_H_target */
> +#pragma message("xt_MARK.h header is deprecated. Use xt_mark.h instead.")
> +
> +#endif /* _XT_MARK_H_TARGET_H */
> diff --git a/include/uapi/linux/netfilter/xt_RATEEST.h b/include/uapi/linux/netfilter/xt_RATEEST.h
> index 2b87a71e6266..ec3d68f67b2f 100644
> --- a/include/uapi/linux/netfilter/xt_RATEEST.h
> +++ b/include/uapi/linux/netfilter/xt_RATEEST.h
> @@ -2,16 +2,8 @@
>  #ifndef _XT_RATEEST_TARGET_H
>  #define _XT_RATEEST_TARGET_H
>  
> -#include <linux/types.h>
> -#include <linux/if.h>
> +#include <linux/netfilter/xt_rateest.h>
>  
> -struct xt_rateest_target_info {
> -	char			name[IFNAMSIZ];
> -	__s8			interval;
> -	__u8		ewma_log;
> -
> -	/* Used internally by the kernel */
> -	struct xt_rateest	*est __attribute__((aligned(8)));
> -};
> +#pragma message("xt_RATEEST.h header is deprecated. Use xt_rateest.h instead.")

If you look througth include/uapi, how many instances of pragma
message do you find? If you are doing something nobody else does, you
are probably doing something wrong.

>  struct xt_tcpmss_match_info {
> -    __u16 mss_min, mss_max;
> -    __u8 invert;
> +	__u16 mss_min, mss_max;
> +	__u8 invert;
> +};

If you want to change whitespacing, please do that in a separate
patch, with an explanation why.

	Andrew
