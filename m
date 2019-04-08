Return-Path: <SRS0=Xgm7=SK=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C809C10F13
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Apr 2019 21:37:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2727820857
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Apr 2019 21:37:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726383AbfDHVhW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 8 Apr 2019 17:37:22 -0400
Received: from mail.us.es ([193.147.175.20]:46020 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726005AbfDHVhW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 8 Apr 2019 17:37:22 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C09AA303D1A
        for <netfilter-devel@vger.kernel.org>; Mon,  8 Apr 2019 23:37:20 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AD9EBDA707
        for <netfilter-devel@vger.kernel.org>; Mon,  8 Apr 2019 23:37:20 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id A34C1DA702; Mon,  8 Apr 2019 23:37:20 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9C64CDA704;
        Mon,  8 Apr 2019 23:37:18 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 08 Apr 2019 23:37:18 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 7AADE4265A31;
        Mon,  8 Apr 2019 23:37:18 +0200 (CEST)
Date:   Mon, 8 Apr 2019 23:37:18 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org,
        Fernando Fernandez Mancera <ffmancera@riseup.net>
Subject: Re: [PATCH nft] doc: update nft list plural form parameters
Message-ID: <20190408213718.4kqzltihoh4ewxrx@salvia>
References: <20190404114158.5758-1-ffmancera@riseup.net>
 <20190404120123.5d3mpuf2unlmmg6n@salvia>
 <20190408012154.GA3173@dimstar.local.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190408012154.GA3173@dimstar.local.net>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Apr 08, 2019 at 11:21:54AM +1000, Duncan Roe wrote:
> On Thu, Apr 04, 2019 at 02:01:23PM +0200, Pablo Neira Ayuso wrote:
> > Cc'ing Duncan, he's been helping with reviewing documentation.
> >
> > On Thu, Apr 04, 2019 at 01:41:58PM +0200, Fernando Fernandez Mancera wrote:
> > > Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
> > > ---
> > >  doc/nft.txt | 13 +++++++++----
> > >  1 file changed, 9 insertions(+), 4 deletions(-)
> > >
> > > diff --git a/doc/nft.txt b/doc/nft.txt
> > > index d162dad..36a92fe 100644
> > > --- a/doc/nft.txt
> > > +++ b/doc/nft.txt
> > > @@ -256,6 +256,7 @@ TABLES
> > >  [verse]
> > >  {add | create} *table* ['family'] 'table' [ {flags 'flags'} ]
> > >  {delete | list | flush} *table* ['family'] 'table'
> > > +list *tables*
> > >  delete *table* ['family'] handle 'handle'
> > >
> > >  Tables are containers for chains, sets and stateful objects. They are identified
> > > @@ -266,7 +267,8 @@ nfproto* keyword can be used to test which family (ipv4 or ipv6) context the
> > >  packet is being processed in. When no address family is specified, *ip* is used
> > >  by default. The only difference between add and create is that the former will
> > >  not return an error if the specified table already exists while *create* will
> > > -return an error.
> > > +return an error. The plural form of list can be used to list all the existing
> > > +tables.
> >
> > Not sure we need this sentence, I mean, not sure if reader will
> > correlate this with 'list tables'.
> >
> > Probably just adding:
> >
> > list *tables*
> >
> > and so on, for other objects in the [verse] area is just enough.
> >
> > Thanks!
> 
> Hi Pablo,
> 
> I had no trouble understanding the sentence, but wouldn't it be clearer to
> change it to simply
> 
> *list tables* lists all the existing tables.

Thanks, this is what Fernando has done in v2, all good :-)
