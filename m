Return-Path: <SRS0=iiCe=TW=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAC7AC282CE
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 May 2019 21:52:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8AD0820868
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 May 2019 21:52:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729980AbfEVVwP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 22 May 2019 17:52:15 -0400
Received: from mail.us.es ([193.147.175.20]:35092 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728615AbfEVVwP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 May 2019 17:52:15 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 8150CC1D4E
        for <netfilter-devel@vger.kernel.org>; Wed, 22 May 2019 23:52:12 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6F632DA707
        for <netfilter-devel@vger.kernel.org>; Wed, 22 May 2019 23:52:12 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 64FA5DA706; Wed, 22 May 2019 23:52:12 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5672DDA705;
        Wed, 22 May 2019 23:52:10 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 22 May 2019 23:52:10 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [31.4.219.46])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 2DEDB4265A32;
        Wed, 22 May 2019 23:52:10 +0200 (CEST)
Date:   Wed, 22 May 2019 23:52:07 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     =?iso-8859-1?Q?St=E9phane?= Veyret <sveyret@gmail.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next,v3] netfilter: nft_ct: add ct expectations support
Message-ID: <20190522215207.ben3plbsi3oduss6@salvia>
References: <20190517164031.8536-1-sveyret@gmail.com>
 <20190517164031.8536-2-sveyret@gmail.com>
 <20190522084615.tyjlorqfxyz5p2c2@salvia>
 <CAFs+hh6vX8-B9nyrTfN9=_qVr=0jYW9EYdmn0aQxg7gJXu0EMg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAFs+hh6vX8-B9nyrTfN9=_qVr=0jYW9EYdmn0aQxg7gJXu0EMg@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, May 22, 2019 at 01:39:57PM +0200, Stéphane Veyret wrote:
[...]
> Le mer. 22 mai 2019 à 10:46, Pablo Neira Ayuso <pablo@netfilter.org> a écrit :
> > I think we should set a maximum number of expectations to be created,
> > as a mandatory field, eg.
> >
> >           size 10;
>
> I feel it would be complicated to set, as it would require to keep
> track of all expectations set using this definition, and moreover,
> check if those expectations are still alive, or deleted because
> already used or timed out.

You can use the 'expecting[0]' counter in the ct helper extension to
limit the number of expectations per conntrack entry:

struct nf_conn_help {
[...]
        /* Current number of expected connections */
        u8 expecting[NF_CT_MAX_EXPECT_CLASSES];
};

You have to check if the ct helper area exists in first place.

> > > +     priv->l3num = ctx->family;
> >
> > priv->l3num is only set and never used, remove it. You'll also have to
>
> priv->l3num is used for setting expectation, in function
> nft_ct_expect_obj_eval (see the call to nf_ct_expect_init).

OK, thanks for explaining.

Still this new expectation extension won't work with NFPROTO_INET
tables though, since the expectation infrastructure does not know what
to do with NFPROTO_INET.

If NFPROTO_INET is specified, you could just fetch the l3proto from
the ct object, from the packet path by when you call
nf_ct_expect_init().

> > > +     nf_ct_helper_ext_add(ct, GFP_ATOMIC);
> >
> > I think you don't need nf_ct_helper_ext_add(...);
>
> Actually, I had to add this instruction. While testing the feature, i
> saw that, even if no helper is really set on the connection,
> expectation functions require NF_CT_EXT_HELPER to be set on master
> connection. Without it, there would be some null pointer exception,
> which fortunately is checked at expectation creation by
> __nf_ct_expect_check.

Thanks again for explaining.

You still have to check if the conntrack already has a helper
extensions, otherwise I'm afraid this resets it for this conntrack.
