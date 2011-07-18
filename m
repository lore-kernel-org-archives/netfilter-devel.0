From: Ed W <lists@wildgooses.com>
Subject: Re: NAT66 : A first implementation
Date: Mon, 18 Jul 2011 09:38:51 +0100
Message-ID: <4E23F11B.7020804@wildgooses.com>
References: <alpine.LNX.2.01.1107141818500.10490@frira.zrqbmnf.qr> <4E1F1902.9020605@student.ulg.ac.be> <alpine.LNX.2.01.1107141915580.10781@frira.zrqbmnf.qr> <20110714.161717.1387261665409519132.davem@davemloft.net> <alpine.LNX.2.01.1107150151390.20658@frira.zrqbmnf.qr> <4E226E7D.6050800@ans.pl> <4E2360C9.20304@wildgooses.com> <4E23764A.1080404@ans.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: =?UTF-8?B?S3J6eXN6dG9mIE9sxJlkemtp?= <ole@ans.pl>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail1.nippynetworks.com ([91.220.24.129]:41873 "EHLO
	mail1.nippynetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752479Ab1GRIix convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 18 Jul 2011 04:38:53 -0400
In-Reply-To: <4E23764A.1080404@ans.pl>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 18/07/2011 00:54, Krzysztof Ol=C4=99dzki wrote:
>>> Also, how would you imagine readressing such network one day, when =
you
>>> decide to change your ISP?
>>
>> Aha.  This is a statement that you don't believe PI space will becom=
e
>> easier to access when requesting IPV6 space?
>=20
> IPv6 PI for everyone? Forget about it, we would shortly hit 1M or eve=
n
> 10M+ IPv6 prefixes and this way make BGP unreliable.

Agree entirely, but I think it's clear that were this an option then a
number of issues would disappear?

On a related note, plenty of people are pointing out that there are
enough IPv6 addresses to give every atom an entire IPV4 space. However,
the implementation of IPv6 appears to currently be to give out whacking
great blocks of space on the grounds that giving out small chunks would
lead to an unroutable situation..? Are we just heading for a repeat of
IPV4 exhaustion at some future point?

My understanding of IPv6 is way too limited at present, but it would
*appear* that IPV6 is really a kind of a 64bit address scheme (or
perhaps more like a 64-70bit), given that many of the standards assume
prefixes starting at /64 and getting shorter from there if you are a
larger user?  My ISP (IDNet) gives every customer a /48 for example...
It seems like DHCPv6 is needed to autoassign shorter prefixes than /64
(so I presume that /64 will be the shortest prefix given to soho users
for the time being?)

Seems absolutely baffling that we created a standard for this gigantic
address space and then we are scared to actually use it because it's
unroutable with today's hardware and so instead we hand it out in globs
large enough to make it only a tiny fraction of the size...

Ahh well

Ed W


--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
