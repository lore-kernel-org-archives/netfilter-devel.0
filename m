Return-Path: <SRS0=kuYc=ZR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FB95C432C0
	for <netfilter-devel@archiver.kernel.org>; Mon, 25 Nov 2019 09:30:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 30FF92071E
	for <netfilter-devel@archiver.kernel.org>; Mon, 25 Nov 2019 09:30:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fRHBt/2e"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727006AbfKYJaw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 25 Nov 2019 04:30:52 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:57292 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725793AbfKYJaw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 25 Nov 2019 04:30:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574674249;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2mMhh4+Au5l7bhj6mboy/WcJFcSoG6GthRT5WjHaBXI=;
        b=fRHBt/2eQgFoIerwXtQ9uSZkye7S2lzjD8iZ1vDpfykx+8jJb3Asrss6qiwoncP1MNqcbo
        nnrEjreDzouHz9zrYIwXyu4b6jnCPdIm5g3TH6fqWaMTxQUJu44U4NCVTYDlDVFsctn4tp
        hUqd7gpqnEwPwWB82NRceUHpSNVsQi0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-401-plapiXlmPqewDEqXs2jAwQ-1; Mon, 25 Nov 2019 04:30:45 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 603E01800D52;
        Mon, 25 Nov 2019 09:30:43 +0000 (UTC)
Received: from elisabeth (ovpn-200-25.brq.redhat.com [10.40.200.25])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 45C105D9CA;
        Mon, 25 Nov 2019 09:30:39 +0000 (UTC)
Date:   Mon, 25 Nov 2019 10:30:35 +0100
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Kadlecsik =?UTF-8?B?SsOzenNlZg==?= <kadlec@blackhole.kfki.hu>,
        Eric Garver <eric@garver.life>, Phil Sutter <phil@nwl.cc>
Subject: Re: [PATCH nf-next v2 1/8] netfilter: nf_tables: Support for
 subkeys, set with multiple ranged fields
Message-ID: <20191125103035.7da18406@elisabeth>
In-Reply-To: <20191123200108.j75hl4sm4zur33jt@salvia>
References: <cover.1574428269.git.sbrivio@redhat.com>
        <90493a6feae0ae64db378fbfc8e9f351d4b7b05d.1574428269.git.sbrivio@redhat.com>
        <20191123200108.j75hl4sm4zur33jt@salvia>
Organization: Red Hat
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: plapiXlmPqewDEqXs2jAwQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

On Sat, 23 Nov 2019 21:01:08 +0100
Pablo Neira Ayuso <pablo@netfilter.org> wrote:

