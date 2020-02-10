Return-Path: <SRS0=1PBg=36=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97F67C352A3
	for <netfilter-devel@archiver.kernel.org>; Mon, 10 Feb 2020 15:08:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 65E7820661
	for <netfilter-devel@archiver.kernel.org>; Mon, 10 Feb 2020 15:08:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bsk45ITM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728360AbgBJPIe (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 10 Feb 2020 10:08:34 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:54881 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727842AbgBJPIe (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 10 Feb 2020 10:08:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581347312;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iGTTXES5hBpetbzaN0t801BEF31nbGd+Ep8TLKYHULo=;
        b=bsk45ITMAKd5ERvv21i6pz2rQKbvpmjufI3z20IPCHnqpD7fm+dDrZRMUBUQU+CWt/vRxd
        QBfEqsff0+gbNr7+NwpTORbwJP8Wx1FSRgdaRJq/sCmkkVxJ06YkuAg/E/Bh8TQZF+Gqca
        vbbcUFYuDiB+yHd9ygpq03xKSfUwrcI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-220-AsmWTZgfMAiDoZdtPAEJjA-1; Mon, 10 Feb 2020 10:08:18 -0500
X-MC-Unique: AsmWTZgfMAiDoZdtPAEJjA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 98F108017DF;
        Mon, 10 Feb 2020 15:08:17 +0000 (UTC)
Received: from localhost (ovpn-200-43.brq.redhat.com [10.40.200.43])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1182D89F18;
        Mon, 10 Feb 2020 15:08:14 +0000 (UTC)
Date:   Mon, 10 Feb 2020 16:08:09 +0100
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Kadlecsik =?UTF-8?B?SsOzenNlZg==?= <kadlec@blackhole.kfki.hu>,
        Eric Garver <eric@garver.life>, Phil Sutter <phil@nwl.cc>
Subject: Re: [PATCH nft v4 3/4] src: Add support for concatenated set ranges
Message-ID: <20200210160809.6178251e@redhat.com>
In-Reply-To: <20200207103306.r4xweekigdrzojy7@salvia>
References: <cover.1580342294.git.sbrivio@redhat.com>
 <92d2e10dda6dbb8443383606bde835ca1e9da834.1580342294.git.sbrivio@redhat.com>
 <20200207103306.r4xweekigdrzojy7@salvia>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, 7 Feb 2020 11:33:06 +0100
Pablo Neira Ayuso <pablo@netfilter.org> wrote:

> Applied, thanks. See comments below though.
> 
> On Thu, Jan 30, 2020 at 01:16:57AM +0100, Stefano Brivio wrote:
> > After exporting field lengths via NFTNL_SET_DESC_CONCAT attributes,
> > we now need to adjust parsing of user input and generation of
> > netlink key data to complete support for concatenation of set
> > ranges.
> > 
> > Instead of using separate elements for start and end of a range,
> > denoting the end element by the NFT_SET_ELEM_INTERVAL_END flag,
> > as it's currently done for ranges without concatenation, we'll use
> > the new attribute NFTNL_SET_ELEM_KEY_END as suggested by Pablo. It
> > behaves in the same way as NFTNL_SET_ELEM_KEY, but it indicates
> > that the included key represents the upper bound of a range.
> > 
> > For example, "packets with an IPv4 address between 192.0.2.0 and
> > 192.0.2.42, with destination port between 22 and 25", needs to be
> > expressed as a single element with two keys:
> > 
> >   NFTA_SET_ELEM_KEY:		192.0.2.0 . 22
> >   NFTA_SET_ELEM_KEY_END:	192.0.2.42 . 25
> > 
> > To achieve this, we need to:
> > 
> > - adjust the lexer rules to allow multiton expressions as elements
> >   of a concatenation. As wildcards are not allowed (semantics would
> >   be ambiguous), exclude wildcards expressions from the set of
> >   possible multiton expressions, and allow them directly where
> >   needed. Concatenations now admit prefixes and ranges
> > 
> > - generate, for each element in a range concatenation, a second key
> >   attribute, that includes the upper bound for the range
> > 
> > - also expand prefixes and non-ranged values in the concatenation
> >   to ranges: given a set with interval and concatenation support,
> >   the kernel has no way to tell which elements are ranged, so they
> >   all need to be. For example, 192.0.2.0 . 192.0.2.9 : 1024 is
> >   sent as:
> > 
> >   NFTA_SET_ELEM_KEY:		192.0.2.0 . 1024
> >   NFTA_SET_ELEM_KEY_END:	192.0.2.9 . 1024
> > 
> > - aggregate ranges when elements received by the kernel represent
> >   concatenated ranges, see concat_range_aggregate()  
> 
> I think concat_range_aggregate() can be remove.
> 
> NFTA_SET_ELEM_KEY and the NFTA_SET_ELEM_KEY_END are now coming in the
> same element. From the set element delinearization path this could
> just build the range, correct?

Correct, with two caveats:

- building ranges isn't that straightforward. Some complexity currently
  in concat_range_aggregate() would go away if we embed that logic in  
  netlink_delinearize_setelem(), but most of it would remain, and that
  logic doesn't seem to belong to "netlink" functions. I guess this is
  quite subjective though

- if we keep a mechanism that can build ranges this way, the day we
  want to switch to NFTA_SET_ELEM_KEY_END for ranges in general, also
  for other set types (or without concatenation anyway), maintaining
  compatibility with older kernels, it should be easier to let
  concat_range_aggregate() handle all cases. I'm not sure, I haven't
  really thought it through

> [...]
> > diff --git a/include/rule.h b/include/rule.h
> > index a7f106f715cf..c232221e541b 100644
> > --- a/include/rule.h
> > +++ b/include/rule.h
> > @@ -372,6 +372,11 @@ static inline bool set_is_interval(uint32_t set_flags)
> >  	return set_flags & NFT_SET_INTERVAL;
> >  }
> >  
> > +static inline bool set_is_non_concat_range(struct set *s)
> > +{
> > +	return (s->flags & NFT_SET_INTERVAL) && s->desc.field_count <= 1;
> > +}  
> 
> I might make a second pass to revisit this new helper.
> 
> Probably, we can pass struct set to all set_is_*() helpers instead,
> and use set_is_interval() for the legacy interval representation
> that is using the segtree infrastructure.

Ah, yes, I also think that would make sense.

By the way, while I didn't switch other helpers to take 'struct set' in
this series (because it didn't fit the scope), I'm quite convinced that
functions called set_is_*() should really take a 'set' as argument. :)

-- 
Stefano

