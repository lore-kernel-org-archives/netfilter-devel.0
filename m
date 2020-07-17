Return-Path: <SRS0=dQkn=A4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE13EC433E2
	for <netfilter-devel@archiver.kernel.org>; Fri, 17 Jul 2020 10:22:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C2AD12070E
	for <netfilter-devel@archiver.kernel.org>; Fri, 17 Jul 2020 10:22:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725950AbgGQKWr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 17 Jul 2020 06:22:47 -0400
Received: from correo.us.es ([193.147.175.20]:53992 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725864AbgGQKWr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 17 Jul 2020 06:22:47 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 27913E2C4F
        for <netfilter-devel@vger.kernel.org>; Fri, 17 Jul 2020 12:22:46 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1732ADA801
        for <netfilter-devel@vger.kernel.org>; Fri, 17 Jul 2020 12:22:46 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 0BC58DA78C; Fri, 17 Jul 2020 12:22:46 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EDF08DA78D;
        Fri, 17 Jul 2020 12:22:43 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 17 Jul 2020 12:22:43 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id C606942EF4E2;
        Fri, 17 Jul 2020 12:22:43 +0200 (CEST)
Date:   Fri, 17 Jul 2020 12:22:43 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Giuseppe Scrivano <gscrivan@redhat.com>
Cc:     netfilter-devel@vger.kernel.org, Phil Sutter <phil@nwl.cc>,
        Florian Westphal <fw@strlen.de>
Subject: Re: [iptables PATCH v3] iptables: accept lock file name at runtime
Message-ID: <20200717102243.GB18560@salvia>
References: <20200717083940.618618-1-gscrivan@redhat.com>
 <20200717092744.GA17027@salvia>
 <87wo32v4at.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87wo32v4at.fsf@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Jul 17, 2020 at 12:12:10PM +0200, Giuseppe Scrivano wrote:
> Hi Pablo,
> 
> Pablo Neira Ayuso <pablo@netfilter.org> writes:
> 
> > Probably remove the check for lock_file[0] == '\0'
> >
> > Or is this intentional?
> 
> I've added it intentionally as I think it is safer to ignore an empty
> string.  The programs I've checked, GNU coreutils and GNU grep, have the
> same check.

Thanks for explaining.

> The empty string will likely fail on open(2), at least on tmpfs
> it does with ENOENT.  If you want though, I can drop the check.

No worries, patch description did not explain this and quick git grep
on iptables was showing no check for \0 in other spots in the tree. No
need to drop the check.
