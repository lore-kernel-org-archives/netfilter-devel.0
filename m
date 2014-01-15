From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftables PATCH] tests: xml: delete comments
Date: Wed, 15 Jan 2014 17:43:39 +0100
Message-ID: <20140115164339.GA32508@localhost>
References: <20140115111218.25584.60794.stgit@nfdev.cica.es>
 <20140115131214.GA22148@localhost>
 <CAOkSjBjTZv0jHzPG6MPYVQU=amvGntwq1qe8FY47O704mFs5fA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41120 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752458AbaAOQno (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Jan 2014 11:43:44 -0500
Content-Disposition: inline
In-Reply-To: <CAOkSjBjTZv0jHzPG6MPYVQU=amvGntwq1qe8FY47O704mFs5fA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jan 15, 2014 at 05:00:20PM +0100, Arturo Borrero Gonzalez wrote:
> On 15 January 2014 14:12, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Wed, Jan 15, 2014 at 12:12:18PM +0100, Arturo Borrero Gonzalez wrote:
> >> In libmxml > 2.6, comments are not ignored when building the XML tree,
> >> so these comments produce errors and test fail.
> >
> > Doesn't have libmxml any way to accept comments?
> 
> I explained it bad, i'm sorry.
> 
> When building a XML tree, only one root node can be in place. This is
> a "feature" added in libmxml 2.7:
> 
> <<<
> mxmlLoad... did not error out on XML with multiple root nodes (Bug #403)
> >>>
> 
> In libmxml 2.6 the second root node was ingored, not because it was a
> comment but because a bug.
> Our files had two root nodes, being comments or not.
> libmxml accept comments, but inside the root node.

That makes sense, I have applied the patch and included this
description. Thanks.
