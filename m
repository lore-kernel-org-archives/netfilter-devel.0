Return-Path: <SRS0=7QpW=T7=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 608E0C28CC2
	for <netfilter-devel@archiver.kernel.org>; Fri, 31 May 2019 09:59:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 435C026748
	for <netfilter-devel@archiver.kernel.org>; Fri, 31 May 2019 09:59:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726593AbfEaJ77 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 31 May 2019 05:59:59 -0400
Received: from mail.us.es ([193.147.175.20]:36274 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726515AbfEaJ76 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 31 May 2019 05:59:58 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 00666819A5
        for <netfilter-devel@vger.kernel.org>; Fri, 31 May 2019 11:59:57 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E4945DA714
        for <netfilter-devel@vger.kernel.org>; Fri, 31 May 2019 11:59:56 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id D7486DA71A; Fri, 31 May 2019 11:59:56 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CCFF9DA712;
        Fri, 31 May 2019 11:59:54 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 31 May 2019 11:59:54 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id AA9D340705C6;
        Fri, 31 May 2019 11:59:54 +0200 (CEST)
Date:   Fri, 31 May 2019 11:59:54 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft,v3 2/7] mnl: mnl_set_rcvbuffer() skips buffer size
 update if it is too small
Message-ID: <20190531095954.p2yms677clmsbmv7@salvia>
References: <20190530111246.14550-1-pablo@netfilter.org>
 <20190531093012.GH31548@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190531093012.GH31548@orbyte.nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, May 31, 2019 at 11:30:12AM +0200, Phil Sutter wrote:
> Hi Pablo,
> 
> On Thu, May 30, 2019 at 01:12:46PM +0200, Pablo Neira Ayuso wrote:
> > Check for existing buffer size, if this is larger than the newer buffer
> > size, skip this size update.
> > 
> > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > ---
> > v3: 'len' variable was not properly set.
> > 
> >  src/mnl.c | 7 +++++++
> >  1 file changed, 7 insertions(+)
> > 
> > diff --git a/src/mnl.c b/src/mnl.c
> > index 288a887df097..2270a084ad29 100644
> > --- a/src/mnl.c
> > +++ b/src/mnl.c
> > @@ -235,8 +235,15 @@ static void mnl_set_sndbuffer(const struct mnl_socket *nl,
> >  
> >  static int mnl_set_rcvbuffer(const struct mnl_socket *nl, size_t bufsiz)
> >  {
> > +	unsigned int cur_bufsiz;
> > +	socklen_t len = sizeof(cur_bufsiz);
> >  	int ret;
> >  
> > +	ret = getsockopt(mnl_socket_get_fd(nl), SOL_SOCKET, SO_RCVBUF,
> > +			 &cur_bufsiz, &len);
> > +	if (cur_bufsiz > bufsiz)
> > +		return 0;
> > +
> 
> For mnl_set_sndbuffer(), there is simply a global static variable
> holding the last set value. Can't we use that here as well? I think of
> something like:
> 
> + static unsigned int nlsndbufsiz;
> 
>  static int mnl_set_rcvbuffer(const struct mnl_socket *nl, size_t bufsiz)
>  {
> +	socklen_t len = sizeof(nlsndbufsiz);
>  	int ret;
>  
> +	if (!nlsndbufsiz)
> +		ret = getsockopt(mnl_socket_get_fd(nl), SOL_SOCKET, SO_RCVBUF,
> +				 &nlsndbufsiz, &len);
> +	if (nlsndbufsiz >= bufsiz)
> +		return 0;

Yes, I'm going to send a v4 including this change you propose.

Thanks!
