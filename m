Return-Path: <SRS0=p03Y=VS=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5572AC76191
	for <netfilter-devel@archiver.kernel.org>; Sun, 21 Jul 2019 18:46:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2C3402084C
	for <netfilter-devel@archiver.kernel.org>; Sun, 21 Jul 2019 18:46:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727215AbfGUSqX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 21 Jul 2019 14:46:23 -0400
Received: from mail.us.es ([193.147.175.20]:43562 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726765AbfGUSqX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 21 Jul 2019 14:46:23 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C7795DA702
        for <netfilter-devel@vger.kernel.org>; Sun, 21 Jul 2019 20:46:21 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B7FB6DA732
        for <netfilter-devel@vger.kernel.org>; Sun, 21 Jul 2019 20:46:21 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id AD80C1150B9; Sun, 21 Jul 2019 20:46:21 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C5068DA732;
        Sun, 21 Jul 2019 20:46:19 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sun, 21 Jul 2019 20:46:19 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [31.4.214.120])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 89F704265A31;
        Sun, 21 Jul 2019 20:46:19 +0200 (CEST)
Date:   Sun, 21 Jul 2019 20:46:18 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 1/3] src: erec: fall back to internal location if its
 null
Message-ID: <20190721184618.pfcmtt34xr5zaqwb@salvia>
References: <20190721001406.23785-1-fw@strlen.de>
 <20190721001406.23785-2-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190721001406.23785-2-fw@strlen.de>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sun, Jul 21, 2019 at 02:14:05AM +0200, Florian Westphal wrote:
> This should never happen (we should pass valid locations to the error
> reporting functions), but in case we screw up we will segfault during
> error reporting.
> 
> cat crash
> table inet filter {
> }
> table inet filter {
>       chain test {
>         counter
>     }
> }
> "nft -f crash" Now reports:
> internal:0:0-0: Error: No such file or directory
> 
> ... which is both bogus and useless, but better than crashing.

This should not ever happen, right?
