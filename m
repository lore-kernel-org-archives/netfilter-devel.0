From: Liping Zhang <zlpnobody@gmail.com>
Subject: Re: [PATCH 1/2 nf] netfilter: nft_set_bitmap: keep a list of dummy elements
Date: Mon, 13 Mar 2017 22:23:53 +0800
Message-ID: <CAML_gOf5DM6W81b34EQQz+hdsFb-72jq4BhtRK4d2657Ks9bHg@mail.gmail.com>
References: <1489408071-6123-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vk0-f52.google.com ([209.85.213.52]:33705 "EHLO
        mail-vk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752331AbdCMOXz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 Mar 2017 10:23:55 -0400
Received: by mail-vk0-f52.google.com with SMTP id d188so35746104vka.0
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Mar 2017 07:23:54 -0700 (PDT)
In-Reply-To: <1489408071-6123-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

2017-03-13 20:27 GMT+08:00 Pablo Neira Ayuso <pablo@netfilter.org>:
> Element comments may come without any prior set flag, so we have to keep
> a list of dummy struct nft_set_ext to keep this information around. This
> is only useful for set dumps to userspace. From the packet path, this
> set type relies on the bitmap representation. This patch simplifies the
> logic since we don't need to allocate the dummy nft_set_ext structure
> anymore on the fly at the cost of increasing memory consumption because
> of the list of dummy struct nft_set_ext.

If I didn't misunderstand it, I think after introducing the dummy nft_set_ext,
the nft_bitmap_estimate() should also be updated? i.e.:

1. est->size should be recalculated
2. est->space should be changed to NFT_SET_CLASS_O_N
