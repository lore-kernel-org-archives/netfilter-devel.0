From: Fr3DBr <fr3dbr@gmail.com>
Subject: Re: Netfilter Packet Reinjection
Date: Fri, 23 Mar 2012 20:04:36 -0300
Message-ID: <CAMpo4z1kGLWbfuoSnBx=_ECDWB15TxR1v50CwO+6+hjJQw72kg@mail.gmail.com>
References: <CAMpo4z2HumFBL+xNWPKbJiUancfraKT2_+u=fqkzSOX-74t8jg@mail.gmail.com>
	<471DE477E2B1F549A58F3A14A27180BE014CC0@HQ-EX01.bytemobile.com>
	<CAMpo4z0gLyYa6xnZHYSz8Z4q98aan_uv_z73o4Wwc0UV=5m2Lg@mail.gmail.com>
	<471DE477E2B1F549A58F3A14A27180BE014CD8@HQ-EX01.bytemobile.com>
	<CAMpo4z2YMZDv1vAAevK1Q_k37nCPhZpuLAvErK5O8BN0mbaZgw@mail.gmail.com>
	<alpine.LNX.2.01.1203232355300.32477@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jeff Haran <jharan@bytemobile.com>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:35014 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753114Ab2CWXEh convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 23 Mar 2012 19:04:37 -0400
Received: by iagz16 with SMTP id z16so5272903iag.19
        for <netfilter-devel@vger.kernel.org>; Fri, 23 Mar 2012 16:04:36 -0700 (PDT)
In-Reply-To: <alpine.LNX.2.01.1203232355300.32477@frira.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Well, i have a hook to capure the packets right now... but after
storing then in other place, after some 'tests' i perform around then
i have to 're-create' part of the packet flow (like a proxy) and then
let the real packets from the source, flow locally or remotelly
through forwarding to its destinations.

But i didn't understood well what i would do with NF_HOOK, by using a
NfHook i can also call methods inside netfilter core to perform such
tasks as 'reinjecting' a packet ?


(Disconsider last e-mail, it wasn't visible to the list)

Em 23 de mar=E7o de 2012 19:55, Jan Engelhardt <jengelh@medozas.de> esc=
reveu:
> On Friday 2012-03-23 23:22, Fr3DBr wrote:
>
>>Ok i get you.
>>
>>Could you tell me how one must instantiate the nf queue entry in orde=
r
>>to use the nf_reinject method ?
>
> You do not strictly need an nfqueue entry. Just calling one of the
> NF_HOOK macros is sufficient.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
