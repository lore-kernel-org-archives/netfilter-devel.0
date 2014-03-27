From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [PATCH 3/5] netfilter: nf_tables: Add meta expression key for
 bridge interface name
Date: Thu, 27 Mar 2014 13:59:06 +0100
Message-ID: <CAOkSjBiyNe7cRA_HiojL_BOsYXPR=P48mJQyZSVgO7HSnLp3DQ@mail.gmail.com>
References: <1395924427-27947-1-git-send-email-tomasz.bursztyka@linux.intel.com>
 <1395924427-27947-4-git-send-email-tomasz.bursztyka@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f45.google.com ([209.85.215.45]:38019 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752124AbaC0M72 convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 27 Mar 2014 08:59:28 -0400
Received: by mail-la0-f45.google.com with SMTP id hr17so2592693lab.18
        for <netfilter-devel@vger.kernel.org>; Thu, 27 Mar 2014 05:59:26 -0700 (PDT)
In-Reply-To: <1395924427-27947-4-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 27 March 2014 13:47, Tomasz Bursztyka
<tomasz.bursztyka@linux.intel.com> wrote:
>
> diff --git a/net/bridge/netfilter/nft_meta_bridge.c b/net/bridge/netf=
ilter/nft_meta_bridge.c
> new file mode 100644
> index 0000000..411a6b5
> --- /dev/null
> +++ b/net/bridge/netfilter/nft_meta_bridge.c
> @@ -0,0 +1,162 @@
> +/*
> + * Copyright (c) 2012 Intel Corporation
> + *

minor question:
Why do you use 2012 here?

regards
--=20
Arturo Borrero Gonz=E1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
