Return-Path: <SRS0=kuYc=ZR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0ACAEC432C3
	for <netfilter-devel@archiver.kernel.org>; Mon, 25 Nov 2019 14:55:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D4DD02084D
	for <netfilter-devel@archiver.kernel.org>; Mon, 25 Nov 2019 14:55:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eiFuINSa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728376AbfKYOzF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 25 Nov 2019 09:55:05 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:23496 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728371AbfKYOzD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 25 Nov 2019 09:55:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574693702;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vo2fz2RhOCo/tgRKFZWwPRrTInfxaUCa8L+iUbSzKbY=;
        b=eiFuINSa9i2yd0IoHR1WjYs+pKpk2G6NxNlCpvlZ8Ke/V6NzQctePQAOYbmaUQuKqXu9UY
        fo50dv/X7lh/cU3Pidd5ljBdCkp6DmULcKx84/ce0kdTMn7yEjs+DMydVguJMVFPigyyn6
        /ZzCgVIrcYy4X/zZyQ1kDTOXLwlpOw0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-272-YMvjx0qePreyHkKYttmhFg-1; Mon, 25 Nov 2019 09:54:58 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E123A107ACE4;
        Mon, 25 Nov 2019 14:54:56 +0000 (UTC)
Received: from elisabeth (ovpn-200-25.brq.redhat.com [10.40.200.25])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4EAE6600C6;
        Mon, 25 Nov 2019 14:54:54 +0000 (UTC)
Date:   Mon, 25 Nov 2019 15:54:22 +0100
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Kadlecsik =?UTF-8?B?SsOzenNlZg==?= <kadlec@blackhole.kfki.hu>,
        Eric Garver <eric@garver.life>, Phil Sutter <phil@nwl.cc>
Subject: Re: [PATCH nf-next v2 1/8] netfilter: nf_tables: Support for
 subkeys, set with multiple ranged fields
Message-ID: <20191125155422.1ea6e2bf@elisabeth>
In-Reply-To: <20191125143058.zpbtm34cuhvl32rt@salvia>
References: <cover.1574428269.git.sbrivio@redhat.com>
        <90493a6feae0ae64db378fbfc8e9f351d4b7b05d.1574428269.git.sbrivio@redhat.com>
        <20191123200108.j75hl4sm4zur33jt@salvia>
        <20191125103035.7da18406@elisabeth>
        <20191125095817.bateimhhcxmmhlzj@salvia>
        <20191125142616.46951155@elisabeth>
        <20191125143058.zpbtm34cuhvl32rt@salvia>
Organization: Red Hat
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: YMvjx0qePreyHkKYttmhFg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, 25 Nov 2019 15:30:58 +0100
Pablo Neira Ayuso <pablo@netfilter.org> wrote:

> On Mon, Nov 25, 2019 at 02:26:16PM +0100, Stefano Brivio wrote:
> > On Mon, 25 Nov 2019 10:58:17 +0100
> > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> >   
> > > On Mon, Nov 25, 2019 at 10:30:35AM +0100, Stefano Brivio wrote:
> > > [...]  
> > > > Another idea could be that we get rid of this flag altogether: if we
> > > > move "subkeys" to set->desc, the ->estimate() functions of rbtree and
> > > > pipapo can check for those and refuse or allow set selection
> > > > accordingly. I have no idea yet if this introduces further complexity
> > > > for nft, because there we would need to decide how to create start/end
> > > > elements depending on the existing set description instead of using a
> > > > single flag. I can give it a try if it makes sense.    
> > > 
> > > nft_set_desc can probably store a boolean 'concat' that is set on if
> > > the NFTA_SET_DESC_SUBKEY attribute is specified. Then, this flag is
> > > not needed and you can just rely on ->estimate() as you describe.  
> > 
> > I could even just check desc->num_subkeys from your patch then, without
> > adding another field to nft_set_desc. Too ugly?  
> 
> OK.
> 
> > > The hashtable will just ignore this description, it does not need the
> > > description even if userspace pass it on since the interval flag is
> > > set on.
> > > 
> > > You just have to update the rbtree to check for desc->concat, if this
> > > is true, then rbtree->estimate() returns false.  
> > 
> > Yes, I think it all makes sense, thanks for detailing the idea. I'll get
> > to this in a few hours.
> >   
> > > BTW, then probably you can rename this attribute to
> > > NFT_SET_DESC_CONCAT?  
> > 
> > It would include sizes, though. What about NFT_SET_DESC_SUBSIZE or
> > NFT_SET_DESC_FIELD_SIZE?  
> 
> You mean this:
> 
>        NFT_SET_DESC_SUBSIZE
>           NFT_SET_DESC_FIELD_SIZE
>           NFT_SET_DESC_FIELD_SIZE
> 
> instead of this:
> 
>         NFT_SET_DESC_CONCAT
>           NFT_LIST_ELEM
>              NFT_SET_DESC_SUBKEY_LEN
>           NFT_LIST_ELEM
>              NFT_SET_DESC_SUBKEY_LEN
> 
> If I described this correctly, your approach is more simple indeed.

Ah, yes, that's what I meant, but that's because I didn't understand
your intention in the first place. :) I see now.

> However, I don't really have specific requirements for the future
> right now. The one below is leaving room to add more subkey fields (to
> describe each subkey if that is ever required). My experience is that
> leaving room to extend netlink in the future is usually a good idea,
> that's all.
> 
> Instead of NFT_LIST_ELEM, something like NFT_SET_DESC_SUBKEY should be
> fine too, ie.
> 
>         NFT_SET_DESC_CONCAT
>           NFT_SET_DESC_SUBKEY
>              NFT_SET_DESC_SUBKEY_LEN
>           NFT_SET_DESC_SUBKEY
>              NFT_SET_DESC_SUBKEY_LEN

Actually:

>         NFT_SET_DESC_CONCAT
>           NFT_LIST_ELEM
>              NFT_SET_DESC_SUBKEY_LEN
>           NFT_LIST_ELEM
>              NFT_SET_DESC_SUBKEY_LEN

sounds better to me. Maybe "SUBKEY" starts looking a bit obscure here:
the "SUB" part is already there, the "KEY" part mostly refers to an
implementation detail. What about:

         NFT_SET_DESC_CONCAT
           NFT_LIST_ELEM
              NFT_SET_DESC_LEN
           NFT_LIST_ELEM
              NFT_SET_DESC_LEN

this?

-- 
Stefano

