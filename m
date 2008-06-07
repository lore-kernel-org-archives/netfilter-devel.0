From: Krzysztof Oledzki <ole@ans.pl>
Subject: Re: [PATCH]  Accounting rework: ct_extend + 64bit counters (ver. 2)
Date: Sat, 7 Jun 2008 16:10:47 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0806071608200.14796@bizon.gios.gov.pl>
References: <48459c0c.4MdiVlMLZBmNAw6M%olel@ans.pl> <484916E2.3090200@trash.net>
 <Pine.LNX.4.64.0806061848340.12641@bizon.gios.gov.pl> <484A8DA6.1080808@trash.net>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-187430788-616161930-1212847847=:14796"
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bizon.gios.gov.pl ([212.244.124.8]:38903 "EHLO
	bizon.gios.gov.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752814AbYFGOKw (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 7 Jun 2008 10:10:52 -0400
In-Reply-To: <484A8DA6.1080808@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---187430788-616161930-1212847847=:14796
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Sat, 7 Jun 2008, Patrick McHardy wrote:
<CUT>

>>>>  struct hlist_head *nf_ct_alloc_hashtable(unsigned int *sizep, int=20
>>>> *vmalloced)
>>>> @@ -1165,6 +1174,10 @@ int __init nf_conntrack_init(void)
>>>>      if (ret < 0)
>>>>          goto out_fini_expect;
>>>>  +    ret =3D nf_conntrack_acct_init();
>>>> +    if (ret < 0)
>>>> +        goto out_fini_acct;
>>>> +
>>>>      /* For use by REJECT target */
>>>>      rcu_assign_pointer(ip_ct_attach, nf_conntrack_attach);
>>>>      rcu_assign_pointer(nf_ct_destroy, destroy_conntrack);
>>>> @@ -1177,6 +1190,7 @@ int __init nf_conntrack_init(void)
>>>>       return ret;
>>>>  +out_fini_acct:
>>>=20
>>> nf_conntrack_helper_fini(); ?
>>=20
>> Hm... "helper"? You mean "acct"?=20
>
> No, I mean helper. If acct initialization fails, the helper
> initialization was the last thing that succeeded and you need
> to properly clean it up again.

Ack.

Best regards,

 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-616161930-1212847847=:14796--
