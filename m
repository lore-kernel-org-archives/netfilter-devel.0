Return-Path: <SRS0=edwS=ZZ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE641C432C0
	for <netfilter-devel@archiver.kernel.org>; Tue,  3 Dec 2019 11:03:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ABF5720661
	for <netfilter-devel@archiver.kernel.org>; Tue,  3 Dec 2019 11:03:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725838AbfLCLDX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 3 Dec 2019 06:03:23 -0500
Received: from correo.us.es ([193.147.175.20]:35548 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725773AbfLCLDX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 3 Dec 2019 06:03:23 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 58B79DA3E3
        for <netfilter-devel@vger.kernel.org>; Tue,  3 Dec 2019 12:02:56 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 47967DA781
        for <netfilter-devel@vger.kernel.org>; Tue,  3 Dec 2019 12:02:56 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 3D58CDA720; Tue,  3 Dec 2019 12:02:56 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1309ADA70C;
        Tue,  3 Dec 2019 12:02:54 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 03 Dec 2019 12:02:54 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (barqueta.lsi.us.es [150.214.188.150])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 026934265A5A;
        Tue,  3 Dec 2019 12:02:53 +0100 (CET)
Date:   Tue, 3 Dec 2019 12:02:54 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Stefano Brivio <sbrivio@redhat.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH,nf-next RFC 0/2] add NFTA_SET_ELEM_KEY_END
Message-ID: <20191203110254.maczg7zs4wrcg6th@salvia>
References: <20191202131407.500999-1-pablo@netfilter.org>
 <20191202171952.2e577345@elisabeth>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191202171952.2e577345@elisabeth>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Stefano,

On Mon, Dec 02, 2019 at 05:19:52PM +0100, Stefano Brivio wrote:
[...]
> On Mon,  2 Dec 2019 14:14:05 +0100
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
[...]
> > This patchset extends the netlink API to allow to express an interval
> > with one single element.
> > 
> > This simplifies this interface since userspace does not need to send two
> > independent elements anymore, one of the including the
> > NFT_SET_ELEM_INTERVAL_END flag.
> > 
> > The idea is to use the _DESC to specify that userspace speaks the kernel
> > that new API representation. In your case, the new description attribute
> > that tells that this set contains interval + concatenation implicitly
> > tells the kernel that userspace supports for this new API.
> 
> Thanks! I just had a quick look, I think the new set implementation
> would indeed look more elegant this way. As to design choices, I'm
> afraid I'm not familiar enough with the big picture to comment on the
> general idea, but my uninformed opinion agrees with this approach. :)
> 
> For what it's worth, I'd review this in deeper detail next.

Thanks.

> > If you're fine with this, I can scratch a bit of time to finish the
> > libnftnl part. The nft code will need a small update too. You will not
> > need to use the nft_set_pipapo object as scratchpad area anymore.
> 
> On my side, I'm almost done with nft/libnftnl/kernel changes for the
> NFT_SET_DESC_CONCAT thing. How should we proceed? Do you want me to
> share those patches so that you can add this bit on top, or should this
> come first, or in a separate series?

My suggestion is that you can take them and place them at the
beginning of your batch since it will be the first client for this new
netlink attribute, you will have to adapt pipapo to use the new
key_end value too.

> I could also just share the new nft/libnftnl patches (I should have them
> ready between today and tomorrow), and proceed adapting the kernel part
> according to your changes.

I still have to send you the libnftnl part for this.

> Related question: to avoid copying data around, I'm now dynamically
> allocating a struct nft_data_desc in nf_tables_newset() with a
> reference from struct nft_set: desc->dlen, desc->klen, desc->size would
> all live there, together with the "subkey" stuff.
> 
> Is it a bad idea? I can undo it easily, I just don't know if there's a
> specific reason why those fields are repeated in struct nft_set.

Not sure I understand, probably some code sketch? From your words it
does not look like a major issue though, but let me know.

BTW, there is also one more pending issue: I can see there is a clone
point in nft_set_pipapo, you mentioned some problems to make things
fit in into the transaction infrastructure. Could you describe how you
integrate with it? Probably there is a chance to extend the front-end
API too to make it easier for pipapo.

Thanks.