> Hi Stefano,
> 
> On Fri, Nov 22, 2019 at 02:40:00PM +0100, Stefano Brivio wrote:
> [...]
> > diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
> > index bb9b049310df..f8dbeac14898 100644
> > --- a/include/uapi/linux/netfilter/nf_tables.h
> > +++ b/include/uapi/linux/netfilter/nf_tables.h
> > @@ -48,6 +48,7 @@ enum nft_registers {
> >  
> >  #define NFT_REG_SIZE	16
> >  #define NFT_REG32_SIZE	4
> > +#define NFT_REG32_COUNT	(NFT_REG32_15 - NFT_REG32_00 + 1)
> >  
> >  /**
> >   * enum nft_verdicts - nf_tables internal verdicts
> > @@ -275,6 +276,7 @@ enum nft_rule_compat_attributes {
> >   * @NFT_SET_TIMEOUT: set uses timeouts
> >   * @NFT_SET_EVAL: set can be updated from the evaluation path
> >   * @NFT_SET_OBJECT: set contains stateful objects
> > + * @NFT_SET_SUBKEY: set uses subkeys to map intervals for multiple fields
> >   */
> >  enum nft_set_flags {
> >  	NFT_SET_ANONYMOUS		= 0x1,
> > @@ -284,6 +286,7 @@ enum nft_set_flags {
> >  	NFT_SET_TIMEOUT			= 0x10,
> >  	NFT_SET_EVAL			= 0x20,
> >  	NFT_SET_OBJECT			= 0x40,
> > +	NFT_SET_SUBKEY			= 0x80,
> >  };
> >  
> >  /**
> > @@ -309,6 +312,17 @@ enum nft_set_desc_attributes {
> >  };
> >  #define NFTA_SET_DESC_MAX	(__NFTA_SET_DESC_MAX - 1)
> >  
> > +/**
> > + * enum nft_set_subkey_attributes - subkeys for multiple ranged fields
> > + *
> > + * @NFTA_SET_SUBKEY_LEN: length of single field, in bits (NLA_U32)
> > + */
> > +enum nft_set_subkey_attributes {  
> 
> Missing NFTA_SET_SUBKEY_UNSPEC here.
> 
> Not a problem if nla_parse_nested*() is not used as in your case,
> probably good for consistency, in case there is a need for using such
> function in the future.
> 
> > +	NFTA_SET_SUBKEY_LEN,
> > +	__NFTA_SET_SUBKEY_MAX
> > +};
> > +#define NFTA_SET_SUBKEY_MAX	(__NFTA_SET_SUBKEY_MAX - 1)
> > +
> >  /**
> >   * enum nft_set_attributes - nf_tables set netlink attributes
> >   *
> > @@ -327,6 +341,7 @@ enum nft_set_desc_attributes {
> >   * @NFTA_SET_USERDATA: user data (NLA_BINARY)
> >   * @NFTA_SET_OBJ_TYPE: stateful object type (NLA_U32: NFT_OBJECT_*)
> >   * @NFTA_SET_HANDLE: set handle (NLA_U64)
> > + * @NFTA_SET_SUBKEY: subkeys for multiple ranged fields (NLA_NESTED)
> >   */
> >  enum nft_set_attributes {
> >  	NFTA_SET_UNSPEC,
> > @@ -346,6 +361,7 @@ enum nft_set_attributes {
> >  	NFTA_SET_PAD,
> >  	NFTA_SET_OBJ_TYPE,
> >  	NFTA_SET_HANDLE,
> > +	NFTA_SET_SUBKEY,  
> 
> Could you use NFTA_SET_DESC instead for this? The idea is to add the
> missing front-end code to parse this new attribute and store the
> subkeys length in set->desc.klen[], hence nft_pipapo_init() can just
> use the already parsed data.

Logically, I think it makes sense. I'll try to implement this in nft
and libnftnl and see if some fundamental issue pops up there.

> I think this will simplify the code that I'm seeing in
> nft_pipapo_init() a bit since not netlink parsing will be required.

I don't think it makes a real difference there, because the actual
parsing parts are rather limited:

	nla_for_each_nested(attr, nla[NFTA_SET_SUBKEY], rem) {
	[...]
		if (nla_len(attr) != sizeof(klen) ||
		    nla_type(attr) != NFTA_SET_SUBKEY_LEN)
			return -EINVAL;
	}

	[...]

	nla_for_each_nested(attr, nla[NFTA_SET_SUBKEY], rem) {
		klen = ntohl(nla_get_be32(attr));
	[...]
	}

the rest is validations (specific for this set type):

	nla_for_each_nested(attr, nla[NFTA_SET_SUBKEY], rem) {
		if (++field_count >= NFT_PIPAPO_MAX_FIELDS)
			return -EINVAL;
	[...]
	}

	[...]

	nla_for_each_nested(attr, nla[NFTA_SET_SUBKEY], rem) {
	[...]
		if (!klen || klen % NFT_PIPAPO_GROUP_BITS)
			goto out_free;

		if (klen > NFT_PIPAPO_MAX_BITS)
			goto out_free;
	[...]
	}

and calculations (also specific):

	nla_for_each_nested(attr, nla[NFTA_SET_SUBKEY], rem) {
		if (++field_count >= NFT_PIPAPO_MAX_FIELDS)
	[...]
	}

	nla_for_each_nested(attr, nla[NFTA_SET_SUBKEY], rem) {
	[...]
		priv->groups += f->groups = klen / NFT_PIPAPO_GROUP_BITS;
		priv->width += round_up(klen / BITS_PER_BYTE, sizeof(u32));
	[...]
	}

that we would still need.

> I'm attaching a sketch patch, including also the use of NFTA_LIST_ELEM:
> 
> NFTA_SET_DESC
>   NFTA_SET_DESC_SIZE
>   NFTA_SET_DESC_SUBKEY
>      NFTA_LIST_ELEM
>        NFTA_SET_SUBKEY_LEN
>      NFTA_LIST_ELEM
>        NFTA_SET_SUBKEY_LEN
>      ...
> 
> Just in there's a need for more fields to describe the subkey in the
> future, it's just more boilerplate code for the future extensibility.

Thanks! I'll play with it and see if I can fit all the pieces.

> Another suggestion is to rename NFT_SET_SUBKEY to NFT_SET_CONCAT, to
> signal the kernel that userspace wants a datastructure that knows how
> to deal with concatenations. Although concatenations can be done by
> hashtable already, this flags is just interpreted by the kernel as a
> hint on what kind of datastructure would fit better for what is
> needed. The combination of the NFT_SET_INTERVAL and the NFT_SET_CONCAT
> (if you're fine with the rename, of course) is what will kick in
> pipapo to be used.

I think that NFT_SET_CONCAT as you propose is conceptually a better
fit. I'm worried about the confusion this might generate for other set
implementations.

That is, a reasonable expectation is that userspace passes
NFT_SET_CONCAT whenever there's a concatenation, and hash
implementations support sets with that flag, too, so I would add it to
the supported feature flags of hash types, and it wouldn't be there for
rbtree.

Right now, that won't break anything: the flag might or might not be
present depending on userspace version, and selection of hash types
would proceed as usual. But I'm worried that we might miss this
subtlety in the future and break concatenation support for older
userspace versions.

Another idea could be that we get rid of this flag altogether: if we
move "subkeys" to set->desc, the ->estimate() functions of rbtree and
pipapo can check for those and refuse or allow set selection
accordingly. I have no idea yet if this introduces further complexity
for nft, because there we would need to decide how to create start/end
elements depending on the existing set description instead of using a
single flag. I can give it a try if it makes sense.

-- 
Stefano

