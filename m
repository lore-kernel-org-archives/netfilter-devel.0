From: Krzysztof Oledzki <ole@ans.pl>
Subject: Re: [PATCH]  Accounting rework: ct_extend + 64bit counters
Date: Mon, 2 Jun 2008 20:05:18 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0806022004150.3333@bizon.gios.gov.pl>
References: <48442cd8.dD0hLVFRFjNruv6o%ole@ans.pl> <484430D8.10106@gmx.ch>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-187430788-2054460786-1212429918=:3333"
Cc: netfilter-devel@vger.kernel.org
To: Fabian Hugelshofer <hugelshofer2006@gmx.ch>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bizon.gios.gov.pl ([212.244.124.8]:54588 "EHLO
	bizon.gios.gov.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495AbYFBSFZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 2 Jun 2008 14:05:25 -0400
In-Reply-To: <484430D8.10106@gmx.ch>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---187430788-2054460786-1212429918=:3333
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Mon, 2 Jun 2008, Fabian Hugelshofer wrote:

> Krzysztof Oledzki wrote:
>> [NETFILTER] Accounting rework: ct_extend + 64bit counters
>>=20
>> Initially netfilter has had 64bit counters for conntrack-based accountin=
g,=20
>> but
>> it was changed in 2.6.14 to save memory. Unfortunately in-kernel 64bit=
=20
>> counters are
>> still required, for example for "connbytes" extension. However, 64bit=20
>> counters
>> waste a lot of memory and it was not possible to enable/disable it runti=
me.
> [...]
>> Patch against 2.6.26-rc4, it would be nice if it can be included
>> in 2.6.27.
>
> Just to notice: recently nf_ct_kill_acct() has been introduced which acco=
unts=20
> packets on abnormal connection termination. This function has to be chang=
ed=20
> as well.
>
> See:
> http://git.kernel.org/?p=3Dlinux/kernel/git/kaber/nf-next-2.6.git;a=3Dcom=
mit;h=3D8d38001bd4a51fd5571ca84a40a7cddeca1e472d
> and
> http://git.kernel.org/?p=3Dlinux/kernel/git/kaber/nf-next-2.6.git;a=3Dcom=
mit;h=3D0943b274f3fa89f7dd5d8d435d81e2e929e13c3a

Indeed. Thank you for pointing this out.

Best regards,

 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-2054460786-1212429918=:3333--
