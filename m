From: =?ISO-8859-1?Q?=C1lvaro_Neira_Ayuso?= <alvaroneay@gmail.com>
Subject: Re: [nft PATCH] payload: generate expression using big endian byteorder
Date: Fri, 12 Sep 2014 19:04:59 +0200
Message-ID: <541327BB.40609@gmail.com>
References: <1410526023-4370-1-git-send-email-alvaroneay@gmail.com> <20140912130012.GJ26224@acer.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f178.google.com ([74.125.82.178]:33107 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119AbaILREr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 12 Sep 2014 13:04:47 -0400
Received: by mail-we0-f178.google.com with SMTP id q58so1083071wes.9
        for <netfilter-devel@vger.kernel.org>; Fri, 12 Sep 2014 10:04:45 -0700 (PDT)
In-Reply-To: <20140912130012.GJ26224@acer.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

IHello Patrick

El 12/09/14 15:00, Patrick McHardy escribi=F3:
> On Fri, Sep 12, 2014 at 02:47:03PM +0200, Alvaro Neira Ayuso wrote:
>> If we try to add a rule like:
>>
>> nft add rule filter input udp length {55-9999}
>>
>> nft shows:
>>
>> BUG: invalid byte order conversion 0 =3D> 2
>> nft: src/evaluate.c:153: byteorder_conversion_op: Assertion `0' fail=
ed.
>>
>> Some of the existing payload fields rely on BYTEORDER_INVALID. There=
fore, if we
>> try to convert it in evaluation step, we hit this bug.
>>
>> The packets from the Internet are always in big endian. Therefore, w=
e can create
>> all the payload expressions using big endian byteorder.
>
> No, that's not true for MAC addresses and also a bad assumption to ma=
ke
> in general.

You are right. I forgot that case. I supposed wrong.

>
> What's wrong with the patch you sent previously? I think this is the
> correct way to fix it.

Nothing. I'm going to follow the previous way for fixing this bug.

Thanks Patrick.


--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
