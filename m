From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/4] ipt_set: fix a typo in the manpage
Date: Mon, 24 Aug 2009 14:19:13 +0200
Message-ID: <4A928541.6070802@trash.net>
References: <1250780978-14013-1-git-send-email-jengelh@medozas.de> <1250780978-14013-3-git-send-email-jengelh@medozas.de> <20090820164732.GA27954@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@medozas.de>,
	netfilter-devel@vger.kernel.org
To: Phil Oester <kernel@linuxace.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:50706 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752308AbZHXMTP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 24 Aug 2009 08:19:15 -0400
In-Reply-To: <20090820164732.GA27954@linuxace.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Phil Oester wrote:
> On Thu, Aug 20, 2009 at 05:09:36PM +0200, Jan Engelhardt wrote:
>> From: Trent W. Buck <trentbuck@gmail.com>
>>
>> References: http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=539101
>> Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
>> ---
>>  extensions/libipt_set.man |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/extensions/libipt_set.man b/extensions/libipt_set.man
>> index 6df6b29..455706c 100644
>> --- a/extensions/libipt_set.man
>> +++ b/extensions/libipt_set.man
>> @@ -1,4 +1,4 @@
>> -This modules macthes IP sets which can be defined by ipset(8).
>> +This modules matches IP sets which can be defined by ipset(8).
> 
> While in there, modules should be singular.  

Fixed, thanks.
