Return-Path: <SRS0=/ozj=TY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FBAAC072B5
	for <netfilter-devel@archiver.kernel.org>; Fri, 24 May 2019 09:22:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CDE7F217F9
	for <netfilter-devel@archiver.kernel.org>; Fri, 24 May 2019 09:22:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389762AbfEXJWy (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 24 May 2019 05:22:54 -0400
Received: from mail.us.es ([193.147.175.20]:37684 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389515AbfEXJWy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 24 May 2019 05:22:54 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 56D8510FB00
        for <netfilter-devel@vger.kernel.org>; Fri, 24 May 2019 11:22:52 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 456C8DA707
        for <netfilter-devel@vger.kernel.org>; Fri, 24 May 2019 11:22:52 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 4324BDA703; Fri, 24 May 2019 11:22:52 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0361CDA709;
        Fri, 24 May 2019 11:22:50 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 24 May 2019 11:22:45 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id D1D9340705C6;
        Fri, 24 May 2019 11:22:49 +0200 (CEST)
Date:   Fri, 24 May 2019 11:22:49 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc:     Kristian Evensen <kristian.evensen@gmail.com>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] netfilter: ctnetlink: Resolve conntrack L3-protocol
 flush regression
Message-ID: <20190524092249.7gatc643noc27qzp@salvia>
References: <20190503154007.32495-1-kristian.evensen@gmail.com>
 <20190505223229.3ujqpwmuefd3wh7b@salvia>
 <4ecbebbb-0a7f-6d45-c2c0-00dee746e573@6wind.com>
 <20190506131605.kapyns6gkyphbea2@salvia>
 <6dea0101-9267-ae20-d317-649f1f550089@6wind.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6dea0101-9267-ae20-d317-649f1f550089@6wind.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, May 20, 2019 at 10:35:07AM +0200, Nicolas Dichtel wrote:
> Le 06/05/2019 à 15:16, Pablo Neira Ayuso a écrit :
> > On Mon, May 06, 2019 at 10:49:52AM +0200, Nicolas Dichtel wrote:
> [snip]
> >> Is it possible to queue this for stable?
> > 
> > Sure, as soon as this hits Linus' tree.
> > 
> FYI, it's now in Linus tree:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=f8e608982022

Please, send an email requesting this to stable@vger.kernel.org and
keep me on CC.

I'll ACK it.

Thanks.
