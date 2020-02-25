Return-Path: <SRS0=2ZCu=4N=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00E30C35E17
	for <netfilter-devel@archiver.kernel.org>; Tue, 25 Feb 2020 20:58:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D3A002176D
	for <netfilter-devel@archiver.kernel.org>; Tue, 25 Feb 2020 20:58:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729007AbgBYU6v (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 25 Feb 2020 15:58:51 -0500
Received: from correo.us.es ([193.147.175.20]:58752 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728162AbgBYU6v (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 25 Feb 2020 15:58:51 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 9B9AF12082A
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Feb 2020 21:58:42 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8CD78DA38D
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Feb 2020 21:58:42 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 827E9DA840; Tue, 25 Feb 2020 21:58:42 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9E577DA736;
        Tue, 25 Feb 2020 21:58:40 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 25 Feb 2020 21:58:40 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 7EA0B42EE38E;
        Tue, 25 Feb 2020 21:58:40 +0100 (CET)
Date:   Tue, 25 Feb 2020 21:58:47 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Stefano Brivio <sbrivio@redhat.com>
Cc:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org,
        Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf 0/2] nft_set_pipapo: Fix crash due to dangling entries
 in mapping table
Message-ID: <20200225205847.s5pjjp652unj6u7v@salvia>
References: <20200221211704.GM20005@orbyte.nwl.cc>
 <20200221232218.2157d72b@elisabeth>
 <20200222011933.GO20005@orbyte.nwl.cc>
 <20200223222258.2bb7516a@redhat.com>
 <20200225123934.p3vru3tmbsjj2o7y@salvia>
 <20200225141346.7406e06b@redhat.com>
 <20200225134236.sdz5ujufvxm2in3h@salvia>
 <20200225153435.17319874@redhat.com>
 <20200225202143.tqsfhggvklvhnsvs@salvia>
 <20200225213815.3c0a1caa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200225213815.3c0a1caa@redhat.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Feb 25, 2020 at 09:38:15PM +0100, Stefano Brivio wrote:
> On Tue, 25 Feb 2020 21:21:43 +0100
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> 
> > Hi Stefano,
> > 
> > On Tue, Feb 25, 2020 at 03:34:35PM +0100, Stefano Brivio wrote:
> > [...]
> > > This is the problem Phil reported:  
> > [...]
> > > Or also simply with:
> > > 
> > > # nft add element t s '{ 20-30 . 40 }'
> > > # nft add element t s '{ 25-35 . 40 }'
> > > 
> > > the second element is silently ignored. I'm returning -EEXIST from
> > > nft_pipapo_insert(), but nft_add_set_elem() clears it because NLM_F_EXCL
> > > is not set.
> > > 
> > > Are you suggesting that this is consistent and therefore not a problem?  
> > 
> >                         NLM_F_EXCL      !NLM_F_EXCL
> >         exact match       EEXIST             0 [*]
> >         partial match     EEXIST           EEXIST
> > 
> > The [*] case would allow for element timeout/expiration updates from
> > the control plane for exact matches.
> 
> A-ha. I didn't even consider that.
> 
> > Note that element updates are not
> > supported yet, so this check for !NLM_F_EXCL is a stub. I don't think
> > we should allow for updates on partial matches
> > 
> > I think what it is missing is a error to report "partial match" from
> > pipapo. Then, the core translates this "partial match" error to EEXIST
> > whether NLM_F_EXCL is set or not.
> 
> Yes, given what you explained, I also think it's the case.
> 
> > Would this work for you?
> 
> It would. I need to write a few more lines in nft_pipapo_insert(),
> because right now I don't have a special case for "entirely
> overlapping". Something on the lines of:
> 
> 	dup = pipapo_get(net, set, start, genmask);
> 	if (PTR_ERR(dup) == -ENOENT) {
> 
> -->		compare start and end key for this entry with
> 		start and end key from 'ext'
> 
> Let me know if you want me to post a patch with a placeholder for
> whatever you have in mind, or if I can help implementing this, etc.

Please, go ahead with the placeholder, it might be faster. I'll jump
on it.
