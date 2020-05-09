Return-Path: <SRS0=rZfM=6X=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46FC0C47247
	for <netfilter-devel@archiver.kernel.org>; Sat,  9 May 2020 16:09:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 260232192A
	for <netfilter-devel@archiver.kernel.org>; Sat,  9 May 2020 16:09:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728237AbgEIQJJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 9 May 2020 12:09:09 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:44441 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727863AbgEIQJJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 9 May 2020 12:09:09 -0400
Received: from dimstar.local.net (n175-34-64-112.sun1.vic.optusnet.com.au [175.34.64.112])
        by mail105.syd.optusnet.com.au (Postfix) with SMTP id 09D223A3FF2
        for <netfilter-devel@vger.kernel.org>; Sun, 10 May 2020 02:09:05 +1000 (AEST)
Received: (qmail 30888 invoked by uid 501); 9 May 2020 16:09:03 -0000
Date:   Sun, 10 May 2020 02:09:03 +1000
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH libnetfilter_queue 2/2] pktbuff: add pktb_head_alloc(),
 pktb_setup() and pktb_head_size()
Message-ID: <20200509160903.GF26529@dimstar.local.net>
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
        a=37rGoeeWIGCFrgcYRlgA:9 a=CjuIK1q_8ugA:10 a=laEoCiVfU_Unz3mSdgXN:22
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
> +size_t pktb_head_size(void);
> +
> +#define pktb_head_alloc()	(struct pkt_buff *)(malloc(pktb_head_size()))
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
> +{
> +	pktb->data_len = len + extra;

Are you proposing to be able to use extra space in the receive buffer?
I think that is unsafe. mnl_cb_run() steps through that bufffer and needs a
zero following the last message to know there are no more. At least, that's
how it looks to me on stepping through with gdb.

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
Will post an alternative in the morning - D.
