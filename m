Return-Path: <SRS0=lJQT=5J=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12A0BC43331
	for <netfilter-devel@archiver.kernel.org>; Tue, 24 Mar 2020 19:01:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DC63720714
	for <netfilter-devel@archiver.kernel.org>; Tue, 24 Mar 2020 19:01:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727876AbgCXTBz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 24 Mar 2020 15:01:55 -0400
Received: from correo.us.es ([193.147.175.20]:55324 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727715AbgCXTBz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 24 Mar 2020 15:01:55 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 799761E2C62
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Mar 2020 20:01:17 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 67BB0DA390
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Mar 2020 20:01:17 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 5D28ADA736; Tue, 24 Mar 2020 20:01:17 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 93586DA3A0;
        Tue, 24 Mar 2020 20:01:15 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 24 Mar 2020 20:01:15 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 7652B42EF42B;
        Tue, 24 Mar 2020 20:01:15 +0100 (CET)
Date:   Tue, 24 Mar 2020 20:01:51 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v3 nf] selftests: netfilter: add nfqueue test case
Message-ID: <20200324190151.3qvkupml4krbitvu@salvia>
References: <20200323163430.11240-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200323163430.11240-1-fw@strlen.de>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Mar 23, 2020 at 05:34:30PM +0100, Florian Westphal wrote:
> Add a test case to check nf queue infrastructure.
> Could be extended in the future to also cover serialization of
> conntrack, uid and secctx attributes in nfqueue.
> 
> For now, this checks that 'queue bypass' works, that a queue rule with
> no bypass option blocks traffic and that userspace receives the expected
> number of packets.
> For this we add two queues and hook all of
> prerouting/input/forward/output/postrouting.
> 
> Packets get queued twice with a dummy base chain in between:
> This passes with current nf tree, but reverting
> commit 946c0d8e6ed4 ("netfilter: nf_queue: fix reinject verdict handling")
> makes this trip (it processes 30 instead of expected 20 packets).

Applied, thanks.
