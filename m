From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 3/8] [NETFILTER]: rename NF_ARP to NFPROTO_ARP and assign
 a non-clashing value
Date: Wed, 09 Apr 2008 15:42:08 +0200
Message-ID: <47FCC7B0.6080205@trash.net>
References: <5130e28c2130c57a9a07ae21c552fe7db519473c.1207668694.git.jengelh@computergmbh.de> <2a75525ff0d60f2e71df2c9c3d040d3a76451713.1207668694.git.jengelh@computergmbh.de> <47FCBC24.4020209@trash.net> <alpine.LNX.1.10.0804091508480.4411@fbirervta.pbzchgretzou.qr> <47FCC0D2.7060306@trash.net> <alpine.LNX.1.10.0804091514550.4411@fbirervta.pbzchgretzou.qr> <47FCC2F4.4030901@trash.net> <alpine.LNX.1.10.0804091533010.4411@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:46894 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752734AbYDINmL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Apr 2008 09:42:11 -0400
In-Reply-To: <alpine.LNX.1.10.0804091533010.4411@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Wednesday 2008-04-09 15:21, Patrick McHardy wrote:
>> The decoupling of netfilter supported protocols from AF values
>> makes sense.
>>
>> However I think _MAX definitions actually having the value MAX + 1
>> is pretty poor style. When you see an array dimensioned as
>> [XYZ_MAX] you always have to check whether it is really the maximum
>> (and thus a bug) or maximum + 1. So I'd prefer to have MAX really
>> be the maximum and use max + 1 for arrays etc.
>>
> In this case, I'd just follow AF_ suit.
> Especially since NAME_MAX=256, PATH_MAX=4096 for example,

Thats a bad example.

> _MAX is more often the total size rather than the last element.
> (The more even since loops use for (; x < MAX; )
> rather than for (; x<= MAX;) as can probably be seen
> in a lot of userspace code.)

Which is in my opinion a sign of poor coding and leads to
off-by-ones. Please don't redefine the meaning of maximum.

