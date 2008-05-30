From: Krzysztof Oledzki <ole@ans.pl>
Subject: Re: iptables version defines
Date: Fri, 30 May 2008 12:05:07 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0805301204120.17471@bizon.gios.gov.pl>
References: <200805301016.03130.thomas.jarosch@intra2net.com>
 <Pine.LNX.4.64.0805301140430.14733@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-187430788-1001008650-1212141907=:17471"
Cc: netfilter-devel@vger.kernel.org
To: Thomas Jarosch <thomas.jarosch@intra2net.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bizon.gios.gov.pl ([212.244.124.8]:59887 "EHLO
	bizon.gios.gov.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752882AbYE3KF5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 30 May 2008 06:05:57 -0400
In-Reply-To: <Pine.LNX.4.64.0805301140430.14733@bizon.gios.gov.pl>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---187430788-1001008650-1212141907=:17471
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Fri, 30 May 2008, Krzysztof Oledzki wrote:

>
>
> On Fri, 30 May 2008, Thomas Jarosch wrote:
>
>> Hello netfilter coreteam,
>>=20
>> I'm currently looking for a way to support ipt_ACCOUNT
>> both for iptables 1.4.0 and iptables 1.4.1. Some function
>> names changed (addr_to_dotted() -> ipaddr_to_numeric())
>> and it would be easy to #ifdef around them.
>>=20
>> The linux kernel provides multiple defines for its version number,
>> while iptables only supports a char* version string.
>>=20
>> Would it make sense to add something like the kernel version defines
>> so one could write code like this:
>>=20
>> #if IPTABLES_VERSION_CODE < IPTABLES_VERSION(1,4,1)
>> =09abc
>> #else
>> =09xyz
>> #endif
>
> #ifdef _XTABLES_H
> init(struct xt_entry_target *t)
> #else
> init(struct ipt_entry_target *t, unsigned int *nfcache)
> #endif

Bzzz, sorry. Just noticed that you had asked about 1.4.0->1.4.1, not=20
1.3->1.4.

Best regards,

 =09=09=09Krzysztof Ol=EAdzki
---187430788-1001008650-1212141907=:17471--
