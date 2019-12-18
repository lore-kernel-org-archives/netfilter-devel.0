Return-Path: <SRS0=U5wk=2I=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0729AC43603
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 Dec 2019 14:12:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CC5212146E
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 Dec 2019 14:12:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727024AbfLROMw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 18 Dec 2019 09:12:52 -0500
Received: from correo.us.es ([193.147.175.20]:41096 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726856AbfLROMw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 18 Dec 2019 09:12:52 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 717C0C2305
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Dec 2019 15:12:47 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 63367DA718
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Dec 2019 15:12:47 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 5714EDA713; Wed, 18 Dec 2019 15:12:47 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 34143DA707;
        Wed, 18 Dec 2019 15:12:45 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 18 Dec 2019 15:12:45 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (barqueta.lsi.us.es [150.214.188.150])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 278F94265A5A;
        Wed, 18 Dec 2019 15:12:45 +0100 (CET)
Date:   Wed, 18 Dec 2019 15:12:45 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org,
        =?iso-8859-1?Q?M=E1t=E9?= Eckl <ecklm94@gmail.com>
Subject: Re: [nf PATCH] netfilter: nft_tproxy: Fix port selector on Big Endian
Message-ID: <20191218141245.ahc6yqvocwwoeul6@salvia>
References: <20191217235929.32555-1-phil@nwl.cc>
 <20191218000315.GY795@breakpoint.cc>
 <20191218002444.GA20229@orbyte.nwl.cc>
 <20191218003625.GZ795@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191218003625.GZ795@breakpoint.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Dec 18, 2019 at 01:36:25AM +0100, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > On Wed, Dec 18, 2019 at 01:03:15AM +0100, Florian Westphal wrote:
> > > Phil Sutter <phil@nwl.cc> wrote:
> > > > On Big Endian architectures, u16 port value was extracted from the wrong
> > > > parts of u32 sreg_port, just like commit 10596608c4d62 ("netfilter:
> > > > nf_tables: fix mismatch in big-endian system") describes.
> > > 
> > > I was about to debug this today, thanks for debugging/fixing this.
> > 
> > With that BE machine at hand, I quickly gave nftables testsuite a try -
> > results are a bit concerning: The mere fact that netlink debug output
> > for these immediates differs between BE and LE indicates we don't
> > seriously test on BE.
> 
> Yes, I fear we will need to add extra .be test files with
> big-endian output.
> 
> Alternative is to unify debug output in libnftnl to always print
> in host byte order, but thats not going to be easy because we don't
> know if the immediate value is in network or host byte order.

The byteorder information is available in libnftables, so we can
probably move the print function there.
