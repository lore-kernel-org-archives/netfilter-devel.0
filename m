From: Laszlo Attila Toth <panther@balabit.hu>
Subject: Re: [resend net-next] socket: Added 'transparent' option
Date: Fri, 05 Jun 2009 15:06:59 +0200
Message-ID: <4A291873.5080707@balabit.hu>
References: <1244122013-25970-1-git-send-email-panther@balabit.hu> <4A27CD5A.6040303@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, jengelh@medozas.de
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from support.balabit.hu ([195.70.41.86]:52279 "EHLO lists.balabit.hu"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751345AbZFENG6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Jun 2009 09:06:58 -0400
Received: from balabit.hu (unknown [10.80.0.254])
	by lists.balabit.hu (Postfix) with ESMTP id 6217D13A1C9
	for <netfilter-devel@vger.kernel.org>; Fri,  5 Jun 2009 15:06:58 +0200 (CEST)
In-Reply-To: <4A27CD5A.6040303@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy wrote:
> Laszlo Attila Toth wrote:
>>          nf_tproxy_put_sock(sk);
>> +
>>          if (wildcard)
>>              sk = NULL;
>> +        else if (check_transparent && info->transparent &&
>> +             !transparent)
>> +            sk = NULL;
> 
> Please add a comment what this is doing exactly. And why do the lookup
> at all in this case?
> 

We need a socket lookup because without it we can't know the listening 
address and the socket's transparent state (socket option). After all of 
these pieces of information is gathered, the socket can be put back.

-- 
Attila
