Return-Path: <SRS0=7QpW=T7=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7910C04AB6
	for <netfilter-devel@archiver.kernel.org>; Fri, 31 May 2019 18:11:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C4E3226DAB
	for <netfilter-devel@archiver.kernel.org>; Fri, 31 May 2019 18:11:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726701AbfEaSLn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 31 May 2019 14:11:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38886 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726638AbfEaSLn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 31 May 2019 14:11:43 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D30F9B0AA6;
        Fri, 31 May 2019 18:11:42 +0000 (UTC)
Received: from egarver.localdomain (ovpn-122-157.rdu2.redhat.com [10.10.122.157])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 19E8558C81;
        Fri, 31 May 2019 18:11:42 +0000 (UTC)
Date:   Fri, 31 May 2019 14:11:41 -0400
From:   Eric Garver <eric@garver.life>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, phil@nwl.cc
Subject: Re: [PATCH nft,v2 5/7] mnl: estimate receiver buffer size
Message-ID: <20190531181141.s2znspcdty5ihgvd@egarver.localdomain>
Mail-Followup-To: Eric Garver <eric@garver.life>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, phil@nwl.cc
References: <20190530105529.12657-1-pablo@netfilter.org>
 <20190530105529.12657-5-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190530105529.12657-5-pablo@netfilter.org>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Fri, 31 May 2019 18:11:43 +0000 (UTC)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, May 30, 2019 at 12:55:27PM +0200, Pablo Neira Ayuso wrote:
> Set a receiver buffer size based on the number of commands and the
> average message size, this is useful for the --echo option in order to
> avoid ENOBUFS errors.
> 
> Double the estimated size is used to ensure enough receiver buffer
> space.
> 
> Skip buffer receiver logic if estimation is smaller than current buffer.
> 
> Reported-by: Phil Sutter <phil@nwl.cc>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
[..]
> diff --git a/src/libnftables.c b/src/libnftables.c
> index 199dbc97b801..a58b8ca9dcf6 100644
> --- a/src/libnftables.c
> +++ b/src/libnftables.c
[..]
> @@ -308,14 +310,17 @@ int mnl_batch_talk(struct netlink_ctx *ctx, struct list_head *err_list)
>  		.tv_sec		= 0,
>  		.tv_usec	= 0
>  	};
> -	fd_set readfds;
>  	struct iovec iov[iov_len];
>  	struct msghdr msg = {};
> +	fd_set readfds;
>  	int err = 0;
>  
>  	mnl_set_sndbuffer(ctx->nft->nf_sock, ctx->batch);
>  
> -	mnl_nft_batch_to_msg(ctx, &msg, &snl, iov, iov_len);
> +	batch_size = mnl_nft_batch_to_msg(ctx, &msg, &snl, iov, iov_len);
> +	avg_msg_size = div_round_up(batch_size, num_cmds);
> +
> +	mnl_set_rcvbuffer(ctx->nft->nf_sock, num_cmds * avg_msg_size * 2);

I think this calculation is incorrect. I'm still getting ENOBUFS with
Phil's testcase and firewalld's testsuite (large json blob). I changed
the multiplier from 2 to 6 and it worked.


-->8--

# ./run-tests.sh ./testcases/transactions/0049huge_0                                                                                                                                                                                                          
I: using nft binary ./../../src/nft                                                                                                                                                                                                                                             
                                                                                                                                                                                                                                                                                
W: [FAILED]     ./testcases/transactions/0049huge_0: got 1
netlink: Error: Could not process rule: No buffer space available                                                                                                                                                                                                               
                                                                                                                                                                                                                                                                                
I: results: [OK] 0 [FAILED] 1 [TOTAL] 1
