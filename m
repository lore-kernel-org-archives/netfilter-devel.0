From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/3] build: rename conflicting parser.h instances
Date: Wed, 20 Nov 2013 15:02:06 +0100
Message-ID: <20131120140206.GA7599@localhost>
References: <1382280491-9921-1-git-send-email-jengelh@inai.de>
 <1382280491-9921-3-git-send-email-jengelh@inai.de>
 <20131119202534.GB4929@localhost>
 <alpine.LSU.2.11.1311201002440.24243@nerf07.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42118 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751585Ab3KTOCP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 20 Nov 2013 09:02:15 -0500
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.11.1311201002440.24243@nerf07.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Nov 20, 2013 at 10:06:39AM +0100, Jan Engelhardt wrote:
> On Tuesday 2013-11-19 21:25, Pablo Neira Ayuso wrote:
> 
> >On Sun, Oct 20, 2013 at 04:48:10PM +0200, Jan Engelhardt wrote:
> >> If -I. is on the command line, #include <parser.h> becomes ./parser.h
> >> instead of ../include/parser.h.
> >
> >What use case are you trying to handle with this?
> >
> automake adds -I${builddir} -I${srcdir} and -I{dir with config.h} to the 
> command line. Because both ${builddir} and -I${top_srcdir}/include 
> (which is also being passed, this time by Makefile.am), #include 
> <parser.h> becomes sort of ambiguous (the compiler knows which one to 
> pick, but it's not the one to success).

OK, then you need this patch to get patch 3/3 working, since automake
it currently not used. That was unclear in the patch description.
