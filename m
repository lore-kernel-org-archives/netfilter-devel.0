From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 0/5] netfilter: ipset patches
Date: Tue, 19 Apr 2011 16:08:09 +0200
Message-ID: <4DAD9749.7070302@trash.net>
References: <1302724356-19590-1-git-send-email-kadlec@blackhole.kfki.hu> <4DAC4BC1.8060208@trash.net> <alpine.DEB.2.00.1104182107170.9202@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:39301 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908Ab1DSOIK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Apr 2011 10:08:10 -0400
In-Reply-To: <alpine.DEB.2.00.1104182107170.9202@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 18.04.2011 21:08, schrieb Jozsef Kadlecsik:
> On Mon, 18 Apr 2011, Patrick McHardy wrote:
> 
>> Am 13.04.2011 21:52, schrieb Jozsef Kadlecsik:
>>> Hi Patrick,
>>>
>>> Here follows the ipset patches for nf-next-2.6. This batch contains
>>> the missing fixes compared to nf-2.6 and one new feature, the ability
>>> to modify the timeout value of already existing elements.
>>
>> Thanks, but we shouldn't be applying the same patches twice, its better
>> to ask Dave to pull in net-2.6.git into net-next-2.6.git if your
>> patches depend on fixes in that tree, I can then pull net-next-2.6.git
>> into my tree.
> 
> Oh, right. I'm going to send one bugfix today or tomorrow morning, then 
> just the improvements remains.

The fixes are in net-next now, I'll send out the so far queued patches
tonight or tommorrow morning and will then merge the current net-next
tree into nf-next.
