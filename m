Return-Path: <SRS0=rhnh=U3=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28538C4321A
	for <netfilter-devel@archiver.kernel.org>; Fri, 28 Jun 2019 16:46:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EE71C2086D
	for <netfilter-devel@archiver.kernel.org>; Fri, 28 Jun 2019 16:46:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726780AbfF1Qqi (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 28 Jun 2019 12:46:38 -0400
Received: from mail.us.es ([193.147.175.20]:37660 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726605AbfF1Qqi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 28 Jun 2019 12:46:38 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 5462C15AEA0
        for <netfilter-devel@vger.kernel.org>; Fri, 28 Jun 2019 18:46:36 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 45EC01021A6
        for <netfilter-devel@vger.kernel.org>; Fri, 28 Jun 2019 18:46:36 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 3B6EC10219C; Fri, 28 Jun 2019 18:46:36 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EA903A5B8;
        Fri, 28 Jun 2019 18:46:32 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 28 Jun 2019 18:46:32 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [31.4.195.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id C59044265A31;
        Fri, 28 Jun 2019 18:46:32 +0200 (CEST)
Date:   Fri, 28 Jun 2019 18:46:31 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Stephen Suryaputra <ssuryaextr@gmail.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH RESEND nftables v3] exthdr: doc: add support for matching
 IPv4 options
Message-ID: <20190628164631.2ztsgxglqv3l6k2a@salvia>
References: <20190625000924.6213-1-ssuryaextr@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190625000924.6213-1-ssuryaextr@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Jun 24, 2019 at 08:09:24PM -0400, Stephen Suryaputra wrote:
> This is the userspace change for the overall changes with this
> description:
> Add capability to have rules matching IPv4 options. This is developed
> mainly to support dropping of IP packets with loose and/or strict source
> route route options.

python nft-tests.py

runs fine.

However:

python nft-tests.py -j

shows errors like:

ERROR: did not find JSON equivalent for rule 'ip option lsrr type 1'
/home/pablo/devel/scm/git-netfilter/nftables/tests/py/ip/ipopt.t.json.got:
WARNING: line 2: Wrote JSON equivalent for rule ip option lsrr type 1

Would you also fix json? Thanks.
