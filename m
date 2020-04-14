Return-Path: <SRS0=Os75=56=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91C2CC2BB1D
	for <netfilter-devel@archiver.kernel.org>; Tue, 14 Apr 2020 21:39:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6765720767
	for <netfilter-devel@archiver.kernel.org>; Tue, 14 Apr 2020 21:39:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732193AbgDNVjy (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 14 Apr 2020 17:39:54 -0400
Received: from correo.us.es ([193.147.175.20]:50050 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731763AbgDNVjv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 14 Apr 2020 17:39:51 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B8A49DA711
        for <netfilter-devel@vger.kernel.org>; Tue, 14 Apr 2020 23:39:50 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AC054FC553
        for <netfilter-devel@vger.kernel.org>; Tue, 14 Apr 2020 23:39:50 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id A18B5FC54C; Tue, 14 Apr 2020 23:39:50 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3E135DA8E6;
        Tue, 14 Apr 2020 23:39:47 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 14 Apr 2020 23:39:47 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 1F5E84301DF4;
        Tue, 14 Apr 2020 23:39:47 +0200 (CEST)
Date:   Tue, 14 Apr 2020 23:39:46 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH 0/3] nft: cache: Minor review
Message-ID: <20200414213946.x7xgsxes253ilqsj@salvia>
References: <20200407143445.26394-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200407143445.26394-1-phil@nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Apr 07, 2020 at 04:34:42PM +0200, Phil Sutter wrote:
> Minor code simplification in patches 1 and 2, a small tweak to set
> fetching in patch 3.
> 
> Basically these are fall-out from working at rewritten cache logic.

LGTM.

These are not clashing with my pending patches, right? :-)

Thanks.
