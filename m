Return-Path: <SRS0=A3Nh=UF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A96E1C04AB5
	for <netfilter-devel@archiver.kernel.org>; Thu,  6 Jun 2019 09:21:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7F42B2083E
	for <netfilter-devel@archiver.kernel.org>; Thu,  6 Jun 2019 09:21:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727734AbfFFJVN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 6 Jun 2019 05:21:13 -0400
Received: from mail.us.es ([193.147.175.20]:37466 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727540AbfFFJVN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 6 Jun 2019 05:21:13 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 0EB00C4246
        for <netfilter-devel@vger.kernel.org>; Thu,  6 Jun 2019 11:21:12 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F38E4DA701
        for <netfilter-devel@vger.kernel.org>; Thu,  6 Jun 2019 11:21:11 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id E923BDA705; Thu,  6 Jun 2019 11:21:11 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 014ADDA701;
        Thu,  6 Jun 2019 11:21:10 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 06 Jun 2019 11:21:10 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id D4B1E4265A32;
        Thu,  6 Jun 2019 11:21:09 +0200 (CEST)
Date:   Thu, 6 Jun 2019 11:21:09 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org, Eric Garver <e@erig.me>
Subject: Re: [nft PATCH v5 01/10] src: Fix cache_flush() in
 cache_needs_more() logic
Message-ID: <20190606092109.f33ofbtl5np5rbdj@salvia>
References: <20190604173158.1184-1-phil@nwl.cc>
 <20190604173158.1184-2-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190604173158.1184-2-phil@nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Jun 04, 2019 at 07:31:49PM +0200, Phil Sutter wrote:
> Commit 34a20645d54fa enabled cache updates depending on command causing
> it. As a side-effect, this disabled measures in cache_flush() preventing
> a later cache update. Re-establish this by setting cache->cmd in
> addition to cache->genid after dropping cache entries.
> 
> While being at it, set cache->cmd in cache_release() as well. This
> shouldn't be necessary since zeroing cache->genid should suffice for
> cache_update(), but better be consistent (and future-proof) here.

Applied, thanks Phil.
