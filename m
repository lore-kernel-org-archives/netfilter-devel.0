From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: Re: [RFC PATCH 0/1] xtables: allow to monitor table update event
Date: Thu, 25 Oct 2012 14:52:48 +0200
Message-ID: <50893620.70107@6wind.com>
References: <1348501182-12470-1-git-send-email-nicolas.dichtel@6wind.com> <1349183171-4136-1-git-send-email-nicolas.dichtel@6wind.com> <507C0B40.5000105@6wind.com>
Reply-To: nicolas.dichtel@6wind.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:63863 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752803Ab2JYMwx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 25 Oct 2012 08:52:53 -0400
Received: by mail-ee0-f46.google.com with SMTP id b15so600818eek.19
        for <netfilter-devel@vger.kernel.org>; Thu, 25 Oct 2012 05:52:51 -0700 (PDT)
In-Reply-To: <507C0B40.5000105@6wind.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le 15/10/2012 15:10, Nicolas Dichtel a =C3=A9crit :
> Le 02/10/2012 15:06, Nicolas Dichtel a =C3=A9crit :
>> The following patch is an example of a userspace tools (in fact, ipt=
ables)
>> that use the new netlink API to monitor tables activity.
>>
>> I will also send a patch against libnfnetlink to update linux includ=
es with
>> this new feature.
>>
>> Maybe another API can be used for this feature: adding a setsockopt(=
) on an
>> iptc socket to enable monitoring. When a table is updated, a packet =
(built with
>> CMSG_* macro for example) can be sent over all sockets that monitor =
tables
>> acitivity (like km sockets in IPsec). I know that this socket was us=
ed only with
>> [g|s]etsockopt(), but this can avoid adding another netlink API.
>>
>> Comments are welcome.
> Any feedback about this patch or the other proposed API?
Still no comment about this feature? Maybe another option to solve the =
problem?


Regards,
Nicolas
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
