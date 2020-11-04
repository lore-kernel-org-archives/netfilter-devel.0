Return-Path: <SRS0=dzjG=EK=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91465C2D0A3
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Nov 2020 13:04:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4188B2071A
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Nov 2020 13:04:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729795AbgKDNEg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 4 Nov 2020 08:04:36 -0500
Received: from correo.us.es ([193.147.175.20]:56140 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728508AbgKDNEf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 4 Nov 2020 08:04:35 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E1B77D9AD6C
        for <netfilter-devel@vger.kernel.org>; Wed,  4 Nov 2020 14:04:33 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CDE8CDA840
        for <netfilter-devel@vger.kernel.org>; Wed,  4 Nov 2020 14:04:33 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id CAD4FDA801; Wed,  4 Nov 2020 14:04:33 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8C4EADA840;
        Wed,  4 Nov 2020 14:04:31 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 04 Nov 2020 14:04:31 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 6836142EF9E2;
        Wed,  4 Nov 2020 14:04:31 +0100 (CET)
Date:   Wed, 4 Nov 2020 14:04:31 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 0/2] src: Optimize prefix matches on byte-boundaries
Message-ID: <20201104130431.GA5304@salvia>
References: <20201027165602.26630-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201027165602.26630-1-phil@nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Oct 27, 2020 at 05:56:00PM +0100, Phil Sutter wrote:
> This mini-series optimizes prefix matches to skip the "bitwise"
> expression if they are byte-bound. We can simply reduce "cmp" expression
> length to achieve the same effect.
> 
> The first patch adds support for delinearization, this enables correct
> display of the IP address prefix matches added by iptables-nft with my
> (not yet accepted) patch applied.
> 
> The second patch enables nft to create such bytecode itself.

Patches LGTM, thanks.
