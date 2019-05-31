Return-Path: <SRS0=7QpW=T7=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E717C04AB6
	for <netfilter-devel@archiver.kernel.org>; Fri, 31 May 2019 18:40:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0E96F26E04
	for <netfilter-devel@archiver.kernel.org>; Fri, 31 May 2019 18:40:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727057AbfEaSkj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 31 May 2019 14:40:39 -0400
Received: from mail.us.es ([193.147.175.20]:49318 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727005AbfEaSkj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 31 May 2019 14:40:39 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 98543190DC3
        for <netfilter-devel@vger.kernel.org>; Fri, 31 May 2019 20:40:37 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 87140DA70E
        for <netfilter-devel@vger.kernel.org>; Fri, 31 May 2019 20:40:37 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 7CE45DA70C; Fri, 31 May 2019 20:40:37 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 20F4DDA704;
        Fri, 31 May 2019 20:40:35 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 31 May 2019 20:40:35 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id F3A2F4265A31;
        Fri, 31 May 2019 20:40:34 +0200 (CEST)
Date:   Fri, 31 May 2019 20:40:34 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Eric Garver <eric@garver.life>, netfilter-devel@vger.kernel.org,
        phil@nwl.cc
Subject: Re: [PATCH nft,v2 5/7] mnl: estimate receiver buffer size
Message-ID: <20190531184034.ne5p3scrfooue3d6@salvia>
References: <20190530105529.12657-1-pablo@netfilter.org>
 <20190530105529.12657-5-pablo@netfilter.org>
 <20190531181141.s2znspcdty5ihgvd@egarver.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190531181141.s2znspcdty5ihgvd@egarver.localdomain>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, May 31, 2019 at 02:11:41PM -0400, Eric Garver wrote:
> On Thu, May 30, 2019 at 12:55:27PM +0200, Pablo Neira Ayuso wrote:
> > Set a receiver buffer size based on the number of commands and the
> > average message size, this is useful for the --echo option in order to
> > avoid ENOBUFS errors.
> > 
> > Double the estimated size is used to ensure enough receiver buffer
> > space.
> > 
> > Skip buffer receiver logic if estimation is smaller than current buffer.
> > 
> > Reported-by: Phil Sutter <phil@nwl.cc>
> > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > ---
> [..]
> > diff --git a/src/libnftables.c b/src/libnftables.c
> > index 199dbc97b801..a58b8ca9dcf6 100644
> > --- a/src/libnftables.c
> > +++ b/src/libnftables.c
> [..]
> > @@ -308,14 +310,17 @@ int mnl_batch_talk(struct netlink_ctx *ctx, struct list_head *err_list)
> >  		.tv_sec		= 0,
> >  		.tv_usec	= 0
> >  	};
> > -	fd_set readfds;
> >  	struct iovec iov[iov_len];
> >  	struct msghdr msg = {};
> > +	fd_set readfds;
> >  	int err = 0;
> >  
> >  	mnl_set_sndbuffer(ctx->nft->nf_sock, ctx->batch);
> >  
> > -	mnl_nft_batch_to_msg(ctx, &msg, &snl, iov, iov_len);
> > +	batch_size = mnl_nft_batch_to_msg(ctx, &msg, &snl, iov, iov_len);
> > +	avg_msg_size = div_round_up(batch_size, num_cmds);
> > +
> > +	mnl_set_rcvbuffer(ctx->nft->nf_sock, num_cmds * avg_msg_size * 2);
> 
> I think this calculation is incorrect.

Yes, see v4 of this patch:

https://patchwork.ozlabs.org/patch/1107737/

> I'm still getting ENOBUFS with Phil's testcase and firewalld's
> testsuite (large json blob). I changed the multiplier from 2 to 6
> and it worked.

I just pushed out the patchset, the last version is using a multiplier
of 4, I modified Phil's testcase to 100000 and it works fine. Please
try the version upstream and let me know.

We can enhance this code by checking for ENOBUFS in _sendmsg(), extend
the buffer size and retry. Then, we also need to update kernel code to
abort the transaction in case NLM_F_ECHO flag is set on and we hit
ENOBUFS.
