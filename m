From: Krzysztof Oledzki <ole@ans.pl>
Subject: Re: [NETFILTER 01/02]: nf_conntrack_tcp: fix connection reopening
 fix
Date: Thu, 18 Oct 2007 12:37:42 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0710181231210.17074@bizon.gios.gov.pl>
References: <20071018101159.28424.36079.sendpatchset@localhost.localdomain>
 <20071018101200.28424.26306.sendpatchset@localhost.localdomain>
 <Pine.LNX.4.64.0710181223310.17074@bizon.gios.gov.pl> <4717359E.9020208@trash.net>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-187430788-47216559-1192703862=:17074"
Cc: davem@davemloft.net, netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bizon.gios.gov.pl ([212.244.124.8]:51724 "EHLO
	bizon.gios.gov.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762181AbXJRKh4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 18 Oct 2007 06:37:56 -0400
In-Reply-To: <4717359E.9020208@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---187430788-47216559-1192703862=:17074
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Thu, 18 Oct 2007, Patrick McHardy wrote:

> Krzysztof Oledzki wrote:
>>=20
>>=20
>> On Thu, 18 Oct 2007, Patrick McHardy wrote:
>>=20
>>> [NETFILTER]: nf_conntrack_tcp: fix connection reopening fix
>>>=20
>>> Setting the last_dir parameter was missing from the previous one.
>>=20
>> This description is IMHO wrong. It should be as in previous, little=20
>> incomplete (last_dir), patch:
>>=20
>> "If one side aborts an established connection, the entry still lingers f=
or
>> 10s in conntrack for the late packets. Allow to open up the connection
>> again for the party which sent the RST packet."
>
>
> The first patch was submitted seperately with a somewhat similar
> description. This is just the incremental fix.

No, there are two independent fixes. The first one is already in the=20
mainline (nf_conntrack_tcp: fix connection reopening) and it is OK:
   http://git.kernel.org/?p=3Dlinux/kernel/git/torvalds/linux-2.6.git;a=3Dc=
ommitdiff;h=3D17311393f969090ab060540bd9dbe7dc885a76d5

The second one had been incomplete:
  http://marc.info/?l=3Dnetfilter-devel&m=3D119214261727254&w=3D1
and it was recently fixed:
  http://marc.info/?l=3Dnetfilter-devel&m=3D119264302103523&w=3D1

So, this "Setting the last_dir parameter was missing from the previous=20
one." comment applies to this patch:
  http://marc.info/?l=3Dnetfilter-devel&m=3D119214261727254&w=3D1

Best regards,

 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-47216559-1192703862=:17074--
