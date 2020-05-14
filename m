Return-Path: <SRS0=bPAQ=64=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C3ECC433E0
	for <netfilter-devel@archiver.kernel.org>; Thu, 14 May 2020 12:23:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DD6A8206DA
	for <netfilter-devel@archiver.kernel.org>; Thu, 14 May 2020 12:23:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726191AbgENMXc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 14 May 2020 08:23:32 -0400
Received: from correo.us.es ([193.147.175.20]:57122 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725955AbgENMXc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 14 May 2020 08:23:32 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 2ABBD15C111
        for <netfilter-devel@vger.kernel.org>; Thu, 14 May 2020 14:23:31 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1CB76DA716
        for <netfilter-devel@vger.kernel.org>; Thu, 14 May 2020 14:23:31 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 11E96DA709; Thu, 14 May 2020 14:23:31 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 23B19DA717;
        Thu, 14 May 2020 14:23:29 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 14 May 2020 14:23:29 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 026E642EF42B;
        Thu, 14 May 2020 14:23:28 +0200 (CEST)
Date:   Thu, 14 May 2020 14:23:28 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH 0/3] Fix SECMARK target comparison
Message-ID: <20200514122328.GA24661@salvia>
References: <20200512171018.16871-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200512171018.16871-1-phil@nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, May 12, 2020 at 07:10:15PM +0200, Phil Sutter wrote:
> The kernel sets struct secmark_target_info->secid, so target comparison
> in user space failed every time. Given that target data comparison
> happens in libiptc, fixing this is a bit harder than just adding a cmp()
> callback to struct xtables_target. Instead, allow for targets to write
> the matchmask bits for their private data themselves and account for
> that in both legacy and nft code. Then make use of the new
> infrastructure to fix libxt_SECMARK.

Hm, -D and -C with SECMARK are broken since the beginning.

Another possible would be to fix the kernel to update the layout, to
get it aligned with other existing extensions.
