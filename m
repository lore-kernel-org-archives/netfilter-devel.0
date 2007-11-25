From: Krzysztof Oledzki <ole@ans.pl>
Subject: Re: NF [PATCH 2/4] xt_TEE
Date: Sun, 25 Nov 2007 21:22:59 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0711252058430.13641@bizon.gios.gov.pl>
References: <Pine.LNX.4.64.0711252004220.9477@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0711252005460.9477@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0711252030520.13641@bizon.gios.gov.pl>
 <Pine.LNX.4.64.0711252054370.9477@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-187430788-1990150970-1196022179=:13641"
Cc: kaber@trash.net,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Sebastian Classen <sebastian.classen@freenet.de>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bizon.gios.gov.pl ([212.244.124.8]:47334 "EHLO
	bizon.gios.gov.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754185AbXKYU3X (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 25 Nov 2007 15:29:23 -0500
In-Reply-To: <Pine.LNX.4.64.0711252054370.9477@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---187430788-1990150970-1196022179=:13641
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Sun, 25 Nov 2007, Jan Engelhardt wrote:

>
> On Nov 25 2007 20:39, Krzysztof Oledzki wrote:
>> On Sun, 25 Nov 2007, Jan Engelhardt wrote:
>>> Netfilter: Import xt_TEE
>>>
>>>
>>> Originally from Sebastian Classen.
>>> xt_TEE is the logical successor to ipt_ROUTE; routing based on packet
>>> charactersitics is done using xt_MARK/iproute2/fwmark nowadays, so
>>> what remains of ipt_ROUTE is the --tee option, which xt_TEE implements.
>>
>> IMHO it is not successor as it does not provide all ipt_ROUTE functional=
ity. As
>> I appreciate your work and time spent on cleaning this code I think it w=
ould be
>> better not to strip it as xt_MARK/iproute2/fwmark is not always a valid =
option.
>
> We've been there -
> http://www.gossamer-threads.com/lists/engine?do=3Dpost_view_printable;pos=
t=3D68316;list=3Diptables

Exactly. But still, it is not a successor but rather a substitute with a=20
stripped functionality. I wish I haven't been so busy with other tasks=20
lately to do it myself, but I really think that a cleaned xt_ROUTE=20
extension is not going to bite. We can even add a config option to only=20
allow --tee by default, so no one will use --gw if xt_MARK/iproute2/fwmark=
=20
works for him.

Best regards,

 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-1990150970-1196022179=:13641--
