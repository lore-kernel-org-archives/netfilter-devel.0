From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: Re: [RFC PATCH 0/1] xtables: allow to monitor table update event
Date: Mon, 15 Oct 2012 15:10:24 +0200
Message-ID: <507C0B40.5000105@6wind.com>
References: <1348501182-12470-1-git-send-email-nicolas.dichtel@6wind.com> <1349183171-4136-1-git-send-email-nicolas.dichtel@6wind.com>
Reply-To: nicolas.dichtel@6wind.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org, pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:62126 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753120Ab2JONKc (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Oct 2012 09:10:32 -0400
Received: by mail-bk0-f46.google.com with SMTP id jk13so2441381bkc.19
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Oct 2012 06:10:30 -0700 (PDT)
In-Reply-To: <1349183171-4136-1-git-send-email-nicolas.dichtel@6wind.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le 02/10/2012 15:06, Nicolas Dichtel a =C3=A9crit :
> The following patch is an example of a userspace tools (in fact, ipta=
bles)
> that use the new netlink API to monitor tables activity.
>
> I will also send a patch against libnfnetlink to update linux include=
s with
> this new feature.
>
> Maybe another API can be used for this feature: adding a setsockopt()=
 on an
> iptc socket to enable monitoring. When a table is updated, a packet (=
built with
> CMSG_* macro for example) can be sent over all sockets that monitor t=
ables
> acitivity (like km sockets in IPsec). I know that this socket was use=
d only with
> [g|s]etsockopt(), but this can avoid adding another netlink API.
>
> Comments are welcome.
Any feedback about this patch or the other proposed API?


Regards,
Nicolas
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
