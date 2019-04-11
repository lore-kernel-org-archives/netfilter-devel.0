Return-Path: <SRS0=iy/8=SN=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88F6AC10F14
	for <netfilter-devel@archiver.kernel.org>; Thu, 11 Apr 2019 23:48:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 603C22146F
	for <netfilter-devel@archiver.kernel.org>; Thu, 11 Apr 2019 23:48:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727114AbfDKXs1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 11 Apr 2019 19:48:27 -0400
Received: from mail.us.es ([193.147.175.20]:41678 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726858AbfDKXs1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 11 Apr 2019 19:48:27 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id BFF874A7075
        for <netfilter-devel@vger.kernel.org>; Fri, 12 Apr 2019 01:48:24 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B0968DA70A
        for <netfilter-devel@vger.kernel.org>; Fri, 12 Apr 2019 01:48:24 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id A4DFEDA706; Fri, 12 Apr 2019 01:48:24 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8C219DA701;
        Fri, 12 Apr 2019 01:48:22 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 12 Apr 2019 01:48:22 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 65C6B4265A31;
        Fri, 12 Apr 2019 01:48:22 +0200 (CEST)
Date:   Fri, 12 Apr 2019 01:48:22 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, netdev@vger.kernel.org
Subject: Re: [PATCH nf-next 0/4] netfilter: bridge: remove broute hook
Message-ID: <20190411234822.s3d6kjvolo6u6ufo@salvia>
References: <20190411143642.1087-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190411143642.1087-1-fw@strlen.de>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Apr 11, 2019 at 04:36:38PM +0200, Florian Westphal wrote:
> This series removes the 'broute' hook by promoting ebtables' broute table
> to a normal ebtables table (invoked via normal PREROUTING netfilter hook).
> 
> The downside is that nf_hook_slow() needs to be duplicated in br_input.c
> (see patch 3).
> 
> However, I think its worth the price as this allows to remove the
> br_should_route_hook.
> 
> There are quite some changes in bridge specific code, if you prefer
> I can re-submit this for net-next instead of nf-next.
> 
> Main motivation is to provide 'ebtables -t broute' functionality via
> nftables later on, this can then be done without touching the bridge
> or netfilter core infrastructure again.

Series applied, thanks Florian.
