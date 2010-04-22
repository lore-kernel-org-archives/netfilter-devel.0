From: James King <t.james.king@gmail.com>
Subject: Re: Recalculate checksums in netfilter queue
Date: Thu, 22 Apr 2010 12:37:22 -0700
Message-ID: <z2x38bcb3ec1004221237yde677868mfb3f87f11d9bb6f8@mail.gmail.com>
References: <l2z8363055a1004201802x47a250f3ya43e4bec4e79061c@mail.gmail.com>
	 <x2t3fdd6ce01004201902x33440642rd1189d2852aa57a@mail.gmail.com>
	 <z2o8363055a1004212015w2216df48s3074cdb2328c66db@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Justin Yaple <yaplej@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:40362 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756869Ab0DVThX convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:37:23 -0400
Received: by vws14 with SMTP id 14so130173vws.19
        for <netfilter-devel@vger.kernel.org>; Thu, 22 Apr 2010 12:37:22 -0700 (PDT)
In-Reply-To: <z2o8363055a1004212015w2216df48s3074cdb2328c66db@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Apr 21, 2010 at 8:15 PM, Justin Yaple <yaplej@gmail.com> wrote:
> If I get it figured out I will let you know. =A0Im kind of supprised
> that there isnt a function for this in libnetfilter_queue already. =A0=
It
> seems like it would be a pretty common requirement to recalculate the
> tcp, and ip checksums. =A0I have spent two days trying to get somethi=
ng
> to work without much luck.
>
> My understanding is that the one complement of each 16-bit word is
> summed, and then the result of that is bitwise complemented.
>
> So for each word we would do something like this.
> for each word{
> =A0 =A0 sum +=3D ~word;
> }
>
> then you would take the bitwise complement of that total.
> sum =3D ~sum;

=46or TCP, it's a bit more complicated, as you need to construct an IP
pseudo header first, calculate the checksum for the pseudo header +
segment containing a zeroed checksum field, and then finally insert
the checksum into the TCP header [1].  You also have to pad the
segment into an even number of octets before doing the calculation,
but not include this padding in the transmitted segment [2].  You may
also need to recalculate the IP checksum, depending on what fields
you're modifying.  The process is also slightly different for TCP over
IPv6.

I found a thread on this list from last year that contains some helper
functions extracted from tcpdump that may help you, titled "Re: Fwd:
Modifying TCP packets with libnetfilter_queue" [3].

If this works for you, perhaps a patch to include them in
libnetfilter_queue is in order.

[1] http://www.tcpipguide.com/free/t_TCPChecksumCalculationandtheTCPPse=
udoHeader-2.htm
[2] http://en.wikipedia.org/wiki/Transmission_Control_Protocol#TCP_chec=
ksum_for_IPv4
[3] http://markmail.org/message/auqvblfqenhy4hlz


HTH,
James
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
