From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: kernel 4.5.1 issue at system boot
Date: Mon, 30 May 2016 19:22:13 +0200
Message-ID: <20160530172213.GA1349@salvia>
References: <CAOkSjBh-P0RNKhNeR8fBmRVda7mtU9332punaUufO4Rx3aqpqA@mail.gmail.com>
 <CAOkSjBh--Ro9YzOdsTQsK6F73kPMdihjfU-tbyHc9gYN4gjOYA@mail.gmail.com>
 <20160523100811.GA9385@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36948 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161249AbcE3RWS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 May 2016 13:22:18 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 6837A1B5CA7
	for <netfilter-devel@vger.kernel.org>; Mon, 30 May 2016 19:22:16 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 5A0961B3264
	for <netfilter-devel@vger.kernel.org>; Mon, 30 May 2016 19:22:16 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 043F01B3260
	for <netfilter-devel@vger.kernel.org>; Mon, 30 May 2016 19:22:14 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160523100811.GA9385@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, May 23, 2016 at 12:08:11PM +0200, Florian Westphal wrote:
> Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com> wrote:
> > On 23 May 2016 at 08:49, Arturo Borrero Gonzalez
> > <arturo.borrero.glez@gmail.com> wrote:
> > > This was in the log of my system boot today:
> > >
> > 
> > Probably more readable in this link:
> > 
> > http://paste.debian.net/695904/
> 
> This looks like an ABBA-style deadlock of
> net_mutex and nfnl_lock(NFNL_SUBSYS_NFTABLES).

@Arturo: Could you enable CONFIG_LOCKDEP and CONFIG_DEBUG_MUTEXES?
this instrumention should provide a bit more information on the locks
that are involved in the deadlock.

Thanks.
