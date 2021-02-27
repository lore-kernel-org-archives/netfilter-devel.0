Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.8 required=3.0 tests=BAYES_00,FORGED_MUA_MOZILLA,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49316C433E0
	for <netfilter-devel@archiver.kernel.org>; Sat, 27 Feb 2021 21:34:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C90764D73
	for <netfilter-devel@archiver.kernel.org>; Sat, 27 Feb 2021 21:34:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230060AbhB0Veb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 27 Feb 2021 16:34:31 -0500
Received: from correo.us.es ([193.147.175.20]:52030 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229991AbhB0Ve3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 27 Feb 2021 16:34:29 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D2FEE15C106
        for <netfilter-devel@vger.kernel.org>; Sat, 27 Feb 2021 22:33:47 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BDE76DA704
        for <netfilter-devel@vger.kernel.org>; Sat, 27 Feb 2021 22:33:47 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id B2BDFDA722; Sat, 27 Feb 2021 22:33:47 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8C43CDA704;
        Sat, 27 Feb 2021 22:33:45 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 27 Feb 2021 22:33:45 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 6ED8142DC6E2;
        Sat, 27 Feb 2021 22:33:45 +0100 (CET)
Date:   Sat, 27 Feb 2021 22:33:45 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf 0/3] netfilter: nat: fix ancient dnat+edemux bug
Message-ID: <20210227213345.GA15934@salvia>
References: <20210224162321.4899-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210224162321.4899-1-fw@strlen.de>
User-Agent: Mozilla/5.0
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Feb 24, 2021 at 05:23:18PM +0100, Florian Westphal wrote:
> Netfilter NAT collision handling + TCP edemux can cause packets to end
> up with the wrong socket.
> This happens since TCP early demux was added more than 8 years ago, so
> this needs very rare and specific conditions to trigger.
> 
> Patch 1 fixes the bug.
> Patch 2 rewords a debug message that imlies packets are treated
> as invalid while they are not.
> Patch 3 adds a test case for this.  On unpatched kernel this script
> should error out with:
> (UNKNOWN) [10.96.0.1] 443 (https) : Connection timed out
> FAIL: nc cannot connect via NAT'd address

Applied, thanks Florian.
