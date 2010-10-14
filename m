From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: event-driven connection tracking
Date: Thu, 14 Oct 2010 14:04:50 +0200
Message-ID: <4CB6F1E2.3030702@netfilter.org>
References: <4CB5CF17.3090302@googlemail.com> <alpine.LNX.2.01.1010131747460.27120@obet.zrqbmnf.qr> <4CB6302A.8080507@googlemail.com> <alpine.LNX.2.01.1010140053190.5698@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Mr Dash Four <mr.dash.four@googlemail.com>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, netfilter@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48852 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753179Ab0JNMEx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 14 Oct 2010 08:04:53 -0400
In-Reply-To: <alpine.LNX.2.01.1010140053190.5698@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 14/10/10 00:56, Jan Engelhardt wrote:
> 
> On Thursday 2010-10-14 00:18, Mr Dash Four wrote:
>>>> Is it possible to use event-driven connection tracking - with conntrack-utils
>>>> or by other means?
>>>> Ideally, what I would like to do is 'register' a handler for particular
>>>> connection events (when new connection is established and then closed for
>>>> example) based on particular pre-defined filter (say, by protocol,
>>>> source/destination ip etc) and execute a program code/function (if done
>>>> programmatically) or a script (if done outside the connection-tracking
>>>> domain)
>>>> to do what I want?
>>>
>>> conntrack -Ee NEW,DESTROY
>>>
>>> would list you the specified events as they happen. Combined with a script
>>> that reacts when a new line is outputted by conntrack should
>>> do the trick.
>>>  
>> That's not what I am after!
>>
>> If I want to poll a text output every-so-often I can use /proc/net/nf_conntrack
> 
> -E is event driven. (That's why it's got the "E".)

Indeed, if you're looking for a tool to listen to event-driven conntrack
notifications, then what Jan suggests is the correct approach. If you
want to make your own handling application, you can use
libnetfilter_conntrack.

For logging, you can use ulogd2.
