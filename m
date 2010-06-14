From: Narendra Choyal <narendrachoyal@gmail.com>
Subject: Re: ip_conntrack fails to track Windows Vista TCP connection
Date: Tue, 15 Jun 2010 01:37:16 +0530
Message-ID: <AANLkTilcVU8BtrliadtrtJ1ad3GWMnFOqW5d77u68Shd@mail.gmail.com>
References: <0199E0D51A61344794750DC57738F58E70B258E2B3@GVW1118EXC.americas.hpqcorp.net>
	<4C165596.8020700@trash.net>
	<alpine.LSU.2.01.1006141834280.7212@obet.zrqbmnf.qr>
	<0199E0D51A61344794750DC57738F58E70B258E346@GVW1118EXC.americas.hpqcorp.net>
	<alpine.LSU.2.01.1006141941160.23197@obet.zrqbmnf.qr>
	<0199E0D51A61344794750DC57738F58E70B258E34D@GVW1118EXC.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Engelhardt <jengelh@medozas.de>,
	Patrick McHardy <kaber@trash.net>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: "Fischer, Anna" <anna.fischer@hp.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:50646 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754549Ab0FNUOV convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Jun 2010 16:14:21 -0400
Received: by yxl31 with SMTP id 31so1572577yxl.19
        for <netfilter-devel@vger.kernel.org>; Mon, 14 Jun 2010 13:14:20 -0700 (PDT)
In-Reply-To: <0199E0D51A61344794750DC57738F58E70B258E34D@GVW1118EXC.americas.hpqcorp.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

How can we make following changes as --
Nagle =3D off and TCPNODelay =3D 1

On Mon, Jun 14, 2010 at 11:39 PM, Fischer, Anna <anna.fischer@hp.com> w=
rote:
>> Subject: RE: ip_conntrack fails to track Windows Vista TCP connectio=
n
>>
>>
>> On Monday 2010-06-14 19:34, Fischer, Anna wrote:
>>
>> >>>> [something about Vista and TCP Delayed ACK]
>> >>>>
>> >>>> Is this a known issue?
>> >>>
>> >>> You're mentioning ip_conntrack, which is obsoleted for multiple
>> >>> years now. Which kernel version are you using?
>> >>
>> >> By definition of ip_conntrack, that must be older than 2.6.20.
>> >
>> >Yes, this is a 2.6.18 Xen kernel that I am using. Even if it is
>> obsolete, can you let me know if you are aware of such a problem eve=
r
>> having caused any issues? I just want to get a feeling if I am at le=
ast
>> roughly on the right track while figuring out what the problem is.
>>
>> The 2.6.18 has a known problem with DSACK even when both
>> endpoints are Linux.
>
> My problem is really very specific to connection tracking and so the =
problem (bug?) is probably in the ip_conntrack_tcp module. TCP communic=
ation actually works fine, also connection tracking on (slow, non-bulk =
data) TCP traffic works. However, it fails with high throughput connect=
ions coming from newer Windows (Vista / 7) machines. If I switch those =
to TCP_NODELAY then it all works again.
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-d=
evel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
