Return-Path: <SRS0=Xgm7=SK=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AF73C10F0E
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Apr 2019 01:51:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2C32C20855
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Apr 2019 01:51:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726456AbfDHBv0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 7 Apr 2019 21:51:26 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:45018 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726412AbfDHBv0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 7 Apr 2019 21:51:26 -0400
X-Greylist: delayed 1758 seconds by postgrey-1.27 at vger.kernel.org; Sun, 07 Apr 2019 21:51:25 EDT
Received: from dimstar.local.net (n175-33-58-214.meb2.vic.optusnet.com.au [175.33.58.214])
        by mail106.syd.optusnet.com.au (Postfix) with SMTP id 8975B3D8EA4
        for <netfilter-devel@vger.kernel.org>; Mon,  8 Apr 2019 11:21:55 +1000 (AEST)
Received: (qmail 3544 invoked by uid 501); 8 Apr 2019 01:21:54 -0000
Date:   Mon, 8 Apr 2019 11:21:54 +1000
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     netfilter-devel@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Fernando Fernandez Mancera <ffmancera@riseup.net>
Subject: Re: [PATCH nft] doc: update nft list plural form parameters
Message-ID: <20190408012154.GA3173@dimstar.local.net>
Mail-Followup-To: netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Fernando Fernandez Mancera <ffmancera@riseup.net>
References: <20190404114158.5758-1-ffmancera@riseup.net>
 <20190404120123.5d3mpuf2unlmmg6n@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190404120123.5d3mpuf2unlmmg6n@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=UJetJGXy c=1 sm=1 tr=0 cx=a_idp_d
        a=t7w6lFx7q6My/318K9/+uQ==:117 a=t7w6lFx7q6My/318K9/+uQ==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=oexKYjalfGEA:10
        a=bBqXziUQAAAA:8 a=CulaJ-4HOluxuF2fB3AA:9 a=CjuIK1q_8ugA:10
        a=BjKv_IHbNJvPKzgot4uq:22
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Apr 04, 2019 at 02:01:23PM +0200, Pablo Neira Ayuso wrote:
> Cc'ing Duncan, he's been helping with reviewing documentation.
>
> On Thu, Apr 04, 2019 at 01:41:58PM +0200, Fernando Fernandez Mancera wrote:
> > Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
> > ---
> >  doc/nft.txt | 13 +++++++++----
> >  1 file changed, 9 insertions(+), 4 deletions(-)
> >
> > diff --git a/doc/nft.txt b/doc/nft.txt
> > index d162dad..36a92fe 100644
> > --- a/doc/nft.txt
> > +++ b/doc/nft.txt
> > @@ -256,6 +256,7 @@ TABLES
> >  [verse]
> >  {add | create} *table* ['family'] 'table' [ {flags 'flags'} ]
> >  {delete | list | flush} *table* ['family'] 'table'
> > +list *tables*
> >  delete *table* ['family'] handle 'handle'
> >
> >  Tables are containers for chains, sets and stateful objects. They are identified
> > @@ -266,7 +267,8 @@ nfproto* keyword can be used to test which family (ipv4 or ipv6) context the
> >  packet is being processed in. When no address family is specified, *ip* is used
> >  by default. The only difference between add and create is that the former will
> >  not return an error if the specified table already exists while *create* will
> > -return an error.
> > +return an error. The plural form of list can be used to list all the existing
> > +tables.
>
> Not sure we need this sentence, I mean, not sure if reader will
> correlate this with 'list tables'.
>
> Probably just adding:
>
> list *tables*
>
> and so on, for other objects in the [verse] area is just enough.
>
> Thanks!

Hi Pablo,

I had no trouble understanding the sentence, but wouldn't it be clearer to
change it to simply

*list tables* lists all the existing tables.

Sorry for late reply - a bit behind with my emails.

Cheers ... Duncan.
