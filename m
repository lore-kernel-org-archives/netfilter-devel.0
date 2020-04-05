Return-Path: <SRS0=tJPO=5V=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB86BC2BA1B
	for <netfilter-devel@archiver.kernel.org>; Sun,  5 Apr 2020 19:47:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7EAA820644
	for <netfilter-devel@archiver.kernel.org>; Sun,  5 Apr 2020 19:47:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728247AbgDETrT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 5 Apr 2020 15:47:19 -0400
Received: from correo.us.es ([193.147.175.20]:34330 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727612AbgDETrT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 5 Apr 2020 15:47:19 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id EF2BD8140A
        for <netfilter-devel@vger.kernel.org>; Sun,  5 Apr 2020 21:47:16 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E147F100A50
        for <netfilter-devel@vger.kernel.org>; Sun,  5 Apr 2020 21:47:16 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id D610EDA736; Sun,  5 Apr 2020 21:47:16 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7C921DA736;
        Sun,  5 Apr 2020 21:47:14 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sun, 05 Apr 2020 21:47:14 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 59F5342EE38E;
        Sun,  5 Apr 2020 21:47:14 +0200 (CEST)
Date:   Sun, 5 Apr 2020 21:47:14 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: Re: [PATCH nf 1/1] netfilter: nf_tables: do not leave dangling
 pointer in nf_tables_set_alloc_name
Message-ID: <20200405194714.wagcla6jdvkn55di@salvia>
References: <20200401173716.222205-1-edumazet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200401173716.222205-1-edumazet@google.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Apr 01, 2020 at 10:37:16AM -0700, Eric Dumazet wrote:
> If nf_tables_set_alloc_name() frees set->name, we better
> clear set->name to avoid a future use-after-free or invalid-free.

Applied, thank you.
