From: Serge Leschinsky <serge.leschinsky@gmail.com>
Subject: Re: a possible bug in netfilter
Date: Sat, 07 Apr 2012 21:07:13 -0700
Message-ID: <4F810EF1.1030209@gmail.com>
References: <4F7E6D32.9060109@gmail.com> <alpine.LNX.2.01.1204061444170.19371@frira.zrqbmnf.qr> <20120407155847.GB28425@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@medozas.de>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36536 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713Ab2DHEHU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 8 Apr 2012 00:07:20 -0400
Received: by pbcun15 with SMTP id un15so3902834pbc.19
        for <netfilter-devel@vger.kernel.org>; Sat, 07 Apr 2012 21:07:20 -0700 (PDT)
In-Reply-To: <20120407155847.GB28425@Chamillionaire.breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 04/07/2012 08:58 AM, Florian Westphal wrote:
....
> Serge, could you try this patch?
>
> diff --git a/extensions/xt_psd.c b/extensions/xt_psd.c
> index 46b2831..acb5e8e 100644
> --- a/extensions/xt_psd.c
> +++ b/extensions/xt_psd.c
> @@ -227,7 +227,7 @@ xt_psd_match(const struct sk_buff *pskb, struct xt_action_param *match)
>   				goto out_match;
>
>   			/* Remember the new port */
> -			if (curr->count<  SCAN_MAX_COUNT) {
> +			if (curr->count<  ARRAY_SIZE(curr->ports)) {
>   				curr->ports[curr->count].number = dest_port;
>   				curr->ports[curr->count].proto = proto;
>   				curr->ports[curr->count].and_flags = tcp_flags;
>

The patch is applied. I'll monitor logs for about a week to make sure there are 
no more panics.

Thank you!
Serge
