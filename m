Return-Path: <SRS0=v9tr=TU=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F17E1C04AAC
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 May 2019 14:59:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CFD1C20863
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 May 2019 14:59:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388072AbfETO7j (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 20 May 2019 10:59:39 -0400
Received: from mail.us.es ([193.147.175.20]:44310 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730927AbfETO7i (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 20 May 2019 10:59:38 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D16F1C1A02
        for <netfilter-devel@vger.kernel.org>; Mon, 20 May 2019 16:59:35 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C0F40DA70A
        for <netfilter-devel@vger.kernel.org>; Mon, 20 May 2019 16:59:35 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id B625BDA707; Mon, 20 May 2019 16:59:35 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A4C79DA705;
        Mon, 20 May 2019 16:59:33 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 20 May 2019 16:59:33 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 7F7D44265A32;
        Mon, 20 May 2019 16:59:33 +0200 (CEST)
Date:   Mon, 20 May 2019 16:59:33 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     fw@strlen.de, phil@nwl.cc
Subject: Re: [PATCH iptables RFC 4/4] nft: don't care about previous state in
 RESTART
Message-ID: <20190520145933.wyl2sks6x63s6ko6@salvia>
References: <20190520144115.29732-1-pablo@netfilter.org>
 <20190520144115.29732-5-pablo@netfilter.org>
 <20190520144938.gqjakvfck6v4akq3@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190520144938.gqjakvfck6v4akq3@salvia>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, May 20, 2019 at 04:49:38PM +0200, Pablo Neira Ayuso wrote:
> On Mon, May 20, 2019 at 04:41:15PM +0200, Pablo Neira Ayuso wrote:
> > We need to re-evalute based on the existing cache generation.
> > 
> > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > ---
> >  iptables/nft.c | 19 +++++++++++--------
> >  1 file changed, 11 insertions(+), 8 deletions(-)
> > 
> > diff --git a/iptables/nft.c b/iptables/nft.c
> > index c1a079b734cf..bc3847d7ea47 100644
> > --- a/iptables/nft.c
> > +++ b/iptables/nft.c
> > @@ -2782,10 +2782,10 @@ static void nft_refresh_transaction(struct nft_handle *h)
> >  			if (!tablename)
> >  				continue;
> >  			exists = nft_table_find(h, tablename);
> > -			if (n->skip && exists)
> > -				n->skip = 0;
> > -			else if (!n->skip && !exists)
> > +			if (exists)
> >  				n->skip = 1;
> > +			else
> > +				n->skip = 0;
> 
> Actually, this should be the opposite:
> 
>  			if (exists)
>  				n->skip = 0;
> 			else
> 				n->skip = 1;
> 
> So we only skip the flush if the table does not exist.
> 
> Still not working though, hitting EEXIST on CHAIN_USER_ADD.

Hm.

I also occasionally see "Message too long" errors, so looks like a few
more bugs ahead.
