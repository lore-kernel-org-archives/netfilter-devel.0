From: Patrick McHardy <kaber@trash.net>
Subject: Re: doc: escape minus sign in manpages
Date: Fri, 16 Jan 2009 09:05:33 +0100
Message-ID: <49703FCD.9020205@trash.net>
References: <alpine.LSU.2.00.0901090313110.16418@fbirervta.pbzchgretzou.qr> <496A9E8A.10405@netfilter.org> <alpine.LSU.2.00.0901120339080.20867@fbirervta.pbzchgretzou.qr> <alpine.LSU.2.00.0901120706460.21692@fbirervta.pbzchgretzou.qr> <496AE148.6000909@trash.net> <alpine.LSU.2.00.0901140645040.29956@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:61195 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758822AbZAPIFf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 16 Jan 2009 03:05:35 -0500
In-Reply-To: <alpine.LSU.2.00.0901140645040.29956@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Monday 2009-01-12 07:20, Patrick McHardy wrote:
>> Jan Engelhardt wrote:
>>> Hm I noticed I still had something in my index that
>>> puts back hyphens where they belong. Here goes:
>>>
>>>
>>> parent fea74bf74ff524431ce65145f1523584edf99dc9 (v1.4.3-rc1-16-gfea74bf)
>>> commit de2a83cb5022c429ccf1b852688481a0d8ad95e5
>>> Author: Jan Engelhardt <jengelh@medozas.de>
>>> Date:   Mon Jan 12 07:06:12 2009 +0100
>>>
>>> doc: escape minus sign in manpage (2)
>> Something in this patch seems to be confusing "patch":
>>
>> patching file ip6tables.8.in
>> patching file iptables.8.in
>> Hunk #1 FAILED at 23.
>> 1 out of 1 hunk FAILED -- saving rejects to file iptables.8.in.rej
> 
> Hm... but format/flowed is disabled already.

It doesn't apply nevertheless. Just send it over gzipped, that will
hopefully keep it intact.
