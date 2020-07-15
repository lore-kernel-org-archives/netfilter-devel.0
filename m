Return-Path: <SRS0=26XO=A2=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD6B2C433DF
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 Jul 2020 18:48:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 800BE2065F
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 Jul 2020 18:48:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726648AbgGOSsl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 15 Jul 2020 14:48:41 -0400
Received: from correo.us.es ([193.147.175.20]:39830 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726465AbgGOSsl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Jul 2020 14:48:41 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 3C6D0DA851
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Jul 2020 20:48:40 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2E7DDDA78F
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Jul 2020 20:48:40 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 238F5DA78C; Wed, 15 Jul 2020 20:48:40 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 159FFDA722;
        Wed, 15 Jul 2020 20:48:38 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 15 Jul 2020 20:48:38 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id EC98E4265A2F;
        Wed, 15 Jul 2020 20:48:37 +0200 (CEST)
Date:   Wed, 15 Jul 2020 20:48:37 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        syzbot+2570f2c036e3da5db176@syzkaller.appspotmail.com
Subject: Re: [PATCH nf] netfilter: nf_tables: fix nat hook table deletion
Message-ID: <20200715184837.GA19055@salvia>
References: <20200714165139.14385-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200714165139.14385-1-fw@strlen.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Jul 14, 2020 at 06:51:39PM +0200, Florian Westphal wrote:
> sybot came up with following transaction:
>  add table ip syz0
>  add chain ip syz0 syz2 { type nat hook prerouting priority 0; policy accept; }
>  add table ip syz0 { flags dormant; }
>  delete chain ip syz0 syz2
>  delete table ip syz0
> 
> which yields:
> hook not found, pf 2 num 0
> WARNING: CPU: 0 PID: 6775 at net/netfilter/core.c:413 __nf_unregister_net_hook+0x3e6/0x4a0 net/netfilter/core.c:413
> [..]

Applied, thanks.
