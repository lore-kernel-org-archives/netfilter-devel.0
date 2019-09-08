Return-Path: <SRS0=xcdV=XD=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 161BDC433EF
	for <netfilter-devel@archiver.kernel.org>; Sun,  8 Sep 2019 18:14:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E4B12216C8
	for <netfilter-devel@archiver.kernel.org>; Sun,  8 Sep 2019 18:14:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730561AbfIHSOK convert rfc822-to-8bit (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 8 Sep 2019 14:14:10 -0400
Received: from correo.us.es ([193.147.175.20]:40720 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726535AbfIHSOK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 8 Sep 2019 14:14:10 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 4FE63DA722
        for <netfilter-devel@vger.kernel.org>; Sun,  8 Sep 2019 20:14:06 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 401C7DA72F
        for <netfilter-devel@vger.kernel.org>; Sun,  8 Sep 2019 20:14:06 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 3570DDA801; Sun,  8 Sep 2019 20:14:06 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 39005DA72F;
        Sun,  8 Sep 2019 20:14:04 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sun, 08 Sep 2019 20:14:04 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 19C124265A5A;
        Sun,  8 Sep 2019 20:14:04 +0200 (CEST)
Date:   Sun, 8 Sep 2019 20:14:05 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nf-next v2 00/30] Add config option checks to netfilter
 headers.
Message-ID: <20190908181405.uaxxh2nzjgkrvmnt@salvia>
References: <20190902230650.14621-1-jeremy@azazel.net>
 <20190904190535.7dslwytvpff567mt@salvia>
 <20190907191658.GA6508@azazel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20190907191658.GA6508@azazel.net>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, Sep 07, 2019 at 08:16:59PM +0100, Jeremy Sowden wrote:
> On 2019-09-04, at 21:05:35 +0200, Pablo Neira Ayuso wrote:
[...]
> > * 17/30 I don't think struct nf_bridge_frag_data qualifies for the
> >   global netfilter.h header.
> 
> What about netfilter_bridge.h?

That's fine indeed.

[...]
> As I mentioned in the cover-letter the idea behind my approach was to
> config out as much code as possible: if header H is only required when
> config C is enabled, then wrap it in an `#if IS_ENABLED(CONFIG_C)`.
> However, you're clearly not keen, and, having had a poke around in other
> headers that have been moved off the blacklist, I've come to the con-
> clusion that it was the wrong way to go: we want less #ifdeffery, not
> more.  Will rework this part of the series.

It would be great if all those are #if IS_ENABLED(CONFIG_C) only to
make happy CONFIG_HEADER_TEST go away, and no more new ones are added
indeed.

Thanks.
