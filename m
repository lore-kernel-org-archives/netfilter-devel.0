From: Changli Gao <xiaosuo@gmail.com>
Subject: Re: [PATCH] libxtables: change option precedence order to be intuitive
Date: Fri, 29 Oct 2010 13:26:23 +0800
Message-ID: <AANLkTi=V1vzOxF84M-weryWgQdozzwiyZwFUBMnd9MTH@mail.gmail.com>
References: <1287501388-5948-1-git-send-email-jengelh@medozas.de>
 <1287501388-5948-2-git-send-email-jengelh@medozas.de> <alpine.LNX.2.01.1010252357270.18188@obet.zrqbmnf.qr>
 <4CC94854.8010306@trash.net> <alpine.LNX.2.01.1010281250120.2326@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:64175 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004Ab0J2F0q convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 29 Oct 2010 01:26:46 -0400
Received: by wwe15 with SMTP id 15so2868801wwe.1
        for <netfilter-devel@vger.kernel.org>; Thu, 28 Oct 2010 22:26:45 -0700 (PDT)
In-Reply-To: <alpine.LNX.2.01.1010281250120.2326@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Oct 28, 2010 at 6:54 PM, Jan Engelhardt <jengelh@medozas.de> wr=
ote:
> On Thursday 2010-10-28 11:54, Patrick McHardy wrote:
>
>>On 25.10.2010 23:57, Jan Engelhardt wrote:
>>> On Tuesday 2010-10-19 17:16, Jan Engelhardt wrote:
>>>
>>>> When using `-m mark --mark 2 -m connmark --mark 2`, the user curre=
ntly
>>>> gets an error about the (libxt_mark) --mark option being used twic=
e.
>>>> This is because libxt_connmark's option table does not override an=
y
>>>> previous options. This patch changes this behavior, since the curr=
ent
>>>> behavior does not allow connmark's option to be used at all, which=
 is
>>>> illogical.
>>>
>>> As per fw's suggestion, I should nag you every 48 hours ;-)
>>>
>>> Really, this should be in the next tag.
>>
>>This stuff is pretty fragile and whenever we changed it, something br=
oke
>>for users. Why not simply add new options =A0(--connmark etc). That w=
ould
>>also be more consistent with the other extensions.
>
> Adding new options does not fix the real problem, and you cannot easi=
ly
> ensure that no options will clash with another.
> And what do you do when you use -m hashlimit --hashlimit-name abc -m
> hashlimit --hashlimit-name def? You can't use new options here.
>

I think this issue was discussed in this thread:
http://marc.info/?l=3Dnetfilter-devel&m=3D121881908205975&w=3D2 . And t=
he
above command should be OK. Did you test it?

--=20
Regards,
Changli Gao(xiaosuo@gmail.com)
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
