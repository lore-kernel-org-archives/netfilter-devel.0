From: Liping Zhang <zlpnobody@gmail.com>
Subject: Re: [PATCH nf 1/2] netfilter: nft_set_bitmap: fetch the element key
 based on the set->klen
Date: Mon, 6 Mar 2017 22:27:20 +0800
Message-ID: <CAML_gOedJF8udDAt-=aBAUZAvCKUGWh1RnqdLASn42LfoJGCrA@mail.gmail.com>
References: <1488729773-48343-1-git-send-email-zlpnobody@163.com> <20170306120119.GA3461@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Liping Zhang <zlpnobody@163.com>,
        Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ua0-f182.google.com ([209.85.217.182]:33268 "EHLO
        mail-ua0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750988AbdCFPYP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 6 Mar 2017 10:24:15 -0500
Received: by mail-ua0-f182.google.com with SMTP id u30so39706590uau.0
        for <netfilter-devel@vger.kernel.org>; Mon, 06 Mar 2017 07:24:14 -0800 (PST)
In-Reply-To: <20170306120119.GA3461@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

2017-03-06 20:01 GMT+08:00 Pablo Neira Ayuso <pablo@netfilter.org>:
[...]
> Right, the userdata case is not handled properly. And in this case we
> have no specific flag at set creation, so element comments may come
> without previous notice via set flags.
>
> I think we have to keep a list of dummy nft_set_ext that is only used
> in the dump path, we can simplify this logic at the cost of increasing
> memory consumption. Another alternative is to keep around a structure
> to store only the set element userdata that we need for comments.
>
> Let me think.
>
> Your patches look good to me. Probably we can skip 2/2 if we introduce
> the dummy nft_set_ext list, and remove the ->flush field for
> nft_set_iter.
>

Actually I was preparing to send v2 about this patch, then I saw your
reply:). Because I find out that in nft_bitmap_walk(), the 'key' maybe
incorrect on the big-endian machines when the key length is 1.
So the patch diff looks like this:

static void nft_bitmap_walk(...)
                        key = ((idx * BITS_PER_BYTE) + off) >> 1;
-                       memcpy(nft_set_ext_key(ext), &key, set->klen);
+                       if (set->klen == 2)
+                               *(u16 *)nft_set_ext_key(ext) = key;
+                       else
+                               *(u8 *)nft_set_ext_key(ext) = key;

But if we will introduce the dummy nft_set_ext list to the whole elements
in the bitmap, the above part is not needed anymore, i.e. we need not to
convert the bit to key.

(Now start the second part, about the byte-order in nft)
Unrelated to this patch actually, I find that there's a little messy when we
store the u8 or u16 integer to the register, which may cause miss-match in
big-endian machines (Actually I have no big-endian machine around me,
so I can't verify it).

For example, dest pointer is declared as "u32 *dest = &regs->data[priv->dreg];",
but there are different ways to fetch the value:
1. fetching the l4 port, we use:
    *dest = 0;
    *(u16 *)dest = *(u16 *)ptr;

2. fetching the NFT_META_IIFTYPE, we use:
    *dest = 0;
    *(u16 *)dest = in->type;

3. fetching the NFT_CT_PROTO_SRC, we use:
    *dest = (__force __u16)tuple->src.u.all;

So method 1 and method 2 will cause the value stored like this, either in
big-endian or little-endian:
  0          15           31
  +-+-+-+-+-+-+-+-+-
  |  Value  |       0     |
  +-+-+-+-+-+-+-+-+-
But method 3 will cause the value stored like this, in big-endian machine:
  0          15           31
  +-+-+-+-+-+-+-+-+-
  |  0         |  Value   |
  +-+-+-+-+-+-+-+-+-

Later in nft_cmp, nft_set_hash, nft_set_rbtree, we use memcmp to do compare:
   "memcmp(&regs->data[priv->sreg], data/key, 2);"

So method 3 is wrong in big-endian, as 0~15 bits will always be zero. Maybe we
can introduce some wrapper functions to help us, for example:

static inline void nft_register_store16(u32 *dreg, u16 value)
{
        *dreg = 0;
        *(u16 *)dreg = value;
}

static inline void nft_register_store8(u32 *dreg, u8 value)
{
        *dreg = 0;
        *(u8 *)dreg = value;
}

...

Am I wrong? Or I totally misunderstood this byte-order issue?
