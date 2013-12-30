From: Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: Re: [PATCH 1/1] netfilter: xtables: add quota support to nfacct
Date: Mon, 30 Dec 2013 16:14:21 -0700
Message-ID: <CANLsYkzRPDQsKFDsHTZKDOLmX=_yhBa3FBCbuY1-Uy2TG3jYQg@mail.gmail.com>
References: <1386780798-24374-1-git-send-email-mathieu.poirier@linaro.org>
	<1386780798-24374-2-git-send-email-mathieu.poirier@linaro.org>
	<20131218095322.GA4740@localhost>
	<CANLsYkxMzdFCpJ3456PPd8KsEPi-U70kJDqGv8c3BhCsKY8RiQ@mail.gmail.com>
	<20131219194339.GA4561@localhost>
	<CANLsYkzoa0E6T8ZGYmKHSPdFyGkLeQw8_dsB_NAJx9YA2qD8uw@mail.gmail.com>
	<20131221085509.GA4230@localhost>
	<CANLsYkx32_sUzZvy697Vhyu7cBUaoYtB__FNTvdhwWDguLmT2Q@mail.gmail.com>
	<20131230173655.GA21288@localhost>
	<CANLsYkx34A97NwJyFb05MT=zneT8ET=Nyz7HTGEDWHhGAZP_-Q@mail.gmail.com>
	<20131230214653.GP29632@breakpoint.cc>
	<CANLsYkxr2eRyz0aWDD8OMJDf2YWpwg3SOBpEhoopfy6N+kzfWg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
	John Stultz <john.stultz@linaro.org>,
	JP Abgrall <jpa@google.com>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ve0-f180.google.com ([209.85.128.180]:34346 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932390Ab3L3XOX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 Dec 2013 18:14:23 -0500
Received: by mail-ve0-f180.google.com with SMTP id jz11so6145178veb.39
        for <netfilter-devel@vger.kernel.org>; Mon, 30 Dec 2013 15:14:22 -0800 (PST)
In-Reply-To: <CANLsYkxr2eRyz0aWDD8OMJDf2YWpwg3SOBpEhoopfy6N+kzfWg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 30 December 2013 15:17, Mathieu Poirier <mathieu.poirier@linaro.org> wrote:
> Hey Florian - I think that is an acceptable compromise.  The LOG chain
> and rules are extra but it is setup only once and as such scale well.
>
> Thank you for that,
> Mathieu
>
> On 30 December 2013 14:46, Florian Westphal <fw@strlen.de> wrote:
>> Mathieu Poirier <mathieu.poirier@linaro.org> wrote:
>>> Upon reaching the limit of 10000 byte of http traffic, any outgoing
>>> http packets will be dropped and a single broadcast message will be
>>> sent to user space.  That is because the match explicitly takes care
>>> of sending the notification.
>>>
>>> With your proposal:
>>>
>>> iptables -I OUTPUT -p http \
>>>          -m nfacct --nfacct-name http-limit --quota 10000 --match-once \
>>>          -j NFLOG --nflog-prefix "http: " --nflog-group 34
>>>
>>> will log the quota reached event but won't prevent further http
>>> traffic from going out.  One could instinctively add another rule
>>> right after the above one, something like:
>>>
>>> iptables -I OUTPUT -p http \
>>>          -m nfacct --nfacct-name http-limit --quota 10000 \
>>>          -j REJECT
>>>
>>> but that won't work either because the packet/byte could will be
>>> incremented twice.
>>
>> The usual workaround is to create custom chains to deal with this,
>> i.e.
>> iptables -N LOG_DROP_HTTP
>> iptables -A LOG_DROP_HTTP -j NFLOG --nflog-prefix "http: " --nflog-group 34
>> iptables -A LOG_DROP_HTTP -j REJECT
>> iptables -I OUTPUT -p http -m nfacct ... -j LOG_DROP_HTTP

I may have spoken too quickly.  With this solution a log message is
sent every time a packet over quota is received, something we
definitely want to avoid.  I was able to cover that case when sending
a notification from the match function.
