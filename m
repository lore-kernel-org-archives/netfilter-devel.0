Return-Path: <SRS0=yhqN=4H=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9ABCDC34056
	for <netfilter-devel@archiver.kernel.org>; Wed, 19 Feb 2020 17:53:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 750E0206DB
	for <netfilter-devel@archiver.kernel.org>; Wed, 19 Feb 2020 17:53:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726647AbgBSRxH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 19 Feb 2020 12:53:07 -0500
Received: from correo.us.es ([193.147.175.20]:50110 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726593AbgBSRxG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 19 Feb 2020 12:53:06 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 7201DF23A5
        for <netfilter-devel@vger.kernel.org>; Wed, 19 Feb 2020 18:53:04 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6441CDA3AB
        for <netfilter-devel@vger.kernel.org>; Wed, 19 Feb 2020 18:53:04 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 56C12DA390; Wed, 19 Feb 2020 18:53:04 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 71D9BDA840;
        Wed, 19 Feb 2020 18:53:02 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 19 Feb 2020 18:53:02 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 55C4242EF52A;
        Wed, 19 Feb 2020 18:53:02 +0100 (CET)
Date:   Wed, 19 Feb 2020 18:53:02 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Stefano Brivio <sbrivio@redhat.com>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Kadlecsik =?iso-8859-1?Q?J=F3zsef?= <kadlec@blackhole.kfki.hu>,
        Eric Garver <eric@garver.life>, Phil Sutter <phil@nwl.cc>
Subject: Re: [PATCH nft v5] tests: Introduce test for set with concatenated
 ranges
Message-ID: <20200219175302.nnabqwq4xcal4t5e@salvia>
References: <546dccfe97760ba910676b84799b15d38164e192.1581693171.git.sbrivio@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <546dccfe97760ba910676b84799b15d38164e192.1581693171.git.sbrivio@redhat.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Feb 14, 2020 at 04:27:25PM +0100, Stefano Brivio wrote:
> This test checks that set elements can be added, deleted, that
> addition and deletion are refused when appropriate, that entries
> time out properly, and that they can be fetched by matching values
> in the given ranges.

Applied, thanks Stefano.
