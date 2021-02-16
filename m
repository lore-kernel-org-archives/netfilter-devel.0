Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.4 required=3.0 tests=BAYES_00,FORGED_MUA_MOZILLA,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB631C433DB
	for <netfilter-devel@archiver.kernel.org>; Tue, 16 Feb 2021 13:36:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8F3CC64DFF
	for <netfilter-devel@archiver.kernel.org>; Tue, 16 Feb 2021 13:36:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229864AbhBPNgY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 16 Feb 2021 08:36:24 -0500
Received: from correo.us.es ([193.147.175.20]:53158 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229812AbhBPNgX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 16 Feb 2021 08:36:23 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 39FA32EFEB2
        for <netfilter-devel@vger.kernel.org>; Tue, 16 Feb 2021 14:35:41 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 27777DA73D
        for <netfilter-devel@vger.kernel.org>; Tue, 16 Feb 2021 14:35:41 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 1C79DDA704; Tue, 16 Feb 2021 14:35:41 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0A8A8DA78A;
        Tue, 16 Feb 2021 14:35:39 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 16 Feb 2021 14:35:39 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id D973B42DF562;
        Tue, 16 Feb 2021 14:35:38 +0100 (CET)
Date:   Tue, 16 Feb 2021 14:35:38 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 0/3] nft: fix ct zone handling in sets and maps
Message-ID: <20210216133538.GA9919@salvia>
References: <20210203165707.21781-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210203165707.21781-1-fw@strlen.de>
User-Agent: Mozilla/5.0
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Feb 03, 2021 at 05:57:03PM +0100, Florian Westphal wrote:
> 'ct zone' (and other expressions w. host byte order and integer dtype)
> are not handled correctly on little endian platforms.
> 
> First patch adds a test case that demonstrates the problem,
> patch 2 and 3 resolve this for the mapping and set key cases.

Series LGTM, thanks Florian.
