From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: libiptc: fix retry path in TC_INIT
Date: Thu, 19 Apr 2012 18:55:42 +0200
Message-ID: <20120419165542.GA17540@1984>
References: <1334651363.10712.6.camel@mgo-thinkpad>
 <20120418231242.GB12354@1984>
 <1334830473.25428.2.camel@mgo-thinkpad>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Miguel GAIO <miguel.gaio@efixo.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54397 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755647Ab2DSQ4A (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Apr 2012 12:56:00 -0400
Content-Disposition: inline
In-Reply-To: <1334830473.25428.2.camel@mgo-thinkpad>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Apr 19, 2012 at 12:14:33PM +0200, Miguel GAIO wrote:
> On Thu, 2012-04-19 at 01:12 +0200, Pablo Neira Ayuso wrote:
[...]
> > 
> > Still iptc_fn is set to TC_FREE. We have to move up to the beginning
> > of TC_INIT.
> 
> Your right, I miss it.
> I resend patch with the retry at the beginning of TC_INIT.

Applied, Thanks Miguel.
