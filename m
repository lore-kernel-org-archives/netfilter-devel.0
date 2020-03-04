Return-Path: <SRS0=EiUA=4V=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2266C3F2C6
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Mar 2020 01:25:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9EF2B20726
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Mar 2020 01:25:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387402AbgCDBZl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 3 Mar 2020 20:25:41 -0500
Received: from correo.us.es ([193.147.175.20]:54350 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727985AbgCDBZl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 3 Mar 2020 20:25:41 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 6902C6D4E8
        for <netfilter-devel@vger.kernel.org>; Wed,  4 Mar 2020 02:25:25 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5A0F0DA3A3
        for <netfilter-devel@vger.kernel.org>; Wed,  4 Mar 2020 02:25:25 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 4F391DA38F; Wed,  4 Mar 2020 02:25:25 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 71110DA3C3;
        Wed,  4 Mar 2020 02:25:23 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 04 Mar 2020 02:25:23 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 5493D4251480;
        Wed,  4 Mar 2020 02:25:23 +0100 (CET)
Date:   Wed, 4 Mar 2020 02:25:37 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        netdev@vger.kernel.org,
        syzbot+a2ff6fa45162a5ed4dd3@syzkaller.appspotmail.com
Subject: Re: [PATCH nf] netfilter: nf_tables: free flowtable hooks on hook
 register error
Message-ID: <20200304012537.rkz2u3dipbeoz6fx@salvia>
References: <20200302205850.29365-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200302205850.29365-1-fw@strlen.de>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Mar 02, 2020 at 09:58:50PM +0100, Florian Westphal wrote:
> If hook registration fails, the hooks allocated via nft_netdev_hook_alloc
> need to be freed.
> 
> We can't change the goto label to 'goto 5' -- while it does fix the memleak
> it does cause a warning splat from the netfilter core (the hooks were not
> registered).

Applied, thanks.
