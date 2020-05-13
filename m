Return-Path: <SRS0=Lm+H=63=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 864F6C2D0F8
	for <netfilter-devel@archiver.kernel.org>; Wed, 13 May 2020 06:48:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6989B20708
	for <netfilter-devel@archiver.kernel.org>; Wed, 13 May 2020 06:48:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729578AbgEMGsV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 13 May 2020 02:48:21 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:54994 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728784AbgEMGsU (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 13 May 2020 02:48:20 -0400
Received: from dimstar.local.net (n175-34-64-112.sun1.vic.optusnet.com.au [175.34.64.112])
        by mail105.syd.optusnet.com.au (Postfix) with SMTP id 1D18B3A3FF5
        for <netfilter-devel@vger.kernel.org>; Wed, 13 May 2020 16:48:17 +1000 (AEST)
Received: (qmail 28405 invoked by uid 501); 13 May 2020 06:48:16 -0000
Date:   Wed, 13 May 2020 16:48:16 +1000
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH libnetfilter_queue 2/2] pktbuff: add pktb_head_alloc(),
 pktb_setup() and pktb_head_size()
Message-ID: <20200513064816.GB23132@dimstar.local.net>
Mail-Followup-To: netfilter-devel@vger.kernel.org
References: <20200509091141.10619-1-pablo@netfilter.org>
 <20200509091141.10619-2-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200509091141.10619-2-pablo@netfilter.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=QIgWuTDL c=1 sm=1 tr=0
        a=keeXcwCgVCrAuxOn72dlvA==:117 a=keeXcwCgVCrAuxOn72dlvA==:17
        a=kj9zAlcOel0A:10 a=sTwFKg_x9MkA:10 a=RSmzAf-M6YYA:10 a=3HDBlxybAAAA:8
        a=Lm8M50Lik8FVY7rSMqIA:9 a=TmVuaFoErMMYK7ql:21 a=UNV0kcJWMWx9M2Y3:21
        a=CjuIK1q_8ugA:10 a=laEoCiVfU_Unz3mSdgXN:22
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, May 09, 2020 at 11:11:41AM +0200, Pablo Neira Ayuso wrote:
> Add two new helper functions, as alternative to pktb_alloc().
>
> * pktb_setup() allows you to skip memcpy()'ing the payload from the
>   netlink message.
>
> * pktb_head_size() returns the size of the pkt_buff opaque object.
>
> * pktb_head_alloc() allows you to allocate the pkt_buff in the heap.
>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  include/libnetfilter_queue/pktbuff.h |  7 +++++++
>  src/extra/pktbuff.c                  | 20 ++++++++++++++++++++
>  2 files changed, 27 insertions(+)
>
> diff --git a/include/libnetfilter_queue/pktbuff.h b/include/libnetfilter_queue/pktbuff.h
> index 42bc153ec337..a27582b02840 100644
> --- a/include/libnetfilter_queue/pktbuff.h
> +++ b/include/libnetfilter_queue/pktbuff.h
> @@ -6,6 +6,13 @@ struct pkt_buff;
>  struct pkt_buff *pktb_alloc(int family, void *data, size_t len, size_t extra);
>  void pktb_free(struct pkt_buff *pktb);
>
> +#define NFQ_BUFFER_SIZE	(0xffff + (MNL_SOCKET_BUFFER_SIZE / 2)
> +struct pkt_buff *pktb_setup(struct pkt_buff *pktb, int family, uint8_t *data,
> +			    size_t len, size_t extra);

Prototypes in headers are generally on 1 line - see pktb_mangle() below

> +size_t pktb_head_size(void);
> +
> +#define pktb_head_alloc()	(struct pkt_buff *)(malloc(pktb_head_size()))

Users will never know about this. doxygen is configured to only look in .c
files, you wouldn't want it any other way.

Anyway, users can figure this one out for themselves, surely?
> +
>  uint8_t *pktb_data(struct pkt_buff *pktb);
>  uint32_t pktb_len(struct pkt_buff *pktb);
>
> diff --git a/src/extra/pktbuff.c b/src/extra/pktbuff.c
> index 118ad898f63b..6acefbe72a9b 100644
> --- a/src/extra/pktbuff.c
> +++ b/src/extra/pktbuff.c
> @@ -103,6 +103,26 @@ struct pkt_buff *pktb_alloc(int family, void *data, size_t len, size_t extra)
>  	return pktb;
>  }
>
> +EXPORT_SYMBOL
> +struct pkt_buff *pktb_setup(struct pkt_buff *pktb, int family, uint8_t *buf,
> +			    size_t len, size_t extra)

This calling sequence shuts out any possibility for pktb_mangle() to decide
whether a memcpy is needed because the packet is being lenghened.

Later in this thread, you write:

> There are "two buffers":
>
> 1) The buffer that you use to receive the netlink message. This buffer
>    is parsed via mnl_cb_run().
>
> 2) The buffer that stores the pkt_buff structure.

pktb_alloc() can acess both of these. It gets 1 in its arguments and calloc()s
the other. It could be enhanced to pass that information down to pktb_mangle()
via extra elements in struct pktbuff the way pktb_alloc2 does (I'm not
suggesting we should).

BUT, there is no way to do that for pktb_setup() as it is now. You need packet
data address & length, user buffer address & length, and family as a minimum. By
going back to the 'sk_buff' model, you don't need a 'head' argument - packet
data copy just follows the metadata immediately. 5 arguments, as the latest
iteration of pktb_alloc2 has. Suggest something like:

 struct pkt_buff *pktb_setup(int family, void *buf, size_t buflen,
                             void *data, size_t len)

I'm fine with renaming pktb_alloc2 to pktb_setup. Then, with the suggestions
below, the code is pretty much the same.

> +{

Before doing anything, you really need to memset all of pktb to zero. Otherwise
you get scenarios like this:

> (gdb) p *pktb
> $1 = {
>   mac_header = 0xffffffffffffffff <error: Cannot access memory at address 0xffffffffffffffff>,
>   network_header = 0x6052f8 <nlrxbuf+88> "`",
>   transport_header = 0x25252525ffffffff <error: Cannot access memory at address 0x25252525ffffffff>,
>   data = 0x6052f8 <nlrxbuf+88> "`",
>   len = 52,
>   data_len = 52,
>   mangled = 255,
> }

To be fair, that buffer was on the stack. If you do a pktb_head_alloc() early
on, you will likely fluke a bunch of zeroes. But, once a packet is mangled, the
mangle flag will stay on so all subsequent verdicts will contain packet contents
whether the packet was mangled or not.

> +	pktb->data_len = len + extra;
> +	pktb->data = buf;
> +	pktb->len = len;
> +
> +	if (__pktb_setup(family, pktb) < 0)
> +		return NULL;
> +
> +	return pktb;
> +}
> +
> +EXPORT_SYMBOL
> +size_t pktb_head_size(void)
> +{
> +	return sizeof(struct pkt_buff);
> +}
> +
>  /**
>   * pktb_data - get pointer to network packet
>   * \param pktb Pointer to userspace packet buffer
> --
> 2.20.1
>
