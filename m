From: Arturo Borrero Gonzalez <arturo@debian.org>
Subject: Re: [PATCH nf-next 1/5] netfilter: nft: UAPI headers for routing expression
Date: Mon, 17 Oct 2016 09:32:41 +0200
Message-ID: <CAOkSjBj-a94zjvChOjWBykkkSDUy-p1Kj7r-i+=Gz+jzHUpr4A@mail.gmail.com>
References: <1476625229.1038.3.camel@cohaesio.com> <1476625315.1038.5.camel@cohaesio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: "Anders K. Pedersen | Cohaesio" <akp@cohaesio.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:34008 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757592AbcJQHdF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 17 Oct 2016 03:33:05 -0400
Received: by mail-lf0-f65.google.com with SMTP id x23so19419114lfi.1
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Oct 2016 00:33:04 -0700 (PDT)
Received: from mail-lf0-f51.google.com (mail-lf0-f51.google.com. [209.85.215.51])
        by smtp.gmail.com with ESMTPSA id g10sm7242354lji.40.2016.10.17.00.33.03
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 17 Oct 2016 00:33:03 -0700 (PDT)
Received: by mail-lf0-f51.google.com with SMTP id l131so230882476lfl.2
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Oct 2016 00:33:03 -0700 (PDT)
In-Reply-To: <1476625315.1038.5.camel@cohaesio.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 16 October 2016 at 15:41, Anders K. Pedersen | Cohaesio
<akp@cohaesio.com> wrote:
> diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
> --- a/include/uapi/linux/netfilter/nf_tables.h
> +++ b/include/uapi/linux/netfilter/nf_tables.h
> @@ -759,6 +759,16 @@ enum nft_meta_keys {
>  };
>
>  /**
> + * enum nft_rt_keys - nf_tables routing expression keys
> + *
> + * @NFT_META_NEXTHOP: routing nexthop
> + */
> +enum nft_rt_keys {
> +       NFT_RT_CLASSID,
> +       NFT_RT_NEXTHOP,
> +};
> +

The comment section looks like it requires a fix.
