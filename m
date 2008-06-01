From: Patrick McHardy <kaber@trash.net>
Subject: Re: [patch] ipset 2.3.0 segfault on '-U :all: {:all:|:default:}
Date: Sun, 01 Jun 2008 23:14:42 +0200
Message-ID: <48431142.5030106@trash.net>
References: <483F111A.40700@shorewall.net> <Pine.LNX.4.64.0805300917070.10875@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Tom Eastep <teastep@shorewall.net>, netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:46365 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751967AbYFAVOr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 1 Jun 2008 17:14:47 -0400
In-Reply-To: <Pine.LNX.4.64.0805300917070.10875@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jozsef Kadlecsik wrote:
> On Thu, 29 May 2008, Tom Eastep wrote:
> 
>> Segfault occurs at line 1641 as a result of dereferencing a null pointer while
>> testing the set type for iptreemap.
>>
>> Patch attached.
> 
> Thank you the report and the patch: I'll apply it as soon as the svn->git 
> migration of ipset source is ready.

Don't let this stop you, doing a final resync is no problem.
