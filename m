From: Fr3DBr <fr3dbr@gmail.com>
Subject: Re: Netfilter Packet Reinjection
Date: Sat, 24 Mar 2012 22:57:02 -0300
Message-ID: <CAMpo4z3hmSYvOaWK0zd1WhMF=TvHc0QSge5xzmAMj35wJ_ib=Q@mail.gmail.com>
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
	<CAMpo4z1ZYOcs-jwoA6w88esUkrMpKhGSkfn3DmcSFOAR0dcnMA@mail.gmail.com>
	<alpine.LNX.2.01.1203250352030.7826@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jeff Haran <jharan@bytemobile.com>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50658 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752552Ab2CYB5D (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 24 Mar 2012 21:57:03 -0400
Received: by pbcun15 with SMTP id un15so4163529pbc.19
        for <netfilter-devel@vger.kernel.org>; Sat, 24 Mar 2012 18:57:02 -0700 (PDT)
In-Reply-To: <alpine.LNX.2.01.1203250352030.7826@frira.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> Since C does have type checking, that would mean you ignored a warning
> somewhere. Also note that since NF_HOOK does take struct sk_buff *, one
> might wonder just what you are doing with a raw struct sk_buff
> aggregate..

Yes this is correct, after fixing this it started working properly.

I am having fun with raw streams here =P.
