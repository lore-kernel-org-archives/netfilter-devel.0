Return-Path: <SRS0=em6Q=62=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 514CBC54E8B
	for <netfilter-devel@archiver.kernel.org>; Tue, 12 May 2020 12:49:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3BB6B206F5
	for <netfilter-devel@archiver.kernel.org>; Tue, 12 May 2020 12:49:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728283AbgELMty (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 12 May 2020 08:49:54 -0400
Received: from correo.us.es ([193.147.175.20]:45448 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727859AbgELMtx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 12 May 2020 08:49:53 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 3293FF258C
        for <netfilter-devel@vger.kernel.org>; Tue, 12 May 2020 14:49:52 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2269E115410
        for <netfilter-devel@vger.kernel.org>; Tue, 12 May 2020 14:49:52 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 181D611540C; Tue, 12 May 2020 14:49:52 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 147B1115410;
        Tue, 12 May 2020 14:49:50 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 12 May 2020 14:49:50 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id EB5EB42EE38E;
        Tue, 12 May 2020 14:49:49 +0200 (CEST)
Date:   Tue, 12 May 2020 14:49:49 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH 2/2] nfnl_osf: Improve error handling
Message-ID: <20200512124949.GA23943@salvia>
References: <20200509115200.19480-1-phil@nwl.cc>
 <20200509115200.19480-3-phil@nwl.cc>
 <20200509172807.GA12265@salvia>
 <20200511113112.GC17795@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200511113112.GC17795@orbyte.nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, May 11, 2020 at 01:31:12PM +0200, Phil Sutter wrote:
> Hi Pablo,
> 
> On Sat, May 09, 2020 at 07:28:07PM +0200, Pablo Neira Ayuso wrote:
> > On Sat, May 09, 2020 at 01:52:00PM +0200, Phil Sutter wrote:
> > > For some error cases, no log message was created - hence apart from the
> > > return code there was no indication of failing execution.
> > > 
> > > When loading a line fails, don't abort but continue with the remaining
> > > file contents. The current pf.os file in this repository serves as
> > > proof-of-concept: Loading all entries succeeds, but when deleting, lines
> > > 700, 701 and 704 return ENOENT. Not continuing means the remaining
> > > entries are not cleared.
> > 
> > Did you look at why are these lines returning ENOENT?
> 
> If I understand the code right, line 700 is a duplicate of line 698, 701
> of 699 and 704 of 702. This is because 'W*' parses identical to 'W0' and
> in right-hand side only the first three text fields (genre, version and
> subtype) are relevant - the rest is ignored.

I see, in the userspace parser, W0 and W* are being handled as
OSF_WSS_PLAIN.

> When adding, this doesn't become visible because flag NLM_F_EXCL is not
> specified. If it is, kernel returns EEXISTS for those lines.

In the kernel, the struct nf_osf_user_finger is used as key to
identify each line, given they are identical.

So it looks like this EEXIST has been there since the beginning.

This patchset LGTM, it's just that the user might get confused if it
see errors when using this tool, probably turning this into a warning
is fine.

Or at least, include this information in the commit message so this
does not get lost :-)
