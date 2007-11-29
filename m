From: Jesper Dangaard Brouer <hawk@diku.dk>
Subject: Re: iptables release
Date: Thu, 29 Nov 2007 21:46:49 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0711292044300.8275@ask.diku.dk>
References: <474C4B67.3000200@trash.net> <200711290249.lAT2nkEr004081@toshiba.co.jp>
 <474E640F.4010401@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Netfilter Developers <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mgw2.diku.dk ([130.225.96.92]:39413 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763697AbXK2Uq6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 29 Nov 2007 15:46:58 -0500
In-Reply-To: <474E640F.4010401@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


On Thu, 29 Nov 2007, Patrick McHardy wrote:
>
> It seems it switches the first directory and "trunk". Did you use
> git-svnimport or just git-svn for importing?

I use "git-svn":
  git-svn clone https://svn.netfilter.org/netfilter/ -T trunk -b branches -t tags

And I had to update git to a newer version (1.5.3 than debians 1.4.4) to 
make it work.

Still, I don't think it got the tags and branches right, because 
.git/refs/tags is empty. And it only gets log history back from revision 
3070 (thats where a "new global trunk directory" were created).

When I want to sync with SVN I do:

  git-checkout master
  git-svn fetch
  git-svn rebase

To get one of my work branches up to sync I do a git rebase:

  git-checkout perf_work1
  git rebase master

Hilsen
   Jesper Brouer

--
-------------------------------------------------------------------
MSc. Master of Computer Science
Dept. of Computer Science, University of Copenhagen
Author of http://www.adsl-optimizer.dk
-------------------------------------------------------------------
