Return-Path: <SRS0=20ch=WJ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20DDCC32750
	for <netfilter-devel@archiver.kernel.org>; Tue, 13 Aug 2019 19:26:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E98742054F
	for <netfilter-devel@archiver.kernel.org>; Tue, 13 Aug 2019 19:26:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726188AbfHMT0H (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 13 Aug 2019 15:26:07 -0400
Received: from correo.us.es ([193.147.175.20]:37928 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726126AbfHMT0H (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 13 Aug 2019 15:26:07 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 2ACCEB6324
        for <netfilter-devel@vger.kernel.org>; Tue, 13 Aug 2019 21:26:05 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1C62FDA7E1
        for <netfilter-devel@vger.kernel.org>; Tue, 13 Aug 2019 21:26:05 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 11FD2DA72F; Tue, 13 Aug 2019 21:26:05 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1DBA5DA7E1;
        Tue, 13 Aug 2019 21:26:03 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 13 Aug 2019 21:26:03 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [31.4.218.116])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id EC8E74265A2F;
        Tue, 13 Aug 2019 21:26:02 +0200 (CEST)
Date:   Tue, 13 Aug 2019 21:26:02 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nftables 2/4] src: parser: fix parsing of chain priority
 and policy on bigendian
Message-ID: <20190813192602.q7r43eg36cqsxlyh@salvia>
References: <20190813184409.10757-1-fw@strlen.de>
 <20190813184409.10757-3-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190813184409.10757-3-fw@strlen.de>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Aug 13, 2019 at 08:44:07PM +0200, Florian Westphal wrote:
> tests/shell/testcases/flowtable/0001flowtable_0
> tests/shell/testcases/nft-f/0008split_tables_0
> fail the 'dump compare' on s390x.
> The priority (10) turns to 0, and accept turned to drop.
> 
> Problem is that '$1' is a 64bit value -- then we pass the address
> and import 'int' -- we then get the upper all zero bits.
> 
> Use an intermediate value instead.

Probably add this:

%union {
        uint64_t                val;
        uint32_t                val32;

then update this to use it?

%type <val32>                   int_num chain_policy

We can get someone to review all these typing, maybe some more folks
need <val32>.
