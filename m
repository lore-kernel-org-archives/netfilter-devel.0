From: Patrick McHardy <kaber@trash.net>
Subject: Re: cups slow on linux-2.6.24
Date: Fri, 15 Feb 2008 02:44:00 +0100
Message-ID: <47B4EE60.4030501@trash.net>
References: <Pine.LNX.4.64.0802102257420.14442@boston.corp.fedex.com>	<Pine.LNX.4.64.0802141536560.22526@blackhole.kfki.hu> <20080214.145042.210615931.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: kadlec@blackhole.kfki.hu, jeff.chua.linux@gmail.com,
	linux-kernel@vger.kernel.org, ole@ans.pl, cups-bugs@easysw.com,
	netfilter-devel@vger.kernel.org, torvalds@linux-foundation.org
To: David Miller <davem@davemloft.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from viefep18-int.chello.at ([213.46.255.22]:8692 "EHLO
	viefep14-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752508AbYBOBoI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 14 Feb 2008 20:44:08 -0500
In-Reply-To: <20080214.145042.210615931.davem@davemloft.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

David Miller wrote:
> From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
> Date: Thu, 14 Feb 2008 16:02:29 +0100 (CET)
> 
>> Hi,
>>
>> On Sun, 10 Feb 2008, Jeff Chua wrote:
>>
>>> Please note the lastest git commit is missing one part (which was in Jozsef's
>>> original patch).
>> Sorry everyone, that's my fault: the patch I sent for the stable branch 
>> was correct, however I mistyped a state in the patch for the newest 
>> git tree - Jeff spotted it, thanks! So here follows the patch against the 
>> newest git tree which corrects the mistake. Please review and commit.
> 
> I'll apply this since Patrick still isn't feeling well.


Thanks Dave. I'm almost feeling healthy again, so I'll go through
my backlog over the next days and will push everything important
early next week.

