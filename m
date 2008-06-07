From: Krzysztof Oledzki <ole@ans.pl>
Subject: Re: [Bug 10875] Oops in nf_nat_setup_info
Date: Sat, 7 Jun 2008 17:34:11 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0806071729180.12357@bizon.gios.gov.pl>
References: <Pine.LNX.4.64.0806061931140.12641@bizon.gios.gov.pl>
 <Pine.LNX.4.64.0806070046360.12641@bizon.gios.gov.pl> <484A788C.3000205@trash.net>
 <484A798C.6000608@trash.net> <Pine.LNX.4.64.0806071540490.14796@bizon.gios.gov.pl>
 <484A9303.5030407@trash.net> <Pine.LNX.4.64.0806071656190.10202@bizon.gios.gov.pl>
 <484AA8E5.2040704@trash.net>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-187430788-1458066365-1212852851=:12357"
Cc: netfilter-devel@vger.kernel.org, bugme-daemon@bugzilla.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bizon.gios.gov.pl ([212.244.124.8]:48779 "EHLO
	bizon.gios.gov.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754954AbYFGPeu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 7 Jun 2008 11:34:50 -0400
In-Reply-To: <484AA8E5.2040704@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---187430788-1458066365-1212852851=:12357
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Sat, 7 Jun 2008, Patrick McHardy wrote:

> Krzysztof Oledzki wrote:
>>=20
>>=20
>> On Sat, 7 Jun 2008, Patrick McHardy wrote:
>>=20
>>> Krzysztof Oledzki wrote:
>>>> On Sat, 7 Jun 2008, Patrick McHardy wrote:
>>>>> In case its not, does that kernel include commit 86577c661?
>>>>=20
>>>> No, it does not but unfortunately this fix does not solve the crash.=
=20
>>>> However, before you spend too much time on this I'll check 2.6.25.6 an=
d=20
>>>> 2.6.26-rc to make sure this problem has not been solved already.
>>>=20
>>> Thanks, please let me know how it turns out.
>>=20
>> Clean 2.6.26-rc5 kernel, no additional patches at all.
>>=20
>> BUG: unable to handle kernel NULL pointer dereference at 00000032
>> IP: [<c03d930e>] nf_nat_setup_info+0x219/0x57f
>> *pde =3D 00000000 Oops: 0000 [#1] PREEMPT SMP
>
> How heavily is that system loaded (conntrack-wise)?

It is nearly 100% idle (backup). However, I'm able to trigger this bug=20
when I try to synchronize connections from an active firewall (it is still=
=20
running a heavily patched 2.6.22 kernel, btw).

Best regards,

 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-1458066365-1212852851=:12357--
