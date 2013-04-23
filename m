From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [Nftables RFC] High level library proposal
Date: Tue, 23 Apr 2013 13:31:13 +0200
Message-ID: <20130423113112.GB3348@localhost>
References: <516EA684.9040209@linux.intel.com>
 <20130419100531.GA3481@localhost>
 <517129D8.8000006@linux.intel.com>
 <20130419121127.GA29452@localhost>
 <1366671791.15660.36.camel@tiger2>
 <20130422235012.GA4875@localhost>
 <51765F2E.9000909@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Leblond <eric@regit.org>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>,
	Patrick McHardy <kaber@trash.net>,
	Julien Vehent <julien@linuxwall.info>
To: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35132 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755256Ab3DWLbX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 23 Apr 2013 07:31:23 -0400
Content-Disposition: inline
In-Reply-To: <51765F2E.9000909@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Apr 23, 2013 at 01:15:10PM +0300, Tomasz Bursztyka wrote:
> Hi Eric and Pablo,
> >>>I don't get why you may need something different than libmnl or libnl.
> >>
> >>I don't think Tomasz need it but future application developers will
> >>really love to avoid to learn how netlink messages are build.
> 
> I actually need this flexibility. But indeed, it's thought to hide
> netlink IOs anyway.
[...]
> >I was referring to the driver switch that he wants to introduce to
> >select libnl or libmnl in runtime, it makes no sense to me.
> 
> It's easy to support it.
[...]

Again, you say you need this driver thing, but you will not escape
without explaining me why you need this.

Regards.
