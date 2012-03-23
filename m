From: Fr3DBr <fr3dbr@gmail.com>
Subject: Re: Netfilter Packet Reinjection
Date: Fri, 23 Mar 2012 20:09:13 -0300
Message-ID: <CAMpo4z0GcztvVUCDR7Ay97Z=LTB-=JFnV_dNtw4__u1YEKTeSQ@mail.gmail.com>
References: <CAMpo4z2HumFBL+xNWPKbJiUancfraKT2_+u=fqkzSOX-74t8jg@mail.gmail.com>
	<471DE477E2B1F549A58F3A14A27180BE014CC0@HQ-EX01.bytemobile.com>
	<CAMpo4z0gLyYa6xnZHYSz8Z4q98aan_uv_z73o4Wwc0UV=5m2Lg@mail.gmail.com>
	<471DE477E2B1F549A58F3A14A27180BE014CD8@HQ-EX01.bytemobile.com>
	<CAMpo4z2YMZDv1vAAevK1Q_k37nCPhZpuLAvErK5O8BN0mbaZgw@mail.gmail.com>
	<alpine.LNX.2.01.1203232355300.32477@frira.zrqbmnf.qr>
	<CAMpo4z1kGLWbfuoSnBx=_ECDWB15TxR1v50CwO+6+hjJQw72kg@mail.gmail.com>
	<alpine.LNX.2.01.1203240005020.4134@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jeff Haran <jharan@bytemobile.com>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:55935 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754453Ab2CWXJO convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 23 Mar 2012 19:09:14 -0400
Received: by ghrr11 with SMTP id r11so3189241ghr.19
        for <netfilter-devel@vger.kernel.org>; Fri, 23 Mar 2012 16:09:13 -0700 (PDT)
In-Reply-To: <alpine.LNX.2.01.1203240005020.4134@frira.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Yeah i was looking this, so i'll try through the NFHook and see what ha=
ppens...

As long i call it with the properly 'event' identifier, everything
should works i guess.

Em 23 de mar=E7o de 2012 20:06, Jan Engelhardt <jengelh@medozas.de> esc=
reveu:
> On Saturday 2012-03-24 00:04, Fr3DBr wrote:
>
>>Well, i have a hook to capure the packets right now... but after
>>storing then in other place, after some 'tests' i perform around then
>>i have to 're-create' part of the packet flow (like a proxy) and then
>>let the real packets from the source, flow locally or remotelly
>>through forwarding to its destinations.
>>
>>But i didn't understood well what i would do with NF_HOOK
>
> If you do read the function body of nf_reinject, you will see that it
> too will only call nf_iterate (which is the same that NF_HOOK eventua=
lly
> gets to do).
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
