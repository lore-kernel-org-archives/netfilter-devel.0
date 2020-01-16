Return-Path: <SRS0=22nV=3F=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CD94C33CB6
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 Jan 2020 11:19:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2CBA52073A
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 Jan 2020 11:19:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726474AbgAPLTW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 16 Jan 2020 06:19:22 -0500
Received: from correo.us.es ([193.147.175.20]:55530 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726084AbgAPLTW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 16 Jan 2020 06:19:22 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id AEBF518FD83
        for <netfilter-devel@vger.kernel.org>; Thu, 16 Jan 2020 12:19:18 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9F04BDA714
        for <netfilter-devel@vger.kernel.org>; Thu, 16 Jan 2020 12:19:18 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 94B3EDA701; Thu, 16 Jan 2020 12:19:18 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 75AE6DA703;
        Thu, 16 Jan 2020 12:19:16 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 16 Jan 2020 12:19:16 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 5A23F42EE38E;
        Thu, 16 Jan 2020 12:19:16 +0100 (CET)
Date:   Thu, 16 Jan 2020 12:19:15 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [RFC nf-next 0/4] netfilter: conntrack: allow insertion of
 clashing entries
Message-ID: <20200116111915.d7ddcc2lavocvzrq@salvia>
References: <20200108134500.31727-1-fw@strlen.de>
 <20200113235309.GM795@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200113235309.GM795@breakpoint.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Jan 14, 2020 at 12:53:09AM +0100, Florian Westphal wrote:
> Florian Westphal <fw@strlen.de> wrote:
> > This entire series isn't nice but so far I did not find a better
> > solution.
> 
> I did consider getting rid of the unconfirmed list, but this is also
> problematic.

Another proposal:

I think the percpu unconfirmed list should become a hashtable.

From resolve_normal_ct(), if __nf_conntrack_find_get() returns NULL,
this can fall back to make a rcu lookless lookup on the unconfirmed
hashtable.

From nf_nat_inet_fn(), grab a nat spinlock only if the conntrack is
unconfirmed (slow path) to make sure that the packet winning race to
enter nf_nat_inet_fn() takes the time to set up NAT properly.
