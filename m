From: Patrick McHardy <kaber@trash.net>
Subject: Re: nf-next: netfilter: xt_recent: Add an entry reaper
Date: Wed, 17 Mar 2010 16:19:37 +0100
Message-ID: <4BA0F309.2060003@trash.net>
References: <20100316170915.8F49FF88DA@sepang.rtg.net> <4B9FD4A8.4070704@trash.net> <4B9FDF59.4060409@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: tim.gardner@canonical.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:60105 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381Ab0CQPTn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Mar 2010 11:19:43 -0400
In-Reply-To: <4B9FDF59.4060409@canonical.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Tim Gardner wrote:
> On 03/16/2010 12:57 PM, Patrick McHardy wrote:
>> Thanks, this looks fine. My only concern is that we currently
>> don't catch unknown flags, so userspace won't get an error if
>> the option is used and the kernel doesn't support it. If you
>> document this clearly we can ignore it this one time, but I'd
>> appreciate if you could send me a patch on top to check for
>> unknown flags and refuse them.
>>
> Thusly? (attached)

Applied, thanks.
