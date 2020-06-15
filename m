Return-Path: <SRS0=VCDi=74=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38B1BC433E0
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Jun 2020 13:48:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 136A92078E
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Jun 2020 13:48:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730144AbgFONsK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 15 Jun 2020 09:48:10 -0400
Received: from verein.lst.de ([213.95.11.211]:33536 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729243AbgFONsJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 15 Jun 2020 09:48:09 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 8076068BFE; Mon, 15 Jun 2020 15:48:05 +0200 (CEST)
Date:   Mon, 15 Jun 2020 15:48:04 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Christoph Hellwig <hch@lst.de>, Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ian Kent <raven@themaw.net>,
        David Howells <dhowells@redhat.com>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH 05/13] fs: check FMODE_WRITE in __kernel_write
Message-ID: <20200615134804.GA11061@lst.de>
References: <20200615121257.798894-1-hch@lst.de> <20200615121257.798894-6-hch@lst.de> <20200615123439.GT8681@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200615123439.GT8681@bombadil.infradead.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Jun 15, 2020 at 05:34:39AM -0700, Matthew Wilcox wrote:
> On Mon, Jun 15, 2020 at 02:12:49PM +0200, Christoph Hellwig wrote:
> > We still need to check if the fѕ is open write, even for the low-level
> > helper.
> 
> Do we need the analogous check for FMODE_READ in the __kernel_read()
> patch?

Yes, we should probably grow it.  Hoping that none of the caller
actually wants to mess with files not open for reading as some of them
are rather dodgy.
