Return-Path: <SRS0=aq0Q=4C=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91D95C35242
	for <netfilter-devel@archiver.kernel.org>; Fri, 14 Feb 2020 20:42:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4C716222C4
	for <netfilter-devel@archiver.kernel.org>; Fri, 14 Feb 2020 20:42:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729996AbgBNUmf (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 14 Feb 2020 15:42:35 -0500
Received: from correo.us.es ([193.147.175.20]:51626 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729672AbgBNUme (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 14 Feb 2020 15:42:34 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 27DDFDA737
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Feb 2020 21:42:33 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 13A87DA702
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Feb 2020 21:42:33 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 08E2EDA703; Fri, 14 Feb 2020 21:42:33 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 896D5DA702;
        Fri, 14 Feb 2020 21:42:27 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 14 Feb 2020 21:42:27 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 6B77E42EF4E1;
        Fri, 14 Feb 2020 21:42:27 +0100 (CET)
Date:   Fri, 14 Feb 2020 21:42:25 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Stefano Brivio <sbrivio@redhat.com>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Kadlecsik =?iso-8859-1?Q?J=F3zsef?= <kadlec@blackhole.kfki.hu>,
        Eric Garver <eric@garver.life>, Phil Sutter <phil@nwl.cc>
Subject: Re: [PATCH nf-next v4 5/9] nf_tables: Add set type for arbitrary
 concatenation of ranges
Message-ID: <20200214204225.dh3ubs67vorh2ail@salvia>
References: <cover.1579647351.git.sbrivio@redhat.com>
 <4e78727d12d54ebd6a6f832585d15f116280dc42.1579647351.git.sbrivio@redhat.com>
 <20200207112308.sqtlvbluujlftqz2@salvia>
 <20200210161047.370582c5@redhat.com>
 <20200214181634.cacy3elfwnankvop@salvia>
 <20200214204213.50b54ed4@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200214204213.50b54ed4@redhat.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Feb 14, 2020 at 08:42:13PM +0100, Stefano Brivio wrote:
> On Fri, 14 Feb 2020 19:16:34 +0100
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
[...]
> > You refer to a property that says that you can split a range into a
> > 2*n netmasks IIRC. Do you know what is the worst case when splitting
> > ranges?
> 
> I'm not sure I got your question: that is exactly the worst case, i.e.
> we can have _up to_ 2 * n netmasks (hence rules) given a range of n
> bits. There's an additional upper bound on this, given by the address
> space, but single fields in a concatenation can overlap.
> 
> For example, we can have up to 128 rules for an IPv6 range where at
> least 64 bits differ between the endpoints, and which would contain
> 2 ^ 64 addresses. Or, say, the IPv4 range 1.2.3.4 - 255.255.0.2 is
> expressed by 42 rules.
> 
> By the way, 0.0.0.1 - 255.255.255.254 takes 62 rules, so we can
> *probably* say it's 2 * n - 2, but I don't have a formal proof for that.

By "splitting" I was actually refering to "expanding", so you're
replying here to my worst-case range-to-rules expansion question.

> I have a couple of ways in mind to get that down to n / 2, but it's not
> straightforward and it will take me some time (assuming it makes
> sense). For the n bound, we can introduce negations (proof in
> literature), and I have some kind of ugly prototype. For the n / 2
> bound, I'd need some auxiliary data structure to keep insertion
> invertible.

OK, so there is room to improve the "rule expansion" logic. I didn't
spend much time on that front yet.

> In practice, the "average" case is much less, but to define it we would
> first need to agree on what are the actual components of the
> multivariate distribution... size and start? Is it a Poisson
> distribution then? After spending some time on this and disagreeing
> with myself I'd shyly recommend to skip the topic. :)

Yes, I agree to stick to something relatively simple and good is just
fine.

> > There is no ipset set like this, but I agree usecase might happen.
> 
> Actually, for ipset, a "net,port,net,port" type was proposed
> (netfilter-devel <20181216213039.399-1-oliver@uptheinter.net>), but when
> József enquired about the intended use case, none was given. So maybe
> this whole "net,net,port,mac" story makes even less sense.

Would it make sense to you to restrict pipapo to 3 fields until there
is someone with a usecase for this?

[...]
> > The per-cpu scratch index is only required if we cannot fit in the
> > "result bitmap" into the stack, right?
> 
> Right.
> 
> > Probably up to 256 bytes result bitmap in the stack is reasonable?
> > That makes 8192 pipapo rules. There will be no need to disable bh and
> > make use of the percpu scratchpad area in that case.
> 
> Right -- the question is whether that would mean yet another
> implementation for the lookup function.

This would need another lookup function that can be selected from
control plane path. The set size and the range-to-rule expansion
worst-case can tell us if it would fit into the stack. It's would be
just one extra lookup function for this case, ~80-100 LOC.

> > If adjusting the code to deal with variable length "pipapo word" size
> > is not too convoluted, then you could just deal with the variable word
> > size from the insert / delete / get (slow) path and register one
> > lookup function for the version that is optimized for this pipapo word
> > size.
> 
> Yes, I like this a lot -- we would also need one function to rebuild
> tables when the word size changes, but that sounds almost trivial.
> Changes for the slow path are actually rather simple.
>
> Still, I start doubting quite heavily that my original worst case is
> reasonable. If we stick to the one you mentioned, or even something in
> between, it makes no sense to keep 4-bit buckets.

OK, then moving to 8-bits will probably remove a bit of code which is
dealing with "nibbles".

> By the way, I went ahead and tried the 8-bit bucket version of the C
> implementation only, on my usual x86_64 box (one thread, AMD Epyc 7351).
> I think it's worth it:
> 
>                 4-bit       8-bit
> net,port
>  1000 entries   2304165pps  2901299pps
> port,net
>  100 entries    4131471pps  4751247pps
> net6,port
>  1000 entries   1092557pps  1651037pps
> port,proto
>  30000 entries   284147pps   449665pps
> net6,port,mac
>  10 entries     2082880pps  2762291pps
> net6,port,mac,proto
>  1000 entries    783810pps  1195823pps
> net,mac
>  1000 entries   1279122pps  1934003pps

Assuming the same concatenation type, larger bucket size makes pps
drop in the C implementation?

> I would now proceed extending this to the AVX2 implementation and (once
> I finish it) to the NEON one, I actually expect bigger gains there.

Good. BTW, probably you can add a new NFT_SET_CLASS_JIT class that
comes becomes NFT_SET_CLASS_O_1 to make the set routine that selects
the set pick the jit version instead.

> > Probably adding helper function to deal with pipapo words would help
> > to prepare for such update in the future. There is the ->estimate
> > function that allows to calculate for the best word size depending on
> > all the information this gets from the set definition.
> 
> Hm, I really think it should be kind of painless to make this dynamic
> on insertion/deletion.

OK, good. How would you like to proceed?

Thanks!
