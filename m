From: Krzysztof Oledzki <ole@ans.pl>
Subject: Re: PATCH: "invalid SYNIN=" - a patch and a question
Date: Wed, 31 Oct 2007 20:34:27 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0710312030001.22683@bizon.gios.gov.pl>
References: <Pine.LNX.4.64.0709261414200.676@bizon.gios.gov.pl>
 <Pine.LNX.4.64.0710031420130.5307@bizon.gios.gov.pl>
 <Pine.LNX.4.64.0710102054120.13087@blackhole.kfki.hu> <470DA0D7.10803@trash.net>
 <Pine.LNX.4.64.0710111551300.4674@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-187430788-323043910-1193859267=:22683"
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, stable@kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bizon.gios.gov.pl ([212.244.124.8]:54049 "EHLO
	bizon.gios.gov.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753864AbXJaTew (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 31 Oct 2007 15:34:52 -0400
In-Reply-To: <Pine.LNX.4.64.0710111551300.4674@bizon.gios.gov.pl>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---187430788-323043910-1193859267=:22683
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Thu, 11 Oct 2007, Krzysztof Oledzki wrote:

>
>
> On Thu, 11 Oct 2007, Patrick McHardy wrote:
>
>> Jozsef Kadlecsik wrote:
>>> With your description I could reproduce the bug and actually you were=
=20
>>> completely right: the code above is incorrect. Somehow I was able to=20
>>> misread RFC1122 and mixed the roles :-(:
>>>
>>>    When a connection is >>closed actively<<, it MUST linger in
>>>    TIME-WAIT state for a time 2xMSL (Maximum Segment Lifetime).
>>>    However, it MAY >>accept<< a new SYN from the remote TCP to
>>>    reopen the connection directly from TIME-WAIT state, if it:
>>>    [...]
>>>=20
>>> The fix is as follows: if the receiver initiated an active close, then =
the=20
>>> sender may reopen the connection - otherwise try to figure out if we ho=
ld=20
>>> a dead connection.
>>>=20
>>> Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
>>=20
>>=20
>> Applied, thanks Jozsef. I'll push this to -stable once it hits upstream.
>>=20
>
> It would be nice to have this fixed in both 2.6.22-stable and 2.6.23-stab=
le=20
> if that is possible. Thank you.

It seems that this patch together with the additional fix did not get=20
pushed to -stable. Any chances to add those two patches to=20
2.6.22.11:

http://git.kernel.org/?p=3Dlinux/kernel/git/torvalds/linux-2.6.git;a=3Dcomm=
itdiff;h=3D17311393f969090ab060540bd9dbe7dc885a76d5
http://git.kernel.org/?p=3Dlinux/kernel/git/torvalds/linux-2.6.git;a=3Dcomm=
itdiff;h=3Dbc34b841556aad437baf4199744e55500bfa2088

?

Best regards,

 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-323043910-1193859267=:22683--
