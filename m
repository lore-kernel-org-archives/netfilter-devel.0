Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E132EB64DD
	for <netfilter-devel@archiver.kernel.org>; Thu, 20 Jul 2023 10:25:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229628AbjGTKZO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 20 Jul 2023 06:25:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230118AbjGTKZM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 20 Jul 2023 06:25:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E39D10D2
        for <netfilter-devel@vger.kernel.org>; Thu, 20 Jul 2023 03:24:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1689848664;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PKVTfOncXQJfojyynGfI4r/nHW3c+JgUElIDH/9RB8g=;
        b=OjvPFoiRu/lPJOZ6Bq0xC12e/572lcDsVsVb0F64fNCt7wSxaZHJw9zle/Y8pgsZqmc5XF
        B/kDLQOWHn4wNEvY2p2bnisliLb7s0x8KTBRr7JfxBGhYolwW6xbqF4yvu0NBKhSRwtBfp
        fNYsFtQ8vK8wEOWKZTFtI0CgP4Dz5Aw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-465-dgfE4qfSM2Oa_E_M-eEMMw-1; Thu, 20 Jul 2023 06:24:23 -0400
X-MC-Unique: dgfE4qfSM2Oa_E_M-eEMMw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BBFC8800962;
        Thu, 20 Jul 2023 10:24:22 +0000 (UTC)
Received: from elisabeth (unknown [10.39.208.42])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E992840C6F4C;
        Thu, 20 Jul 2023 10:24:21 +0000 (UTC)
Date:   Thu, 20 Jul 2023 12:24:14 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Florian Westphal <fw@strlen.de>
Cc:     <netfilter-devel@vger.kernel.org>,
        lonial con <kongln9170@gmail.com>
Subject: Re: [PATCH nf] netfilter: nft_set_pipapo: fix improper element
 removal
Message-ID: <20230720122414.7f633c03@elisabeth>
In-Reply-To: <20230719190824.21196-1-fw@strlen.de>
References: <20230719190824.21196-1-fw@strlen.de>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, 19 Jul 2023 21:08:21 +0200
Florian Westphal <fw@strlen.de> wrote:

> end key should be equal to start unless NFT_SET_EXT_KEY_END is present.
> 
> Its possible to add elements that only have a start key
> ("{ 1.0.0.0 . 2.0.0.0 }") without an internval end.
> 
> Insertion treats this via:
> 
> if (nft_set_ext_exists(ext, NFT_SET_EXT_KEY_END))
>    end = (const u8 *)nft_set_ext_key_end(ext)->data;
> else
>    end = start;
> 
> but removal side always uses nft_set_ext_key_end().

Oops, right, nft_pipapo_remove() should do exactly the same.

> This is wrong and leads to garbage remaining in the set after removal
> next lookup/insert attempt will give:
> 
> BUG: KASAN: slab-use-after-free in pipapo_get+0x8eb/0xb90
> Read of size 1 at addr ffff888100d50586 by task nft-pipapo_uaf_/1399
> Call Trace:
>  kasan_report+0x105/0x140
>  pipapo_get+0x8eb/0xb90
>  nft_pipapo_insert+0x1dc/0x1710
>  nf_tables_newsetelem+0x31f5/0x4e00
>  ..
> 
> Fixes: 3c4287f62044 ("nf_tables: Add set type for arbitrary concatenation of ranges")
> Cc: Stefano Brivio <sbrivio@redhat.com>
> Reported-by: lonial con <kongln9170@gmail.com>
> Signed-off-by: Florian Westphal <fw@strlen.de>

Reviewed-by: Stefano Brivio <sbrivio@redhat.com>

Thanks for fixing this!

-- 
Stefano

