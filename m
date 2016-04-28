From: subashab@codeaurora.org
Subject: Re: [PATCH iptables] xtables: use exponential delay when waiting for
 xtables lock
Date: Thu, 28 Apr 2016 13:14:17 -0600
Message-ID: <569a5c79f8ca32db942694308c3e1500@codeaurora.org>
References: <1460084845-28057-1-git-send-email-subashab@codeaurora.org>
 <CAML_gOfhesCGBk5WWpmAsi3GQNHu5ZZpe9Wg36HCjGgQuRNeOg@mail.gmail.com>
 <20160428092541.GB1529@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Cc: Liping Zhang <zlpnobody@gmail.com>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:56637 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751865AbcD1TOT (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 28 Apr 2016 15:14:19 -0400
In-Reply-To: <20160428092541.GB1529@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

>> 
>> This break the "-w" option's semantic, i.e. if the user input
>> "iptables -w 1", and concurrency happen,
>> we will just only wait 10ms and return an error.
> 
> If there's any chance this patch can break existing setups then we
> can't take this.
> 
> I'd suggest you add support to express millisecond precision using a
> dot notation, ie.
> 
>         -w .000001
> 
> that means 10 ms.

Thanks Liping / Pablo for your comments.

I'll raise a new patchset for this.

--
Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora 
Forum, a Linux Foundation Collaborative Project.
