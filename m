From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] Out Of Bound Read in Netfilter Conntrack
Date: Mon, 6 Nov 2017 16:13:13 +0100
Message-ID: <20171106151313.GA21034@salvia>
References: <804512f5-786b-d4d0-bc8e-299c5c2683bf@x41-dsec.de>
 <20171024162903.GA20295@salvia>
 <20171024163601.GA30318@salvia>
 <3567257a-3e96-a603-82c0-d1f32bcffd54@x41-dsec.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Eric Sesterhenn <eric.sesterhenn@x41-dsec.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39132 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752360AbdKFPNZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 6 Nov 2017 10:13:25 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 54B021B8411
        for <netfilter-devel@vger.kernel.org>; Mon,  6 Nov 2017 16:13:23 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4096CDA86F
        for <netfilter-devel@vger.kernel.org>; Mon,  6 Nov 2017 16:13:23 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <3567257a-3e96-a603-82c0-d1f32bcffd54@x41-dsec.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Eric,

On Wed, Oct 25, 2017 at 09:05:05AM +0200, Eric Sesterhenn wrote:
[...]
> From b8ed8753ca82f6f07fce2901418aab531d98ee39 Mon Sep 17 00:00:00 2001
> From: Eric Sesterhenn <eric.sesterhenn@x41-dsec.de>
> Date: Wed, 25 Oct 2017 08:32:57 +0200
> Subject: [PATCH netfilter: nf_ct_h323: 1/2] Out Of Bound Read in Netfilter
>  Conntrack
> 
> Add missing counter decrement to prevent out of bounds memory read.

This one, I already applied it, see below comment on 2/2.

> From c1b7044749e534207ecd3b04281ae024b01887d3 Mon Sep 17 00:00:00 2001
> From: Eric Sesterhenn <eric.sesterhenn@x41-dsec.de>
> Date: Wed, 25 Oct 2017 08:39:38 +0200
> Subject: [PATCH netfilter: nf_ct_h323: 2/2] Prevent multiple out of bounds
>  memory reads.
> 
> Multiple accesses are not guarded by out of bound
> checks. This patch introduces them.
> 
> Signed-off-by: Eric Sesterhenn <eric.sesterhenn@x41-dsec.de>
> ---
>  net/netfilter/nf_conntrack_h323_asn1.c | 17 ++++++++++++++++-
>  1 file changed, 16 insertions(+), 1 deletion(-)
> 
> diff --git a/net/netfilter/nf_conntrack_h323_asn1.c b/net/netfilter/nf_conntrack_h323_asn1.c
> index 2a9d1acd0cbd..78a218cdf04e 100644
> --- a/net/netfilter/nf_conntrack_h323_asn1.c
> +++ b/net/netfilter/nf_conntrack_h323_asn1.c
> @@ -104,6 +104,7 @@ typedef struct {
>  #define INC_BITS(bs,b) if(((bs)->bit+=(b))>7){(bs)->cur+=(bs)->bit>>3;(bs)->bit&=7;}
>  #define BYTE_ALIGN(bs) if((bs)->bit){(bs)->cur++;(bs)->bit=0;}
>  #define CHECK_BOUND(bs,n) if((bs)->cur+(n)>(bs)->end)return(H323_ERROR_BOUND)
> +#define CHECK_BIT_BOUND(bs,n) ({ size_t __tmp = n/8; if((bs)->bit+(n%8)>7) { CHECK_BOUND(bs, __tmp + 2); } else { CHECK_BOUND(bs, __tmp + 1); } })

CHECK_BOUND() and your new CHECK_BIT_BOUND() are returning a something
inside a macro, which is a bad practise.

Would you first send me a patch to replace CHECK_BOUND() by a
function, then add place your fix on top of it?

I'd suggest something like:

        static inline int nf_h323_error_boundary(...)
        {
                return bs->cur + (n > bs->end);
        }

Then, use it:

        if (nf_h323_error_boundary(...))
                return H323_ERROR_BOUND;

Please, I'd appreciate if you can send me patches via git-send-mail
too.

Thanks!
