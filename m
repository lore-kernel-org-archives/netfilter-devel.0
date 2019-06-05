Return-Path: <SRS0=tNyb=UE=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1172C28CC5
	for <netfilter-devel@archiver.kernel.org>; Wed,  5 Jun 2019 17:05:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 904FD206C3
	for <netfilter-devel@archiver.kernel.org>; Wed,  5 Jun 2019 17:05:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728768AbfFERFq (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 5 Jun 2019 13:05:46 -0400
Received: from mail.us.es ([193.147.175.20]:37318 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728729AbfFERFq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 5 Jun 2019 13:05:46 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 7B38EFB448
        for <netfilter-devel@vger.kernel.org>; Wed,  5 Jun 2019 19:05:44 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6AD42DA709
        for <netfilter-devel@vger.kernel.org>; Wed,  5 Jun 2019 19:05:44 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 605B0DA705; Wed,  5 Jun 2019 19:05:44 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DA531DA706;
        Wed,  5 Jun 2019 19:05:41 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 05 Jun 2019 19:05:41 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id B6AD94265A2F;
        Wed,  5 Jun 2019 19:05:41 +0200 (CEST)
Date:   Wed, 5 Jun 2019 19:05:41 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org, Eric Garver <e@erig.me>
Subject: Re: [nft PATCH v5 00/10] Cache update fix && intra-transaction rule
 references
Message-ID: <20190605170541.g4mhpsn7k72qyeso@salvia>
References: <20190604173158.1184-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190604173158.1184-1-phil@nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Phil,

Thanks a lot for working on this, I have a few comments.

On Tue, Jun 04, 2019 at 07:31:48PM +0200, Phil Sutter wrote:
> Next round of combined cache update fix and intra-transaction rule
> reference support.

Patch 1 looks good.

> Patch 2 is new, it avoids accidential cache updates when committing a
> transaction containing flush ruleset command and kernel ruleset has
> changed meanwhile.

Patch 2: Could you provide an example scenario for this new patch?

> Patch 3 is also new: If a transaction fails in kernel, local cache is
> incorrect - drop it.

Patch 3 looks good!

Regarding patches 4, 5 and 6. I think we can skip them if we follow
the approach described by [1], given there is only one single
cache_update() call after that patchset, we don't need to do the
"Restore local entries after cache update" logic.

[1] https://marc.info/?l=netfilter-devel&m=155975322308042&w=2

> Patch 9 is a new requirement for patch 10 due to relocation of new
> functions.
> 
> Patch 10 was changed, changelog included.

Patch 10 looks fine. However, as said, I would like to avoid the patch
dependencies 4, 5 and 6, they are adding more cache_update() calls and
I think we should go in the opposite direction to end up with a more
simple approach.

Thanks!
