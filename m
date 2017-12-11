From: Yi-Hung Wei <yihung.wei@gmail.com>
Subject: Re: [PATCH v5 nf-next] netfilter: connlimit: split xt_connlimit into
 front and backend
Date: Mon, 11 Dec 2017 09:51:21 -0800
Message-ID: <CAG1aQhJBqTOyJeh=evt1hcgZh_51FaPG1TaLi+uKpEgzbKY-tQ@mail.gmail.com>
References: <20171209200108.15760-1-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-yb0-f172.google.com ([209.85.213.172]:41971 "EHLO
        mail-yb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751274AbdLKRvm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 11 Dec 2017 12:51:42 -0500
Received: by mail-yb0-f172.google.com with SMTP id x83so1424750ybg.8
        for <netfilter-devel@vger.kernel.org>; Mon, 11 Dec 2017 09:51:42 -0800 (PST)
In-Reply-To: <20171209200108.15760-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Dec 9, 2017 at 12:01 PM, Florian Westphal <fw@strlen.de> wrote:
> This allows to reuse xt_connlimit infrastructure from nf_tables.
> The upcoming nf_tables frontend can just pass in an nftables register
> as input key, this allows limiting by any nft-supported key, including
> concatenations.
>
> For xt_connlimit, pass in the zone and the ip/ipv6 address.
>
> With help from Yi-Hung Wei.
>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
Thanks for working on this again. It looks good to me.

Acked-by: Yi-Hung Wei <yihung.wei@gmail.com>
