Return-Path: <SRS0=QRwA=YQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D359BCA9EB9
	for <netfilter-devel@archiver.kernel.org>; Wed, 23 Oct 2019 20:55:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AE04220650
	for <netfilter-devel@archiver.kernel.org>; Wed, 23 Oct 2019 20:55:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391802AbfJWUzo (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 23 Oct 2019 16:55:44 -0400
Received: from correo.us.es ([193.147.175.20]:45368 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390466AbfJWUzo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 23 Oct 2019 16:55:44 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 93BDDC4807
        for <netfilter-devel@vger.kernel.org>; Wed, 23 Oct 2019 22:55:39 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 820D0CA0F3
        for <netfilter-devel@vger.kernel.org>; Wed, 23 Oct 2019 22:55:39 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 77832CA0F2; Wed, 23 Oct 2019 22:55:39 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 50256B7FF2
        for <netfilter-devel@vger.kernel.org>; Wed, 23 Oct 2019 22:55:37 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 23 Oct 2019 22:55:37 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 2CD9241E4801
        for <netfilter-devel@vger.kernel.org>; Wed, 23 Oct 2019 22:55:37 +0200 (CEST)
Date:   Wed, 23 Oct 2019 22:55:39 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH libnfnetlink 1/1] src: Minimally resurrect doxygen
 documentation
Message-ID: <20191023205539.yh5m73brkkovxrhr@salvia>
References: <20191014020223.21757-1-duncan_roe@optusnet.com.au>
 <20191014020223.21757-2-duncan_roe@optusnet.com.au>
 <20191023111346.4xoujsy6h2j7cv6y@salvia>
 <20191023151205.GA5848@dimstar.local.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191023151205.GA5848@dimstar.local.net>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Oct 24, 2019 at 02:12:05AM +1100, Duncan Roe wrote:
> On Wed, Oct 23, 2019 at 01:13:46PM +0200, Pablo Neira Ayuso wrote:
> > On Mon, Oct 14, 2019 at 01:02:23PM +1100, Duncan Roe wrote:
> > > The documentation was written in the days before doxygen required groups or even
> > > doxygen.cfg, so create doxygen.cfg.in and introduce one \defgroup per source
> > > file, encompassing pretty-much the whole file.
> > >
> > > Also add a tiny \mainpage.
> > >
> > > Added:
> > >
> > >  doxygen.cfg.in: Same as for libmnl except FILE_PATTERNS = *.c linux_list.h
> > >
> > > Updated:
> > >
> > >  configure.ac: Create doxygen.cfg
> > >
> > >  include/linux_list.h: Add defgroup
> > >
> > >  src/iftable.c: Add defgroup
> > >
> > >  src/libnfnetlink.c: Add mainpage and defgroup
> >
> > I'm ambivalent about this, it's been up on the table for a while.
> >
> > This library is rather old, and new applications should probably
> > be based instead used libmnl, which is a better choice.
> >
> > Did you already queue patches to make documentation for libnfnetlink
> > locally there? I would like not to discourage you in your efforts to
> > help us improve documentation, which is always extremely useful for
> > everyone.
> >
> > Let me know, thanks.
> 
> Very timely of you to ask.
> 
> Just this morning I was going to get back into libnetfilter_queue documentation,
> starting with the other 2 verdict helpers.
> 
> But I ran into a conundrum with nfq_nlmsg_verdict_put_mark (the one I didn't
> use). It's a 1-liner (in src/nlmsg.c):
> 
> > 56  mnl_attr_put_u32(nlh, NFQA_MARK, htonl(mark));
> 
> But examples/nf-queue.c has an example to set the connmark which doesn't use
> nfq_nlmsg_verdict_put_mark()
> 
> Instead it has this line:
> 
> > 52  mnl_attr_put_u32(nlh, CTA_MARK, htonl(42));
> 
> The trouble is, NFQA_MARK *is different from* CTA_MARK. NFQA_MARK is 3, while
> CTA_MARK is 8.
> 
> At this point, I felt I did not understand the software well enough to be able
> to document it further. If you could shed some light on this apparent
> disrcepancy, it might restore my self-confidence sufficiently that I can
> continue documenting.

The idea is that the new libnetfilter_queue API provides a set of
helpers for libmnl. Hence, you have access to the netlink socket API
and you use the helpers to build the netlink message.

The netlink sockets allows you to communicate userspace with the
corresponding kernel subsystem. The message you send to the kernel is
composed of two headers, one is the struct nlmsghdr (netlink header)
and then it follows the nfnl header. The payload of the netlink
message is composite of Type-Length-Value (TLV) attributes.

Therefore:

        mnl_attr_put_u32(nlh, CTA_MARK, htonl(42));

is adding the TLV that represents the conntrack mark.

The value is in network-byte-order for historical reasons, there were
an original effort to place netlink message on the network wire, but
at the end of the day this was not used in practise.

So the new libnetfilter_queue API is more low-level, in the sense that
you have more control on netlink aspects, such as the socket
initialization and the message building / parsing.
