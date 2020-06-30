Return-Path: <SRS0=CJVJ=AL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8329C433E0
	for <netfilter-devel@archiver.kernel.org>; Tue, 30 Jun 2020 17:09:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8E5D7206BE
	for <netfilter-devel@archiver.kernel.org>; Tue, 30 Jun 2020 17:09:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390030AbgF3RJe (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 30 Jun 2020 13:09:34 -0400
Received: from correo.us.es ([193.147.175.20]:41908 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389482AbgF3RJe (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 30 Jun 2020 13:09:34 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 454D811EB2A
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Jun 2020 19:09:33 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 36FEFFC5EC
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Jun 2020 19:09:33 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 22F4AFC5F1; Tue, 30 Jun 2020 19:09:33 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 140A4DA722;
        Tue, 30 Jun 2020 19:09:31 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 30 Jun 2020 19:09:31 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id E8E854265A32;
        Tue, 30 Jun 2020 19:09:30 +0200 (CEST)
Date:   Tue, 30 Jun 2020 19:09:30 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: Re: [PATCH net] netfilter: ipset: call ip_set_free() instead of
 kfree()
Message-ID: <20200630170930.GA27849@salvia>
References: <20200630000417.2249731-1-edumazet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200630000417.2249731-1-edumazet@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Jun 29, 2020 at 05:04:17PM -0700, Eric Dumazet wrote:
> Whenever ip_set_alloc() is used, allocated memory can either
> use kmalloc() or vmalloc(). We should call kvfree() or
> ip_set_free()

Applied, thanks.
