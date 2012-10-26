From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: Re: [RFC PATCH 0/1] xtables: allow to monitor table update event
Date: Fri, 26 Oct 2012 10:05:25 +0200
Message-ID: <508A4445.5020500@6wind.com>
References: <1348501182-12470-1-git-send-email-nicolas.dichtel@6wind.com> <1349183171-4136-1-git-send-email-nicolas.dichtel@6wind.com> <507C0B40.5000105@6wind.com> <50893620.70107@6wind.com> <20121025171911.GA9571@1984>
Reply-To: nicolas.dichtel@6wind.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, Jan Engelhardt <jengelh@inai.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:60425 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757110Ab2JZIF3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 26 Oct 2012 04:05:29 -0400
Received: by mail-ee0-f46.google.com with SMTP id b15so894959eek.19
        for <netfilter-devel@vger.kernel.org>; Fri, 26 Oct 2012 01:05:28 -0700 (PDT)
In-Reply-To: <20121025171911.GA9571@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le 25/10/2012 19:19, Pablo Neira Ayuso a =E9crit :
> Hi Nicolas,
>
> On Thu, Oct 25, 2012 at 02:52:48PM +0200, Nicolas Dichtel wrote:
>> Le 15/10/2012 15:10, Nicolas Dichtel a =E9crit :
>>> Le 02/10/2012 15:06, Nicolas Dichtel a =E9crit :
>>>> The following patch is an example of a userspace tools (in fact, i=
ptables)
>>>> that use the new netlink API to monitor tables activity.
>>>>
>>>> I will also send a patch against libnfnetlink to update linux incl=
udes with
>>>> this new feature.
>>>>
>>>> Maybe another API can be used for this feature: adding a setsockop=
t() on an
>>>> iptc socket to enable monitoring. When a table is updated, a packe=
t (built with
>>>> CMSG_* macro for example) can be sent over all sockets that monito=
r tables
>>>> acitivity (like km sockets in IPsec). I know that this socket was =
used only with
>>>> [g|s]etsockopt(), but this can avoid adding another netlink API.
>>>>
>>>> Comments are welcome.
>>> Any feedback about this patch or the other proposed API?
>>
>> Still no comment about this feature? Maybe another option to solve t=
he problem?
>
> Adding a new nfnetlink subsystem to just reports table updates seems
> a bit too much to me.
What about the second proposal? Sending messages through the iptc socke=
t?
If you have some other ideas, we can change the design of the implement=
ation,=20
it's not a problem.

>
> I'd aim to the nftables proposal that I just made. If this doesn't
> happen in a reasonable amount of time, get back to the mailing list
> and push us again to get this in.
There seems to be two competitors for the next generation: nftables vs =
xtables2.=20
Can we not start with a first implementation with the current xtables. =
Then, we=20
will work to have a continuity of this feature in the next generation.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
