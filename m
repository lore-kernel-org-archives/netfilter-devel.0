Return-Path: <SRS0=3WFO=VT=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C776C7618F
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Jul 2019 19:23:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 595E72190D
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Jul 2019 19:23:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726896AbfGVTXc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 22 Jul 2019 15:23:32 -0400
Received: from mail.us.es ([193.147.175.20]:52708 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726710AbfGVTXc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 22 Jul 2019 15:23:32 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 3755881405
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Jul 2019 21:23:29 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 27DF4CE158
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Jul 2019 21:23:29 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 1D62BD1911; Mon, 22 Jul 2019 21:23:29 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F18BDDA732;
        Mon, 22 Jul 2019 21:23:26 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 22 Jul 2019 21:23:26 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [31.4.183.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 804614265A31;
        Mon, 22 Jul 2019 21:23:26 +0200 (CEST)
Date:   Mon, 22 Jul 2019 21:23:23 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>, Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] doc: fib: explain example in more detail
Message-ID: <20190722192323.aycmplb3xd47iccd@salvia>
References: <20190721104305.29594-1-fw@strlen.de>
 <20190721184212.2fxviqkcil27wzqp@salvia>
 <20190721185432.o2wke7wecfdbyzfr@breakpoint.cc>
 <20190722115756.GH22661@orbyte.nwl.cc>
 <20190722121747.32ve2o3e7luxtwnq@breakpoint.cc>
 <20190722125246.GJ22661@orbyte.nwl.cc>
 <20190722125633.7pgm3glloutr4esj@breakpoint.cc>
 <20190722130259.GK22661@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190722130259.GK22661@orbyte.nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Jul 22, 2019 at 03:02:59PM +0200, Phil Sutter wrote:
> On Mon, Jul 22, 2019 at 02:56:33PM +0200, Florian Westphal wrote:
> > Phil Sutter <phil@nwl.cc> wrote:
> > > On Mon, Jul 22, 2019 at 02:17:47PM +0200, Florian Westphal wrote:
> > > > Phil Sutter <phil@nwl.cc> wrote:
> > > > > use for "no data available" situations. This whole attempt feels a bit
> > > > > futile. Maybe we should introduce something to signal "no value" so that
> > > > > cmp expression will never match for '==' and always for '!='? Not sure
> > > > > how to realize this via registers. Also undecided about '<' and '>' ops.
> > > > 
> > > > Whats the point?
> > > 
> > > IIRC, Pablo's demand for not aborting in nft_meta in case of
> > > insufficient data was to insert a value into dreg which will never
> > > match. I think the idea was to avoid accidental matching in situations
> > > where a match doesn't make sense.
> > 
> > I think the only contraint is that it must not overlap with a
> > legitimate ifindex.
> > 
> > But 0 cannot occur, so 'meta iif 0' will only match in case no input
> > interface existed -- I think thats fine and might even be desired.
> 
> OK, so we just drop my patch to reject ifindex 0 from userspace to keep
> fib working?

I think so, yes.
