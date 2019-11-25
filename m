Return-Path: <SRS0=kuYc=ZR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4FA7C432C0
	for <netfilter-devel@archiver.kernel.org>; Mon, 25 Nov 2019 20:38:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 985402071E
	for <netfilter-devel@archiver.kernel.org>; Mon, 25 Nov 2019 20:38:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726984AbfKYUin (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 25 Nov 2019 15:38:43 -0500
Received: from correo.us.es ([193.147.175.20]:59024 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726980AbfKYUin (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 25 Nov 2019 15:38:43 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 9AADB4FFE15
        for <netfilter-devel@vger.kernel.org>; Mon, 25 Nov 2019 21:38:38 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8407380147
        for <netfilter-devel@vger.kernel.org>; Mon, 25 Nov 2019 21:38:38 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 8356D80132; Mon, 25 Nov 2019 21:38:38 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 58B89DA3A9;
        Mon, 25 Nov 2019 21:38:36 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 25 Nov 2019 21:38:36 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 3048F41E4800;
        Mon, 25 Nov 2019 21:38:36 +0100 (CET)
Date:   Mon, 25 Nov 2019 21:38:37 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Stefano Brivio <sbrivio@redhat.com>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Kadlecsik =?iso-8859-1?Q?J=F3zsef?= <kadlec@blackhole.kfki.hu>,
        Eric Garver <eric@garver.life>, Phil Sutter <phil@nwl.cc>
Subject: Re: [PATCH nf-next v2 1/8] netfilter: nf_tables: Support for
 subkeys, set with multiple ranged fields
Message-ID: <20191125203837.djdv5abpm7f5rtcu@salvia>
References: <cover.1574428269.git.sbrivio@redhat.com>
 <90493a6feae0ae64db378fbfc8e9f351d4b7b05d.1574428269.git.sbrivio@redhat.com>
 <20191123200108.j75hl4sm4zur33jt@salvia>
 <20191125103035.7da18406@elisabeth>
 <20191125095817.bateimhhcxmmhlzj@salvia>
 <20191125142616.46951155@elisabeth>
 <20191125143058.zpbtm34cuhvl32rt@salvia>
 <20191125155422.1ea6e2bf@elisabeth>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191125155422.1ea6e2bf@elisabeth>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Nov 25, 2019 at 03:54:22PM +0100, Stefano Brivio wrote:
> On Mon, 25 Nov 2019 15:30:58 +0100
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> 
> > On Mon, Nov 25, 2019 at 02:26:16PM +0100, Stefano Brivio wrote:
> > > On Mon, 25 Nov 2019 10:58:17 +0100
> > > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > >   
> > > > On Mon, Nov 25, 2019 at 10:30:35AM +0100, Stefano Brivio wrote:
> > > > [...]  
> > > > > Another idea could be that we get rid of this flag altogether: if we
> > > > > move "subkeys" to set->desc, the ->estimate() functions of rbtree and
> > > > > pipapo can check for those and refuse or allow set selection
> > > > > accordingly. I have no idea yet if this introduces further complexity
> > > > > for nft, because there we would need to decide how to create start/end
> > > > > elements depending on the existing set description instead of using a
> > > > > single flag. I can give it a try if it makes sense.    
> > > > 
> > > > nft_set_desc can probably store a boolean 'concat' that is set on if
> > > > the NFTA_SET_DESC_SUBKEY attribute is specified. Then, this flag is
> > > > not needed and you can just rely on ->estimate() as you describe.  
> > > 
> > > I could even just check desc->num_subkeys from your patch then, without
> > > adding another field to nft_set_desc. Too ugly?  
> > 
> > OK.
> > 
> > > > The hashtable will just ignore this description, it does not need the
> > > > description even if userspace pass it on since the interval flag is
> > > > set on.
> > > > 
> > > > You just have to update the rbtree to check for desc->concat, if this
> > > > is true, then rbtree->estimate() returns false.  
> > > 
> > > Yes, I think it all makes sense, thanks for detailing the idea. I'll get
> > > to this in a few hours.
> > >   
> > > > BTW, then probably you can rename this attribute to
> > > > NFT_SET_DESC_CONCAT?  
> > > 
> > > It would include sizes, though. What about NFT_SET_DESC_SUBSIZE or
> > > NFT_SET_DESC_FIELD_SIZE?  
> > 
> > You mean this:
> > 
> >        NFT_SET_DESC_SUBSIZE
> >           NFT_SET_DESC_FIELD_SIZE
> >           NFT_SET_DESC_FIELD_SIZE
> > 
> > instead of this:
> > 
> >         NFT_SET_DESC_CONCAT
> >           NFT_LIST_ELEM
> >              NFT_SET_DESC_SUBKEY_LEN
> >           NFT_LIST_ELEM
> >              NFT_SET_DESC_SUBKEY_LEN
> > 
> > If I described this correctly, your approach is more simple indeed.
> 
> Ah, yes, that's what I meant, but that's because I didn't understand
> your intention in the first place. :) I see now.
> 
> > However, I don't really have specific requirements for the future
> > right now. The one below is leaving room to add more subkey fields (to
> > describe each subkey if that is ever required). My experience is that
> > leaving room to extend netlink in the future is usually a good idea,
> > that's all.
> > 
> > Instead of NFT_LIST_ELEM, something like NFT_SET_DESC_SUBKEY should be
> > fine too, ie.
> > 
> >         NFT_SET_DESC_CONCAT
> >           NFT_SET_DESC_SUBKEY
> >              NFT_SET_DESC_SUBKEY_LEN
> >           NFT_SET_DESC_SUBKEY
> >              NFT_SET_DESC_SUBKEY_LEN
> 
> Actually:
> 
> >         NFT_SET_DESC_CONCAT
> >           NFT_LIST_ELEM
> >              NFT_SET_DESC_SUBKEY_LEN
> >           NFT_LIST_ELEM
> >              NFT_SET_DESC_SUBKEY_LEN
> 
> sounds better to me. Maybe "SUBKEY" starts looking a bit obscure here:
> the "SUB" part is already there, the "KEY" part mostly refers to an
> implementation detail. What about:
> 
>          NFT_SET_DESC_CONCAT
>            NFT_LIST_ELEM
>               NFT_SET_DESC_LEN
>            NFT_LIST_ELEM
>               NFT_SET_DESC_LEN
> 
> this?

I think the _SUBKEY_ infix is fine.

Problem with using NFT_SET_DESC_* for inner (nested) attributes is
that this matches the same prefix as top level netlink attributes.

Note there is NFT_SET_DESC_SIZE. If there is a NFT_SET_DESC_LEN that
is wrapped around NFT_SET_DESC_CONCAT (using same prefix) it might
look a bit misleading.

Having said this, although I started this debate about naming, I don't
have a strong opinion on all these names. As soon as the netlink
attribute scheme that is used allows for extensibility in the future,
such as allowing to add more descriptions for each subkey, I'll be fine.

Thanks.
