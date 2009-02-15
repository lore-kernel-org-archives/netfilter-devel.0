From: Eric Leblond <eric@inl.fr>
Subject: Re: [PATCH 1/7] netfilter: use a linked list of loggers.
Date: Sun, 15 Feb 2009 13:33:43 +0100
Message-ID: <49980BA7.2040108@inl.fr>
References: <49909B3E.0@inl.fr> <1234213876-8176-1-git-send-email-eric@inl.fr> <4992DD14.8050906@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 78-210-144-213.altitudetelecom.fr ([213.144.210.78]:59152 "EHLO
	fydelkass.inl.fr" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752395AbZBOMdq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 15 Feb 2009 07:33:46 -0500
In-Reply-To: <4992DD14.8050906@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

Patrick McHardy a =E9crit :
> Eric Leblond wrote:
>> This patch modifies nf_log to use a linked list of loggers for each
>
>> ---
>>  include/net/netfilter/nf_log.h |   10 +++-

>> +#define NFLOGGER_NAME_LEN        12
>=20
> Just wondering what this limit is based on, I can't seem to
> fine anything requiring a limit at all since the names are
> const char *.

Ok, good remark. This is not needed here but I was forced to keep a nam=
e
maximum length due to the maxlen part of sysctl.

>>  static const struct nf_logger *nf_loggers[NFPROTO_NUMPROTO]
>> __read_mostly;
>> -static DEFINE_MUTEX(nf_log_mutex);
>> +static struct list_head nf_loggers_l[NFPROTO_NUMPROTO] __read_mostl=
y;
>> +static DEFINE_SPINLOCK(nf_log_lock);
>=20
> I don't understand how locking is supposed to work now. You change
> the mutex to a spinlock and use it with _bh everywhere, yet I don't
> see a single spot thats called outside of process context and the
> RCU assignments are still present.

I've simplified the code to have the loggers list protected by a trivia=
l
mutex and I only use RCU for the used function array.

> The users of nf_log_register are also not converted simultaneously,
> so this patch breaks bisection.

I've reordered and combined my patches to avoid this.

Thanks a lot for all your remarks, the updated patchset will follow as
reply to this mail.

BR,
--=20
Eric Leblond <eric@inl.fr>
INL: http://www.inl.fr/
NuFW: http://www.nufw.org/
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
