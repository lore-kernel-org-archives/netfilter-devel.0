From: Krzysztof Oledzki <ole@ans.pl>
Subject: Re: [PATCH,RFC] Route match
Date: Thu, 3 Jul 2008 18:14:50 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0807031810210.4958@bizon.gios.gov.pl>
References: <20080703003942.GA2012@linuxace.com>
 <alpine.LNX.1.10.0807030913510.20393@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0807031140480.1816@blackhole.kfki.hu>
 <alpine.LNX.1.10.0807031317090.23294@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0807031749501.4958@bizon.gios.gov.pl>
 <alpine.LNX.1.10.0807031806310.23294@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-187430788-1735749197-1215101690=:4958"
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Phil Oester <kernel@linuxace.com>,
	netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bizon.gios.gov.pl ([212.244.124.8]:50409 "EHLO
	bizon.gios.gov.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752721AbYGCQP2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Jul 2008 12:15:28 -0400
In-Reply-To: <alpine.LNX.1.10.0807031806310.23294@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---187430788-1735749197-1215101690=:4958
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Thu, 3 Jul 2008, Jan Engelhardt wrote:

>
> On Thursday 2008-07-03 17:51, Krzysztof Oledzki wrote:
>>>
>>> You know what's been bugging me... why don't we replace the entire
>>> routing infrastructure by an xtables "route" table, with something like
>>
>> Because routing in a firewall is slow and too complicated?
>
> Proof?

Proof of what? Of a performance penalty?

http://people.netfilter.org/kadlec/nftest.pdf

# ip route show table all|wc -l
456292


Best regards,

 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-1735749197-1215101690=:4958--
