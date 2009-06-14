From: Bart De Schuymer <bdschuym@pandora.be>
Subject: Re: Fwd: ebtables broken for kernel above 2.6.28
Date: Sun, 14 Jun 2009 18:54:38 +0200
Message-ID: <4A352B4E.4030607@pandora.be>
References: <17923cc80905280124t4ed6cf7m87f91e4444146697@mail.gmail.com>	 <4A1EB783.4090801@pandora.be>	 <17923cc80905282251s2ddc50a4n1a44a2b1e6b01cc5@mail.gmail.com> <1244994434.11823.4816.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, jengelh@medozas.de,
	sachin sanap <sachin.sanap.1gb@gmail.com>,
	buytenh@wantstofly.org
To: Peter Volkov <pva@gentoo.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from georges.telenet-ops.be ([195.130.137.68]:56056 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752379AbZFNQyo (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 14 Jun 2009 12:54:44 -0400
In-Reply-To: <1244994434.11823.4816.camel@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The sourceforge page is still the site to obtain the userspace tool.=20
Some unreleased code is in the cvs. Kernel changes seem to get in these=
=20
days without checking for compatibility with userspace.
Please fix things up in the kernel code. I sure hope that's possible. I=
=20
won't accept a patch to the userspace code that makes the application n=
o=20
longer work on older kernels.

cheers,
Bart

Peter Volkov schreef:
> Could anybody suggest correct fix for this problem? After reading ful=
l
> thread I'm unsure what to do... BTW, where ebtables (userspace)
> development now flows? Does it still uses the sourceforge's CVS serve=
r?
>
> Thanks,
> --
> Peter.
>
> =D0=92 =D0=9F=D1=82=D0=BD, 29/05/2009 =D0=B2 11:21 +0530, sachin sana=
p =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
>  =20
>> Iam facing problem with ebtables binay on 2.6.28 kernel (same binary
>> works well with 2.6.27). Its mostly a structure alignment issue with
>> standard targets like DROP,ACCEPT etc. Message seen by user is
>> "eb_tables: standard target: invalid size 8 !=3D 4"
>> Iam trying to fix it, this mail is just to check if its already fixe=
d
>> by someone else?
>>
>> Thanks
>> -Sachin
>>
>> ---------- Forwarded message ----------
>> From: Bart De Schuymer <bdschuym@pandora.be>
>> Date: Thu, May 28, 2009 at 9:40 PM
>> Subject: Re: ebtables broken for kernel above 2.6.28
>> To: sachin sanap <sachin.sanap.1gb@gmail.com>
>> Cc: nick@fedchik.org.ua, grzes@gnu.univ.gda.pl
>>
>>
>> You can ask around on netfilter-devel-owner@vger.kernel.org to see i=
f
>> it has been fixed.
>>
>> Regards,
>> Bart
>>    =20
> =09
>  =20

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
