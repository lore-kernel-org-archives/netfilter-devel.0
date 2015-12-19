From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: nftables symbols
Date: Sat, 19 Dec 2015 18:58:18 +0100
Message-ID: <20151219175818.GA1631@salvia>
References: <CAKHNQQG0AN5OiThvRJTXHOj5OmzO5UHtDqjn-RqbH5thw-EVkg@mail.gmail.com>
 <20151219174822.GC1421@salvia>
 <CAKHNQQFrcS3p=LCbE_ijR839Z_vB5Etr5tM4oRbmuRFvEGdh4w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Shivani Bhardwaj <shivanib134@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55380 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965060AbbLSR6Y (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 19 Dec 2015 12:58:24 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 8128A130FC4
	for <netfilter-devel@vger.kernel.org>; Sat, 19 Dec 2015 18:58:22 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 737CCDA807
	for <netfilter-devel@vger.kernel.org>; Sat, 19 Dec 2015 18:58:22 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id C82B5DA803
	for <netfilter-devel@vger.kernel.org>; Sat, 19 Dec 2015 18:58:19 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <CAKHNQQFrcS3p=LCbE_ijR839Z_vB5Etr5tM4oRbmuRFvEGdh4w@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Dec 19, 2015 at 11:19:08PM +0530, Shivani Bhardwaj wrote:
> On Sat, Dec 19, 2015 at 11:18 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Sat, Dec 19, 2015 at 06:17:15PM +0530, Shivani Bhardwaj wrote:
> >> Hi,
> >>
> >> What is nft symbol for the following?
> >>
> >> on-port
> >> on-ip
> >> tproxy-mark
> >>
> >> I'm doing translations for TPROXY.
> >
> > There is no native support for TPROXY yet.
> 
> So, should I leave this one for now?

Yes, leave this by now.

We have a wiki page to maintain what it is supported natively and what
it is not:

http://wiki.nftables.org/wiki-nftables/index.php/Supported_features_compared_to_xtables

I can create an account for you if you're fine with it so you can help
us maintain it.

Thanks.
