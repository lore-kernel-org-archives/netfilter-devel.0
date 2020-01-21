Return-Path: <SRS0=AyPt=3K=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75E9FC2D0DB
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 Jan 2020 12:56:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 55CB42051A
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 Jan 2020 12:56:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727817AbgAUM4R (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 21 Jan 2020 07:56:17 -0500
Received: from correo.us.es ([193.147.175.20]:35176 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727059AbgAUM4Q (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 Jan 2020 07:56:16 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 29558172C8A
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Jan 2020 13:56:15 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 18B8CDA712
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Jan 2020 13:56:15 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 0E366DA707; Tue, 21 Jan 2020 13:56:15 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 18671DA718;
        Tue, 21 Jan 2020 13:56:13 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 21 Jan 2020 13:56:13 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id F144242EE38F;
        Tue, 21 Jan 2020 13:56:12 +0100 (CET)
Date:   Tue, 21 Jan 2020 13:56:12 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 3/4] segtree: Fix for potential NULL-pointer deref in
 ei_insert()
Message-ID: <20200121125612.6kmvuazs6bmarhir@salvia>
References: <20200120162540.9699-1-phil@nwl.cc>
 <20200120162540.9699-4-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200120162540.9699-4-phil@nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Jan 20, 2020 at 05:25:39PM +0100, Phil Sutter wrote:
> Covscan complained about potential deref of NULL 'lei' pointer,
> Interestingly this can't happen as the relevant goto leading to that
> (in line 260) sits in code checking conflicts between new intervals and
> since those are sorted upon insertion, only the lower boundary may
> conflict (or both, but that's covered before).
> 
> Given the needed investigation to proof covscan wrong and the actually
> wrong (but impossible) code, better fix this as if element ordering was
> arbitrary to avoid surprises if at some point it really becomes that.
> 
> Fixes: 4d6ad0f310d6c ("segtree: check for overlapping elements at insertion")

Not fixing anything. Tell them to fix covscan :-)
