From: Patrick McHardy <kaber@trash.net>
Subject: Re: iptables release
Date: Thu, 29 Nov 2007 10:13:37 +0100
Message-ID: <474E82C1.3050905@trash.net>
References: <474C4B67.3000200@trash.net> <200711290249.lAT2nkEr004081@toshiba.co.jp> <474E640F.4010401@trash.net> <200711290801.lAT81sf6014235@toshiba.co.jp> <Pine.LNX.4.64.0711290908240.22052@fbirervta.pbzchgretzou.qr> <474E77F6.8030003@trash.net> <Pine.LNX.4.64.0711290945110.22052@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0711291005050.22052@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>,
	coreteam@netfilter.org, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:39484 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752745AbXK2JNk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 29 Nov 2007 04:13:40 -0500
In-Reply-To: <Pine.LNX.4.64.0711291005050.22052@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Jan Engelhardt wrote:
> On Nov 29 2007 09:47, Jan Engelhardt wrote:
>> On Nov 29 2007 09:27, Patrick McHardy wrote:
>>> Jan Engelhardt wrote:
>>>> On Nov 29 2007 17:01, Yasuyuki KOZAKAI wrote:
>>>>>> $ git-svnimport -v -C nf.git http://svn.netfilter.org/netfilter
>>> I want to switch entirely, but first I have to manage to import the
>>> repository :)
>>>
>> The problem is you have a non-trivial repository layout, so
>> using above's git-svnimport is likely to be not enough.
> 
> Also, there currently exist /trunk/PROJECTNAME. If that were to be
> imported into git, I would not be sure whether you can tag single
> projects like in svn .. in git it seems like just the whole tree.
> Trying to tag v1.4.0 would then also include libnfconntrack and
> friends in the tag - not good.


We could use sepate git repositories for that, shouldn't be
a big problem.
