Return-Path: <SRS0=pLNN=YE=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5218DC47404
	for <netfilter-devel@archiver.kernel.org>; Fri, 11 Oct 2019 10:20:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3527E205F4
	for <netfilter-devel@archiver.kernel.org>; Fri, 11 Oct 2019 10:20:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726546AbfJKKU4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 11 Oct 2019 06:20:56 -0400
Received: from correo.us.es ([193.147.175.20]:45428 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726357AbfJKKU4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 11 Oct 2019 06:20:56 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 7CE84A7E1A
        for <netfilter-devel@vger.kernel.org>; Fri, 11 Oct 2019 12:20:52 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6D3BAB7FF2
        for <netfilter-devel@vger.kernel.org>; Fri, 11 Oct 2019 12:20:52 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 6C9A8FB362; Fri, 11 Oct 2019 12:20:52 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5BEF5B8007;
        Fri, 11 Oct 2019 12:20:50 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 11 Oct 2019 12:20:50 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 38BCF42EE38E;
        Fri, 11 Oct 2019 12:20:50 +0200 (CEST)
Date:   Fri, 11 Oct 2019 12:20:52 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH v3 04/11] nft-cache: Introduce cache levels
Message-ID: <20191011102052.77s5ujrdb3ficddo@salvia>
References: <20191008161447.6595-1-phil@nwl.cc>
 <20191008161447.6595-5-phil@nwl.cc>
 <20191009093723.snbyd6xvtd5gpnto@salvia>
 <20191009102901.6kel2u36u3yv4myu@salvia>
 <20191010220911.GM12661@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191010220911.GM12661@orbyte.nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Oct 11, 2019 at 12:09:11AM +0200, Phil Sutter wrote:
[...]
> Maybe we could go with a simpler solution for now, which is to check
> kernel genid again and drop the local cache if it differs from what's
> stored. If it doesn't, the current cache is still up to date and we may
> just fetch what's missing. Or does that leave room for a race condition?

My concern with this approach is that, in the dynamic ruleset update
scenarios, assuming very frequent updates, you might lose race when
building the cache in stages. Hence, forcing you to restart from
scratch in the middle of the transaction handling.

I prefer to calculate the cache that is needed in one go by analyzing
the batch, it's simpler. Note that we might lose race still since
kernel might tell us we're working on an obsolete generation number ID
cache, forcing us to restart.
