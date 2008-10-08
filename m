From: Patrick McHardy <kaber@trash.net>
Subject: Re: [Fwd: [PATCH 2.4]: ip6t_{hbh,dst}: Rejects not-strict mode on
 rule insersion]
Date: Wed, 08 Oct 2008 14:55:24 +0200
Message-ID: <48ECADBC.2010409@trash.net>
References: <48ECA862.1010204@trash.net> <20081008125229.GC28783@1wt.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Willy Tarreau <w@1wt.eu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:49503 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751561AbYJHMz1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Oct 2008 08:55:27 -0400
In-Reply-To: <20081008125229.GC28783@1wt.eu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Willy Tarreau wrote:
> Hi Patrick,
> 
> On Wed, Oct 08, 2008 at 02:32:34PM +0200, Patrick McHardy wrote:
>> Hi Willy,
>>
>> This patch from Yasuyuki fixes a problem in the hbh/dst matches which
>> is currently hidden by broken userspace, but will be exposed once
>> we've fixed userspace. Unfortunately neither of us has a working
>> 2.4 environment, so all I can do is forward the patch. The upstream
>> commit ID is 8ca31ce52.
> 
> OK. I still have working 2.4 + IPv6, so if there is any reproducer, I can
> test the fix. Otherwise, I'll apply it, as it seems pretty straight-forward
> for anyone who doesn't want to precisely understand what it fixes :-)

I guess it can't be tested right now because of the userspace problem,
but it really is pretty straight forward :)
