From: Florian Westphal <fw@strlen.de>
Subject: Re: .config for iptables icmp rule delete failure
Date: Tue, 9 May 2017 04:32:00 +0200
Message-ID: <20170509023200.GA16263@breakpoint.cc>
References: <20170507204306.GW25861@madcap2.tricolour.ca>
 <20170508202236.GC9660@breakpoint.cc>
 <CA+FuTSdikLZoOZDXLPG933DP6sBzqSU0s9DE7L+3Y4xMquK3fQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>,
        Richard Guy Briggs <rgb@redhat.com>, fwestpha@redhat.com,
        netfilter-devel <netfilter-devel@vger.kernel.org>,
        pmoore@redhat.com, pvrabec@redhat.com
To: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:42024 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754389AbdEICc1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 8 May 2017 22:32:27 -0400
Content-Disposition: inline
In-Reply-To: <CA+FuTSdikLZoOZDXLPG933DP6sBzqSU0s9DE7L+3Y4xMquK3fQ@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Willem de Bruijn <willemdebruijn.kernel@gmail.com> wrote:

> Thanks, Florian. Also for the detailed context. I'm having a look.
> The following might be sufficient. It fixes the given example for me.
> 
> @@ -288,6 +288,10 @@ int xt_data_to_user(void __user *dst, const void *src,
>         usersize = usersize ? : size;
>         if (copy_to_user(dst, src, usersize))
>                 return -EFAULT;
> +       size = XT_ALIGN(size);
>         if (usersize != size && clear_user(dst + usersize, size - usersize))
>                 return -EFAULT;

Looks good, but I think this needs a tweak for compat case (use of
COMPAT_XT_ALIGN()).
