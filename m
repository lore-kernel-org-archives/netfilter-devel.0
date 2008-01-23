From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [conntrack-utils PATCH r7285 04/11] added alarm_pending()
Date: Wed, 23 Jan 2008 13:16:48 +0100
Message-ID: <47973030.40704@netfilter.org>
References: <20080122141034.30077.12083.stgit@rabbit.intern.cm-ag> <20080122141051.30077.28791.stgit@rabbit.intern.cm-ag> <479729ED.6070904@netfilter.org> <20080123115831.GA14427@swift.blarg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Max Kellermann <max@duempel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41171 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751824AbYAWMRA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 Jan 2008 07:17:00 -0500
In-Reply-To: <20080123115831.GA14427@swift.blarg.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Max Kellermann wrote:
> On 2008/01/23 12:50, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>> Max Kellermann wrote:
>>> +int alarm_pending(struct alarm_list *alarm, struct timeval *tv)
>>> +{
>>> +	if (list_empty(&alarm->head))
>>> +		return 0;
>>> +
>>> +	if (tv != NULL)
>>> +		*tv = alarm->tv;
>> This introduces an extra copy.
> 
> I know.  This patch should make transition to libevent smooth.
> libevent still has this copy in evtimer_pending() but it is called
> rarely

I have noticed it during the first loop review.

> and libevent does not do a lookup in 2048 lists in every main
> loop iteration.
>>> +	if (!alarm_pending(alarm, &tmp))
>>> +		return 0;
>> I cannot think of a situation where alarm_pending returns true at the
>> moment.
> 
> You mean, where alarm_pending returns false?  The check is just here
> for completeness, you could replace it with an assertion.

Indeed. I like this extra checking for completeness. Applied without the
tv parameter.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
