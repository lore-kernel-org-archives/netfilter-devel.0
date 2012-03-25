From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Netfilter Packet Reinjection
Date: Sun, 25 Mar 2012 03:54:32 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1203250352030.7826@frira.zrqbmnf.qr>
References: <CAMpo4z2HumFBL+xNWPKbJiUancfraKT2_+u=fqkzSOX-74t8jg@mail.gmail.com> <471DE477E2B1F549A58F3A14A27180BE014CC0@HQ-EX01.bytemobile.com> <CAMpo4z0gLyYa6xnZHYSz8Z4q98aan_uv_z73o4Wwc0UV=5m2Lg@mail.gmail.com> <471DE477E2B1F549A58F3A14A27180BE014CD8@HQ-EX01.bytemobile.com>
 <CAMpo4z2YMZDv1vAAevK1Q_k37nCPhZpuLAvErK5O8BN0mbaZgw@mail.gmail.com> <alpine.LNX.2.01.1203232355300.32477@frira.zrqbmnf.qr> <CAMpo4z1kGLWbfuoSnBx=_ECDWB15TxR1v50CwO+6+hjJQw72kg@mail.gmail.com> <alpine.LNX.2.01.1203240005020.4134@frira.zrqbmnf.qr>
 <CAMpo4z0GcztvVUCDR7Ay97Z=LTB-=JFnV_dNtw4__u1YEKTeSQ@mail.gmail.com> <CAMpo4z0GRn7WD+4K+2EA1EbvKsvP+Ohu1i1PTSNkKHe0rBwiTA@mail.gmail.com> <20120324213104.GA30268@1984> <CAMpo4z1ZYOcs-jwoA6w88esUkrMpKhGSkfn3DmcSFOAR0dcnMA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jeff Haran <jharan@bytemobile.com>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Fr3DBr <fr3dbr@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:53980 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753564Ab2CYByg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 24 Mar 2012 21:54:36 -0400
In-Reply-To: <CAMpo4z1ZYOcs-jwoA6w88esUkrMpKhGSkfn3DmcSFOAR0dcnMA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sunday 2012-03-25 03:24, Fr3DBr wrote:

>> b) you reduce the amount of emails for every single issue that you
>> find while trying to learn how things. People may end up ignoring you
>> if you become too spamming. Making questions is fine, don't abuse.
>
>Btw, the problem was that i wasn't 'dereferencing' the point of skb,
>after i did it, it became stable and worked as intended, thanks for
>helping guys.

Since C does have type checking, that would mean you ignored a warning 
somewhere. Also note that since NF_HOOK does take struct sk_buff *, one 
might wonder just what you are doing with a raw struct sk_buff 
aggregate..

