Return-Path: <SRS0=RE83=6O=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC78FC47247
	for <netfilter-devel@archiver.kernel.org>; Thu, 30 Apr 2020 15:08:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A7C8420661
	for <netfilter-devel@archiver.kernel.org>; Thu, 30 Apr 2020 15:08:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726396AbgD3PIf (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 30 Apr 2020 11:08:35 -0400
Received: from correo.us.es ([193.147.175.20]:36598 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726350AbgD3PIf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 30 Apr 2020 11:08:35 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 9E93AB5AAE
        for <netfilter-devel@vger.kernel.org>; Thu, 30 Apr 2020 17:08:33 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8EAF8B800B
        for <netfilter-devel@vger.kernel.org>; Thu, 30 Apr 2020 17:08:33 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 8E049B8003; Thu, 30 Apr 2020 17:08:33 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 89FFAB8006;
        Thu, 30 Apr 2020 17:08:31 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 30 Apr 2020 17:08:31 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 6CF3242EFB81;
        Thu, 30 Apr 2020 17:08:31 +0200 (CEST)
Date:   Thu, 30 Apr 2020 17:08:31 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH v2 00/18] iptables: introduce cache evaluation
 phase
Message-ID: <20200430150831.GA2267@salvia>
References: <20200428121013.24507-1-phil@nwl.cc>
 <20200429213609.GA24368@salvia>
 <20200430135300.GK15009@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200430135300.GK15009@orbyte.nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Apr 30, 2020 at 03:53:00PM +0200, Phil Sutter wrote:
> Hi Pablo,
>
> On Wed, Apr 29, 2020 at 11:36:09PM +0200, Pablo Neira Ayuso wrote:
> > On Tue, Apr 28, 2020 at 02:09:55PM +0200, Phil Sutter wrote:
> > > Hi Pablo,
> > >
> > > As promised, here's a revised version of your cache rework series from
> > > January. It restores performance according to my tests (which are yet to
> > > be published somewhere) and passes the testsuites.
> >
> > I did not test this yet, and I made a few rounds of quick reviews
> > alrady, but this series LGTM. Thank you for working on this.
>
> Cool! Should I push it or do you want to have a closer look first?

You already took the time to test this, so I think it's fine if you
push out. Problems can be fixed from master. It would also good a few
runs to valgrind.

BTW, this cache consistency check

commit 200bc399651499f502ac0de45f4d4aa4c9d37ab6
Author: Phil Sutter <phil@nwl.cc>
Date:   Fri Mar 13 13:02:12 2020 +0100

    nft: cache: Fix iptables-save segfault under stress

is already restored in this series, right?

Thanks.
