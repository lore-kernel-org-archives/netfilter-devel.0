Return-Path: <SRS0=CDuC=UQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7647FC31E5C
	for <netfilter-devel@archiver.kernel.org>; Mon, 17 Jun 2019 16:07:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4F569208C0
	for <netfilter-devel@archiver.kernel.org>; Mon, 17 Jun 2019 16:07:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726362AbfFQQHD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 17 Jun 2019 12:07:03 -0400
Received: from mail.us.es ([193.147.175.20]:54764 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726028AbfFQQHC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 17 Jun 2019 12:07:02 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 4191B6DFDD
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Jun 2019 18:07:00 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 322D9DA702
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Jun 2019 18:07:00 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 27BF8DA70F; Mon, 17 Jun 2019 18:07:00 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 21853DA70C;
        Mon, 17 Jun 2019 18:06:58 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 17 Jun 2019 18:06:58 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id F1F9A4265A2F;
        Mon, 17 Jun 2019 18:06:57 +0200 (CEST)
Date:   Mon, 17 Jun 2019 18:06:57 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org,
        fw@strlen.de
Subject: Re: [PATCH nft 2/5] tests: shell: cannot use handle for non-existing
 rule in kernel
Message-ID: <20190617160657.qrl2vx5dn5zomk6l@salvia>
References: <20190617122518.10486-1-pablo@netfilter.org>
 <20190617122518.10486-2-pablo@netfilter.org>
 <20190617160030.GS31548@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190617160030.GS31548@orbyte.nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Phil,

On Mon, Jun 17, 2019 at 06:00:30PM +0200, Phil Sutter wrote:
> Hi,
> 
> On Mon, Jun 17, 2019 at 02:25:15PM +0200, Pablo Neira Ayuso wrote:
> > This test invokes the 'replace rule ... handle 2' command. However,
> > there are no rules in the kernel, therefore it always fails.
> 
> This guesses the previously inserted rule's handle. Does this start
> failing with your flags conversion in place?

Yes.

> My initial implementation of intra-transaction rule references made
> this handle guessing impossible, but your single point cache
> fetching still allowed for it (hence why I dropped my patch with a
> similar change).

Hm. I think we should not guess the handle that the kernel assigns.

In a batch, handles do not exist. We could expose the
intra-transaction index if needed to the user. But I don't see a
use-case for this.

I think we should leave the handle as a reference to already existing
rules in the kernel.
