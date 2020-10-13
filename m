Return-Path: <SRS0=fGlf=DU=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 274D1C433DF
	for <netfilter-devel@archiver.kernel.org>; Tue, 13 Oct 2020 10:15:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C2F0F20708
	for <netfilter-devel@archiver.kernel.org>; Tue, 13 Oct 2020 10:15:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727894AbgJMKPI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 13 Oct 2020 06:15:08 -0400
Received: from correo.us.es ([193.147.175.20]:52016 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726935AbgJMKPI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 13 Oct 2020 06:15:08 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 28DEF1C4381
        for <netfilter-devel@vger.kernel.org>; Tue, 13 Oct 2020 12:15:06 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 03430DA872
        for <netfilter-devel@vger.kernel.org>; Tue, 13 Oct 2020 12:15:06 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id EAEE8DA791; Tue, 13 Oct 2020 12:15:05 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D67D8DA793;
        Tue, 13 Oct 2020 12:15:02 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 13 Oct 2020 12:14:55 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id AB9A942EF532;
        Tue, 13 Oct 2020 12:15:02 +0200 (CEST)
Date:   Tue, 13 Oct 2020 12:15:02 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org,
        Florian Westphal <fw@strlen.de>
Subject: Re: [iptables PATCH 3/3] nft: Fix for concurrent noflush restore
 calls
Message-ID: <20201013101502.GA29142@salvia>
References: <20201005144858.11578-1-phil@nwl.cc>
 <20201005144858.11578-4-phil@nwl.cc>
 <20201012125450.GA26934@salvia>
 <20201013100803.GW13016@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201013100803.GW13016@orbyte.nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Oct 13, 2020 at 12:08:03PM +0200, Phil Sutter wrote:
[...]
> On Mon, Oct 12, 2020 at 02:54:50PM +0200, Pablo Neira Ayuso wrote:
> [...]
> > Patch LGTM, thanks Phil.
> > 
> > What I don't clearly see yet is what scenario is triggering the bug in
> > the existing code, if you don't mind to explain.
> 
> See the test case attached to the patch: An other iptables-restore
> process may add references (i.e., jumps) to a chain the own
> iptables-restore process wants to delete. This should not be a problem
> because these references are added to a chain that is being flushed by
> the own process as well. But if that chain doesn't exist while the own
> process fetches kernel's ruleset, this flush job is not created.

Let me rephrase this:

1) process A fetches the ruleset, finds no chain C (no flush job then)
2) process B adds new chain C, flush job is present
3) process B adds the ruleset
4) process A appends rules to the existing chain C (because there is
   no flush job)

Is this the scenario? If so, I wonder why the generation ID is not
helping to refresh and retry.
