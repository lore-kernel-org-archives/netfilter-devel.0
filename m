From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: flow start_time
Date: Wed, 06 May 2009 15:47:04 +0400
Message-ID: <4A0178B8.3040706@msgid.tls.msk.ru>
References: <49F08A19.6010909@msgid.tls.msk.ru> <4A0045E8.1000508@trash.net> <4A016F74.6050601@msgid.tls.msk.ru> <4A0173CF.6080505@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from isrv.corpit.ru ([81.13.33.159]:48914 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758198AbZEFLrH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 6 May 2009 07:47:07 -0400
In-Reply-To: <4A0173CF.6080505@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
[]
>> For nowadays tools, in case we've seen "new" but not "remove" event,
>> that connection will be in our hash table sorta forever (ok, till
>> restart).  Which is, I think, worse than not logging it at all (it
>> will not be logged anyway).
>>
>> Basically, I don't see such a case (lost "remove" event) as valid.
> 
> I have a couple of patches here that I'm still working on it here to
> avoid "remove" event loss. It should be ready for review once the
> nf-next-2.6 tree is open.

Well, I didn't know it can occur to start with :)  But it's good to
know it's almost fixed -- thanks!

> To know when a flow starts and avoid the problem of "new" event loss. I
> think that we can still add a conntrack extension to store the start
> time. I think that's enough, right?

It is _exactly_ what I'm talking/asking about.  To say - Does anyone
have an objection to that?

Which time to use is entirely another question.  Should it be 'ticks'
or 'jiffies' or like time(2)/gettimeofday(2) with all the fun stuff
about system time resets etc.....  Oh well.

Thanks.

/mjt
