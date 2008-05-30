From: Krzysztof Oledzki <ole@ans.pl>
Subject: Re: iptables version defines
Date: Fri, 30 May 2008 11:41:12 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0805301140430.14733@bizon.gios.gov.pl>
References: <200805301016.03130.thomas.jarosch@intra2net.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-187430788-974735841-1212140472=:14733"
Cc: netfilter-devel@vger.kernel.org
To: Thomas Jarosch <thomas.jarosch@intra2net.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bizon.gios.gov.pl ([212.244.124.8]:33998 "EHLO
	bizon.gios.gov.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934AbYE3JlU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 30 May 2008 05:41:20 -0400
In-Reply-To: <200805301016.03130.thomas.jarosch@intra2net.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---187430788-974735841-1212140472=:14733
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Fri, 30 May 2008, Thomas Jarosch wrote:

> Hello netfilter coreteam,
>
> I'm currently looking for a way to support ipt_ACCOUNT
> both for iptables 1.4.0 and iptables 1.4.1. Some function
> names changed (addr_to_dotted() -> ipaddr_to_numeric())
> and it would be easy to #ifdef around them.
>
> The linux kernel provides multiple defines for its version number,
> while iptables only supports a char* version string.
>
> Would it make sense to add something like the kernel version defines
> so one could write code like this:
>
> #if IPTABLES_VERSION_CODE < IPTABLES_VERSION(1,4,1)
> =09abc
> #else
> =09xyz
> #endif

#ifdef _XTABLES_H
init(struct xt_entry_target *t)
#else
init(struct ipt_entry_target *t, unsigned int *nfcache)
#endif

Best regards,

 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-974735841-1212140472=:14733--
