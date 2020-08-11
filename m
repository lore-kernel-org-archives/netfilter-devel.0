Return-Path: <SRS0=vjpg=BV=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B101EC433DF
	for <netfilter-devel@archiver.kernel.org>; Tue, 11 Aug 2020 07:31:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C6A920781
	for <netfilter-devel@archiver.kernel.org>; Tue, 11 Aug 2020 07:31:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728000AbgHKHbH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 11 Aug 2020 03:31:07 -0400
Received: from correo.us.es ([193.147.175.20]:45370 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727852AbgHKHbH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 11 Aug 2020 03:31:07 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 6760BE4B86
        for <netfilter-devel@vger.kernel.org>; Tue, 11 Aug 2020 09:31:05 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 577C8DA853
        for <netfilter-devel@vger.kernel.org>; Tue, 11 Aug 2020 09:31:05 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 4BAFDDA852; Tue, 11 Aug 2020 09:31:05 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1CF09DA722;
        Tue, 11 Aug 2020 09:31:03 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 11 Aug 2020 09:31:03 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (57.pool85-48-186.static.orange.es [85.48.186.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id A1849426CCB9;
        Tue, 11 Aug 2020 09:31:02 +0200 (CEST)
Date:   Tue, 11 Aug 2020 09:30:59 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: avoid ipv6 -> nf_defrag_ipv6 module
 dependency
Message-ID: <20200811073059.GE1403@salvia>
References: <20200810115215.369-1-fw@strlen.de>
 <20200811073026.GD1403@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200811073026.GD1403@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Aug 11, 2020 at 09:30:26AM +0200, Pablo Neira Ayuso wrote:
> On Mon, Aug 10, 2020 at 01:52:15PM +0200, Florian Westphal wrote:
> > nf_ct_frag6_gather is part of nf_defrag_ipv6.ko, not ipv6 core.
> > 
> > The current use of the netfilter ipv6 stub indirections  causes a module
> > dependency between ipv6 and nf_defrag_ipv6.
> > 
> > This prevents nf_defrag_ipv6 module from being removed because ipv6 can't
> > be unloaded.
> > 
> > Remove the indirection and always use a direct call.  This creates a
> > depency from nf_conntrack_bridge to nf_defrag_ipv6 instead:
> > 
> > modinfo nf_conntrack
> > depends:        nf_conntrack,nf_defrag_ipv6,bridge
> > 
> > .. and nf_conntrack already depends on nf_defrag_ipv6 anyway.
> > 
> > Signed-off-by: Florian Westphal <fw@strlen.de>
> > ---
> >  I can also re-send it when nf-next reopens later, whatever you prefer.
> 
> No problem, it can just sit here until net-next reopens.

Oh, I skipped the [PATCH nf] tag. This can go to nf.git then.
