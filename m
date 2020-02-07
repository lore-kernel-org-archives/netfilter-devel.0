Return-Path: <SRS0=l6lg=33=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36617C352A2
	for <netfilter-devel@archiver.kernel.org>; Fri,  7 Feb 2020 10:35:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 152D62082E
	for <netfilter-devel@archiver.kernel.org>; Fri,  7 Feb 2020 10:35:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727031AbgBGKfK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 7 Feb 2020 05:35:10 -0500
Received: from correo.us.es ([193.147.175.20]:50214 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726587AbgBGKfK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 7 Feb 2020 05:35:10 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 066AD2EFEBB
        for <netfilter-devel@vger.kernel.org>; Fri,  7 Feb 2020 11:35:10 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E646BDA4D8
        for <netfilter-devel@vger.kernel.org>; Fri,  7 Feb 2020 11:35:09 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id E4208DA56C; Fri,  7 Feb 2020 11:35:09 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 15A89DA80D;
        Fri,  7 Feb 2020 11:33:08 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 07 Feb 2020 11:33:08 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id E32D742EF42A;
        Fri,  7 Feb 2020 11:33:07 +0100 (CET)
Date:   Fri, 7 Feb 2020 11:33:06 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Stefano Brivio <sbrivio@redhat.com>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Kadlecsik =?iso-8859-1?Q?J=F3zsef?= <kadlec@blackhole.kfki.hu>,
        Eric Garver <eric@garver.life>, Phil Sutter <phil@nwl.cc>
Subject: Re: [PATCH nft v4 3/4] src: Add support for concatenated set ranges
Message-ID: <20200207103306.r4xweekigdrzojy7@salvia>
References: <cover.1580342294.git.sbrivio@redhat.com>
 <92d2e10dda6dbb8443383606bde835ca1e9da834.1580342294.git.sbrivio@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <92d2e10dda6dbb8443383606bde835ca1e9da834.1580342294.git.sbrivio@redhat.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Applied, thanks. See comments below though.

On Thu, Jan 30, 2020 at 01:16:57AM +0100, Stefano Brivio wrote:
> After exporting field lengths via NFTNL_SET_DESC_CONCAT attributes,
> we now need to adjust parsing of user input and generation of
> netlink key data to complete support for concatenation of set
> ranges.
> 
> Instead of using separate elements for start and end of a range,
> denoting the end element by the NFT_SET_ELEM_INTERVAL_END flag,
> as it's currently done for ranges without concatenation, we'll use
> the new attribute NFTNL_SET_ELEM_KEY_END as suggested by Pablo. It
> behaves in the same way as NFTNL_SET_ELEM_KEY, but it indicates
> that the included key represents the upper bound of a range.
> 
> For example, "packets with an IPv4 address between 192.0.2.0 and
> 192.0.2.42, with destination port between 22 and 25", needs to be
> expressed as a single element with two keys:
> 
>   NFTA_SET_ELEM_KEY:		192.0.2.0 . 22
>   NFTA_SET_ELEM_KEY_END:	192.0.2.42 . 25
> 
> To achieve this, we need to:
> 
> - adjust the lexer rules to allow multiton expressions as elements
>   of a concatenation. As wildcards are not allowed (semantics would
>   be ambiguous), exclude wildcards expressions from the set of
>   possible multiton expressions, and allow them directly where
>   needed. Concatenations now admit prefixes and ranges
> 
> - generate, for each element in a range concatenation, a second key
>   attribute, that includes the upper bound for the range
> 
> - also expand prefixes and non-ranged values in the concatenation
>   to ranges: given a set with interval and concatenation support,
>   the kernel has no way to tell which elements are ranged, so they
>   all need to be. For example, 192.0.2.0 . 192.0.2.9 : 1024 is
>   sent as:
> 
>   NFTA_SET_ELEM_KEY:		192.0.2.0 . 1024
>   NFTA_SET_ELEM_KEY_END:	192.0.2.9 . 1024
> 
> - aggregate ranges when elements received by the kernel represent
>   concatenated ranges, see concat_range_aggregate()

I think concat_range_aggregate() can be remove.

NFTA_SET_ELEM_KEY and the NFTA_SET_ELEM_KEY_END are now coming in the
same element. From the set element delinearization path this could
just build the range, correct?

[...]
> diff --git a/include/rule.h b/include/rule.h
> index a7f106f715cf..c232221e541b 100644
> --- a/include/rule.h
> +++ b/include/rule.h
> @@ -372,6 +372,11 @@ static inline bool set_is_interval(uint32_t set_flags)
>  	return set_flags & NFT_SET_INTERVAL;
>  }
>  
> +static inline bool set_is_non_concat_range(struct set *s)
> +{
> +	return (s->flags & NFT_SET_INTERVAL) && s->desc.field_count <= 1;
> +}

I might make a second pass to revisit this new helper.

Probably, we can pass struct set to all set_is_*() helpers instead,
and use set_is_interval() for the legacy interval representation
that is using the segtree infrastructure.
