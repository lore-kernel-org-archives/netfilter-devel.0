Return-Path: <SRS0=QW5x=UU=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95586C43613
	for <netfilter-devel@archiver.kernel.org>; Fri, 21 Jun 2019 16:48:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6AA9120665
	for <netfilter-devel@archiver.kernel.org>; Fri, 21 Jun 2019 16:48:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726017AbfFUQs6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 21 Jun 2019 12:48:58 -0400
Received: from mail.us.es ([193.147.175.20]:42392 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726002AbfFUQs6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 21 Jun 2019 12:48:58 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id F1CA2EDB0D
        for <netfilter-devel@vger.kernel.org>; Fri, 21 Jun 2019 18:48:55 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E237EDA702
        for <netfilter-devel@vger.kernel.org>; Fri, 21 Jun 2019 18:48:55 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id D7C66DA701; Fri, 21 Jun 2019 18:48:55 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EA7C0DA702;
        Fri, 21 Jun 2019 18:48:53 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 21 Jun 2019 18:48:53 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id C8E624265A2F;
        Fri, 21 Jun 2019 18:48:53 +0200 (CEST)
Date:   Fri, 21 Jun 2019 18:48:53 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft,v2] ct: support for NFT_CT_{SRC,DST}_{IP,IP6}
Message-ID: <20190621164853.aq42prnxia6h3qvs@salvia>
References: <20190621162934.6953-1-pablo@netfilter.org>
 <20190621164514.o4ljon5nqvkgjy52@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190621164514.o4ljon5nqvkgjy52@breakpoint.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Jun 21, 2019 at 06:45:14PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > diff --git a/tests/py/inet/ct.t.json.output b/tests/py/inet/ct.t.json.output
> > index 8b71519e9be7..74c436a3a79e 100644
> > --- a/tests/py/inet/ct.t.json.output
> > +++ b/tests/py/inet/ct.t.json.output
> > @@ -5,7 +5,6 @@
> >              "left": {
> >                  "ct": {
> >                      "dir": "original",
> > -                    "family": "ip",
> >                      "key": "saddr"
> 
> Should that be "ip saddr"?
> Or is a plain "saddr" without family now implicitly ipv4?

In this patch, the old way (NFT_CT_SRC) still works via dependency:

# meta nfproto ipv4 ct original saddr 1.2.3.4

If someone with kernel < 4.17 needs to match on ct address, it can
still use it this way.

set, map and concatenations are broken anyway, so I would just expect
users with simple rules that refer to something like this.
