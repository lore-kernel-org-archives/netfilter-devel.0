Return-Path: <SRS0=kXi6=7Q=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D69A5C433DF
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Jun 2020 21:32:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B6C38206E6
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Jun 2020 21:32:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726303AbgFCVcl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 3 Jun 2020 17:32:41 -0400
Received: from correo.us.es ([193.147.175.20]:42706 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725961AbgFCVcl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 3 Jun 2020 17:32:41 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 027FB508CD4
        for <netfilter-devel@vger.kernel.org>; Wed,  3 Jun 2020 23:32:39 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E5307DA78F
        for <netfilter-devel@vger.kernel.org>; Wed,  3 Jun 2020 23:32:38 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id DA6E5DA78B; Wed,  3 Jun 2020 23:32:38 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4EBB3DA722;
        Wed,  3 Jun 2020 23:32:36 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 03 Jun 2020 23:32:36 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 3116042EF42A;
        Wed,  3 Jun 2020 23:32:36 +0200 (CEST)
Date:   Wed, 3 Jun 2020 23:32:35 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Harald Welte <laforge@gnumonks.org>
Cc:     netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: Re: [MAINTENANCE] Shutting down FTP services at netfilter.org
Message-ID: <20200603213235.GA31552@salvia>
References: <20200603113712.GA24918@salvia>
 <20200603171621.GC717800@nataraja>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200603171621.GC717800@nataraja>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Harald,

On Wed, Jun 03, 2020 at 07:16:21PM +0200, Harald Welte wrote:
> Hi Pablo,
> 
> On Wed, Jun 03, 2020 at 01:37:12PM +0200, Pablo Neira Ayuso wrote:
> > So netfilter.org will also be shutting down FTP services by
> > June 12th 2020.
> 
> I always find that somewhat sad, as with HTTP there is no real convenient
> way to get directory listings in a standardized / parseable format.  But
> of course I understand the rationale and I obviously respect your
> decision in that matter.

There was a discussion regarding the existing netfilter.org
infrastructure during the last workshop. People are busy and the
infrastructure maintainance tasks end up being the last thing on the
list at the end of the day, unfortunately. Luckly, there is one more
person volunteering to help maintain the netfilter.org infrastructure
these days. Still I have to scratch my limited spare time to migrate
the infrastructure to the new datacenter.

> > As an alternative, you can still reach the entire netfilter.org
> > software repository through HTTP at this new location:
> > 
> >         https://netfilter.org/pub/
> 
> Maybe make http://ftp.netfilter.org/ an alias to it?

It's just one extra file in apache and an entry on the DNS server.
Yes, I can do that. It's probably convenient to keep this at least
working for a while.

I cannot hide, however, that I would like to simplify the existing
infrastructure to reduce the maintainance burden to adecuate it to the
existing resource availability. Including the consolidation of the
existing virtual servers in apache around one or two instances.

> I think the important part would be some way to conveniently obtain a
> full clone, e.g. by rsync.  This way both public and private mirrors
> can exist in an efficient way, without having to resort to 'wget -r'
> or related hacks, which then only use file size as an indication if a
> file might have changed, ...

Regarding rsync: I'm actually considering to propose to remove
netfilter mirrors or, alternatively, only propose to maintain a number
of them that have worked reliably along these years. So rsync would be
only available for those few people that will be maintaining mirrors.

Regards.
