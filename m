From: Liping Zhang <zlpnobody@gmail.com>
Subject: Re: [PATCH] netfilter: remove ip_conntrack* sysctl compat code
Date: Sat, 13 Aug 2016 15:09:14 +0800
Message-ID: <CAML_gOe84HZUgCr+ECxAxgO-21BbwQtvfWV_V7DNQWQUuzhGiA@mail.gmail.com>
References: <1471002426-3803-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ua0-f194.google.com ([209.85.217.194]:35636 "EHLO
	mail-ua0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752435AbcHMHJz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 13 Aug 2016 03:09:55 -0400
Received: by mail-ua0-f194.google.com with SMTP id 109so568055uat.2
        for <netfilter-devel@vger.kernel.org>; Sat, 13 Aug 2016 00:09:15 -0700 (PDT)
In-Reply-To: <1471002426-3803-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,
2016-08-12 19:47 GMT+08:00 Pablo Neira Ayuso <pablo@netfilter.org>:
> diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
> index dd2c43a..22558b7 100644
> --- a/net/netfilter/nf_conntrack_core.c
> +++ b/net/netfilter/nf_conntrack_core.c
> @@ -161,10 +161,7 @@ static void nf_conntrack_all_unlock(void)
>  }
>
>  unsigned int nf_conntrack_htable_size __read_mostly;
> -EXPORT_SYMBOL_GPL(nf_conntrack_htable_size);

We still need to export nf_conntrack_htable_size, otherwise:

ERROR: "nf_conntrack_htable_size"
[net/netfilter/nfnetlink_cttimeout.ko] undefined!
ERROR: "nf_conntrack_htable_size"
[net/netfilter/nf_conntrack_netlink.ko] undefined!
ERROR: "nf_conntrack_htable_size"
[net/ipv4/netfilter/nf_conntrack_ipv4.ko] undefined!
