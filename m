Return-Path: <SRS0=PuwI=UG=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28051C2BCA1
	for <netfilter-devel@archiver.kernel.org>; Fri,  7 Jun 2019 12:05:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 088832089E
	for <netfilter-devel@archiver.kernel.org>; Fri,  7 Jun 2019 12:05:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728624AbfFGMFp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 7 Jun 2019 08:05:45 -0400
Received: from mail.us.es ([193.147.175.20]:46082 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727450AbfFGMFp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 7 Jun 2019 08:05:45 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id AABEEC1A07
        for <netfilter-devel@vger.kernel.org>; Fri,  7 Jun 2019 14:05:43 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9D20ADA703
        for <netfilter-devel@vger.kernel.org>; Fri,  7 Jun 2019 14:05:43 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 9C50BDA709; Fri,  7 Jun 2019 14:05:43 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9868BDA703;
        Fri,  7 Jun 2019 14:05:41 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 07 Jun 2019 14:05:41 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 759574265A5B;
        Fri,  7 Jun 2019 14:05:41 +0200 (CEST)
Date:   Fri, 7 Jun 2019 14:05:41 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] mnl: bogus error when running monitor mode
Message-ID: <20190607120541.3lkvmqpjlyefcuoo@salvia>
References: <20190605173451.19031-1-pablo@netfilter.org>
 <20190605205214.GA31548@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190605205214.GA31548@orbyte.nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Jun 05, 2019 at 10:52:14PM +0200, Phil Sutter wrote:
> On Wed, Jun 05, 2019 at 07:34:51PM +0200, Pablo Neira Ayuso wrote:
> > Fix bogus error message:
> > 
> >  # nft monitor
> >  Cannot set up netlink socket buffer size to 16777216 bytes, falling back to 16777216 bytes
> > 
> > Fixes: bcf60fb819bf ("mnl: add mnl_set_rcvbuffer() and use it")
> > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > ---
> >  src/mnl.c | 2 --
> >  1 file changed, 2 deletions(-)
> > 
> > diff --git a/src/mnl.c b/src/mnl.c
> > index c0df2c941d88..a7693ef1de30 100644
> > --- a/src/mnl.c
> > +++ b/src/mnl.c
> > @@ -1433,8 +1433,6 @@ int mnl_nft_event_listener(struct mnl_socket *nf_sock, unsigned int debug_mask,
> >  
> >  	ret = mnl_set_rcvbuffer(nf_sock, bufsiz);
> >  	if (ret < 0)
> > -		nft_print(octx, "# Cannot increase netlink socket buffer size, expect message loss\n");
> > -	else
> >  		nft_print(octx, "# Cannot set up netlink socket buffer size to %u bytes, falling back to %u bytes\n",
> >  			  NFTABLES_NLEVENT_BUFSIZ, bufsiz);
> 
> This error message is not correct: If mnl_set_rcvbuffer() returned
> non-zero, both setsockopt() calls failed. The removed message would be
> more appropriate for that situation.

setsockopt() should not fail, I think. So this is unlikely to show up.

events are unreliable anyway, no matter if buffer is set or not.

> BTW: While being at it, maybe s/socket buffer/socket receive buffer/?

Yes I can update this.

Thanks for reviewing.
