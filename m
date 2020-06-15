Return-Path: <SRS0=VCDi=74=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15B60C433DF
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Jun 2020 22:05:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EB48020739
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Jun 2020 22:05:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726308AbgFOWFr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 15 Jun 2020 18:05:47 -0400
Received: from correo.us.es ([193.147.175.20]:54646 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725903AbgFOWFr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 15 Jun 2020 18:05:47 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id ADABF124EE6
        for <netfilter-devel@vger.kernel.org>; Tue, 16 Jun 2020 00:05:45 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9E198DA793
        for <netfilter-devel@vger.kernel.org>; Tue, 16 Jun 2020 00:05:45 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 932D0DA722; Tue, 16 Jun 2020 00:05:45 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7A188DA78A;
        Tue, 16 Jun 2020 00:05:43 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 16 Jun 2020 00:05:43 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 5AC54426CCBA;
        Tue, 16 Jun 2020 00:05:43 +0200 (CEST)
Date:   Tue, 16 Jun 2020 00:05:43 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Stefano Brivio <sbrivio@redhat.com>
Cc:     Mike Dillinger <miked@softtalker.com>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] tests: 0044interval_overlap_0: Repeat insertion
 tests with timeout
Message-ID: <20200615220543.GA26718@salvia>
References: <99aaa1c20475b24ce52d767d1104a7ad64c00350.1591141568.git.sbrivio@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <99aaa1c20475b24ce52d767d1104a7ad64c00350.1591141568.git.sbrivio@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Jun 03, 2020 at 01:51:20AM +0200, Stefano Brivio wrote:
> Mike Dillinger reported issues with insertion of entries into sets
> supporting intervals that were denied because of false conflicts with
> elements that were already expired. Partial failures would occur to,
> leading to the generation of new intervals the user didn't specify,
> as only the opening or the closing elements wouldn't be inserted.
> 
> The reproducer provided by Mike looks like this:
> 
>   #!/bin/bash
>   nft list set ip filter blacklist4-ip-1m
>   for ((i=1;i<=10;i++)); do
>         nft add element filter blacklist4-ip-1m {$i.$i.$i.$i}
>         sleep 1
>   done
>   nft list set ip filter blacklist4-ip-1m
> 
> which, run in a loop at different intervals, show the different kind
> of failures.
> 
> Extend the existing test case for overlapping and non-overlapping
> intervals to systematically cover sets with a configured timeout.

Also applied, thanks.
