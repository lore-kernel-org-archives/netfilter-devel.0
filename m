Return-Path: <SRS0=J2Vc=4L=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE915C35673
	for <netfilter-devel@archiver.kernel.org>; Sun, 23 Feb 2020 21:43:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B512220675
	for <netfilter-devel@archiver.kernel.org>; Sun, 23 Feb 2020 21:43:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727133AbgBWVnm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 23 Feb 2020 16:43:42 -0500
Received: from correo.us.es ([193.147.175.20]:52154 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726302AbgBWVnm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 23 Feb 2020 16:43:42 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 61205DA718
        for <netfilter-devel@vger.kernel.org>; Sun, 23 Feb 2020 22:43:35 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5326ADA7B2
        for <netfilter-devel@vger.kernel.org>; Sun, 23 Feb 2020 22:43:35 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 48D37DA788; Sun, 23 Feb 2020 22:43:35 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 83BA2DA736;
        Sun, 23 Feb 2020 22:43:33 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sun, 23 Feb 2020 22:43:33 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 6693F42EF4E1;
        Sun, 23 Feb 2020 22:43:33 +0100 (CET)
Date:   Sun, 23 Feb 2020 22:43:38 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next v2 0/2] netfilter: nf_tables: make sets built-in
Message-ID: <20200223214338.gwalga4rsyssecvq@salvia>
References: <20200218105927.4685-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200218105927.4685-1-fw@strlen.de>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Feb 18, 2020 at 11:59:25AM +0100, Florian Westphal wrote:
> v2, only change is in 2/2 where a left-over __read_mostly annotation
> was removed.
> 
> v1 cover letter:
> There is little to no technical reason to have an extra kconfig knob for
> this; nf_tables main use case it levaraging set infrastructure for
> decisions/packet classification.
> 
> Also there were number of bug reports that turned out to be
> caused by builds with nftables enabled and sets disabled.
> 
> This removes the set kconfig knob and places set infra in the nf_tables
> core.

Applied.
