Return-Path: <SRS0=EiUA=4V=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA52CC3F2D1
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Mar 2020 01:26:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A2DA02073B
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Mar 2020 01:26:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387498AbgCDB06 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 3 Mar 2020 20:26:58 -0500
Received: from correo.us.es ([193.147.175.20]:54646 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387490AbgCDB06 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 3 Mar 2020 20:26:58 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 5AA506D4E8
        for <netfilter-devel@vger.kernel.org>; Wed,  4 Mar 2020 02:26:42 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4D062DA3A0
        for <netfilter-devel@vger.kernel.org>; Wed,  4 Mar 2020 02:26:42 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 4C5DCDA38D; Wed,  4 Mar 2020 02:26:42 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 86967DA7B2;
        Wed,  4 Mar 2020 02:26:40 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 04 Mar 2020 02:26:40 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 62D284251480;
        Wed,  4 Mar 2020 02:26:40 +0100 (CET)
Date:   Wed, 4 Mar 2020 02:26:54 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netfilter-devel@vger.kernel.org, fw@strlen.de,
        netdev@vger.kernel.org
Subject: Re: [PATCH netfilter 0/3] netfilter: add missing attribute validation
Message-ID: <20200304012654.quo3wm3kg5nwj2cg@salvia>
References: <20200303050833.4089193-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200303050833.4089193-1-kuba@kernel.org>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Mar 02, 2020 at 09:08:30PM -0800, Jakub Kicinski wrote:
> Hi!
> 
> Netfilter and nf_tables is missing a handful of netlink policy entries.

Series applied, thank you!
