Return-Path: <SRS0=iSAz=WD=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9B50C32751
	for <netfilter-devel@archiver.kernel.org>; Wed,  7 Aug 2019 18:02:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8E3A822305
	for <netfilter-devel@archiver.kernel.org>; Wed,  7 Aug 2019 18:02:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389080AbfHGSCA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 7 Aug 2019 14:02:00 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:55630 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388163AbfHGSCA (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 7 Aug 2019 14:02:00 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hvQG5-000362-BO; Wed, 07 Aug 2019 20:01:57 +0200
Date:   Wed, 7 Aug 2019 20:01:57 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Dirk Morris <dmorris@metaloft.com>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net] netfilter: Use consistent ct id hash calculation
Message-ID: <20190807180157.ogsx435gxih7wo7r@breakpoint.cc>
References: <e5d48c19-508d-e1ed-1f16-8e0a3773c619@metaloft.com>
 <20190807003416.v2q3qpwen6cwgzqu@breakpoint.cc>
 <33301d87-0bc2-b332-d48c-6aa6ef8268e8@metaloft.com>
 <20190807163641.vrid7drwsyk2cer4@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190807163641.vrid7drwsyk2cer4@salvia>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > Listening to the conntrack events this does not happen, as you get the NEW event
> > only after the ct is confirmed, but unfortunately you get the packet from queue
> > and the log messages well before that.
> 
> ct->ext also might change while packet is in transit, since new
> extension can be added too.

Not after confirmation though.

> &ct->tuplehash was not good either for event retransmission, since
> hnnode might change (when moving the object to the dying list), so
> ct->tuplehash[x].tuple looks good to me.

Oh, thats a fair point (dying list), had not considered that.

So this needs fixing in any case.

> @Florian: by mangling this patch not to use ct->ext, including Dirk's
> update, conntrackd works again (remember that bug we discussed during
> NFWS).

But conntrackd is still borken.
It can't rely on id recycling  -- it will just take a lot
longer before it starts to fill up.

> @@ -470,8 +470,8 @@ u32 nf_ct_get_id(const struct nf_conn *ct)
>  
>         a = (unsigned long)ct;
>         b = (unsigned long)ct->master ^ net_hash_mix(nf_ct_net(ct));
> -       c = (unsigned long)ct->ext;
> -       d = (unsigned long)siphash(&ct->tuplehash[IP_CT_DIR_ORIGINAL], sizeof(ct->tuplehash[IP_CT_DIR_ORIGINAL]),
> +       c = (unsigned long)0;
> +       d = (unsigned long)siphash(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple, sizeof(ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
 
> I think it's safe to turn this into:
> 
>         a = (unsigned long)ct;
>         b = (unsigned long)ct->master;
>         c = (unsigned long)nf_ct_net(ct));
>         d = (unsigned long)siphash(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple, sizeof(ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);

No, not if we allow using the function before confirmation, the tuple
can also change in original dir when e.g. queuing before NAT hooks.
