From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH] libxtables: change option precedence order to be
 intuitive
Date: Fri, 29 Oct 2010 14:59:30 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1010291458200.3755@obet.zrqbmnf.qr>
References: <1287501388-5948-1-git-send-email-jengelh@medozas.de> <1287501388-5948-2-git-send-email-jengelh@medozas.de> <alpine.LNX.2.01.1010252357270.18188@obet.zrqbmnf.qr> <4CC94854.8010306@trash.net> <alpine.LNX.2.01.1010281250120.2326@obet.zrqbmnf.qr>
 <AANLkTi=V1vzOxF84M-weryWgQdozzwiyZwFUBMnd9MTH@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Changli Gao <xiaosuo@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:41776 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756182Ab0J2M7b (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 29 Oct 2010 08:59:31 -0400
In-Reply-To: <AANLkTi=V1vzOxF84M-weryWgQdozzwiyZwFUBMnd9MTH@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Friday 2010-10-29 07:26, Changli Gao wrote:
>>>>
>>>>> When using `-m mark --mark 2 -m connmark --mark 2`, the user curr=
ently
>>>>> gets an error about the (libxt_mark) --mark option being used twi=
ce.
>>>>> This is because libxt_connmark's option table does not override a=
ny
>>>>> previous options. This patch changes this behavior, since the cur=
rent
>>>>> behavior does not allow connmark's option to be used at all, whic=
h is
>>>>> illogical.
>>>>
>>>> As per fw's suggestion, I should nag you every 48 hours ;-)
>>>>
>>>> Really, this should be in the next tag.
>>>
>>>This stuff is pretty fragile and whenever we changed it, something b=
roke
>>>for users. Why not simply add new options =C2=A0(--connmark etc). Th=
at would
>>>also be more consistent with the other extensions.
>>
>> Adding new options does not fix the real problem, and you cannot eas=
ily
>> ensure that no options will clash with another.
>> And what do you do when you use -m hashlimit --hashlimit-name abc -m
>> hashlimit --hashlimit-name def? You can't use new options here.
>
>I think this issue was discussed in this thread:
>http://marc.info/?l=3Dnetfilter-devel&m=3D121881908205975&w=3D2 . And =
the
>above command should be OK. Did you test it?

Well ok bad example; -m hashlimit twice works, as does your linked=20
example when replacing -m a and -m b with -m mac.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
