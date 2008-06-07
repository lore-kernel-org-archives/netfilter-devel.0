From: Krzysztof Oledzki <ole@ans.pl>
Subject: Re: [Bug 10875] Oops in nf_nat_setup_info
Date: Sat, 7 Jun 2008 15:27:55 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0806071527340.14796@bizon.gios.gov.pl>
References: <Pine.LNX.4.64.0806061931140.12641@bizon.gios.gov.pl>
 <Pine.LNX.4.64.0806070046360.12641@bizon.gios.gov.pl> <484A788C.3000205@trash.net>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-187430788-60274406-1212845275=:14796"
Cc: netfilter-devel@vger.kernel.org, bugme-daemon@bugzilla.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bizon.gios.gov.pl ([212.244.124.8]:54049 "EHLO
	bizon.gios.gov.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756024AbYFGN2j (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 7 Jun 2008 09:28:39 -0400
In-Reply-To: <484A788C.3000205@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---187430788-60274406-1212845275=:14796
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Sat, 7 Jun 2008, Patrick McHardy wrote:

> Krzysztof Oledzki wrote:
>>=20
>>=20
>> On Fri, 6 Jun 2008, Krzysztof Oledzki wrote:
>>=20
>>> Hello,
>>>=20
>>> Today I have been plaing with the conntrackd utility and noticed it is=
=20
>>> very easy to trigger a kernel oops just by:
>>>=20
>>> conntrackd -d
>>> conntrackd -n
>>> conntrackd -c
>>> conntrackd -c
>>=20
>> OK, quite often is is enough to run only the first "conntrackd -c" to cr=
ash=20
>> the kernel.=20
>
> Is that with or without your accounting patch?

Without.

Best regards,

 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-60274406-1212845275=:14796--
