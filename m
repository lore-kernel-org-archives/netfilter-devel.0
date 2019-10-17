Return-Path: <SRS0=wLp+=YK=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF5ACECE58E
	for <netfilter-devel@archiver.kernel.org>; Thu, 17 Oct 2019 10:08:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B9B5920869
	for <netfilter-devel@archiver.kernel.org>; Thu, 17 Oct 2019 10:08:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732960AbfJQKIV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 17 Oct 2019 06:08:21 -0400
Received: from correo.us.es ([193.147.175.20]:53806 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731894AbfJQKIV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 17 Oct 2019 06:08:21 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 84918103284
        for <netfilter-devel@vger.kernel.org>; Thu, 17 Oct 2019 12:08:16 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7098FB7FFE
        for <netfilter-devel@vger.kernel.org>; Thu, 17 Oct 2019 12:08:16 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 6DDD2B7FF9; Thu, 17 Oct 2019 12:08:16 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5350BCA0F1;
        Thu, 17 Oct 2019 12:08:14 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 17 Oct 2019 12:08:14 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 3134A41F55EB;
        Thu, 17 Oct 2019 12:08:14 +0200 (CEST)
Date:   Thu, 17 Oct 2019 12:08:16 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH v4 0/8] Improve iptables-nft performance with
 large rulesets
Message-ID: <20191017100816.plzn3tugcu2j2rpl@salvia>
References: <20191015114152.25254-1-phil@nwl.cc>
 <20191017090332.erwubv7pzxbbowjg@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191017090332.erwubv7pzxbbowjg@salvia>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Oct 17, 2019 at 11:03:32AM +0200, Pablo Neira Ayuso wrote:
> On Tue, Oct 15, 2019 at 01:41:44PM +0200, Phil Sutter wrote:
> > Fourth try at caching optimizations implementation.
> > 
> > Changes since v3:
> > 
> > * Rebase onto current master after pushing the accepted initial three
> >   patches.
> > * Avoid cache inconsistency in __nft_build_cache() if kernel ruleset
> >   changed since last call.
> 
> I still hesitate with this cache approach.
> 
> Can this deal with this scenario? Say you have a ruleset composed on N
> rules.
> 
> * Rule 1..M starts using generation X for the evaluation, they pass
>   OK.
> 
> * Generation is bumped.
> 
> * Rule M..N is evaluated with a diferent cache.
> 
> So the ruleset evaluation is inconsistent itself since it is based on
> different caches for each rule in the batch.

It might be that rule M fails because a user-defined chain is not
found anymore, error reporting will not be consistent on races, and
who knows what else.

Anyway, if you want to go for this approach, merge it upstream and
let's test how it goes... this batch looks much better indeed than v1,
so push it out.

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
