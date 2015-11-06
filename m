From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH -stable,4.x.y] netfilter: nf_nat_redirect: add missing
 NULL pointer check
Date: Fri, 6 Nov 2015 18:26:10 +0100
Message-ID: <20151106172610.GA1357@salvia>
References: <1446813886-5632-1-git-send-email-pablo@netfilter.org>
 <20151106170858.GB24185@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, stable@vger.kernel.org,
	Munehisa Kamata <kamatam@amazon.com>
To: Greg KH <gregkh@linuxfoundation.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37188 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161768AbbKFRSr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 6 Nov 2015 12:18:47 -0500
Content-Disposition: inline
In-Reply-To: <20151106170858.GB24185@kroah.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Nov 06, 2015 at 09:08:58AM -0800, Greg KH wrote:
> On Fri, Nov 06, 2015 at 01:44:43PM +0100, Pablo Neira Ayuso wrote:
> > From: Munehisa Kamata <kamatam@amazon.com>
> > 
> > [ upstream commit 94f9cd81436c85d8c3a318ba92e236ede73752fc ]
> 
> This isn't a valid git commit id in Linus's tree :(

This is David's tree already:

http://git.kernel.org/cgit/linux/kernel/git/davem/net.git/commit/?id=94f9cd81436c85d8c3a318ba92e236ede73752fc

So this should hit Linus tree soon.
