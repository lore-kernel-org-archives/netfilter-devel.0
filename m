Return-Path: <SRS0=TDc5=UZ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74F5EC48BD3
	for <netfilter-devel@archiver.kernel.org>; Wed, 26 Jun 2019 09:08:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4B29A2054F
	for <netfilter-devel@archiver.kernel.org>; Wed, 26 Jun 2019 09:08:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726849AbfFZJIO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 26 Jun 2019 05:08:14 -0400
Received: from mail.us.es ([193.147.175.20]:53638 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726157AbfFZJIN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 26 Jun 2019 05:08:13 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id EC7B5BA1B9
        for <netfilter-devel@vger.kernel.org>; Wed, 26 Jun 2019 11:08:11 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C2E0B1150B9
        for <netfilter-devel@vger.kernel.org>; Wed, 26 Jun 2019 11:08:11 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id B6D4F114D70; Wed, 26 Jun 2019 11:08:11 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 927A71021A9;
        Wed, 26 Jun 2019 11:08:09 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 26 Jun 2019 11:08:09 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 633514265A2F;
        Wed, 26 Jun 2019 11:08:09 +0200 (CEST)
Date:   Wed, 26 Jun 2019 11:08:08 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Felix Kaechele <felix@kaechele.ca>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] netfilter: ctnetlink: Fix regression in conntrack entry
 deletion
Message-ID: <20190626090808.loyw7swhnkti2jlp@salvia>
References: <20190625204859.28241-1-felix@kaechele.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190625204859.28241-1-felix@kaechele.ca>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Jun 25, 2019 at 04:48:59PM -0400, Felix Kaechele wrote:
> Commit f8e608982022 ("netfilter: ctnetlink: Resolve conntrack
> L3-protocol flush regression") introduced a regression in which deletion
> of conntrack entries would fail because the L3 protocol information
> is replaced by AF_UNSPEC. As a result the search for the entry to be
> deleted would turn up empty due to the tuple used to perform the search
> is now different from the tuple used to initially set up the entry.
> 
> For flushing the conntrack table we do however want to keep the option
> for nfgenmsg->version to have a non-zero value to allow for newer
> user-space tools to request treatment under the new behavior. With that
> it is possible to independently flush tables for a defined L3 protocol.
> This was introduced with the enhancements in in commit 59c08c69c278
> ("netfilter: ctnetlink: Support L3 protocol-filter on flush").
> 
> Older user-space tools will retain the behavior of flushing all tables
> regardless of defined L3 protocol.

Applied, thanks Felix.
