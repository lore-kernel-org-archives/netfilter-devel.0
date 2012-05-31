From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH] conntrackd: resolve a compiler error
Date: Thu, 31 May 2012 15:31:14 +0200
Message-ID: <20120531133114.GA10522@breakpoint.cc>
References: <1338465797-9797-1-git-send-email-jengelh@inai.de>
 <1338465797-9797-2-git-send-email-jengelh@inai.de>
 <20120531131945.GA961@1984>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Engelhardt <jengelh@inai.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:42867 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758111Ab2EaNbf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 31 May 2012 09:31:35 -0400
Content-Disposition: inline
In-Reply-To: <20120531131945.GA961@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Hi Jan,
> 
> On Thu, May 31, 2012 at 02:03:17PM +0200, Jan Engelhardt wrote:
> > Observed with gcc-4.7/glibc-2.15 and conntrack-tools-1.2.1:
> > 
> >   CC     parse.o
> > parse.c: In function 'msg2ct':
> > parse.c:258:34: error: 'NULL' undeclared (first use in this function)
> > parse.c:258:34: note: each undeclared identifier is reported only once for each function it appears in
> > parse.c: In function 'msg2exp':
> > parse.c:438:16: error: 'NULL' undeclared (first use in this function)
> 
> Similar patch was already applied.
> 
> http://git.netfilter.org/cgi-bin/gitweb.cgi?p=conntrack-tools.git;a=commit;h=d44489648c1a56d543a84bbebe455227bb25cf34

NULL is defined in stddef.h, stdlib.h does not necessarily pull that
header in, too.

Jan, does conntrackd build when you replace the stdlib.h include with
stddef.h?
