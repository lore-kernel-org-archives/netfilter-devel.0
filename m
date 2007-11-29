From: Patrick McHardy <kaber@trash.net>
Subject: Re: iptables release
Date: Thu, 29 Nov 2007 21:52:00 +0100
Message-ID: <474F2670.8080509@trash.net>
References: <474C4B67.3000200@trash.net> <200711290249.lAT2nkEr004081@toshiba.co.jp> <474E640F.4010401@trash.net> <Pine.LNX.4.64.0711292044300.8275@ask.diku.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developers <netfilter-devel@vger.kernel.org>
To: Jesper Dangaard Brouer <hawk@diku.dk>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:56146 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932277AbXK2Uwb (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 29 Nov 2007 15:52:31 -0500
In-Reply-To: <Pine.LNX.4.64.0711292044300.8275@ask.diku.dk>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Jesper Dangaard Brouer wrote:
>
> On Thu, 29 Nov 2007, Patrick McHardy wrote:
>>
>> It seems it switches the first directory and "trunk". Did you use
>> git-svnimport or just git-svn for importing?
>
> I use "git-svn":
>  git-svn clone https://svn.netfilter.org/netfilter/ -T trunk -b 
> branches -t tags
>
> And I had to update git to a newer version (1.5.3 than debians 1.4.4) 
> to make it work.
>
> Still, I don't think it got the tags and branches right, because 
> .git/refs/tags is empty. And it only gets log history back from 
> revision 3070 (thats where a "new global trunk directory" were created).
>
> When I want to sync with SVN I do:
>
>  git-checkout master
>  git-svn fetch
>  git-svn rebase
>
> To get one of my work branches up to sync I do a git rebase:
>
>  git-checkout perf_work1
>  git rebase master

Yeah, that works for importing the head and keeping in sync,
but it doesn't work for importing the entire repository with
branches and history according to the manpage. Still useful
since I hate SVN about as much as CVS :)

