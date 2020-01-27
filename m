Return-Path: <SRS0=xF+Z=3Q=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F99BC32771
	for <netfilter-devel@archiver.kernel.org>; Mon, 27 Jan 2020 08:20:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E00F3214AF
	for <netfilter-devel@archiver.kernel.org>; Mon, 27 Jan 2020 08:20:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728913AbgA0IUy (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 27 Jan 2020 03:20:54 -0500
Received: from correo.us.es ([193.147.175.20]:36052 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725955AbgA0IUy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 27 Jan 2020 03:20:54 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 50A0EB192B
        for <netfilter-devel@vger.kernel.org>; Mon, 27 Jan 2020 09:20:53 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 40623DA705
        for <netfilter-devel@vger.kernel.org>; Mon, 27 Jan 2020 09:20:53 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 3FA52DA713; Mon, 27 Jan 2020 09:20:53 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B6749DA711;
        Mon, 27 Jan 2020 09:20:50 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 27 Jan 2020 09:20:50 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 976C042EFB81;
        Mon, 27 Jan 2020 09:20:50 +0100 (CET)
Date:   Mon, 27 Jan 2020 09:20:49 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Stefano Brivio <sbrivio@redhat.com>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Kadlecsik =?iso-8859-1?Q?J=F3zsef?= <kadlec@blackhole.kfki.hu>,
        Eric Garver <eric@garver.life>, Phil Sutter <phil@nwl.cc>
Subject: Re: [PATCH nf-next v4 0/9] nftables: Set implementation for
 arbitrary concatenation of ranges
Message-ID: <20200127082049.2crc2luiw2g235sh@salvia>
References: <cover.1579647351.git.sbrivio@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1579647351.git.sbrivio@redhat.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Jan 22, 2020 at 12:17:50AM +0100, Stefano Brivio wrote:
> Existing nftables set implementations allow matching entries with
> interval expressions (rbtree), e.g. 192.0.2.1-192.0.2.4, entries
> specifying field concatenation (hash, rhash), e.g. 192.0.2.1:22,
> but not both.
> 
> In other words, none of the set types allows matching on range
> expressions for more than one packet field at a time, such as ipset
> does with types bitmap:ip,mac, and, to a more limited extent
> (netmasks, not arbitrary ranges), with types hash:net,net,
> hash:net,port, hash:ip,port,net, and hash:net,port,net.
> 
> As a pure hash-based approach is unsuitable for matching on ranges,
> and "proxying" the existing red-black tree type looks impractical as
> elements would need to be shared and managed across all employed
> trees, this new set implementation intends to fill the functionality
> gap by employing a relatively novel approach.
> 
> The fundamental idea, illustrated in deeper detail in patch 5/9, is to
> use lookup tables classifying a small number of grouped bits from each
> field, and map the lookup results in a way that yields a verdict for
> the full set of specified fields.
> 
> The grouping bit aspect is loosely inspired by the Grouper algorithm,
> by Jay Ligatti, Josh Kuhn, and Chris Gage (see patch 5/9 for the full
> reference).
> 
> A reference, stand-alone implementation of the algorithm itself is
> available at:
> 	https://pipapo.lameexcu.se
> 
> Some notes about possible future optimisations are also mentioned
> there. This algorithm reduces the matching problem to, essentially,
> a repetitive sequence of simple bitwise operations, and is
> particularly suitable to be optimised by leveraging SIMD instruction
> sets. An AVX2-based implementation is also presented in this series.
> 
> I plan to post the adaptation of the existing AVX2 vectorised
> implementation for (at least) NEON at a later time.
> 
> Patches 1/9 to 3/9 implement the needed infrastructure: new
> attributes are used to describe length of single ranged fields in
> concatenations and to denote the upper bound for ranges.
> 
> Patch 4/9 adds a new bitmap operation that copies the source bitmap
> onto the destination while removing a given region, and is needed to
> delete regions of arrays mapping between lookup tables.
> 
> Patch 5/9 is the actual set implementation.
> 
> Patch 6/9 introduces selftests for the new implementation.

Applied up to 6/9.

Merge window will close soon and I'm going to be a bit defensive and
take only the batch that include the initial implementation. I would
prefer if we all use this round to start using the C implementation
upstream and report bugs. While I have received positive feedback from
other fellows meanwhile privately, this batch is large and I'm
inclined to follow this approach.

Please, don't be disappointed, and just follow up with more patches
once merge window opens up again.

Thanks.
