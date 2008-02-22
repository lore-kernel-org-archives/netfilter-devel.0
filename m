From: Patrick McHardy <kaber@trash.net>
Subject: Re: Xtables, Xtables-addons 1.5.1
Date: Fri, 22 Feb 2008 14:17:44 +0100
Message-ID: <47BECB78.4060405@trash.net>
References: <47BDD5B0.3040806@trash.net>	<Pine.LNX.4.64.0802212253450.26109@fbirervta.pbzchgretzou.qr>	<47BEC691.8040905@trash.net> <200802221313.m1MDDEBV012684@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: jengelh@computergmbh.de, netfilter-devel@vger.kernel.org
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from viefep20-int.chello.at ([62.179.121.40]:48573 "EHLO
	viefep20-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755434AbYBVNSH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 22 Feb 2008 08:18:07 -0500
In-Reply-To: <200802221313.m1MDDEBV012684@toshiba.co.jp>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Yasuyuki KOZAKAI wrote:
> From: Patrick McHardy <kaber@trash.net>
> Date: Fri, 22 Feb 2008 13:56:49 +0100
> 
>> Jan Engelhardt wrote:
>>> What have become of the idea of gitifying the netfilter svn?
>>
>> I didn't find time for this so far. Unfortunately there seems to be
>> something wrong with the netfilter SVN and a full import didn't work
>> last time I tried, so we would have to throw away the history.
> 
> We can keep the history in git tree.
> 
> Actually I could do that (with some diffs of $Id lines) for almost
> programs last year. But I did not update my git tree.
> 
> Unfortunately I have to concentrate with other work until next Monday.
> If you want the recent git tree, I'll update and put them people.netfilter.org
> next week.
> 
> (You can get the old git tree for iptables at
> 	http://people.netfilter.org/yasuyuki/git/iptables.git/
>  and the mapping of svn revision and git tag is available at
> 	http://people.netfilter.org/yasuyuki/git/iptables.git/svn2git)
> 
> Sorry, but I couldn't find the way to synchronize svn tree from git tree.
> So at least we have to 'switch' git tree from svn tree at once.


That sounds good. I won't be able to look into this until the
end of next week, but I'll look into it then. We'll also need
to set up gitweb and a public git server somewhere.
