From: Patrick McHardy <kaber@trash.net>
Subject: Re: cups slow on linux-2.6.24
Date: Tue, 05 Feb 2008 14:47:02 +0100
Message-ID: <47A868D6.8060907@trash.net>
References: <Pine.LNX.4.64.0802050913560.6704@boston.corp.fedex.com> <Pine.LNX.4.64.0802050909220.32232@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jeff Chua <jeff.chua.linux@gmail.com>,
	lkml <linux-kernel@vger.kernel.org>,
	Krzysztof Piotr Oledzki <ole@ans.pl>,
	"David S. Miller" <davem@davemloft.net>,
	cups-bugs <cups-bugs@easysw.com>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:58147 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075AbYBENrm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 5 Feb 2008 08:47:42 -0500
In-Reply-To: <Pine.LNX.4.64.0802050909220.32232@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jozsef Kadlecsik wrote:
> On Tue, 5 Feb 2008, Jeff Chua wrote:
> 
>> On Feb 5, 2008 4:17 AM, Jozsef Kadlecsik <kadlec@blackhole.kfki.hu> wrote:
>>
>>> Actively closed connections are not handled properly, i.e. the initiator of
>>> the active close should not be taken into account. So could you give a try
>>> to the patch below? Does it just suppress the 'invalid packed ignored' and
>>> all other kernel messages or both suppresses them and produces normal
>>> printing speed?
>> Amazing! You fixed it. No more 'invalid packed ignored', and speed back to
>> normal (continues after approx. 20 seconds of pausing after 503 prints).
> 
> Great! Thank you for the testing!


Thanks for figuring this out.

>> I used the latest git, and have to modify your patch slightly to make it work
>> (changing "conntrack" to "ct").
> 
> Patrick, I suppose you need a patch against the latest git, don't you?


Yes, please. I'll take you first patch for -stable though if you
send me a Signed-off-by: line.
