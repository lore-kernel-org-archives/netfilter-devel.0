From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/2] Convert CHECK_BOUND macro to function
Date: Mon, 13 Nov 2017 14:13:33 +0100
Message-ID: <20171113131333.GA21936@salvia>
References: <20171106151313.GA21034@salvia>
 <20171113080941.616-1-eric.sesterhenn@x41-dsec.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: eric.sesterhenn@x41-dsec.de
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34400 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752591AbdKMNNh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 Nov 2017 08:13:37 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 7AEA78D0502
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Nov 2017 14:13:36 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6CE88DA86B
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Nov 2017 14:13:36 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20171113080941.616-1-eric.sesterhenn@x41-dsec.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Nov 13, 2017 at 09:09:40AM +0100, eric.sesterhenn@x41-dsec.de wrote:
> From: Eric Sesterhenn <eric.sesterhenn@x41-dsec.de>
> 
> It is bad practive to return in a macro, this patch
> moves the check into a function.

Applied with minor changes, see below.

[...]
> diff --git a/net/netfilter/nf_conntrack_h323_asn1.c b/net/netfilter/nf_conntrack_h323_asn1.c
> index 89b2e46925c4..f358222b1e5e 100644
> --- a/net/netfilter/nf_conntrack_h323_asn1.c
> +++ b/net/netfilter/nf_conntrack_h323_asn1.c
> @@ -103,7 +103,6 @@ typedef struct {
>  #define INC_BIT(bs) if((++(bs)->bit)>7){(bs)->cur++;(bs)->bit=0;}
>  #define INC_BITS(bs,b) if(((bs)->bit+=(b))>7){(bs)->cur+=(bs)->bit>>3;(bs)->bit&=7;}
>  #define BYTE_ALIGN(bs) if((bs)->bit){(bs)->cur++;(bs)->bit=0;}
> -#define CHECK_BOUND(bs,n) if((bs)->cur+(n)>(bs)->end)return(H323_ERROR_BOUND)
>  static unsigned int get_len(bitstr_t *bs);
>  static unsigned int get_bit(bitstr_t *bs);
>  static unsigned int get_bits(bitstr_t *bs, unsigned int b);
> @@ -166,6 +165,14 @@ static unsigned int get_len(bitstr_t *bs)
>  }
>  
>  /****************************************************************************/
> +static int nf_h323_error_boundary(bitstr_t *bs, size_t bytes)

Make sure you make you patches on top of nf-next.git:

https://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git/

Look, bitstr_t is gone there already, we got a patch to remove
typedefs.

Anyway, I have mangled this here and it's now applied.

It would be great if your follow up patch subject is prefixes like
this:

        netfilter: nf_ct_h323: blah

So we know what subsystem this is targeting to, just for the next
time.

Thanks for following up on this!
