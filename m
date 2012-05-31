From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] conntrackd: resolve a compiler error
Date: Thu, 31 May 2012 15:19:45 +0200
Message-ID: <20120531131945.GA961@1984>
References: <1338465797-9797-1-git-send-email-jengelh@inai.de>
 <1338465797-9797-2-git-send-email-jengelh@inai.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48697 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757948Ab2EaNTu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 31 May 2012 09:19:50 -0400
Content-Disposition: inline
In-Reply-To: <1338465797-9797-2-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Jan,

On Thu, May 31, 2012 at 02:03:17PM +0200, Jan Engelhardt wrote:
> Observed with gcc-4.7/glibc-2.15 and conntrack-tools-1.2.1:
> 
>   CC     parse.o
> parse.c: In function 'msg2ct':
> parse.c:258:34: error: 'NULL' undeclared (first use in this function)
> parse.c:258:34: note: each undeclared identifier is reported only once for each function it appears in
> parse.c: In function 'msg2exp':
> parse.c:438:16: error: 'NULL' undeclared (first use in this function)

Similar patch was already applied.

http://git.netfilter.org/cgi-bin/gitweb.cgi?p=conntrack-tools.git;a=commit;h=d44489648c1a56d543a84bbebe455227bb25cf34

This was spotted a couple of days ago by Mandriva people.

Thanks anyway!
