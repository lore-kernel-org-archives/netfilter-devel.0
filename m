From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH -stable,4.x.y] netfilter: nf_nat_redirect: add missing
 NULL pointer check
Date: Mon, 18 Jan 2016 20:47:18 +0100
Message-ID: <20160118194718.GA2067@salvia>
References: <1446813886-5632-1-git-send-email-pablo@netfilter.org>
 <20151106170858.GB24185@kroah.com>
 <20151106172610.GA1357@salvia>
 <569D3C91.7040409@amazon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Greg KH <gregkh@linuxfoundation.org>,
	netfilter-devel@vger.kernel.org, stable@vger.kernel.org
To: Munehisa Kamata <kamatam@amazon.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43681 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755533AbcARTrc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 18 Jan 2016 14:47:32 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 76D0D3066AB
	for <netfilter-devel@vger.kernel.org>; Mon, 18 Jan 2016 20:47:30 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 63A0FDA811
	for <netfilter-devel@vger.kernel.org>; Mon, 18 Jan 2016 20:47:30 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 4552DDA808
	for <netfilter-devel@vger.kernel.org>; Mon, 18 Jan 2016 20:47:27 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <569D3C91.7040409@amazon.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jan 18, 2016 at 11:27:13AM -0800, Munehisa Kamata wrote:
> Hi Greg,
> 
> This commit is already in Linus's tree. Could you please pick this up for 4.1.y?

I submitted this twice... Last time I made it was this one:

http://patchwork.ozlabs.org/patch/544964/

Previous was rejected because it was not in Linus tree:

http://patchwork.ozlabs.org/patch/540946/

But the last attempt got no feedback...

> On 11/6/2015 9:26 AM, Pablo Neira Ayuso wrote:
> > On Fri, Nov 06, 2015 at 09:08:58AM -0800, Greg KH wrote:
> >> On Fri, Nov 06, 2015 at 01:44:43PM +0100, Pablo Neira Ayuso wrote:
> >>> From: Munehisa Kamata <kamatam@amazon.com>
> >>>
> >>> [ upstream commit 94f9cd81436c85d8c3a318ba92e236ede73752fc ]
> >>
> >> This isn't a valid git commit id in Linus's tree :(
> > 
> > This is David's tree already:
> > 
> > http://git.kernel.org/cgit/linux/kernel/git/davem/net.git/commit/?id=94f9cd81436c85d8c3a318ba92e236ede73752fc
> > 
> > So this should hit Linus tree soon.
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
