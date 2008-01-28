From: Krzysztof Oledzki <ole@ans.pl>
Subject: Re: Bug with Fedora's 2.6.23.9-85 kernel (at least) and ESTABLISHED
 and SACK
Date: Mon, 28 Jan 2008 22:06:31 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801282203500.21384@bizon.gios.gov.pl>
References: <479D64B0.10101@acm.org>  <Pine.LNX.4.64.0801281434100.10533@bizon.gios.gov.pl>
 <1201539978.6526.7.camel@localhost>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-187430788-910104997-1201554391=:21384"
Cc: netfilter-devel@vger.kernel.org
To: Zan Lynx <zlynx@acm.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bizon.gios.gov.pl ([212.244.124.8]:60556 "EHLO
	bizon.gios.gov.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571AbYA1VGn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Jan 2008 16:06:43 -0500
In-Reply-To: <1201539978.6526.7.camel@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---187430788-910104997-1201554391=:21384
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Mon, 28 Jan 2008, Zan Lynx wrote:

>
> On Mon, 2008-01-28 at 14:38 +0100, Krzysztof Oledzki wrote:
>>
>> On Sun, 27 Jan 2008, Zan Lynx wrote:
>>
>>> Please CC me on any replies as I am not subscribed.
>>>
>>> I was downloading a new Google Earth when I noticed a LOT of max-size d=
ropped
>>> packets in my firewall log.  I only allow RELATED,ESTABLISHED sessions =
into
>>> my firewall.
>>>
>>> tcpdump showed that every time Google sent a packet to satisfy the miss=
ing
>>> data identified by SACK, that packet was rejected.  So it must have bee=
n
>>> missing the ESTABLISHED rule.
>>>
>>> I fixed the problem by adding an ALLOW source port 80 rule for the Goog=
le
>>> download site IP.
>>>
>>> This makes me wonder how often this has happened and I haven't noticed =
it.
>>> Is this a known bug or something new?
>>
>> Which kernel version?
>
> As in the Subject, Fedora's 2.6.23.9-85.

Right, sorry. I must have overlooked this.


>> Most likely there is a broken box along the path that mangles seq number=
s
>> but forgets about sacks. Could you please provide a dump:
>> "tcpdump -v -S host (...)"?
>
> I have not yet been able to reproduce it so I cannot provide a dump.
>
> I doubt that the sequence numbers were being mangled.  I doubt this
> because as soon as I added the rule to accept all port 80 packets from
> the server IP, the TCP session accepted the packet with the missing data
> and the hole described by the SACK options disappeared.  The session was
> sourced from the machine itself via a Squid proxy.

It is because most tcp stacks (including the one available in Linux) are=20
less restrictive than netfilter code and allow tcp packets with invalid=20
sacks but valid acks by ignoring sack data.


Best regards,

 =09=09=09Krzysztof Ol=EAdzki
---187430788-910104997-1201554391=:21384--
