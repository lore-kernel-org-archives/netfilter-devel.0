From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH libnftnl] rule: Fix comparison between rules
Date: Thu, 18 Aug 2016 18:17:09 +0200
Message-ID: <20160818161709.GA1268@salvia>
References: <20160818151236.19924-1-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org
To: Carlos Falgueras =?iso-8859-1?Q?Garc=EDa?= <carlosfg@riseup.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:43244 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752314AbcHSCrm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 18 Aug 2016 22:47:42 -0400
Content-Disposition: inline
In-Reply-To: <20160818151236.19924-1-carlosfg@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Aug 18, 2016 at 05:12:36PM +0200, Carlos Falgueras García wrote:
> Before this patch, comparison between rules with distinct number of
> expressions can returns that they are equals when they are not. Example:
> 
> 	r1[e1, e2] == r2[e1, e2, e3]

Applied.

I have mangled patch title to specify a bit more the bug type.

And simplified the code. Remove the comment as 'git annotate' provides
this information already.
