Return-Path: <SRS0=eo3W=4M=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8BEBC35673
	for <netfilter-devel@archiver.kernel.org>; Mon, 24 Feb 2020 01:03:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AE0102067D
	for <netfilter-devel@archiver.kernel.org>; Mon, 24 Feb 2020 01:03:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727165AbgBXBD7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 23 Feb 2020 20:03:59 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:39687 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727148AbgBXBD7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 23 Feb 2020 20:03:59 -0500
Received: from dimstar.local.net (n122-110-29-255.sun2.vic.optusnet.com.au [122.110.29.255])
        by mail105.syd.optusnet.com.au (Postfix) with SMTP id 8A44B3A15E2
        for <netfilter-devel@vger.kernel.org>; Mon, 24 Feb 2020 12:03:45 +1100 (AEDT)
Received: (qmail 3742 invoked by uid 501); 24 Feb 2020 01:03:44 -0000
Date:   Mon, 24 Feb 2020 12:03:44 +1100
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     Netfilter Development <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH libnetfilter_queue] src: add nfq_get_skbinfo()
Message-ID: <20200224010344.GA3564@dimstar.local.net>
Mail-Followup-To: Netfilter Development <netfilter-devel@vger.kernel.org>,
        Florian Westphal <fw@strlen.de>
References: <20200223234941.44877-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200223234941.44877-1-fw@strlen.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=xEIwVUYJq7t7CX9UEWuoUA==:117 a=xEIwVUYJq7t7CX9UEWuoUA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=l697ptgUJYAA:10
        a=RSmzAf-M6YYA:10 a=fDsNTez0a6miIqfCtGYA:9 a=CjuIK1q_8ugA:10
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Feb 24, 2020 at 12:49:41AM +0100, Florian Westphal wrote:
> Silly, since its easy to fetch this via libmnl.
> Unfortunately there is a large number of software that uses the old
> API, so add a helper to return the attribute.
>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  fixmanpages.sh                                |  6 ++--
>  .../libnetfilter_queue/libnetfilter_queue.h   |  1 +
>  src/libnetfilter_queue.c                      | 31 +++++++++++++++++++
>  3 files changed, 36 insertions(+), 2 deletions(-)
>
> diff --git a/fixmanpages.sh b/fixmanpages.sh
> index 897086bad6df..4d12247d14f6 100755
> --- a/fixmanpages.sh
> +++ b/fixmanpages.sh
> @@ -11,8 +11,10 @@ function main
>      add2group nfq_get_nfmark nfq_get_timestamp nfq_get_indev nfq_get_physindev
>      add2group nfq_get_outdev nfq_get_physoutdev nfq_get_indev_name
>      add2group nfq_get_physindev_name nfq_get_outdev_name
> -    add2group nfq_get_physoutdev_name nfq_get_packet_hw nfq_get_uid
> -    add2group nfq_get_gid nfq_get_secctx nfq_get_payload
> +    add2group nfq_get_physoutdev_name nfq_get_packet_hw
> +    add2group nfq_get_skbinfo
> +    add2group nfq_get_uid nfq_get_gid
> +    add2group nfq_get_secctx nfq_get_payload
>    setgroup Queue nfq_fd
>      add2group nfq_create_queue nfq_destroy_queue nfq_handle_packet nfq_set_mode
>      add2group nfq_set_queue_flags nfq_set_queue_maxlen nfq_set_verdict
> diff --git a/include/libnetfilter_queue/libnetfilter_queue.h b/include/libnetfilter_queue/libnetfilter_queue.h
> index 092c57d07451..46e14e135458 100644
> --- a/include/libnetfilter_queue/libnetfilter_queue.h
> +++ b/include/libnetfilter_queue/libnetfilter_queue.h
> @@ -103,6 +103,7 @@ extern uint32_t nfq_get_indev(struct nfq_data *nfad);
>  extern uint32_t nfq_get_physindev(struct nfq_data *nfad);
>  extern uint32_t nfq_get_outdev(struct nfq_data *nfad);
>  extern uint32_t nfq_get_physoutdev(struct nfq_data *nfad);
> +extern uint32_t nfq_get_skbinfo(struct nfq_data *nfad);
>  extern int nfq_get_uid(struct nfq_data *nfad, uint32_t *uid);
>  extern int nfq_get_gid(struct nfq_data *nfad, uint32_t *gid);
>  extern int nfq_get_secctx(struct nfq_data *nfad, unsigned char **secdata);
> diff --git a/src/libnetfilter_queue.c b/src/libnetfilter_queue.c
> index 3cf9653393e6..f5462a374b80 100644
> --- a/src/libnetfilter_queue.c
> +++ b/src/libnetfilter_queue.c
> @@ -1210,6 +1210,37 @@ struct nfqnl_msg_packet_hw *nfq_get_packet_hw(struct nfq_data *nfad)
>  					struct nfqnl_msg_packet_hw);
>  }
>
> +/**
> + * nfq_get_skbinfo - return the NFQA_SKB_INFO meta information
> + * \param nfad Netlink packet data handle passed to callback function
> + *
> + * This can be used to obtain extra information about a packet by testing
> + * the returned integer for any of the following bit flags:
> + *
> + * - NFQA_SKB_CSUMNOTREADY
> + *   packet header checksums will be computed by hardware later on, i.e.
> + *   tcp/ip checksums in the packet must not be validated, application
> + *   should pretend they are correct.
> + * - NFQA_SKB_GSO
> + *   packet is an aggregated super-packet.  It exceeds device mtu and will
> + *   be (re-)split on transmit by hardware.
> + * - NFQA_SKB_CSUM_NOTVERIFIED
> + *   packet checksum was not yet verified by the kernel/hardware, for
> + *   example because this is an incoming packet and the NIC does not
> + *   perform checksum validation at hardware level.
> + * See nfq_set_queue_flags() documentation for more information.
> + *
> + * \return the skbinfo value
> + */
> +EXPORT_SYMBOL
> +uint32_t nfq_get_skbinfo(struct nfq_data *nfad)
> +{
> +	if (!nfnl_attr_present(nfad->data, NFQA_SKB_INFO))
> +		return 0;
> +
> +	return ntohl(nfnl_get_data(nfad->data, NFQA_SKB_INFO, uint32_t));
> +}
> +
>  /**
>   * nfq_get_uid - get the UID of the user the packet belongs to
>   * \param nfad Netlink packet data handle passed to callback function
> --
> 2.24.1
>
Can I suggest:

  > + *   example because this is an incoming packet and the NIC does not
  > + *   perform checksum validation at hardware level.
- > + * See nfq_set_queue_flags() documentation for more information.
  > + *
  > + * \return the skbinfo value
+ > + * \sa __nfq_set_queue_flags__(3)
  > + */
  > +EXPORT_SYMBOL

I think this will look better, especially on the man page.

Cheers ... Duncan.
