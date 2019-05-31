Return-Path: <SRS0=7QpW=T7=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01859C04AB6
	for <netfilter-devel@archiver.kernel.org>; Fri, 31 May 2019 15:56:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C5C2A26B89
	for <netfilter-devel@archiver.kernel.org>; Fri, 31 May 2019 15:56:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726652AbfEaP4U (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 31 May 2019 11:56:20 -0400
Received: from mail.us.es ([193.147.175.20]:38048 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726576AbfEaP4U (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 31 May 2019 11:56:20 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 6C42881A08
        for <netfilter-devel@vger.kernel.org>; Fri, 31 May 2019 17:56:18 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5C929DA707
        for <netfilter-devel@vger.kernel.org>; Fri, 31 May 2019 17:56:18 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 524B1DA701; Fri, 31 May 2019 17:56:18 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 589B7DA704;
        Fri, 31 May 2019 17:56:16 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 31 May 2019 17:56:16 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 2D0244265A5B;
        Fri, 31 May 2019 17:56:16 +0200 (CEST)
Date:   Fri, 31 May 2019 17:56:15 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next] netfilter: nf_tables: free base chain counters
 from worker
Message-ID: <20190531155615.tywuxqyk6odshdhn@salvia>
References: <20190522213511.21419-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190522213511.21419-1-fw@strlen.de>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, May 22, 2019 at 11:35:11PM +0200, Florian Westphal wrote:
> No need to use synchronize_rcu() here, just swap the two pointers
> and have the release occur from work queue after commit has completed.

Applied, thanks Florian.
