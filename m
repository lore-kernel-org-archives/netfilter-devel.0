Return-Path: <SRS0=TDc5=UZ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C6E3C48BD6
	for <netfilter-devel@archiver.kernel.org>; Wed, 26 Jun 2019 10:37:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3DB51205F4
	for <netfilter-devel@archiver.kernel.org>; Wed, 26 Jun 2019 10:37:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726992AbfFZKhw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 26 Jun 2019 06:37:52 -0400
Received: from mail.us.es ([193.147.175.20]:56532 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726131AbfFZKhv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 26 Jun 2019 06:37:51 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 6818B11F030
        for <netfilter-devel@vger.kernel.org>; Wed, 26 Jun 2019 12:37:49 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5845B202D1
        for <netfilter-devel@vger.kernel.org>; Wed, 26 Jun 2019 12:37:49 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 5782B58F; Wed, 26 Jun 2019 12:37:49 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5865EDA4D0;
        Wed, 26 Jun 2019 12:37:47 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 26 Jun 2019 12:37:47 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 330EF4265A32;
        Wed, 26 Jun 2019 12:37:47 +0200 (CEST)
Date:   Wed, 26 Jun 2019 12:37:46 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: Use of oifname in input chains
Message-ID: <20190626103746.ag26jczoq7ggkh5b@salvia>
References: <20190625122954.GC9218@orbyte.nwl.cc>
 <20190625194321.e2siqh7jfhldwzgw@salvia>
 <20190626103230.b7eqh2i3ibpkfv52@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190626103230.b7eqh2i3ibpkfv52@breakpoint.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Jun 26, 2019 at 12:32:30PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > Feature because one could add the rule to a non-base chain and jump to
> > > it from any hook to reduce duplication in ruleset. We would have to
> > > check rules in the target chain while validating the rule containing the
> > > jump.
> > > 
> > > What do you think?
> > 
> > How does this behave in iptables BTW? I think iptables simply allows
> > this, but it won't ever match obviously.
> 
> iptables userspace will reject iptables -A INPUT -o foo.
> -A FOO -o foo will "work", even if we only have a -j FOO from INPUT.
> 
> I don't think its worth to add tracking for this to kernel:
> 
> new chain C
> meta oifname bla added to C
> jump added from output to C
> jump added from input to C   # should this fail? why?
> 
> new chain C
> jump added from input to C
> meta oifname added to C	     # same q: why should this fail?

There's tracking infrastructure for this already in place, right? It's
just a matter to check for this from nft_meta_get_validate().
