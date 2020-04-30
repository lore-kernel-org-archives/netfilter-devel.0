Return-Path: <SRS0=RE83=6O=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99481C83001
	for <netfilter-devel@archiver.kernel.org>; Thu, 30 Apr 2020 05:41:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4FF7C2082E
	for <netfilter-devel@archiver.kernel.org>; Thu, 30 Apr 2020 05:41:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726491AbgD3Flr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 30 Apr 2020 01:41:47 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:58221 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726391AbgD3Flq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 30 Apr 2020 01:41:46 -0400
Received: from dimstar.local.net (n175-34-64-112.sun1.vic.optusnet.com.au [175.34.64.112])
        by mail105.syd.optusnet.com.au (Postfix) with SMTP id 4109E3A3BCD
        for <netfilter-devel@vger.kernel.org>; Thu, 30 Apr 2020 15:41:42 +1000 (AEST)
Received: (qmail 11270 invoked by uid 501); 30 Apr 2020 05:41:41 -0000
Date:   Thu, 30 Apr 2020 15:41:41 +1000
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     netfilter-devel@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH libnetfilter_queue 1/3] pktbuff: add pktb_alloc_head()
 and pktb_build_data()
Message-ID: <20200430054141.GE3833@dimstar.local.net>
Mail-Followup-To: netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>
References: <20200426132356.8346-1-pablo@netfilter.org>
 <20200426132356.8346-2-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200426132356.8346-2-pablo@netfilter.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=keeXcwCgVCrAuxOn72dlvA==:117 a=keeXcwCgVCrAuxOn72dlvA==:17
        a=kj9zAlcOel0A:10 a=cl8xLZFz6L8A:10 a=RSmzAf-M6YYA:10 a=3HDBlxybAAAA:8
        a=zTG73k9i9ECIxAVFpFMA:9 a=CjuIK1q_8ugA:10 a=laEoCiVfU_Unz3mSdgXN:22
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sun, Apr 26, 2020 at 03:23:54PM +0200, Pablo Neira Ayuso wrote:
> Add two new helper functions to skip memcpy()'ing the payload from the
> netlink message.
>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  include/libnetfilter_queue/pktbuff.h |  3 +++
>  src/extra/pktbuff.c                  | 20 ++++++++++++++++++++
>  2 files changed, 23 insertions(+)
>
> diff --git a/include/libnetfilter_queue/pktbuff.h b/include/libnetfilter_queue/pktbuff.h
> index 42bc153ec337..f9bddaf072fb 100644
> --- a/include/libnetfilter_queue/pktbuff.h
> +++ b/include/libnetfilter_queue/pktbuff.h
> @@ -4,8 +4,11 @@
>  struct pkt_buff;
>
>  struct pkt_buff *pktb_alloc(int family, void *data, size_t len, size_t extra);
> +struct pkt_buff *pktb_alloc_head(void);
>  void pktb_free(struct pkt_buff *pktb);
>
> +void pktb_build_data(struct pkt_buff *pktb, uint8_t *payload, uint32_t len);
> +
>  uint8_t *pktb_data(struct pkt_buff *pktb);
>  uint32_t pktb_len(struct pkt_buff *pktb);
>
> diff --git a/src/extra/pktbuff.c b/src/extra/pktbuff.c
> index 6dd0ca98aff2..a93e72ac7795 100644
> --- a/src/extra/pktbuff.c
> +++ b/src/extra/pktbuff.c
> @@ -93,6 +93,26 @@ struct pkt_buff *pktb_alloc(int family, void *data, size_t len, size_t extra)
>  	return pktb;
>  }
>
> +EXPORT_SYMBOL
> +struct pkt_buff *pktb_alloc_head(void)

I think we agreed to dispense with this function?
> +{
> +	struct pkt_buff *pktb;
> +
> +	pktb = calloc(1, sizeof(struct pkt_buff));
The callback (CB) needs to zeroise head: calling calloc() here is ineffective.
At least the *mangled* flag must be cleared, also the new *copy_done* flag.
> +	if (pktb == NULL)
> +		return NULL;
The above 2 lines are unnecessary
> +
> +	return pktb;
> +}
> +
> +EXPORT_SYMBOL
> +void pktb_build_data(struct pkt_buff *pktb, uint8_t *payload, uint32_t len)
> +{
> +	pktb->len = len;
> +	pktb->data_len = len;
> +	pktb->data = payload;
Also
+	mangled = false;
Maybe nullify the other pointers?
> +}
> +
>  /**
>   * pktb_data - get pointer to network packet
>   * \param pktb Pointer to userspace packet buffer
> --
> 2.20.1
>
-Duncan
