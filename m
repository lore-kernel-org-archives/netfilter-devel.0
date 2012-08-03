From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 5/5] nfacct: add timestamp option
Date: Fri, 3 Aug 2012 16:54:00 +0200
Message-ID: <20120803145400.GA1454@1984>
References: <1343856436-11129-1-git-send-email-eric@regit.org>
 <1343856436-11129-6-git-send-email-eric@regit.org>
 <20120803093533.GE12107@1984>
 <1343987038.3284.6.camel@tiger.regit.org>
 <20120803112449.GA19641@1984>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60607 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753052Ab2HCOyF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 3 Aug 2012 10:54:05 -0400
Content-Disposition: inline
In-Reply-To: <20120803112449.GA19641@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Aug 03, 2012 at 01:24:49PM +0200, Pablo Neira Ayuso wrote:
[...]
> I'm still undecided, but it seems to me we provide more fine-grain
> control if timestamp is calculated in the output for the nfacct case.

Well, most input plugins already provide timestamp calculation. GPRINT
seems to be the exception for the output plugin case.

I have applied the patch expanding the documentation on the example
file a bit.

Thanks Eric.
