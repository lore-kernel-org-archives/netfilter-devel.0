Return-Path: <SRS0=kuYc=ZR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6170C432C0
	for <netfilter-devel@archiver.kernel.org>; Mon, 25 Nov 2019 10:02:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C3A9E20740
	for <netfilter-devel@archiver.kernel.org>; Mon, 25 Nov 2019 10:02:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727332AbfKYKCU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 25 Nov 2019 05:02:20 -0500
Received: from correo.us.es ([193.147.175.20]:46234 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727133AbfKYKCU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 25 Nov 2019 05:02:20 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C96A1C2313
        for <netfilter-devel@vger.kernel.org>; Mon, 25 Nov 2019 11:02:15 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D0C93B8007
        for <netfilter-devel@vger.kernel.org>; Mon, 25 Nov 2019 11:02:14 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id BF23BBAACC; Mon, 25 Nov 2019 11:02:14 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C9288FF13C;
        Mon, 25 Nov 2019 11:02:12 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 25 Nov 2019 11:02:12 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 76B7342EF42B;
        Mon, 25 Nov 2019 11:02:13 +0100 (CET)
Date:   Mon, 25 Nov 2019 11:02:14 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Stefano Brivio <sbrivio@redhat.com>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Kadlecsik =?iso-8859-1?Q?J=F3zsef?= <kadlec@blackhole.kfki.hu>,
        Eric Garver <eric@garver.life>, Phil Sutter <phil@nwl.cc>
Subject: Re: [PATCH nf-next v2 0/8] nftables: Set implementation for
 arbitrary concatenation of ranges
Message-ID: <20191125100214.ke2inuq7cequbdgx@salvia>
References: <cover.1574428269.git.sbrivio@redhat.com>
 <20191123200518.t2we5nqmmh62g5b6@salvia>
 <20191125103106.5acbc958@elisabeth>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191125103106.5acbc958@elisabeth>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Nov 25, 2019 at 10:31:06AM +0100, Stefano Brivio wrote:
> On Sat, 23 Nov 2019 21:05:18 +0100
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> 
> > On Fri, Nov 22, 2019 at 02:39:59PM +0100, Stefano Brivio wrote:
> > [...]
> > > Patch 1/8 implements the needed UAPI bits: additions to the existing
> > > interface are kept to a minimum by recycling existing concepts for
> > > both ranging and concatenation, as suggested by Florian.
> > > 
> > > Patch 2/8 adds a new bitmap operation that copies the source bitmap
> > > onto the destination while removing a given region, and is needed to
> > > delete regions of arrays mapping between lookup tables.
> > > 
> > > Patch 3/8 is the actual set implementation.
> > > 
> > > Patch 4/8 introduces selftests for the new implementation.  
> > [...]
> > 
> > After talking to Florian, I'm inclined to merge upstream up to patch
> > 4/8 in this merge window, once the UAPI discussion is sorted out.
> 
> Thanks for the update. Let me know if there's some specific topic or
> concern I can start addressing for patches 5/8 to 8/8.

Merge window is now closed, I was trying to get the bare minimum in
this round. Now we have a bit more time to merge this upstream.

BTW, do you have numbers comparing the AVX2 version with the C code? I
quickly had a look at your numbers, but not clear to me if this is
compared there.

Thanks.
