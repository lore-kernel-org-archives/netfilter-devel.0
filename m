Return-Path: <SRS0=UFFK=AD=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC270C433DF
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Jun 2020 08:26:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C915D20708
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Jun 2020 08:26:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726140AbgFVI0h (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 22 Jun 2020 04:26:37 -0400
Received: from correo.us.es ([193.147.175.20]:48910 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726080AbgFVI0h (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 22 Jun 2020 04:26:37 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 31039130E27
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Jun 2020 10:26:36 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2278E114D7B
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Jun 2020 10:26:36 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 176F0114D76; Mon, 22 Jun 2020 10:26:36 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DE3C4DA72F;
        Mon, 22 Jun 2020 10:26:33 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 22 Jun 2020 10:26:33 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id B994942EE38F;
        Mon, 22 Jun 2020 10:26:33 +0200 (CEST)
Date:   Mon, 22 Jun 2020 10:26:33 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     coreteam@netfilter.org, netfilter-devel@vger.kernel.org,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH] netfiler: ipset: fix unaligned atomic access
Message-ID: <20200622082633.GA4512@salvia>
References: <E1jj7gl-0008Bq-BQ@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1jj7gl-0008Bq-BQ@rmk-PC.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Jun 10, 2020 at 09:51:11PM +0100, Russell King wrote:
> When using ip_set with counters and comment, traffic causes the kernel
> to panic on 32-bit ARM:
> 
> Alignment trap: not handling instruction e1b82f9f at [<bf01b0dc>]
> Unhandled fault: alignment exception (0x221) at 0xea08133c
> PC is at ip_set_match_extensions+0xe0/0x224 [ip_set]
> 
> The problem occurs when we try to update the 64-bit counters - the
> faulting address above is not 64-bit aligned.  The problem occurs
> due to the way elements are allocated, for example:
> 
> 	set->dsize = ip_set_elem_len(set, tb, 0, 0);
> 	map = ip_set_alloc(sizeof(*map) + elements * set->dsize);
> 
> If the element has a requirement for a member to be 64-bit aligned,
> and set->dsize is not a multiple of 8, but is a multiple of four,
> then every odd numbered elements will be misaligned - and hitting
> an atomic64_add() on that element will cause the kernel to panic.
> 
> ip_set_elem_len() must return a size that is rounded to the maximum
> alignment of any extension field stored in the element.  This change
> ensures that is the case.

Applied, thanks.
