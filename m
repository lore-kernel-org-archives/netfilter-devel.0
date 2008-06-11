From: Patrick McHardy <kaber@trash.net>
Subject: Re: [SPAM?] Re: conntrackd causes kernel panic
Date: Wed, 11 Jun 2008 08:48:34 +0200
Message-ID: <484F7542.8040906@trash.net>
References: <200806101343.12607.sabelka@iue.tuwien.ac.at> <Pine.LNX.4.64.0806101858080.12641@bizon.gios.gov.pl> <Pine.LNX.4.64.0806102008000.20559@bizon.gios.gov.pl> <200806110841.44410.sabelka@iue.tuwien.ac.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Krzysztof Oledzki <ole@ans.pl>, netfilter-devel@vger.kernel.org
To: Rainer Sabelka <sabelka@iue.tuwien.ac.at>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62984 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752767AbYFKGsg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Jun 2008 02:48:36 -0400
In-Reply-To: <200806110841.44410.sabelka@iue.tuwien.ac.at>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Rainer Sabelka wrote:
> On Tuesday 10 June 2008 20:12:48 Krzysztof Oledzki wrote:
>> On Tue, 10 Jun 2008, Krzysztof Oledzki wrote:
>>> On Tue, 10 Jun 2008, Rainer Sabelka wrote:
>>>> On Tuesday 10 June 2008 16:29, Patrick McHardy wrote:
>>>>> Do these two patches help?
>>>> Patrick, I tried to apply those patches to the Ubuntu kernel sources
>>>> (2.6.24-18) but they failed, so I guess I should try to use a vanilla
>>>> kernel
>>>> instead.
>>>> Which version should I try?
>>> Those patches are for nf-next-2.6. I have a backport of this patches for
>>> 2.6.24.x and 2.6.25.x kernels, but I need to make sure there were no
>>> changes in the latest version.
>> OK, here it is (for 2.6.24.7):
>>   ftp://ftp.ans.pl/pub/patches/patch-ole-2.6.24-o4.gz
>>
>> Not sure what changes are in ubuntu 2.6.24-18 and probably you may not
>> like to take all of my patches so:
>>   ftp://ftp.ans.pl/pub/patches/broken-out/2.6.24-o4/
>>
>> You need patches 0750, 0760, 0840 and 0850.
> 
> Krzysztof, I've applied these 4 patches to ubuntu's 2.6.24-18 and things look 
> much better now. 
> "conntrackd -c" no longer causes a kernel panic or oops.


Thanks for testing.
