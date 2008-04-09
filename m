From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/8] [NETFILTER]: xt_recent: IPv6 support
Date: Wed, 09 Apr 2008 15:48:00 +0200
Message-ID: <47FCC910.3000206@trash.net>
References: <5130e28c2130c57a9a07ae21c552fe7db519473c.1207668694.git.jengelh@computergmbh.de> <e6fb8173fde4f1ea0cee785b763a2b2b37a89ebb.1207668694.git.jengelh@computergmbh.de> <47FCBB15.90003@trash.net> <47FCC50F.2020802@trash.net> <alpine.LNX.1.10.0804091536410.4411@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:47089 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752101AbYDINsE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Apr 2008 09:48:04 -0400
In-Reply-To: <alpine.LNX.1.10.0804091536410.4411@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Wednesday 2008-04-09 15:30, Patrick McHardy wrote:
>> Patrick McHardy wrote:
>>> Jan Engelhardt wrote:
>>>> This updates xt_recent to support the IPv6 address family.
>>>> The new /proc/net/xt_recent directory must be used for this.
>>>>
>>> Could you introduce a new option for this please? Something
>>> like CONFIG_NF_CONNTRACK_PROC_COMPAT.
>> BTW, it would be great if you could send me this patch before
>> anything else since my tree has grown too much and I intend
>> to push the first batch to Dave later and would like to already
>> include the hashlimit patch in this batch.
>>
> Adding an extra option to compile out the old stuff makes
> for lots of ugly #ifdefs. Not want to do that.


I don't care much about the text size, I want the option
to make it clear that this is an old interface kept for
compatibility.
