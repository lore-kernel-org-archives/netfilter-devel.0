From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftables PATCH v3] src: xml: add versioning
Date: Thu, 6 Jun 2013 12:15:55 +0200
Message-ID: <20130606101555.GA7808@localhost>
References: <20130603155815.19094.29178.stgit@nfdev.cica.es>
 <20130605033009.GA24974@localhost>
 <CAOkSjBhqT2Mn2a5CjtKRc3qf2_S4uhO-3q5cucK8kLumT1UBuQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36665 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751473Ab3FFKQA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 6 Jun 2013 06:16:00 -0400
Content-Disposition: inline
In-Reply-To: <CAOkSjBhqT2Mn2a5CjtKRc3qf2_S4uhO-3q5cucK8kLumT1UBuQ@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jun 05, 2013 at 01:06:10PM +0200, Arturo Borrero Gonzalez wrote:
> 2013/6/5 Pablo Neira Ayuso <pablo@netfilter.org>:
> > On Mon, Jun 03, 2013 at 05:58:38PM +0200, Arturo Borrero wrote:
> >> All XML chunks now have a "version" attribute to help in future changes.
> >
> > Not sure this is the best approach after reading this:
> >
> > http://stackoverflow.com/questions/2014237/what-are-the-best-practices-for-versioning-xml-schemas
> >
> > Can you give it some read and get back to me with more feedback
> > regarding the XML versioning approaches?
> >
> 
> The version attribute could be add to the top level element (e.g.
> <nftables> in the ruleset dump example I sent).
> A drawback of this is that the version cannot be checked when parsing
> loose/single elements.

Fair enough. Applied, thanks.
