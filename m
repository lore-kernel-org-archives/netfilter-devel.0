Return-Path: <SRS0=LKiS=YY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FBA9CA9ECB
	for <netfilter-devel@archiver.kernel.org>; Thu, 31 Oct 2019 14:14:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 39F0920873
	for <netfilter-devel@archiver.kernel.org>; Thu, 31 Oct 2019 14:14:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727720AbfJaOO5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 31 Oct 2019 10:14:57 -0400
Received: from correo.us.es ([193.147.175.20]:49098 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726793AbfJaOO4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 31 Oct 2019 10:14:56 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 229F811EB25
        for <netfilter-devel@vger.kernel.org>; Thu, 31 Oct 2019 15:14:52 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1423EB8001
        for <netfilter-devel@vger.kernel.org>; Thu, 31 Oct 2019 15:14:52 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 09EF7DA72F; Thu, 31 Oct 2019 15:14:52 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2CAC0DA72F;
        Thu, 31 Oct 2019 15:14:50 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 31 Oct 2019 15:14:50 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 09C2142EE38E;
        Thu, 31 Oct 2019 15:14:49 +0100 (CET)
Date:   Thu, 31 Oct 2019 15:14:52 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH v3 00/12] Implement among match support
Message-ID: <20191031141452.h3hknkc3qze3xm3r@salvia>
References: <20191030172701.5892-1-phil@nwl.cc>
 <20191031141314.u5fvw4djza25er44@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191031141314.u5fvw4djza25er44@salvia>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Oct 31, 2019 at 03:13:14PM +0100, Pablo Neira Ayuso wrote:
> On Wed, Oct 30, 2019 at 06:26:49PM +0100, Phil Sutter wrote:
> [...]
> > Patches 1 to 5 implement required changes and are rather boring by
> > themselves: When converting an nftnl rule to iptables command state,
> > cache access is required (to lookup set references).
> 
> nft_handle is passed now all over the place, this allows anyone to
> access all of its content. This layering design was done on purpose,
> to avoid giving access to all information to the callers, instead
> force the developer to give a reason to show why it needs something
> else from wherever he is. I'm not entirely convinced exposing the
> handle everywhere just because you need to access the set cache is the
> way to go.

In other words: You only need the cache, right? Why don't you just
expose cache to these functions which what you need?
