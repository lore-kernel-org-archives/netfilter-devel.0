Return-Path: <SRS0=wLp+=YK=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3140CFA3733
	for <netfilter-devel@archiver.kernel.org>; Thu, 17 Oct 2019 09:50:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 12A6921D7F
	for <netfilter-devel@archiver.kernel.org>; Thu, 17 Oct 2019 09:50:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393993AbfJQJuX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 17 Oct 2019 05:50:23 -0400
Received: from correo.us.es ([193.147.175.20]:39702 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389021AbfJQJuX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 17 Oct 2019 05:50:23 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 88E77ED600
        for <netfilter-devel@vger.kernel.org>; Thu, 17 Oct 2019 11:50:19 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 760EBB8009
        for <netfilter-devel@vger.kernel.org>; Thu, 17 Oct 2019 11:50:19 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 6BB4BB8007; Thu, 17 Oct 2019 11:50:19 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3B32E21FE5;
        Thu, 17 Oct 2019 11:50:17 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 17 Oct 2019 11:50:17 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 09DB44251480;
        Thu, 17 Oct 2019 11:50:16 +0200 (CEST)
Date:   Thu, 17 Oct 2019 11:50:17 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v2 nf-next 0/2] netfilter: conntrack: free extension area
 immediately
Message-ID: <20191017095017.zo36ixhybdxax6jy@salvia>
References: <20191015131915.28385-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191015131915.28385-1-fw@strlen.de>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Oct 15, 2019 at 03:19:13PM +0200, Florian Westphal wrote:
> conntrack extensions are free'd via kfree_rcu, but there appears to be
> no need for this anymore.
> 
> Lookup doesn't access ct->ext.  All other accesses i found occur
> after taking either the hash bucket lock, the dying list lock,
> or a ct reference count.
> 
> Only exception was ctnetlink, where we could potentially see a
> ct->ext that is about to be free'd via krealloc on other cpu.
> Since that only affects unconfirmed conntracks, just skip dumping
> extensions for those.
> 

Applied.
