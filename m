Return-Path: <SRS0=+PqO=WE=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0509BC433FF
	for <netfilter-devel@archiver.kernel.org>; Thu,  8 Aug 2019 10:28:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D54942173E
	for <netfilter-devel@archiver.kernel.org>; Thu,  8 Aug 2019 10:28:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390027AbfHHK2d (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 8 Aug 2019 06:28:33 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:58946 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390025AbfHHK2d (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 8 Aug 2019 06:28:33 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hvfep-0008Do-0Y; Thu, 08 Aug 2019 12:28:31 +0200
Date:   Thu, 8 Aug 2019 12:28:30 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Dirk Morris <dmorris@metaloft.com>
Cc:     Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net] netfilter: Use consistent ct id hash calculation
Message-ID: <20190808102830.yl2wso3ax7nyiq5k@breakpoint.cc>
References: <e5d48c19-508d-e1ed-1f16-8e0a3773c619@metaloft.com>
 <20190807003416.v2q3qpwen6cwgzqu@breakpoint.cc>
 <33301d87-0bc2-b332-d48c-6aa6ef8268e8@metaloft.com>
 <20190807163641.vrid7drwsyk2cer4@salvia>
 <20190807180157.ogsx435gxih7wo7r@breakpoint.cc>
 <20190807203146.bmlvjw4kvkbd5dns@salvia>
 <20190807234552.lnfuktyr7cpvocki@breakpoint.cc>
 <f58a512a-0b74-c98d-067d-70ef67da0a95@metaloft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f58a512a-0b74-c98d-067d-70ef67da0a95@metaloft.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Dirk Morris <dmorris@metaloft.com> wrote:
> On 8/7/19 4:45 PM, Florian Westphal wrote:
> > So Pablos suggestion above should work just fine.
> > Dirk, can you spin a v2 with that change?
> > 
> 
> Yes, will do tomorrow.

Thanks.

> Also, just an idea, I also played around with just adding
> u32 id to struct nf_conn and just calculating the hash inside
> __nf_conntack_alloc when initialized or even lazily in nf_ct_get_id.
> This seems to work fine and you don't have to worry about anything changing
> and only calculate the hash once.
> 
> I'm presuming this method was avoided for some reason, like keeping the struct
> size to a minimum.

Yes, exactly.

If we go for storing id in the struct we could also just use a random
value rather than computing a hash.
