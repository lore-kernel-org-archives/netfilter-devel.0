From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] Bitwise Out Of Bound Read in Netfilter Conntrack
Date: Tue, 17 Oct 2017 15:09:17 +0200
Message-ID: <20171017130917.GA21110@salvia>
References: <804512f5-786b-d4d0-bc8e-299c5c2683bf@x41-dsec.de>
 <20171012000346.GE26835@breakpoint.cc>
 <732a5fa7-1ccc-24f4-862c-18ff61b0fabb@x41-dsec.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Eric Sesterhenn <eric.sesterhenn@x41-dsec.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38566 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935801AbdJQNJZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 Oct 2017 09:09:25 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 547955230A
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Oct 2017 15:09:24 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4442FBAAB1
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Oct 2017 15:09:24 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <732a5fa7-1ccc-24f4-862c-18ff61b0fabb@x41-dsec.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Eric,

Is there any change with regards to previous patch?

I have two in patchwork:

http://patchwork.ozlabs.org/patch/823074/
http://patchwork.ozlabs.org/patch/825682/

Which one should I consider for submission?

Thanks!

On Fri, Oct 13, 2017 at 08:29:08PM +0200, Eric Sesterhenn wrote:
> 
> From 66a5a55b6e7e45c51691583cf5833b4fe9365dc1 Mon Sep 17 00:00:00 2001
> From: Eric Sesterhenn <eric.sesterhenn@x41-dsec.de>
> Date: Fri, 13 Oct 2017 20:26:32 +0200
> Subject: [PATCH] Prevent bitwise out of bound memory reads
> 
> The CHECK_BOUND function is not always uses, especially not
> when reading bitwise.
> 
> Signed-off-by: Eric Sesterhenn <eric.sesterhenn@x41-dsec.de>
> ---
>  net/netfilter/nf_conntrack_h323_asn1.c | 18 +++++++++++++++++-
>  1 file changed, 17 insertions(+), 1 deletion(-)
> 
> diff --git a/net/netfilter/nf_conntrack_h323_asn1.c
> b/net/netfilter/nf_conntrack_h323_asn1.c
> index 89b2e46925c4..e298878edc86 100644
> --- a/net/netfilter/nf_conntrack_h323_asn1.c
> +++ b/net/netfilter/nf_conntrack_h323_asn1.c
> @@ -104,6 +104,7 @@ typedef struct {
>  #define INC_BITS(bs,b)
> if(((bs)->bit+=(b))>7){(bs)->cur+=(bs)->bit>>3;(bs)->bit&=7;}
>  #define BYTE_ALIGN(bs) if((bs)->bit){(bs)->cur++;(bs)->bit=0;}
>  #define CHECK_BOUND(bs,n)
> if((bs)->cur+(n)>(bs)->end)return(H323_ERROR_BOUND)
> +#define CHECK_BIT_BOUND(bs,n) ({ size_t __tmp = n/8;
> if((bs)->bit+(n%8)>7) { CHECK_BOUND(bs, __tmp + 2); } else {
> CHECK_BOUND(bs, __tmp + 1); } })
>  static unsigned int get_len(bitstr_t *bs);
>  static unsigned int get_bit(bitstr_t *bs);
>  static unsigned int get_bits(bitstr_t *bs, unsigned int b);
> @@ -319,9 +320,11 @@ static int decode_int(bitstr_t *bs, const struct
> field_t *f,
>  		bs->cur += 2;
>  		break;
>  	case CONS:		/* 64K < Range < 4G */
> +		CHECK_BIT_BOUND(bs, 2)
>  		len = get_bits(bs, 2) + 1;
>  		BYTE_ALIGN(bs);
>  		if (base && (f->attr & DECODE)) {	/* timeToLive */
> +			CHECK_BOUND(bs, len);
>  			unsigned int v = get_uint(bs, len) + f->lb;
>  			PRINT(" = %u", v);
>  			*((unsigned int *)(base + f->offset)) = v;
> @@ -404,6 +407,7 @@ static int decode_numstr(bitstr_t *bs, const struct
> field_t *f,
>  	PRINT("%*.s%s\n", level * TAB_SIZE, " ", f->name);
> 
>  	/* 2 <= Range <= 255 */
> +	CHECK_BIT_BOUND(bs, f->sz);
>  	len = get_bits(bs, f->sz) + f->lb;
> 
>  	BYTE_ALIGN(bs);
> @@ -449,6 +453,7 @@ static int decode_octstr(bitstr_t *bs, const struct
> field_t *f,
>  		len = get_len(bs) + f->lb;
>  		break;
>  	default:		/* 2 <= Range <= 255 */
> +		CHECK_BIT_BOUND(bs, f->sz);
>  		len = get_bits(bs, f->sz) + f->lb;
>  		BYTE_ALIGN(bs);
>  		break;
> @@ -477,6 +482,7 @@ static int decode_bmpstr(bitstr_t *bs, const struct
> field_t *f,
>  		len = (*bs->cur++) + f->lb;
>  		break;
>  	default:		/* 2 <= Range <= 255 */
> +		CHECK_BIT_BOUND(bs, f->sz);
>  		len = get_bits(bs, f->sz) + f->lb;
>  		BYTE_ALIGN(bs);
>  		break;
> @@ -503,9 +509,11 @@ static int decode_seq(bitstr_t *bs, const struct
> field_t *f,
>  	base = (base && (f->attr & DECODE)) ? base + f->offset : NULL;
> 
>  	/* Extensible? */
> +	CHECK_BIT_BOUND(bs, 1);
>  	ext = (f->attr & EXT) ? get_bit(bs) : 0;
> 
>  	/* Get fields bitmap */
> +	CHECK_BIT_BOUND(bs, f->sz);
>  	bmp = get_bitmap(bs, f->sz);
>  	if (base)
>  		*(unsigned int *)base = bmp;
> @@ -555,8 +563,9 @@ static int decode_seq(bitstr_t *bs, const struct
> field_t *f,
>  		return H323_ERROR_NONE;
> 
>  	/* Get the extension bitmap */
> +	CHECK_BIT_BOUND(bs, 7);
>  	bmp2_len = get_bits(bs, 7) + 1;
> -	CHECK_BOUND(bs, (bmp2_len + 7) >> 3);
> +	CHECK_BIT_BOUND(bs, bmp2_len);
>  	bmp2 = get_bitmap(bs, bmp2_len);
>  	bmp |= bmp2 >> f->sz;
>  	if (base)
> @@ -639,6 +648,7 @@ static int decode_seqof(bitstr_t *bs, const struct
> field_t *f,
>  		count = get_len(bs);
>  		break;
>  	default:
> +		CHECK_BIT_BOUND(bs, f->sz);
>  		count = get_bits(bs, f->sz);
>  		break;
>  	}
> @@ -658,6 +668,7 @@ static int decode_seqof(bitstr_t *bs, const struct
> field_t *f,
>  	for (i = 0; i < count; i++) {
>  		if (son->attr & OPEN) {
>  			BYTE_ALIGN(bs);
> +			CHECK_BOUND(bs, 2);
>  			len = get_len(bs);
>  			CHECK_BOUND(bs, len);
>  			if (!base || !(son->attr & DECODE)) {
> @@ -710,11 +721,14 @@ static int decode_choice(bitstr_t *bs, const
> struct field_t *f,
>  	base = (base && (f->attr & DECODE)) ? base + f->offset : NULL;
> 
>  	/* Decode the choice index number */
> +	CHECK_BIT_BOUND(bs, 1);
>  	if ((f->attr & EXT) && get_bit(bs)) {
>  		ext = 1;
> +		CHECK_BIT_BOUND(bs, 7);
>  		type = get_bits(bs, 7) + f->lb;
>  	} else {
>  		ext = 0;
> +		CHECK_BIT_BOUND(bs, f->sz);
>  		type = get_bits(bs, f->sz);
>  		if (type >= f->lb)
>  			return H323_ERROR_RANGE;
> @@ -727,6 +741,7 @@ static int decode_choice(bitstr_t *bs, const struct
> field_t *f,
>  	/* Check Range */
>  	if (type >= f->ub) {	/* Newer version? */
>  		BYTE_ALIGN(bs);
> +		CHECK_BOUND(bs, 2);
>  		len = get_len(bs);
>  		CHECK_BOUND(bs, len);
>  		bs->cur += len;
> @@ -742,6 +757,7 @@ static int decode_choice(bitstr_t *bs, const struct
> field_t *f,
> 
>  	if (ext || (son->attr & OPEN)) {
>  		BYTE_ALIGN(bs);
> +		CHECK_BOUND(bs, 2);
>  		len = get_len(bs);
>  		CHECK_BOUND(bs, len);
>  		if (!base || !(son->attr & DECODE)) {
> 
> 
> -- 
> Eric Sesterhenn (Principal Security Consultant)
> X41 D-SEC GmbH, Dennewartstr. 25-27, D-52068 Aachen
> T: +49 241 9809418-0, Fax: -9
> Unternehmenssitz: Aachen, Amtsgericht Aachen: HRB19989
> Geschäftsführer: Markus Vervier
> 



