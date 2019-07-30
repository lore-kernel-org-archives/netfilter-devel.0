Return-Path: <SRS0=FCuH=V3=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52B49C433FF
	for <netfilter-devel@archiver.kernel.org>; Tue, 30 Jul 2019 14:48:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2D8CD206E0
	for <netfilter-devel@archiver.kernel.org>; Tue, 30 Jul 2019 14:48:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731487AbfG3OsQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 30 Jul 2019 10:48:16 -0400
Received: from correo.us.es ([193.147.175.20]:60810 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731560AbfG3OsQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 30 Jul 2019 10:48:16 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 04F9811F129
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Jul 2019 16:48:14 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EA304D190F
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Jul 2019 16:48:13 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id DF41EDA732; Tue, 30 Jul 2019 16:48:13 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C500F1150CB;
        Tue, 30 Jul 2019 16:48:11 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 30 Jul 2019 16:48:11 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [47.60.32.83])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 698CB4265A2F;
        Tue, 30 Jul 2019 16:48:11 +0200 (CEST)
Date:   Tue, 30 Jul 2019 16:48:09 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, bmastbergen@untangle.com
Subject: Re: [PATCH nft,RFC,PoC 2/2] src: restore typeof datatype when
 listing set definition
Message-ID: <20190730144809.trhyxhhhxegoe47s@salvia>
References: <20190730141620.2129-1-pablo@netfilter.org>
 <20190730141620.2129-3-pablo@netfilter.org>
 <20190730144141.k3dn37nlychhjk46@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190730144141.k3dn37nlychhjk46@breakpoint.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Jul 30, 2019 at 04:41:41PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > This is a proof-of-concept.
> > 
> > The idea behind this patch is to store the typeof definition
> > so it can be restored when listing it back.
> > 
> > Better way to do this would be to store the typeof expression
> > definition in a way that the set->key expression can be rebuilt.
> 
> Maybe we can store the raw netlink data that makes up the expression
> in the tlv area?

That's another possibility to explore.

> That would probably allow more code reuse to get back the "proper"
> type.

Just make sure there's sufficient context around to rebuild the
expression. Think of more complex fields that require bitmask
operations.

> One problem with my patch is that while you can add a map that
> returns "osf name", I could not find a way to easily re-lookup
> a suitable expression.  Storing a string would work of course,
> but I don't like it because we have no way to revalidate this.

I'm not advocating for storing the string. This was just a quick PoC
given the discussions after NFWS, and I wasn't sure everyone was on
the same page after it.

I agree with you in that the string is not the way to go.

> If we can reuse libnftnl/libmnl to have the basic netlink validation
> run on the blob we can at least be sure that its not complete garbage
> before we attempt to interpret the blob.

Please, go ahead explore that possibility. I'd try with payload
expressions, which are the most complex one. For thing like meta, it
should be simple to follow the approach you describe. Thanks.
