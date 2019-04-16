Return-Path: <SRS0=dF0f=SS=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59C2FC10F13
	for <netfilter-devel@archiver.kernel.org>; Tue, 16 Apr 2019 09:12:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2BD4420675
	for <netfilter-devel@archiver.kernel.org>; Tue, 16 Apr 2019 09:12:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728786AbfDPJMV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 16 Apr 2019 05:12:21 -0400
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:55890 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726160AbfDPJMV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 16 Apr 2019 05:12:21 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hGK8U-00017t-83; Tue, 16 Apr 2019 11:12:14 +0200
Date:   Tue, 16 Apr 2019 11:12:14 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Mukesh Ojha <mojha@codeaurora.org>
Cc:     Colin King <colin.king@canonical.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S . Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [NETFILTER]: nf_conntrack_h323: fix spelling mistake
 "authenticaton" -> "authentication"
Message-ID: <20190416091214.vjydcg3xblxtvosk@breakpoint.cc>
References: <20190415114414.24600-1-colin.king@canonical.com>
 <90e0d4af-77c5-6e4b-a364-5b9e342c83be@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <90e0d4af-77c5-6e4b-a364-5b9e342c83be@codeaurora.org>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 4/15/2019 5:14 PM, Colin King wrote:
> > diff --git a/net/netfilter/nf_conntrack_h323_types.c b/net/netfilter/nf_conntrack_h323_types.c
> > index d880f3523c1d..95a0b3d6b24d 100644
> > --- a/net/netfilter/nf_conntrack_h323_types.c
> > +++ b/net/netfilter/nf_conntrack_h323_types.c
> > @@ -1109,7 +1109,7 @@ static const struct field_t _SecurityCapabilities[] = {	/* SEQUENCE */
> >   	 _NonStandardParameter},
> >   	{FNAME("encryption") CHOICE, 2, 3, 3, SKIP | EXT, 0,
> >   	 _SecurityServiceMode},
> > -	{FNAME("authenticaton") CHOICE, 2, 3, 3, SKIP | EXT, 0,
> > +	{FNAME("authentication") CHOICE, 2, 3, 3, SKIP | EXT, 0,
> >   	 _SecurityServiceMode},
> >   	{FNAME("integrity") CHOICE, 2, 3, 3, SKIP | EXT, 0,
> >   	 _SecurityServiceMode},

https://www.itu.int/ITU-T/formal-language/itu-t/h/h225-0/2009/H323-MESSAGES.html says:
		         ...
SecurityCapabilities ::= SEQUENCE {
nonStandard    NonStandardParameter OPTIONAL,
encryption     SecurityServiceMode,
authenticaton  SecurityServiceMode,
integrity      SecurityServiceMode,
...
}

so this spelling seems intentional.
