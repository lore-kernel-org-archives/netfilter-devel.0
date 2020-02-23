Return-Path: <SRS0=J2Vc=4L=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49C0EC35671
	for <netfilter-devel@archiver.kernel.org>; Sun, 23 Feb 2020 22:35:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2524920675
	for <netfilter-devel@archiver.kernel.org>; Sun, 23 Feb 2020 22:35:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727064AbgBWWfR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 23 Feb 2020 17:35:17 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:45776 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726302AbgBWWfR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 23 Feb 2020 17:35:17 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1j5zqE-0004Fy-Gx; Sun, 23 Feb 2020 23:35:14 +0100
Date:   Sun, 23 Feb 2020 23:35:14 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Duncan Roe <duncan_roe@optusnet.com.au>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH libnetfilter_queue] build: doc: "make" builds & installs
 a full set of man pages
Message-ID: <20200223223514.GA19559@breakpoint.cc>
References: <20200208012844.30481-1-duncan_roe@optusnet.com.au>
 <20200223222733.rc4mhtvxgxiihlij@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200223222733.rc4mhtvxgxiihlij@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Sat, Feb 08, 2020 at 12:28:44PM +1100, Duncan Roe wrote:
> > This enables one to enter "man <any nfq function>" and get the appropriate
> > group man page created by doxygen.
> > 
> >  - New makefile in doxygen directory. Rebuilds documentation if any sources
> >    change that contain doxygen comments, or if fixmanpages.sh changes
> >  - New shell script fixmanpages.sh which
> >    - Renames each group man page to the first function listed therein
> >    - Creates symlinks for subsequently listed functions (if any)
> >    - Deletes _* temp files
> >  - Update top-level makefile to visit new subdir doxygen
> >  - Update top-level configure to only build documentation if doxygen installed
> 
> I'd prefer people to keep this infrastructure out of tree. Thanks.

Hmm, why?
