Return-Path: <SRS0=CgNT=DN=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A5B9C41604
	for <netfilter-devel@archiver.kernel.org>; Tue,  6 Oct 2020 10:48:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0CF8520757
	for <netfilter-devel@archiver.kernel.org>; Tue,  6 Oct 2020 10:48:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725942AbgJFKsi (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 6 Oct 2020 06:48:38 -0400
Received: from correo.us.es ([193.147.175.20]:39228 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725891AbgJFKsi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Oct 2020 06:48:38 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 68D36396262
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Oct 2020 12:48:53 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 58359DA73F
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Oct 2020 12:48:53 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 4DA41DA792; Tue,  6 Oct 2020 12:48:53 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 27AC7DA791;
        Tue,  6 Oct 2020 12:48:50 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 06 Oct 2020 12:48:50 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 0B0B842EF42C;
        Tue,  6 Oct 2020 12:48:50 +0200 (CEST)
Date:   Tue, 6 Oct 2020 12:48:49 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org,
        Serhey Popovych <serhe.popovych@gmail.com>
Subject: Re: [iptables PATCH 1/3] libxtables: Make sure extensions register
 in revision order
Message-ID: <20201006104849.GA18853@salvia>
References: <20200922225341.8976-1-phil@nwl.cc>
 <20200922225341.8976-2-phil@nwl.cc>
 <20201003111741.GA3035@salvia>
 <20201004145339.GE29050@orbyte.nwl.cc>
 <20201005224255.GA13440@salvia>
 <20201006092723.GJ29050@orbyte.nwl.cc>
 <20201006095047.GA17114@salvia>
 <20201006101303.GM29050@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201006101303.GM29050@orbyte.nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Oct 06, 2020 at 12:13:03PM +0200, Phil Sutter wrote:
[...]
> Put more simply: I'm not assuming *any* ordering in input, not even
> grouped input by name. But I chose the algorithm to optimize for input
> which is grouped by name and family and sorted by ascending revision
> within groups, as that is mostly the case in in-tree extensions.

Looks good, thanks for explaining.
