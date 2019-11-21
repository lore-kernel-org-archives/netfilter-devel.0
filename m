Return-Path: <SRS0=7szD=ZN=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F733C432C0
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Nov 2019 20:22:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7A8EF20643
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Nov 2019 20:22:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726574AbfKUUWj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 21 Nov 2019 15:22:39 -0500
Received: from correo.us.es ([193.147.175.20]:59030 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726541AbfKUUWj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 21 Nov 2019 15:22:39 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 3B9B5EBAE7
        for <netfilter-devel@vger.kernel.org>; Thu, 21 Nov 2019 21:22:33 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2E4B6B7FFE
        for <netfilter-devel@vger.kernel.org>; Thu, 21 Nov 2019 21:22:33 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 1368CBAACC; Thu, 21 Nov 2019 21:22:33 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EF3A4DA7B6;
        Thu, 21 Nov 2019 21:22:30 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 21 Nov 2019 21:22:30 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id B829541E4801;
        Thu, 21 Nov 2019 21:22:30 +0100 (CET)
Date:   Thu, 21 Nov 2019 21:22:32 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Stefano Brivio <sbrivio@redhat.com>
Cc:     Phil Sutter <phil@nwl.cc>, Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org,
        Kadlecsik =?iso-8859-1?Q?J=F3zsef?= <kadlec@blackhole.kfki.hu>,
        Eric Garver <eric@garver.life>,
        Sabrina Dubroca <sd@queasysnail.net>,
        Jay Ligatti <ligatti@usf.edu>,
        Ori Rottenstreich <or@cs.technion.ac.il>,
        Kirill Kogan <kirill.kogan@gmail.com>
Subject: Re: [PATCH nf-next 8/8] nft_set_pipapo: Introduce AVX2-based lookup
 implementation
Message-ID: <20191121202232.e6enl4ck7ynjekty@salvia>
References: <cover.1574119038.git.sbrivio@redhat.com>
 <367e77e2a0097a0c1b715919b8d21f7a51a10429.1574119038.git.sbrivio@redhat.com>
 <20191120151653.GD20235@breakpoint.cc>
 <20191120160800.GN8016@orbyte.nwl.cc>
 <20191121205510.0068551b@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191121205510.0068551b@redhat.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Nov 21, 2019 at 08:55:10PM +0100, Stefano Brivio wrote:
> On Wed, 20 Nov 2019 17:08:00 +0100
> Phil Sutter <phil@nwl.cc> wrote:
> 
> > On Wed, Nov 20, 2019 at 04:16:53PM +0100, Florian Westphal wrote:
> > > Stefano Brivio <sbrivio@redhat.com> wrote:  
[...]
> > > If not, I think we might want to expose some additional debug info
> > > on set dumps.  
> > 
> > I once submitted a patch introducing NFTA_SET_OPS, an attribute holding
> > set type's name in dumps. Maybe we can reuse that? It is message ID
> > 20180403211540.23700-3-phil@nwl.cc (Subject: [PATCH v2 2/2] net:
> > nftables: Export set backend name via netlink).
> 
> ...I would rather try to introduce this at a later time. I just
> wonder: what was the problem with that series? :)

For datastructure like bitmap and hashtable, the tuning parameters are
well-known probably and rather trivial for everyone. However, for
composite datastructures, this is not.

In general, I think the developer should better know how to optimize
the tuning of the datastructure based on the description. Rather than
assuming that the user knows how to tune things and exposing n-thousand
knobs for configuring things.

Moreover, if it turns out that we ever get something better than
pipapo in the future to represent this, then we cannot transparently
get rid of this code in favour of the new one. And I'm not telling I
know a better way to do what you're proposing right now :-)

Probably, at some point we can start exposing knobs, but I'd rather
see a bit more discussions on how to provide a good autotuning. By
exposing all knobs, then such discussion might not ever happen?
