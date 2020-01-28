Return-Path: <SRS0=fFh5=3R=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4C86C2D0DB
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Jan 2020 21:27:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9DC0E2173E
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Jan 2020 21:27:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726266AbgA1V15 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 28 Jan 2020 16:27:57 -0500
Received: from correo.us.es ([193.147.175.20]:43142 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726211AbgA1V15 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 Jan 2020 16:27:57 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 7FA4D1878A8
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Jan 2020 22:27:54 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 70AA4DA710
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Jan 2020 22:27:54 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 65E56DA707; Tue, 28 Jan 2020 22:27:54 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 56AC1DA701;
        Tue, 28 Jan 2020 22:27:52 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 28 Jan 2020 22:27:52 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 3B37742EF4E0;
        Tue, 28 Jan 2020 22:27:52 +0100 (CET)
Date:   Tue, 28 Jan 2020 22:27:51 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Stefano Brivio <sbrivio@redhat.com>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Kadlecsik =?iso-8859-1?Q?J=F3zsef?= <kadlec@blackhole.kfki.hu>,
        Eric Garver <eric@garver.life>, Phil Sutter <phil@nwl.cc>
Subject: Re: [PATCH libnftnl v3 1/2] set: Add support for
 NFTA_SET_DESC_CONCAT attributes
Message-ID: <20200128212751.exx3zl5pfeond5pi@salvia>
References: <cover.1579432712.git.sbrivio@redhat.com>
 <1c8f7f6ceca5a37c5115c75ed2ebcc337e78a3d1.1579432712.git.sbrivio@redhat.com>
 <20200128193016.42lnsncnvmypf62p@salvia>
 <20200128211752.00312b6a@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200128211752.00312b6a@redhat.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Jan 28, 2020 at 09:17:52PM +0100, Stefano Brivio wrote:
> On Tue, 28 Jan 2020 20:30:16 +0100
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> 
> > On Sun, Jan 19, 2020 at 02:35:25PM +0100, Stefano Brivio wrote:
> > > If NFTNL_SET_DESC_CONCAT data is passed, pass that to the kernel
> > > as NFTA_SET_DESC_CONCAT attributes: it describes the length of
> > > single concatenated fields, in bytes.
> > > 
> > > Similarly, parse NFTA_SET_DESC_CONCAT attributes if received
> > > from the kernel.
> > > 
> > > This is the libnftnl counterpart for nftables patch:
> > >   src: Add support for NFTNL_SET_DESC_CONCAT
> > > 
> > > v3:
> > >  - use NFTNL_SET_DESC_CONCAT and NFTA_SET_DESC_CONCAT instead of a
> > >    stand-alone NFTA_SET_SUBKEY attribute (Pablo Neira Ayuso)
> > >  - pass field length in bytes instead of bits, fields would get
> > >    unnecessarily big otherwise
> > > v2:
> > >  - fixed grammar in commit message
> > >  - removed copy of array bytes in nftnl_set_nlmsg_build_subkey_payload(),
> > >    we're simply passing values to htonl() (Phil Sutter)
> > > 
> > > Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
> > > ---
> > >  include/libnftnl/set.h |   1 +
> > >  include/set.h          |   2 +
> > >  src/set.c              | 111 ++++++++++++++++++++++++++++++++++-------
> > >  3 files changed, 95 insertions(+), 19 deletions(-)
> > > 
> > > diff --git a/include/libnftnl/set.h b/include/libnftnl/set.h
> > > index db3fa686d60a..dcae354b76c4 100644
> > > --- a/include/libnftnl/set.h
> > > +++ b/include/libnftnl/set.h
> > > @@ -24,6 +24,7 @@ enum nftnl_set_attr {
> > >  	NFTNL_SET_ID,
> > >  	NFTNL_SET_POLICY,
> > >  	NFTNL_SET_DESC_SIZE,
> > > +	NFTNL_SET_DESC_CONCAT,  
> > 
> > This one needs to be defined at the end to not break binary interface.
> 
> Hah, right, I just focused on not breaking kernel UAPI and didn't check
> this. I'll move it.

Good, thanks.

> > Compilation breaks for some reason:
> > 
> > In file included from ../include/internal.h:10,
> >                  from gen.c:9:
> > ../include/set.h:28:22: error: ‘NFT_REG32_COUNT’ undeclared here (not
> > in a function); did you mean ‘NFT_REG32_15’?
> >    28 |   uint8_t  field_len[NFT_REG32_COUNT];
> >       |                      ^~~~~~~~~~~~~~~
> >       |                      NFT_REG32_15
> 
> That's something that comes from kernel headers changes, now
> commit f3a2181e16f1 ("netfilter: nf_tables: Support for sets with
> multiple ranged fields"), this hunk:
> 
> diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
> index c13106496bd2..065218a20bb7 100644
> --- a/include/uapi/linux/netfilter/nf_tables.h
> +++ b/include/uapi/linux/netfilter/nf_tables.h
> @@ -48,6 +48,7 @@ enum nft_registers {
>  
>  #define NFT_REG_SIZE   16
>  #define NFT_REG32_SIZE 4
> +#define NFT_REG32_COUNT        (NFT_REG32_15 - NFT_REG32_00 + 1)
>  
>  /**
>   * enum nft_verdicts - nf_tables internal verdicts
> 
> I didn't include those in userspace patches, following e.g. current
> iproute2 practice. Let me know if I should actually submit that as
> separate change -- I thought it would be more practical for you to sync
> headers as needed.

I'd suggest you send a separated patch to get the nf_tables.h cached
copy under libnftnl/include/linux/

I occasionally make patches like this one:

commit 239fabea9a436aaa7b787f389d80dfb57f7b893c
Author: Pablo Neira Ayuso <pablo@netfilter.org>
Date:   Tue Aug 13 21:41:45 2019 +0200

    include: resync nf_tables.h cache copy

    Get this header in sync with 5.3-rc1.

You bring all pending updates, so you help keep it sync :-)

Thanks.
