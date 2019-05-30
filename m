Return-Path: <SRS0=kxmZ=T6=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4470DC28CC0
	for <netfilter-devel@archiver.kernel.org>; Thu, 30 May 2019 11:46:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 18A1625870
	for <netfilter-devel@archiver.kernel.org>; Thu, 30 May 2019 11:46:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726980AbfE3LqJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 30 May 2019 07:46:09 -0400
Received: from mail.us.es ([193.147.175.20]:43872 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726753AbfE3LqJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 30 May 2019 07:46:09 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 7C1B4FB6CC
        for <netfilter-devel@vger.kernel.org>; Thu, 30 May 2019 13:46:07 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6D6C9DA713
        for <netfilter-devel@vger.kernel.org>; Thu, 30 May 2019 13:46:07 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 62EA0DA70F; Thu, 30 May 2019 13:46:07 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5FED8DA70B;
        Thu, 30 May 2019 13:46:05 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 30 May 2019 13:46:05 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 3E7034265A31;
        Thu, 30 May 2019 13:46:05 +0200 (CEST)
Date:   Thu, 30 May 2019 13:46:04 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org, Eric Garver <e@erig.me>
Subject: Re: [nft PATCH 2/4] mnl: Increase receive buffer in mnl_batch_talk()
Message-ID: <20190530114604.qredzvoaf3naxmpr@salvia>
References: <20190529131346.23659-1-phil@nwl.cc>
 <20190529131346.23659-3-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190529131346.23659-3-phil@nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, May 29, 2019 at 03:13:44PM +0200, Phil Sutter wrote:
> Be prepared to receive larger messages for the same reason as in
> nft_mnl_recv() and mnl_nft_event_listener().
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
>  src/mnl.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/src/mnl.c b/src/mnl.c
> index 2c5a26a5e3465..06280aa2cb50a 100644
> --- a/src/mnl.c
> +++ b/src/mnl.c
> @@ -287,7 +287,7 @@ int mnl_batch_talk(struct netlink_ctx *ctx, struct list_head *err_list)
>  {
>  	struct mnl_socket *nl = ctx->nft->nf_sock;
>  	int ret, fd = mnl_socket_get_fd(nl), portid = mnl_socket_get_portid(nl);
> -	char rcv_buf[MNL_SOCKET_BUFFER_SIZE];
> +	char rcv_buf[NFT_NLMSG_MAXSIZE];

Revisiting this:

The kernel uses NLMSG_GOODSIZE for events and also for the echo
message, so MNL_SOCKET_BUFFER_SIZE should be fine.
