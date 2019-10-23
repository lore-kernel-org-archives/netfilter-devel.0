Return-Path: <SRS0=QRwA=YQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFEF5CA9EB9
	for <netfilter-devel@archiver.kernel.org>; Wed, 23 Oct 2019 20:48:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 89F0F20650
	for <netfilter-devel@archiver.kernel.org>; Wed, 23 Oct 2019 20:48:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390466AbfJWUsl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 23 Oct 2019 16:48:41 -0400
Received: from correo.us.es ([193.147.175.20]:43406 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733153AbfJWUsl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 23 Oct 2019 16:48:41 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 71B64E8639
        for <netfilter-devel@vger.kernel.org>; Wed, 23 Oct 2019 22:48:36 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 618B0DA72F
        for <netfilter-devel@vger.kernel.org>; Wed, 23 Oct 2019 22:48:36 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 52CB5B8017; Wed, 23 Oct 2019 22:48:36 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4587CDA7B6
        for <netfilter-devel@vger.kernel.org>; Wed, 23 Oct 2019 22:48:34 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 23 Oct 2019 22:48:34 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 22A6041E480B
        for <netfilter-devel@vger.kernel.org>; Wed, 23 Oct 2019 22:48:34 +0200 (CEST)
Date:   Wed, 23 Oct 2019 22:48:36 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libnfnetlink 1/1] src: Minimally resurrect doxygen
 documentation
Message-ID: <20191023204836.ws4rv55f2dczhq2q@salvia>
References: <20191014020223.21757-1-duncan_roe@optusnet.com.au>
 <20191014020223.21757-2-duncan_roe@optusnet.com.au>
 <20191023111346.4xoujsy6h2j7cv6y@salvia>
 <20191023153142.GB5848@dimstar.local.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191023153142.GB5848@dimstar.local.net>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Oct 24, 2019 at 02:31:42AM +1100, Duncan Roe wrote:
> On Wed, Oct 23, 2019 at 01:13:46PM +0200, Pablo Neira Ayuso wrote:
> > On Mon, Oct 14, 2019 at 01:02:23PM +1100, Duncan Roe wrote:
> > > The documentation was written in the days before doxygen required groups or even
> > > doxygen.cfg, so create doxygen.cfg.in and introduce one \defgroup per source
> > > file, encompassing pretty-much the whole file.
> > >
> [...]
> > >
> >
> > I'm ambivalent about this, it's been up on the table for a while.
> >
> > This library is rather old, and new applications should probably
> > be based instead used libmnl, which is a better choice.
> >
> The thing is, the Deprecated functions in libnetfilter_queue are much better
> documented than the newer functions and that documentation refers to
> libnfnetlink functions.

Would you help me get better the documentation for the new
libnetfilter_queue API? I'll be trying to address your questions
timely in case you decide to enroll in such endeavor.

> So I think that while the deprecated functions are documented, you should really
> have documentation for the old library they use.

Are you refering to libnfnetlink or libnetfilter_queue in this case?
If you insist on documenting libnfnetlink, I'll be fine with it, no
worries.

> BTW, ldd of my app shows libnfnetlink.so although it doesn't use any deprecated
> functions. Is that expected?

Yes, there is still code in the libraries that refer to libnfnetlink.
Replacing some of that code should be feasible via libmnl, it is a
task that has been in my TODO list for long time. There's always
something with more priority in the queue.
