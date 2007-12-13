From: "=?ISO-8859-1?Q?Damien_Th=E9bault?=" <damien.thebault@gmail.com>
Subject: Re: Wrong ethernet headers after double postrouting fix
Date: Thu, 13 Dec 2007 16:33:02 +0100
Message-ID: <9a4a382a0712130733g21dd4390w9f457bed7ad19777@mail.gmail.com>
References: <9a4a382a0712130005l49a72164r26e5818060534285@mail.gmail.com>
	 <4760F020.5070405@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: "Patrick McHardy" <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.177]:48340 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756022AbXLMPdD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 13 Dec 2007 10:33:03 -0500
Received: by wa-out-1112.google.com with SMTP id v27so1141247wah.23
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Dec 2007 07:33:03 -0800 (PST)
In-Reply-To: <4760F020.5070405@trash.net>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Dec 13, 2007 9:41 AM, Patrick McHardy <kaber@trash.net> wrote:
> Could you try this patch please?
>
>
> diff --git a/include/linux/netfilter_bridge.h b/include/linux/netfilter_bridge.h
> index 533ee35..499aa93 100644
> --- a/include/linux/netfilter_bridge.h
> +++ b/include/linux/netfilter_bridge.h
> @@ -50,7 +50,8 @@ enum nf_br_hook_priorities {
>  extern int nf_bridge_copy_header(struct sk_buff *skb);
>  static inline int nf_bridge_maybe_copy_header(struct sk_buff *skb)
>  {
> -       if (skb->nf_bridge)
> +       if (skb->nf_bridge &&
> +           skb->nf_bridge->mask & (BRNF_BRIDGED | BRNF_BRIDGED_DNAT))
>                 return nf_bridge_copy_header(skb);
>         return 0;
>  }
>
>

I tried it and it successfully solves this problem. Everything is fine now.

Thank you!
--
Damien Thebault
