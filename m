Return-Path: <SRS0=O4lm=UX=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CE20C48BE8
	for <netfilter-devel@archiver.kernel.org>; Mon, 24 Jun 2019 08:05:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2933C2083D
	for <netfilter-devel@archiver.kernel.org>; Mon, 24 Jun 2019 08:05:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="eTmJSY7k"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726923AbfFXIFM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 24 Jun 2019 04:05:12 -0400
Received: from smtp-out.kfki.hu ([148.6.0.48]:58317 "EHLO smtp-out.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726351AbfFXIFM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 24 Jun 2019 04:05:12 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp2.kfki.hu (Postfix) with ESMTP id 94948CC0112;
        Mon, 24 Jun 2019 10:05:08 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        blackhole.kfki.hu; h=mime-version:user-agent:references
        :message-id:in-reply-to:from:from:date:date:received:received
        :received; s=20151130; t=1561363505; x=1563177906; bh=1SSu12OlQW
        BkbR9WbF2k9cfohkHDnowQ++wDq4bRvXo=; b=eTmJSY7kZCWzIiZxbBvT4qjUnC
        M9MXUJWxWIrdj7EwZ+aP0Vt1wPHraON/bUYbHJO5oglOoC7u2+eL4hTc+4z5PgrZ
        8LoSf1VrOku6PfS9hlNL/9pFtktRtqagsl1XAaV3KKwDCyJCsCSzWNmN4ANbhNHR
        RhTc/XKThqRz0PMpU=
X-Virus-Scanned: Debian amavisd-new at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
        by localhost (smtp2.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Mon, 24 Jun 2019 10:05:05 +0200 (CEST)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [IPv6:2001:738:5001:1::240:2])
        by smtp2.kfki.hu (Postfix) with ESMTP id A4099CC010D;
        Mon, 24 Jun 2019 10:05:03 +0200 (CEST)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id 674FE21F1B; Mon, 24 Jun 2019 10:05:03 +0200 (CEST)
Date:   Mon, 24 Jun 2019 10:05:03 +0200 (CEST)
From:   Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        NetFilter <netfilter-devel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: linux-next: manual merge of the netfilter-next tree with Linus'
 tree
In-Reply-To: <20190624130653.64016e85@canb.auug.org.au>
Message-ID: <alpine.DEB.2.20.1906241000250.6525@blackhole.kfki.hu>
References: <20190624130653.64016e85@canb.auug.org.au>
User-Agent: Alpine 2.20 (DEB 67 2015-01-07)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Stephen,

Sorry, that was my fault. 

When reviewing and applying the patches in my tree, I skipped d2912cb15bdd 
as "comments only" and then forgot about it.

Best regards,
Jozsef

On Mon, 24 Jun 2019, Stephen Rothwell wrote:

> Today's linux-next merge of the netfilter-next tree got conflicts in:
> 
>   include/linux/netfilter/ipset/ip_set.h
>   include/linux/netfilter/ipset/ip_set_counter.h
>   include/linux/netfilter/ipset/ip_set_skbinfo.h
>   include/linux/netfilter/ipset/ip_set_timeout.h
>   net/netfilter/ipset/ip_set_bitmap_gen.h
>   net/netfilter/ipset/ip_set_bitmap_ip.c
>   net/netfilter/ipset/ip_set_bitmap_ipmac.c
>   net/netfilter/ipset/ip_set_bitmap_port.c
>   net/netfilter/ipset/ip_set_core.c
>   net/netfilter/ipset/ip_set_getport.c
>   net/netfilter/ipset/ip_set_hash_gen.h
>   net/netfilter/ipset/ip_set_hash_ip.c
>   net/netfilter/ipset/ip_set_hash_ipmark.c
>   net/netfilter/ipset/ip_set_hash_ipport.c
>   net/netfilter/ipset/ip_set_hash_ipportip.c
>   net/netfilter/ipset/ip_set_hash_ipportnet.c
>   net/netfilter/ipset/ip_set_hash_mac.c
>   net/netfilter/ipset/ip_set_hash_net.c
>   net/netfilter/ipset/ip_set_hash_netiface.c
>   net/netfilter/ipset/ip_set_hash_netnet.c
>   net/netfilter/ipset/ip_set_hash_netport.c
>   net/netfilter/ipset/ip_set_hash_netportnet.c
>   net/netfilter/ipset/ip_set_list_set.c
>   net/netfilter/xt_set.c
> 
> between commit:
> 
>   d2912cb15bdd ("treewide: Replace GPLv2 boilerplate/reference with SPDX - rule 500")
> 
> from Linus' tree and commit:
> 
>   fe03d4745675 ("Update my email address")
> 
> from the netfilter-next tree.
> 
> I fixed it up (see below) and can carry the fix as necessary. This
> is now fixed as far as linux-next is concerned, but any non trivial
> conflicts should be mentioned to your upstream maintainer when your tree
> is submitted for merging.  You may also want to consider cooperating
> with the maintainer of the conflicting tree to minimise any particularly
> complex conflicts.
> 
> -- 
> Cheers,
> Stephen Rothwell
> 
> diff --cc include/linux/netfilter/ipset/ip_set.h
> index f5e03809cdb2,f5c6e7cd6469..000000000000
> --- a/include/linux/netfilter/ipset/ip_set.h
> +++ b/include/linux/netfilter/ipset/ip_set.h
> @@@ -2,7 -1,11 +2,7 @@@
>   /* Copyright (C) 2000-2002 Joakim Axelsson <gozem@linux.nu>
>    *                         Patrick Schaaf <bof@bof.de>
>    *                         Martin Josefsson <gandalf@wlug.westbo.se>
> -  * Copyright (C) 2003-2013 Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
> +  * Copyright (C) 2003-2013 Jozsef Kadlecsik <kadlec@netfilter.org>
>  - *
>  - * This program is free software; you can redistribute it and/or modify
>  - * it under the terms of the GNU General Public License version 2 as
>  - * published by the Free Software Foundation.
>    */
>   #ifndef _IP_SET_H
>   #define _IP_SET_H
> diff --cc include/linux/netfilter/ipset/ip_set_counter.h
> index 5477492c8374,305aeda2a899..000000000000
> --- a/include/linux/netfilter/ipset/ip_set_counter.h
> +++ b/include/linux/netfilter/ipset/ip_set_counter.h
> @@@ -2,7 -1,11 +2,7 @@@
>   #ifndef _IP_SET_COUNTER_H
>   #define _IP_SET_COUNTER_H
>   
> - /* Copyright (C) 2015 Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
> + /* Copyright (C) 2015 Jozsef Kadlecsik <kadlec@netfilter.org>
>  - *
>  - * This program is free software; you can redistribute it and/or modify
>  - * it under the terms of the GNU General Public License version 2 as
>  - * published by the Free Software Foundation.
>    */
>   
>   #ifdef __KERNEL__
> diff --cc include/linux/netfilter/ipset/ip_set_skbinfo.h
> index aae081e085c6,fac57ef854c2..000000000000
> --- a/include/linux/netfilter/ipset/ip_set_skbinfo.h
> +++ b/include/linux/netfilter/ipset/ip_set_skbinfo.h
> @@@ -2,7 -1,11 +2,7 @@@
>   #ifndef _IP_SET_SKBINFO_H
>   #define _IP_SET_SKBINFO_H
>   
> - /* Copyright (C) 2015 Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
> + /* Copyright (C) 2015 Jozsef Kadlecsik <kadlec@netfilter.org>
>  - *
>  - * This program is free software; you can redistribute it and/or modify
>  - * it under the terms of the GNU General Public License version 2 as
>  - * published by the Free Software Foundation.
>    */
>   
>   #ifdef __KERNEL__
> diff --cc include/linux/netfilter/ipset/ip_set_timeout.h
> index 88926b4c75f0,dc74150f3432..000000000000
> --- a/include/linux/netfilter/ipset/ip_set_timeout.h
> +++ b/include/linux/netfilter/ipset/ip_set_timeout.h
> @@@ -2,7 -1,11 +2,7 @@@
>   #ifndef _IP_SET_TIMEOUT_H
>   #define _IP_SET_TIMEOUT_H
>   
> - /* Copyright (C) 2003-2013 Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
> + /* Copyright (C) 2003-2013 Jozsef Kadlecsik <kadlec@netfilter.org>
>  - *
>  - * This program is free software; you can redistribute it and/or modify
>  - * it under the terms of the GNU General Public License version 2 as
>  - * published by the Free Software Foundation.
>    */
>   
>   #ifdef __KERNEL__
> diff --cc net/netfilter/ipset/ip_set_bitmap_gen.h
> index 8acc4e173167,29c1e9a50601..000000000000
> --- a/net/netfilter/ipset/ip_set_bitmap_gen.h
> +++ b/net/netfilter/ipset/ip_set_bitmap_gen.h
> @@@ -1,5 -1,8 +1,5 @@@
>  +/* SPDX-License-Identifier: GPL-2.0-only */
> - /* Copyright (C) 2013 Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
> + /* Copyright (C) 2013 Jozsef Kadlecsik <kadlec@netfilter.org>
>  - *
>  - * This program is free software; you can redistribute it and/or modify
>  - * it under the terms of the GNU General Public License version 2 as
>  - * published by the Free Software Foundation.
>    */
>   
>   #ifndef __IP_SET_BITMAP_IP_GEN_H
> diff --cc net/netfilter/ipset/ip_set_bitmap_ip.c
> index e3884b0cca91,5a66c5499700..000000000000
> --- a/net/netfilter/ipset/ip_set_bitmap_ip.c
> +++ b/net/netfilter/ipset/ip_set_bitmap_ip.c
> @@@ -1,7 -1,10 +1,7 @@@
>  +// SPDX-License-Identifier: GPL-2.0-only
>   /* Copyright (C) 2000-2002 Joakim Axelsson <gozem@linux.nu>
>    *                         Patrick Schaaf <bof@bof.de>
> -  * Copyright (C) 2003-2013 Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
> +  * Copyright (C) 2003-2013 Jozsef Kadlecsik <kadlec@netfilter.org>
>  - *
>  - * This program is free software; you can redistribute it and/or modify
>  - * it under the terms of the GNU General Public License version 2 as
>  - * published by the Free Software Foundation.
>    */
>   
>   /* Kernel module implementing an IP set type: the bitmap:ip type */
> diff --cc net/netfilter/ipset/ip_set_bitmap_ipmac.c
> index b73c37b3a791,ec7a8b12642c..000000000000
> --- a/net/netfilter/ipset/ip_set_bitmap_ipmac.c
> +++ b/net/netfilter/ipset/ip_set_bitmap_ipmac.c
> @@@ -2,7 -1,11 +2,7 @@@
>   /* Copyright (C) 2000-2002 Joakim Axelsson <gozem@linux.nu>
>    *                         Patrick Schaaf <bof@bof.de>
>    *			   Martin Josefsson <gandalf@wlug.westbo.se>
> -  * Copyright (C) 2003-2013 Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
> +  * Copyright (C) 2003-2013 Jozsef Kadlecsik <kadlec@netfilter.org>
>  - *
>  - * This program is free software; you can redistribute it and/or modify
>  - * it under the terms of the GNU General Public License version 2 as
>  - * published by the Free Software Foundation.
>    */
>   
>   /* Kernel module implementing an IP set type: the bitmap:ip,mac type */
> diff --cc net/netfilter/ipset/ip_set_bitmap_port.c
> index d8c140553379,18275ec4924c..000000000000
> --- a/net/netfilter/ipset/ip_set_bitmap_port.c
> +++ b/net/netfilter/ipset/ip_set_bitmap_port.c
> @@@ -1,5 -1,8 +1,5 @@@
>  +// SPDX-License-Identifier: GPL-2.0-only
> - /* Copyright (C) 2003-2013 Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
> + /* Copyright (C) 2003-2013 Jozsef Kadlecsik <kadlec@netfilter.org>
>  - *
>  - * This program is free software; you can redistribute it and/or modify
>  - * it under the terms of the GNU General Public License version 2 as
>  - * published by the Free Software Foundation.
>    */
>   
>   /* Kernel module implementing an IP set type: the bitmap:port type */
> diff --cc net/netfilter/ipset/ip_set_core.c
> index 3cdf171cd468,18430ad2fdf2..000000000000
> --- a/net/netfilter/ipset/ip_set_core.c
> +++ b/net/netfilter/ipset/ip_set_core.c
> @@@ -1,7 -1,10 +1,7 @@@
>  +// SPDX-License-Identifier: GPL-2.0-only
>   /* Copyright (C) 2000-2002 Joakim Axelsson <gozem@linux.nu>
>    *                         Patrick Schaaf <bof@bof.de>
> -  * Copyright (C) 2003-2013 Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
> +  * Copyright (C) 2003-2013 Jozsef Kadlecsik <kadlec@netfilter.org>
>  - *
>  - * This program is free software; you can redistribute it and/or modify
>  - * it under the terms of the GNU General Public License version 2 as
>  - * published by the Free Software Foundation.
>    */
>   
>   /* Kernel module for IP set management */
> diff --cc net/netfilter/ipset/ip_set_getport.c
> index 2384e36aef5c,dc7b46b41354..000000000000
> --- a/net/netfilter/ipset/ip_set_getport.c
> +++ b/net/netfilter/ipset/ip_set_getport.c
> @@@ -1,5 -1,8 +1,5 @@@
>  +// SPDX-License-Identifier: GPL-2.0-only
> - /* Copyright (C) 2003-2011 Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
> + /* Copyright (C) 2003-2011 Jozsef Kadlecsik <kadlec@netfilter.org>
>  - *
>  - * This program is free software; you can redistribute it and/or modify
>  - * it under the terms of the GNU General Public License version 2 as
>  - * published by the Free Software Foundation.
>    */
>   
>   /* Get Layer-4 data from the packets */
> diff --cc net/netfilter/ipset/ip_set_hash_gen.h
> index 10f619625abd,07ef941130a6..000000000000
> --- a/net/netfilter/ipset/ip_set_hash_gen.h
> +++ b/net/netfilter/ipset/ip_set_hash_gen.h
> @@@ -1,5 -1,8 +1,5 @@@
>  +/* SPDX-License-Identifier: GPL-2.0-only */
> - /* Copyright (C) 2013 Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
> + /* Copyright (C) 2013 Jozsef Kadlecsik <kadlec@netfilter.org>
>  - *
>  - * This program is free software; you can redistribute it and/or modify
>  - * it under the terms of the GNU General Public License version 2 as
>  - * published by the Free Software Foundation.
>    */
>   
>   #ifndef _IP_SET_HASH_GEN_H
> diff --cc net/netfilter/ipset/ip_set_hash_ip.c
> index 69d7576be2e6,7b82bf1104ce..000000000000
> --- a/net/netfilter/ipset/ip_set_hash_ip.c
> +++ b/net/netfilter/ipset/ip_set_hash_ip.c
> @@@ -1,5 -1,8 +1,5 @@@
>  +// SPDX-License-Identifier: GPL-2.0-only
> - /* Copyright (C) 2003-2013 Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
> + /* Copyright (C) 2003-2013 Jozsef Kadlecsik <kadlec@netfilter.org>
>  - *
>  - * This program is free software; you can redistribute it and/or modify
>  - * it under the terms of the GNU General Public License version 2 as
>  - * published by the Free Software Foundation.
>    */
>   
>   /* Kernel module implementing an IP set type: the hash:ip type */
> diff --cc net/netfilter/ipset/ip_set_hash_ipmark.c
> index 6fe1ec0d2154,7d468f98a252..000000000000
> --- a/net/netfilter/ipset/ip_set_hash_ipmark.c
> +++ b/net/netfilter/ipset/ip_set_hash_ipmark.c
> @@@ -1,6 -1,9 +1,6 @@@
>  +// SPDX-License-Identifier: GPL-2.0-only
> - /* Copyright (C) 2003-2013 Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
> + /* Copyright (C) 2003-2013 Jozsef Kadlecsik <kadlec@netfilter.org>
>    * Copyright (C) 2013 Smoothwall Ltd. <vytas.dauksa@smoothwall.net>
>  - *
>  - * This program is free software; you can redistribute it and/or modify
>  - * it under the terms of the GNU General Public License version 2 as
>  - * published by the Free Software Foundation.
>    */
>   
>   /* Kernel module implementing an IP set type: the hash:ip,mark type */
> diff --cc net/netfilter/ipset/ip_set_hash_ipport.c
> index 74ec7e097e34,d358ee69d04b..000000000000
> --- a/net/netfilter/ipset/ip_set_hash_ipport.c
> +++ b/net/netfilter/ipset/ip_set_hash_ipport.c
> @@@ -1,5 -1,8 +1,5 @@@
>  +// SPDX-License-Identifier: GPL-2.0-only
> - /* Copyright (C) 2003-2013 Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
> + /* Copyright (C) 2003-2013 Jozsef Kadlecsik <kadlec@netfilter.org>
>  - *
>  - * This program is free software; you can redistribute it and/or modify
>  - * it under the terms of the GNU General Public License version 2 as
>  - * published by the Free Software Foundation.
>    */
>   
>   /* Kernel module implementing an IP set type: the hash:ip,port type */
> diff --cc net/netfilter/ipset/ip_set_hash_ipportip.c
> index ced57d63b01f,0a304785f912..000000000000
> --- a/net/netfilter/ipset/ip_set_hash_ipportip.c
> +++ b/net/netfilter/ipset/ip_set_hash_ipportip.c
> @@@ -1,5 -1,8 +1,5 @@@
>  +// SPDX-License-Identifier: GPL-2.0-only
> - /* Copyright (C) 2003-2013 Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
> + /* Copyright (C) 2003-2013 Jozsef Kadlecsik <kadlec@netfilter.org>
>  - *
>  - * This program is free software; you can redistribute it and/or modify
>  - * it under the terms of the GNU General Public License version 2 as
>  - * published by the Free Software Foundation.
>    */
>   
>   /* Kernel module implementing an IP set type: the hash:ip,port,ip type */
> diff --cc net/netfilter/ipset/ip_set_hash_ipportnet.c
> index 905f6cf0f55e,245f7d714870..000000000000
> --- a/net/netfilter/ipset/ip_set_hash_ipportnet.c
> +++ b/net/netfilter/ipset/ip_set_hash_ipportnet.c
> @@@ -1,5 -1,8 +1,5 @@@
>  +// SPDX-License-Identifier: GPL-2.0-only
> - /* Copyright (C) 2003-2013 Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
> + /* Copyright (C) 2003-2013 Jozsef Kadlecsik <kadlec@netfilter.org>
>  - *
>  - * This program is free software; you can redistribute it and/or modify
>  - * it under the terms of the GNU General Public License version 2 as
>  - * published by the Free Software Foundation.
>    */
>   
>   /* Kernel module implementing an IP set type: the hash:ip,port,net type */
> diff --cc net/netfilter/ipset/ip_set_hash_mac.c
> index 853e772ab4d9,3d1fc71dac38..000000000000
> --- a/net/netfilter/ipset/ip_set_hash_mac.c
> +++ b/net/netfilter/ipset/ip_set_hash_mac.c
> @@@ -1,5 -1,8 +1,5 @@@
>  +// SPDX-License-Identifier: GPL-2.0-only
> - /* Copyright (C) 2014 Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
> + /* Copyright (C) 2014 Jozsef Kadlecsik <kadlec@netfilter.org>
>  - *
>  - * This program is free software; you can redistribute it and/or modify
>  - * it under the terms of the GNU General Public License version 2 as
>  - * published by the Free Software Foundation.
>    */
>   
>   /* Kernel module implementing an IP set type: the hash:mac type */
> diff --cc net/netfilter/ipset/ip_set_hash_net.c
> index 06c91e49bf25,470701fda231..000000000000
> --- a/net/netfilter/ipset/ip_set_hash_net.c
> +++ b/net/netfilter/ipset/ip_set_hash_net.c
> @@@ -1,5 -1,8 +1,5 @@@
>  +// SPDX-License-Identifier: GPL-2.0-only
> - /* Copyright (C) 2003-2013 Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
> + /* Copyright (C) 2003-2013 Jozsef Kadlecsik <kadlec@netfilter.org>
>  - *
>  - * This program is free software; you can redistribute it and/or modify
>  - * it under the terms of the GNU General Public License version 2 as
>  - * published by the Free Software Foundation.
>    */
>   
>   /* Kernel module implementing an IP set type: the hash:net type */
> diff --cc net/netfilter/ipset/ip_set_hash_netiface.c
> index 0a8cbcdfb42b,1df8656ad84d..000000000000
> --- a/net/netfilter/ipset/ip_set_hash_netiface.c
> +++ b/net/netfilter/ipset/ip_set_hash_netiface.c
> @@@ -1,5 -1,8 +1,5 @@@
>  +// SPDX-License-Identifier: GPL-2.0-only
> - /* Copyright (C) 2011-2013 Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
> + /* Copyright (C) 2011-2013 Jozsef Kadlecsik <kadlec@netfilter.org>
>  - *
>  - * This program is free software; you can redistribute it and/or modify
>  - * it under the terms of the GNU General Public License version 2 as
>  - * published by the Free Software Foundation.
>    */
>   
>   /* Kernel module implementing an IP set type: the hash:net,iface type */
> diff --cc net/netfilter/ipset/ip_set_hash_netnet.c
> index 832e4f5491cb,e0553be89600..000000000000
> --- a/net/netfilter/ipset/ip_set_hash_netnet.c
> +++ b/net/netfilter/ipset/ip_set_hash_netnet.c
> @@@ -1,6 -1,9 +1,6 @@@
>  +// SPDX-License-Identifier: GPL-2.0-only
> - /* Copyright (C) 2003-2013 Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
> + /* Copyright (C) 2003-2013 Jozsef Kadlecsik <kadlec@netfilter.org>
>    * Copyright (C) 2013 Oliver Smith <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
>  - *
>  - * This program is free software; you can redistribute it and/or modify
>  - * it under the terms of the GNU General Public License version 2 as
>  - * published by the Free Software Foundation.
>    */
>   
>   /* Kernel module implementing an IP set type: the hash:net type */
> diff --cc net/netfilter/ipset/ip_set_hash_netport.c
> index a4f3f15b874a,943d55d76fcf..000000000000
> --- a/net/netfilter/ipset/ip_set_hash_netport.c
> +++ b/net/netfilter/ipset/ip_set_hash_netport.c
> @@@ -1,5 -1,8 +1,5 @@@
>  +// SPDX-License-Identifier: GPL-2.0-only
> - /* Copyright (C) 2003-2013 Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
> + /* Copyright (C) 2003-2013 Jozsef Kadlecsik <kadlec@netfilter.org>
>  - *
>  - * This program is free software; you can redistribute it and/or modify
>  - * it under the terms of the GNU General Public License version 2 as
>  - * published by the Free Software Foundation.
>    */
>   
>   /* Kernel module implementing an IP set type: the hash:net,port type */
> diff --cc net/netfilter/ipset/ip_set_hash_netportnet.c
> index e54d415405f3,afaff99e578c..000000000000
> --- a/net/netfilter/ipset/ip_set_hash_netportnet.c
> +++ b/net/netfilter/ipset/ip_set_hash_netportnet.c
> @@@ -1,5 -1,8 +1,5 @@@
>  +// SPDX-License-Identifier: GPL-2.0-only
> - /* Copyright (C) 2003-2013 Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
> + /* Copyright (C) 2003-2013 Jozsef Kadlecsik <kadlec@netfilter.org>
>  - *
>  - * This program is free software; you can redistribute it and/or modify
>  - * it under the terms of the GNU General Public License version 2 as
>  - * published by the Free Software Foundation.
>    */
>   
>   /* Kernel module implementing an IP set type: the hash:ip,port,net type */
> diff --cc net/netfilter/ipset/ip_set_list_set.c
> index 8ada318bf09d,ed4360072f64..000000000000
> --- a/net/netfilter/ipset/ip_set_list_set.c
> +++ b/net/netfilter/ipset/ip_set_list_set.c
> @@@ -1,5 -1,8 +1,5 @@@
>  +// SPDX-License-Identifier: GPL-2.0-only
> - /* Copyright (C) 2008-2013 Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
> + /* Copyright (C) 2008-2013 Jozsef Kadlecsik <kadlec@netfilter.org>
>  - *
>  - * This program is free software; you can redistribute it and/or modify
>  - * it under the terms of the GNU General Public License version 2 as
>  - * published by the Free Software Foundation.
>    */
>   
>   /* Kernel module implementing an IP set type: the list:set type */
> diff --cc net/netfilter/xt_set.c
> index f099228cb9c4,f025c51ba375..000000000000
> --- a/net/netfilter/xt_set.c
> +++ b/net/netfilter/xt_set.c
> @@@ -2,7 -1,11 +2,7 @@@
>   /* Copyright (C) 2000-2002 Joakim Axelsson <gozem@linux.nu>
>    *                         Patrick Schaaf <bof@bof.de>
>    *                         Martin Josefsson <gandalf@wlug.westbo.se>
> -  * Copyright (C) 2003-2013 Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
> +  * Copyright (C) 2003-2013 Jozsef Kadlecsik <kadlec@netfilter.org>
>  - *
>  - * This program is free software; you can redistribute it and/or modify
>  - * it under the terms of the GNU General Public License version 2 as
>  - * published by the Free Software Foundation.
>    */
>   
>   /* Kernel module which implements the set match and SET target
> 

-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
