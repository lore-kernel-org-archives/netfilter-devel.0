From: Krzysztof Oledzki <ole@ans.pl>
Subject: Re: PATCH: "invalid SYNIN=" - a patch and a question
Date: Thu, 11 Oct 2007 15:52:59 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0710111551300.4674@bizon.gios.gov.pl>
References: <Pine.LNX.4.64.0709261414200.676@bizon.gios.gov.pl>
 <Pine.LNX.4.64.0710031420130.5307@bizon.gios.gov.pl>
 <Pine.LNX.4.64.0710102054120.13087@blackhole.kfki.hu> <470DA0D7.10803@trash.net>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-187430788-930351019-1192110779=:4674"
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bizon.gios.gov.pl ([212.244.124.8]:33968 "EHLO
	bizon.gios.gov.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758354AbXJKNxG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Oct 2007 09:53:06 -0400
In-Reply-To: <470DA0D7.10803@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---187430788-930351019-1192110779=:4674
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Thu, 11 Oct 2007, Patrick McHardy wrote:

> Jozsef Kadlecsik wrote:
>> With your description I could reproduce the bug and actually you were=20
>> completely right: the code above is incorrect. Somehow I was able to=20
>> misread RFC1122 and mixed the roles :-(:
>>
>>    When a connection is >>closed actively<<, it MUST linger in
>>    TIME-WAIT state for a time 2xMSL (Maximum Segment Lifetime).
>>    However, it MAY >>accept<< a new SYN from the remote TCP to
>>    reopen the connection directly from TIME-WAIT state, if it:
>>    [...]
>>=20
>> The fix is as follows: if the receiver initiated an active close, then t=
he=20
>> sender may reopen the connection - otherwise try to figure out if we hol=
d a=20
>> dead connection.
>>=20
>> Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
>
>
> Applied, thanks Jozsef. I'll push this to -stable once it hits upstream.
>

It would be nice to have this fixed in both 2.6.22-stable and=20
2.6.23-stable if that is possible. Thank you.

Best regards,

 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-930351019-1192110779=:4674--
