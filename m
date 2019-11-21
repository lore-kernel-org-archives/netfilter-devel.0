Return-Path: <SRS0=7szD=ZN=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20B45C432C3
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Nov 2019 20:56:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0004620672
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Nov 2019 20:56:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726912AbfKUU4i (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 21 Nov 2019 15:56:38 -0500
Received: from correo.us.es ([193.147.175.20]:39388 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726293AbfKUU4i (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 21 Nov 2019 15:56:38 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 7A2B3FB457
        for <netfilter-devel@vger.kernel.org>; Thu, 21 Nov 2019 21:56:33 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6D049DA8E8
        for <netfilter-devel@vger.kernel.org>; Thu, 21 Nov 2019 21:56:33 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 5E7E4DA840; Thu, 21 Nov 2019 21:56:33 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5D9E7DA72F;
        Thu, 21 Nov 2019 21:56:31 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 21 Nov 2019 21:56:31 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 278DB41E4800;
        Thu, 21 Nov 2019 21:56:31 +0100 (CET)
Date:   Thu, 21 Nov 2019 21:56:32 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     Stefano Brivio <sbrivio@redhat.com>, Phil Sutter <phil@nwl.cc>,
        netfilter-devel@vger.kernel.org,
        Kadlecsik =?iso-8859-1?Q?J=F3zsef?= <kadlec@blackhole.kfki.hu>,
        Eric Garver <eric@garver.life>,
        Sabrina Dubroca <sd@queasysnail.net>,
        Jay Ligatti <ligatti@usf.edu>,
        Ori Rottenstreich <or@cs.technion.ac.il>,
        Kirill Kogan <kirill.kogan@gmail.com>
Subject: Re: [PATCH nf-next 8/8] nft_set_pipapo: Introduce AVX2-based lookup
 implementation
Message-ID: <20191121205632.l6rjueclm3z7zvgd@salvia>
References: <cover.1574119038.git.sbrivio@redhat.com>
 <367e77e2a0097a0c1b715919b8d21f7a51a10429.1574119038.git.sbrivio@redhat.com>
 <20191120151653.GD20235@breakpoint.cc>
 <20191120160800.GN8016@orbyte.nwl.cc>
 <20191121205510.0068551b@redhat.com>
 <20191121202232.e6enl4ck7ynjekty@salvia>
 <20191121204612.GM20235@breakpoint.cc>
 <20191121205456.lsgg2srtmauum5l5@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191121205456.lsgg2srtmauum5l5@salvia>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Nov 21, 2019 at 09:54:56PM +0100, Pablo Neira Ayuso wrote:
> On Thu, Nov 21, 2019 at 09:46:12PM +0100, Florian Westphal wrote:
> > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > Probably, at some point we can start exposing knobs, but I'd rather
> > > see a bit more discussions on how to provide a good autotuning. By
> > > exposing all knobs, then such discussion might not ever happen?
> > 
> > My remarks were not aimed at exposing knobs but to provide some
> > debugging aid.
> > 
> > Say e.g. there is a bug in the avx implementation that isn't present
> > in the C version, or vice versa.  Or in rhashtable but not hashtable.
> 
> Ah indeed, thanks for explaining.
> 
> > Right now it requires some guesswork to figure out what set backend is
> > actually used for @myset, and it might make things easier for debugging
> > if one could query the kernel for some information wrt. what set backend
> > is used.  I would try to avoid to expose anything that can't be ripped
> > out again, so e.g. names or even just %pF of ->lookup() would perhaps be
> > enough.
> 
> I think exposing names would be fine. Probably you can also add name
> to operations, instead of %pF of lookup.

At second spin, %pF should be fine too. Names are fine, you pick the way.
