From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Netfilter Packet Reinjection
Date: Sat, 24 Mar 2012 00:06:32 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1203240005020.4134@frira.zrqbmnf.qr>
References: <CAMpo4z2HumFBL+xNWPKbJiUancfraKT2_+u=fqkzSOX-74t8jg@mail.gmail.com> <471DE477E2B1F549A58F3A14A27180BE014CC0@HQ-EX01.bytemobile.com> <CAMpo4z0gLyYa6xnZHYSz8Z4q98aan_uv_z73o4Wwc0UV=5m2Lg@mail.gmail.com> <471DE477E2B1F549A58F3A14A27180BE014CD8@HQ-EX01.bytemobile.com>
 <CAMpo4z2YMZDv1vAAevK1Q_k37nCPhZpuLAvErK5O8BN0mbaZgw@mail.gmail.com> <alpine.LNX.2.01.1203232355300.32477@frira.zrqbmnf.qr> <CAMpo4z1kGLWbfuoSnBx=_ECDWB15TxR1v50CwO+6+hjJQw72kg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Jeff Haran <jharan@bytemobile.com>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Fr3DBr <fr3dbr@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:38255 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753114Ab2CWXGg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 23 Mar 2012 19:06:36 -0400
In-Reply-To: <CAMpo4z1kGLWbfuoSnBx=_ECDWB15TxR1v50CwO+6+hjJQw72kg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Saturday 2012-03-24 00:04, Fr3DBr wrote:

>Well, i have a hook to capure the packets right now... but after
>storing then in other place, after some 'tests' i perform around then
>i have to 're-create' part of the packet flow (like a proxy) and then
>let the real packets from the source, flow locally or remotelly
>through forwarding to its destinations.
>
>But i didn't understood well what i would do with NF_HOOK

If you do read the function body of nf_reinject, you will see that it 
too will only call nf_iterate (which is the same that NF_HOOK eventually 
gets to do).
