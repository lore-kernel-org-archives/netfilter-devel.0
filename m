Return-Path: <SRS0=cAfZ=AO=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A27DC433E0
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 Jul 2020 09:28:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 68B7F2084C
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 Jul 2020 09:28:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VQvZlrBZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725915AbgGCJ2l (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 3 Jul 2020 05:28:41 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:56764 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725764AbgGCJ2k (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 Jul 2020 05:28:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593768518;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=e25nSDokOprzO6HMJf7LlNtW+GXF0wX783MmBZZTEPo=;
        b=VQvZlrBZlSzPSyjSLbyXrvMloHOd/2BY2dIAes8RWIfnbVu2dg5EvMhSrrSvhB5N/cG/Mg
        P6fP7ZidTf/JBWR3EemS2l7f7ZSH0Y0ToQRH2eXvqbf2DLZxkR6RVyg9BQ5EcArAQ6PvDa
        OIm7G/scXiTcxvhXafIonSUR3ceBDUs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-277-Co53sIy4NBy3pPmjRn_PyA-1; Fri, 03 Jul 2020 05:28:23 -0400
X-MC-Unique: Co53sIy4NBy3pPmjRn_PyA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 634E910059AF;
        Fri,  3 Jul 2020 09:28:21 +0000 (UTC)
Received: from elisabeth (unknown [10.36.110.12])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6AC7F1059589;
        Fri,  3 Jul 2020 09:28:17 +0000 (UTC)
Date:   Fri, 3 Jul 2020 11:28:09 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     "Timo Sigurdsson" <public_timo.s@silentcreek.de>
Cc:     netfilter-devel@vger.kernel.org, Phil Sutter <phil@nwl.cc>,
        Jozsef Kadlecsik <kadlec@netfilter.org>
Subject: Re: Moving from ipset to nftables: Sets not ready for prime time
 yet?
Message-ID: <20200703112809.72eb94bf@elisabeth>
In-Reply-To: <20200702223010.C282E6C848EC@dd34104.kasserver.com>
References: <20200702223010.C282E6C848EC@dd34104.kasserver.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Timo,

On Fri,  3 Jul 2020 00:30:10 +0200 (CEST)
"Timo Sigurdsson" <public_timo.s@silentcreek.de> wrote:

> Another issue I stumbled upon was that auto-merge may actually
> generate wrong/incomplete intervals if you have multiple 'add
> element' statements within an nftables script file. I consider this a
> serious issue if you can't be sure whether the addresses or intervals
> you add to a set actually end up in the set. I reported this here
> [2]. The workaround for it is - again - to add all addresses in a
> single statement.

Practically speaking I think it's a bug, but I can't find a formal,
complete definition of automerge, so one can also say it "adds items up
to and including the first conflicting one", and there you go, it's
working as intended.

In general, when we discussed this "automerge" feature for
multi-dimensional sets in nftables (not your case, but I aimed at
consistency), I thought it was a mistake to introduce it altogether,
because it's hard to define it and whatever definition one comes up
with might not match what some users think. Consider this example:

# ipset create s hash:net,net
# ipset add s 10.0.1.1/30,192.168.1.1/24
# ipset add s 10.0.0.1/24,172.16.0.1
# ipset list s
[...]
Members:
10.0.1.0/30,192.168.1.0/24
10.0.0.0/24,172.16.0.1

good, ipset has no notion of automerge, so it won't try to do anything
bad here: the set of address pairs denoted by <10.0.1.1/30,
192.168.1.1/24> is disjoint from the set of address pairs denoted by
<10.0.0.1/24, 172.16.0.1>. Then:

# ipset add s 10.0.0.1/16,192.168.0.0/16
# ipset list s
[...]
Members:
10.0.1.0/30,192.168.1.0/24
10.0.0.0/16,192.168.0.0/16
10.0.0.0/24,172.16.0.1

and, as expected with ipset, we have entirely overlapping entries added
to the set. Is that a problem? Not really, ipset doesn't support maps,
so it doesn't matter which entry is actually matched.

# nft add table t
# nft add set t s '{ type ipv4_addr . ipv4_addr; flags interval ; }'
# nft add element t s '{ 10.0.1.1/30 . 192.168.1.1/24 }'
# nft add element t s '{ 10.0.0.1/24 . 172.16.0.1 }'
# nft add element t s '{ 10.0.0.1/16 . 192.168.0.0/16 }'
# nft list ruleset
table ip t {
	set s {
		type ipv4_addr . ipv4_addr
		flags interval
		elements = { 10.0.1.0/30 . 192.168.1.0/24,
			     10.0.0.0/24 . 172.16.0.1,
			     10.0.0.0/16 . 192.168.0.0/16 }
	}
}

also fine: the least generic entry is added first, so it matches first.
Let's try to reorder the insertions:

# nft add element t s '{ 10.0.0.1/16 . 192.168.0.0/16 }'
# nft add element t s '{ 10.0.0.1/24 . 172.16.0.1 }'
# nft add element t s '{ 10.0.1.1/30 . 192.168.1.1/24 }'
Error: Could not process rule: File exists
add element t s { 10.0.1.1/30 . 192.168.1.1/24 }
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

...because that entry would never match anything: it's inserted after a
more generic one that already covers it completely, and we'd like to
tell the user that it doesn't make sense.

Now, this is pretty much the only advantage of not allowing overlaps:
telling the user that some insertion doesn't make sense, and thus it
was probably not what the user wanted to do.

So... I wouldn't know how deal with your use case, even in theory, in a
consistent way. Should we rather introduce a flag that allows any type
of overlapping (default with ipset), which is a way for the user to
tell us they don't actually care about entries not having any effect?

And, in that case, would you expect the entry to be listed in the
resulting set, in case of full overlap (where one set is a subset, not
necessarily proper, of the other one)?

> [...]
>
> Summing up:
> Well, that's quite a number of issues to run into as an nftables
> newbie. I wouldn't have expected this at all. And frankly, I actually
> converted my rules first and thought adjusting my scripts around
> ipset to achieve the same with nftables sets would be straightforward
> and simple... Maybe my approach or understanding of nftables is
> wrong. But I don't think that the use case is that extraordinary that
> it should be that difficult.

I don't think so either, still I kind of expect to see the issues you
report as these features seem to start being heavily used just recently.

And I (maybe optimistically) think that all we need to iron out the
most apparent issues on the subject is a few reports like yours, so
thanks for sharing it.

-- 
Stefano

