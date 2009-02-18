From: Ratnaraj Mirgal <ratnaraj20@gmail.com>
Subject: Re: queuing pkts using nf_queue_handler in bridge (PF_BRIDGE) mode
	not working in 2.6 kernel
Date: Wed, 18 Feb 2009 16:35:23 +0530
Message-ID: <c6c752b20902180305t796628abs6b926e69c2620b42@mail.gmail.com>
References: <c6c752b20902171954k4439c1dsc7c311c4863deaef@mail.gmail.com>
	 <499BE240.6050204@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ew0-f21.google.com ([209.85.219.21]:39507 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751988AbZBRLFZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 18 Feb 2009 06:05:25 -0500
Received: by ewy14 with SMTP id 14so2647331ewy.13
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Feb 2009 03:05:23 -0800 (PST)
In-Reply-To: <499BE240.6050204@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

thanx for reply :-)

i just found tht.... (i put printks in nf_queue of
net/netfilter/nf_queue.c)... n i referred to afinfo of ipv4...

thanx again

On Wed, Feb 18, 2009 at 3:56 PM, Patrick McHardy <kaber@trash.net> wrote:
> Ratnaraj Mirgal wrote:
>>
>> Hi,
>>
>> i'm trying a simple lkm tht register a hook in PF_BRIDGE protocol,
>> also registers a queue_handler for the same.
>> the hook function simply returns NF_QUEUE for all IP pakcets.
>>
>> i'm trying this out in 2.6.18-8.el5 (centos 5.0)
>>
>> it seems like pkts are queuing up, but the _problem_ is queue_handler
>> is not getting invoked.
>> plz refer to the code below.
>>
>> (NOTE: the same program worked fine in my rh9 (ie 2.4 kernel), of
>> course with minor nf API modification)
>
> The bridge netfilter code doesn't register an afinfo with the
> netfilter core, so queueing drops the packets. Its actually
> not needed since bridge netfilter doesn't need to reroute anyways.
> So you basically need to change the __nf_queue function to only
> invoke the af-specific functions if an afinfo is available.
>
> Patches welcome btw :)
>
>
>
