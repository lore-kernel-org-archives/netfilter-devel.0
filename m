Return-Path: <SRS0=iRt+=ZL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37D60C432C0
	for <netfilter-devel@archiver.kernel.org>; Tue, 19 Nov 2019 22:11:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 14BBA2245B
	for <netfilter-devel@archiver.kernel.org>; Tue, 19 Nov 2019 22:11:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727468AbfKSWLi (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 19 Nov 2019 17:11:38 -0500
Received: from correo.us.es ([193.147.175.20]:37420 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725923AbfKSWLi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 19 Nov 2019 17:11:38 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 8E549E1519
        for <netfilter-devel@vger.kernel.org>; Tue, 19 Nov 2019 23:11:34 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7B72EFB362
        for <netfilter-devel@vger.kernel.org>; Tue, 19 Nov 2019 23:11:34 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 6AB778012A; Tue, 19 Nov 2019 23:11:34 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 77E36DA4D0;
        Tue, 19 Nov 2019 23:11:32 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 19 Nov 2019 23:11:32 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 530E742EE38E;
        Tue, 19 Nov 2019 23:11:32 +0100 (CET)
Date:   Tue, 19 Nov 2019 23:11:33 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
Cc:     "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: Re: Choosing best API-way to full dump/restore nftables
Message-ID: <20191119221133.66nqmwivrid6y6pa@salvia>
References: <20191119152120.85eaddcc5d6f76c6980bd68a@virtuozzo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191119152120.85eaddcc5d6f76c6980bd68a@virtuozzo.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Tue, Nov 19, 2019 at 12:21:21PM +0000, Alexander Mikhalitsyn wrote:
> Dear colleagues,
> 
> In CRIU (Checkpoint/Restore In Userspace) we want to add support nft
> dump/restore. Initial implementation directly uses `nft list ruleset
> dumpfile`/`nft -f dumpfile` but it's not the best way because
> fork/exec is needed. We want to use some API. But after diving
> into libnftnl and nftables code I've realized that it's not so
> simple: in libnftnl there is some partial code for JSON support in
> nftables too. But as I see in libnftnl JSON doesn't fully
> supported. In nftables I've found tests/json_echo/run-test.py test
> that uses libnftables.so shared library that exports some
> functions for dumping/restoring full ruleset as JSON. After some
> googling, I've found that recently CLI and API interfaces related
> to JSON/XML exporting functions of nft have changed significantly.
> Question is: What API I could use to have confidence that in the
> near future it will not be deprecated? (We need only make *full*
> dump/restore nftables)

Please, see:

        man 3 libnftables
