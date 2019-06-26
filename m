Return-Path: <SRS0=TDc5=UZ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 876BDC48BD6
	for <netfilter-devel@archiver.kernel.org>; Wed, 26 Jun 2019 12:50:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6890E214DA
	for <netfilter-devel@archiver.kernel.org>; Wed, 26 Jun 2019 12:50:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726723AbfFZMuq (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 26 Jun 2019 08:50:46 -0400
Received: from mail.us.es ([193.147.175.20]:60450 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726104AbfFZMup (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 26 Jun 2019 08:50:45 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id DAE5EB5700
        for <netfilter-devel@vger.kernel.org>; Wed, 26 Jun 2019 14:50:42 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C9010DA801
        for <netfilter-devel@vger.kernel.org>; Wed, 26 Jun 2019 14:50:42 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id BE7FEDA704; Wed, 26 Jun 2019 14:50:42 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8DEEEFB37C;
        Wed, 26 Jun 2019 14:50:40 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 26 Jun 2019 14:50:40 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [31.4.197.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 6845240705C3;
        Wed, 26 Jun 2019 14:50:40 +0200 (CEST)
Date:   Wed, 26 Jun 2019 14:50:38 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: Use of oifname in input chains
Message-ID: <20190626125038.25bclkhvsj7mseng@salvia>
References: <20190625122954.GC9218@orbyte.nwl.cc>
 <20190625194321.e2siqh7jfhldwzgw@salvia>
 <20190626103230.b7eqh2i3ibpkfv52@breakpoint.cc>
 <20190626103746.ag26jczoq7ggkh5b@salvia>
 <20190626104254.cfhkfpagequp6kuv@breakpoint.cc>
 <20190626104740.vw7xzrkoqd2lwzqh@salvia>
 <20190626105812.kkq6bfdcoihmphrd@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190626105812.kkq6bfdcoihmphrd@breakpoint.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Jun 26, 2019 at 12:58:12PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > delete jump from output		# disallow?
> > > 
> > > This seems rather suicidal to me.
> > 
> > OK, you think there may be people using oifname from the C chain, but
> > how so? To skip rules that are specific to the output path?
> 
> Maybe, or just to consolidate rules, e.g.
> 
> chain C {
> 	[ some common rules ]
> 	meta oifname bla ...
> 	[ other common rules ]
> }
> 
> After the proposed change, kernel refuses ruleset as soon as C is
> or becomes reachable from a prerouting/input basechain.

I think it's more likely to misuse oifname from input path (eg. typo)
that finding someone with such usecase you describe above but...

> (Alternatively, we could reject if not reachable from output/forward,
>  but that seems even more crazy because we'd have to refuse ruleset
>  that has unreachable chain with 'oifname' in it ...).

... I have no problem whatsoever to leave the existing behaviour in place.

No need to keep spinning on this :-)
