From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft 0/9] tests: Move tests from files to shell.
Date: Tue, 17 Oct 2017 13:08:10 +0200
Message-ID: <20171017110810.GA24278@salvia>
References: <cover.1507696149.git.rvarsha016@gmail.com>
 <20171011095708.GB1678@salvia>
 <CAAFX7JTjwwp+pCLW6MtD6nVuq7wA4-EZVssGvEO3QOkxBnXNOQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Varsha Rao <rvarsha016@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48994 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758963AbdJQLIS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 Oct 2017 07:08:18 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 68227249C3
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Oct 2017 13:08:17 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 57FCCDA874
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Oct 2017 13:08:17 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <CAAFX7JTjwwp+pCLW6MtD6nVuq7wA4-EZVssGvEO3QOkxBnXNOQ@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Oct 14, 2017 at 06:34:28PM +0530, Varsha Rao wrote:
> Hello Pablo,
> 
> On Wed, Oct 11, 2017 at 3:27 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > Hi Varsha,
> >
> > On Wed, Oct 11, 2017 at 10:03:56AM +0530, Varsha Rao wrote:
> >> Test files of tests/files/ are moved to tests/shell.
> >
> > We have more than 100 tests these days, could you have a look at the
> > repository to see if this is adding redundant tests for what we have?
> > If we already have a test covering the same configuration, we should
> > just remove them from tests/files/.
> >
> Sorry, the cover letter title and commit message looks misleading.
> But I have removed the redundant ones and added tests which were
> not there.

Thanks for clarifying, I have applied this.
