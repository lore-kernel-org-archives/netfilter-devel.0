Return-Path: <SRS0=wLp+=YK=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4298CECE58E
	for <netfilter-devel@archiver.kernel.org>; Thu, 17 Oct 2019 09:07:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0EAF92082C
	for <netfilter-devel@archiver.kernel.org>; Thu, 17 Oct 2019 09:07:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405236AbfJQJHp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 17 Oct 2019 05:07:45 -0400
Received: from correo.us.es ([193.147.175.20]:38630 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731152AbfJQJHp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 17 Oct 2019 05:07:45 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id AF75818CE94
        for <netfilter-devel@vger.kernel.org>; Thu, 17 Oct 2019 11:07:40 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A04C3DA72F
        for <netfilter-devel@vger.kernel.org>; Thu, 17 Oct 2019 11:07:40 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 9278EDA840; Thu, 17 Oct 2019 11:07:40 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9A9ABDA7B6;
        Thu, 17 Oct 2019 11:07:38 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 17 Oct 2019 11:07:38 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 770004251481;
        Thu, 17 Oct 2019 11:07:38 +0200 (CEST)
Date:   Thu, 17 Oct 2019 11:07:38 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 2/4] Revert "monitor: fix double cache update with
 --echo"
Message-ID: <20191017090738.2wey6j4mfzelgse2@salvia>
References: <20191016230322.24432-1-phil@nwl.cc>
 <20191016230322.24432-3-phil@nwl.cc>
 <20191017085549.zm4jcz23q6vceful@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191017085549.zm4jcz23q6vceful@salvia>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Oct 17, 2019 at 10:55:49AM +0200, Pablo Neira Ayuso wrote:
> On Thu, Oct 17, 2019 at 01:03:20AM +0200, Phil Sutter wrote:
> > This reverts commit 9b032cd6477b847f48dc8454f0e73935e9f48754.
> >
> > While it is true that a cache exists, we still need to capture new sets
> > and their elements if they are anonymous. This is because the name
> > changes and rules will refer to them by name.

Please, tell me how I can reproduce this here with a simple snippet
and I will have a look. Thanks!

> > Given that there is no easy way to identify the anonymous set in cache
> > (kernel doesn't (and shouldn't) dump SET_ID value) to update its name,
> > just go with cache updates. Assuming that echo option is typically used
> > for single commands, there is not much cache updating happening anyway.
> 
> This was fixing a real bug, if this is breaking anything, then I think
> we are not getting to the root cause.
> 
> But reverting it does not make things any better.
