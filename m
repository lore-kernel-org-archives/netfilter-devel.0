Return-Path: <SRS0=iSAz=WD=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0E06C32751
	for <netfilter-devel@archiver.kernel.org>; Wed,  7 Aug 2019 20:31:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9827A21BE3
	for <netfilter-devel@archiver.kernel.org>; Wed,  7 Aug 2019 20:31:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389419AbfHGUb6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 7 Aug 2019 16:31:58 -0400
Received: from correo.us.es ([193.147.175.20]:51832 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389413AbfHGUb6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 7 Aug 2019 16:31:58 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 8A8A01031F0
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Aug 2019 22:31:55 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 70D751150CB
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Aug 2019 22:31:55 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 66855DA72F; Wed,  7 Aug 2019 22:31:55 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2530CDA72F;
        Wed,  7 Aug 2019 22:31:53 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 07 Aug 2019 22:31:53 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (149.103.108.93.rev.vodafone.pt [93.108.103.149])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 894464265A2F;
        Wed,  7 Aug 2019 22:31:52 +0200 (CEST)
Date:   Wed, 7 Aug 2019 22:31:46 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     Dirk Morris <dmorris@metaloft.com>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net] netfilter: Use consistent ct id hash calculation
Message-ID: <20190807203146.bmlvjw4kvkbd5dns@salvia>
References: <e5d48c19-508d-e1ed-1f16-8e0a3773c619@metaloft.com>
 <20190807003416.v2q3qpwen6cwgzqu@breakpoint.cc>
 <33301d87-0bc2-b332-d48c-6aa6ef8268e8@metaloft.com>
 <20190807163641.vrid7drwsyk2cer4@salvia>
 <20190807180157.ogsx435gxih7wo7r@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190807180157.ogsx435gxih7wo7r@breakpoint.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Aug 07, 2019 at 08:01:57PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > @Florian: by mangling this patch not to use ct->ext, including Dirk's
> > update, conntrackd works again (remember that bug we discussed during
> > NFWS).
> 
> But conntrackd is still borken.
> It can't rely on id recycling  -- it will just take a lot
> longer before it starts to fill up.

Conntrackd does not rely on ID recycling. Conntrackd is in trouble
because of event loss. It seems the event re-delivery routine is
buggy, if the destroy event gets to userspace sooner or later, then
this entry would not get stuck in the cache forever. I can just remove
the check for the ID in userspace, so conntrackd would get rid of the
stale entry by when a new entry with the same tuple shows up (lazy
garbage collection).

> > @@ -470,8 +470,8 @@ u32 nf_ct_get_id(const struct nf_conn *ct)
> >  
> >         a = (unsigned long)ct;
> >         b = (unsigned long)ct->master ^ net_hash_mix(nf_ct_net(ct));
> > -       c = (unsigned long)ct->ext;
> > -       d = (unsigned long)siphash(&ct->tuplehash[IP_CT_DIR_ORIGINAL], sizeof(ct->tuplehash[IP_CT_DIR_ORIGINAL]),
> > +       c = (unsigned long)0;
> > +       d = (unsigned long)siphash(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple, sizeof(ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
>  
> > I think it's safe to turn this into:
> > 
> >         a = (unsigned long)ct;
> >         b = (unsigned long)ct->master;
> >         c = (unsigned long)nf_ct_net(ct));
> >         d = (unsigned long)siphash(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple, sizeof(ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
> 
> No, not if we allow using the function before confirmation, the tuple
> can also change in original dir when e.g. queuing before NAT hooks.

Tuple could be artificially built from original source as source and
reply source as destination, those never change IIRC.

This hash-based ID calculation is a simple approach, but it looks weak
/ easy to break.
