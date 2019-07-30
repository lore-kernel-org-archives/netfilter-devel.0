Return-Path: <SRS0=FCuH=V3=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 872B5C0650F
	for <netfilter-devel@archiver.kernel.org>; Tue, 30 Jul 2019 11:39:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 64828206E0
	for <netfilter-devel@archiver.kernel.org>; Tue, 30 Jul 2019 11:39:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730822AbfG3LjC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 30 Jul 2019 07:39:02 -0400
Received: from correo.us.es ([193.147.175.20]:34924 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730551AbfG3LjC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 30 Jul 2019 07:39:02 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B6554B5AAC
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Jul 2019 13:39:00 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A3D931FFCC
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Jul 2019 13:39:00 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 99831D190F; Tue, 30 Jul 2019 13:39:00 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AB2031150CB;
        Tue, 30 Jul 2019 13:38:58 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 30 Jul 2019 13:38:58 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [47.60.32.83])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 4A49C4265A2F;
        Tue, 30 Jul 2019 13:38:58 +0200 (CEST)
Date:   Tue, 30 Jul 2019 13:38:53 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        syzbot+276ddebab3382bbf72db@syzkaller.appspotmail.com
Subject: Re: [PATCH nf] netfilter: ebtables: also count base chain policies
Message-ID: <20190730113853.le4554hfoweoifey@salvia>
References: <0000000000006d6c68058e259203@google.com>
 <20190729155810.20653-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190729155810.20653-1-fw@strlen.de>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Jul 29, 2019 at 05:58:10PM +0200, Florian Westphal wrote:
> ebtables doesn't include the base chain policies in the rule count,
> so we need to add them manually when we call into the x_tables core
> to allocate space for the comapt offset table.
> 
> This lead syzbot to trigger:
> WARNING: CPU: 1 PID: 9012 at net/netfilter/x_tables.c:649
> xt_compat_add_offset.cold+0x11/0x36 net/netfilter/x_tables.c:649

Applied, thanks Florian.
