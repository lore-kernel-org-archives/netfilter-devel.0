Return-Path: <SRS0=v1Ge=CG=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02DDEC433E6
	for <netfilter-devel@archiver.kernel.org>; Fri, 28 Aug 2020 17:52:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D587C20776
	for <netfilter-devel@archiver.kernel.org>; Fri, 28 Aug 2020 17:52:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727878AbgH1RwJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 28 Aug 2020 13:52:09 -0400
Received: from correo.us.es ([193.147.175.20]:34410 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726794AbgH1RwI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 28 Aug 2020 13:52:08 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id F280220A522
        for <netfilter-devel@vger.kernel.org>; Fri, 28 Aug 2020 19:52:06 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E3818DA704
        for <netfilter-devel@vger.kernel.org>; Fri, 28 Aug 2020 19:52:06 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id D92E6DA730; Fri, 28 Aug 2020 19:52:06 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CBF01DA704;
        Fri, 28 Aug 2020 19:52:04 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 28 Aug 2020 19:52:04 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id ADB2342EF4E0;
        Fri, 28 Aug 2020 19:52:04 +0200 (CEST)
Date:   Fri, 28 Aug 2020 19:52:04 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next 0/4] netfilter: revisit conntrack statistics
Message-ID: <20200828175204.GA24446@salvia>
References: <20200825225245.8072-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200825225245.8072-1-fw@strlen.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Aug 26, 2020 at 12:52:41AM +0200, Florian Westphal wrote:
> With recent addition of clash resolution the 'insert_failed' counter has
> become confusing.  Depending on wheter clash resolution is successful,
> insert_failed increments or both insert_failed and drop increment.
> 
> Example (conntrack -S):
> [..] insert_failed=15 drop=0 [..] search_restart=268
> 
> This means clash resolution worked and the insert_failed increase is harmeless.
> In case drop is non-zero, things become murky.
> 
> It would be better to have a dedicated counter that only increments when
> clash resolution is successful.
> 
> This series revisits conntrack statistics.  Counters that do not
> indicate an error or reside in fast-paths are removed.
> 
> With patched kernel and conntrack tool, output looks similar to this
> during a 'clash resolve' stress test:
> 
> [..] insert_failed=9 drop=9 [..] search_restart=123 clash_resolve=3675

Series applied, thanks.
