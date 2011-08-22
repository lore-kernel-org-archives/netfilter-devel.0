From: Dave Taht <dave.taht@gmail.com>
Subject: Re: [PATCH 1/6] libxt_u32: fix missing allowance for inversion
Date: Mon, 22 Aug 2011 09:31:37 -0700
Message-ID: <CAA93jw7sjY=QtBo=QDhG3Z3goHA1zAbVoD-JrqeuASQSzt2nwA@mail.gmail.com>
References: <1313868294-21471-1-git-send-email-jengelh@medozas.de>
	<1313868294-21471-2-git-send-email-jengelh@medozas.de>
	<CAA93jw6mpDL6rLXM+9SpAhafkDdKoSfhAxU8UM87vUqjuzjYJw@mail.gmail.com>
	<alpine.LNX.2.01.1108210917340.11614@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: kaber@trash.net, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:52241 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751048Ab1HVQbi convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 22 Aug 2011 12:31:38 -0400
Received: by ywf7 with SMTP id 7so3628433ywf.19
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Aug 2011 09:31:38 -0700 (PDT)
In-Reply-To: <alpine.LNX.2.01.1108210917340.11614@frira.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Aug 21, 2011 at 12:25 AM, Jan Engelhardt <jengelh@medozas.de> w=
rote:
>
> [oh, the mailing list daemon seems unresponsive for I have not
> received the 2nd copy, and neither did the web crawlers...]
>
>

No, I goofed and sent html, which it kicked back.

> On Saturday 2011-08-20 23:40, Dave Taht wrote:
>
> >I keep seeing inversion match fixes go by on this version of iptable=
s. I ran
> >across one also, on the port to cerowrt of this version of iptables,=
 in the
> >"dscp" tables matches.
> >
> >http://www.bufferbloat.net/issues/216#note-48
> >
> >but have not poked into it further (am travelling). Fixed?
>
> This is unfortunate indeed, but somewhat owed to the fact that this w=
as
> not encoded reliably previously, in other words, negations were
> sometimes erroneously allowed as each match checked for this themselv=
es.


>
> With the move to the Guided Option Parser, negation became centrally
> checked and thus needs to be explicit mentioned. With the initial
> conversion to GOP, I may have missed adding XTOPT_INVERT in some case=
s
> because of that repetitive action.

>
> Yeah, there are other extensions (xt_dccp) that I have come across in=
 my
> audit sweep of all extensions so far.

I saw the fixes to dccp go by today, but where I'd hit the problem was
with the 'dscp' matches. I have a test implementation of diffserv (
https://github.com/dtaht/Diffserv ) where a quick test against this
release of iptables showed the inversion regression as per the above
bug note...

regrettably I'm away from a build machine, internet, etc for a few more=
 days.


--
Dave T=E4ht
SKYPE: davetaht
US Tel: 1-239-829-5608
http://the-edge.blogspot.com
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
