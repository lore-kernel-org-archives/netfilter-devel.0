Return-Path: <SRS0=572t=CR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FCCBC433E2
	for <netfilter-devel@archiver.kernel.org>; Tue,  8 Sep 2020 10:31:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 22EDF206DB
	for <netfilter-devel@archiver.kernel.org>; Tue,  8 Sep 2020 10:31:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730082AbgIHK35 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 8 Sep 2020 06:29:57 -0400
Received: from correo.us.es ([193.147.175.20]:50642 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729967AbgIHK3i (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 8 Sep 2020 06:29:38 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 808746D8CF
        for <netfilter-devel@vger.kernel.org>; Tue,  8 Sep 2020 12:29:37 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 73C41DA722
        for <netfilter-devel@vger.kernel.org>; Tue,  8 Sep 2020 12:29:37 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 697D3DA796; Tue,  8 Sep 2020 12:29:37 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 51E9CDA73F;
        Tue,  8 Sep 2020 12:29:35 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 08 Sep 2020 12:29:35 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 33BA94301DE1;
        Tue,  8 Sep 2020 12:29:35 +0200 (CEST)
Date:   Tue, 8 Sep 2020 12:29:34 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Fabian Frederick <fabf@skynet.be>
Cc:     davem@davemloft.net, kuba@kernel.org, fw@strlen.de,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH 1/1 net-next] selftests/net: replace obsolete NFT_CHAIN
 configuration
Message-ID: <20200908102934.GA4838@salvia>
References: <20200907161428.16847-1-fabf@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200907161428.16847-1-fabf@skynet.be>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Sep 07, 2020 at 06:14:28PM +0200, Fabian Frederick wrote:
> Replace old parameters with global NFT_NAT from commit db8ab38880e0
> ("netfilter: nf_tables: merge ipv4 and ipv6 nat chain types")

Applied.

Please, Cc: netfilter-devel@vger.kernel.org next time.

Thanks.
