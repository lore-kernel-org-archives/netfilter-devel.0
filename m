Return-Path: <SRS0=9u1R=UN=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A32CBC31E4B
	for <netfilter-devel@archiver.kernel.org>; Fri, 14 Jun 2019 13:04:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 81E19208CA
	for <netfilter-devel@archiver.kernel.org>; Fri, 14 Jun 2019 13:04:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727922AbfFNNEn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 14 Jun 2019 09:04:43 -0400
Received: from mail.us.es ([193.147.175.20]:34680 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727807AbfFNNEn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 14 Jun 2019 09:04:43 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 0CD8A819A3
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Jun 2019 15:04:41 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F403FDA70C
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Jun 2019 15:04:40 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id E99CDDA705; Fri, 14 Jun 2019 15:04:40 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EEE4ADA70A;
        Fri, 14 Jun 2019 15:04:38 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 14 Jun 2019 15:04:38 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id CBC5D4265A31;
        Fri, 14 Jun 2019 15:04:38 +0200 (CEST)
Date:   Fri, 14 Jun 2019 15:04:38 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org,
        fw@strlen.de
Subject: Re: [PATCH nft,v2] cache: do not populate the cache in case of flush
 ruleset command
Message-ID: <20190614130438.y6stvoi3ydz33s55@salvia>
References: <20190614123630.17341-1-pablo@netfilter.org>
 <20190614125432.GO31548@orbyte.nwl.cc>
 <20190614125910.zlpbor35toz6ewgp@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190614125910.zlpbor35toz6ewgp@salvia>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Jun 14, 2019 at 02:59:10PM +0200, Pablo Neira Ayuso wrote:
> On Fri, Jun 14, 2019 at 02:54:32PM +0200, Phil Sutter wrote:
> > Hi Pablo,
> > 
> > On Fri, Jun 14, 2019 at 02:36:30PM +0200, Pablo Neira Ayuso wrote:
> > > __CMD_FLUSH_RULESET is a dummy definition that used to skip the netlink
> > > dump to populate the cache. This patch is a workaround until we have a
> > > better infrastructure to track the state of the cache objects.
> > 
> > I assumed the problem wouldn't exist anymore since we're populating the
> > cache just once. Can you maybe elaborate a bit on the problem you're
> > trying to solve with that workaround?
> 
> If nft segfaults to dump the cache, 'nft flush ruleset' will not work
> since it always fetches the cache, it will segfault too.
> 
> The flush ruleset command was still dumping the cache before this
> patch.

In general, we still need to improve the cache logic, to make it finer
grain. Now that we have a single point to populate the cache, things
will get more simple. We need to replace the cache command level to
cache flags or our own cache level definitions. The existing approach
that uses of commands to define the cache level completeness has its
own limitations. We can discuss this during the NFWS :-).
