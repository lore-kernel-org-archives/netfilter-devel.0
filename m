Return-Path: <SRS0=Hoda=6K=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A20D0C55194
	for <netfilter-devel@archiver.kernel.org>; Sun, 26 Apr 2020 21:43:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 89B752070A
	for <netfilter-devel@archiver.kernel.org>; Sun, 26 Apr 2020 21:43:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726343AbgDZVnp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 26 Apr 2020 17:43:45 -0400
Received: from correo.us.es ([193.147.175.20]:52878 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726184AbgDZVnn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 26 Apr 2020 17:43:43 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B01D9DA72F
        for <netfilter-devel@vger.kernel.org>; Sun, 26 Apr 2020 23:43:40 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A184CBAAB5
        for <netfilter-devel@vger.kernel.org>; Sun, 26 Apr 2020 23:43:40 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 9744BBAAB1; Sun, 26 Apr 2020 23:43:40 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BA990DA736;
        Sun, 26 Apr 2020 23:43:38 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sun, 26 Apr 2020 23:43:38 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 9CCFD42EF4E0;
        Sun, 26 Apr 2020 23:43:38 +0200 (CEST)
Date:   Sun, 26 Apr 2020 23:43:38 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Romain Bellan <romain.bellan@wifirst.fr>
Cc:     netfilter-devel@vger.kernel.org,
        Florent Fourcot <florent.fourcot@wifirst.fr>
Subject: Re: [PATCH nf-next v5 1/1] netfilter: ctnetlink: add kernel side
 filtering for dump
Message-ID: <20200426214338.GA2276@salvia>
References: <20200330204637.11472-1-romain.bellan@wifirst.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200330204637.11472-1-romain.bellan@wifirst.fr>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Florent, Romain,

On Mon, Mar 30, 2020 at 10:46:37PM +0200, Romain Bellan wrote:
> Conntrack dump does not support kernel side filtering (only get exists,
> but it returns only one entry. And user has to give a full valid tuple)
> 
> It means that userspace has to implement filtering after receiving many
> irrelevant entries, consuming resources (conntrack table is sometimes
> very huge, much more than a routing table for example).
> 
> This patch adds filtering in kernel side. To achieve this goal, we:
> 
>  * Add a new CTA_FILTER netlink attributes, actually a flag list to
>    parametize filtering
>  * Convert some *nlattr_to_tuple() functions, to allow a partial parsing
>    of CTA_TUPLE_ORIG and CTA_TUPLE_REPLY (so nf_conntrack_tuple it not
>    fully set)

Still some issues here running conntrack-tools/tests/conntrack/test-conntrack.c
with your patch v5 on top of nf-next, it reports:

        OK: 84 BAD: 38

it should say:

        OK: 122 BAD: 0

The test this needs to be compiled via:

        gcc -lnetfilter_conntrack test-conntrack.c -o test

I'm attaching the log for the run of your patch v5.

Have a look at the "BAD" pattern which provides tells what conntrack
command stopped working.

Thanks for working on this.
