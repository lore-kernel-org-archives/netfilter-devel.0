From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: iptables release
Date: Thu, 29 Nov 2007 22:05:52 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0711292205040.3089@fbirervta.pbzchgretzou.qr>
References: <474C4B67.3000200@trash.net> <200711290249.lAT2nkEr004081@toshiba.co.jp>
 <474E640F.4010401@trash.net> <Pine.LNX.4.64.0711292044300.8275@ask.diku.dk>
 <474F2670.8080509@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Jesper Dangaard Brouer <hawk@diku.dk>,
	Netfilter Developers <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:45089 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759413AbXK2VFx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 29 Nov 2007 16:05:53 -0500
In-Reply-To: <474F2670.8080509@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


On Nov 29 2007 21:52, Patrick McHardy wrote:
>>
>>  git-checkout master
>>  git-svn fetch
>>  git-svn rebase
>>
>> To get one of my work branches up to sync I do a git rebase:
>>
>>  git-checkout perf_work1
>>  git rebase master
>
> Yeah, that works for importing the head and keeping in sync,
> but it doesn't work for importing the entire repository with
> branches and history according to the manpage. Still useful
> since I hate SVN about as much as CVS :)

If you are willing to reorder the SVN tree, that may make git
more happy.
