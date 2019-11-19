Return-Path: <SRS0=iRt+=ZL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67D03C432C0
	for <netfilter-devel@archiver.kernel.org>; Tue, 19 Nov 2019 19:40:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4785B2186D
	for <netfilter-devel@archiver.kernel.org>; Tue, 19 Nov 2019 19:40:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727295AbfKSTkT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 19 Nov 2019 14:40:19 -0500
Received: from correo.us.es ([193.147.175.20]:52802 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726620AbfKSTkT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 19 Nov 2019 14:40:19 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D217F303D03
        for <netfilter-devel@vger.kernel.org>; Tue, 19 Nov 2019 20:40:13 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BCE3DB7FF9
        for <netfilter-devel@vger.kernel.org>; Tue, 19 Nov 2019 20:40:13 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id B24D3B7FF2; Tue, 19 Nov 2019 20:40:13 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B16A8D2B1E;
        Tue, 19 Nov 2019 20:40:11 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 19 Nov 2019 20:40:11 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 8A71642EE38F;
        Tue, 19 Nov 2019 20:40:11 +0100 (CET)
Date:   Tue, 19 Nov 2019 20:40:13 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Christian =?iso-8859-1?Q?G=F6ttsche?= <cgzones@googlemail.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: nftables: secmark support
Message-ID: <20191119194013.fobvb5wfxz327esl@salvia>
References: <CAJ2a_DcUH1ZaovOTNS14Z64Bwj5R5y4LLmZUeEPWFaNKECS6mQ@mail.gmail.com>
 <20191022173411.zh3o2wnoqxpjhjkq@salvia>
 <CAJ2a_DdVOTDPpamh=DKcGde_8gp++xYPwBP=0gY3_GDqPFntrQ@mail.gmail.com>
 <CAJ2a_Df61oAEc4NSFZneThOpwQcsmmjf7_RiV9y-bePwYO-9Sw@mail.gmail.com>
 <20191118181849.k4tb5rnmcuzigbaw@salvia>
 <20191118183013.zaaupujid7pnmp33@salvia>
 <CAJ2a_Dd5NTOorEuPHzsUvj8kOTQmGWw6z6fUydMqCYibgHo8QQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJ2a_Dd5NTOorEuPHzsUvj8kOTQmGWw6z6fUydMqCYibgHo8QQ@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Nov 19, 2019 at 08:02:10PM +0100, Christian Göttsche wrote:
> > > 1) I would replace secmark_raw by secmark instead. I think we should
> > >    hide this assymmetry to the user. I would suggest you also extend
> > >    the evaluation phase, ie. expr_evaluate_meta() and expr_evaluate_ct()
> > >    to bail out in case the user tries to match on the raw packet / ct
> > >    secmark ID. IIRC, the only usecase for this raw ID is to save and
> > >    to restore the secmark from/to the packet to/from the conntrack
> > >    object.
> > >
> > > And a few minor issues:
> > >
> > > 2) Please remove meta_key_unqualified chunk.
> > >
> > >         meta_key_unqualified    SET stmt_expr
> >
> > I mean, this update (moving the location of this rule) is not
> > necessary, right? Thanks.
>
> Without these, I am stuck with
>
> $ ./src/nft -c -f files/examples/secmark.nft
> files/examples/secmark.nft:64:49-58: Error: Counter expression must be constant
>                 ct state established,related meta secmark set ct secmark
>                                                               ^^^^^^^^^^

meta_stmt               :       META    meta_key        SET stmt_expr
                        {
                                switch ($2) {
                                case NFT_META_SECMARK:
                                        $$ = objref_stmt_alloc(&@$);
                                        $$->objref.type = NFT_OBJECT_SECMARK;
                                        $$->objref.expr = $4;

Check for what type of expression you have on $4 from the parser code.
If this is EXPR_META or EXPR_CT, then this is restoring a value. If
that is the case, then you have to use meta_stmt_alloc(), not
objref_stmt_alloc(), since this is not a reference to object.
