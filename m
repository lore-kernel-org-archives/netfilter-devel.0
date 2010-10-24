From: Bart De Schuymer <bdschuym@pandora.be>
Subject: Re: [patch] arptables: some patches from debian
Date: Sun, 24 Oct 2010 19:10:47 +0200
Message-ID: <4CC46897.5030809@pandora.be>
References: <1284558534.22085.164.camel@tablet>	 <1286630249.3611.514.camel@tablet>  <4CB0BFE5.7070201@pandora.be> <1287070653.28231.11.camel@tablet>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: ebtables-devel@lists.sourceforge.net,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Peter Volkov <pva@gentoo.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from brigitte.telenet-ops.be ([195.130.137.66]:52228 "EHLO
	brigitte.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932203Ab0JXRKt (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 24 Oct 2010 13:10:49 -0400
In-Reply-To: <1287070653.28231.11.camel@tablet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Applied.

Thanks,

Bart

On 14-10-10 17:37, Peter Volkov wrote:
> Hi Bart. Thank you for review/applying patches. Could you also apply
> attached patch to fix not respecting LDFLAGS issue (very similar to o=
ne
> I've sent you long time ago for ebtables :) )
>
> --
> Peter.
>
> =D0=92 =D0=A1=D0=B1=D1=82, 09/10/2010 =D0=B2 21:17 +0200, Bart De Sch=
uymer =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
>> Hello Peter,
>>
>> Patch 2 and 3 are committed.
>> For the '*' part of patch 1 I'd rather remove the -v usage in=20
>> arptables-restore. This will require fixing the reason why -v is use=
d in=20
>> the first place. I wasn't aware this is due to a bug: the -i and -o=20
>> interfaces aren't printed unless -v is specified. I'll look into thi=
s.
>>
>> cheers,
>> Bart
>>
>> On 09-10-10 15:17, Peter Volkov wrote:
>>> Hi again. What is the best way to contact arptables developers? My
>>> previous patch was left without attention, should I resend it? In
>>> attachment there are three fixes from debian:
>>>
>>> 1. arptables_save patch makes arp_tables don't resolve host names a=
nd
>>> don't convert '*' interface names to any. Remove '*' interface name=
s.
>>> 2. manpage patch removes old version from man page
>>> 3. is a patch from Jeroen van Wolffelaar to make arptables --proto-=
type
>>> also accept hexadecimal inputs (ethernet protocol numbers are often
>>> specfied in hex, not decimal), using standard strtol() behaviour (h=
ex
>>> iff starts with 0x).


--=20
Bart De Schuymer
www.artinalgorithms.be

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
