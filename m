From: Patrick McHardy <kaber@trash.net>
Subject: Re: bug in iptables
Date: Wed, 27 Feb 2008 13:07:28 +0100
Message-ID: <47C55280.6060503@trash.net>
References: <74d7e2880802141038t53e58f5frafe12a3a77a3fca9@mail.gmail.com> <47B53643.9000107@gmail.com> <47BACB6C.4090000@trash.net> <47BE7917.1030301@gmail.com> <47BED75A.9090204@trash.net> <47BEE08D.9070003@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: justin joseph <justin.cok@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from viefep31-int.chello.at ([62.179.121.49]:55435 "EHLO
	viefep31-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753606AbYB0MH1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 27 Feb 2008 07:07:27 -0500
In-Reply-To: <47BEE08D.9070003@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy wrote:
> Patrick McHardy wrote:
>> justin joseph wrote:
>>
>>> root@hq.enpaq:~# uname -r
>>> 2.6.15-29-386
>>> root@hq.enpaq:~#
>>
>>
>> Thanks, I can reproduce it on current -git. I'll look into it.
> 
> 
> OK actually we've never had a check for this in the kernel.
> Userspace contains some basic checks based on the chainname,
> but this only works for the built-in chains.
> 
> This patch adds the proper checks to the kernel. I'm a bit
> worried though that this might break some rulesets. So
> far we've allowed to create used-defined rules with these
> "invalid" matches, which might even be useful to share
> chains between multiple hooks, even if some matches will
> not match depending on where the jump came from.
> 
> Opinions?


Well, I decided against pushing this patch since there's no
harm in the current behaviour and the risk of breaking things
seems to high.
