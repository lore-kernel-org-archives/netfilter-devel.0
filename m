From: =?ISO-8859-1?Q?Jorge_D=E1vila?= <jorgedavilalopez@gmail.com>
Subject: Re: Drop a packet while keeping the conntrack alive
Date: Wed, 20 Mar 2013 20:05:17 -0600
Message-ID: <CAG61UF_QMHAqr9Kx2g9R0S0K_p+WeSSAoECKQKSErsEKNL_d4g@mail.gmail.com>
References: <CACd4Q01yBxCJo8XcvY8+_HDqkuQG9Zz7=x6BGKdGCh7MA2oFHw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: =?ISO-8859-1?Q?Nicolas_Ma=EEtre?= <nimai@skynet.be>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f50.google.com ([74.125.82.50]:37370 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751755Ab3CUCFT convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 20 Mar 2013 22:05:19 -0400
Received: by mail-wg0-f50.google.com with SMTP id es5so1892255wgb.29
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Mar 2013 19:05:17 -0700 (PDT)
In-Reply-To: <CACd4Q01yBxCJo8XcvY8+_HDqkuQG9Zz7=x6BGKdGCh7MA2oFHw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi list,

An example about ...

With the current user space tools
there are ways for tracking INVALID connections.

INVALID connections, IMHO, should be "active" if you create a firewall
with stateless packet filtering and of course, setting the "needed"
values for the kernel parameters.

Jorge Isaac

2013/3/20, Nicolas Ma=EEtre <nimai@skynet.be>:
> Hi,
>
> I've developed a connection tracking module which I'd like to use for
> detecting packets that may be dropped with an iptables rule.
> That is, the connection tracker can detect that a packet is not  vali=
d
> in the context of the tracked connection. So, I'd like the
> administrator to be able to add a rule that would allow to drop/rejec=
t
> that packet.
> A possible use case is to block packets from an attacker (assumed as
> such as the packet is not conform considering the current state of th=
e
> connection).
>
> As far as I understand it, the connection tracker usually handle this
> by returning a negative/null value (-NF_ACCEPT, NF_DROP, ...) which
> marks the packet invalid, so that it is possible to use the
> xt_conntrack extension to match it.
>
> I've looked at the TCP connection tracker. If I understand well, the
> current behavior is that if we've got an INVALID packet, it kills the
> conntrack, then create it again if we see an ACK later on. Am I right=
?
>
> That is, it seems that by any way we invalidate a packet, it always
> destroy the conntrack so that we haven't the connection state at our
> disposal anymore. I would like to avoid that for the protocol I track=
=2E
> Is there a way to do so? Am I missing something?
>
>
>
> Thank you.
>
> --
> nimai
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-d=
evel"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


--=20
Jorge Isaac D=E1vila L=F3pez
---
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
