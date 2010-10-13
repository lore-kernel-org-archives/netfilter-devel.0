From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: Re: event-driven connection tracking
Date: Wed, 13 Oct 2010 23:18:18 +0100
Message-ID: <4CB6302A.8080507@googlemail.com>
References: <4CB5CF17.3090302@googlemail.com> <alpine.LNX.2.01.1010131747460.27120@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, netfilter@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:37443 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149Ab0JMWS0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Oct 2010 18:18:26 -0400
In-Reply-To: <alpine.LNX.2.01.1010131747460.27120@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


>> Is it possible to use event-driven connection tracking - with conntrack-utils
>> or by other means?
>>
>> Ideally, what I would like to do is 'register' a handler for particular
>> connection events (when new connection is established and then closed for
>> example) based on particular pre-defined filter (say, by protocol,
>> source/destination ip etc) and execute a program code/function (if done
>> programmatically) or a script (if done outside the connection-tracking domain)
>> to do what I want?
>>     
>
> conntrack -Ee NEW,DESTROY
>
> would list you the specified events as they happen. Combined with a 
> script that reacts when a new line is outputted by conntrack should
> do the trick.
>   
That's not what I am after!

If I want to poll a text output every-so-often I can use 
/proc/net/nf_conntrack for that. I am after event-driven tracking 
(without the polling!), informing me when the conditions I initially set 
are satisfied (connection status, source IP, destination IP etc) and I 
pick up the rest (again, via a program interface or a script if there is 
no other choice). A bit like (ng-)cron, but with set filters which 
trigger the events (as oppose to timing as is the case with cron).
