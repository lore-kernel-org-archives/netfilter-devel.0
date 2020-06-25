Return-Path: <SRS0=ETlx=AG=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D88FCC433E0
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 Jun 2020 18:35:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B75E62082E
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 Jun 2020 18:35:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405388AbgFYSff (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 25 Jun 2020 14:35:35 -0400
Received: from correo.us.es ([193.147.175.20]:36640 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405208AbgFYSfe (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 25 Jun 2020 14:35:34 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 34BFAB6C62
        for <netfilter-devel@vger.kernel.org>; Thu, 25 Jun 2020 20:35:33 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 261ABDA796
        for <netfilter-devel@vger.kernel.org>; Thu, 25 Jun 2020 20:35:33 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 1BE56DA78B; Thu, 25 Jun 2020 20:35:33 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D60FDDA78B;
        Thu, 25 Jun 2020 20:35:30 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 25 Jun 2020 20:35:30 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id B791942EE38E;
        Thu, 25 Jun 2020 20:35:30 +0200 (CEST)
Date:   Thu, 25 Jun 2020 20:35:30 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next 0/5] support for anonymous non-base chains in
 nftables
Message-ID: <20200625183530.GA2141@salvia>
References: <20200625181651.1481-1-pablo@netfilter.org>
 <20200625182809.GZ26990@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200625182809.GZ26990@breakpoint.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Jun 25, 2020 at 08:28:09PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > This patchset extends the nftables netlink API to support for anonymous
> > non-base chains. Anonymous non-base chains have two properties:
> > 
> > 1) The kernel dynamically allocates the (internal) chain name.
> > 2) If the rule that refers to the anonymous chain is removed, then the
> >    anonymous chain and its content is also released.
> > 
> > This new infrastructure allows for the following syntax from userspace:
> > 
> >  table inet x {
> >         chain y {
> >                 type filter hook input priority 0;
> >                 tcp dport 22 chain {
> >                         ip saddr { 127.0.0.0/8, 172.23.0.0/16, 192.168.13.0/24 } accept
> >                         ip6 saddr ::1/128 accept;
> >                 }
> >         }
> >  }
> 
> What about goto semantics?
> 
> Would it make sense to change this to
> 
> tcp dport 22 jump chain {
> 	 ...
> 
> so this could be changed to support 'tcp dport 22 goto chain {' as well?

Yes.

To expose goto, it should be possible to use this instead:

        tcp dport 22 jump {
                ...

and

        tcp dport 22 goto {
                ...

Thanks!
