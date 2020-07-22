Return-Path: <SRS0=uHYT=BB=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6037C433E2
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 Jul 2020 07:57:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C2E1820684
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 Jul 2020 07:57:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728930AbgGVH5D (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 22 Jul 2020 03:57:03 -0400
Received: from verein.lst.de ([213.95.11.211]:55305 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726807AbgGVH5C (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Jul 2020 03:57:02 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id B7D966736F; Wed, 22 Jul 2020 09:56:57 +0200 (CEST)
Date:   Wed, 22 Jul 2020 09:56:57 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Eric Dumazet <edumazet@google.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-sctp@vger.kernel.org, linux-hams@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, bridge@lists.linux-foundation.org,
        linux-can@vger.kernel.org, dccp@vger.kernel.org,
        linux-decnet-user@lists.sourceforge.net,
        linux-wpan@vger.kernel.org, linux-s390@vger.kernel.org,
        mptcp@lists.01.org, lvs-devel@vger.kernel.org,
        rds-devel@oss.oracle.com, linux-afs@lists.infradead.org,
        tipc-discussion@lists.sourceforge.net, linux-x25@vger.kernel.org
Subject: Re: get rid of the address_space override in setsockopt
Message-ID: <20200722075657.GB26554@lst.de>
References: <20200720124737.118617-1-hch@lst.de> <20200720204756.iengwcguikj2yrxt@ast-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200720204756.iengwcguikj2yrxt@ast-mbp.dhcp.thefacebook.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Jul 20, 2020 at 01:47:56PM -0700, Alexei Starovoitov wrote:
> > a kernel pointer.  This is something that works for most common sockopts
> > (and is something that the ePBF support relies on), but unfortunately
> > in various corner cases we either don't use the passed in length, or in
> > one case actually copy data back from setsockopt, so we unfortunately
> > can't just always do the copy in the highlevel code, which would have
> > been much nicer.
> 
> could you rebase on bpf-next tree and we can route it this way then?
> we'll also test the whole thing before applying.

The bpf-next tree is missing all my previous setsockopt cleanups, so
there series won't apply.
