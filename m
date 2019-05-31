Return-Path: <SRS0=7QpW=T7=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DDAAC04AB6
	for <netfilter-devel@archiver.kernel.org>; Fri, 31 May 2019 16:10:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F212126B9A
	for <netfilter-devel@archiver.kernel.org>; Fri, 31 May 2019 16:10:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726678AbfEaQKc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 31 May 2019 12:10:32 -0400
Received: from mail.us.es ([193.147.175.20]:42972 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726037AbfEaQKc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 31 May 2019 12:10:32 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B115A80766
        for <netfilter-devel@vger.kernel.org>; Fri, 31 May 2019 18:10:30 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A2E84DA709
        for <netfilter-devel@vger.kernel.org>; Fri, 31 May 2019 18:10:30 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 98A1BDA708; Fri, 31 May 2019 18:10:30 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A5F4EDA702;
        Fri, 31 May 2019 18:10:28 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 31 May 2019 18:10:28 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 7D5DC4265A31;
        Fri, 31 May 2019 18:10:28 +0200 (CEST)
Date:   Fri, 31 May 2019 18:10:28 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 0/2] Fix and simplify mnl_batch_talk()
Message-ID: <20190531161028.hmuuu5rr4xko7tp7@salvia>
References: <20190531141743.15049-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190531141743.15049-1-phil@nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, May 31, 2019 at 04:17:41PM +0200, Phil Sutter wrote:
> As requested, here's the mnl_batch_talk() fix extracted from previous
> series. To make things more clear, I've split this into a very minimal
> FD_SET/select reordering fix and a follow-up simplifying the code a bit.

Series applied, thanks Phil.
