From: Max Kellermann <max@duempel.org>
Subject: Re: [PATCH 1/4] check nfct_get_attr()!=NULL
Date: Mon, 21 Jan 2008 13:58:24 +0100
Message-ID: <20080121125824.GA29741@swift.blarg.de>
References: <20080121082752.27612.82519.stgit@rabbit.intern.cm-ag> <20080121082958.27612.50164.stgit@rabbit.intern.cm-ag> <479495C7.2010903@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from duempel.org ([78.31.71.42]:40604 "HELO duempel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750939AbYAUM60 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 21 Jan 2008 07:58:26 -0500
Content-Disposition: inline
In-Reply-To: <479495C7.2010903@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 2008/01/21 13:53, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Max Kellermann wrote:
> > from time to time, conntrackd segfaults in cache.c, function hash(),
> > because it does not check the return value of nfct_get_attr().  For
> > some reason (which I have not investigated), there is no
> > ATTR_ORIG_IPV4_SRC.  A gdb dump of *ct after the segfault says the
> > following:
> 
> I cannot reproduce this problem in my testbed. Are you running
> conntrackd with IPv6 connections?

This machine uses IPv6 and IPv6 CT.  I have no idea what conntrackd
does with these.

Max

