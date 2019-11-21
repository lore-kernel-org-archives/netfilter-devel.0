Return-Path: <SRS0=7szD=ZN=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FD2EC432C0
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Nov 2019 20:51:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5435720672
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Nov 2019 20:51:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726546AbfKUUvh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 21 Nov 2019 15:51:37 -0500
Received: from correo.us.es ([193.147.175.20]:37912 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726293AbfKUUvg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 21 Nov 2019 15:51:36 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E15B8C127A
        for <netfilter-devel@vger.kernel.org>; Thu, 21 Nov 2019 21:51:32 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D3921FB362
        for <netfilter-devel@vger.kernel.org>; Thu, 21 Nov 2019 21:51:32 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id C586ADA3A9; Thu, 21 Nov 2019 21:51:32 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D3036B7FF2;
        Thu, 21 Nov 2019 21:51:30 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 21 Nov 2019 21:51:30 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 9D07641E4800;
        Thu, 21 Nov 2019 21:51:30 +0100 (CET)
Date:   Thu, 21 Nov 2019 21:51:32 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     Stefano Brivio <sbrivio@redhat.com>,
        netfilter-devel@vger.kernel.org,
        Kadlecsik =?iso-8859-1?Q?J=F3zsef?= <kadlec@blackhole.kfki.hu>,
        Eric Garver <eric@garver.life>, Phil Sutter <phil@nwl.cc>,
        Sabrina Dubroca <sd@queasysnail.net>,
        Jay Ligatti <ligatti@usf.edu>,
        Ori Rottenstreich <or@cs.technion.ac.il>,
        Kirill Kogan <kirill.kogan@gmail.com>
Subject: Re: [PATCH nf-next 8/8] nft_set_pipapo: Introduce AVX2-based lookup
 implementation
Message-ID: <20191121205132.g7a2mk2jummiap6k@salvia>
References: <cover.1574119038.git.sbrivio@redhat.com>
 <367e77e2a0097a0c1b715919b8d21f7a51a10429.1574119038.git.sbrivio@redhat.com>
 <20191120151653.GD20235@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191120151653.GD20235@breakpoint.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Nov 20, 2019 at 04:16:53PM +0100, Florian Westphal wrote:
> Stefano Brivio <sbrivio@redhat.com> wrote:
> > If the AVX2 set is available, we can exploit the repetitive
> > characteristic of this algorithm to provide a fast, vectorised
> > version by using 256-bit wide AVX2 operands for bucket loads and
> > bitwise intersections.
> > 
> > In most cases, this implementation consistently outperforms rbtree
> > set instances despite the fact they are configured to use a given,
> > single, ranged data type out of the ones used for performance
> > measurements by the nft_concat_range.sh kselftest.
> 
> I think in that case it makes sense to remove rbtree once this new
> set type has had some upstream exposure and let pipapo handle the
> range sets.

Agreed.
