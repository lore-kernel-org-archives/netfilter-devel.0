From: Mistick Levi <gmistick@gmail.com>
Subject: RE: iptables rule matching error
Date: Thu, 19 Aug 2010 22:21:08 +0300
Message-ID: <AANLkTimJVo1fY=qnzzm5vt6DLEnC9eY2MKedjLB9f4Jd@mail.gmail.com>
References: <AANLkTin-QPu+vaZaRy62J80qwVbz1XiazCvi9iYZ1tR3@mail.gmail.com>
 <alpine.LSU.2.01.1008162227430.5282@obet.zrqbmnf.qr> <AANLkTi=MwadVp=0Yx93QsMkz2f6=Fc6LsMCGnZ9CscFH@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:37183 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753176Ab0HSTV3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Aug 2010 15:21:29 -0400
Received: by ywe9 with SMTP id 9so240241ywe.19
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Aug 2010 12:21:28 -0700 (PDT)
In-Reply-To: <AANLkTi=MwadVp=0Yx93QsMkz2f6=Fc6LsMCGnZ9CscFH@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

comments anyone?


---------- Forwarded message ----------
From: Mistick Levi <gmistick@gmail.com>
Date: Tue, Aug 17, 2010 at 9:45 PM
Subject: Re: iptables rule matching error
To: Jan Engelhardt <jengelh@medozas.de>


Hi,
thanks for the quick reply.

Could you point a few links with more information? for example what
modules update internal state and why the evaluation order is
important?
and why does it matter which match evaluate first when the issue here
is with deletion of a rule... could you give a few examples?

Kind Regards
Yechiel Levi

On Mon, Aug 16, 2010 at 11:29 PM, Jan Engelhardt <jengelh@medozas.de> wrote:
>
> On Monday 2010-08-16 22:06, Mistick Levi wrote:
>>
>>I'm experiencing a problem with iptables...
>>I add a rule to a chain with a few matches, and afterwards when i want
>>to delete it, i must give it the exact order of matches i gave it
>>before, otherwise it says it cant find the rule.
>>
>>Anyone else know this error? And if it's not an error, but there for
>>performance, should'nt it be fixed?
>>I'd like that change to be my first patch to iptables... so if you
>>guys think the change is appropriate i'll get on it.
>>
>>Example:
>>iptables -A FORWARD -s 192.168.2.2 -d 192.168.3.3 -p udp ! --fragment
>>-m udp --dport 555 -m physdev --physdev-out eth0
>>iptables -D FORWARD -s 192.168.2.2 -d 192.168.3.3 -p udp ! --fragment
>>-m physdev --physdev-out eth0 -m udp --dport 555
>
> These are not the same two rules. One evaluates the UDP header first,
> the other evaluates the physdev interface first. Note that they are
> evaluated in short-circuit fashion much like C expressions. Order is
> important. This has implications for modules which update an internal
> state.
>
