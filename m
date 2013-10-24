From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: netfilter: xt_socket: add XT_SOCKET_NOWILDCARD flag causes
 behavioural change in userspace?
Date: Thu, 24 Oct 2013 03:15:06 -0700
Message-ID: <1382609706.7572.48.camel@edumazet-glaptop.roam.corp.google.com>
References: <52667EBC.5010709@ee.oulu.fi> <20131024095212.GA4422@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pekka =?ISO-8859-1?Q?Pietik=E4inen?= <pp@ee.oulu.fi>,
	edumazet@google.com, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:57018 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754441Ab3JXKPK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 24 Oct 2013 06:15:10 -0400
Received: by mail-wi0-f169.google.com with SMTP id cb5so9603445wib.2
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Oct 2013 03:15:09 -0700 (PDT)
In-Reply-To: <20131024095212.GA4422@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 2013-10-24 at 11:52 +0200, Pablo Neira Ayuso wrote:
> Hi Pekka,
>=20
> On Tue, Oct 22, 2013 at 04:33:48PM +0300, Pekka Pietik=C3=A4inen wrot=
e:
> > After a kernel update to 3.11 (feat. commit
> > 681f130f39e10087475383e6771b9366e26bab0c) my "generate fake tcp
> > connections from random ip addresses" app broke.
>=20
> Did you give a try to revert it and things were working back fine? I
> think the root cause for this behaviour change is not in that patch.

Yes, given that the option is off by default, I do not really understan=
d
the issue.

Its true that the option is currently a bit flawed, but my refactoring
of TCP listener should solve the problem soon. I do not feel necessary
to 'fix' xt_socket --nowildcard right now.

Oh, if the binary is too old, make sure commit
681f130f39e100 is there...
("netfilter: xt_socket: fix broken v0 support")

Thanks


--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
