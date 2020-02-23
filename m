Return-Path: <SRS0=J2Vc=4L=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFEB4C35673
	for <netfilter-devel@archiver.kernel.org>; Sun, 23 Feb 2020 22:16:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9AAF9206E0
	for <netfilter-devel@archiver.kernel.org>; Sun, 23 Feb 2020 22:16:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727151AbgBWWQc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 23 Feb 2020 17:16:32 -0500
Received: from correo.us.es ([193.147.175.20]:59786 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726302AbgBWWQc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 23 Feb 2020 17:16:32 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 1E84CEBAC7
        for <netfilter-devel@vger.kernel.org>; Sun, 23 Feb 2020 23:16:25 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0F88DDA3C3
        for <netfilter-devel@vger.kernel.org>; Sun, 23 Feb 2020 23:16:25 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 04DB8DA72F; Sun, 23 Feb 2020 23:16:25 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EF20BDA7B2;
        Sun, 23 Feb 2020 23:16:22 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sun, 23 Feb 2020 23:16:22 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id CCFF642EF4E0;
        Sun, 23 Feb 2020 23:16:22 +0100 (CET)
Date:   Sun, 23 Feb 2020 23:16:27 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Duncan Roe <duncan_roe@optusnet.com.au>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH libnetfilter_queue 1/1] src: move static nfq_hdr_put from
 examples/nf-queue.c into the library since everyone is going to want it.
Message-ID: <20200223221627.fuls57nduj5u7ree@salvia>
References: <20200204020003.6478-1-duncan_roe@optusnet.com.au>
 <20200204020003.6478-2-duncan_roe@optusnet.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200204020003.6478-2-duncan_roe@optusnet.com.au>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Feb 04, 2020 at 01:00:03PM +1100, Duncan Roe wrote:
> Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
> ---
>  examples/nf-queue.c                             | 15 -------------
>  include/libnetfilter_queue/libnetfilter_queue.h |  1 +
>  src/nlmsg.c                                     | 28 ++++++++++++++++++++++---
>  3 files changed, 26 insertions(+), 18 deletions(-)
> 
> diff --git a/examples/nf-queue.c b/examples/nf-queue.c
> index 960e244..112c3bf 100644
> --- a/examples/nf-queue.c
> +++ b/examples/nf-queue.c
> @@ -20,21 +20,6 @@
>  
>  static struct mnl_socket *nl;
>  
> -static struct nlmsghdr *
> -nfq_hdr_put(char *buf, int type, uint32_t queue_num)
> -{
> -	struct nlmsghdr *nlh = mnl_nlmsg_put_header(buf);
> -	nlh->nlmsg_type	= (NFNL_SUBSYS_QUEUE << 8) | type;
> -	nlh->nlmsg_flags = NLM_F_REQUEST;
> -
> -	struct nfgenmsg *nfg = mnl_nlmsg_put_extra_header(nlh, sizeof(*nfg));
> -	nfg->nfgen_family = AF_UNSPEC;
> -	nfg->version = NFNETLINK_V0;
> -	nfg->res_id = htons(queue_num);
> -
> -	return nlh;
> -}
> -
>  static void
>  nfq_send_verdict(int queue_num, uint32_t id)
>  {
> diff --git a/include/libnetfilter_queue/libnetfilter_queue.h b/include/libnetfilter_queue/libnetfilter_queue.h
> index 092c57d..3372099 100644
> --- a/include/libnetfilter_queue/libnetfilter_queue.h
> +++ b/include/libnetfilter_queue/libnetfilter_queue.h
> @@ -149,6 +149,7 @@ void nfq_nlmsg_verdict_put_mark(struct nlmsghdr *nlh, uint32_t mark);
>  void nfq_nlmsg_verdict_put_pkt(struct nlmsghdr *nlh, const void *pkt, uint32_t pktlen);
>  
>  int nfq_nlmsg_parse(const struct nlmsghdr *nlh, struct nlattr **attr);
> +struct nlmsghdr *nfq_hdr_put(char *buf, int type, uint32_t queue_num);
>  
>  #ifdef __cplusplus
>  } /* extern "C" */
> diff --git a/src/nlmsg.c b/src/nlmsg.c
> index 4f09bf6..f4123f3 100644
> --- a/src/nlmsg.c
> +++ b/src/nlmsg.c
> @@ -261,9 +261,9 @@ static int nfq_pkt_parse_attr_cb(const struct nlattr *attr, void *data)
>  
>  /**
>   * nfq_nlmsg_parse - set packet attributes from netlink message
> - * \param nlh netlink message that you want to read.
> - * \param attr pointer to array of attributes to set.
> - * \returns MNL_CB_OK on success or MNL_CB_ERROR if any error occurs.
> + * \param nlh Pointer to netlink message
> + * \param attr Pointer to array of attributes to set
> + * \returns MNL_CB_OK on success or MNL_CB_ERROR if any error occurs
>   */
>  EXPORT_SYMBOL
>  int nfq_nlmsg_parse(const struct nlmsghdr *nlh, struct nlattr **attr)
> @@ -272,6 +272,28 @@ int nfq_nlmsg_parse(const struct nlmsghdr *nlh, struct nlattr **attr)
>  			      nfq_pkt_parse_attr_cb, attr);
>  }
>  
> +/**
> + * nfq_hdr_put - Convert memory buffer into a Netlink buffer

Looks good. Just one small change: I'd suggest you rename this to
nfq_nlmsg_put.

Thanks.
