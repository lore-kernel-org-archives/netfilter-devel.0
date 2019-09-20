Return-Path: <SRS0=NOIG=XP=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE280C49ED7
	for <netfilter-devel@archiver.kernel.org>; Fri, 20 Sep 2019 11:13:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9C0D720882
	for <netfilter-devel@archiver.kernel.org>; Fri, 20 Sep 2019 11:13:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438158AbfITLNg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 20 Sep 2019 07:13:36 -0400
Received: from correo.us.es ([193.147.175.20]:50324 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438154AbfITLNf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 20 Sep 2019 07:13:35 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 0BBACB6C64
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Sep 2019 13:13:32 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EE34FCA0F3
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Sep 2019 13:13:31 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id ED339CE39C; Fri, 20 Sep 2019 13:13:31 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CA3686DA3A;
        Fri, 20 Sep 2019 13:13:29 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 20 Sep 2019 13:13:29 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [5.182.56.138])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 76E8442EE38E;
        Fri, 20 Sep 2019 13:13:29 +0200 (CEST)
Date:   Fri, 20 Sep 2019 13:13:29 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH 07/14] nft Increase mnl_talk() receive buffer
 size
Message-ID: <20190920111329.g6nuxbpovzrtq2aq@salvia>
References: <20190916165000.18217-1-phil@nwl.cc>
 <20190916165000.18217-8-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190916165000.18217-8-phil@nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Sep 16, 2019 at 06:49:53PM +0200, Phil Sutter wrote:
> This improves cache population quite a bit and therefore helps when
> dealing with large rulesets. A simple hard to improve use-case is
> listing the last rule in a large chain. These are the average program
> run times depending on number of rules:
> 
> rule count	| legacy	| nft old	| nft new
> ---------------------------------------------------------
>  50,000		| .052s		| .611s		| .406s
> 100,000		| .115s		| 2.12s		| 1.24s
> 150,000		| .265s		| 7.63s		| 4.14s
> 200,000		| .411s		| 21.0s		| 10.6s
> 
> So while legacy iptables is still magnitudes faster, this simple change
> doubles iptables-nft performance in ideal cases.
> 
> Note that increasing the buffer even further didn't improve performance
> anymore, so 32KB seems to be an upper limit in kernel space.

Here are the details for this 32 KB number:

commit d35c99ff77ecb2eb239731b799386f3b3637a31e
Author: Eric Dumazet <edumazet@google.com>
Date:   Thu Oct 6 04:13:18 2016 +0900

    netlink: do not enter direct reclaim from netlink_dump()

iproute2 is also using 32 KBytes buffer, in case you want to append
this to your commit description before pushing this out.

> Signed-off-by: Phil Sutter <phil@nwl.cc>

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
