From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] mark newly opened fds as FD_CLOEXEC (close on exec)
 [part 2]
Date: Thu, 22 Mar 2012 12:21:20 +0100
Message-ID: <20120322112120.GA16645@1984>
References: <1332327120-22444-1-git-send-email-zenczykowski@gmail.com>
 <1332361663.9433.8.camel@edumazet-glaptop>
 <CANP3RGdUHYzLKaGR2APoWzbV2LSquujXoNdsTN-yYs8=bT=5kw@mail.gmail.com>
 <1332362670.9433.9.camel@edumazet-glaptop>
 <CAHo-OozsBkyQ-hq0Hkuef3uohemnHCh1qBo02By-kE5Rpt92Lg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Maciej =?utf-8?Q?=C5=BBenczykowski?= <zenczykowski@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60154 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751250Ab2CVLV0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 22 Mar 2012 07:21:26 -0400
Content-Disposition: inline
In-Reply-To: <CAHo-OozsBkyQ-hq0Hkuef3uohemnHCh1qBo02By-kE5Rpt92Lg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Maciej,

On Wed, Mar 21, 2012 at 01:50:59PM -0700, Maciej =C5=BBenczykowski wrot=
e:
> > True, but CLOEXEC on iptables... I mean... how is it mandatory ?
>=20
> I'm not sure what you mean by mandatory.

If this patch is needed, I think we have to stick to fcntl for
backward compatibility reasons as well.

> iptables does potentially fork/exec modprobe to load modules.
> That can cause a selinux 'domain'/'role'/whatever-it-is-called crossi=
ng.
> You can do automated inspection of what gets carried across such
> privilege changes and any unexpected open file descriptors flag
> problems, patches like this cut down on the noise.

Could you resend the patch including the description of the precise
problem that this fixes in selinux?

IMO, if the patch description would have include since the beginnging
why that CLOEXEC is needed, we would have save a couple of emails.

Thanks.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
