From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Netfilter Packet Reinjection
Date: Fri, 23 Mar 2012 23:55:54 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1203232355300.32477@frira.zrqbmnf.qr>
References: <CAMpo4z2HumFBL+xNWPKbJiUancfraKT2_+u=fqkzSOX-74t8jg@mail.gmail.com> <471DE477E2B1F549A58F3A14A27180BE014CC0@HQ-EX01.bytemobile.com> <CAMpo4z0gLyYa6xnZHYSz8Z4q98aan_uv_z73o4Wwc0UV=5m2Lg@mail.gmail.com> <471DE477E2B1F549A58F3A14A27180BE014CD8@HQ-EX01.bytemobile.com>
 <CAMpo4z2YMZDv1vAAevK1Q_k37nCPhZpuLAvErK5O8BN0mbaZgw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Jeff Haran <jharan@bytemobile.com>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Fr3DBr <fr3dbr@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:38154 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753773Ab2CWWz7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 23 Mar 2012 18:55:59 -0400
In-Reply-To: <CAMpo4z2YMZDv1vAAevK1Q_k37nCPhZpuLAvErK5O8BN0mbaZgw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Friday 2012-03-23 23:22, Fr3DBr wrote:

>Ok i get you.
>
>Could you tell me how one must instantiate the nf queue entry in order
>to use the nf_reinject method ?

You do not strictly need an nfqueue entry. Just calling one of the 
NF_HOOK macros is sufficient.
