Return-Path: <SRS0=VCDi=74=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1D3EC433E0
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Jun 2020 16:42:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B8C8C2078A
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Jun 2020 16:42:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731112AbgFOQmW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 15 Jun 2020 12:42:22 -0400
Received: from verein.lst.de ([213.95.11.211]:34321 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730596AbgFOQmW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 15 Jun 2020 12:42:22 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id CE3AA68C4E; Mon, 15 Jun 2020 18:42:19 +0200 (CEST)
Date:   Mon, 15 Jun 2020 18:42:18 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Christoph Hellwig <hch@lst.de>, Al Viro <viro@zeniv.linux.org.uk>,
        Ian Kent <raven@themaw.net>,
        David Howells <dhowells@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        NetFilter <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH 05/13] fs: check FMODE_WRITE in __kernel_write
Message-ID: <20200615164218.GB23493@lst.de>
References: <20200615121257.798894-1-hch@lst.de> <20200615121257.798894-6-hch@lst.de> <CAHk-=whfMo7gvco8N5qEjh+jSqezv+bd+N-7txpNokD39t=dhQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHk-=whfMo7gvco8N5qEjh+jSqezv+bd+N-7txpNokD39t=dhQ@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Jun 15, 2020 at 09:39:31AM -0700, Linus Torvalds wrote:
> On Mon, Jun 15, 2020 at 5:13 AM Christoph Hellwig <hch@lst.de> wrote:
> >
> > We still need to check if the fѕ is open write, even for the low-level
> > helper.
> 
> Is there actually a way to trigger something like this? I'm wondering
> if it's worth a WARN_ON_ONCE()?
> 
> It doesn't sound sensible to have some kernel functionality try to
> write to a file it didn't open for write, and sounds like a kernel bug
> if this case were to ever trigger..

Yes, this would be bug in the calling code.
