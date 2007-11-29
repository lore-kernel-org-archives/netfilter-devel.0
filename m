From: Patrick McHardy <kaber@trash.net>
Subject: Re: iptables release
Date: Thu, 29 Nov 2007 22:37:47 +0100
Message-ID: <474F312B.5060103@trash.net>
References: <474C4B67.3000200@trash.net> <200711290249.lAT2nkEr004081@toshiba.co.jp> <474E640F.4010401@trash.net> <Pine.LNX.4.64.0711292044300.8275@ask.diku.dk> <474F2670.8080509@trash.net> <Pine.LNX.4.64.0711292205040.3089@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jesper Dangaard Brouer <hawk@diku.dk>,
	Netfilter Developers <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:57274 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762642AbXK2ViS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 29 Nov 2007 16:38:18 -0500
In-Reply-To: <Pine.LNX.4.64.0711292205040.3089@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Jan Engelhardt wrote:
> On Nov 29 2007 21:52, Patrick McHardy wrote:
>   
>>>  git-checkout master
>>>  git-svn fetch
>>>  git-svn rebase
>>>
>>> To get one of my work branches up to sync I do a git rebase:
>>>
>>>  git-checkout perf_work1
>>>  git rebase master
>>>       
>> Yeah, that works for importing the head and keeping in sync,
>> but it doesn't work for importing the entire repository with
>> branches and history according to the manpage. Still useful
>> since I hate SVN about as much as CVS :)
>>     
>
> If you are willing to reorder the SVN tree, that may make git
> more happy.

I think its more a SVN misconfiguration. git-svnimport looks for
(example) iptables/trunk, but its trunk/iptables. Couldn't find
out where the misconfiguration is though.

