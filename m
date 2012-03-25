From: Fr3DBr <fr3dbr@gmail.com>
Subject: Re: Netfilter Packet Reinjection
Date: Sat, 24 Mar 2012 22:24:07 -0300
Message-ID: <CAMpo4z1ZYOcs-jwoA6w88esUkrMpKhGSkfn3DmcSFOAR0dcnMA@mail.gmail.com>
References: <CAMpo4z2HumFBL+xNWPKbJiUancfraKT2_+u=fqkzSOX-74t8jg@mail.gmail.com>
	<471DE477E2B1F549A58F3A14A27180BE014CC0@HQ-EX01.bytemobile.com>
	<CAMpo4z0gLyYa6xnZHYSz8Z4q98aan_uv_z73o4Wwc0UV=5m2Lg@mail.gmail.com>
	<471DE477E2B1F549A58F3A14A27180BE014CD8@HQ-EX01.bytemobile.com>
	<CAMpo4z2YMZDv1vAAevK1Q_k37nCPhZpuLAvErK5O8BN0mbaZgw@mail.gmail.com>
	<alpine.LNX.2.01.1203232355300.32477@frira.zrqbmnf.qr>
	<CAMpo4z1kGLWbfuoSnBx=_ECDWB15TxR1v50CwO+6+hjJQw72kg@mail.gmail.com>
	<alpine.LNX.2.01.1203240005020.4134@frira.zrqbmnf.qr>
	<CAMpo4z0GcztvVUCDR7Ay97Z=LTB-=JFnV_dNtw4__u1YEKTeSQ@mail.gmail.com>
	<CAMpo4z0GRn7WD+4K+2EA1EbvKsvP+Ohu1i1PTSNkKHe0rBwiTA@mail.gmail.com>
	<20120324213104.GA30268@1984>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Jan Engelhardt <jengelh@medozas.de>,
	Jeff Haran <jharan@bytemobile.com>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47987 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753369Ab2CYBYI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 24 Mar 2012 21:24:08 -0400
Received: by pbcun15 with SMTP id un15so4139073pbc.19
        for <netfilter-devel@vger.kernel.org>; Sat, 24 Mar 2012 18:24:08 -0700 (PDT)
In-Reply-To: <20120324213104.GA30268@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> b) you reduce the amount of emails for every single issue that you
> find while trying to learn how things. People may end up ignoring you
> if you become too spamming. Making questions is fine, don't abuse.

Hey , i am not sending 100 e-mails per hour, just one or another :).

And yes i am researching stuff before asking, but this kind of stuff
mainly when you are not too familiar with the designed API is common,
maybe for you its not that uncommon since you are more used than me to
this stuff, but i understand your point.

Btw, the problem was that i wasn't 'dereferencing' the point of skb,
after i did it, it became stable and worked as intended, thanks for
helping guys.
