From: Krzysztof Oledzki <ole@ans.pl>
Subject: Re: [Bug 10875] Oops in nf_nat_setup_info
Date: Sat, 7 Jun 2008 15:51:07 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0806071540490.14796@bizon.gios.gov.pl>
References: <Pine.LNX.4.64.0806061931140.12641@bizon.gios.gov.pl>
 <Pine.LNX.4.64.0806070046360.12641@bizon.gios.gov.pl> <484A788C.3000205@trash.net>
 <484A798C.6000608@trash.net>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-187430788-1525665593-1212846667=:14796"
Cc: netfilter-devel@vger.kernel.org, bugme-daemon@bugzilla.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bizon.gios.gov.pl ([212.244.124.8]:58030 "EHLO
	bizon.gios.gov.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753862AbYFGNvR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 7 Jun 2008 09:51:17 -0400
In-Reply-To: <484A798C.6000608@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---187430788-1525665593-1212846667=:14796
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Sat, 7 Jun 2008, Patrick McHardy wrote:

> Patrick McHardy wrote:
>> Krzysztof Oledzki wrote:
>>>=20
>>>=20
>>> On Fri, 6 Jun 2008, Krzysztof Oledzki wrote:
>>>=20
>>>> Hello,
>>>>=20
>>>> Today I have been plaing with the conntrackd utility and noticed it is=
=20
>>>> very easy to trigger a kernel oops just by:
>>>>=20
>>>> conntrackd -d
>>>> conntrackd -n
>>>> conntrackd -c
>>>> conntrackd -c
>>>=20
>>> OK, quite often is is enough to run only the first "conntrackd -c" to=
=20
>>> crash the kernel.=20
>>=20
>> Is that with or without your accounting patch?=20
>
> In case its not, does that kernel include commit 86577c661?

No, it does not but unfortunately this fix does not solve the crash.=20
However, before you spend too much time on this I'll check 2.6.25.6 and=20
2.6.26-rc to make sure this problem has not been solved already.

Best regards,

 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-1525665593-1212846667=:14796--
