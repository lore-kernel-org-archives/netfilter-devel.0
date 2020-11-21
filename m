Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97D41C388F9
	for <netfilter-devel@archiver.kernel.org>; Sat, 21 Nov 2020 12:12:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5D7AF22226
	for <netfilter-devel@archiver.kernel.org>; Sat, 21 Nov 2020 12:12:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727672AbgKUML7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 21 Nov 2020 07:11:59 -0500
Received: from correo.us.es ([193.147.175.20]:53638 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727486AbgKUML6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 21 Nov 2020 07:11:58 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C89DDE780C
        for <netfilter-devel@vger.kernel.org>; Sat, 21 Nov 2020 13:11:56 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BB839DA78A
        for <netfilter-devel@vger.kernel.org>; Sat, 21 Nov 2020 13:11:56 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id B12C7DA789; Sat, 21 Nov 2020 13:11:56 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 875EEDA72F;
        Sat, 21 Nov 2020 13:11:54 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 21 Nov 2020 13:11:54 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 725E74265A5A;
        Sat, 21 Nov 2020 13:11:54 +0100 (CET)
Date:   Sat, 21 Nov 2020 13:11:54 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH] tests: shell: Stabilize
 nft-only/0009-needless-bitwise_0
Message-ID: <20201121121154.GA21180@salvia>
References: <20201120175757.8063-1-phil@nwl.cc>
 <20201120185000.GA17769@salvia>
 <20201120193723.GN11766@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201120193723.GN11766@orbyte.nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Nov 20, 2020 at 08:37:23PM +0100, Phil Sutter wrote:
> Hi,
> 
> On Fri, Nov 20, 2020 at 07:50:00PM +0100, Pablo Neira Ayuso wrote:
> > On Fri, Nov 20, 2020 at 06:57:57PM +0100, Phil Sutter wrote:
> > > Netlink debug output varies depending on host's endianness and therefore
> > > the test fails on Big Endian machines. Since for the sake of asserting
> > > no needless bitwise expressions in output the actual data values are not
> > > relevant, simply crop the output to just the expression names.
> > 
> > Probably we can fix this in libnftnl before we apply patches like this
> > to nft as well?
> 
> You're right, ignoring the problems in nft testsuite is pretty
> inconsistent. OTOH this is the first test that breaks iptables testsuite
> on Big Endian while nft testsuite is entirely broken. ;)

Do you think we can fix this from the testsuite site? It would require
to replicate payload files. The snprintf printing is used for
debugging only at this stage. That would fix nft and this specific case.

> I had a look at libnftnl and it seems like even kernel support is needed
> to carry the endianness info from input to output. IMHO data should be
> in a consistent format in netlink messages, but I fear we can't change
> this anymore. I tried to print the data byte-by-byte, but we obviously
> still get problems with any data in host byte order. Do you see an
> easier way to fix this than adding extra info to all expressions
> containing data?

Probably we can make assumptions based on context, such as payload
expression always express things in network byte order, and annotate
that such register stores something in network byteorder. For meta,
assume host byte order. Unless there is an explicit byteorder
expression.
