From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [RFC nft PATCH] tests: shell: add a basic scapy test
Date: Thu, 1 Dec 2016 11:45:35 +0100
Message-ID: <20161201104535.GA13152@salvia>
References: <148049874652.26121.17744801893432354214.stgit@nfdev2.cica.es>
 <20161130182704.GA7892@salvia>
 <20161130182801.GB7892@salvia>
 <CAOkSjBibmjB6Uo2z9Wx1+tfkpO=eY1vY2_79qXN+TEB_tvPcEA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>,
        Shivani Bhardwaj <shivanib134@gmail.com>
To: Arturo Borrero Gonzalez <arturo@debian.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45770 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751148AbcLAKps (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 1 Dec 2016 05:45:48 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 40411E34D0
        for <netfilter-devel@vger.kernel.org>; Thu,  1 Dec 2016 11:45:44 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2D9F2A0FD3
        for <netfilter-devel@vger.kernel.org>; Thu,  1 Dec 2016 11:45:44 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 220EBA0FD4
        for <netfilter-devel@vger.kernel.org>; Thu,  1 Dec 2016 11:45:40 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <CAOkSjBibmjB6Uo2z9Wx1+tfkpO=eY1vY2_79qXN+TEB_tvPcEA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Dec 01, 2016 at 09:10:53AM +0100, Arturo Borrero Gonzalez wrote:
> On 30 November 2016 at 19:28, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> >> * You can probably augment this at some pointer to rely on the new
> >>   nf_tables tracing infrastructure.
> >>
> 
> That would be rather complex.

OK, let's start with this something simple.

> > Only one more question left: Do you think you can slightly generalize
> > this so we decouple test files from the script? Similar to what we
> > have for nft-tests.py.
> 
> What do you mean?
> 
> This testcase script is decoupled enough that you can even call it
> this way (and it works):
> 
>  % NFT=%(which nft) testcases/scapy/0001_ip_ttl_0
> 
> Do you mean you would like to have a different testsuite (with a
> different runner script) for these datapath tests?

I mean, it would be good if you place as much common code as possible
in the runner script, so individual unit tests don't result in too
much copy and paste.

Thanks Arturo.
