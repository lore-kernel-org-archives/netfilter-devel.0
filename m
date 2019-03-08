Return-Path: <SRS0=0Xdd=RL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4280AC43381
	for <netfilter-devel@archiver.kernel.org>; Fri,  8 Mar 2019 15:42:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 12EED2087C
	for <netfilter-devel@archiver.kernel.org>; Fri,  8 Mar 2019 15:42:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726298AbfCHPml (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 8 Mar 2019 10:42:41 -0500
Received: from mail.us.es ([193.147.175.20]:48566 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726249AbfCHPml (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 8 Mar 2019 10:42:41 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 559EB5E5399
        for <netfilter-devel@vger.kernel.org>; Fri,  8 Mar 2019 16:42:39 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4273ADA856
        for <netfilter-devel@vger.kernel.org>; Fri,  8 Mar 2019 16:42:39 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 37FE4DA84E; Fri,  8 Mar 2019 16:42:39 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5ED1BDA856;
        Fri,  8 Mar 2019 16:42:37 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 08 Mar 2019 16:42:37 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 3C98C4265A2F;
        Fri,  8 Mar 2019 16:42:37 +0100 (CET)
Date:   Fri, 8 Mar 2019 16:42:36 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v2 nf] netfilter: nat: don't register device notifier
 twice
Message-ID: <20190308154236.rh4pvsntcddgilap@salvia>
References: <20190306114417.3265-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190306114417.3265-1-fw@strlen.de>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Mar 06, 2019 at 12:44:17PM +0100, Florian Westphal wrote:
> Otherwise, we get notifier list corruption.
> 
> This is the most simple fix: remove the device notifier call chain
> from the ipv6 masquerade register function and handle it only
> in the ipv4 version.
> 
> The better fix is merge
> nf_nat_masquerade_ipv4/6_(un)register_notifier
>   into a single
> nf_nat_masquerade_(un)register_notifiers
> 
> but to do this its needed to first merge the two masquerade modules
> into a single xt_MASQUERADE.
> 
> Furthermore, we need to use different refcounts for ipv4/ipv6
> until we can merge MASQUERADE.

Applied, thanks Florian.
